-- INVENTORY

-- Current inventory screen state (cloned from INV_INIT).
local I=nil

function I_Show()
 INVAC_STR=X_Strs(SYM_AInvActions)
 I=DeepCopy(INV_INIT)
 RebuildInvGrid()
 A_Enq(ActInvScreen,{})
end

--END OF API-------------------------------------------------------
-------------------------------------------------------------------

-- INVAC_STR is initialized in I_Show
#id INVAC_STR

#define INV_WINDOW_X0 8
#define INV_WINDOW_Y0 8
#define INV_WINDOW_WIDTH 224
#define INV_WINDOW_HEIGHT 120

#define INV_GRID_X0 24
#define INV_GRID_Y0 26
-- Has to be enough cols to fit the equipped items AND the inventory
-- items side by side.
#define INV_GRID_COLS 20
#define INV_GRID_ROWS 8
#define INV_GRID_STRIDE 10

#define INV_MAX 80

-- Start and end column of the grid that we use for inventory items.
#define INV_GRID_GEAR_START_COL 11
#define INV_GRID_GEAR_END_COL 20

#define INV_DETAILS_X 12
#define INV_DETAILS_Y 120

-- Possible actions for an inventory item.
#define INVAC_EQUIP_C1 1
#define INVAC_EQUIP_C2 2
#define INVAC_EQUIP_C3 3
#define INVAC_EQUIP_C4 4
#define INVAC_REMOVE 5
#define INVAC_USE 6
#define INVAC_EXAMINE 7
#define INVAC_DISCARD 8

#id INV_INIT
INV_INIT={
 -- Grid of item cells. Index is "c,r". Sparse. Each cell be nil.
 -- If a cell is NOT nil, then it has:
 --  chi: if this represents an equipped item, this is the index of
 --       the character on which this item is equipped. Otherwise nil.
 --  idx: if this represents an inventory item, this is the index
 --       of the item in P.inv[]. Otherwise nil.
 --  it: the item (reference to the item in a character's equip list
 --      or the inventory).
 grid={},

 -- Cursor row/col on the grid.
 cr=1,cc=INV_GRID_GEAR_START_COL,

 -- When set to TRUE, we should close the inv screen.
 quitf=FALSE,
}

-- Action that shows the inventory screen.
function ActInvScreen(st,isFg)
 if not I then return TRUE end
 Window(INV_WINDOW_X0,INV_WINDOW_Y0,INV_WINDOW_WIDTH,INV_WINDOW_HEIGHT,
   C_BLACK,X_Str(SYM_SInventory))
 if isFg and (Dbtnp(BTN_SEC) or I.quitf) then
  -- Close the inventory screen.
  I=nil
  return TRUE
 end
 DrawItems(isFg)

 if not isFg then return end

 if Dbtnp(BTN_UP) then MoveGridCursor(0,-1) end
 if Dbtnp(BTN_DOWN) then MoveGridCursor(0,1) end
 if Dbtnp(BTN_LEFT) then MoveGridCursor(-1,0) end
 if Dbtnp(BTN_RIGHT) then MoveGridCursor(1,0) end

 if Dbtnp(BTN_PRI) then
  -- Show the item action menu.
  OpenItemActionMenu()
  return FALSE
 end

 return FALSE
end

-- Rebuilds the grid, based on the equipped items and inventory items.
function RebuildInvGrid()
 I.grid={}
 -- Add all equipped items for all characters to the top left of the
 -- grid.
 for chi=1,#PA do
  local col=1
  local ch=PA[chi]
  for k,it in pairs(ch.eq) do
   if it then
    I.grid[col..","..chi]={chi=chi,it=it}
    col=col+1
   end
  end
 end
 -- Add all inventory items to the right side of the grid.
 local col,row=INV_GRID_GEAR_START_COL,1
 for i,it in ipairs(P.inv) do
  I.grid[col..","..row]={idx=i,it=it}
  if col==INV_GRID_GEAR_END_COL then
   col,row=INV_GRID_GEAR_START_COL,row+1
  else
   col,row=col+1,row
  end
 end
end

