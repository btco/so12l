-- PLAYER MODULE

-- enum of character classes
-- WARNING: if you change this, also change the ITAC_* flags in
-- items.lua, as these must match exactly.
-- Also, change the order of class names in the strings in XL.
-- Also, check PSHEET_Draw.
-- On second thought, don't change these at all. That's better.
#define CLS_FIGHTER 1
#define CLS_PALADIN 2
#define CLS_ARCHER 3
#define CLS_WIZARD 4

-- Initialized later (strings loaded from XL).
#id CLS_NAME

-- How much the attack score improves per level, for each class:
#id ATT_IMPROV
ATT_IMPROV={5,5,5,1}
-- How defense improves at each level, for each class:
#id DEF_IMPROV
DEF_IMPROV={2,2,1,1}
-- How much HP a character gains per level, for each class:
#id HP_IMPROV
HP_IMPROV={15,14,12,8}
-- How much speed a character gains per level, for each class:
#id SPEED_IMPROV
SPEED_IMPROV={4,5,6,3}
-- How many SP a character gains per level, for each class:
#id SP_IMPROV
SP_IMPROV={0,5,0,8}

-- Maximum level attainable
#define MAX_LEVEL 30

-- Width and height of character box.
#define CHAR_BOX_W 43
#define CHAR_BOX_H 25
#define CHAR_BOX_Y 111
-- Spacing between character boxes.
#define CHAR_BOX_STRIDE 47

-- Maximum XP a character can have. We store it in a DWORD (32 bits)
-- so the theoretical maximum is 4294967296 but for practical
-- reasons we cap it at 10M - 1
#define XP_MAX 9999999

-- Maximum gold party can have.
#define GOLD_MAX 999999999

-- Minimum # of ticks between two walk steps
#define MOVE_MIN_INTERVAL 15

-- TYPE: Character
--  name: name of the character
--  class: character's class
--  face: sprite ID of the character's face.
--  hp: current hitpoints
--  maxHp: maximum hitpoints.
--  att: base attack score.
--  def: base defense score
--  sp: current spell points.
--  maxSp: max spell points.
--  speed: speed score
--  rec: countdown to recovery (used in melee) -- deprecated?
--  eq: DICT of equipped items, keyed by item kind.
--    So, for example, eq[ITK_MWEAP] is the melee weapon that
--    the character has equipped.
--  zs: spells known by character
--    Array of spell IDs (ZID_*)

P=nil
PA=nil   -- shortcut for P.party, as that's used often.
-- Player initial state
P_INIT={
 -- Player's current tile.
 x=0,z=0,
 -- Player's current heading.
 dir=DIR_N,
 -- Gameplay clock: ticks elapsed since start of quest. A tick
 -- is counted every time the player moves or performs an action.
 pclk=0,
 -- Party (Character[])
 -- (loaded from XL at init time).
 party=nil,
 -- Inventory (array of ItemDef). Loaded from XL.
 inv={},
 -- Party gold. Loaded from XL.
 gold=0,
 -- Party XP.
 xp=0,
 -- Party level.
 level=1,
 -- Move cooldown time, in ticks.
 mcd=0,
}

function P_Reset()
 CLS_NAME=X_Strs(SYM_AClassNames)
 P=DeepCopy(P_INIT)
 -- Initialize player data from defaults in XL memory.
 P_Load(FALSE)
 PA=P.party
end

-- Called to update the player. This is only called when we are NOT
-- in melee, so this is strictly for non-melee updating.
function P_Update()
 -- Check if player wants to move.
 if CheckMove() then return end
 if Dbtnp(BTN_PRI) then
  -- Open the general menu.
  A_Enq(ActGeneralMenu)
 end
 -- Update camera to reflect where player currently is.
 UpdateCam()
end

function P_SetPos(x,z,dir)
 P.x,P.z,P.dir=x or P.x,z or P.z,dir or P.dir
 UpdateCam()
end

--[[
function P_DistSqToPlr(x,z)
 return (x-P.x)*(x-P.x)+(z-P.z)*(z-P.z)
end

function P_ManhDistToPlr(x,z)
 return abs(x-P.x)+abs(z-P.z)
end
]]

function P_RendParty()
 for i=1,#PA do
  local x,y=GetCharBoxXY(i)
  RendChar(i,PA[i],x,y)
 end
 -- Light meter.
 --_=P.light>0 and DrawMeter(188,64,320,42,C_YELLOW,C_BROWN,P.light/LIGHT_MAX)
 -- Experience.
 local eli=P_IsEligibleToLevelUp()
 spr(eli and 236 or 237,232,118)
 PrintN(P.xp,226,120,eli and C_WHITE or C_GREEN)
 -- Gold.
 spr(238,232,126)
 PrintN(P.gold,226,128,C_YELLOW)
