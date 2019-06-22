-- XL Virtual Machine
-- This is a minimal VM that loads bytecodes from the cartridge
-- and executes them. The bytecode is assembled by the XL language
-- assembler (xlasm).

-- GLOBAL VARIABLES
-- Global variables are variable IDs 128 to 255. They are allocated
-- thus:
--     128 - 143: reserved for arguments and returns - 16 positions
--     144 - 207: unassigned - 64 positions
--     208 - 223: unassigned (used to be LPS)
--     224 - 255: GPS (Global Persistent State) - 32 positions
#define VID_ARG_START 128
#define VID_ARG_LEN 16
#define VID_GPS_START 224
#define VID_GPS_LEN 32
#define VID_GPS_END (VID_GPS_START+VID_GPS_LEN-1)

#define VID_ARG1 128
#define VID_ARG2 129
#define VID_ARG3 130
#define VID_ARG4 131
#define VID_ARG5 132
#define VID_ARG6 133
#define VID_ARG7 134
#define VID_ARG8 135
#define VID_ARG9 136
#define VID_ARG10 137
#define VID_ARG11 138
#define VID_ARG12 139
#define VID_ARG13 140
#define VID_ARG14 141
#define VID_ARG15 142
#define VID_ARG16 143

-- Global variables used for debug settings.
#define VID_DBG1  171
#define VID_DBG2  172
#define VID_DBG3  173
#define VID_DBG4  174
#define VID_DBG5  175
#define VID_DBG6  176

#define VID_GPS1 224
#define VAR_GPS1 _224
#define VID_GPS2 225
#define VAR_GPS2 _225
#define VID_GPS3 226
#define VAR_GPS3 _226
#define VID_GPS4 227
#define VAR_GPS4 _227
#define VID_GPS5 228
#define VAR_GPS5 _228
#define VID_GPS6 229
#define VAR_GPS6 _229
#define VID_GPS7 230
#define VAR_GPS7 _230
#define VID_GPS8 231
#define VAR_GPS8 _231
#define VID_GPS9 232
#define VAR_GPS9 _232
#define VID_GPS10 233
#define VAR_GPS10 _233
#define VID_GPS11 234
#define VAR_GPS11 _234
#define VID_GPS12 235
#define VAR_GPS12 _235
#define VID_GPS13 236
#define VAR_GPS13 _236
#define VID_GPS14 237
#define VAR_GPS14 _237
#define VID_GPS15 238
#define VAR_GPS15 _238
#define VID_GPS16 239
#define VAR_GPS16 _239
#define VID_GPS17 240
#define VAR_GPS17 _240
#define VID_GPS18 241
#define VAR_GPS18 _241
#define VID_GPS19 242
#define VAR_GPS19 _242
#define VID_GPS20 243
#define VAR_GPS20 _243
#define VID_GPS21 244
#define VAR_GPS21 _244
#define VID_GPS22 245
#define VAR_GPS22 _245
#define VID_GPS23 246
#define VAR_GPS23 _246
#define VID_GPS24 247
#define VAR_GPS24 _247
#define VID_GPS25 248
#define VAR_GPS25 _248
#define VID_GPS26 249
#define VAR_GPS26 _249
#define VID_GPS27 250
#define VAR_GPS27 _250
#define VID_GPS28 251
#define VAR_GPS28 _251
#define VID_GPS29 252
#define VAR_GPS29 _252
#define VID_GPS30 253
#define VAR_GPS30 _253
#define VID_GPS31 254
#define VAR_GPS31 _254
#define VID_GPS32 255
#define VAR_GPS32 _255

-- Convenience aliases (useful when reading strings as resources).
#define X_Str X_ReadString
#define X_Strs X_ReadStrings

-- Initializes the program, loading it from the cartridge. This
-- will require switching bank, so it must be done on a frame by
-- itself that has not yet bank switched.
-- Call X_InitLo() on one frame, then X_InitHi() on the next one.
function X_InitLo()
 BankSwitch(T80_SYNC_MAP,X_BIN_BANK_NUMBER_LO)
 -- Load the program from map memory into XP.
 -- Check the signature byte (if we are in the low segment)
 ast(peek(X_BIN_START) == 123, "XL sig");
 -- Load the program.
 -- NOTE: since we skip the signature byte, the first offset we
 -- load is 1, which is convenient because Lua arrays start at 1,
 -- so there's an exact correspondence between offset in binary
 -- and the index in the XP array.
 XP={}
 for addr=X_BIN_START+1,X_BIN_START+X_BIN_LENGTH-1 do
  insert(XP,peek(addr))
 end
 trace("XL init LO")
end

-- Finishes initialization that was started by X_InitLo()
function X_InitHi()
 ast(XP)
 BankSwitch(T80_SYNC_MAP,X_BIN_BANK_NUMBER_HI)
 for addr=X_BIN_START,X_BIN_START+X_BIN_LENGTH-1 do
  insert(XP,peek(addr))
 end
 trace("XL init HI")
 X_Reset()
end

-- Resets the VM. Call before starting a game.
function X_Reset()
 X=DeepCopy(X_INIT)
end

-- Set a global variable.
--   vid: the var ID. Must be >= 128 and <= 255 (the valid range
--        for global variable IDs).
--   v: the value to set. Must be a number.
function X_SetGlob(vid,v)
 ast(vid>=128 and vid <=255, "GVID "..vid)
 if vid>=VID_GPS_START and vid<=VID_GPS_END then
  -- Setting a value in the GPS.
  PS_SetGps(vid-VID_GPS_START+1,v)
 else
  X.globs[vid]=v
 end
end

function X_GetGlob(vid)
 ast(vid>=128 and vid <=255, "GVID "..vid)
 if vid>=VID_GPS_START and vid<=VID_GPS_END then
  -- Getting a value from the GPS.
  return PS_GetGps(vid-VID_GPS_START+1)
 else
  return X.globs[vid] or 0
 end
end

