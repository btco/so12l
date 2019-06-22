-- 2D BATTLE MODULE

-- # of cells on the battle board.
#define BAT_CELLS 6
-- Width of the battle board. Must be divisible by BAT_CELLS
#define BAT_BOARD_WIDTH 180
#define BAT_BOARD_HEIGHT 110
-- Width of an individual battle board cell.
-- Must be BAT_WIDTH/BAT_CELLS
#define BAT_CELL_WIDTH 30

-- Cell index in which player characters start.
#define BAT_CHAR_START_CELL 3
-- Cell index in which wizards start.
#define BAT_CHAR_START_CELL_WIZ 2
-- Cell index in which enemies start.
#define BAT_FOE_START_CELL 4

-- Memory bank# where battle graphics are
#define BAT_BANK_NO 6

-- Possible battle poses for a token.
#define BAT_PO_IDLE 0
#define BAT_PO_PRE 1
#define BAT_PO_ATTACK 2
#define BAT_PO_HURT 3
#define BAT_PO_DEAD 4
#define BAT_PO_FIRE 5
  -- Means firing a bow. Animation plays automatically.
#define BAT_PO_CAST 6
  -- Means casting a spell.
#define BAT_PO_THROW 7
  -- Means throwing an item

-- Attack kinds:
#define BAT_AK_MELEE 1
#define BAT_AK_RANGED 2
#define BAT_AK_AREA 3
  -- Targets a whole cell
-- Attack flags:
#define BAT_AF_SPELL 1
#define BAT_AF_THROW 2
#define BAT_AF_STUN 4
-- If set by XL code, this forces the attack to miss.
#define BAT_AF_FORCE_MISS 16
-- If set by XL code, this forces the attack to hit.
#define BAT_AF_FORCE_HIT 32
-- If set, target is pushed back as a result of this attack.
#define BAT_AF_PUSH 64
-- Conditions (CEF) that can be inflicted by the attack:
-- (this logic is handled by XL code).
#define BAT_AF_CEF_POISON 128
#define BAT_AF_CEF_ASLEEP 256
#define BAT_AF_CEF_FROZEN 512

-- Battle condition flags:
#define BAT_CO_STUNNED 1

-- Battle visual styles
#define BAT_VST_NONE 0
#define BAT_VST_GRASS 1
#define BAT_VST_CAVE 2
#define BAT_VST_TOWER 3
#define BAT_VST_DESERT 4
#define BAT_VST_WATER 5
#define BAT_VST_MARSHES 6
#define BAT_VST_SNOW 7
#define BAT_VST_AUT 8
#define BAT_VST_LAVA 9

-- TYPE:BatAttackDef
--   ak: the kind of attack (BAT_AK_*)
--   att: attack score to use
--   narr: narration string ("The giant rat bites") 
--   psp: projectile sprite, if BAT_AK_RANGED
--   fl: flags (BAT_AF_*)

B=nil
#id B_INIT
B_INIT={
 -- Array of cells on the battle board, left to right. Each cell
 -- can be occupied by party characters OR enemies, but not both.
 -- Or it can be empty.
 -- Each cell is an ARRAY of TOKENs.
 -- Each TOKEN contains:
 --  chi: character index, if it's a character, or nil if not.
 --  ch: same as PA[chi] (convenience reference)
 --  ent: entity, if it's an enemy, nil of not.
 --  cx,cy: position of CENTER of the token on the battle board
 --        (battle board coords, which start at the top left of the
 --        battle board).
 --  rx,ry: current RENDERED position of CENTER of token (for
 --         animations). If not animating this will coincide with cx,cy
 --  po: render pose. Can be one of the BAT_PO_* constants.
 --  pocs: pose clock start (value of G.clk when pose changed).
 --  sid: sprite ID that represents this token on the board.
 --  ssz: sprite size (1 = 8x8, 2 = 16x16, etc).
 --    For entities, 4 sprites are expected to appear sequentially
 --    starting at sid: idle1, idle2, attack_pre and attack.
 --  co: condition. This is one of the BAT_CO_* flags.
 c={},
 -- Turn order. Array. Each element is a reference to a TOKEN in
 -- one of the c arrays.
 ord={},
 -- Shortcut to B.ord[B.nx] -- owner of the current turn.
 t=nil,
 -- How many actions are left for the current turn owner.
 -- This is 1 for characters/foes that can perform one action per turn.
 tac=0,
 -- Whose turn it will be next. This is an index into ord.
 -- Initialized later.
 nx=nil,
 -- Quit flag. If true, combat will end after current modal actions end.
 q=FALSE,
 -- If true, we are waiting for the player to choose what to do.
 am=FALSE,
 -- If not nil, this is an externally requested attack (from a spell
 -- or item) that will be launched next.
 -- This is a BatAttackDef.
 rbad=nil,
 -- Background color
 bgc=0,
 -- Decorative sprite#
 dsp=0,
 -- Total XP value of the battle.
 xp=0,
 -- Total gold value of the battle.
 gp=0,
 -- Char index (chi) of last attacked character. Used to avoid
 -- attacking the same character several times in a row.
 ltchi=0,
 -- Is "surrender" an option?
 sur=FALSE
}