end

-- Returns the computed attack and defense scores for a character.
function P_GetAttDef(ch)
 -- Apply modifiers from all the equipped items.
 local a,d,cu,itd,en=ch.att,ch.def
 for k,it in pairs(ch.eq) do
  if it then
   -- Get some item info:
   itd,cu=IT_LookUp(it.itid),it.st&ITSF_CURSED>0
   -- Cursed non-enchantable items apply their normal att/def score
   -- as a negative number (so a Ring of Defense that normally grants
   -- +3 defense will grant -3 defense if cursed).
   -- Enchantable items do NOT do this because we want the base
   -- att/def to always be positive, as it's the enchantment in this
   -- case that is negative for a cursed item.
   en=(cu and not IT_IsEnchantable(it.itid)) and -1 or 1
   -- Apply.
   d=d+(itd.def>0 and en*itd.def+IT_GetEnchant(it) or 0)
   a=a+(itd.att>0 and en*itd.att+IT_GetEnchant(it) or 0)
  end
 end
 return max(1,a),max(1,d)
end

function P_GetDef(ch) local _,d=P_GetAttDef(ch) return d end

function P_GetSpeed(ch)
 local s,r=ch.speed,ch.eq[ITK_RING]
 if r and r.itid==ITID_RING_OF_SPEED then
  s=s+(r.st&ITSF_CURSED>0 and -100 or 100)
 end
 return max(1,s)
end

