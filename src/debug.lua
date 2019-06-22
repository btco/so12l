-- DEBUG settings

-- START LOCATION (MAP AND ENTRY POINT) ------------------------------
--#define DBG_GAME_START_LOC nil,nil
--#define DBG_GAME_START_LOC LVLN_RSTO, ENTPT_RSTO_SOUTH_GATE
--#define DBG_GAME_START_LOC LVLN_RSC1, 1
--#define DBG_GAME_START_LOC LVLN_RSC2, ENTPT_RSC2_FROM_L1
--#define DBG_GAME_START_LOC LVLN_ORCH, 1
--#define DBG_GAME_START_LOC LVLN_SUTO, ENTPT_SUTO
--#define DBG_GAME_START_LOC LVLN_OTO1, 1
--#define DBG_GAME_START_LOC LVLN_OTO3, ENTPT_OTO3_FROM_OTO2
--#define DBG_GAME_START_LOC LVLN_OTO4, ENTPT_OTO4_FROM_OTO3
--#define DBG_GAME_START_LOC LVLN_GRTO_ALIVE, 1
--#define DBG_GAME_START_LOC LVLN_CELR, 1
--#define DBG_GAME_START_LOC LVLN_WRLD, 1
--#define DBG_GAME_START_LOC LVLN_JAIL, 1
--#define DBG_GAME_START_LOC LVLN_WRLD, ENTPT_WRLD_FROM_RSTO_N
--#define DBG_GAME_START_LOC LVLN_STMP, 1
--#define DBG_GAME_START_LOC LVLN_ORCH, 1
--#define DBG_GAME_START_LOC LVLN_WRLD, ENTPT_WRLD_FROM_ORCH
--#define DBG_GAME_START_LOC LVLN_WRLD, ENTPT_WRLD_FROM_PASS_S
--#define DBG_GAME_START_LOC LVLN_PASS, 1
--#define DBG_GAME_START_LOC LVLN_MTN1, 1
--#define DBG_GAME_START_LOC LVLN_MTN3, 1
--#define DBG_GAME_START_LOC LVLN_WRLD, ENTPT_WRLD_FROM_MTN1
--#define DBG_GAME_START_LOC LVLN_FOVI, 1
--#define DBG_GAME_START_LOC LVLN_WRLD, ENTPT_WRLD_FROM_FOVI
--#define DBG_GAME_START_LOC LVLN_OTO5, 1
--#define DBG_GAME_START_LOC LVLN_CAST, 1
--#define DBG_GAME_START_LOC LVLN_MONA, 1
--#define DBG_GAME_START_LOC LVLN_WRLD, ENTPT_WRLD_DESERT
--#define DBG_GAME_START_LOC LVLN_SAHA, 1
--#define DBG_GAME_START_LOC LVLN_OBE1, 1
--#define DBG_GAME_START_LOC LVLN_OBE3, 1
--#define DBG_GAME_START_LOC LVLN_WPTO, 1
--#define DBG_GAME_START_LOC LVLN_INTX, 1
--#define DBG_GAME_START_LOC LVLN_NOKE, 1
--#define DBG_GAME_START_LOC LVLN_YNIS, 1
--#define DBG_GAME_START_LOC LVLN_UGTO, 1
--#define DBG_GAME_START_LOC LVLN_ICEM, 1
--#define DBG_GAME_START_LOC LVLN_IGNI, 1

-- PARTY TO USE ------------------------------------------------------
--#define DBG_INIT_PARTY nil
--#define DBG_INIT_PARTY SYM_Party_DEBUG
--#define DBG_INIT_PARTY SYM_Party_PreRSC
--#define DBG_INIT_PARTY SYM_Party_PostJAIL
--#define DBG_INIT_PARTY SYM_Party_PostCELR
--#define DBG_INIT_PARTY SYM_Party_PostORCH
--#define DBG_INIT_PARTY SYM_Party_PostMYRA
--#define DBG_INIT_PARTY SYM_Party_PostVicJoined
--#define DBG_INIT_PARTY SYM_Party_OTO5
--#define DBG_INIT_PARTY SYM_Party_PostOTO
--#define DBG_INIT_PARTY SYM_Party_PostMONA
--#define DBG_INIT_PARTY SYM_Party_StartSAHA

