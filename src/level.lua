-- LEVEL PROCESSING ROUTINES

-- Current level state.
L=nil
L_INIT={
 -- Current level number.
 lvlN=nil,
 -- Current level (references one of the objects in LVLS)
 lvl=nil,
 -- Title of current level.
 lvlt=nil,
 -- Level tiles, addressed as r*1000+c where r,c are in LEVEL coordinates,
 -- each:
 --  sid: sprite ID in map memory that represents it.
 --  x,z: tile position
 --  mc,mr: raw map row/col in map memory where the tile is located
 --  td: pointer to the tile definition (TD[sid])
 --  rends: array of renderables (floors, ceilings, walls) that
 --         represent this tile.
 --  msp: the map sprite that it should rendered with
 --  mspo: the map sprite that should be rendered transparently
 --        over the msp (for overlays).
 --  kfi: If not nil, this is the kill flag index for this tile.
 --       This indicates which bit in the level's state stores the
 --       binary state of this tile. For example, for a treasure chest
 --       it might indicate if the chest was already looted.
 --  bsn: battle visual style# to use for battles on this level.
 tiles={},
 -- NOTE: we only keep the renderables for the portion of the level
 -- that's close to the player. We dynamically create and delete
 -- renderables for tiles as the player moves around. These are
 -- the tiles for which we have active renderables.
 -- rtiles stands for "rendered tiles."
 rtiles={},
 --  TODO: more data here soon.
}

-- List of all levels. Each level has a number (the index in
-- this array). Each level has:
--  mc0,mr0: row,col in map memory where level starts.
--  mcols,mrows: width/height of level in tiles.
--  flags: flags (LVLF_*)
--  kfL: kill flags length, in bytes. This specifies how many
--    bytes to reserve for the entity kill flags (the flags that 
--    indicate which entities in the map have already been killed).
--    The actual value for the KF is managed by pers.lua.
--  sky: sky color
--  iproc: address of level interaction procedure
--         This is an XL procedure called when the player interacts
--         with something in the level.
--  uproc: address of level item use procedure. This is an XL
--         proc that gets called when the user uses an item on
--         this level, if there's no built-in behavior for that item.
--         If 0, it means there is no uproc.
--  wproc: address of level walk procedure. Called when player
--         walks.
--  bproc: address of level boot procedure. Called when the level
--         has just been loaded.
--  epts: entry points into the level (each with x, z, dir).
--  mus: Music type for level (MUT_* constants)
--  tsub: Map of TID substitutions for tiles.
--  texb: Texture bank# to use for this level.
-- (Loaded from XL memory on startup)
local LVLS=nil

-- Level defines (level numbers and entry point indices):
#define LVLN_WRLD 1
  #define ENTPT_WRLD_NEW_GAME 1
  #define ENTPT_WRLD_FROM_RSTO_S 2
  #define ENTPT_WRLD_FROM_RSTO_N 3
  #define ENTPT_WRLD_FROM_RSC1 4
  #define ENTPT_WRLD_FROM_STMP 5
  #define ENTPT_WRLD_FROM_ORCH 6
  #define ENTPT_WRLD_FROM_PASS_S 7
  #define ENTPT_WRLD_FROM_PASS_N 8
  #define ENTPT_WRLD_FROM_MTN1 9
  #define ENTPT_WRLD_FROM_FOVI 10
  #define ENTPT_WRLD_FROM_TUNN_SE 11
  #define ENTPT_WRLD_FROM_TUNN_SK 12
  #define ENTPT_WRLD_FROM_SUTO 13
  #define ENTPT_WRLD_FROM_OTO1 14
  #define ENTPT_WRLD_FROM_CAST 15
  #define ENTPT_WRLD_FROM_MONA 16
  #define ENTPT_WRLD_FROM_SAHA 17
  #define ENTPT_WRLD_DESERT    18
  #define ENTPT_WRLD_PORTAL_RS 19
  #define ENTPT_WRLD_FROM_WPTO 20
  #define ENTPT_WRLD_FROM_INTO 21
  #define ENTPT_WRLD_FROM_NOKE 22
  #define ENTPT_WRLD_FROM_YNIS 23
  #define ENTPT_WRLD_FROM_UGTO 24
  #define ENTPT_WRLD_FROM_ICEM 25
  #define ENTPT_WRLD_FROM_LLIB 26
