-- Possible loot levels.
#define LOL_A 1
#define LOL_B 2
#define LOL_C 3
#define LOL_D 4
#define LOL_E 5

-- Target gp value for each loot level.
#id LOL_TARGET_VALUES
LOL_TARGET_VALUES={50,100,200,300,400}
  -- WARNING: If you change these values, also update sim/quest.js
#id LOL_CAND_ITEMS
LOL_CAND_ITEMS={}

-- Initializes loot system.
function LO_Init()
 -- For each possible loot category, compile a list of ITIDs that
 -- have value > 0 and less than the target value for that category.
 -- These are the candidate items for each loot level.
 for i=1,#LOL_TARGET_VALUES do
  local tv,ci=LOL_TARGET_VALUES[i],{}
  for itid,itd in pairs(ITDB) do
   if itd.v and itd.v>0 and itd.v<=tv then insert(ci,itid) end
  end
  ast(#ci>0,"LOi"..i)
  insert(LOL_CAND_ITEMS,ci)
 end
end

-- Gives random item(s) as loot.
--   lol: target loot level (one of the LOL_* constants above).
function LO_Give(lol)
 -- tv: target value to award
 -- can: the list of candidate items
 -- ai: awarded items (list)
 -- av: awarded value (sum of values of ai)
 -- sw: if true, we already switched the first item
 local tv,can,ai,av,f,sw=LOL_TARGET_VALUES[lol],LOL_CAND_ITEMS[lol],{},0,0,FALSE
 -- Pick items randomly from the list of candidates until we reach
 -- a maximum of 2 items or the target value. If we pick an item
 -- that would take us over budget, pick again.
 for i=1,100 do
  if av>=tv or #ai>=2 then break end
  i=i+1
  -- Pick a random item.
  local itid,v=can[random(1,#can)]
  v=IT_LookUp(itid).v
  -- If we haven't done it before, discard a lesser value first 
  -- item in favor of a more valuable one.
  --if not sw and #ai==1 and v>av then
   -- Discard our previous pick.
   --ai,av,sw={},0,TRUE
  --end
  -- Would go over budget?
  if av+v<=tv then
   -- OK to add.
   insert(ai,LO_MakeRandomItem(itid))
   av=av+v
  else
   -- Failure.
   f=f+1
  end
 end
 -- When we get here, ai[] is the list of items to award (items, not
 -- ITIDs), av is the total award value (sum of item values) and
 -- tv is the target value we wanted to award.
 -- So award the items and give the "change"
 _=#ai>0 and P_GiveItems(ai,tv>av and tv-av or nil)
end

function LO_MakeRandomItem(itid)
 -- Look up the definition.
 local itd,f=IT_LookUp(itid)
 -- Figure out the flags we're going to use.
 -- Loot items are always unidentified:
 f=ITSF_UNIDENT
 -- If it can have an enchantment, figure out what value to give.
 r=random(0,0xffff)>>8
 if IT_IsEnchantable(itid) then
  f=f|(r>254 and ITSF_ENCHANT_7 or
   r>252 and ITSF_ENCHANT_6 or
   r>248 and ITSF_ENCHANT_5 or
   r>240 and ITSF_ENCHANT_4 or
   r>224 and ITSF_ENCHANT_3 or
   r>192 and ITSF_ENCHANT_2 or
   r>128 and ITSF_ENCHANT_1 or 0)
 elseif itd.k==ITK_WAND then
  f=f|(r>224 and ITSF_ENCHANT_5 or
   r>192 and ITSF_ENCHANT_4 or
   r>128 and ITSF_ENCHANT_3 or ITSF_ENCHANT_2)
 end
 -- 1/4 chance of it being cursed.
 f=f|(random(0,3)<1 and ITSF_CURSED or 0)
 return IT_MakeItem(itid,f)
end