-- Opens the menu of actions so the player can chose what to do
-- with a particular item (equip, use, examine, etc).
function OpenItemActionMenu()
 local m={sel=1}
 m.acts=GetSelItemActions()
 if not m.acts then return end
 m.names={}
 for _,ac in ipairs(m.acts) do
  -- If it's the equip action, append the character's name.
  local n
  if ac>=INVAC_EQUIP_C1 and ac<=INVAC_EQUIP_C4 then
   n="Equip ("..PA[ac-INVAC_EQUIP_C1+1].name..")"
  else
   n=INVAC_STR[ac]
  end
  insert(m.names,n)
 end
 A_Enq(ActItemActionMenu,m,AF_MODAL)
end


-- Action that shows the menu that allows the user to take an action
-- on the selected item (Equip, Remove, Use, etc)
-- m.sel is the currently selected option in the menu.
-- m.acts is the list of actions.
-- m.names is the list of action names.
function ActItemActionMenu(m,isFg)
 m.sel=Menu("Item",m.names,120,40,C_WHITE,C_BROWN,m.sel)
 if not isFg then return FALSE end
 if Dbtnp(BTN_PRI) then
  -- Carry out the selected action on the item.
  local cell=GetSelCell()
  local ac=m.acts[m.sel]
  local fn=INVAC_HANDLER_FN[ac]
  ast(fn,"No ac hnd " .. m.sel)
  local itd=IT_LookUp(cell.it.itid)
  return fn(ac,cell)
 end
 if Dbtnp(BTN_SEC) then
  -- Close menu.
  return TRUE
 end
 return FALSE
end

-- Returns the selected cell.
function GetSelCell() return I.grid[I.cc..","..I.cr] end

-- Equips the currently selected item.
--  ac: the action performed (INVAC_*)
--  cell: the item cell
function HandleItemEquip(ac,cell)
 -- The # of the character who will equip it is based on the action
 -- number (INVAC_EQUIP_C1 is character 1, INVAC_EQUIP_C2 is character
 -- 2 and so on).
 local chi=ac-INVAC_EQUIP_C1+1
 local ch=PA[chi]
 local itd=IT_LookUp(cell.it.itid)
 -- Check that the character is of the appropriate class for the item.
 if (1<<ch.class)&itd.ac<1 then
  Alert(ch.name..X_Str(SYM_SCantUseThis),nil,nil,SFX_ERROR)
  return FALSE
 end
 -- If the character is already using an item on that slot, error out.
 if ch.eq[itd.k] then
  Alert({ch.name..X_Str(SYM_SMustFirstRemove),
   "current "..ITK_STRS[itd.k].."."},nil,nil,SFX_ERROR)
  return FALSE
 end
 -- Shield and two-handed weapons can't be used together.
 if (ch.eq[ITK_SHIELD] and itd.f&ITF_TWO_HANDED>0) or
   (itd.k==ITK_SHIELD and Has2HandedWeapon(ch)) then
  Alert(X_Strs(SYM_ATwoHandedShieldConflict),
    nil,nil,SFX_ERROR)
  return FALSE
 end
 -- Move item to character's equip list.
 ch.eq[itd.k]=cell.it
 -- Remove item from inventory.
 ast(cell.idx)
 remove(P.inv,cell.idx)
 RebuildInvGrid()
 -- Select the newly equipped item.
 SelectItemInGrid(cell.it)
 SFX_Play(SFX_OK)
 return TRUE
end

-- Determines if the given character is using a two-handed weapon.
function Has2HandedWeapon(ch)
 local w=ch.eq[ITK_MWEAP]
 return w and (IT_LookUp(w.itid).f&ITF_TWO_HANDED>0)
end

-- Makes the given item selected in the grid.
function SelectItemInGrid(it)
 for r=1,INV_GRID_ROWS do
  for c=1,INV_GRID_COLS do
   local cell=I.grid[c..","..r]
   if cell and cell.it==it then
    I.cc,I.cr=c,r
    return
   end
  end
 end
end

