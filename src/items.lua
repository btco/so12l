-- ITEMS

-- An item is:
-- TYPE: Item
--  itid: the ITID of the item (indexes into the item database)
--  st: item state (0-255), meaning depends on item.

-- Item state flags:
#define ITSF_UNIDENT 1
#define ITSF_CURSED 2
#define ITSF_ENCHANT_MASK 28
   -- 28 = 00011100
#define ITSF_ENCHANT_SHIFT 2
   -- WARNING: this shift is hard-coded into wand.xl.
   -- If you change it, also change wand.xl.
-- Convenience flag sets
#define ITSF_ENCHANT_1 4
#define ITSF_ENCHANT_2 8
#define ITSF_ENCHANT_3 12
#define ITSF_ENCHANT_4 16
#define ITSF_ENCHANT_5 20
#define ITSF_ENCHANT_6 24
#define ITSF_ENCHANT_7 28

-- Item kinds.
-- EQUIPPABLE:
#define ITK_ARMOR 1
#define ITK_HELM 2
#define ITK_MWEAP 3
#define ITK_RWEAP 4
#define ITK_SHIELD 5
#define ITK_BOOT 6
#define ITK_BELT 7
#define ITK_AMULET 8
#define ITK_RING 9
-- Total count of equippable item kinds:
#define ITK_EQ_KINDS 9
-- Remaining are non-equippable kinds:
#define ITK_WAND 10
#define ITK_SCROLL 11
#define ITK_POTION 12
#define ITK_FOOD 13
#define ITK_THING 14
#define ITK_QUEST 15
-- An ITK_THING is an item that doesn't do anything by default,
-- it just sits there taking up space. It may have some custom effect
-- in code.

-- Enchantable item kinds (those that can have +1, +2, -3, etc).
#id ENCHANTABLE_ITK
ENCHANTABLE_ITK={ITK_ARMOR,ITK_HELM,ITK_MWEAP,ITK_RWEAP,ITK_SHIELD,ITK_BOOT}

-- Maximum # of items of the same type that can be acquired from a shop.
#define MAX_SHOP_SAME_ITEM 4
-- Exceptions:
#id MAX_SHOP_SAME_ITEM_EXCEPTIONS
MAX_SHOP_SAME_ITEM_EXCEPTIONS={
 [ITID_RATION]=6
}

-- ITK_STRS Initialized lazily (because it needs to be loaded from XL).
#id ITK_STRS

-- Item allowed class flags. These must be defined as 1<<c where
-- c is the class constant in plr.lua (CLS_*). So if CLS_FIGHTER
-- is 1, then ITAC_FIGHTER must be 2.
#define ITAC_FIGHTER 2
#define ITAC_PALADIN 4
#define ITAC_ARCHER 8
#define ITAC_WIZARD 16
-- Combinations:
#define ITAC_FP 6
#define ITAC_FPA 14
#define ITAC_PW 20
#define ITAC_ALL 30

-- ITEM FLAGS:
-- Indicates that the item can be used in combat.
#define ITF_MELEE_USE 1
-- Indicates that this weapon is a two-handed weapon.
#define ITF_TWO_HANDED 2
-- Item is cursed (the cursed bit is always set when the item is acquired).
#define ITF_ALWAYS_CURSED 4
-- Value should be scaled by 100
#define ITF_VALUE_X100 8

-- Special byte that appears in the item database binary
-- for error-checking.
#define ITEM_DEF_HDR 123

-- Item IDs:
#define ITID_NONE 0

#define ITID_SHORT_SWORD 1
#define ITID_LONG_SWORD 2
#define ITID_MACE 3
#define ITID_QUARTERSTAFF 4
#define ITID_DAGGER 5
#define ITID_AXE 6
#define ITID_SHORT_BOW 7
#define ITID_LONG_BOW 8
#define ITID_CROSSBOW 9
#define ITID_BROAD_SWORD 10

#define ITID_TWO_HANDED_SWORD 12
#define ITID_BATTLE_AXE 13
#define ITID_BATTLE_HAMMER 14

#define ITID_CLOTHES 16
#define ITID_LEATHER_ARMOR 17
#define ITID_BRIGANDINE 18
#define ITID_SCALE_ARMOR 19
#define ITID_RING_ARMOR 20
#define ITID_CHAIN_ARMOR 21
#define ITID_SPLINTED_ARMOR 22
#define ITID_PLATE_ARMOR 23

#define ITID_WOODEN_SHIELD 24
#define ITID_IRON_SHIELD 25
#define ITID_STEEL_SHIELD 26
#define ITID_BATTLE_SHIELD 27

#define ITID_LEATHER_BOOTS 28
#define ITID_IRON_BOOTS 29
#define ITID_STEEL_BOOTS 30
#define ITID_BATTLE_BOOTS 31

