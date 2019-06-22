-- UI STUFF (DIALOGUE, SHOPS, ETC).

#define DIA_X 0
#define DIA_Y 0
#define DIA_W VP_W+1
#define DIA_H VP_H+2

#define DIA_CHAR_X 4
#define DIA_CHAR_Y_BOT VP_H-10
#define DIA_CHAR_W VP_W-8

-- Shows a dialogue screen.
--  face: NPC character's face sprite.
--   If this is 1-4, it's a character who is speaking, not an NPC.
--   If this is 0, it's the omnipresent narrator (narration
--   interstitial).
--  name: Name of the NPC. Ignored if face<5.
--  msg: The message to speak (string or array of strings for
--       multi line.
--  cb?: callback to call when done speaking but before closing
--      the speech UI.
function UI_Speak(face,name,msg,cb)
 A_Enq(ActSpeak,{face=face,name=name,msg=msg,cb=cb})
end

-- Shows a shop screen that lets the user select an item to buy.
--  itids: Array of ITIDs of items being offered for sale.
--  m: Item cost multiplier (default 1.0)
--  
-- The items will be sold at their list price in the item DB,
-- multiplied by m.
function UI_Buy(itids,m)
 m=m or 1
 local choices={}
 for _,itid in ipairs(itids) do
  local itd=IT_LookUp(itid)
  insert(choices,itd.n.." ("..ceil(itd.v*m).. "gp)")
 end
 ChoiceDialog({
   X_Str(SYM_SBuyWhat),"(Funds: "..P.gold.." gp)"},choices,
   ActBuyCB,C_WHITE,C_BROWN,{itids=itids,m=m},CHD_F_CANCELABLE)
end

-- Shows the shop sell UI.
--  ks: array of item kinds to show.
function UI_Sell(ks)
 P_ChooseItem("Sell",ks,0,X_Str(SYM_SNoItemsToSell),TRUE,_SellCB)
end
function _SellCB(it)
 if not it then return end
 local itd=IT_LookUp(it.itid)
 ChoiceDialog({"Sell "..itd.n,"for "..itd.v.." gp?"},
   X_Strs(SYM_ADontSellSell),_SellCB2,C_WHITE,C_GREEN,
   {it=it,itd=itd},CHD_F_CANCELABLE)
end
function _SellCB2(ch,d)
 if ch and ch==2 then
  -- Remove item from inventory.
  P_DiscardItem(d.it)
  -- Give gold.
  P_GiveGold(d.itd.v)
 end
end

-- Presents a UI that asks the player if they are okay with
-- paying something. Calls the callback with c,udata where c
-- is 1 if player paid, 0 if player did not pay (refused or did
-- not have enough money).
function UI_Pay(msg,amt,cb,udata,fl)
 ChoiceDialog(ListConcat(msg,{"Cost: "..amt.." gp"}),
   {"No","Yes"},_UiPayCb,C_WHITE,C_BLUE,{cb=cb,udata=udata,amt=amt,fl=fl})
end
function _UiPayCb(a,d)
 a=a or 1
 if a==2 then
  -- Player accepted to pay. Do they have enough money?
  if P.gold<d.amt then
   -- Not enough gold.
   Alert(X_Str(SYM_SNotEnoughGold))
   -- Same as declining.
   a=1
  else
   -- Deduct the gold.
   ChangeGold(-d.amt)
  end
 end
 -- Invoke the callback. a-1 means "1" if yes, "0" if no.
 d.cb(a-1,d.udata)
end

-- Presents a UI that lets the player choose an equipped item
-- of the given character.
--   chi: character index
--   msg: message to show.
--   cb: callback to call with selected item kind.
function UI_ChooseEquipped(chi,msg,cb)
 -- ns: names of items.
 -- ks: kinds of items (parallel array to ns) .
 -- it: current item.
 local ns,ks,it,n={},{}
 for k=1,ITK_EQ_KINDS do
  it=PA[chi].eq[k]
  if it then
   _,n=IT_GetDisplayInfo(it)
   insert(ns,n) insert(ks,k)
  end
 end
 if #ns<1 then
  Alert(PA[chi].n..X_Str(SYM_SNothingEquipped))
  cb(0)
 else
  ChoiceDialog(msg,ns,_UI_ChooseEquippedCb,
    C_WHITE,C_BROWN,{cb=cb,ks=ks},CHD_F_CANCELABLE)
 end
end
function _UI_ChooseEquippedCb(i,d)
 -- If i is nil, dialog was cancelled. Otherwise, i is the index
 -- in d.ks (array of item kinds), so pass that to callback.
 d.cb(d.ks[i] or 0)
end

--END OF API-------------------------------------------------------
-------------------------------------------------------------------

function ActSpeak(s)
 -- If s.face is 1-4, it's one of the party members speaking.
 -- If s.face is 0, it's the "omnipresent narrator" (narration
 -- interstitial).
 local chi,tw,th,x,y,w,h,yo=
   s.face<5 and s.face,MeasureText(s.msg,PRN_MONOSPACE)
 if s.face<1 then
  -- Narration style.
  -- HACK: x has -8 because later we add 8 when printing.
  x,y,w,h,yo=HSCRW-tw//2-8,HSCRH-th//2,tw,th,0
 else
  x,y,w,h,yo=
   chi and DIA_CHAR_X or DIA_X,
   chi and (DIA_CHAR_Y_BOT-th-4) or DIA_Y,
   chi and DIA_CHAR_W or DIA_W,
   chi and th+8 or DIA_H,
   chi and 4 or 30
 end

 s.sfxp=s.sfxp or (SFX_Play(SFX_SPEAK) or TRUE)
 if s.face>0 then RectFB(x,y,w,h,C_BROWN,C_WHITE) else cls(0) end
 -- Only show face if NOT a character.
 -- Otherwise, draw the tip of the speech balloon next to the
 -- appropriate character.
 if s.face<1 then
  -- Narration style: no face.
 elseif chi then
  -- Character speaking, add the "tip of speech balloon" sprite.
  spr(224,(2*chi-1)*CHAR_BOX_W//2,y+h-1,0)
 else
  -- NPC speaking: show face and name of NPC.
  RectFB(x+8,y+8,12,12,C_BLACK,C_WHITE)
  spr(s.face,DIA_X+10,DIA_Y+10)
  prn(s.name,DIA_X+25,DIA_Y+12,C_WHITE)
 end
 if DBG_FAST then s.clk=s.clk+10 end
 local done=PrintLines(s.msg,x+8,y+yo,C_WHITE,s.clk//2,PRN_MONOSPACE)
 if s.q then return TRUE end
 if done and (Dbtnp(BTN_PRI) or Dbtnp(BTN_SEC)) then
  -- When we call the callback, we could in theory end up in a
  -- situation where the callback initiates a modal action, in which
  -- case this current action will survive and continue to be called,
  -- so we ward against that by setting s.q=1 so we know to
  -- return TRUE and end this silently if control gets back to us.
  s.q=1
  -- Call callback, if present.
  _=s.cb and s.cb()
  -- Don't return TRUE yet, run for one more frame to let the
  -- callback have a chance to enqueue modal actions.
 end
end

-- Callback for the buy UI.
--  i: the selected index.
--  d.itids: the items for sale (array of ITIDs).
--  d.m: the cost multiplier.
function ActBuyCB(i,d)
 local itid,itd,v,err,max
 if not i then return end
 itid=d.itids[i]
 itd=IT_LookUp(itid)
 -- Check if purchase exceeds item count limit.
 max=MAX_SHOP_SAME_ITEM_EXCEPTIONS[itid] or MAX_SHOP_SAME_ITEM
 er=(#P.inv>=INV_MAX or P_GetItemCount(itid)>=max) and SYM_AOutOfStock
 if er then Alert(X_Strs(er)) return end
 -- Offer to buy.
 v=ceil(itd.v*d.m)
 UI_Pay({"Buy "..itd.n.."?"},v,ActBuyConfirmCB,itid)
end

function ActBuyConfirmCB(i,itid)
 _=i>0 and P_GiveItems({IT_MakeItem(itid)})
end


