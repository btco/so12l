-- ENTITIES

-- TYPE: Ent
--  eid: the entity type ID (not unique among entities -- this just
--   specifies the entity type). This is set on creation.
--  name: entity's display name.
--  fl: flags (ENTF_*)
--  sid: TID of the sprite.
--  palm: Palette map (array of 16 ints).
--  speed: Entity's speed score.
--  maxHp: entity's maximum hit points.
--  def: defense score.
--  nat: number of attacks
--  bad: BatAttackDef defining how this enemy attacks.
--  hp: entity's current hit points. Initialized to maxHp on spawn.
--  xp: XP value
--  gp: gold pieces of treasure
--  mr: magic resistance (0-100), % chance of avoiding spell

-- TYPE: BatAttackDef
-- (see battle.lua for definition)

-- Entity flags
#define ENTF_HAS_PALMAP 1
  -- If set, the entity has a palette map that needs to be applied.
#define ENTF_LARGE 2   
  -- If set, entity is 16x16 not 8x8

-- EIDs.
-- For table formatting, each EID must be at most 6 chars
-- long after EID:
--      EID_######
#define EID_SLIME  1
#define EID_RSLIME 2
#define EID_BUG    3
#define EID_FBUG   4
#define EID_SNAKE  5
#define EID_BANDIT 6
#define EID_RAT    7
#define EID_IMP    9
#define EID_MGOLEM 10
#define EID_SPIDER 11
#define EID_BSPIDR 12
#define EID_WORM   13
#define EID_GHOST  14
#define EID_DCLER  15
#define EID_TGUARD 16
#define EID_FDEMON 17
#define EID_RSNAKE 18
#define EID_SCORPI 19
#define EID_DESBUG 20
#define EID_TWIST  21
#define EID_UGUARD 22
#define EID_UMAGE  23
#define EID_UKING  24
#define EID_SEAMON 25
#define EID_FWIND  26
#define EID_NDEMON 27
#define EID_ISNAKE 28
#define EID_IGOLEM 29
#define EID_PGOLEM 30
#define EID_FLAME  31
#define EID_FCLER  32
#define EID_SRKING 33
#define EID_LEON   34
#define EID_LYLA   35
#define EID_VIC    36

function E_Init() LoadEntDefs() end

-- Creates the given entity.
-- eid: EID of the entity to spawn
function E_Create(eid)
 -- Get the entity definition.
 local entd=ENTD[eid]
 ast(entd,"Bad EID " .. eid)
 return DeepCopy(entd)
end

--END OF API---------------------------------------------------------
---------------------------------------------------------------------

#define ENT_DEF_HDR 151

-- Loads entity definitions from XL memory.
function LoadEntDefs()
 X_SetPc(SYM_EntDB)
 ENTD={}
 local c=0
 while 1 do
  local sig,d=X_FetchB(),{}
  -- A 0 byte ends the DB.
  if sig==0 then break end
  ast(sig==ENT_DEF_HDR,"Bad ent db")
  local eid=X_FetchB()
  ast(not ENTD[eid],"DupE"..eid)
  d.eid=eid
  d.name=X_FetchString()
  d.fl=X_FetchB()
  d.sid=X_FetchW()
  -- Only read palette map if that flag is set:
  d.palm=d.fl&ENTF_HAS_PALMAP>0 and X_FetchBs(15)
  d.speed=X_FetchB()
  d.maxHp=X_FetchW()
  d.hp=d.maxHp
  d.def=0 -- Per new design, all ents have defense 0.
          -- They make up for it by having a lot of HP :)
  d.xp=X_FetchW()
  d.gp=X_FetchW()
  d.mr=X_FetchB()
  d.nat=X_FetchB()
  d.bad=FetchBatAttackDef()
  ENTD[eid]=d
  c=c+1
 end
 trace("ENT load "..c)
end

function FetchBatAttackDef()
 local r={}
 r.ak=X_FetchB()
 r.att=X_FetchB()
 r.psp=X_FetchB()
 r.narr=X_FetchString()
 r.fl=X_FetchW()
 return r.ak>0 and r or nil
end

