-- Music types
#define MUT_NONE 0
#define MUT_TITLE 1
#define MUT_OVERWORLD 2
#define MUT_TOWN 3
#define MUT_DUNGEON 4
#define MUT_BATTLE 5

MU={
 M={
  [MUT_TITLE]={0},
  [MUT_OVERWORLD]={7,1,6},
  [MUT_TOWN]={2,5},
  [MUT_DUNGEON]={3},
  [MUT_BATTLE]={4}
 },
 -- For music variety, we store what index we last used for each
 -- music type, and try to use a different one next time.
 lm={},
 -- Music type (not track!) that's currently playing, -1 to mean none.
 cm=MUT_NONE
}

-- Plays the given music type.
--   m: the music type (one of the MUT_* constants).
--   k: if not nil, then we will reuse the last song we were playing
--      of that type, not start a new one.
function MU_Play(m,k)
 local mt,lm=MU.M[m],MU.lm
 assert(mt and #mt>0,"MU"..m)
 -- lm[m] is the last music index used for this music type.
 lm[m]=k and (lm[m] or 0) or WrapInc(lm[m] or 0,#mt)
 _=DBG_NO_MUSIC or music(mt[lm[m]])
 MU.cm=m
end

function MU_IsPlaying() return MU.cm>MUT_NONE end

function MU_Stop()
 music(-1)
 MU.cm=MUT_NONE
end

