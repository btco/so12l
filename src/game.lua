-- Start level/entry point.

-- MAIN MODULE

#define MINIMAP_X 188
#define MINIMAP_Y 0
#define MINIMAP_COLS 5
#define MINIMAP_ROWS 5
#define MINIMAP_RX MINIMAP_X
#define MINIMAP_RY MINIMAP_Y
#define MINIMAP_RW 40
#define MINIMAP_RH 40

-- Game modes
-- Title screen
#define GMODE_TITLE 1
-- Instructions screen
#define GMODE_INSTR 2
-- Play mode
#define GMODE_PLAY 3
-- Dead mode
#define GMODE_DEAD 4
-- Erase game mode
#define GMODE_ERASE 5
-- World map mode
#define GMODE_WMAP 6
-- Win mode (The End)
#define GMODE_WIN 7
-- Cut scene (cut scene# is in G.csn)
#define GMODE_CUTSCENE 8
-- Story display mode
#define GMODE_STORY 9

-- Cut scenes:
#define CSN_CAMPING 1
#define CSN_INN 2
#define CSN_RSTO 3
#define CSN_FOVI 4
#define CSN_OTO 5
#define CSN_MTN 6
#define CSN_SUTO 7
#define CSN_CAST 8
#define CSN_MONA 9
#define CSN_SAHA 10
#define CSN_UGTO 11
#define CSN_YNIS 12
#define CSN_WPTO 13
#define CSN_NOKE 14
#define CSN_IGNI 15
#define CSN_INTO 16

-- Bank# for title screen.
#define TITLE_BANK_NO 4

-- Input configuration
#define INPUT_CONFIG_KEYBOARD 0
#define INPUT_CONFIG_GAMEPAD 1

-- Game state
G={
 -- Current mode
 m=GMODE_TITLE,
 -- Cut scene# if mode is GMODE_CUTSCENE
 csn=0,
 -- Loaded XLVM program? 1 = loading, 2 = done.
 xin=0,
 -- Booted?
 booted=FALSE,
 -- Frame counter.
 clk=0,
 -- Queue of outstanding requests for non-blocking bank switches.
 -- Each:
 --  mask: bank switch mask to use.
 --  bank: bank#.
 bsr={},
 -- Memory bank number currently active for tiles.
 tbank=0,
 -- Memory bank number currently active for sprites (textures).
 sbank=0,
 -- If true, a bank switch was already performed on this frame.
 bsw=FALSE,
 -- Indicates which buttons are pressed on this frame.
 --    e.g., b[BTN_PRI]
 b={},
 -- Indicates which buttons have been just pressed on this frame.
 --    e.g., bp[BTN_PRI]
 bp={},
}

-- Goes to the given level#, entering it at entry point epnum.
function G_ChangeLvl(lvlN,epnum)
 trace("ch lvl "..lvlN.." e"..epnum)
 -- Load the new level.
 L_Load(lvlN,epnum)
end

-- Resets all systems to their default state.
function G_ResetAll()
 A_Reset()
 B_Reset()
 R_Reset()
 P_Reset()
 PS_Reset()
 X_Reset()
end

function G_ShowWorldMap() ChangeMode(GMODE_WMAP) end

function G_LaunchCutScene(csn) MU_Stop() G.csn=csn ChangeMode(GMODE_CUTSCENE) end

-- Shows the end screen.
--   endn: ending number
function G_Win(endn)
 G.endn=endn
 ChangeMode(GMODE_WIN)
end

--END OF API-----------------------------------------------------
-----------------------------------------------------------------

function Boot()
 -- Test pmem
 G.pok=pmem(254)==123
 pmem(254,123)
end

function TIC() #keep
 G.bsw=FALSE
 G.frst=time()
 if G.xin==0 then
  -- Initialize XL VM (first part).
  X_InitLo()
  G.xin=1
  return
 elseif G.xin==1 then
  -- Finish XL init (second part).
  X_InitHi()
  G.xin=2
  return
 elseif G.xin==2 then
  -- Done loading XLVM data, switch back to bank 0.
  BankSwitch(T80_SYNC_MAP, 0)
  G.xin=3
  -- Initialize modules that depend on the XL program being loaded:
  R_Init()
  L_Init()
  IT_Init()
  E_Init()
  Z_Init()
  LO_Init()
  return
 end
 G.clk=G.clk+1
 ProcessButtons()
 G.booted=G.booted or Boot() or TRUE

 -- On GMODE_PLAY and GMODE_DEAD, don't clear screen (it has its own logic).
 _=G.m==GMODE_PLAY or G.m==GMODE_DEAD or cls(C_GRAY)

 -- Call the appropriate TIC function for the current mode.
 GMTIC[G.m]()
 if DBG_SHOW_FPS then
  local t=ceil(time()-G.frst)
  t=t<10 and "0"..t or t
  prn(t,4,4,15)
 end
end

function ProcessButtons()
 -- In GMODE_PLAY mode, only even frames are update frames
 -- (odd frames are prep only).
 --if G.m==GMODE_PLAY and G.clk&1>0 then return end
 for b=0,7 do
  G.bp[b]=btn(b) and not G.b[b]
  G.b[b]=btn(b)
 end
end

function BankSwitch(mask,bank)
 ast(not G.bsw,"BSW")
 G.bsw=TRUE
 sync(mask,bank)
 if mask&T80_SYNC_TILES>0 then G.tbank=bank end
 if mask&T80_SYNC_SPRITES>0 then G.sbank=bank end
 if mask&T80_SYNC_MAP>0 then G.mbank=bank end
end

function TicTitle()
 cls(0)
 -- Request bank switch to title screen graphics.
 if G.clk==1 then
  BankSwitch(T80_SYNC_TILES|T80_SYNC_SPRITES|T80_SYNC_MAP|T80_SYNC_PALETTE,TITLE_BANK_NO)
  MU_Play(MUT_TITLE)
  return
 end
 -- Background (day).
 local off=G.clk&16>0 and 60 or 0
 map(off,0,30,17,0,0)
 -- Background (night).
 _=G.clk>40 and map(30+off,0,30,min(17,(G.clk-40)//4),0,0)
 DrawTransition()
 if G.clk<140 and not btn(7) then return end
 -- Title.
 map(0,17,30,17,0,0,0)
 local new=pmem(0)<1
 _=G.clk&32>0 and
   PrintC(X_Str(new and SYM_SPressZToStart or SYM_SPressZToLoad),
   120,110,C_YELLOW)
 if Dbtnp(BTN_PRI) then
  -- Restore normal bank.
  if new then ChangeMode(GMODE_STORY) else MU_Stop() StartGame() end
 end
 if btn(BTN_DOWN) and btn(BTN_LEFT) and btn(6) and btnp(7) then
  -- Erase save.
  ChangeMode(GMODE_ERASE)
 end
 --PrintC("Copyright (c) 2019 Bruno Oliveira",0,0,C_GRAY)
 prn(X_Str(SYM_SCopyright),5,128,C_LGRAY,PRN_MONOSPACE_TINY)
 _=G.pok and prn("Save OK",0,0,C_PURPLE,PRN_MONOSPACE_TINY)
end

function TicStory()
 -- Night background.
 map(30,0,30,17,0,0)
 PrintLines(X_Strs(SYM_AStory),5,max(136-G.clk//2,5))
 if G.clk>260 or btn(7) then
  _=G.clk&32>0 and
    PrintC(X_Str(SYM_SPressZToStart),120,110,C_YELLOW)
  _=btnp(BTN_PRI) and ChangeMode(GMODE_INSTR)
 end
end


function TicInstr()
 -- This mode must be shown with bank #4 active.
 assert(G.mbank==4,"INSmb")
 _=G.clk==1 and MU_Stop()
 cls(1)
 map(30,17,30,17,0,0,0)
 if G.clk>100 and G.clk&32>0 then
  PrintC(X_Str(SYM_SPressZToContinue),120,120,C_WHITE)
 end
 _=(G.clk>100 or btn(7)) and Dbtnp(BTN_PRI) and StartGame()
 DrawTransition()
end

function TicErase()
 cls(1)
 PrintLines(X_Strs(SYM_AErasePrompt),20,20)
 G.etcks=(G.etcks or 0)+BoolToNum(Dbtnp(BTN_PRI))
 if G.etcks>15 then
  G.etcks=0
  SFX_Play(SFX_HURT)
  pmem(0,0)
  ChangeMode(GMODE_TITLE)
 end
 if Dbtnp(BTN_SEC) then ChangeMode(GMODE_TITLE) end
end

function TicWMap()
 WM_DrawWorldMap()
 _=Dbtnp(BTN_SEC) and ChangeMode(GMODE_PLAY)
 DrawTransition()
end

function StartGame()
 -- Request bank switch back to 0 (default)
 BankSwitch(T80_SYNC_TILES|T80_SYNC_SPRITES|T80_SYNC_MAP|T80_SYNC_PALETTE,0)
 -- Reset all systems.
 G_ResetAll()
 if pmem(0)<1 then
  -- Go to the first level.
  local sl={DBG_GAME_START_LOC}
  G_ChangeLvl(sl[1] or LVLN_WRLD, sl[2] or 1)
  ChangeMode(GMODE_PLAY)
 else
  -- Load existing game.
  S_Load()
  ChangeMode(GMODE_PLAY)
 end
end

function TicPlay()
 Rend()
 Update()

 -- HACK: if no music is playing (happens when returning from a
 -- cutscene like 'resting' or 'inn'), force music.
 _=G.clk>10 and not B and L_PlayMusicIfNeeded()

 if P_IsGameOver() then
  MU_Stop()
  ChangeMode(GMODE_DEAD)
 end
 if btnp(6) and btn(BTN_RIGHT) and btn(BTN_UP) then D_LaunchPatch() end
 DrawTransition()
end

function TicDead()
 Rend()
 clip()
 Stipple(VP_X+1,VP_Y+1,VP_W-2,VP_H-2,C_BLUE)
 PrintC(X_Str(SYM_SGameOver),VP_X+VP_W//2,VP_Y+VP_H//2,C_WHITE)
 if G.clk>200 or (G.clk>30 and Dbtnp(BTN_PRI)) then
  G_ResetAll()
  ChangeMode(GMODE_TITLE)
 end
end

function TicWin()
 local off=G.clk&16>0 and 30 or 0
 -- Use bank #4 for win screen.
 -- Use T80_SYNC_ALL to include music.
 -- IMPORTANT: we leave this as the permanent bank and don't switch
 -- back because there's nothing else to do after this mode; if in
 -- the future we have to switch back to the other modes, we need
 -- to switch music/sfx back to bank 0.
 if G.clk==1 then
  BankSwitch(T80_SYNC_ALL,4)
  -- HACK: bank#4 replaces the title song with the finale song,
  -- so if we just request MUT_TITLE, we get the finale song.
  MU_Play(MUT_TITLE)
 end
 map((G.endn==ENDN_GOOD and 120 or 60)+off,G.endn==ENDN_GOOD and 0 or 17,30,17)
 local x,y,a=20,max(136-G.clk//2,5),
   G.endn==ENDN_GOOD and X_Strs(SYM_AEpilogueGood) or X_Strs(SYM_AEpilogueEvil)
 PrintLines(a,x+1,y+1,C_BLACK)
 PrintLines(a,x,y)
 DrawTransition()
end

function TicCutScene()
 cls(0)
 if G.clk<2 then
  -- Use bank 5 for graphics
  BankSwitch(T80_SYNC_SPRITES|T80_SYNC_TILES|T80_SYNC_MAP,5)
  return
 end
 local n=G.csn-1
 map((n%8)*30,17*(n//8))
 PrintC(X_Strs(SYM_ACutSceneStrings)[G.csn],120,max(110,136-G.clk),C_WHITE)
 if G.clk>200 then
  -- Switch to bank 0. This is what other modes expect. In particular,
  -- other modes assume the map bank will always be 0 and don't switch
  -- it, so we really have to restore it to 0.
  BankSwitch(T80_SYNC_SPRITES|T80_SYNC_TILES|T80_SYNC_MAP,0)
  ChangeMode(GMODE_PLAY)
 end
end

function ChangeMode(m)
 G.clk,G.m=0,m
 clip()
end

function Update()
 -- Try to run pending actions, if there are any. If we ran an action,
 -- that's all we do for this frame.
 if A_Run() then return end

 -- Update the level.
 L_Update()

 -- If we got here, we are idle, that is, there are no actions
 -- queued, so we can process player input.
 P_Update()
end

function Rend()
 if G.clk&1>0 then
  -- Odd frame: just switch bank to the level's bank, or to the
  -- battle bank, if we're in battle mode.
  BankSwitch(T80_SYNC_SPRITES|T80_SYNC_TILES,
    B and BAT_BANK_NO or L.lvl.texb)
  -- Don't render anything on this frame.
  clip(0,0,0,0)
 elseif G.clk>2 then -- safeguard
  -- Even frame: actually render stuff.
  clip()
  cls(0)
  -- It's an even frame so we know the current sprites/tiles bank is
  -- the level's textures (or battle bank), so we can start by
  -- rendering the viewport.
  clip(VP_X-1,VP_Y-1,VP_W+1,VP_H+2)
  if B then
   -- Render the battle.
   B_Render()
  elseif G.tbank==L.lvl.texb then
   -- NOTE: we have to check above if G.tbank is the level's bank
   -- because we may have JUST ended the battle so B was set to nil but
   -- maybe we didn't yet bank switch back to the level's texture
   -- bank, in which case we'd crash on TID lookups. In that case,
   -- we skip a frame without drawing anything.
   
   -- Render the 3D view.
   R_SetSkyColor(L.lvl.skyc)
   R_Rend()
  end
  clip()
  -- Now we can bank switch to bank 0 for UI elements.
  BankSwitch(T80_SYNC_SPRITES|T80_SYNC_TILES|T80_SYNC_MAP,0)
  DecoRect(VP_X,VP_Y,VP_W,VP_H)
  -- Render the party info.
  P_RendParty()
  L_RendPMap(MINIMAP_X,MINIMAP_Y,MINIMAP_COLS,MINIMAP_ROWS)
  DecoRect(MINIMAP_RX,MINIMAP_RY,MINIMAP_RW,MINIMAP_RH)
  prn(L.lvl.lvlt,MINIMAP_X,45,C_LGRAY,PRN_MONOSPACE_TINY)
  if R.li==LIGHT_NONE and not B then
   PrintC(X_Str(SYM_SItsDark),VP_X+VP_W//2,15,C_GRAY)
  end
  -- Now call the XL frame proc, if any.
  -- Params:
  --   0 if not in battle, 1 if in battle.
  X_Call(SYM_PROC_DrawFrame,{BoolToNum(B)})
  -- If there are 2 characters in the party, then we are at the
  -- beginning of the game before Lyla joins. In this case, show
  -- the keys summary.
  _=#PA==2 and prn("Keys\nZ: action\nX: close/cancel",
    100,115,C_GRAY,PRN_MONOSPACE_TINY)
 end
end

function DrawTransition()
 local s=G.clk/30
 if s>=1 then return end
 rect(0,0,240,68-s*68,C_BLACK)
 rect(0,68+s*68,240,68,C_BLACK)
 rect(0,0,120-s*120,136,C_BLACK)
 rect(120+s*120,0,120,136,C_BLACK)
end

-- Tick function for each game mode.
GMTIC={
 [GMODE_TITLE]=TicTitle,
 [GMODE_INSTR]=TicInstr,
 [GMODE_PLAY]=TicPlay,
 [GMODE_DEAD]=TicDead,
 [GMODE_ERASE]=TicErase,
 [GMODE_WMAP]=TicWMap,
 [GMODE_WIN]=TicWin,
 [GMODE_CUTSCENE]=TicCutScene,
 [GMODE_STORY]=TicStory
}