-- Returns the BatAttackDef defining how the character performs
-- melee or ranged attacks.
--   ch: the character for which to get the attack def
--   ak: the type of attack (BAT_AK_*)
-- Returns the BatAttackDef, or nil if the given attack can't
-- be done by the character.
function P_GetBad(ch,ak)
 local w,bad,n,att
 -- What's the wielded/ranged weapon?
 w=ch.eq[ak==BAT_AK_MELEE and ITK_MWEAP or ITK_RWEAP]
 -- If no weapon weapon, no attack.
 if not w then return nil end
 -- w is now the weapon def, or false if no weapon equipped.
 w=w and IT_LookUp(w.itid)
 -- Get the character's attack score.
 att,_=P_GetAttDef(ch)
 -- Build the BatAttackDef describing the attack.
 bad={  -- (BatAttackDef)
   ak=ak,att=att,
   narr=ch.name..(ak==BAT_AK_MELEE and " attacks" or " fires"),
   psp=227,fl=0}  -- arrow sprite (ignored for melee)
 -- A non-archer firing a ranged weapon has a penalty.
 -- An archer attacking with a melee weapon has a penalty too.
 if ch.class~=CLS_ARCHER and ak==BAT_AK_RANGED or
    ch.class==CLS_ARCHER and ak==BAT_AK_MELEE then
  bad.att=max(1,bad.att//2)
 end
 return bad
end

-- Returns the count of particular ITID in the inventory.
-- Either itid or itk must be nil:
--  itid: ITID to count.
--- itk: item kind to count.
function P_GetItemCount(itid,itk)
 local r,it=0
 for _,it in ipairs(P.inv) do
  r=r+(itk and BoolToNum(IT_LookUp(it.itid).k==itk) or
    BoolToNum(it.itid==itid))
 end
 return r
end

-- Adds items to the inventory. If there is not enough space,
-- cheap items will be automatically overwritten.
--  its: array of items to receive
--  gp: gold to receive (nil if no gold)
function P_GiveItems(its,gp)
 -- Make room.
 while #P.inv+#its>INV_MAX do InvDiscardCheapest() end
 -- Insert the items into the list.
 for i=1,#its do
  ast(its[i].itid)
  insert(P.inv,its[i])
 end
 -- Notify the player about it.
 A_Enq(_ActInvAddNotif,{its=its,gp=gp})
end
function _ActInvAddNotif(st)
 local w,h=160,30+12*#st.its+(st.gp and 12 or 0)
 local x,y,iy=92-w//2,55-h//2
 Window(x,y,w,h,C_BLACK,"Received")
 prn(X_Str(SYM_SReceived),x+4,y+8,C_LGRAY)
 iy=y+22
 for i,it in ipairs(st.its) do
  local d,ic,n=IT_LookUp(it.itid),IT_GetDisplayInfo(it)
  spr(ic,x+4,iy)
  prn(n,x+14,iy+2)
  iy=iy+12
 end
 if st.gp then
  spr(238,x+4,iy)
  prn(st.gp.." gp",x+14,iy+2,C_YELLOW)
 end
 st.sfxd=st.sfxd or SFX_Play(SFX_RECEIVE) or 1
 if Dbtnp(BTN_PRI) then
  -- Credit gold.
  ChangeGold(st.gp or 0)
  return TRUE
 end
end

-- Adds gold.
--   gold: amount to give
--   s: if TRUE, don't show visual feedback
function P_GiveGold(gold,s)
 ChangeGold(gold)
 _=gold>0 and not s and
  P_BlinkChar(nil,C_YELLOW,"+"..gold.." gp",SFX_POWERUP)
 --P_GiveItems({},gold)
end

-- Grants a spell.
function P_LearnSpell(zid)
 ast(ZD[zid],"!Z "..zid)
 local cls=Z_IsWizardSpell(zid) and CLS_WIZARD or CLS_PALADIN
 -- Name of character who learned the spell.
 local n
 for i,c in ipairs(PA) do
  if c.class==cls and not ListFind(c.zs,zid) then
   n=c.name
   insert(c.zs,zid)
  end
 end
 if n then
  Alert({n..X_Str(SYM_SLearnedNewSpell),ZD[zid].n},
    C_YELLOW,C_PURPLE,SFX_RECEIVE)
 else
  Alert({X_Str(SYM_SAlreadyKnewSpell),ZD[zid].n},
    C_BGRAY,C_GRAY)
 end
end

-- Removes an item from the inventory. Returns TRUE if the item
-- was removed, FALSE if it was not found.
--   itid: the ITID to remove
--   idx: if not nil, this will be the preferred index to remove
--     (if it's the right ITID). Otherwise an arbitrary one will
--     be removed.
function P_RemoveItem(itid,idx)
 -- If a preferred index was passed, and it's the right ITID,
 -- remove that one.
 if idx and P.inv[idx].itid==itid then
  P_DiscardItem(P.inv[idx])
  return TRUE
 end
 -- Preferred index not passed, or not the right ITID, so remove
 -- the first occurrence.
 for i=1,#P.inv do
  if P.inv[i].itid==itid then
   P_DiscardItem(P.inv[i])
   return TRUE
  end
 end
 return FALSE
end

-- Returns TRUE if the given character is active (in conditions
-- to perform actions).
--   chi: The character index to check.
function P_IsCharActive(chi)
 return PA[chi].hp>0 and not CEF_Test(chi,CEF_MASK_INACTIVE)
end

-- Returns TRUE if the game is over (all characters are dead or
-- unable to act).
function P_IsGameOver()
 for i=1,#PA do
  if P_IsCharActive(i) then return FALSE end
 end
 return TRUE
end

-- Pops up a choice dialog asking which character will do a certain
-- action.
--   msg: the message to show.
--   cb: the callback to call when the choice is made.
--   udata: opaque object to pass to callback as second param.
--   fl: choice dialog flags (e.g. CHD_F_CANCELABLE)
--   wfl: who dialog flags (WHOD_*)
function P_AskWho(title,msg,cb,udata,fl,wfl)
 local c,en={},ArrOf(TRUE,#PA)
 wfl=wfl or 0
 for i=1,#PA do
  insert(c,PA[i].name)
  en[i]=P_IsCharActive(i) or (PA[i].hp>0 and wfl&WHOD_INACTIVE_ALIVE>0)
 end
 ChoiceDialog(msg,c,cb,nil,nil,udata,fl,en)
end
-- If specified, inactive (but not dead) characters will be included.
#define WHOD_INACTIVE_ALIVE 1

-- Returns a list of spell casters in the party.
-- (array of character indices). Also returns a parallel array of
-- names.
function P_GetCasters()
 local idxs,names={},{}
 for i=1,#PA do
  -- Does this character have spells?
  -- (it's better to test this rather than test classes, because
  -- a spell caster without any spells is, in practice, a non-caster).
  if #PA[i].zs>0 then
   insert(idxs,i)
   insert(names,PA[i].name)
  end
 end
 return idxs,names
end

-- Returns an array of spell names and casting costs for the
-- given character.
function P_GetSpellChoices(chi)
 local r={}
 for _,zid in pairs(PA[chi].zs) do
  local zd=ZD[zid]
  ast(zd)
  insert(r,zd.n .. " (" .. zd.sp .. " SP)")
 end
 return r
end

-- Makes the given character blink briefly, with a short
-- message on top.
--   chi: character index, nil to mean "all characters"
--   clr: color of the message
--   msg: the message to display
--   sfx: sfx to play
function P_BlinkChar(chi,clr,msg,sfx)
 A_Enq(_ActBlinkChar,{chi=chi,clr=clr,msg=msg,sfx=sfx},AF_MODAL)
end
function _ActBlinkChar(st,isf)
 if not isf then return end
 local chis=st.chi and {st.chi} or Seq(1,#PA)
 for _,chi in ipairs(chis) do
  local x,y=GetCharBoxXY(chi)
  if st.clk&8>0 then
   rectb(x,y,CHAR_BOX_W,CHAR_BOX_H,st.clr)
  end
  -- If an individual character got it, show the box on top
  -- of the corresponding character.
  if st.chi and st.msg then
   local oy=min(5,st.clk)
   DecoRect(x,y-15-oy,CHAR_BOX_W,20,st.clr,C_WHITE)
   PrintC(st.msg,x+CHAR_BOX_W//2,y-5-oy,C_BLACK)
  end
  if st.sfx then
   SFX_Play(st.sfx)
   st.sfx=nil
  end
 end
 -- If all characters got it, show a box in the middle.
 if not st.chi then
  #define CHAR_BOX_X_ALL 0
  #define CHAR_BOX_W_ALL 184
  #define CHAR_BOX_Y_ALL 93
  local oy=min(5,st.clk)
  DecoRect(CHAR_BOX_X_ALL,CHAR_BOX_Y_ALL-oy,CHAR_BOX_W_ALL,20,st.clr,C_WHITE)
  PrintC(st.msg,CHAR_BOX_X_ALL+CHAR_BOX_W_ALL//2,CHAR_BOX_Y_ALL-oy+10,C_BLACK)
 end
 return st.clk>70
end

-- Heals the given character, or increase SP.
-- REQUIREMENT: Either hp~=0 or sp~=0 (NOT both).
-- Can also hurt, if hp/sp is negative.
-- If chi is nil, applies to all.
function P_Heal(chi,hp,sp)
 hp,sp=hp or 0,sp or 0
 local p,c,msg=hp>0 or sp>0
 for i=1,#PA do
  if not chi or i==chi then
   c=PA[i]
   ast(c,"HC")
   -- Note: max(c.hp,c.maxHp) is to account for the case where
   -- hp>maxHp which might be the case in special circumstances.
   c.hp=Clamp(c.hp+hp,0,max(c.hp,c.maxHp))
   c.sp=Clamp(c.sp+sp,0,c.maxSp)
  end
 end
 msg=(p and "+" or "")..(hp~=0 and hp or sp)..(hp~=0 and "hp" or "sp")
 if hp>200 then msg="Heal" end
 P_BlinkChar(chi, -- if chi is nil, this works too.
   p and C_BBLUE or C_RED,msg,
   p and SFX_POWERUP or SFX_HURT)
end

-- Gives the given # of XP to the party.
--   xp: how many XP to give
--   shh: if TRUE, don't notify player (default FALSE).
function P_GiveXp(xp,shh)
 P.xp=min(P.xp+xp,XP_MAX)
 _=shh or P_BlinkChar(nil,C_LGREEN,
  "+"..(xp>9999 and ((xp//1000).."K") or xp).." xp",
  SFX_POWERUP)
end

-- Delete item from inventory (only works for inventory, not for
-- equipped items).
function P_DiscardItem(it)
 local itd=IT_LookUp(it.itid)
 ListRem(P.inv,it)
end

#define P_CI_OK 0
#define P_CI_NO_ITEMS 1
#define P_CI_CANCELED 2
-- Displays a dialog where the user is asked to pick an
-- item from the inventory.
-- Params:
--   title: title of the dialog
--   ks: array of item kinds to display. nil to show all.
--   rfl: required flags (e.g. ITF_MELEE_USE).
--   nmsg: message to show if there are no items.
--   sv: if TRUE, displays item value. Also, hide priceless items
--       (the ones that have no value set).
--   cb: callback to call when user chooses an item,
--       or cancels the dialog, or has no items available.
--       Args: it,result
--         it: the item, or nil if no items/canceled
--         result: P_CI_* indicating what happened
function P_ChooseItem(title,ks,rfl,nmsg,sv,cb)
 local its={}
 for _,it in ipairs(P.inv) do
  local itd=IT_LookUp(it.itid)
  -- If item is priceless and sv is TRUE, ignore it.
  -- If the item is of one of the requested kinds, and if
  -- it matches the requested flags (if any), then add it.
  if (not ks or ListFind(ks,itd.k)) and itd.f&rfl==rfl and
    -- If item is priceless (itd.v is nil) and sv is true, then
    -- ignore it:
    (itd.v or not sv) then
   insert(its,it)
  end
 end
 -- If there are no items, display the "no items" message.
 if #its==0 then
  Alert(nmsg,C_WHITE,C_BLUE,SFX_ERROR)
  cb(nil,P_CI_NO_ITEMS)
  return
 end
 -- Otherwise, start a modal action to show the item picker.
 A_Enq(_ActChooseItem,{its=its,sv=sv,cb=cb,title=title},AF_MODAL)
end
function _ActChooseItem(s)
 local x0,y0,w,h=48,10,114,105
 local gx0,gy0,ic,dn=x0+6,y0+6
 Window(x0,y0,w,h,C_BLACK,s.title)
 -- Render item grid.
 for i=1,#s.its do
  ic,dn=IT_GetDisplayInfo(s.its[i])
  local itid=s.its[i].itid
  local itd=IT_LookUp(itid)
  local c,r=(i-1)%10,(i-1)//10
  spr(ic,gx0+c*10,gy0+r*10)
 end
 s.sel=s.sel or 1
 -- Render the selection rect.
 local sc,sr=(s.sel-1)%10,(s.sel-1)//10
 _=G.clk&16>0 and rectb(gx0-1+sc*10,gy0-1+sr*10,10,10,C_YELLOW)
 -- Render name of selected item at the bottom.
 local it=s.its[s.sel]
 if it then
  local itd=IT_LookUp(it.itid)
  ic,dn=IT_GetDisplayInfo(it)
  PrintC(dn,x0+w//2,y0+90,C_YELLOW,1,TRUE)
  _=s.sv and PrintC(itd.v.." gp",x0+w//2,y0+98,C_BROWN,1,TRUE)
 end
 -- If the user pressed BTN_PRI, choose the item.
 if it and Dbtnp(BTN_PRI) then
  s.cb(it,P_CI_OK)
  return TRUE
 end
 -- If the user pressed BTN_SEC, cancel the choice.
 if Dbtnp(BTN_SEC) then
  s.cb(nil,P_CI_CANCELED)
  return TRUE
 end
 -- Move the selection according to arrow keys.
 local dx,dy=GetDpadP()
 sc,sr=Clamp(sc+dx,0,9),Clamp(sr+dy,0,7)
 s.sel=1+sc+sr*10
end

-- Save the player data to PMEM.
function P_SavePM()
 -- Signature byte for error-checking.
 PM_WriteB(187)
 PM_WriteB({P.x,P.z,P.dir,#PA})
 PM_WriteDW(P.pclk)
 -- Write characters.
 for _,c in ipairs(PA) do
  PM_WriteB(186)
  PM_WriteS(c.name)
  PM_WriteB({c.class,c.face,c.att,c.def,c.speed})
  PM_WriteW(c.hp)
  PM_WriteW(c.maxHp)
  PM_WriteW(c.sp)
  PM_WriteW(c.maxSp)
  for ek=1,ITK_EQ_KINDS do IT_WritePM(c.eq[ek]) end
  PM_WriteB(#c.zs)
  for i=1,#c.zs do PM_WriteB(c.zs[i]) end
 end
 -- Write inventory.
 PM_WriteB(#P.inv)
 for _,it in ipairs(P.inv) do
  IT_WritePM(it)
 end
 -- Write gold.
 PM_WriteDW(P.gold)
 -- Write XP
 PM_WriteDW(P.xp)
 -- Write level
 PM_WriteB(P.level)
end

-- Load player data from PMEM or from XL memory.
-- Arg:
--  pm: if TRUE, load from PM, else load from XL.
function P_Load(pm)
 _=pm and P_Reset()
 local fB,fW,fDW,fS,dbgl=
   pm and PM_ReadB or X_FetchB,
   pm and PM_ReadW or X_FetchW,
   pm and PM_ReadDW or X_FetchDW,
   pm and PM_ReadS or X_FetchString
 _=pm or X_SetPc(DBG_INIT_PARTY or SYM_InitialParty)
 -- Signature byte for error-checking.
 ast(fB()==187,"Bad PMEM plr.")
 P.x=fB()
 P.z=fB()
 P.dir=fB()
 local pc=fB()
 P.pclk=fDW()
 P.party={}
 PA=P.party
 -- Load characters.
 for i=1,pc do insert(PA,LoadChar(fB,fW,fDW,fS)) end
 -- Load inventory items.
 local ic=fB()
 P.inv={}
 for i=1,ic do insert(P.inv,IT_ReadPM(fB)) end
 -- Load other party data:
 P.gold=fDW()
 P.xp=fDW()
 P.level=fB()
 -- If we loaded from XL memory, level party up to match the XP,
 -- because that's how we store debug parties for game testing.
 while not pm and P_IsEligibleToLevelUp() do P_LevelUp(TRUE) end
end

function P_Save()
 S_Save()
 A_Enq(_ActSaveAnim) 
end
function _ActSaveAnim(st)
 cls(0)
 if st.clk<150 then
  _=st.clk&16<1 and PrintC(X_Str(SYM_SSaving),120,68,C_WHITE)
  PrintC(X_Str(SYM_SSaveWarning),120,126,C_GRAY)
 elseif st.clk<230 then
  _=st.clk==150 and SFX_Play(SFX_POWERUP)
  PrintC(X_Str(SYM_SGameSaved),120,68,C_LGREEN)
 else return 1 end
end

-- Evaluates the party for elegibility to level up.
-- Returns TRUE if eligible, FALSE if not.
function P_IsEligibleToLevelUp()
 return P.level<MAX_LEVEL and P.xp>=P_GetXpForLevel(P.level+1)
end

-- Levels the party up.
-- q: if TRUE, don't display anything.
function P_LevelUp(q)
 if P.level>=MAX_LEVEL then return end
 P.level=P.level+1
 for i,c in ipairs(PA) do LevelUpChar(c) end
 _=q or P_BlinkChar(nil,C_LGREEN,"Level Up!",SFX_POWERUP)
end

-- Adds a new character to the party.
--   ptr: pointer in XL memory where the character data is stored.
-- The character will be leveled up to match the party.
function P_AddChar(ptr)
 local old,c
 old=X_SetPc(ptr)
 c=LoadChar(X_FetchB,X_FetchW,X_FetchDW,X_FetchString)
 X_SetPc(old)
 -- Level up the new character to match the party.
 for i=2,P.level do LevelUpChar(c) end
 -- Insert into party.
 insert(PA,c)
end

function P_GetXpForLevel(l)
 return l>MAX_LEVEL and XP_MAX or
   1000*X_ReadW(SYM_XpTable+2*Clamp(l,1,MAX_LEVEL))
end

-- Calculates party's total wealth (net worth).
function P_CalcNetWorth()
 -- Start out with cash balance.
 local r,itd=P.gold
 -- Add the values of all inventory items.
 for _,it in ipairs(P.inv) do r=r+(IT_LookUp(it.itid).v or 0) end
 -- Add value of all equipped items.
 for _,ch in ipairs(PA) do
  for _,it in pairs(ch.eq) do
   if it then
    r=r+(IT_LookUp(it.itid).v or 0)
   end
  end
 end
 return r
end

-- Determines of character# chi is resistant to the given condition.
-- cm: condition mask, like CEF_POISON.
function P_IsResistantTo(chi,cm)
 local r=PA[chi].eq[ITK_RING]
 r=r and r.itid or 0
 return cm==CEF_FROZEN and r==ITID_RING_DEFROST or
  cm==CEF_ASLEEP and
    (CEF_Test(chi,CEF_ALERT) or r==ITID_RING_SLEEP_RES) or
  cm==CEF_POISON and r==ITID_RING_POISON_RES
end

-- Inflicts the given condition on the character, if they
-- are not resistant to it.
--  chi: The character, or 0 to mean all.
--  cm: condition mask, e.g., CEF_POISON
function P_Inflict(chi,cm)
 if chi<1 then
  for i=1,#PA do P_Inflict(i,cm) end
 elseif not P_IsResistantTo(chi,cm) then
  CEF_SetBit(chi,cm)
 end
end

--END OF API--------------------------------------------------------------
--------------------------------------------------------------------------

function GetCharBoxXY(chi)
 return (chi-1)*CHAR_BOX_STRIDE,CHAR_BOX_Y
end

-- Checks if the player wants to move, and moves if so.
function CheckMove()
 P.mcd=max(0,P.mcd-1)
 if btn(BTN_UP) then
  TryMove(1)
 elseif btn(BTN_DOWN) then
  TryMove(-1)
 elseif Dbtnp(BTN_RIGHT) then
  --R_SetCamYaw(P.dir*PI/2+PI/4)
  --A_Enq(_ActYawHalfStep)
  P.dir=(P.dir+1)%4
  UpdateCam() -- immediate update
 elseif Dbtnp(BTN_LEFT) then
  --R_SetCamYaw(P.dir*PI/2-PI/4)
  --A_Enq(_ActYawHalfStep)
  P.dir=P.dir>0 and P.dir-1 or 3
  UpdateCam() -- immediate update
 else return FALSE end
 return TRUE
end
--function _ActYawHalfStep(st)
-- _=st.clk>6 and UpdateCam()
-- return st.clk>12
--end

-- Determines if the player can enter the given tile.
function PlrCanEnterTile(c,r)
 if DBG_FAST then return TRUE end
 if L_IsTileSolid(c,r) then return FALSE end
 return TRUE
 -- Check with XL code
 --local ti,r=L_GetTile(c,r)
 --X_Call(SYM_PROC_CheckCanEnter,{ti.mc+256*ti.mr})
 --r=X_GetAllArgs()
 --return r>0
end

-- Tries to move.
--   di: 1 if forward, -1 if backward.
function TryMove(di)
 if P.mcd>0 then return end
 -- Check if the tile is walkable.
 local wdir=di>0 and P.dir or OppositeDir(P.dir)
 local tc,tr=ApplyDir(wdir,P.x,P.z)
 if not PlrCanEnterTile(tc,tr) then
  -- Call level interaction proc to notify that player has interacted
  -- with this tile (if the player is moving forward).
  _=di>0 and L_Interact(tc,tr)
  return
 end
 -- Move to destination.
 local hx,hz=(P.x+tc+1)*.5,(P.z+tr+1)*.5
 P.x,P.z=tc,tr
 -- Advance gameplay clock.
 P.pclk=P.pclk+1
 -- Update camera pos.
 UpdateCam()
 -- Call the XL walk procedure:
 local ti=L_GetTile(P.x,P.z)
 _=ti and A_Enq(function() X_Call(SYM_PROC_Walk,{ti.mc+256*ti.mr,wdir}) return TRUE end)
 SFX_Play(SFX_WALK)
 -- Do post-move bookkeeping
 PostMoveUpdate()
 -- Cooldown to next move.
 P.mcd=DBG_FAST and 3 or MOVE_MIN_INTERVAL
end

function PostMoveUpdate()
 -- Remove any conditions that characters are resistant to.
 for i=1,#PA do
  RemoveCondIfResistant(i,CEF_POISON)
  RemoveCondIfResistant(i,CEF_ASLEEP)
  RemoveCondIfResistant(i,CEF_FROZEN)
 end
end

function RemoveCondIfResistant(chi,cm)
 _=P_IsResistantTo(chi,cm) and CEF_ClearBit(chi,cm)
end

-- Updates the position of the camera based on the current position.
function UpdateCam()
 local x,z,yaw=P.x,P.z,P.dir*PI/2
 -- The camera should be at the middle of the tile.
 R_SetCamPos(x+0.5,0.5,z+0.5)
 R_SetCamYaw(yaw)
end

function RendChar(chi,c,x0,y0)
 --local mag=c.maxSp>0
 local active=P_IsCharActive(chi)
 rect(x0,y0,CHAR_BOX_W,CHAR_BOX_H,B_IsCharTurn(chi) and 2 or 0)
 spr(c.face,x0+3,y0+1,0)
 -- Name
 prn(c.name,x0+12,y0+3,active and C_WHITE or C_GRAY,PRN_MONOSPACE)
 -- Hitpoints
 spr(244,x0+4,y0+9,0)
 local f=c.hp/c.maxHp
 local fg,bg=G.clk&16>0 and C_RED or C_BLACK,C_PURPLE
 if c.hp<=0 then
  fg,bg=C_LGRAY,C_GRAY
 elseif c.hp>c.maxHp then
  fg,bg=C_LBLUE,C_LBLUE
 elseif c.hp==c.maxHp then
  fg,bg=C_LGREEN,C_GREEN
 elseif f>0.5 then
  fg,bg=C_YELLOW,C_BROWN
 elseif c.hp>10 and f>0.1 then
  fg,bg=C_ORANGE,C_BROWN
 end
 PrintN(c.hp,x0+20,y0+11,fg)
 DrawHBar(x0+3,y0+18,37,4,f,fg,bg) 
 -- Spell points.
 --spr(mag and 245 or 246,x0+24,y0+9,0)
 --PrintN(c.sp,x0+39,y0+11,mag and 15 or 3)
 --DrawHBar(x0+24,y0+18,19,4,mag and 0.5*c.sp/c.maxSp or 0,
 --  mag and 11 or 7,mag and 5 or 3) 
 if not active then
  Stipple(x0+1,y0+1,CHAR_BOX_W-2,CHAR_BOX_H-2,C_BLUE)
 end
 DecoRect(x0,y0,CHAR_BOX_W,CHAR_BOX_H)
end

-- Action that shows the general game menu.
-- st:
--  sel: current menu selection.
function ActGeneralMenu(st)
 st.sel=st.sel or 1
 st.sel=Menu("MENU",X_Strs(SYM_AGeneralMenu),
  200,70,C_WHITE,C_GREEN,st.sel)
 if Dbtnp(BTN_SEC) then return TRUE end
 if Dbtnp(BTN_PRI) then
  if st.sel==1 then
   -- Interact
   local tc,tr=ApplyDir(P.dir,P.x,P.z)
   if PlrCanEnterTile(tc,tr) then
    Alert(X_Strs(SYM_ANothingToInteract))
   else
    L_Interact(tc,tr)
   end
   return TRUE
  elseif st.sel==2 then
   if L.lvl.flags&LVLF_NO_ITEMS>0 then
    Alert(X_Strs(SYM_ANoItems))
    return TRUE
   else
    -- Show inventory window.
    I_Show()
    return TRUE
   end
  elseif st.sel==3 then
   -- Cast spell.
   Z_LaunchCast()
   return TRUE
  elseif st.sel==4 then
   -- Show party sheet.
   A_Enq(ActPartySheet,{i=1})
   return TRUE
  end
 end
 return FALSE
end

function ActPartySheet(st)
 st.i=Dbtnp(BTN_RIGHT) and WrapInc(st.i,#PA) or st.i
 st.i=Dbtnp(BTN_LEFT) and WrapDec(st.i,#PA) or st.i
 X_Call(SYM_PSHEET_Draw,{st.i})
 return Dbtnp(BTN_PRI) or Dbtnp(BTN_SEC)
end

-- Discards the cheapest item from inventory.
function InvDiscardCheapest()
 -- wi: winner index, wv: winner value
 local wi,lv=nil,nil
 for i=1,#P.inv do
  -- What is the value of this item?
  local v=IT_LookUp(P.inv[i].itid).v
  -- Is it cheaper than the previous winner?
  if v and (not wv or v<wv) then wi,wv=i,v end
 end
 -- If no item was found, it means the inventory is full of priceless
 -- items, which should not be possible.
 ast(wi,"Inv add err")
 P_DiscardItem(P.inv[wi])
end

-- Loads a character from PM or XL memory.
--   fB, fW, fDW, fS: functions to fetch byte, word, dword, string.
function LoadChar(fB,fW,fDW,fS)
 local c,sig={},fB()
 ast(sig==186,"!P_L"..sig)
 c.name=fS()
 c.class=fB()
 c.face=fB()
 c.att=fB()
 c.def=fB()
 c.speed=fB()
 c.hp=fW()
 c.maxHp=fW()
 c.sp=fW()
 c.maxSp=fW()
 c.eq=ArrOf(nil,ITK_EQ_KINDS)
 for ek=1,ITK_EQ_KINDS do c.eq[ek]=IT_ReadPM(fB) end
 local zc=fB()
 c.zs={}
 for j=1,zc do insert(c.zs,fB()) end
 return c
end

-- Levels up a given character.
--  c: the character
--  q: if TRUE, don't display anything.
function LevelUpChar(c,q)
 c.att,c.def,c.maxHp,c.maxSp,c.speed=
  min(255,c.att+ATT_IMPROV[c.class]),
  min(255,c.def+DEF_IMPROV[c.class]),
  min(255,c.maxHp+HP_IMPROV[c.class]+random(0,2)),
  min(255,c.maxSp+SP_IMPROV[c.class]),
  min(255,c.speed+SPEED_IMPROV[c.class]+random(0,1))
  c.hp,c.sp=c.maxHp,c.maxSp
end

function ChangeGold(d)
 P.gold=Clamp(P.gold+d,0,GOLD_MAX)
end