#define LVLN_RSC1 2
  #define ENTPT_RSC1_ENTRANCE 1
  #define ENTPT_RSC1_FROM_L2 2
#define LVLN_RSC2 3
  #define ENTPT_RSC2_FROM_L1 1
#define LVLN_RSTO 4
  #define ENTPT_RSTO_SOUTH_GATE 1
  #define ENTPT_RSTO_NORTH_GATE 2
  #define ENTPT_RSTO_FROM_CELR 3
  #define ENTPT_RSTO_FROM_JAIL 4
  #define ENTPT_RSTO_PORTAL 5
#define LVLN_ORCH 5
  #define ENTPT_ORCH 1
#define LVLN_PASS 6
  #define ENTPT_PASS_SOUTH 1
  #define ENTPT_PASS_NORTH 2
#define LVLN_TUNN 7
  #define ENTPT_TUNN_W 1
  #define ENTPT_TUNN_E 2
#define LVLN_SUTO 8
  #define ENTPT_SUTO 1
#define LVLN_OTO1 9
  #define ENTPT_OTO1_FROM_WRLD 1
  #define ENTPT_OTO1_FROM_OTO2 2
#define LVLN_OTO2 10
  #define ENTPT_OTO2_FROM_OTO1 1
  #define ENTPT_OTO2_FROM_OTO3 2
#define LVLN_OTO3 11
  #define ENTPT_OTO3_FROM_OTO2 1
  #define ENTPT_OTO3_FROM_OTO4 2
#define LVLN_OTO4 12
  #define ENTPT_OTO4_FROM_OTO3 1
  #define ENTPT_OTO4_FROM_OTO5 2
#define LVLN_OTO5 13
  #define ENTPT_OTO5 1
-- LVLN_INTX is the dead version of LVLN_INTO
#define LVLN_INTX 14
  #define ENTPT_INTX_FROM_WRLD 1
#define LVLN_INTO 15
  #define ENTPT_INTO_FROM_WRLD 1
  #define ENTPT_INTO_QUEST 2
#define LVLN_CELR 16
  #define ENTPT_CELR 1
#define LVLN_STMP 17
  #define ENTPT_STMP 1
#define LVLN_JAIL 18
  #define ENTPT_JAIL 1
#define LVLN_MTN1 19
  #define ENTPT_MTN1_FROM_WRLD 1
  #define ENTPT_MTN1_FROM_MTN2 2
#define LVLN_MTN2 20
  #define ENTPT_MTN2_FROM_MTN1 1
  #define ENTPT_MTN2_FROM_MTN3 2
#define LVLN_MTN3 21
  #define ENTPT_MTN3 1
#define LVLN_FOVI 22
  #define ENTPT_FOVI 1
#define LVLN_CAST 23
  #define ENTPT_CAST 1
#define LVLN_MONA 24
  #define ENTPT_MONA 1
#define LVLN_SAHA 25
  #define ENTPT_SAHA_FROM_WRLD 1
  #define ENTPT_SAHA_FROM_OBE1 2
#define LVLN_OBE1 26
  #define ENTPT_OBE1_FROM_WRLD 1
  #define ENTPT_OBE1_FROM_OBE2 2
#define LVLN_OBE2 27
  #define ENTPT_OBE2_FROM_OBE1 1
  #define ENTPT_OBE2_FROM_OBE3 2
#define LVLN_OBE3 28
  #define ENTPT_OBE3_FROM_OBE2 1
