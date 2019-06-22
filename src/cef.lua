-- Character effects (poisoned, strong, etc).

-- NOTE: this used to be an XL-only concept unknown to Lua code
-- but now we've migrated it. That's why it's hacky.

#define VID_CEF_CHAR1                      VID_GPS21
#define GV_CEF_CHAR1                       VAR_GPS21
#define GV_CEF_CHAR2                       VAR_GPS22
#define GV_CEF_CHAR3                       VAR_GPS23
#define GV_CEF_CHAR4                       VAR_GPS24
-- Masks to be used with each:
-- WARNING: If you modify the values, modify CEF_MASK_INACTIVE below.
    #define CEF_POISON    1
    #define CEF_ASLEEP    2
    #define CEF_FROZEN    4
    #define CEF_STRONG    8
    #define CEF_INVIS    16
    #define CEF_ALERT    32
-- Mask for what conditions cause a character to be INACTIVE:
    -- CEF_ASLEEP | CEF_FROZEN
    #define CEF_MASK_INACTIVE 6

function CEF_Get(chi)
 ast(chi>0 and chi<5,"!CEFc"..chi)
 return X_GetGlob(VID_CEF_CHAR1+chi-1)
end

function CEF_Test(chi,mask)
 return 0<(CEF_Get(chi)&mask)
end

function CEF_SetBit(chi,mask)
 ast(chi>0 and chi<5,"!CEFs"..chi)
 return X_SetGlob(VID_CEF_CHAR1+chi-1,CEF_Get(chi)|mask)
end

function CEF_ClearBit(chi,mask)
 ast(chi>0 and chi<5,"!CEFc"..chi)
 return X_SetGlob(VID_CEF_CHAR1+chi-1,CEF_Get(chi)&~mask)
end

