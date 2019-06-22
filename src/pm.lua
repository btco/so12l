-- PERSISTENT MEMORY ACCESS.

function PM_OpenWrite()
 ast(PM.m==PM_MODE_OFF,"PMor "..PM.m)
 PM.m,PM.o=PM_MODE_WRITE,0
end

function PM_OpenRead()
 ast(PM.m==PM_MODE_OFF,"PMow "..PM.m)
 PM.m,PM.o=PM_MODE_READ,0
end

function PM_Close()
 ast(PM.m~=PM_MODE_OFF,"PMc")
 trace("PMc "..PM.o)
 PM.m,PM.o=PM_MODE_OFF,0
end

-- Write a byte.
-- b: the byte to write. Can be an array too.
function PM_WriteB(b)
 ast(PM.m==PM_MODE_WRITE)
 if type(b)=="table" then
  for i=1,#b do PM_WriteB(b[i]) end
  return
 end
 ast(b>=0 and b<=255)
 -- Compute the byte index and shift.
 local i,s=PM.o//4,(PM.o%4)*8
 ast(i<=255,"PMEM out")
 -- Splice the new byte into the given position of persistent
 -- memory. &~(255<<s) clears the byte, |(b<<s) sets it.
 pmem(i,(pmem(i)&~(255<<s))|(b<<s))
 -- Advance the cursor.
 PM.o=PM.o+1
end

-- Writes a number using the given number of bytes (n).
-- So to write a word use PM_WriteNum(2,val), to write a DWORD,
-- use PM_WriteNum(4,val), etc.
function PM_WriteNum(n,dw)
 for i=1,n do
  PM_WriteB(dw&255)
  dw=dw>>8
 end
end
-- Convenience aliases:
function PM_WriteW(w) PM_WriteNum(2,w) end
function PM_WriteDW(d) PM_WriteNum(4,d) end

function PM_ReadB()
 ast(PM.m==PM_MODE_READ)
 -- Compute the byte index and shift.
 local i,s=PM.o//4,(PM.o%4)*8
 ast(i<=255,"EOPM")
 -- Advance to next position
 PM.o=PM.o+1
 -- Get the byte.
 return (pmem(i)&(255<<s))>>s
end

-- Reads N bytes, returns as an array.
function PM_ReadBs(n)
 local r={}
 for i=1,n do insert(r,PM_ReadB()) end
 return r
end

-- Reads a number made up of N bytes.
function PM_ReadNum(n)
 local r=0
 for i=0,n-1 do r=r|(PM_ReadB()<<(i*8)) end
 return r
end
-- Convenience aliases
function PM_ReadW() return PM_ReadNum(2) end
function PM_ReadDW() return PM_ReadNum(4) end

-- Writes a string.
function PM_WriteS(s)
 ast(#s<=255)
 PM_WriteB(#s)
 for i=1,#s do PM_WriteB(string.byte(s,i)) end
end

-- Reads a string.
function PM_ReadS()
 local l,s=PM_ReadB(),""
 for i=1,l do s=s..schr(PM_ReadB()) end
 return s
end

--[[
function PM_Test()
 trace("testing")
 PM_OpenWrite()

 PM_WriteB(123)
 PM_WriteB(231)
 PM_WriteW(12345)
 PM_WriteDW(1234567890)
 PM_WriteS("Hello, world!")
 PM_WriteB(42)
 PM_WriteDW(600673)

 PM_Close()
 PM_OpenRead()

 trace("-> " .. PM_ReadB())
 trace("-> " .. PM_ReadB())
 trace("-> " .. PM_ReadW())
 trace("-> " .. PM_ReadDW())
 trace("-> " .. PM_ReadS())
 trace("-> " .. PM_ReadB())
 trace("-> " .. PM_ReadDW())

 PM_Close()
end
]]

--END OF API-------------------------------------------------
-------------------------------------------------------------

#define PM_MODE_OFF 0
#define PM_MODE_READ 1
#define PM_MODE_WRITE 2

PM={
 -- Current open mode.
 m=PM_MODE_OFF,
 -- Current byte offset.
 o=0,
}