#define LVLN_WPTO 29
  #define ENTPT_WPTO 1
#define LVLN_NOKE 30
  #define ENTPT_NOKE 1
  #define ENTPT_NOKE_FROM_NOKT 2
#define LVLN_YNIS 31
  #define ENTPT_YNIS 1
#define LVLN_NOKT 32
  #define ENTPT_NOKT 1
#define LVLN_UGTO 33
  #define ENTPT_UGTO 1
#define LVLN_ICEM 34
  #define ENTPT_ICEM 1
#define LVLN_IGNI 35
  #define ENTPT_IGNI 1
#define LVLN_LLIB 36
  #define ENTPT_LLIB 1

-- Level flags
-- Level is dark:
#define LVLF_DARK 1
-- Player is bereft of equipment.
#define LVLF_NO_ITEMS 2
-- Far background is the "sea" (blue rect).
#define LVLF_SEA_BG 4
-- Use texture bank 2 instead of 1 (default).
#define LVLF_TEXB2 8
-- Use black sky color (even if not LVLF_DARK)
#define LVLF_BLACK_SKY 16

-- Tile flags (16 bits -- flags field is a word):
#define TF_WALL_N 1
#define TF_WALL_E 2
#define TF_WALL_S 4
#define TF_WALL_W 8
#define TF_SOLID 16
#define TF_KILLABLE 32
  -- Means the tile is killable, that is, it should have a kill
  -- flag in persistent state that determines if it's in the alive
  -- or dead state, and interacting it will kill it (so the player
  -- can interact with it only once).
#define TF_SOLID_IF_ALIVE 64
  -- Means this tile is SOLID only if marked as "alive". This only
  -- makes sense in conjunction with TF_KILLABLE.
#define TF_SPR_RAND_OFFSET 128
  -- Means the tile can be lept over using the Leap spell.
  -- This is only relevant if the tile is TF_SOLID. Otherwise,
  -- it's leapable by default anyway.
#define TF_LEAPABLE 256
  -- Render walls with colorkey (to support semi-transparent walls).
#define TF_WALL_TRANSPARENT 512
  -- Don't show overlay on map (show original tile only).
#define TF_MAP_NO_OVERLAY 1024
  -- If set, the north/south wall offset is 50%
#define TF_WALL_OFFSET_NS_50 2048
  -- If set, the east/west wall offset is 50%
#define TF_WALL_OFFSET_EW_50 4096