-- Calls a procedure given its address.
-- args: an array of arguments to pass to the procedure.
-- retcb: a callback to call when the given procedure returns.
--  This is asynchronous because the procedure may block on a
--  syscall and resume later.
function X_Call(addr,args,retcb)
 args=args or {}
 -- Calling a nil or 0 addr is valid, and is a no-op, and returns 0.
 if not addr or addr<1 then
  _=retcb and retcb(0,0,0)
  return
 end
 -- XL procedures receive parameters via global variables 128,129,...
 ast(#args<=VID_ARG_LEN,"#args")
 -- Zero out all arg variables before passing in ours, so that
 -- omitted args will be zero.
 XlClearArgs()
 for i=1,#args do X_SetGlob(VID_ARG_START+i-1,args[i]) end
 XlPushStackFrame()
 X_SetPc(addr)
 X.tframe.retcb=retcb
 XlRun()
end

-- Moves the instruction pointer to the given address
-- but don't execute anything. This can be done in preparation
-- to read program memory.
function X_SetPc(addr)
 ast(addr)
 local old=X.pc
 X.pc=addr
 return old
end

-- Fetches a byte from the program counter position and advances
-- the program counter.
function X_FetchB()
 X.pc=X.pc+1
 return XP[X.pc-1]
end

-- Reads sz bytes from the given address. If sz is nil, fetches a
-- byte to figure out the length, then fetches that many bytes.
function X_ReadBs(addr,sz)
 -- Read first byte as size, unless size was given, in which case don't
 sz,addr=sz or XP[addr],addr+(sz and 0 or 1)
 local r={}
 for i=1,sz do insert(r,XP[addr+i-1]) end
 return r
end

-- Fetches sz bytes. If sz is nil, fetches a byte to figure out the
-- length, then fetches that many bytes.
function X_FetchBs(sz)
 local r=X_ReadBs(X.pc,sz)
 X.pc=X.pc+#r+(sz and 0 or 1)
 return r
end

-- Fetches a word from the program counter position and advances
-- the program counter.
function X_FetchW()
 X.pc=X.pc+2
 return X_ReadW(X.pc-2)
end

-- Fetches a dword from the program counter position and advances
-- the program counter.
function X_FetchDW()
 X.pc=X.pc+4
 return X_ReadDW(X.pc-4)
end

-- Reads a word at a given address without changing program counter.
function X_ReadW(addr)
 return (XP[addr+1]*256)+XP[addr]
end

-- Reads a dword at a given address without changing program counter.
function X_ReadDW(addr)
 return X_ReadW(addr)+X_ReadW(addr+2)*256*256
end

-- Gets a string from the given address.
-- If the address is 0 (null), returns nil.
function X_ReadString(addr)
 local s,_=XlReadString(addr)
 return s
end

function X_FetchString()
 local r
 r,X.pc=XlReadString(X.pc)
 return r
end

-- Gets a string array from the given address.
-- If the address is 0 (null), returns nil.
function X_ReadStrings(addr)
 local s,_=XlReadStrings(addr)
 return s
end

function X_FetchStrings()
 local r
 r,X.pc=XlReadStrings(X.pc)
 return r
end

-- Syntactic sugar for getting arguments or return values.
function X_GetAllArgs()
 return XlGetVar(VID_ARG1),XlGetVar(VID_ARG2),XlGetVar(VID_ARG3),
   XlGetVar(VID_ARG4),XlGetVar(VID_ARG5),XlGetVar(VID_ARG6)
end

--END OF API-------------------------------------------------------
-------------------------------------------------------------------

-- Program bytes. Starts at 1 since address 0 in an XL program is
-- the signature byte, which we don't store in memory.
XP=nil

X=nil
X_INIT={
 -- Current program counter (address of next instruction to execute).
 pc=0,
 -- Stack frames. Each element in this array represents a procedure
 -- call in progress, and each of which has:
 --   vars: dictionary of local variables (var ID -> value).
 --         Local variables have IDs from 0 to 127.
 --   ret: the return address when popping this frame.
 --   bsysc: if not nil, this frame is blocked on an async system call
 --          and will resume when the system call returns. This is
 --          the ID of the system call (for error checking).
 --   bsyspc: program counter when resuming from system call.
 --   retcb: if not nil, this stack frame was invoked via an X_Call
 --          and this is the callback to call when the call returns.
 frames={},
 -- If not nil, we are currently servicing a system call (and this
 -- is the syscall number). We use this to guard against reentrantly
 -- doing X_Call while in the middle of servicing a system call.
 -- Note that this is nil is the system call INTENTIONALLY relinquishes
 -- execution via XlSysCallBlock to later resume it with
 -- XlSysCallResume. Between those, an X_Call to another XL procedure
 -- is allowed and the system is not considered to be "actively
 -- servicing a system call", so csysc will be null.
 csysc=nil,
 -- Convenience reference to the top (current) frame.
 tframe=nil,
 -- Global variables. Global variables are variables whose ID is > 127.
 globs={},
 -- Current comparison result (<0 is less, 0 equals, >0 greater).
 cmp=0,
}

function XlPushStackFrame()
 local s,f=X.frames,{vars={},ret=X.pc}
 insert(s,f)
 X.tframe=f
end
function XlPopStackFrame()
 local s,f=X.frames
 ast(#s>0)
 f=s[#s]
 -- Remove the frame.
 remove(s,#s)
 -- Return to the previous frame on the stack.
 X.tframe=s[#s]
 X.pc=f.ret
 -- If this frame has a return callback, invoke it.
 _=f.retcb and f.retcb(
   XlGetVar(VID_ARG1),XlGetVar(VID_ARG2),XlGetVar(VID_ARG3))
end

#define OP_RESULT_HALT 1
function XlRun()
 local op,h,r
 -- Can't reentrantly XlRun while servicing a system call (this would
 -- be a mistake that would lead to really strange stuff).
 -- The correct way to handle a sys call that requires execution to
 -- be suspended and then resumed is XlSysCallBlock and XlSysCallResume.
 ast(not X.csysc,"CSYSCRE"..(X.csysc or 0))
 while 1 do
  op,h=X_FetchB(),XlDoSysCall
  h=op>X_OP_SYSCALL_MAX and (XOP[op] or XOPF[op&0xf0]) or h
  ast(h,"!OPCODE "..op.." @"..(X.pc-1))
  r=h(op)
  if r==OP_RESULT_HALT or (X.tframe and X.tframe.bsysc) then
   -- End of execution. For now, at least. This may be because we
   -- are blocked on a system call and waiting to return.
   return
  end
 end
end

-- Gets a string from the given address. If the address is 0,
-- returns nil.
-- Also returns the address at the end of the string.
function XlReadString(ptr)
 if ptr<1 then return nil,ptr end
 local s,b=""
 -- The special representation 128 means an empty string.
 if XP[ptr]==128 then return "",ptr+1 end
 -- Each byte in memory represents a character (low 7 bits).
 -- A character with the high bit (8th bit) set means end of string.
 repeat b=XP[ptr] s=s..schr(b&127) ptr=ptr+1 until b>127
 return s,ptr
end

-- Gets a string array from the given address.
-- If the address is 0 (null), returns nil.
-- Also returns the address at the end of the string array.
function XlReadStrings(addr)
 if addr<1 then return nil end
 local count,r,s=XP[addr],{}
 addr=addr+1
 for i=1,count do
  s,addr=XlReadString(addr)
  insert(r,s)
 end
 return r,addr
end

function XlDoSysCall(sys)
 local r,f
 -- Mark that we are currently servicing this system call.
 X.csysc=sys
 -- Execute the correct syscall handler.
 f=XSYSC[sys]
 ast(f,"!sysc "..sys)
 r=f(sys)
 -- End of syscall.
 X.csysc=nil
 return r
end

-- Fetches a value in XL value format.
#define VFMT_LIT_BYTE 255
#define VFMT_LIT_WORD 254
#define VFMT_VAR_ID 253
function XlFetchVal()
 local fmt=X_FetchB()
 -- Special case: 242 - 252 means a variable ref from 1-10 (abbrev)
 if fmt>=243 and fmt<=252 then
  return XlGetVar(fmt-242)
 end
 -- If fmt is not any of the valid VFMT* constants, then it's
 -- just the value of a literal byte.
 return fmt==VFMT_LIT_BYTE and X_FetchB() or
   fmt==VFMT_LIT_WORD and X_FetchW() or 
   fmt==VFMT_VAR_ID and XlGetVar(X_FetchB()) or fmt
end

-- SET instruction (set variable to value).
function XlOpSet(op)
 local vid=X_FetchB()
 XlSetVar(vid,XlFetchVal())
end

-- Gets the value of a local or global variable.
function XlGetVar(vid)
 return vid>=128 and X_GetGlob(vid) or X.tframe.vars[vid] or 0
end
function XlSetVar(vid,v)
 ast(type(v)=="number","BADVT")
 if vid>=128 then
  -- Global variable.
  X_SetGlob(vid,v)
 else
  -- Local variable.
  X.tframe.vars[vid]=v
 end
end

function XlOpRet()
 XlPopStackFrame()
 -- If there is no frame in the stack, or if the top frame is blocked
 -- on a system call, halt.
 if not X.tframe or X.tframe.bsysc then
  return OP_RESULT_HALT
 end
end

-- Handles X_OP_CMP and X_OP_CMPZ
function XlOpCmp(op)
 local a=XlGetVar(X_FetchB())
 -- For X_OP_CMPZ, the comparison register is just the variable value,
 -- as we are comparing with 0.
 -- For X_OP_CMP, subtract the value of the immediate value so we are
 -- comparing against the immediate value.
 if op==X_OP_CMP then a=a-XlFetchVal() end
 X.cmp=a
end

function XlOpJmpOrCall(op)
 -- addr is the address of the jump or call
 -- isc is true iff it's a call instruction, else it's a jump
 -- instruction.
 local addr,isc=XlFetchVal(),op>=X_OP_CALL
 -- Calling address 0 is a no-op (like calling a null callback).
 if addr<1 and isc then return end
 -- Convert call opcode to corresponding jump opcode for simplification
 -- below, but we still know if it's a call or a jump (isc is true
 -- iff it's a call).
 op=op-(isc and X_CALL_JMP_OFFSET or 0)
 local cond=op==X_OP_JMP or
   (op==X_OP_JE and X.cmp==0) or (op==X_OP_JNE and X.cmp~=0) or 
   (op==X_OP_JG and X.cmp>0) or (op==X_OP_JGE and X.cmp>=0) or
   (op==X_OP_JL and X.cmp<0) or (op==X_OP_JLE and X.cmp<=0)
 if cond then
  -- If it's a call, we need to push the stack frame.
  _=isc and XlPushStackFrame()
  -- Then jump to target address.
  X.pc=addr
 end
end

function XlOpRnd(op)
 local vid,a,b
 vid=X_FetchB()
 a=XlFetchVal()
 b=XlFetchVal()
 XlSetVar(vid,random(a,b))
end

function XlOpEcho()
 trace("X @"..X.pc..": "..XlFetchVal())
end

function XlOpAndOrTest(op)
 local vid,msk,v=X_FetchB()
 msk=XlFetchVal()
 v=XlGetVar(vid)
 if op==X_OP_TEST then
  -- Result of the test is stored in X.cmp so that the program can
  -- follow with JE or JNE to check the result.
  X.cmp=v&msk
 else
  -- Apply OR or AND to the variable.
  -- If opcode is ANDC, we will AND with the complement of the
  -- variable.
  if op==X_OP_ANDC then msk=(~msk)&255 end
  XlSetVar(vid,op==X_OP_OR and (v|msk) or (v&msk))
 end
end

function XlClearArgs()
 -- Set all argument variables to zero.
 for i=VID_ARG_START,VID_ARG_START+VID_ARG_LEN-1 do XlSetVar(i,0) end
end

function XlOpSndN(op)
 local c=op-X_OP_SND0
 -- Fetch each argument value and put it in an argument var.
 XlClearArgs()
 for vid=VID_ARG_START,VID_ARG_START+c-1 do
  XlSetVar(vid,XlFetchVal())
 end
end

function XlOpRecN(op)
 local c,vid=op-X_OP_REC0
 -- Each argument gets assign to a given var.
 for i=1,c do
  vid=X_FetchB()
  XlSetVar(vid,XlGetVar(VID_ARG_START+i-1))
 end
end

function XlOpParN(op)
 local c=op-X_OP_PAR0
 -- Each argument gets assigned to a local variable, numbered from 1.
 for i=1,c do
  XlSetVar(i,XlGetVar(VID_ARG_START+i-1))
 end
end

-- ADD, SUB, MUL, DIV and MOD instructions.
-- For simplicity, these only operate on variables, not on immediates.
function XlOpArith(op)
 local li,lv,rv=X_FetchB()
 lv=XlGetVar(li)
 rv=XlFetchVal()
 XlSetVar(li,op==X_OP_ADD and lv+rv or op==X_OP_SUB and lv-rv or
  op==X_OP_MUL and lv*rv or op==X_OP_DIV and lv//rv or lv%rv)
end

-- REAB and REAW instructions (read byte/word from address).
function XlOpReaBW(op)
 local vid,a=X_FetchB()
 a=XlFetchVal()
 XlSetVar(vid,op==X_OP_REAB and XP[a] or X_ReadW(a))
end

-- Blocks the current stack frame in order to wait for a system
-- call to return. Returns the system call ID to use.
function XlSysCallBlock()
 -- Mark the frame as being blocked by a system call.
 X.tframe.bsysc=_XlSysCallBlock_nextId
 -- Save the program counter for when we return from the sys call.
 X.tframe.bsyspc=X.pc
 -- Generate an ID for this sys call.
 _XlSysCallBlock_nextId=1+_XlSysCallBlock_nextId
 return _XlSysCallBlock_nextId-1
end
#id _XlSysCallBlock_nextId
_XlSysCallBlock_nextId=1

-- Resumes execution after returning from a system call.
-- scid: the ID given by XlSysCallBlock() when execution blocked.
-- rets: the "return values" from the system call. Can be nil.
function XlSysCallResume(scid,rets)
 rets=rets or {}
 -- Check that the top frame is indeed blocked on this sys call.
 ast(X.tframe,"SYSCR1")
 ast(X.tframe.bsysc==scid,"SYSCR2")
 -- Now resume it.
 X.tframe.bsysc=nil
 -- Set the program counter to the resume address.
 X_SetPc(X.tframe.bsyspc)
 -- Set the return values.
 for i=1,#rets do XlSetVar(VID_ARG_START+i-1,rets[i]) end
 -- ...and run.
 XlRun()
end

-- SYSC_SPEAK system call.
function XlSysSpeak()
 local face,pname,pmsg,name,msg,scid
 face,pname,pmsg=X_GetAllArgs()
 name=X_ReadString(pname)
 msg=X_ReadStrings(pmsg)
 -- Block on system call. Will resume on callback.
 scid=XlSysCallBlock()
 UI_Speak(face,name,msg,function() XlSysCallResume(scid) end)
 return OP_RESULT_HALT
end

-- SYSC_GIVE system call.
function XlSysGive()
 local itid,st=X_GetAllArgs()
 _=itid>0 and P_GiveItems({IT_MakeItem(itid,st)})
end

-- SYSC_CHANGE_LVL system call.
function XlSysChangeLvl()
 local lvlN,epnum=X_GetAllArgs()
 A_Enq(function(st,isFg) _=isFg and G_ChangeLvl(lvlN,epnum>1 and epnum or 1) return TRUE end)
end

-- SYSC_CHOICE system call.
function XlSysChoice()
 local pmsg,popts,fl=X_GetAllArgs()
 local msg,opts,scid=X_ReadStrings(pmsg),X_ReadStrings(popts),
   -- Block on sys call. Will resume on callback.
   XlSysCallBlock()
 ChoiceDialog(msg,opts,_XlSysChoiceCb,C_WHITE,C_BLUE,scid,fl)
 return OP_RESULT_HALT
end
function _XlSysChoiceCb(ch,scid)
 -- Invoke callback proc.
 XlSysCallResume(scid,{ch or 0})
end

-- SYSC_GET_ITEM_COUNT system call.
function XlSysGetItemCount()
 local itid=XlGetVar(VID_ARG1)
 XlSetVar(VID_ARG1,P_GetItemCount(itid))
end

-- SYSC_ALERT system call.
function XlSysAlert()
 local msg,scid=X_ReadStrings(XlGetVar(VID_ARG1)),XlSysCallBlock()
 Alert(msg,C_WHITE,C_BLUE,nil,
  function() XlSysCallResume(scid,{}) end)
 return OP_RESULT_HALT
end

--[[
-- SYSC_RAND_PICK system call.
function XlSysRandPick()
 local addr=XlGetVar(VID_ARG1)
 local len=XP[addr]
 XlSetVar(VID_ARG1, XP[addr+random(1,len)])
end
]]

-- SYSC_RANDOM_LOOT system call.
function XlSysRandomLoot() LO_Give(XlGetVar(VID_ARG1)) end

-- SYSC_GIVE_GOLD system call.
function XlSysGiveGold()
 -- Use an action because other things may already be in the queue,
 -- and this should go after.
 local g=XlGetVar(VID_ARG1)
 A_Enq(function(st,isFg) _=isFg and P_GiveGold(g) return TRUE end)
end

-- SYSC_REMOVE_ITEM system call.
function XlSysRemoveItem()
 local itid,idx=X_GetAllArgs()
 XlSetVar(VID_ARG1,BoolToNum(P_RemoveItem(itid,idx>0 and idx or nil)))
end

function XlSysKillTile()
 local xz,c,r=XlGetVar(VID_ARG1)
 c,r=L_RawToLevelCoords(xz%256,xz//256)
 L_KillTile(c,r)
end

function XlSysTileInfo()
 local xz,fi=X_GetAllArgs()
 local c,r,v,ti=L_RawToLevelCoords(xz%256,xz//256)
 ti=L_GetTile(c,r)
 if fi==TINFO_IS_SOLID then
  v=BoolToNum(L_IsTileSolid(c,r))
 elseif fi==TINFO_IS_KILLED then
  v=BoolToNum(L_IsTileKilled(c,r))
 elseif fi==TINFO_FLAGS then
  v=ti and ti.td.flags or TF_SOLID
 elseif fi==TINFO_SID then
  v=ti and ti.sid or 0
 else error("!TI"..fi) end
 XlSetVar(VID_ARG1,v)
end

function XlSysBuy()
 local ptr,m=X_GetAllArgs()
 local n,itids=XP[ptr],{}
 for i=1,n do insert(itids,XP[ptr+i]) end
 UI_Buy(itids,m*0.01)
end

function XlSysSell()
 local ks,k={}
 for i=VID_ARG1,VID_ARG8 do
  k=XlGetVar(i)
  _=k>0 and insert(ks,k)
 end
 UI_Sell(ks)
end

function XlSysSfx() SFX_Play(XlGetVar(VID_ARG1)) end

function XlSysGiveXp()
 local amt,mult=X_GetAllArgs()
 A_Enq(function(st,isFg) _=isFg and P_GiveXp(amt*max(mult,1)) return TRUE end)
end

function XlSysAskWho()
 local pt,pmsg,fl,wfl=X_GetAllArgs()
 local t,msg,scid=X_ReadString(pt),X_ReadStrings(pmsg),
   -- Block on sys call. Will resume on callback.
   XlSysCallBlock()
 P_AskWho(t,msg,_XlSysAskWhoCb,scid,fl,wfl)
 return OP_RESULT_HALT
end
function _XlSysAskWhoCb(ch,scid)
 XlSysCallResume(scid,{ch or 0})
end
 
function XlSysSave() P_Save() end

function XlSysLearnSpell() P_LearnSpell(XlGetVar(VID_ARG1)) end

-- SYSC_CHOOSE_EQUIPPED system call.
function XlSysChooseEquipped()
 local chi,pmsg=X_GetAllArgs()
 -- Block on sys call:
 local msg,scid=X_ReadString(pmsg),XlSysCallBlock()
 ast(chi>=1)
 UI_ChooseEquipped(chi,msg,
  function(k) XlSysCallResume(scid,{k or 0}) end)
 -- Halt. Wait for syscall return, then resume.
 return OP_RESULT_HALT
end

-- Name of character fields queried by the SYSC_CINFO
-- system call:
#id CINFO_FIELDS
CINFO_FIELDS={
 [CINFO_CLASS]="class",
 [CINFO_HP]="hp",
 [CINFO_MAX_HP]="maxHp",
 [CINFO_SP]="sp",
 [CINFO_MAX_SP]="maxSp",
 [CINFO_ATT]="att",
 [CINFO_SPEED]="speed",
 [CINFO_FACE]="face",
}
#id CINFO_WRITABLE
CINFO_WRITABLE={CINFO_HP,CINFO_MAX_HP,CINFO_SP,CINFO_MAX_SP,
 CINFO_ATT,CINFO_SPEED,CINFO_FACE}

-- Get/set char info (SYSC_CINFO and SYSC_SET_CINFO sys calls).
function XlSysCharInfo(op)
 local chi,f,newv=X_GetAllArgs()
 local c,fn,v1,v2,v3=PA[chi],CINFO_FIELDS[f],0,0,0
 ast(c,"!SYCI")
 if f==CINFO_IS_ACTIVE then
  v1=BoolToNum(P_IsCharActive(chi))
 elseif f==CINFO_EFF_ATT_DEF_SPEED then
  v1,v2=P_GetAttDef(c)
  v3=P_GetSpeed(c)
 else
  v1=c[fn]
  ast(fn and v1,"SYCI2")
 end
 -- If the sys call is SYSC_SET_CINFO, set the value.
 if op==SYSC_SET_CINFO then
  ast(ListFind(CINFO_WRITABLE,f),"SYCI3/"..f)
  c[fn]=Clamp(newv,0,255)
 end
 XlSetVar(VID_ARG1,v1)
 XlSetVar(VID_ARG2,v2)
 XlSetVar(VID_ARG3,v3)
end

-- SYSC_CHAR_EQ or SYSC_SET_CHAR_EQ system calls.
function XlSysCharEq(op)
 local chi,k,ni,nst=X_GetAllArgs()
 local c=PA[chi]
 ast(c,"!SYCE")
 XlSetVar(VID_ARG1,c.eq[k] and c.eq[k].itid or 0)
 XlSetVar(VID_ARG2,c.eq[k] and c.eq[k].st or 0)
 -- If it's SYSC_SET_CHAR_EQ, write to c.eq
 if op==SYSC_SET_CHAR_EQ then c.eq[k]=ni>0 and IT_MakeItem(ni,nst) or nil end
end

-- SYSC_PAY system call.
function XlSysPay()
 -- text pointer, message pointer, cost.
 local pmsg,c,fl=X_GetAllArgs()
 local msg,scid=X_ReadStrings(pmsg),
   -- Block on sys call.
   XlSysCallBlock()
 UI_Pay(msg,c,_XlSysPayCb,scid,fl)
 return OP_RESULT_HALT
end
function _XlSysPayCb(a,scid) XlSysCallResume(scid,{a}) end

-- SYSC_LEVEL_UP sys call.
function XlSysLevelUp() P_LevelUp() end

-- SYSC_CHANGE_SID sys call.
function XlSysChangeSid()
 local xz,sid=X_GetAllArgs()
 local c,r=L_RawToLevelCoords(xz%256,xz//256)
 L_ChangeSid(c,r,sid)
end

#id PINFO_FIELDS
PINFO_FIELDS={
 [PINFO_XP]="xp",
 [PINFO_LEVEL]="level",
 [PINFO_PCLK]="pclk",
 [PINFO_GOLD]="gold",
}
-- SYSC_PINFO and SYSC_SET_PINFO sys calls
function XlSysPinfo(sc)
 local f,v,fn,v2,mc,mr
 f,v,v2=X_GetAllArgs()
 if f==PINFO_NUM_CHARS then
  XlSetVar(VID_ARG1,#PA)
 elseif f==PINFO_XZDIR then
  mc,mr=L_LevelToRawCoords(P.x,P.z)
  XlSetVar(VID_ARG1,mc+mr*256)
  XlSetVar(VID_ARG2,P.dir)
  if sc==SYSC_SET_PINFO then
   P.x,P.z=L_RawToLevelCoords(v%256,v//256)
   P.dir=v2
  end
 elseif f==PINFO_ELIGIBLE then 
  XlSetVar(VID_ARG1,BoolToNum(P_IsEligibleToLevelUp()))
 elseif f==PINFO_XP_FOR_NEXT then
  XlSetVar(VID_ARG1,P_GetXpForLevel(P.level+1))
 elseif f==PINFO_NET_WORTH then
  XlSetVar(VID_ARG1,P_CalcNetWorth())
 else
  fn=PINFO_FIELDS[f]
  ast(fn,"!SYS_PI/"..f)
  P[fn]=sc==SYSC_SET_PINFO and v or P[fn]
  XlSetVar(VID_ARG1,P[fn])
 end
end

#id LINFO_FIELDS
LINFO_FIELDS={
 [LINFO_IPROC]="iproc",
 [LINFO_UPROC]="uproc",
 [LINFO_WPROC]="wproc",
 [LINFO_BPROC]="bproc",
 [LINFO_FLAGS]="flags",
}

-- SYSC_LINFO sys call (level info)
function XlSysLevelInfo()
 local f,fn,v
 f=X_GetAllArgs()
 fn=LINFO_FIELDS[f]
 ast(fn,"LIN"..f)
 v=L.lvl[fn]
 ast(v,"LINV"..fn)
 XlSetVar(VID_ARG1,v)
end

function XlSysHeal()
 local chi,hp,sp=X_GetAllArgs()
 P_Heal(chi>0 and chi or nil,hp,sp)
end

function XlSysBattleAttack()
--  ak: the kind of attack (BAT_AK_*)
--  att: the attack score
--  narr: the narration string to use
--  psp: the projectile sprite to use
--  fl: flags
 local ak,att,n,p,fl=X_GetAllArgs()
 B_ReqAttack({ -- BatAttackDef
   ak=ak,att=att,narr=X_Str(n),psp=p,fl=fl})
end

function XlSysRect()
 local x,y,w,h,c,fl=X_GetAllArgs()
 local fun=fl&RECTF_DECO>0 and DecoRect or
   (fl&RECTF_BORDER>0 and rectb or rect)
 fun(x,y,w,h,c)
end

function XlSysPrint()
 local x,y,txt,c,f=X_GetAllArgs()
 prn(f&PRNF_NUMBER>0 and txt or XlReadString(txt),x,y,c,PRN_MONOSPACE)
end

function XlSysBattle()
 local es,eid,vst
 es={}
 -- Create the requested entities.
 for i=0,5 do
  eid=XlGetVar(VID_ARG1+i)
  if eid<1 then break end
  insert(es,E_Create(eid))
 end
 -- The 7th argument is the battle's visual style
 -- 0 for default.
 vst=XlGetVar(VID_ARG7)
 -- Launch battle.
 -- Use the level's prescribed visual style if one was not
 -- specified (that is, if vst == 0).
 -- Note that we have to launch the battle via action and not
 -- synchronously because B_Launch will want to do X_Call, and we
 -- can't be in the middle of a sys call (SYSC_BATTLE) when that
 -- happens (X_Call is not allowed while actively servicing a sys
 -- call).
 A_Enq(function(st,isf)
   if not isf then return end
   B_Launch(es,vst>0 and vst or L.lvl.bsn) return TRUE end,{})
end

-- SYSC_SET_LIGHT system call.
function XlSysSetLight() R_SetLight(XlGetVar(VID_ARG1)) end

-- SYSC_SPR system call.
function XlSysSpr()
 local sid,x,y=X_GetAllArgs()
 spr(sid,x,y,0)
end

-- SYSC_ADD_CHAR system call.
function XlSysAddChar() P_AddChar(XlGetVar(VID_ARG1)) end

-- SYSC_BLINK system call.
--   chi: Who to blink, 0 for all.
--   msg: Message to display.
--   clr: Color to use.
--   sfx: Sound effect, 0 for none.
function XlSysBlink()
 local chi,msg,clr,sfx=X_GetAllArgs()
 P_BlinkChar(NilIf0(chi),clr,XlReadString(msg),NilIf0(sfx))
end

-- SYSC_HAS_SPELL system call.
function XlSysHasSpell()
 local zid=X_GetAllArgs()
 XlSetVar(VID_ARG1,0)
 for i,c in ipairs(PA) do
  _=ListFind(c.zs,zid) and XlSetVar(VID_ARG1,1)
 end
end

-- SYSC_SET_LVLT system call.
function XlSysSetLvlT()
 L.lvl.lvlt=XlReadString(XlGetVar(VID_ARG1))
end

-- SYSC_REPLACE_SID system call
function XlSysReplaceSid()
 -- From and To sids:
 local f,t=X_GetAllArgs()
 for lc=0,L.lvl.mcols-1 do
  for lr=0,L.lvl.mrows-1 do
   if L_GetTile(lc,lr).sid==f then
    L_ChangeSid(lc,lr,t)
   end
  end
 end
end

-- SYSC_SHOW_ITEM_INFO system call
function XlSysShowItemInfo()
 local itid,st=X_GetAllArgs()
 Alert(IT_GetDetails({itid=itid,st=st}))
end

function XlSysChooseInv()
 -- Block on sys call. Will resume on callback.
 local scid=XlSysCallBlock()
 P_ChooseItem("Item?",nil,0,"No items",FALSE,function(it,r)
  XlSysCallResume(scid,{it and ListFind(P.inv,it) or 0})
 end)
 return OP_RESULT_HALT
end

function XlSysGetSetInv(op)
 local idx,itid,st=X_GetAllArgs()
 local it=P.inv[idx]
 ast(it,"GSI0")
 if op==SYSC_SET_INV then
  ast(itid>0,"GSI1")
  it.itid,it.st=itid,st
 end
 XlSetVar(VID_ARG1,it.itid)
 XlSetVar(VID_ARG2,it.st)
end

function XlSysCastSpell(op)
 local chi,zid=X_GetAllArgs()
 -- Block on sys call. Will resume on spell callback.
 local scid=XlSysCallBlock()
 -- Use A_Enq because otherwise it would reentrantly call
 -- X_Call while servicing a sys call, which XLVM doesn't like,
 -- for reasons I forget.
 A_Enq(function(st,fg)
  _=fg and Z_CastSpell(chi,zid,function(r)
   XlSetVar(VID_ARG1,r and 1 or 0)
   XlSysCallResume(scid)
  end)
  return TRUE
 end,{},AF_MODAL)
end

function XlSysRemChar(op)
 local chi=XlGetVar(VID_ARG1)
 if PA[chi] then remove(PA,chi) end
end

function XlSysWin()
 G_Win(XlGetVar(VID_ARG1))
end

function XlSysInflict()
 local chi,cm=X_GetAllArgs()
 P_Inflict(chi,cm)
end

function XlSysCutScene()
 G_LaunchCutScene(XlGetVar(VID_ARG1))
end

function XlSysDebug()
 D_DebugCmd(XlGetVar(VID_ARG1))
end

-- Opcode handler table.
XOP={
 [X_OP_SET]=XlOpSet,
 [X_OP_RET]=XlOpRet,
 [X_OP_CMP]=XlOpCmp,
 [X_OP_CMPZ]=XlOpCmp,
 [X_OP_JMP]=XlOpJmpOrCall,
 [X_OP_JE]=XlOpJmpOrCall,
 [X_OP_JNE]=XlOpJmpOrCall,
 [X_OP_JG]=XlOpJmpOrCall,
 [X_OP_JGE]=XlOpJmpOrCall,
 [X_OP_JL]=XlOpJmpOrCall,
 [X_OP_JLE]=XlOpJmpOrCall,
 [X_OP_CALL]=XlOpJmpOrCall,
 [X_OP_CE]=XlOpJmpOrCall,
 [X_OP_CNE]=XlOpJmpOrCall,
 [X_OP_CG]=XlOpJmpOrCall,
 [X_OP_CGE]=XlOpJmpOrCall,
 [X_OP_CL]=XlOpJmpOrCall,
 [X_OP_CLE]=XlOpJmpOrCall,
 [X_OP_RND]=XlOpRnd,
 [X_OP_ECHO]=XlOpEcho,
 [X_OP_ANDC]=XlOpAndOrTest,
 [X_OP_OR]=XlOpAndOrTest,
 [X_OP_AND]=XlOpAndOrTest,
 [X_OP_TEST]=XlOpAndOrTest,
 [X_OP_ADD]=XlOpArith,
 [X_OP_SUB]=XlOpArith,
 [X_OP_MUL]=XlOpArith,
 [X_OP_DIV]=XlOpArith,
 [X_OP_MOD]=XlOpArith,
 [X_OP_REAB]=XlOpReaBW,
 [X_OP_REAW]=XlOpReaBW,
}

-- Instruction family handler table
XOPF={
 [X_OP_SND0]=XlOpSndN,
 [X_OP_REC0]=XlOpRecN,
 [X_OP_PAR0]=XlOpParN,
}

-- OPCODEs. Keep this in sync with the assembler script (xlasm).
#define X_OP_SYSCALL_MIN 60
#define X_OP_SYSCALL_MAX 119
#define X_OP_SET 124
#define X_OP_RET 125
#define X_OP_CMP 126
#define X_OP_RND 127
#define X_OP_ECHO 128
#define X_OP_ANDC 129
#define X_OP_OR 130
#define X_OP_AND 131
#define X_OP_TEST 132
#define X_OP_ADD 134
#define X_OP_SUB 135
#define X_OP_MUL 136
#define X_OP_DIV 137
#define X_OP_MOD 138
#define X_OP_REAB 139
#define X_OP_REAW 140
-- Opcodes 144-159 are SND0..SND15
#define X_OP_SND0 144
#define X_OP_SND15 159
 -- Opcodes 160-175 are REC0..REC15
#define X_OP_REC0 160
#define X_OP_REC15 175
-- Opcodes 176-191 are PAR0..PAR15
#define X_OP_PAR0 176
#define X_OP_PAR15 191

-- NOTE: if you change the opcode for jump instructions, update
-- the opcodes for call instructions below.
#define X_OP_JMP 212
#define X_OP_JE 213
#define X_OP_JNE 214
#define X_OP_JG 215
#define X_OP_JGE 216
#define X_OP_JL 217
#define X_OP_JLE 218
-- All conditional call instructions must be offset from their
-- corresponding conditional jump instructions by X_CALL_JMP_OFFSET
-- Also, the code assumes all call instructions have GREATER opcodes
-- than the corresponding jump instructions (see XlOpJmpOrCall).
    #define X_CALL_JMP_OFFSET 7
#define X_OP_CALL 219
#define X_OP_CE 220
#define X_OP_CNE 221
#define X_OP_CG 222
#define X_OP_CGE 223
#define X_OP_CL 224
#define X_OP_CLE 225
#define X_OP_CMPZ 226

#define X_BIN_BANK_NUMBER_LO 6
#define X_BIN_BANK_NUMBER_HI 7

#define X_BIN_START 0x8000
#define X_BIN_LENGTH 32640

-- System calls.

-- NPC or character Speak routine.
--  Args:
--    face (byte): sprite ID of NPC face. If this is 1-4, then
--      it's a character speaking (in which case the speech balloon
--      will be rendered close to the character's face).
--    name (str*): address of name of the NPC. Ignored for characters.
--    msg (str[]*): address of text lines to speak.  
--    cb (proc*): Callback to call when done speaking. 0 if none.
#define SYSC_SPEAK 61
-- Give item.
--  Args:
--    itid (byte): Item ID of item to give.
#define SYSC_GIVE 62
-- Change level.
--  Args:
--   lvlN (byte): level number to go to.
--   epnum (byte): index of the entry point to use.
#define SYSC_CHANGE_LVL 63
-- Choice dialog.
-- Args:
--  text (str[]*): address of text string array.
--  choice (str[]*): address of choice strings.
--  flags: the flags to pass, e.g. CHD_F_CANCELABLE to make
--    the choice dialog cancelable.
-- The callback will be called with the choice# as argument,
-- or 0 if the dialog was canceled (assuming it was specified
-- as cancelable).
#define SYSC_CHOICE 64
-- Gets the count of particular item in the inventory.
-- Args:
--  ITID (the item ID to count).
-- Returns:
--  count of given item in inventory
#define SYSC_GET_ITEM_COUNT 65
-- Shows a message to the user.
-- Args:
--  msg (str[]*): address of text string array.
#define SYSC_ALERT 66
-- Select random byte from an array of bytes.
-- Args:
--   ptr (*): address of an array of bytes, where the first
--     byte is the length of the array.
--#define SYSC_RAND_PICK 7
-- Give gold.
-- Args: amount of gold.
#define SYSC_GIVE_GOLD 68
-- Give random loot (items + gold).
-- Args:
--   val: target total value to give the player.
#define SYSC_RANDOM_LOOT 69
-- Remove an item from the inventory given its ITID.
-- Args:
--   itid: the ITID of the item to remove
--   idx: if supplied (>0), this is the index of the inventory
--     item to remove. If not supplied (0), an arbitrary instance
--     of the ITID will be removed from the inventory.
-- Returns 1 if the item was removed, 0 if not found.
#define SYSC_REMOVE_ITEM 70
-- Kill a tile.
-- That is, set the kill flag of the tile to TRUE.
-- Args:
--   xz (word) the coords of the tile as a word.
#define SYSC_KILL_TILE 71
-- Offer things for the player to buy.
-- Args:
--  ptr (*): address of an array of ITIDs of items for sale,
--     where the first byte is the length of the array.
--  mult: cost multiplier (/100). So 100 is normal
--     price, 200 would be twice the normal price.
#define SYSC_BUY 72
-- Lets the player sell things of specific kinds.
-- Args:
--  itk1: item kind 1 (ITK_*)
--  itk2: item kind 2, 0 if none
--  itk3: item kind 3, 0 if none
--  ...
--  itk8: item kind 8, 0 if none
#define SYSC_SELL 73
-- Plays SFX.
-- Args: sfx (byte)
#define SYSC_SFX 74
-- Give XP.
-- Args: amount mult
--  Will give amount*mult XP to the party
--  For convenience, if mult==0 then mult will be interpreted as 1.
#define SYSC_GIVE_XP 75
-- Save game.
#define SYSC_SAVE 76
-- Ask which character will do something.
-- Args:
--  title (str*)
--  msg (str[]*)
--  flags (e.g. CHD_F_CANCELABLE)
-- Returns the chosen character index, or 0 if cancelled.
#define SYSC_ASK_WHO 77
-- Get character info.
-- Args:
--  chi: the character index
--  what: the desired field (CINFO_*)
-- Returns the requested value.
#define SYSC_CINFO 78
  -- Character's class.
  #define CINFO_CLASS 1
  -- Current hit points.
  #define CINFO_HP 2
  -- Max hit points
  #define CINFO_MAX_HP 3
  -- Attack score (raw).
  #define CINFO_ATT 4
  -- Current spell points.
  #define CINFO_SP 5
  -- Max spell points.
  #define CINFO_MAX_SP 6
  -- Speed score.
  #define CINFO_SPEED 7
  -- Is active?
  #define CINFO_IS_ACTIVE 8
  -- Computed (effective) attack, defense,speed scores,
  -- taking all items into account.
  #define CINFO_EFF_ATT_DEF_SPEED 9
  -- Character face
  #define CINFO_FACE 10

-- Prompt for payment.
-- Args:
--   title (str*)
--   msg (str[]*)
--   price (int)
--   flags (PAYF_*)
-- Returns 1 if paid, 0 if not paid/declined/not enough gold.
#define SYSC_PAY 79
-- Levels up the party.
#define SYSC_LEVEL_UP 80
-- Grants a spell.
-- Args: zid: the ZID of the spell.
#define SYSC_LEARN_SPELL 82
-- Queries the kill flag of a tile.
-- Args:
--   xz (word): the raw coords of the tile as a word.
--   field: (one of the TINFO_* constants).
#define SYSC_TINFO 83
  -- Possible tile info queries:
  #define TINFO_IS_KILLED 1
  #define TINFO_IS_SOLID 2
  #define TINFO_FLAGS 3
  #define TINFO_SID 4
-- Set character info.
-- Args:
--  chi: the character index
--  what: the desired field (CINFO_*)
--  newv: the new value for the field.
#define SYSC_SET_CINFO 84
-- Changes the SID of a tile on the map.
-- Caution must be exercised when using this: only change SIDs
-- of static tiles, not killable/overlays/etc, or weird stuff can
-- happen.
-- Args:
--  rawcr: The raw col/row of the tile whose SID is to be changed.
--  sid: The new SID of the tile.
#define SYSC_CHANGE_SID 86
-- Gets a field in the party (like P.light, etc).
-- Args:
--  field: the field to get (PINFO_*)
#define SYSC_PINFO 87
  #define PINFO_XZDIR 1
  #define PINFO_XP 2
  #define PINFO_LEVEL 3
  #define PINFO_ELIGIBLE 4
  #define PINFO_PCLK 5
  #define PINFO_NUM_CHARS 6
  #define PINFO_GOLD 7
  #define PINFO_XP_FOR_NEXT 8
  #define PINFO_NET_WORTH 9
-- Sets a field in the party (like P.light, etc).
-- Args:
--  field: the field to set (PINFO_*)
--  new_value: the new value of the field.
#define SYSC_SET_PINFO 88
-- Heal (hp or sp).
-- Args:
--  chi: whom to heal (0 = all)
--  hp: how many HP to heal.
--  sp: how many SP to heal.
#define SYSC_HEAL 90
-- Requests a melee attack (this must be done in melee, obviously).
-- Args:
--  ak: the kind of attack (BAT_AK_*)
--  att: the attack score of the attack
--  narr: the narration string to use
--  psp: the projectile sprite to use
--  fl: flags (BAT_AF_*)
#define SYSC_BATTLE_ATTACK 91
-- Draws/fills a rectangle.
-- Args:
--  x0: screen x0 of rectangle.
--  y0: screen y0 of rectangle.
--  w: width of rectangle.
--  h: height of rectangle.
--  color: color of rectangle.
--  flags: flags (RECTF_*)
#define SYSC_RECT 92
 -- If passed, indicates that the rectangle should be stroked,
 -- not filled.
 #define RECTF_BORDER 1
 -- If passed, rectangle will be decorated with fancy borders.
 #define RECTF_DECO 2
-- Prints text.
-- Args:
--  x: x coordinate
--  y: y coordinate
--  text (str*): string to print
--  color: color to print with
--  flags: flags (PRNF_)
#define SYSC_PRINT 93
  -- If set, treats text as a number, not a pointer.
  #define PRNF_NUMBER 1
-- Launches battle.
-- Args:
--  eid1, eid2, eid3, eid4, eid5, eid6, vst
--  The EID of the enemies to battle (1 to 6 enemies).
--  vst: battle's visual style, 0 is default.
#define SYSC_BATTLE 94
-- Gets info about current level.
-- Args:
--  field: one of LINFO_*
#define SYSC_LINFO 95
  #define LINFO_IPROC 1
  #define LINFO_UPROC 2
  #define LINFO_WPROC 3
  #define LINFO_BPROC 4
  #define LINFO_FLAGS 5
-- Set rendering lighting.
-- Args:
--   light: LIGHT_LIMITED, LIGHT_NONE or LIGHT_FULL
#define SYSC_SET_LIGHT 96
-- Draws a sprite.
-- Args:
--   spr: the sprite ID to draw
--   x: the screen X coordinate
--   y: the screen Y coordinate
#define SYSC_SPR 97
-- Adds a character to the party.
-- Args:
--   ptr: Pointer to the character data.
#define SYSC_ADD_CHAR 98
-- Blinks the given char, or the whole party.
-- Args:
--   chi: Who to blink, 0 for all.
--   msg: Message to display.
--   clr: Color to use.
--   sfx: Sound effect, 0 for none.
#define SYSC_BLINK 99
-- Checks if any of the player characters
-- have the given spell.
-- Args:
--   zid: the ZID of the spell to check.
-- Returns:
--   1 if has spell, 0 if not.
#define SYSC_HAS_SPELL 100
-- Gets equipped item.
-- Args:
--   chi: index of character
--   itk: equipment item kind (e.g. ITK_ARMOR)
#define SYSC_CHAR_EQ 101
-- Sets equipped item.
-- Args:
--   chi: index of character
--   itk: equipment item kind (e.g. ITK_ARMOR)
--   nitid: ITID of new item
--   nst: state byte of new item
#define SYSC_SET_CHAR_EQ 102
-- Shows world map.
#define SYSC_WORLD_MAP 103
-- Set level title.
-- Args:
--   lvlt: (string) the new title
#define SYSC_SET_LVLT 104
-- Replace SIDs in whole map.
--   from_sid: the sid to replace
--   to_sid: the sid to replace by
#define SYSC_REPLACE_SID 105
-- Asks player to pick an equipped item of a character.
--   chi: the index of the character
--   msg: the message to show.
#define SYSC_CHOOSE_EQUIPPED 106
-- Displays details about the given item.
--  itid: the item's ITID
--  st: item's state byte.
#define SYSC_SHOW_ITEM_INFO 107
-- Choose an item from the inventory.
--  Returns: index of inventory item selected, 0 if cancelled.
#define SYSC_CHOOSE_INV 108
-- Get inventory item.
--  idx: the index of the item.
-- Returns (itid, st) - the item.
#define SYSC_GET_INV 109
-- Set inventory item.
--  idx: the index of the item.
--  itid: the itid to set.
--  st: the state byte to set.
#define SYSC_SET_INV 110
-- Casts a spell.
--  chi: who is casting
--  zid: ZID of the spell being cast
#define SYSC_CAST_SPELL 111
-- Remove a character from the party.
#define SYSC_REM_CHAR 112
-- Win the game
--  endn: ending# (ENDN_*)
#define SYSC_WIN 113
  #define ENDN_EVIL 0
  #define ENDN_GOOD 1
-- Inflict a condition on the given character,
-- if they are not resistant to it.
--   chi: the character on whom to inflict, 0 for all
--   cm: the CEF mask (e.g. CEF_POISON)
#define SYSC_INFLICT 114
-- Show a "cut scene".
--   n: scene#
#define SYSC_CUTSCENE 115
-- Debug instruction
#define SYSC_DEBUG 116
-- NOTE: LIMIT IS 119

-- Syscall handler table.
XSYSC={
 [SYSC_SPEAK]=XlSysSpeak,
 [SYSC_GIVE]=XlSysGive,
 [SYSC_CHANGE_LVL]=XlSysChangeLvl,
 [SYSC_CHOICE]=XlSysChoice,
 [SYSC_GET_ITEM_COUNT]=XlSysGetItemCount,
 [SYSC_ALERT]=XlSysAlert,
 --[SYSC_RAND_PICK]=XlSysRandPick,
 [SYSC_GIVE_GOLD]=XlSysGiveGold,
 [SYSC_RANDOM_LOOT]=XlSysRandomLoot,
 [SYSC_REMOVE_ITEM]=XlSysRemoveItem,
 [SYSC_KILL_TILE]=XlSysKillTile,
 [SYSC_BUY]=XlSysBuy, 
 [SYSC_SELL]=XlSysSell,
 [SYSC_SFX]=XlSysSfx,
 [SYSC_GIVE_XP]=XlSysGiveXp,
 [SYSC_SAVE]=XlSysSave,
 [SYSC_ASK_WHO]=XlSysAskWho,
 [SYSC_CINFO]=XlSysCharInfo,
 [SYSC_PAY]=XlSysPay,
 [SYSC_LEVEL_UP]=XlSysLevelUp,
 [SYSC_LEARN_SPELL]=XlSysLearnSpell,
 [SYSC_TINFO]=XlSysTileInfo,
 [SYSC_SET_CINFO]=XlSysCharInfo,
 [SYSC_CHANGE_SID]=XlSysChangeSid,
 [SYSC_PINFO]=XlSysPinfo,
 [SYSC_SET_PINFO]=XlSysPinfo,
 [SYSC_HEAL]=XlSysHeal,
 [SYSC_BATTLE_ATTACK]=XlSysBattleAttack,
 [SYSC_RECT]=XlSysRect,
 [SYSC_PRINT]=XlSysPrint,
 [SYSC_BATTLE]=XlSysBattle,
 [SYSC_LINFO]=XlSysLevelInfo,
 [SYSC_SET_LIGHT]=XlSysSetLight,
 [SYSC_SPR]=XlSysSpr,
 [SYSC_ADD_CHAR]=XlSysAddChar,
 [SYSC_BLINK]=XlSysBlink,
 [SYSC_HAS_SPELL]=XlSysHasSpell,
 [SYSC_CHAR_EQ]=XlSysCharEq,
 [SYSC_SET_CHAR_EQ]=XlSysCharEq,
 [SYSC_WORLD_MAP]=G_ShowWorldMap,
 [SYSC_SET_LVLT]=XlSysSetLvlT,
 [SYSC_REPLACE_SID]=XlSysReplaceSid,
 [SYSC_CHOOSE_EQUIPPED]=XlSysChooseEquipped,
 [SYSC_SHOW_ITEM_INFO]=XlSysShowItemInfo,
 [SYSC_CHOOSE_INV]=XlSysChooseInv,
 [SYSC_GET_INV]=XlSysGetSetInv,
 [SYSC_SET_INV]=XlSysGetSetInv,
 [SYSC_CAST_SPELL]=XlSysCastSpell,
 [SYSC_REM_CHAR]=XlSysRemChar,
 [SYSC_WIN]=XlSysWin,
 [SYSC_INFLICT]=XlSysInflict,
 [SYSC_CUTSCENE]=XlSysCutScene,
 [SYSC_DEBUG]=XlSysDebug,
}

