-- PERSISTENT GAME/LEVEL STATE MANAGER

-- Size of the GPS in bytes.
#define GPS_SIZE 32

PS={
 -- GPS (Global Persistent State). Array of GPS_SIZE bytes.
 gps=nil,
 -- KF (kill flags) for each level. Indexed by level#.
 --  kf[lvlN] is a list of bytes that represent the kill flags.
 -- Bits are counted from LEAST to MOST significant, starting with
 -- the first byte, then going to the second byte, and so on and
 -- so forth.
 kf=nil,
}

-- Initializes. Must be called at the start of the game.
function PS_Reset()
 PS.gps=Zeroes(GPS_SIZE)
 PS.kf={}
 for i,lvl in ipairs(LVLS) do
  ast(lvl.kfL)
  insert(PS.kf,Zeroes(lvl.kfL))
 end
end

-- Gets the given entry of the GPS
function PS_GetGps(idx)
 local a=PS.gps
 ast(a and idx>=1 and idx<=#a)
 return a[idx]
end

-- Sets the given entry of the GPS
function PS_SetGps(idx,val)
 local a=PS.gps
 ast(a and a[idx])
 ast(val and val>=0 and val<256,"GPSv")
 a[idx]=val
 --trace("GPS "..idx.." set to "..val)
end

-- Returns the KF flag given the level# and flag index.
function PS_GetKf(lvlNo,kfi)
 local bidx,mask=GetByteAndMaskForKfi(kfi)
 return (PS.kf[lvlNo][bidx]&mask)>0
end

-- Sets the KF flag for the given index in the given level#.
function PS_SetKf(lvlNo,kfi)
 local bidx,mask=GetByteAndMaskForKfi(kfi)
 local t=PS.kf[lvlNo]
 t[bidx]=t[bidx]|mask
end

-- Saves the GPS and kill flags, etc, to persistent memory
function PS_SavePM()
 -- Write signature byte for error checking.
 PM_WriteB(42)
 -- Write the GPS.
 PM_WriteB(PS.gps)
 -- Write the KF for each level.
 for i,lvl in ipairs(LVLS) do
  PM_WriteB(43)
  PM_WriteB(PS.kf[i])
 end
end

-- Loads the GPS, kill flags, etc, from persistent memory
function PS_LoadPM()
 PS_Reset()
 -- Check signature byte.
 ast(PM_ReadB()==42,"Bad PS sig.")
 -- Read the GPS.
 PS.gps=PM_ReadBs(GPS_SIZE)
 -- Read KF for each level.
 for i,lvl in ipairs(LVLS) do
  ast(PM_ReadB()==43,"Bad PS/L sig.")
  PS.kf[i]=PM_ReadBs(lvl.kfL)
 end
end

--END OF API---------------------------------------------------
---------------------------------------------------------------

function GetByteAndMaskForKfi(kfi)
 return 1+kfi//8,1<<(kfi%8)
end