-- Tile definitions
--  flags: tile flags (TF_*)
--  wtid: wall TID
--  ftid: floor TID
--  ctid: ceiling TID
--  stid: TID of sprite to spawn on the tile
--  kstid: if not nil, this is the stid to use instead when the tile
--         is in the killed state (its kill flag is set).
--  ssize: size of sprite, default 1
--  wons: wall offset in the north-south direction. For example, if
--        this is 0.2, walls will be inset from the north and
--        south ends of the tile by this distance.
--  woew: wall offset in the east-west direction.
--  wh: wall height
TD=nil
-- Overlays (each of these will overlay over a copy of the
-- tile that's to the right of it).
OTD=nil

-- "Radius" around the player that we keep active renderables
-- for. This is how far the player can see.
#define TILE_RENDER_RADIUS 5

#define LEVEL_XL_HDR 250
#define TILE_XL_HDR_NORMAL 249
#define TILE_XL_HDR_OVERLAY 248

-- Initializes. Loads the level and tile definitions from XL
-- program memory.
function L_Init()
 -- Load level defs.
 X_SetPc(SYM_LevelDb)
 LVLS={}
 while 1 do
  local sig=X_FetchB()
  local l={}
  -- A 0 byte ends the levels list.
  if sig==0 then break end
  ast(sig==LEVEL_XL_HDR,"!LVLs"..#LVLS)
  -- Check that the level number is right.
  ast(X_FetchB()==1+#LVLS,"!LVLn"..#LVLS)
  l.lvlt=X_FetchString()
  l.mc0=X_FetchB()
  l.mr0=X_FetchB()
  l.mcols=X_FetchB()
  l.mrows=X_FetchB()
  l.flags=X_FetchB()
  l.skyc=l.flags&(LVLF_DARK|LVLF_BLACK_SKY)>0 and 0 or 8
  l.mus=X_FetchB()
  l.texb=l.flags&LVLF_TEXB2>0 and 2 or 1
  l.kfL=X_FetchB()
  l.bsn=X_FetchB()
  l.iproc=X_FetchW()
  l.uproc=X_FetchW()
  l.wproc=X_FetchW()
  l.bproc=X_FetchW()
  l.epts={}
  local entptc=X_FetchB()
  for i=1,entptc do
   local ept={}
   -- NOTE: The xz in XL memory is represented as raw map memory
   -- coordinates, not level coordinates, so we convert here:
   local rx=X_FetchB()
   local rz=X_FetchB()
   ept.x,ept.z=MapCRToLevelCR(l,rx,rz)
   ept.dir=X_FetchB()
   insert(l.epts,ept)
  end
  -- Read list of tile TID substitutions.
  l.tsub={}
  local subc=X_FetchB()
  for i=1,subc do
   local f=X_FetchB()
   l.tsub[f]=X_FetchB()
  end
  insert(LVLS,l)
 end
 trace("LVL init "..#LVLS)
 -- Load tile defs.
 X_SetPc(SYM_TileDb)
 TD,OTD={},{}
 local tc,ss=0,0
 while 1 do
  local sig=X_FetchB()
  local d={}
  -- A 255 byte ends the tile defs list.
  if sig==255 then break end
  ast(sig==TILE_XL_HDR_NORMAL or TILE_XL_HDR_OVERLAY,"!Tsig"..sig..'@'..tc)
  local id=X_FetchB()
  d.flags=X_FetchW()
  d.ftid=NilIf0(X_FetchB())
  d.ctid=NilIf0(X_FetchB())
  d.wtid=NilIf0(X_FetchB())
  d.stid=NilIf0(X_FetchB())
  d.kstid=NilIf0(X_FetchB())
  ss=X_FetchB()
  d.ssize=ss>0 and ss*.01 or 1
  d.wons=d.flags&TF_WALL_OFFSET_NS_50>0 and .5 or 0
  d.woew=d.flags&TF_WALL_OFFSET_EW_50>0 and .5 or 0
  -- Can't have stid with a zero sprite size.
  ast(not d.stid or d.ssize>0,"!ZS"..id)
  ast(not TD[id] and not OTD[id],"!DupTI"..id)
  if sig==TILE_XL_HDR_NORMAL then
   TD[id]=d
  else
   OTD[id]=d
  end
  tc=tc+1
 end
 trace("TILE init "..tc)
end

-- Loads the given level number and places the player at the given
-- entry point number (default 1).
-- If epnum is -1, then the player won't be moved.
function L_Load(lvlN,epnum)
 -- If there's a current level active, shut it down first.
 if L then ShutDownLevel() end
 -- Now load the new level.
 epnum=epnum or 1
 local lvl=LVLS[lvlN]
 ast(lvl)
 L=DeepCopy(L_INIT)
 L.lvlN=lvlN
 L.lvl=lvl
 MU_Play(lvl.mus)
 -- Next KFI to assign
 local nextKfi=0
 for lr=0,lvl.mrows-1 do
  for lc=0,lvl.mcols-1 do
   local ti=TileInit(lc,lr)
   -- If it's a one-shot entity, assign it a unique kill flag index.
   if ti.td and ti.td.flags&TF_KILLABLE>0 then
    -- Ensure that the level has enough kill flag bytes allocated.
    ast((nextKfi//8)<lvl.kfL,"KF over cap")
    ti.kfi=nextKfi
    nextKfi=nextKfi+1
   end
  end
 end
 -- Place player at the indicated entry point.
 if epnum>=0 then
  local ep=lvl.epts[epnum]
  ast(ep,"No lvl entry "..epnum.." @L"..lvlN)
  P_SetPos(ep.x,ep.z,ep.dir)
 end
 -- Call first update manually to ensure we have the right
 -- renderables loaded (since the boot proc might do interstitials,
 -- etc).
 L_Update()
 -- Call boot procedure.
 X_Call(SYM_PROC_BootLevel)
 -- Set the level lighting. This will be overriden by XL code,
 -- but that will take one or two frames to happen, and we don't
 -- want to have a completely wrong lighting setting during those
 -- frames.
 R_SetLight(lvl.flags&LVLF_DARK>0 and LIGHT_NONE or LIGHT_FULL)
end

function L_PlayMusicIfNeeded()
 _=MU_IsPlaying() or MU_Play(L.lvl.mus,TRUE)
end

function L_GetTile(lc,lr)
 return L.tiles[lr*1000+lc]
end

-- Converts raw map memory coordinates to level coordinates.
function L_RawToLevelCoords(mc,mr)
 return mc-L.lvl.mc0,L.lvl.mr0-mr+L.lvl.mrows-1
end
-- Converts level coordinates to raw map memory coordinates.
function L_LevelToRawCoords(lc,lr,lvl)
 lvl=lvl or L.lvl
 return lc+lvl.mc0,lvl.mr0+lvl.mrows-1-lr
end


-- Renders a player-centered map starting at screen coordinates x0,y0
-- and extending for the given number of columns and rows. The player
-- will be rendered at the center.
function L_RendPMap(x0,y0,cols,rows)
 -- If the tiles bank is being used for something else, don't display.
 if G.tbank>0 then return end
 -- Change semantics of y0 to be the bottom left rather than top left
 y0=y0+(rows-1)*8
 -- Tile to show at the bottom left.
 local c0,r0=P.x-cols//2,P.z-rows//2
 for c=c0,c0+cols-1 do
  for r=r0,r0+rows-1 do
   local t,x,y=L_GetTile(c,r),x0+(c-c0)*8,y0-(r-r0)*8
   spr(t and t.msp or 0,x,y)
   spr(t and t.mspo or 0,x,y,0)
   if c==P.x and r==P.z then spr(247,x,y,0,1,0,P.dir) end
  end
 end
end

-- Must be called every frame to update the level.
function L_Update()
 UpdateTileRends()
end

-- Interacts with the given tile.
function L_Interact(tc,tr)
 -- Call level interaction proc to notify that player has interacted
 -- with this tile.
 local ti=L_GetTile(tc,tr)
 if not ti then return end
 -- If it's a TF_KILLABLE tile, we need to pass the kill flag to
 -- the interaction procedure. If it's not, then it's 0.
 local kf=ti.kfi and PS_GetKf(L.lvlN,ti.kfi)
 -- Convert boolean to 0/1 because that's how XL expects it.
 kf=BoolToNum(kf)
 -- Call the XL interaction procedure for the current level.
 -- Arguments:
 --   tile's raw col/row in map memory (as a 16-bit word)
 --   tile's xz in level coordinates (16-bit word)
 --   SID of the tile
 --   kill flag value (0 or 1)
 X_Call(SYM_PROC_Interact,{ti.mc+256*ti.mr,tc+tr*256,ti.sid,kf})
end

-- Determines if the tile is solid.
function L_IsTileSolid(c,r)
 local ti=L_GetTile(c,r)
 -- Get the flags for the tile. If no tile, it's the same as TF_SOLID.
 local f=ti and ti.td.flags or TF_SOLID
 -- Is the tile in the "killed" state?
 local k=ti.kfi and PS_GetKf(L.lvlN,ti.kfi)
 -- If the tile is not in the killed state and has the
 -- TF_SOLID_IF_ALIVE flag, then it's solid.
 if not k and f&TF_SOLID_IF_ALIVE>0 then f=f|TF_SOLID end
 return f&TF_SOLID>0
end

-- Sets the kill flag on the given tile.
function L_KillTile(c,r)
 local ti=L_GetTile(c,r)
 ast(ti.kfi,"Can't kill "..c..","..r)
 -- Set the kill flag, if requested.
 PS_SetKf(L.lvlN,ti.kfi)
 -- Refresh the tile renderables, in case something changed.
 TileRefreshRends(ti)
end

-- Changes a tile's SID (and hence its tile definition, renderables,
-- etc). This cannot be used to switch tiles between being killable
-- and non-killable, as that would require reallocation of kill
-- flags.
function L_ChangeSid(c,r,sid)
 ast(TD[sid] or OTD[sid],"!CSID.."..sid)
 TileRefreshRends(TileInit(c,r,sid))
end

function L_IsTileKilled(c,r)
 local ti=L_GetTile(c,r)
 if not ti or not ti.kfi then return FALSE end
 return PS_GetKf(L.lvlN,ti.kfi)
end

--END OF API-----------------------------------------------------------
-----------------------------------------------------------------------

function PutTile(lc,lr,tile)
 L.tiles[lr*1000+lc]=tile
end

-- Creates the renderables for the given tile.
function TileMaybeCreateRends(ti)
 -- If this tile already has renderables, or if it's far enough that
 -- it should not, then don't do anything for now.
 if ti.rends or not ShouldRenderTile(ti.x,ti.z) then return end
 -- Add this tile to the list of tiles that have active renderables.
 insert(L.rtiles,ti)

 -- Now let's figure out what renderables we should create.
 local x,z,td,ons,oew=ti.x,ti.z,ti.td
 local ons,oew=td.wons,td.woew
 ti.rends={}
 -- Create walls/floor.
 if td then
  _=td.ftid and insert(ti.rends,R_AddFloor(x,z,ResolveTidSubsts(td.ftid)))
  _=td.ctid and insert(ti.rends,R_AddCeil(x,z,ResolveTidSubsts(td.ctid)))
  if td.wtid then
   local wtid=ResolveTidSubsts(td.wtid)
   local wf=td.flags&TF_WALL_TRANSPARENT>0 and RF_TRANSPARENT or 0
   -- NORTH wall starts at NW corner and grows towards EAST.
   _=td.flags&TF_WALL_N>0 and
     insert(ti.rends,R_AddWall(x,z+1-ons,DIR_E,wtid,wf))
   -- EAST wall starts at NE corner and grows towards SOUTH.
   _=td.flags&TF_WALL_E>0 and
     insert(ti.rends,R_AddWall(x+1-oew,z+1,DIR_S,wtid,wf))
   -- SOUTH wall starts at SE corner and grows towards WEST.
   _=td.flags&TF_WALL_S>0 and
     insert(ti.rends,R_AddWall(x+1,z+ons,DIR_W,wtid,wf))
   -- WEST wall starts at SW corner and grows towards NORTH.
   _=td.flags&TF_WALL_W>0 and
     insert(ti.rends,R_AddWall(x+oew,z,DIR_N,wtid,wf))
  end
  local stid=td.stid
  -- If the tile is marked as killed and the tile definition defines
  -- a kstid field, use that instead.
  if ti.kfi and PS_GetKf(L.lvlN,ti.kfi) then
   stid=td.kstid or stid
  end

  if stid then
   stid=ResolveTidSubsts(stid)
   local sz,r=td.ssize,BoolToNum(td.flags&TF_SPR_RAND_OFFSET>0)
   insert(ti.rends,R_AddSprite(
     x+0.5+r*random(-9,9)*.01,sz/2,
     z+0.5+r*random(-9,9)*.01,sz,stid))
  end
 end
end

-- Destroys the renderables for the given tile.
function TileDestroyRends(ti)
 if not ti.rends then return end
 for i=1,#ti.rends do R_Del(ti.rends[i]) end
 ti.rends=nil
end

-- Depending on where the player is, deletes or creates renderables
-- for tiles to ensure that the area around the player is rendered.
function UpdateTileRends()
 -- Destroy renderables for tiles that are too far.
 for i=#L.rtiles,1,-1 do
  local ti=L.rtiles[i]
  if not ShouldRenderTile(ti.x,ti.z) then
   TileDestroyRends(ti)
   ListRemFast(L.rtiles,i)
  end
 end
 -- Create renderables for tiles that are near enough.
 for x=P.x-TILE_RENDER_RADIUS,P.x+TILE_RENDER_RADIUS do
  for z=P.z-TILE_RENDER_RADIUS,P.z+TILE_RENDER_RADIUS do
   local ti=L_GetTile(x,z)
   -- If the tile exists, should be rendered and does not have
   -- renderables, then create the renderables for it.
   _=ti and TileMaybeCreateRends(ti)
  end
 end
end

function ShouldRenderTile(x,z)
 return max(abs(x-P.x),abs(z-P.z))<=TILE_RENDER_RADIUS
end

-- Shuts the level down, removing all renderables, etc.
function ShutDownLevel()
 for _,ti in ipairs(L.rtiles) do
  TileDestroyRends(ti)
 end
 L.rtiles={}
end

-- Compute level coordinates from map memory coordinates
function MapCRToLevelCR(l,mc,mr)
 return mc-l.mc0,l.mr0+l.mrows-1-mr
end

-- Resolves a tile TID, looking it up in the substitution table.
function ResolveTidSubsts(tid) return L.lvl.tsub[tid] or tid end

function TileRefreshRends(ti)
 TileDestroyRends(ti)
 TileMaybeCreateRends(ti)
end

-- Note: this can be called again for an existing tile in
-- order to programatically change its SID.
--   nsid: the new SID to use (if nil use map default).
function TileInit(lc,lr,nsid)
 local lvl=L.lvl
 -- Compute map memory coordinates. Remember that in map memory
 -- the row coordinate is backwards (0 is at the top) while in our
 -- system 0 is at the SOUTH.
 local mc,mr=L_LevelToRawCoords(lc,lr,lvl)
 -- Start building the tile.
 -- Get the sprite from that position in map memory (or use nsid,
 -- if provided).
 local ti=L_GetTile(lc,lr) or {}
 ti.x,ti.z,ti.mc,ti.mr,ti.sid=lc,lr,mc,mr,nsid or mget(mc,mr)
 -- Figure out what tile definition to use. If it's an overlay,
 -- use the definition of the tile to the right.
 -- If it's not, use the tile itself.
 local otd=OTD[ti.sid]
 if otd then
  -- It's an overlay, or an entity marker.
  -- Borrow SID and definition from the tile to the right of it.
  local bsid=mget(mc+1,mr)
  -- If the tile to the right has no floor, use the one to the left,
  -- top or bottom.
  if not TD[bsid] or not TD[bsid].ftid then bsid=mget(mc-1,mr) end
  if not TD[bsid] or not TD[bsid].ftid then bsid=mget(mc,mr-1) end
  if not TD[bsid] or not TD[bsid].ftid then bsid=mget(mc,mr+1) end
  local btd=TD[bsid]
  ast(btd)
  -- The tile definition is a combination of base and the overlay.
  ti.td=Overlay(btd,otd)
  -- The tile's map sprite is a combination of the borrowed
  -- tile, with this tile on top.
  ti.msp,ti.mspo=bsid,otd.flags&TF_MAP_NO_OVERLAY>0 and 0 or ti.sid
 else
  ti.td=TD[ti.sid]
  -- The tile's map sprite is just the tile.
  ti.msp=ti.sid
 end
 ast(ti and ti.td,"!TD"..ti.sid)
 PutTile(lc,lr,ti)
 return ti
end

