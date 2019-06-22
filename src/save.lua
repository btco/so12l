-- SAVE/LOAD GAME

-- Saves the current game to persistent memory.
function S_Save()
 PM_OpenWrite()
 -- Write format byte.
 PM_WriteB(S_FORMAT)
 -- Save current level number.
 PM_WriteB(L.lvlN)
 -- Save player data.
 P_SavePM()
 -- Save GPS and kill flags.
 PS_SavePM()
 -- Close file.
 PM_Close()
end

-- Tries to load the save game. Returns TRUE if successful, FALSE
-- if there was no game saved.
function S_Load()
 PM_OpenRead()
 local f=PM_ReadB()
 -- If the signature byte is 0, it means memory is empty.
 if f==0 then
  PM_Close()
  return FALSE
 end
 -- Otherwise, the signature byte must match S_FORMAT.
 ast(f==S_FORMAT,"S FMT")
 -- Reset everything first.
 G_ResetAll()
 -- Load level number.
 local lvlN=PM_ReadB()
 -- Load player data.
 P_Load(TRUE)
 -- Load GPS and kill flags.
 PS_LoadPM()
 -- Close file.
 PM_Close()
 -- Load the indicated level.
 -- -1 as second arg indicates that player should not be moved
 -- to an entry point.
 L_Load(lvlN,-1)
 return TRUE
end

--END OF API------------------------------------------------
------------------------------------------------------------

#define S_FORMAT 123