-- Removes the currently selected item (returns it to the inventory).
--  ac: the action (unused)
--  cell: the cell.
function HandleItemRemove(ac,cell)
 -- If inventory is full, error.
 if #P.inv>=INV_MAX then
  Alert(X_Str(SYM_SCantRemoveInvFull),nil,nil,SFX_ERROR)
  return FALSE
 end
 local itd=IT_LookUp(cell.it.itid)
 -- Cursed?
 if IT_IsCursed(cell.it) then
  AlertItsCursed()
  return FALSE
 end
 -- Remove item from equipment list.
 PA[I.cr].eq[itd.k]=nil
 -- Add it to the inventory.
 insert(P.inv,cell.it)
 -- Rebuild grid and select item.
 RebuildInvGrid()
 SelectItemInGrid(cell.it)
 SFX_Play(SFX_OK)
 return TRUE
end

function AlertItsCursed()
 Alert(X_Str(SYM_SCantRemoveCursed),nil,nil,SFX_ERROR)
end

function HandleItemUse(ac,cell)
 -- We need to schedule the item use as an action rather than
 -- do it immediately because it should happen after the inventory
 -- screen closes, otherwise it might draw stuff on top of the
 -- inventory screen and it will look weird.
 A_Enq(function() IT_Use(cell.it) return TRUE end)
 -- Signal that we should quit the inventory screen.
 I.quitf=TRUE
 return TRUE
end

function HandleItemExamine(ac,cell)
 Alert(IT_GetDetails(cell.it))
 return TRUE
end

function HandleItemDiscard(ac,cell)
 local itd=IT_LookUp(cell.it.itid)
 if not itd then return TRUE end
 -- Cursed items can't be discarded if equipped.
 if cell.chi and IT_IsCursed(cell.it) then
  AlertItsCursed()
  return FALSE
 end
 -- Don't let the player discard a quest item or a priceless item (v == 0).
 if itd.k==ITK_QUEST or (itd.v or 0)<1 then
  Alert(X_Str(SYM_SCantDiscardLooksImportant),
    nil,nil,SFX_ERROR)
  return TRUE
 end
 -- Ask for confirmation.
 ChoiceDialog(X_Str(SYM_SReallyDiscard).." "..itd.n.."?",
   X_Strs(SYM_ACancelDiscard),_HandleItemDiscardCb)
 return TRUE
end
function _HandleItemDiscardCb(ans)
 if ans~=2 then return end
 local cell=GetSelCell()
 if not cell then return end
 local itd=IT_LookUp(cell.it.itid)
 local chi,idx=cell.chi,cell.idx
 ast(chi or idx)
 if chi then
  -- Item is equipped, so discard from character.
  PA[chi].eq[itd.k]=nil
 else
  -- Item is in the inventory, so remove it from the list.
  P_DiscardItem(cell.it)
 end
 -- In any event, we must rebuild the grid.
 RebuildInvGrid()
 SFX_Play(SFX_OK)
end

-- Moves the grid cursor.
--  dc,dr: 0 or +/-1, the displacement
function MoveGridCursor(dc,dr)
 I.cc=Clamp(I.cc+dc,1,INV_GRID_COLS)
 I.cr=Clamp(I.cr+dr,1,INV_GRID_ROWS)
 -- Now here's some weird logic, to avoid having the cursor on
 -- "spacer" cells that don't really represent an item or a slot:

 -- If the cursor is in the inventory area, every position is valid,
 -- so we don't have to do anything. Also, if it's on a filled cell,
 -- we are also good.
 if I.grid[I.cc..","..I.cr] or (I.cc>=INV_GRID_GEAR_START_COL and
   I.cc<=INV_GRID_GEAR_END_COL) then
  return
 end

 -- Here, the cursor is on an empty cell NOT in the inventory area
 -- (a spacer cell). Let's decide what to do to fix this.
 
 if dc>0 then
  -- We got here by moving to the right, so just send the cursor to
  -- the start of the inventory area.
  I.cc=INV_GRID_GEAR_START_COL
 elseif dc<0 and I.cr<=#PA then
  -- We got here by moving to the left and this is a valid character
  -- equipment row, so just move left until we are at a filled cell
  -- (best effort).
  MoveCursorToNextFilledCell(-1,0)
 elseif dc>0 and I.cr>#PA then
  -- We tried to move left on a row that doesn't represent a
  -- valid character, so clamp to INV_GRID_GEAR_START_COL.
  I.cc=INV_GRID_GEAR_START_COL
 elseif dr~=0 and I.cr<=#PA then
  -- We got here by moving up or down, so just move to the left until
  -- we hit a filled cell (best effort).
  MoveCursorToNextFilledCell(-1,0)
 else
  -- Undo the movement.
  I.cc,I.cr=I.cc-dc,I.cr-dr
 end