-- Launches battle.
--  foes: An array of enemy entities.
--  vst: visual style#
function B_Launch(foes,vst)
 B=DeepCopy(B_INIT)
 -- Create an array of each cell.
 for i=1,BAT_CELLS do insert(B.c,{}) end
 -- Insert each character into battle.
 for i=1,#PA do BatAddChar(i) end
 -- Insert each enemy into battle, 2 per cell.
 ast(#foes<7)
 for i,e in ipairs(foes) do
  BatAddEnt(e,BAT_FOE_START_CELL+(i-1)//2)
  B.xp,B.gp=B.xp+e.xp,B.gp+e.gp
 end
 -- Give the battle code a chance to modify battle rewards.
 X_Call(SYM_BatModRewards,{B.gp,B.xp})
 B.gp,B.xp=X_GetAllArgs()
 -- If DEBUG_NO_MELEE is enabled, just credit XP/GP without battle.
 if DBG_NO_MELEE then
  P_GiveXp(B.xp,TRUE) P_GiveGold(B.gp,TRUE)
  B=nil
  return
 end
 -- HACK: if this is the last battle (Alex vs friends), add
 -- the Surrender option.
 B.sur=(foes[1].eid==EID_LEON)
 -- Calculate initial layout.
 BatCalcLayout()
 -- Set the initial rx,ry (rendered positions) for the entrance anim.
 for i,t in ipairs(B.ord) do
  t.rx,t.ry=t.ch and t.cx-40 or t.cx+BAT_BOARD_WIDTH//2,t.cy
 end
 -- Sort the turn order according to speeds.
 table.sort(B.ord,_BatOrdSortFun)
 -- Advance turn to first turn.
 B.nx=#B.ord   -- will roll over to 1 on BatTurnAdvance()
 B.tac=0
 BatTurnAdvance()
 -- Enqueue the battle action. The battle action remains active
 -- during the course of the entire battle. All in-battle actions
 -- must be modal actions enqueued at the front of this one.
 A_Enq(BatActMain)
 -- Action that ends the battle, setting B to nil.
 A_Enq(function() B=nil return TRUE end)
 -- Enqueue (modally) a layout transition animation to animate
 -- the participants in.
 A_Enq(BatActLayoutAnim,{},AF_MODAL)
 -- Set the visual style parameters.
 B.bgc=X_ReadBs(SYM_BsBatBgColor)[vst] or 0
 -- The decorative sprite is just the visual style# (that's how it's
 -- laid out in the sprite memory).
 B.dsp=vst
 -- Start battle music.
 MU_Play(MUT_BATTLE)
 -- Let XL code know that a battle has started, in case there's
 -- anything housekeeping that it needs to do.
 X_Call(SYM_BatStarted,{})
end
function _BatOrdSortFun(a,b)
 return (a.ent and a.ent.speed or P_GetSpeed(a.ch) or 0)>
   (b.ent and b.ent.speed or P_GetSpeed(b.ch) or 0)
end

function B_Reset() B=nil end

-- Renders battle. NOTE: this assumes that bank BAT_BANK_NO is active
-- for both tiles/sprites.
function B_Render()
 cls(B.bgc)
 -- Draw decorative band of sprites.
 for x=0,VP_W+8,8 do spr(B.dsp,x,0) spr(B.dsp,x,VP_H-8) end
 -- Draw each token.
 for i,t in ipairs(B.ord) do
  local sid,ox=0,0
  -- If this is an enemy, use its palette map.
  _=t.ent and PalMapSet(t.ent.palm)
  -- Draw it according to its current pose:
  if t.po==BAT_PO_DEAD then
   -- Don't draw.
  elseif t.po==BAT_PO_IDLE then
   -- Alternate between two frames of idle animation.
   sid=t.sid+(G.clk&16>0 and t.ssz or 0)
   if t.ch then
    -- Replace sprite depending on character's condition
    if CEF_Test(t.chi,CEF_INVIS) then sid=379+t.chi end
    if CEF_Test(t.chi,CEF_ASLEEP) then sid=327+t.chi end
    if CEF_Test(t.chi,CEF_FROZEN) then sid=343+t.chi end
   end
  elseif t.po==BAT_PO_HURT then
   sid,ox=t.sid,t.ch and -2 or 2
   -- Set the palette map to map everything to yellow.
   PalMapSetUni(C_YELLOW)
  elseif t.po<=BAT_PO_ATTACK then
   -- Use pre or attack frame. This is an ugly hack because we
   -- know BAT_PO_PRE and BAT_PO_ATTACK are consecutive.
   sid=t.sid+(t.po-BAT_PO_PRE+2)*t.ssz
  elseif t.po==BAT_PO_FIRE then
   -- Firing (ranged attack pose).
   -- Animate from sid+{0,1,2,3} for entities.
   -- For characters, offset by 64 because that's where the ranged
   -- attack sprites are on the sprite sheet (hacky!)
   sid=t.sid+(min((G.clk-t.pocs)//10,3))*t.ssz+(t.ch and 64 or 0)
  elseif t.po==BAT_PO_CAST then
   -- Spell cast pose.
   -- Animate from sid+{0,1,2,3} for entities.
   -- For characters, offset by 4 because that's where the spellcast
   -- sprites are on the sprite sheet (hacky!)
   sid=t.sid+(min((G.clk-t.pocs)//10,3))*t.ssz-(t.ch and 4 or 0)
  elseif t.po==BAT_PO_THROW then sid=359+t.chi
  end
  -- If stunned, set the offset to make it go back and forth.
  if t.co&BAT_CO_STUNNED>0 then
   local os,f={0,1,2,1},1+(G.clk//8)%4
   ox=ox+os[f]
  end
  spr(sid,ox+t.rx-t.ssz*4,t.ry-t.ssz*4,0,1,0,0,t.ssz,t.ssz)
  -- Reset the palette map to default.
  PalMapSet()
  -- If it's a character and it's their turn, draw a box around token.
  _=B.am and B.t==t and t.ch and G.clk&16>0 and
    rectb(t.rx-7,t.ry-7,14,14,C_YELLOW)
  -- Render hit point bar.
  local o,fr
  o=t.ch or t.ent
  fr=o.hp/o.maxHp
  _=fr<1 and t.po~=BAT_PO_DEAD and
    DrawHBar(ox+t.rx-3,t.ry-t.ssz*4-2,6,1,fr,
      fr>.8 and C_LGREEN or fr>.2 and C_YELLOW or C_RED,
      fr>.8 and C_GREEN or fr>.2 and C_ORANGE or C_PURPLE)
 end
end

function B_IsCharTurn(chi) return B and B.t and B.t.chi==chi end

-- Request an attack. This can be called from a spell or item handler
-- while in melee to indicate that the current character (owner of
-- the turn) will perform a spell or item use that's equivalent to
-- the given attack.
--   bad: BatAttackDef defining the attack.
function B_ReqAttack(bad)
 -- Append turn owner's name to narration:
 bad.narr=B.t.ch.name.." "..bad.narr
 -- Store it as the "requested attack".
 B.rbad=bad
end

-- END OF API -----------------------------------------------------
-------------------------------------------------------------------

-- Main battle action function.
-- This is a Action that remains active for as long as the battle
-- lasts. Each time it runs (with isFg==true), it is the next
-- participant's turn to act (or maybe it's the same participant as
-- last time, if their action was cancelled and now they must
-- choose again, for instance).
function BatActMain(st,isFg)
 -- If the game is over, just end.
 if P_IsGameOver() then return TRUE end
 -- If we are not the foreground action, there's nothing to do
 -- (we're waiting on a menu or something).
 if not isFg then return end
 -- If the quit flag is on, end.
 if B.q then
  MU_Play(L.lvl.mus)
  -- Let XL code know that a battle has ended, in case there's
  -- anything housekeeping that it needs to do.
  X_Call(SYM_BatEnded,{B.q=="SUR" and 1 or 0})
  return TRUE
 end
 -- If the player won the battle, enqueue the victory action,
 -- then quit.
 if BatIsWon() then
  B.q=TRUE
  MU_Stop()
  A_Enq(BatActVictory,{},AF_MODAL)
 else
  -- B.t is the owner of this turn.
  if B.t.ch then BatHandleCharTurn(B.t) else BatHandleFoeTurn(B.t) end
 end
end

-- Advances to the next participant's turn.
function BatTurnAdvance()
 -- Remove dead tokens, in case there was one.
 BatRemDead()
 -- If the current turn owner still has actions left, it's still
 -- their turn.
 if B.tac>0 then
  B.tac=B.tac-1
  return
 end
 -- Remove BAT_CO_STUNNED condition from current turn owner.
 -- B.t might be nil if this is the first BatTurnAdvance.
 if B.t then B.t.co=B.t.co&~BAT_CO_STUNNED end
 -- Advance to the next turn.
 B.nx=WrapInc(B.nx,#B.ord)
 B.t=B.ord[B.nx]
 -- If it's a character, there's only one action per turn.
 -- Otherwise, the # of actions per turn is given by the ent def.
 -- (note that we already subtract one because we're about to take
 -- the turn).
 B.tac=B.t.ch and 0 or B.t.ent.nat-1
 ast(B.tac,"BTA")
end

--[[
function BatGetTokForChar(chi)
 for i=1,#B.ord do
  if B.ord[i].chi==chi then return B.ord[i] end
 end
 return nil
end
]]

-- Handle a character's turn.
--  t: the token representing the character.
function BatHandleCharTurn(t)
 -- Is the character active? (not unconscious, etc).
 if not P_IsCharActive(t.chi) then
  -- Skip turn.
  BatTurnAdvance()
  return
 end
 -- B.am is set to TRUE when we show the choice dialog and FALSE
 -- when we close it.
 B.am=TRUE
 -- Battle actions
 local as=X_Strs(SYM_ABatActions)
 -- Is "surrender" an option?
 if B.sur then as[7]="SURRENDER" end
 -- Ask what the character wants to do.
 ChoiceDialog(t.ch.name.."?",
   as,_BatCharActCb,C_WHITE,C_BLUE,t,CHD_F_CORNER)
end
function _BatCharActCb(m,t)
 B.am=FALSE
 -- Call the appropriate handler based on the choice.
 local f=BAT_ACTION_HANDLER[m] ast(f) f(m,t)
end

-- Callback that handles character movement.
-- m: the choice (5 = advance, 6 = retreat)
-- t: the character token
function BatCharHandleMove(m,t)
 -- Player wants to advance (m=1) or retreat (m=2).
 if BatTryMoveToken(t,m<6 and 1 or -1) then
  -- Successfully moved, layout animation enqueued, so end of turn.
  BatTurnAdvance()
  return
 end
 -- Failed to move. Alert user.
 Alert(X_Strs(
  m<1 and SYM_ABatMoveRetreatFail or SYM_ABatMoveAdvanceFail),
  C_WHITE,C_BLUE,SFX_ERROR)
 -- Don't advance turn (will try again).
 return
end

-- Callback that handles character ranged attack.
function BatCharHandleFire(m,t)
 local bad=P_GetBad(t.ch,BAT_AK_RANGED)
 -- Does the character have a ranged weapon equipped?
 if not bad then
  Alert(X_Strs(SYM_ANoRangedWeapon))
  return
 end
 -- Launch the flow.
 BatLaunchPlayerAttack(bad)
end

-- Callback that handles character melee attack.
function BatCharHandleAttack(m,t)
 local bad=P_GetBad(t.ch,BAT_AK_MELEE)
 -- Does the character have a ranged weapon equipped?
 if not bad then
  Alert(X_Strs(SYM_ANoMeleeWeapon))
  return
 end
 -- Launch the flow.
 BatLaunchPlayerAttack(bad)
end

-- Callback that handles character spell casting.
function BatCharHandleSpell(m,t)
 -- Launch spell casting flow.
 Z_LaunchCast(t.chi,_BatSpellCB)
end
function _BatSpellCB(r)
 -- r is true iff spell was cast.
 -- If spell was cancelled, do nothing (repeat turn).
 if not r then return end
 -- Ok, spell was cast. If it requested an attack, perform it.
 if B.rbad then
  local b
  b,B.rbad=B.rbad,nil
  BatLaunchPlayerAttack(b)
  -- attack flow will automatically advance turn.
 else
  -- Spell did not request an attack, so it was probably an 
  -- immediate effect spell like a heal. This means we have to 
  -- advance the turn explicitly.
  BatTurnAdvance()
 end
end

-- Callback that handles character item usage.
function BatCharHandleItem(m,t)
 P_ChooseItem(nil,nil,ITF_MELEE_USE,X_Strs(SYM_ABatNoItems),
   FALSE,_BatItemCb)
end
function _BatItemCb(it)
 if it then
  ast(B.t.chi)
  IT_Use(it,B.t.chi,_BatItemUseCb)
 end
end
function _BatItemUseCb(r)
 -- If item use failed (cancelled), do nothing (turn continues).
 if r<1 then return end
 -- If the item use proc requested an attack, carry it out.
 if B.rbad then
  local b
  b,B.rbad=B.rbad,nil
  -- BatTurnAdvance() will be called automatically.
  BatLaunchPlayerAttack(b)
 else
  -- No attack requested. Just advance the turn.
  BatTurnAdvance()
 end
end

function BatCharHandlePass()
 if B.sur then
  -- This battle has a Surrender option, so end the battle.
  B.q="SUR"
 else
  BatTurnAdvance()
 end
end

#id BAT_ACTION_HANDLER
-- Handlers must appear in the same order as in ABatActions list:
BAT_ACTION_HANDLER={
 BatCharHandleAttack,
 BatCharHandleFire,
 BatCharHandleSpell,
 BatCharHandleItem,
 BatCharHandleMove,
 BatCharHandleMove,
 BatCharHandlePass,
}

-- Handle an enemy's turn.
function BatHandleFoeTurn(t)
 local i,j,att
 if t.ent.bad.ak==BAT_AK_MELEE then
  BatHandleFoeMelee(t)
 else
  BatHandleFoeRanged(t)
 end
end

function BatHandleFoeMelee(t)
 -- If this enemy's attack is a melee attack, make it advance
 -- towards the player if possible.
 if BatTryMoveToken(t,-1) then
  -- That's it for this enemy.
  BatTurnAdvance()
  return
 end
 -- Attack a character in the adjacent cell, if there is one.
 i,j=BatFindToken(t)
 if i<2 or #B.c[i]<1 then
  -- Shouldn't happen, but...
  BatTurnAdvance()
  return
 end
 -- Figure out who to attack (pick a token on the cell to the left).
 i=i-1
 j=random(1,#B.c[i])
 local v=B.c[i][j]
 -- To help balance, if we pick the same character that was last
 -- attacked, roll again.
 -- Also, if the character is invisible, also roll again.
 if v.chi and (B.ltchi and v.chi==B.ltchi or CEF_Test(v.chi,CEF_INVIS)) then
  j=random(1,#B.c[i])
  v=B.c[i][j]
 end
 -- Is it also an enemy? If so, don't attack :-D
 if v.ent then
  BatTurnAdvance()
  return
 end
 -- Store character index of last attacked character to help
 -- distribute attacks on characters.
 B.ltchi=v.chi
 -- Do the attack. The victim is the token B.c[i][j].
 BatDoAttack(v,t.ent.bad)
 -- Turn will advance automatically after attack concludes.
end

function BatHandleFoeRanged(t)
 -- Pick random character token as our target.
 local i,j,off,cht
 j=random(1,#B.ord)
 for i=1,#B.ord do
  j=WrapInc(j,#B.ord)
  cht=cht or (B.ord[j].ch and B.ord[j])
 end
 if not cht then return end  -- Shouldn't happen...
 -- Do the attack. The victim is the token cht
 BatDoAttack(cht,t.ent.bad)
 -- Turn will advance automatically after attack concludes.
end

-- Finds a token in the battle cells.
-- Returns the index of the cell and the index within the cell.
function BatFindToken(t)
 ast(t)
 for i,c in ipairs(B.c) do
  local j=ListFind(B.c[i],t)
  if j then return i,j end
 end
 error("!TOK")
end

-- Tries to move the given token by the given dir (1 or -1).
-- Returns TRUE iff succcessful.
function BatTryMoveToken(t,dir)
 local i,j,tci
 -- Find the token.
 -- i is the cell index, j is its index in the cell.
 i,j=BatFindToken(t) 
 -- What cell is it trying to move to?
 tci=i+dir
 -- Is it valid?
 if tci<1 or tci>BAT_CELLS then return FALSE end
 -- Is it too crowded already?
 if #B.c[tci]>3 then return FALSE end
 -- If it's non-empty, its occupants must be of the same type as
 -- the token.
 if #B.c[tci]>0 and not BatTokensAreSameType(B.c[tci][1],t) then
  return FALSE end
 -- We're ok to move. Remove token from original list.
 remove(B.c[i],j)
 -- And add it to the destination list.
 insert(B.c[tci],t)
 -- Redo layout.
 BatCalcLayout()
 -- Enqueue a layout animation.
 A_Enq(BatActLayoutAnim,{},AF_MODAL)
 return TRUE
end

-- Layout animation action. Brings each entity's rx,ry to its cx,cy.
function BatActLayoutAnim(st)
 local r,d=TRUE,1
 d=DBG_FAST and 5 or 1
 for i,t in ipairs(B.ord) do
  t.rx,t.ry=ChangeXyTowards(t.rx,t.ry,t.cx,t.cy,d)
  r=r and DistSqXz(t.rx,t.ry,t.cx,t.cy)<1
 end
 return r
end

-- Inserts a character into battle. Does NOT assign x,y positions.
-- Assumes that BatCalcLayout() will be called later.
function BatAddChar(chi)
 local ch,tok=PA[chi]
 -- If character is dead, don't add.
 if ch.hp<1 then return end
 -- Note: 252+chi*16 is more compact than 268+(chi-1)*16
 tok={chi=chi,ch=ch,sid=252+chi*16,ssz=1,po=BAT_PO_IDLE,pocs=G.clk,co=0}
 -- Insert character token into the starting cell.
 insert(B.c[(ch.class==CLS_WIZARD or ch.class==CLS_ARCHER) and
   BAT_CHAR_START_CELL_WIZ or BAT_CHAR_START_CELL],tok)
 -- Insert character token into turn order.
 insert(B.ord,tok)
 -- Note: position variables will be set by BatCalcLayout(), which
 -- must be called later.
 return tok
end

-- Inserts an enemy into battle.
-- Assumes that BatCalcLayout() will be called later.
--   ci: cell index in which to insert the enemy.
function BatAddEnt(e,ci)
 ast(e and ci)
 local tok={ent=e,sid=e.sid,
   ssz=e.fl&ENTF_LARGE>0 and 2 or 1,
   po=BAT_PO_IDLE,pocs=G.clk,co=0}
 -- Insert enemy into the requested cell.
 insert(B.c[ci],tok)
 -- Insert enemy into turn order.
 insert(B.ord,tok)
 -- Note: position variables will be set by BatCalcLayout(), which
 -- must be called later.
end

-- Removes a token from battle.
function BatRemTok(t)
 -- Can't remove token whose turn it currently is.
 ast(t~=B.t,"BREM")
 local i,j=BatFindToken(t)
 ListRem(B.c[i],t)
 ListRem(B.ord,t)
 -- Fix B.nx so it still points to the right token, as indices
 -- have shifted.
 B.nx=ListFind(B.ord,B.t)
end

-- Recalculates the layout (positions) of tokens.
-- This only sets cx,cy (final) coordinates of each token, not the
-- rendered (rx,ry) coordinates. A layout animation pass must be done
-- to bring rx,ry to be equal to cx,cy.
function BatCalcLayout()
 -- For each cell:
 for i,c in ipairs(B.c) do
  -- Lay out tokens from top to bottom. We will center everything
  -- vertically later.
  local h=0
  for j,tk in ipairs(c) do
   -- Insert margin between tokens:
   h=h+(j>1 and 12 or 0)
   tk.cx=(i-1)*BAT_CELL_WIDTH+BAT_CELL_WIDTH//2
   tk.cy,h=h,h+tk.ssz*8
  end
  -- Now correct y positions to center everything vertically.
  for j,tk in ipairs(c) do
   tk.cy=tk.cy+(BAT_BOARD_HEIGHT-h)//2
  end
 end
end

-- Determines if the two given tokens are of the same type
-- (both are characters, or both are enemies).
function BatTokensAreSameType(t1,t2)
 return (t1.ch and t2.ch) or (t1.ent and t2.ent)
end

-- Starts the player attack flow. This will start by asking the player
-- to pick an enemy, then will proceed to calculate damage, do the
-- right animations, etc.
--   bad: the BatAttackDef defining the attack
function BatLaunchPlayerAttack(bad)
 -- Attack range:
 local ri,rf=1,1
 if bad.ak==BAT_AK_RANGED or bad.ak==BAT_AK_AREA then ri,rf=1,9 end
 -- Find the token that represents the player.
 local i,j=BatFindToken(B.t)
 -- Launch the flow to select the attack target.
 if not BatPickFoe(i+ri,i+rf,bad) then
  -- No enemies to attack.
  Alert(X_Strs(SYM_ABatNoFoesInRange))
  return
 end

 -- If we got here, then the foe pick flow has been launched, and
 -- at the end of it, it will carry out the attack, so we have
 -- nothing more to do.
end

-- Starts a modal action to pick a foe from a range of cells.
--  ci: initial cell index
--  cf: final cell index
--  bad: the BatAttackDef representing the attack to be carried out
-- If the cell range has no foes to pick, this will return FALSE.
-- If the flow was correctly launched, this will return TRUE.
function BatPickFoe(ci,cf,bad)
 -- cs will be the index of the leftmost column in the range
 -- that has foes in it.
 local cs
 ci,cf=Clamp(ci,1,BAT_CELLS),Clamp(cf,1,BAT_CELLS)
 for i=ci,cf do if BatColHasFoes(i) then cs=i break end end
 -- If none of the columns have foes, return.
 if not cs then return FALSE end
 -- Enqueue modal action to choose foe from cell range.
 A_Enq(_BatActPickFoe,{ci=ci,cf=cf,cs=cs,i=1,bad=bad},AF_MODAL)
 return TRUE
end
--  st.ci: index of the start cell
--  st.cf: index of the end cell
--  st.cs: currently selected cell
--  st.i: currently selected index within cell
--  st.bad: the BatAttackDef representing the attack to be made
function _BatActPickFoe(st)
 local c=B.c[st.cs]
 local t=c[st.i]
 if st.bad.ak==BAT_AK_AREA then
  -- Selection arrow points to a whole area.
  _=G.clk%16>4 and rectb(t.cx-BAT_CELL_WIDTH//2,5,
      BAT_CELL_WIDTH,BAT_BOARD_HEIGHT-10,C_YELLOW)
 else
  -- Selection arrow points to individual enemies.
  _=G.clk%16>4 and spr(248,t.rx-t.ssz*4-9,t.ry-4,0)
 end
 -- Move selection up/down the current column.
 st.i=Dbtnp(BTN_UP) and WrapDec(st.i,#c) or st.i
 st.i=Dbtnp(BTN_DOWN) and WrapInc(st.i,#c) or st.i
 if Dbtnp(BTN_LEFT) and st.cs>st.ci then
  -- Find first column to the left that's not empty.
  for i=st.cs-1,st.ci,-1 do if BatColHasFoes(i) then st.cs=i break end end
 elseif Dbtnp(BTN_RIGHT) and st.cs<st.cf then
  -- Find first column to the right that's not empty.
  for i=st.cs+1,st.cf do if BatColHasFoes(i) then st.cs=i break end end
 end
 -- Make sure the index is valid (in case we switched columns).
 st.i=min(st.i,#B.c[st.cs])
 -- If player cancelled, just end the action. This will replay
 -- the player's turn.
 if Dbtnp(BTN_SEC) then return TRUE end
 -- If player pressed BTN_PRI, launch the player attack action
 -- to carry out the player attack.
 if Dbtnp(BTN_PRI) then
  -- Do an attack: character (B.t) vs t.
  BatDoAttack(t,st.bad)
  return TRUE
 end
end

-- Checks whether the given column index has enemies in it.
function BatColHasFoes(ci)
 if ci<1 or ci>#B.c then return FALSE end
 for i,t in ipairs(B.c[ci]) do
  if t.ent then return TRUE end
 end
 return FALSE
end

-- Performs a melee or ranged attack against the given target token t.
--   t: the token that is the target of the attack.
--   bad: the BatAttackDef defining the attack.
function BatDoAttack(t,bad)
 local hit,d,def,dm,i,mad
 -- We will modify the BatAttackDef, so make a copy for safety.
 bad=DeepCopy(bad)
 -- If it's an area attack, skip the whole attack logic and
 -- go directly to the area attack procedure:
 if bad.ak==BAT_AK_AREA then
  -- What is the cell# of the target token? (this is the cell
  -- the attack targets).
  i,_=BatFindToken(t)
  A_Enq(BatActAreaAttack,{at=B.t,tc=i,bad=bad},AF_MODAL)
  return
 end
 def=t.ent and t.ent.def or P_GetDef(t.ch)
 ast(bad and def,"BDAd")
 -- Let XL code modify the attack to customize it, if it so wishes.
 X_Call(B.t.ch and SYM_BatModPlayerAttack or SYM_BatModFoeAttack,{
  -- Attacker (character index or EID) and target:
  B.t.chi or B.t.ent.eid,t.chi or t.ent.eid,
  -- Attack score, defense score, flags, attack type.
  bad.att,def,bad.fl,bad.ak})
 -- We trust the XL code to return the correct modified values for
 -- attack, damage, defense. We hope our trust is not misplaced!
 bad.att,def,bad.fl=X_GetAllArgs()
 -- Total possible damage is att - def. Never below 3.
 mad=max(3,bad.att-def)
 -- Net damage:
 d=DmgRand(mad)
 if t.ch then X_Call(SYM_BatModFoeNetDmg,{t.chi,d}) d=X_GetAllArgs() end
 d=t.ch and ceil((Interp(t.ch.maxHp//2,1,0,0.4,t.ch.hp))*d) or d
 -- Now let's see if this is a hit or a miss.
 -- BAT_AF_FORCE_HIT and BAT_AF_FORCE_MISS can be set to force hit/miss.
 -- Otherwise, a miss happens with 40% chance whenever dmg is 1.
 hit=bad.fl&BAT_AF_FORCE_HIT>0 or (bad.fl&BAT_AF_FORCE_MISS<1 and (
   -- If damage is 0, it's a miss.
   d>0 and
   -- If damage is 1, then 40% chance of missing.
   (d>1 or random(1,5)>2) and
   -- If stunned, 80% chance of missing.
   (B.t.co&BAT_CO_STUNNED<1 or random(1,5)<2)
 ))
 -- If this is a magic attack (BAT_AF_SPELL) and the target has
 -- magic resistance, apply that.
 if hit and bad.fl&BAT_AF_SPELL>0 and t.ent then
  hit=hit and random(0,100)>t.ent.mr
 end
 -- Enqueue action to animate, perform attack, and animate back.
 A_Enq(
  bad.ak==BAT_AK_MELEE and BatActMeleeAttack or BatActRangedAttack,
  {at=B.t,tt=t,dmg=hit and d,bad=bad},AF_MODAL)
end

-- Action that carries out a melee attack of one battle participant
-- against another. This takes care of animating, rendering the
-- damage splat, applying the damage, etc.
--   st.at: the token representing the attacker.
--   st.tt: the token representing the target.
--   st.dmg: the damage caused, or nil if attack missed.
--     This is the ACTUAL damage (already resolved).
--   st.bad: the BatAttackDef defining the attack.
function BatActMeleeAttack(st)
 local a,t,ax,ay,d,sgn,bad
 bad=st.bad
 -- d is how fast we move the character animations.
 d=DBG_FAST and 5 or 2
 -- st.p is the attack phase (0 = animating towards, 1 = attacking,
 -- 2 = returning).
 st.p=st.p or 0
 -- Aliases:
 a,t=st.at,st.tt
 -- sgn is 1 if attacker is to the right of target, -1 otherwise.
 -- This is used to compute displacements.
 sgn=a.cx>t.cx and 1 or -1
 -- Attacker's attack position:
 ax,ay=t.cx+sgn*4*(t.ssz+1),t.cy
 if st.p==0 then
  -- Animating attacker towards target.
  a.rx,a.ry=ChangeXyTowards(a.rx,a.ry,ax,ay,d)
  -- If arrived, move on to phase 1 (attack).
  if DistSqXz(a.rx,a.ry,ax,ay)<1 then
   st.p=1
   -- Enter "pre-attack" pose, unless this is a spell, in which
   -- case enter the spell pose.
   BatSetPose(a,bad.fl&BAT_AF_SPELL>0 and BAT_PO_CAST or BAT_PO_PRE)
  end
 elseif st.p==1 then
  -- Cycle counter for this state
  st.p1c=(st.p1c or 0)+(DBG_FAST and 5 or 1)
  -- Render damage indicator, if it was a hit.
  _=st.p1c>20 and st.p1c<40 and BatPrintDmgString(t,st.dmg,st.p1c//4,bad)
  if st.p1c==20 then
   SFX_Play(st.dmg and SFX_HIT or SFX_MISS)
   -- Apply damage to target. 
   BatApplyDmg(t,st.dmg,bad)
   -- Set to attack pose, unless it's a spell, in which case just
   -- leave it as-is (we're in the "firing" pose).
   _=bad.fl&BAT_AF_SPELL<1 and BatSetPose(a,BAT_PO_ATTACK)
   -- Set target's pose to hurt, if it was a hit.
   BatSetPose(t,st.dmg and BAT_PO_HURT or t.po)
  end
  -- If countdown expired, move on to next phase.
  st.p=st.p1c>50 and 2 or 1
  _=bad.narr and PrintC(bad.narr,92,96)
 else
  BatRestorePose(a,t)
  -- Returning attacker to normal position.
  a.rx,a.ry=ChangeXyTowards(a.rx,a.ry,a.cx,a.cy,d)
  -- If arrived, it's the end of action, and we have to advance to
  -- the next turn.
  if DistSqXz(a.rx,a.ry,a.cx,a.cy)<1 then
   BatTurnAdvance()
   return TRUE
  end
 end
end

-- Restores the pose of attacker and target tokens.
function BatRestorePose(a,t)
 -- Return attacker to idle pose
 BatSetPose(a,BAT_PO_IDLE)
 -- Put target in idle or dead pose, depending.
 BatSetPose(t,BatGetHp(t)>0 and BAT_PO_IDLE or BAT_PO_DEAD)
end

-- Applies the given amount of (net) damage to the participant
-- represented by the given token.
--   bad: the BattleAttackDef
function BatApplyDmg(t,dmg,bad)
 if not dmg then SFX_Play(SFX_MISS) return end
 SFX_Play(SFX_HIT)
 local o=t.ent or t.ch
 o.hp=max(0,o.hp-dmg)
 -- If the BattleAttackDef has the BAT_AF_STUN flag, also apply
 -- the stunned state to the recipient.
 if bad.fl&BAT_AF_STUN>0 then
  -- If the recipient is an inactive character, they don't get stunned.
  -- (so that a frozen or asleep character can't also be stunned).
  if not t.ch or P_IsCharActive(t.chi) then
   t.co=t.co|BAT_CO_STUNNED
  end
 end
 -- If BAT_AF_PUSH is set, also push recipient back if possible.
 if bad.fl&BAT_AF_PUSH>0 then
  BatTryMoveToken(t,t.ent and 1 or -1)
 end
 -- Apply any conditions, if the target is a player.
 if t.chi then
  MaybeInflictCond(bad.fl,BAT_AF_CEF_POISON,t.chi,CEF_POISON)
  MaybeInflictCond(bad.fl,BAT_AF_CEF_ASLEEP,t.chi,CEF_ASLEEP)
  MaybeInflictCond(bad.fl,BAT_AF_CEF_FROZEN,t.chi,CEF_FROZEN)
 end
end

-- if v&m>0, and if the given character is susceptible to the given
-- condition, then inflicts the given condition on the given
-- character.
function MaybeInflictCond(v,m,chi,cm)
 _=v&m>0 and P_Inflict(chi,cm)
end

-- Removes dead or incapacitated participants from battle.
function BatRemDead()
 -- Iterate backwards so we can remove.
 local d=FALSE
 for i=#B.ord,1,-1 do
  local t=B.ord[i]
  if BatGetHp(t)<1 then
   -- Dead. Remove.
   -- TODO: different sound for character vs enemy
   SFX_Play(SFX_KILL)
   -- Entity died. Remove from combat.
   BatRemTok(t)
   -- Mark that we did at least one deletion.
   d=TRUE
  end
 end
 if d then
  -- One or more tokens were removed.
  -- Recalculate layout and enqueue layout pass.
  BatCalcLayout()
  A_Enq(BatActLayoutAnim,{},AF_MODAL)
 end
end


-- Action that animates the combat victory.
function BatActVictory(st)
 B.q=TRUE
 PrintC("Victory!",VP_W//2,18,C_WHITE)
 _=st.clk==1 and SFX_Play(SFX_VICTORY)
 if st.clk==100 then P_GiveXp(B.xp) P_GiveGold(B.gp) end
 return st.clk>110
end

function BatIsWon()
 for i,t in ipairs(B.ord) do
  if t.ent then return FALSE end
 end
 return TRUE
end

function BatGetHp(t)
 return t.ch and t.ch.hp or t.ent.hp
end

-- Action that carries out a ranged attack of one battle participant
-- against another. This takes care of animating, rendering damage,
-- etc, etc.
--   st.at: the token representing the attacker
--   st.tt: the token representing the target
--   st.dmg: the damage caused, nil if missed
--     This is the ACTUAL damage (already resolved).
--   st.bad: the BatAttackDef defining the attack.
function BatActRangedAttack(st)
 local a,t,sgn,x0,y0,x1,y1,px,py,bad,d
 bad=st.bad
 -- Projectile frame count
 st.pfc=DBG_FAST and 5 or (st.pfc or 20)
 -- st.p is the attack phase.
 st.p=st.p or 0
 -- st.pc is the phase clock (resets at the start of every phase).
 st.pc=(st.pc or 0)+1
 -- Aliases to st.at and st.tt
 a,t=st.at,st.tt
 -- sgn is 1 if attacker is to the right of target, -1 otherwise
 sgn=a.cx>t.cx and 1 or -1
 -- Compute projectile start position.
 x0,y0=a.cx-sgn*a.ssz,a.cy-3
 -- Compute projectile end position.
 x1,y1=t.cx,t.cy

 if st.p==0 then
  -- Preparing phase. Play the fire animation for the attacker.
  -- (note: setting this repeatedly is a no-op so we don't have
  -- to waste chars with an if below):
  BatSetPose(a,bad.fl&BAT_AF_THROW>0 and BAT_PO_THROW or
    bad.fl&BAT_AF_SPELL>0 and BAT_PO_CAST or BAT_PO_FIRE)
  -- End of phase? Time to advance.
  if st.pc>25 then st.p,st.pc=1,0 end
 elseif st.p==1 then
  -- Projectile is flying. Animate it.
  px,py=Interp(0,x0,st.pfc,x1,st.pc),Interp(0,y0,st.pfc,y1,st.pc)
  -- Draw it.
  spr(bad.psp,px,py,0)
  -- End of animation?
  if st.pc>st.pfc then st.p,st.pc=2,0 end
  -- If it's a throw, return to idle pose after.
  _=bad.fl&BAT_AF_THROW>0 and BatSetPose(a,BAT_PO_IDLE)
 else
  -- Damage phase.
  if st.pc==1 then
   SFX_Play(st.dmg and SFX_HIT or SFX_MISS)
   -- Hitting target. Set the target to be in the hurt position,
   -- if this is a hit.
   _=st.dmg and BatSetPose(t,BAT_PO_HURT)
   -- Apply damage, if any.
   BatApplyDmg(t,st.dmg,bad)
  end
  -- Render damage indicator, if it was a hit.
  _=st.pc<20 and BatPrintDmgString(t,st.dmg,st.pc//4,bad)
  -- End?
  if st.pc>30 then
   BatRestorePose(a,t)
   BatTurnAdvance()
   return TRUE
  end
 end
 _=st.p>0 and bad.narr and PrintC(bad.narr,92,100)
end

-- Action that carries out an area attack of one battle participant
-- against another. This takes care of animating, rendering damage,
-- etc, etc.
--   st.at: the token representing the attacker
--   st.tc: the # of the cell being targeted
--   st.bad: the BatAttackDef defining the attack.
function BatActAreaAttack(st)
 local a,t,ts,bad,i,def,d
 bad=st.bad
 -- st.p is the attack phase.
 st.p=st.p or 0
 -- st.pc is the phase clock (resets at the start of every phase).
 st.pc=(st.pc or 0)+1
 -- Alias to st.at
 a=st.at
 if st.p==0 then
  -- Preparing phase. Play the fire animation for the attacker.
  -- (note: setting this repeatedly is a no-op so we don't have
  -- to waste chars with an if below):
  BatSetPose(a,bad.fl&BAT_AF_SPELL>0 and BAT_PO_CAST or BAT_PO_FIRE)
  -- End of phase? Time to advance.
  if st.pc>35 then st.p,st.pc=1,0 end
 elseif st.p==1 then
  -- Animate area of effect.
  --rect((st.tc-1)*BAT_CELL_WIDTH,8,BAT_CELL_WIDTH,BAT_BOARD_HEIGHT-16,
  -- st.bad.psp) -- TODO: improve this
  -- Cell width is conveniently 30, so we can just use the phase
  -- clock to animate this:
  for i=8,BAT_BOARD_HEIGHT-16,8 do spr(bad.psp,
   (st.tc-1)*BAT_CELL_WIDTH+st.pc//2,i,0) end
  -- End of animation?
  if st.pc>45 then st.p,st.pc=2,0 end
 else
  -- Damage phase.
  ts=B.c[st.tc]
  if st.pc==1 then
   SFX_Play(SFX_HIT)
   -- Hitting targets.
   for i=1,#ts do
    def=ts[i].ent and ts[i].ent.def or P_GetDef(ts[i].ch)
    assert(def,"BAAd")
    -- Damage is att - def.
    d=max(1,bad.att-def)
    -- Set pose to hurt position.
    BatSetPose(ts[i],BAT_PO_HURT)
    -- Apply damage.
    BatApplyDmg(ts[i],d,bad)
    -- Render damage indicator.
    _=st.pc<20 and BatPrintDmgString(ts[i],d,st.pc//4,bad)
   end
  end
  -- End?
  if st.pc>30 then
   for i=1,#ts do BatRestorePose(a,ts[i]) end
   BatTurnAdvance()
   return TRUE
  end
 end
 _=st.p>0 and bad.narr and PrintC(bad.narr,92,100)
end

-- Sets the pose of a token.
function BatSetPose(t,po) if t.po~=po then t.po,t.pocs=po,G.clk end end

-- Prints a damage string next to the given target.
--   oy: offset Y.
--   dmg: nil if miss, otherwise damage caused. Note that 0 damage
--     is still considered a hit.
function BatPrintDmgString(t,dmg,oy,bad)
 -- Don't print damage for damage 0 (this is used for attacks/spells
 -- that cause no damage but inflict a condition, for instance).
 if dmg and dmg<1 then return end
 PrintC(
   dmg and ("-"..dmg) or (bad.fl&BAT_AF_SPELL>0 and "NO EFFECT" or "MISS"),
   t.cx-(t.ch and -8 or 8),
   t.cy-t.ssz*4-oy,
   dmg and C_RED or C_LGRAY)
end