#define ITID_AMULET_OF_HEALTH 32
#define ITID_WIZARD_ROBES 33
#define ITID_AMULET_OF_WIZ 34
#define ITID_RING_OF_SPEED 35
#define ITID_WIZARD_ROBES2 36
#define ITID_WIZARD_HAT 37
#define ITID_RING_DEFROST 38
#define ITID_RING_POISON_RES 39
#define ITID_RING_SLEEP_RES 40
#define ITID_RING_DEFENSE1 41
#define ITID_RING_DEFENSE2 42
#define ITID_RING_DEFENSE3 43

#define ITID_LEATHER_HELM 44
#define ITID_IRON_HELM 45
#define ITID_STEEL_HELM 46
#define ITID_BATTLE_HELM 47
#define ITID_AMULET_STEADY 48

#define ITID_TORCH 64
#define ITID_SHOVEL 65

#define ITID_POTION_HEALING 144
#define ITID_POTION_MANA 145
#define ITID_POTION_INVIS 146
#define ITID_POTION_AWAKE 147
#define ITID_POTION_POISON 148
#define ITID_POTION_SLEEP 149
#define ITID_POTION_FIRE 150
#define ITID_POTION_ANTIDOTE 151
#define ITID_POTION_ICE 152

#define ITID_WAND_FIRST_MINUS_1 159
-- Wands MUST be in same order as spells (spells.lua):
#define ITID_WAND_HEAL 160
#define ITID_WAND_LIGHT 161
#define ITID_WAND_PROTECT 162
#define ITID_WAND_STUN 163
#define ITID_WAND_ACIDRES 164
#define ITID_WAND_AWAKEN 165
#define ITID_WAND_CURE_POISON 166
#define ITID_WAND_STRENGTHEN 167
#define ITID_WAND_BURN 168
#define ITID_WAND_FORCE_BEAD 169
#define ITID_WAND_TEMPEST 170
#define ITID_WAND_LIGHTNING 171
#define ITID_WAND_PUSH 172
#define ITID_WAND_INVIS 173
#define ITID_WAND_IDENTIFY 174

#define ITID_SCROLL_FIRST_MINUS_1 175
-- Scrolls MUST be in same order as spells (spells.lua):
#define ITID_SCROLL_HEAL 176
#define ITID_SCROLL_LIGHT 177
#define ITID_SCROLL_PROTECT 178
#define ITID_SCROLL_STUN 179
#define ITID_SCROLL_ACIDRES 180
#define ITID_SCROLL_AWAKEN 181
#define ITID_SCROLL_CURE_POISON 182
#define ITID_SCROLL_STRENGTHEN 183
#define ITID_SCROLL_BURN 184
#define ITID_SCROLL_FORCE_BEAD 185
#define ITID_SCROLL_TEMPEST 186
#define ITID_SCROLL_LIGHTNING 187
#define ITID_SCROLL_PUSH 188
#define ITID_SCROLL_INVIS 189
#define ITID_SCROLL_IDENTIFY 190

#define ITID_APPLE 96
#define ITID_RATION 97
#define ITID_PEAR 98
#define ITID_BLUEBERRY 99

#define ITID_KINGS_ARMOR 192
#define ITID_KINGS_SWORD 193
#define ITID_KINGS_RING  194
#define ITID_KINGS_CROWN 195
#define ITID_ECROSSBOW 196

#define ITID_JEWELRY_BOX 208
#define ITID_INCENSE 209
#define ITID_GOLDEN_BRACELET 210
#define ITID_MUSIC_BOX 211
#define ITID_SAIL_PERMIT 212
#define ITID_SPECTACLES 213
#define ITID_DICTIONARY 214

#define ITID_CRYSTAL_RED 240
#define ITID_CRYSTAL_GREEN 241
#define ITID_CRYSTAL_BLUE 242
#define ITID_CRYSTAL_YELLOW 243

#define ITID_LEAPING_STONE 244
#define ITID_WORLD_MAP 245
#define ITID_SQUID_INK 246
#define ITID_EMERALD_KEY 247
#define ITID_STATUETTE 248
#define ITID_RESCUE_TOK 249

-- Item database.
--  n: Name of the item.
--  sp: sprite#
--  k: kind of the item (ITK_*)
--  f: flags (ITF_*)
--  att: attack score given by the item
--  def: defense score given by the item
--  v?: base value of the item
--  ac: classes allowed to use the item (ITAC_* flags)
--  desc: Description, shown when the player examines the item.
--        This can be an array if more than one line.
ITDB={}

function IT_Init()
 ITK_STRS=X_Strs(SYM_AItkNames)
 X_SetPc(SYM_ItemDB)
 while 1 do
  -- Check that we read the correct header.
  local h=X_FetchB()
  -- If it's a 0 byte, it means the item DB ended.
  if h==0 then break end
  -- Otherwise, it must be the signature byte.
  ast(h==ITEM_DEF_HDR,"ITDB err "..h)
  -- Read and store the item definition.
  local itid=X_FetchB()
  ast(not ITDB[itid],"Dup ITID "..itid)
  local r,aod={}
  r.n=X_FetchString()
  -- Item sprite is always ITID + 256, so item 1 is sprite 257, etc.
  r.sp=itid+256
  r.k=X_FetchB()
  r.f=X_FetchB()
  -- Value 0 in the data means "priceless", represented as nil.
  r.v=NilIf0(X_FetchB()*(r.f&ITF_VALUE_X100>0 and 100 or 1))
  r.ac=X_FetchB()
  r.def=r.att
  -- To save XL memory, only att OR def is stored; which one depends on
  -- the item type. Only weapons have att. Otherwise, this is treated as
  -- defense.
  if r.k==ITK_MWEAP or r.k==ITK_RWEAP then
   r.att,r.def=X_FetchB(),0
  else
   r.att,r.def=0,X_FetchB()
  end
  r.desc=X_FetchStrings()
  ITDB[itid]=r
 end
