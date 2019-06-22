-- SFX

-- Each sfx has ID, note, duration, volume, speed.
-- As per TIC-80 sfx() function.
SFX={
 #define SFX_WALK 1
 {id=1,n=16,d=30,v=8,s=1},
 #define SFX_ERROR 2
 {id=2,n=60,d=15,v=10,s=1},
 #define SFX_RECEIVE 3
 {id=3,n=72,d=15,v=10,s=0},
 #define SFX_OK 4
 {id=4,n=36,d=15,v=10,s=0},
 #define SFX_STAIRS_UP 5
 {id=5,n=36,d=30,v=10,s=-2},
 #define SFX_STAIRS_DOWN 6
 {id=6,n=36,d=30,v=10,s=-2},
 #define SFX_HIT 7
 {id=7,n=48,d=15,v=10,s=1},
 #define SFX_MISS 8
 {id=8,n=24,d=15,v=10,s=1},
 #define SFX_HURT 9
 {id=9,n=60,d=15,v=10,s=0},
 #define SFX_KILL 10
 {id=7,n=24,d=15,v=10,s=-1},
 #define SFX_SHOOT 11
 {id=8,n=72,d=15,v=10,s=1},
 #define SFX_POWERUP 12
 {id=10,n=43,d=30,v=10,s=-1},
 #define SFX_SPEAK 13
 {id=11,n=36,d=30,v=10,s=-1},
 #define SFX_VICTORY 14
 {id=13,n=40,d=120,v=8,s=-3},
}

function SFX_Play(sfxid)
 local s=SFX[sfxid]
 _=s and sfx(s.id,s.n,s.d,3,s.v,s.s)
end

--END OF API------------------------------------------------------
------------------------------------------------------------------