--#define DBG_FAST FALSE
#define DBG_FAST (DBG_FAST_ENABLED and btn(7))

#define DBG_NO_MELEE     (XlGetVar(VID_DBG1)&1>0)
#define DBG_FAST_ENABLED (XlGetVar(VID_DBG1)&2>0)
#define DBG_SHOW_FPS     (XlGetVar(VID_DBG1)&4>0)
#define DBG_NO_MUSIC     (XlGetVar(VID_DBG1)&8>0)

-- Debug command (triggered by SYSC_DEBUG system call).
function D_DebugCmd(c)
 if not c then return end
 if c==1 and B then B.q=TRUE end
 if c==2 then for k,v in pairs(ZD) do P_LearnSpell(k) end end
 if c==3 then DebugBuildDungeonWalls() end
 if c==4 then DebugIdentAll() end
end

function D_LaunchPatch()
 A_Enq(_DebugActPatch,{c=""},AF_MODAL)
end
function _DebugActPatch(st)
 cls(3)
 prn("Patch:",8,40)
 prn(st.c,8,50,C_YELLOW,PRN_MONOSPACE_TINY)
 for k=27,36 do
  if keyp(k) and #st.c<64 then st.c=st.c..schr(k-27+48) end
 end
 for k=1,7 do
  if keyp(k) and #st.c<64 then st.c=st.c..schr(k+64) end
 end
 if Dbtnp(BTN_LEFT) and #st.c>0 then st.c=ssub(st.c,1,#st.c-1) end
 if Dbtnp(BTN_PRI) and #st.c>0 and #st.c%2==0 then
  local p=SYM_XLEXEC_Proc
  for i=1,#st.c,2 do
   XP[p]=tonumber(ssub(st.c,i,i+1),16)
   p=p+1
  end
  -- Ensure it ends in a RET statement
  XP[p]=X_OP_RET
  -- Execute it.
  X_Call(SYM_XLEXEC_Proc)
  return TRUE
 end
 return Dbtnp(BTN_SEC)
end

function DebugBuildDungeonWalls()
--[[
 local MC0,MR0,MC1,MR1,c,r=195,102,209,109
 local fn,fe,fs,fw,f
 local TI={
       -- Walls:
       -- N E S W
   27, -- 0 0 0 1
   10, -- 0 0 1 0
   11, -- 0 0 1 1
   25, -- 0 1 0 0
   68, -- 0 1 0 1
    9, -- 0 1 1 0
   70, -- 0 1 1 1
   42, -- 1 0 0 0
   43, -- 1 0 0 1
   67, -- 1 0 1 0
   71, -- 1 0 1 1
   41, -- 1 1 0 0
   72, -- 1 1 0 1
   69, -- 1 1 1 0
   90, -- 1 1 1 1
 }
 for c=MC0,MC1 do
  for r=MR0,MR1 do
   if mget(c,r)==0 then
    fn,fe,fs,fw=mget(c,r-1)==26,mget(c+1,r)==26,
     mget(c,r+1)==26,mget(c-1,r)==26
    f=(fn and 8 or 0)+(fe and 4 or 0)+(fs and 2 or 0)+(fw and 1 or 0)
    if TI[f] then mset(c,r,TI[f]) end
   end
  end
 end
 sync(4,0,true)
]]
end

function DebugIdentAll()
 for _,it in ipairs(P.inv) do
  it.st=it.st&~ITSF_UNIDENT
 end
 for _,ch in ipairs(PA) do
  for k,v in pairs(ch.eq) do
   if v then v.st=v.st&~ITSF_UNIDENT end
  end
 end
end