end

-- Looks up an item from the database.
function IT_LookUp(itid)
 ast(itid,"null ITID")
 local itdef=ITDB[itid]
 ast(itdef,"bad ITID "..itid)
 return itdef
end

-- Uses the item.
--  it: the item
--  chi: the character index who is using it (for melee).
--    If not in melee, nil.
--  cb: callback when use is complete
function IT_Use(it,chi,cb)
 -- idx is the index of the item in the P.inv list (we will pass
 -- this to the XL handler so it can use with SYSC_REMOVE_ITEM
 -- to consume the right item).
 local idx=ListFind(P.inv,it)
 ast(idx,"ITnf")
 X_Call(SYM_PROC_UseItem,{it.itid,idx,chi},function(r) _=cb and cb(r) end)
end

-- Writes an item to PMEM. nil is supported.
function IT_WritePM(it)
 if it then
  PM_WriteB({it.itid,it.st})
 else
  PM_WriteB({0,0})
 end
end

-- Reads an item from PMEM. Can be nil.
-- f?: If passed, uses this function instead of PM_ReadB
function IT_ReadPM(f)
 f=f or PM_ReadB
 local it={}
 it.itid=f()
 it.st=f()
 return it.itid>0 and it or nil
end

function IT_IsCursed(it)
 ast(it.st,"IT_IC/st")
 return it.st&ITSF_CURSED>0
end

-- Returns the enchantment level of the item.
-- Returns negative if item is cursed.
function IT_GetEnchant(it)
 ast(it.st,"IT_GE/st")
 return (IT_IsCursed(it) and -1 or 1)*(
  (it.st&ITSF_ENCHANT_MASK)>>ITSF_ENCHANT_SHIFT)
end

function IT_IsEnchantable(itid)
 return ListFind(ENCHANTABLE_ITK,IT_LookUp(itid).k)
end

-- Returns the item's icon and display name.
--  it: the item (NOT an itid, the full item)
function IT_GetDisplayInfo(it)
 local itd,ic,s,en,br=IT_LookUp(it.itid)
 ic,s=itd.sp,itd.n
 br=" [?]"
 if it.st&ITSF_UNIDENT>0 then
  -- Unidentified item.
  if ICON_FOR_UNIDENT_ITK[itd.k] then
   -- Description/icon are generic for these items.
   ic=ICON_FOR_UNIDENT_ITK[itd.k]
   s=X_Strs(SYM_AItkNames)[itd.k]..br
   -- First letter capitalized
   s=supper(ssub(s,1,1))..ssub(s,2)
  else
   -- Just add 'unknown' suffix.
   s=s..br
  end
 else
  -- Identified item.
  -- (NOTE: wands never show charge count, even when identified)
  en=itd.k~=ITK_WAND and IT_GetEnchant(it) or 0
  -- Add suffix indicating enchatment level.
  s=s..(en>0 and " +"..en or en<0 and " "..en or "")
  -- Add suffix indicating if it's cursed.
  s=s..(it.st&ITSF_CURSED>0 and " CURSED" or "")
 end
 return ic,s
end

-- Make an item given an ITID and a set of state flags to set.
--   itid: the ITID of the item
--   st: optional flags to set (ITSF_)
function IT_MakeItem(itid,st)
 st=st or 0
 local itd=IT_LookUp(itid)
 -- If the item is always cursed, set the cursed flag.
 if itd.f&ITF_ALWAYS_CURSED>0 then st=st|ITSF_CURSED end
 return {itid=itid,st=st}
end

function IT_GetDetails(it)
 ast(it and it.itid)
 local itd,_,n,d=IT_LookUp(it.itid),IT_GetDisplayInfo(it)
 d=itd.desc
 if not d or #d<1 then d=X_Strs(SYM_ARegularItem) end
 if it.st&ITSF_UNIDENT>0 then return X_Strs(SYM_AUnidentDesc) end
 return ListConcat({n,""},d)
end

--END OF API-------------------------------------------------
-------------------------------------------------------------

-- Icon for unidenfied item of each kind
#id ICON_FOR_UNIDENT_ITK
ICON_FOR_UNIDENT_ITK={
 [ITK_POTION]=491,
 [ITK_SCROLL]=492,
 [ITK_AMULET]=493,
 [ITK_WAND]=494,
 [ITK_RING]=495,
}


