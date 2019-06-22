-- SPELLS

-- Spell flags:
-- Spell can be used while in combat.
#define ZF_OK_BATTLE 1
-- Spell can be used while NOT in combat.
#define ZF_OK_NON_BATTLE 2

-- Spell IDs.
-- WARNING: If you change the spell ZIDs, also change:
--     * order of WANDs in items.lua
--     * order of SCROLLs in items.lua
--     * wand/scroll icons in cart
--     * list of scroll prices in wand.xl

-- Paladin spells (1-8):
#define ZID_HEAL 1
#define ZID_LIGHT 2
#define ZID_PROTECT 3
#define ZID_STUN 4
#define ZID_ACIDRES 5
#define ZID_AWAKEN 6
#define ZID_CURE_POISON 7
#define ZID_STRENGTHEN 8
#define ZID_LAST_PALADIN_SPELL 8
-- Wizard spells (9-16):
#define ZID_BURN 9
#define ZID_FORCE_BEAD 10
#define ZID_TEMPEST 11
#define ZID_LIGHTNING 12
#define ZID_PUSH 13
#define ZID_INVIS 14
#define ZID_IDENTIFY 15

-- Spell definitions.
ZD={}

#define XL_SPELL_HDR 204

-- Loads spells from spells database.
function Z_Init()
 local c=0
 X_SetPc(SYM_SpellsDb)
 while 1 do
  local h,z,zid=X_FetchB(),{}
  -- 0 means the end of the database
  if h==0 then break end
  -- Otherwise, it must be the signature.
  ast(h==XL_SPELL_HDR,"!ZDB/"..h)
  zid=X_FetchB()
  ZD[zid]=z
  -- Fetch spell name.
  z.n=X_FetchString()
  -- Fetch spell SP cost.
  z.sp=X_FetchB()
  -- Fetch address of spell procedure.
  z.proc=X_FetchW()
  -- Fetch flags.
  z.f=X_FetchB()
  c=c+1
  -- Create a wand and scroll items that cast this spell.
  GenWandOrScrollForSpell(zid,z,TRUE)
  GenWandOrScrollForSpell(zid,z,FALSE)
 end
 trace("ZDB "..c)
end

function Z_IsWizardSpell(zid) return zid>ZID_LAST_PALADIN_SPELL end

-- Asks the player which spell to cast, then casts it.
-- chi?: If not nil, then this is the character who is casting.
--   If nil, we will ask for which character will cast.
-- pccb?: post-cast callback. Will be called with TRUE or FALSE
--   indicating if the spell succeeded or failed.
function Z_LaunchCast(chi,pccb)
 if not chi then
  -- Ask which character will cast.
  local chis,names=P_GetCasters()
  -- If there are no spell casters, say so, and quit.
  if #chis<1 then
   Alert(X_Strs(SYM_ANoCasters))
   _=pccb and pccb(FALSE)
   return
  end
  ChoiceDialog(X_Str(SYM_SWhoWillCast),names,
    _ZLaunchCastWhoCb,C_WHITE,C_PURPLE,{chis=chis,pccb=pccb},
    CHD_F_CANCELABLE)
  return
 end
 -- Figure out what spells this character can cast.
 local zch=P_GetSpellChoices(chi)
 if #zch<1 then
  -- This character does not know any spells.
  Alert(PA[chi].name..X_Str(SYM_SKnowsNoSpells),
    C_WHITE,C_BLACK)
  _=pccb and pccb(FALSE)
  return
 end
 -- Ask which spell to cast.
 ChoiceDialog(X_Str(SYM_SChooseSpell)..
   PA[chi].sp.." SP left)",
   zch,_ZLaunchCastCb,C_WHITE,C_PURPLE,{chi=chi,pccb=pccb},
   CHD_F_CANCELABLE)
end
function _ZLaunchCastWhoCb(sel,d)
 if not sel then return end
 local chi=d.chis[sel]
 ast(chi)
 Z_LaunchCast(chi,d.pccb)
end
function _ZLaunchCastCb(idx,d)
 -- Character# d.chi will cast spell PA[d.chi].zs[idx].
 -- If idx is nil, then the casting was canceled.
 local r=FALSE
 if idx then
  local zid=PA[d.chi].zs[idx]
  -- Z_CastSpell will take care of calling the callback pccb
  if zid then r=Z_CastSpell(d.chi,zid,d.pccb) end
 else
  _=d.pccb and d.pccb(FALSE)
 end
end

function Z_LookUp(zid)
 local zd=ZD[zid]
 ast(zd,"!ZID "..zid)
 return zd
end

-- Casts a spell.
-- chi: Index of the character who is casting.
--      If this is 0, the spell is being cast by nobody
--      (could be the effect of an item, for instance).
--      In that case SP won't be deducted from anyone.
-- zid: ZID of the spell to cast.
-- cb: callback to call after spell is cast
-- Returns TRUE if spell was cast, FALSE if failed.
function Z_CastSpell(chi,zid,cb)
 local zd,c=Z_LookUp(zid),PA[chi]
 if c and c.sp<zd.sp then
  -- Not enough spell points.
  Alert(X_Strs(SYM_ANotEnoughSp),C_WHITE,C_PURPLE)
  _=cb and cb(FALSE)
  return
 end
 -- If ZF_OK_BATTLE is absent and we're in melee, can't cast.
 if B and zd.f&ZF_OK_BATTLE<1 then
  Alert(X_Strs(SYM_ASpellCannotBeCastInBattle))
   _=cb and cb(FALSE)
  return
 end
 -- If ZF_OK_NON_BATTLE is absent and we're not in melee, can't cast.
 if not B and zd.f&ZF_OK_NON_BATTLE<1 then
  Alert(X_Strs(SYM_ASpellMustBeCastInBattle))
  _=cb and cb(FALSE)
  return
 end
 -- Deduct spell points.
 if c then c.sp=c.sp-zd.sp end
 -- Cast.
 ast(zd.proc>0,"!ZPROC/"..zid)
 X_Call(zd.proc,{chi,zid},
   -- Convert return value (1 -> TRUE, 0 -> FALSE).
   function(r) _=cb and cb(r>0) end)
end

--END OF API--------------------------------------------------
--------------------------------------------------------------

-- Generates a wand or scroll corresponding to the spell ZID.
--   zid: the ZID to generate the wand/scroll for
--   z: the spell desk (redundant, but helps reduce code size)
--   w: if true, generate wand; if false, generate scroll
function GenWandOrScrollForSpell(zid,z,w)
 local v,itid=X_ReadBs(SYM_ScrollPrices)[zid],
   (w and ITID_WAND_FIRST_MINUS_1 or ITID_SCROLL_FIRST_MINUS_1)+zid
 assert(v,"GWFS"..zid)
 ITDB[itid]={
  n=(w and "Wand: " or "Scroll: ")..z.n.." ",
  sp=(w and 415 or 431)+zid,
  k=w and ITK_WAND or ITK_SCROLL,
  f=z.f&ZF_OK_BATTLE>0 and ITF_MELEE_USE or 0,
  -- Wands are 3x the value of the corresponding scroll.
  v=v>0 and (w and 3*v or v) or nil,
  ac=ITAC_ALL,
  att=0,
  def=0,
  desc={"Casts "..z.n},
  }
end