end

function MoveCursorToNextFilledCell(dc,dr)
 while not I.grid[I.cc..","..I.cr] do
  local nc=Clamp(I.cc+dc,1,INV_GRID_COLS)
  local nr=Clamp(I.cr+dr,1,INV_GRID_ROWS)
  if nc==I.cc and nr==I.cr then break end
  I.cc,I.cr=nc,nr
 end
end

function DrawItems(isFg)
 for r=1,INV_GRID_ROWS do
  for c=1,INV_GRID_COLS do
   local cell=I.grid[c..","..r]
   DrawInvCell(cell,
     INV_GRID_X0+INV_GRID_STRIDE*(c-1),
     INV_GRID_Y0+INV_GRID_STRIDE*(r-1),
     I.cc==c and I.cr==r,isFg)
  end
 end
 -- Draw the player icons on the left side.
 local icx=INV_GRID_X0-12
 local icy=INV_GRID_Y0-1
 for i=1,#PA do
  spr(PA[i].face,icx,icy+(i-1)*INV_GRID_STRIDE)
 end
 -- Draw the text labels over the grid areas.
 prn("Equipped",icx,icy-10,C_GRAY)
 prn("Inventory",
   INV_GRID_X0+INV_GRID_STRIDE*(INV_GRID_GEAR_START_COL-1),
   icy-10,C_GRAY)
 -- Display party gold on the left
 prn("Gold",icx,INV_GRID_Y0+50,C_GRAY)
 prn(P.gold .. " gp",icx,INV_GRID_Y0+60,C_WHITE)
end

-- Draws an inventory grid cell.
--  cell: the cell to draw
--  x,y: top left of cell
--  sel: bool indicating if sel is selected
--  isFg: if TRUE, we are in foreground mode, so blink
function DrawInvCell(cell,x,y,sel,isFg)
 local ic,n
 if cell then
  ic,n=IT_GetDisplayInfo(cell.it)
  spr(ic,x,y)
 end
 -- Blink selection unless menu is shown
 if sel and (not isFg or G.clk&16>0) then
  rectb(x-2,y-2,11,11,C_YELLOW)
 end
 -- Show item name at the bottom.
 _=n and sel and PrintC(n,INV_WINDOW_X0+INV_WINDOW_WIDTH//2,INV_DETAILS_Y,C_YELLOW)
end

-- Gets the list of possible actions for the currently selected item.
-- Returns nil if no menu should be shown at all (invalid item).
function GetSelItemActions()
 local ac={}
 local cell=GetSelCell()
 if not cell then return nil end
 local itd=IT_LookUp(cell.it.itid)
 if cell.chi then
  -- It's something that's equipped, so REMOVE is always an option.
  insert(ac,INVAC_REMOVE)
 else
  -- If it's equippable, show option to equip it. 
  if itd.k<=ITK_EQ_KINDS then
   -- Add one equip action for each character in the party.
   for i=1,#PA do
    insert(ac,INVAC_EQUIP_C1+i-1)
   end
  else
   -- Otherwise, the item can be USED, whatever that means for the
   -- item.
   insert(ac,INVAC_USE)
  end
 end
 -- All items can be examined and discarded.
 insert(ac,INVAC_EXAMINE)
 insert(ac,INVAC_DISCARD)
 return ac
end

-- Handlers for item actions
#id INVAC_HANDLER_FN
INVAC_HANDLER_FN={
 [INVAC_EQUIP_C1]=HandleItemEquip,
 [INVAC_EQUIP_C2]=HandleItemEquip,
 [INVAC_EQUIP_C3]=HandleItemEquip,
 [INVAC_EQUIP_C4]=HandleItemEquip,
 [INVAC_REMOVE]=HandleItemRemove,
 [INVAC_USE]=HandleItemUse,
 [INVAC_EXAMINE]=HandleItemExamine,
 [INVAC_DISCARD]=HandleItemDiscard,
}

