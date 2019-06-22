-- UTILITIES

-- True and FALSE (with fewer character than "true" and "false").
#define TRUE 1
#define FALSE nil

-- Colors
#define C_BLACK 0
#define C_PURPLE 1
#define C_BLUE 2
#define C_GRAY 3
#define C_BROWN 4
#define C_GREEN 5
#define C_RED 6
#define C_LGRAY 7
#define C_LBLUE 8
#define C_ORANGE 9
#define C_BGRAY 10
#define C_LGREEN 11
#define C_PINK 12
#define C_BBLUE 13
#define C_YELLOW 14
#define C_WHITE 15

-- Global constants and aliases.
sin,cos,sqrt,floor,ceil,abs,min,max,random=math.sin,math.cos,math.sqrt,math.floor,math.ceil,math.abs,math.min,math.max,math.random
insert,remove,PI,prn=table.insert,table.remove,math.pi,print
ssub,supper,schr,ast=string.sub,string.upper,string.char,assert

-- Argument to prn to indicate that printing should be monospace.
#define PRN_MONOSPACE true
-- Argument to prn to indicate that it should use a small font
#define PRN_MONOSPACE_TINY true,1,true

-- Screen dimensions.
#define SCRW 240
#define SCRH 136
-- Half screen dimensions.
#define HSCRW 120
#define HSCRH 68

-- Button constants.
#define BTN_UP 0
#define BTN_DOWN 1
#define BTN_LEFT 2
#define BTN_RIGHT 3
#define BTN_PRI 4
#define BTN_SEC 5

-- enum of compass directions
-- WARNING: Don't change the values, they are assumed to be 0,1,2,3
-- in several places in the code.
#define DIR_N 0
#define DIR_E 1
#define DIR_S 2
#define DIR_W 3

-- TIC80 sync flags
#define T80_SYNC_TILES 1
#define T80_SYNC_SPRITES 2
#define T80_SYNC_MAP 4
#define T80_SYNC_SFX 8
#define T80_SYNC_MUSIC 16
#define T80_SYNC_PALETTE 32
#define T80_SYNC_ALL 63

-- Applies the given direction to the given coordinates, returning
-- the resulting coordinates. If dir is nil, returns x,z.
function ApplyDir(dir,x,z)
 if not dir then return x,z end
 z=z+(dir==DIR_N and 1 or dir==DIR_S and -1 or 0)
 x=x+(dir==DIR_E and 1 or dir==DIR_W and -1 or 0)
 return x,z
end

-- Returns the opposite of the given direction.
function OppositeDir(dir) return (dir+2)%4 end

-- Interpolation.
function Interp(x1,y1,x2,y2,x)
 if x2<x1 then return Interp(x2,y2,x1,y1,x) end
 if x<x1 then return y1 end
 if x>x2 then return y2 end
 return y1+(y2-y1)*(x-x1)/(x2-x1)
end

function DistSqXz(x1,z1,x2,z2)
 return (x1-x2)*(x1-x2)+(z1-z2)*(z1-z2)
end

--[[
function DistXz(x1,z1,x2,z2)
 return sqrt(DistSqXz(x1,z1,x2,z2))
end
]]

function Normalize(x,z)
 local m=sqrt(x*x+z*z)
 return x/m,z/m
end

function DeepCopy(t)
 if type(t)~="table" then return t end
 local r={}
 for k,v in pairs(t) do
  if type(v)=="table" then
   r[k]=DeepCopy(v)
  else
   r[k]=v
  end
 end
 return r
end

-- Overlays (deeply) the fields of table b over the
-- fields of table a. So if a={x=1,y=2,z=3} and
-- b={y=42,foo="bar"}, then this will return:
-- {x=1,y=42,z=3,foo="bar"}.
function Overlay(a,b)
 local result=DeepCopy(a)
 for k,v in pairs(b) do
  if result[k] and type(result[k])=="table" and
    type(v)=="table" then
   -- Recursive overlay.
   result[k]=Overlay(result[k],v)
  else
   result[k]=DeepCopy(v)
  end
 end
 return result
end

-- Removes object obj from the list, in-place.
function ListRem(list,obj)
 local idx=ListFind(list,obj)
 if not idx then return FALSE end
 remove(list,idx)
 return TRUE
end

-- Removes the item with the given index from the list in O(1)
-- but without keeping list ordering (replaces item with last
-- element, then removes the last element).
-- Returns the removed element.
function ListRemFast(list,idx)
 if idx<0 or idx>#list then return nil end
 local r=list[idx]
 list[idx]=list[#list]
 remove(list,#list)
 return r
end

-- Returns the index of the object in the list, or nil if not found.
function ListFind(list,obj)
 for i=1,#list do
  if list[i]==obj then return i end
 end
 return nil
end

function ListConcat(l1,l2)
 local r={}
 for i=1,#l1 do insert(r,l1[i]) end
 for i=1,#l2 do insert(r,l2[i]) end
 return r
end

-- Draws a horizontal progress bar.
--   x,y,w,h: the rectangle
--   frac: fraction that it's filled (0 to 1)
--   fg,bg: foreground and background colors.
function DrawHBar(x,y,w,h,frac,fg,bg)
 if h>3 then RectFB(x,y,w,h,bg,fg) else rect(x,y,w,h,bg) end
 rect(x,y,frac>0 and max(1,Clamp(w*frac,0,w)) or 0,h,fg)
end

function Clamp(x,lo,hi)
 return min(max(x,lo),hi)
end

#id N_SEGS
local N_SEGS={126,48,109,121,51,91,95,112,127,123}
-- Prints a tiny, right-aligned number.
--  n: the number to print
--  x,y: screen coordinates of rightmost digit
--  c: color
function PrintN(n,x,y,c)
 repeat
  local f=N_SEGS[(n%10)+1]
  n=n//10
  PrintN_HLi(f&64,x+1,y,c)
  PrintN_VLi(f&32,x+2,y+1,c)
  PrintN_VLi(f&16,x+2,y+3,c)
  PrintN_HLi(f&8,x+1,y+4,c)
  PrintN_VLi(f&4,x,y+3,c)
  PrintN_VLi(f&2,x,y+1,c)
  PrintN_HLi(f&1,x+1,y+2,c)
  x=x-4
 until n<=0
end
function PrintN_HLi(f,x,y,clr) if f>0 then line(x-1,y,x+1,y,clr) end end
function PrintN_VLi(f,x,y,clr) if f>0 then line(x,y-1,x,y+1,clr) end end

-- Prints centered string.
--  text: the text to print.
--  cx,cy: position of center of text.
--  clr?: color (default 15)
--  sc?: text scale (default 1)
--  ty?: if true, print tiny
function PrintC(text,cx,cy,clr,sc,ty)
 -- Print outside of screen bounds to measure text.
 local w,h=prn(text,0,-10,clr,FALSE,sc or 1,ty),6
 prn(text,cx-w//2,cy-h//2,clr or 15,FALSE,sc or 1,ty)
end

-- Draws a filled rectangle with border.
function RectFB(x,y,w,h,clr,bclr)
 rect(x,y,w,h,clr)
 rectb(x,y,w,h,bclr)
end

-- Draws a window.
function Window(x,y,w,h,clr,title)
 -- shadow
 rect(x+3,y+3,w,h,C_GRAY)
 -- window
 DecoRect(x,y,w,h,clr)
 -- title bar
 if title then
  local tw=prn(title,0,-10)
  local tx=x+w//2-tw//2
  rect(tx-5,y-4,tw+10,8,C_WHITE)
  prn(title,tx,y-2,clr)
 end
end

#define MENU_ITEM_H 8
-- Draws a menu and handles user input to manipulate it.
--   title: the title of the menu
--   items: the array of items.
--   x,y: the position of the center top point of the menu.
--        The menu will auto size keeping this point at its
--        top center position.
--   fg,bg: fg and bg colors for menu.
--          If bg is nil, it's a transparent overlay menu,
--          won't draw a background or a frame.
--   idx: currently selected index.
--   cen: if not nil, this is an array of booleans of the same
--        size as items, which indicates which items are enabled.
-- Returns the new selected index, which the caller must pass
-- back to this function on the next frame.
function Menu(title,items,x,y,fg,bg,idx,cen)
 local w,h=MeasureText(items)
 cen=cen or ArrOf(1,#items)
 w,h=w+16,h+16
 x=x-w//2
 if bg then Window(x,y,w,h,bg,title) end
 for i=1,#items do
  local iy,c=y+10+(i-1)*MENU_ITEM_H,fg
  c=idx==i and C_YELLOW or c
  c=cen[i] and c or C_GRAY
  prn(items[i],x+8,iy,c)
  _=idx==i and G.clk&16>0 and spr(248,x+2,iy-1,0)
 end
 -- Move cursor.
 idx=Dbtnp(BTN_DOWN) and WrapInc(idx,#items) or
   Dbtnp(BTN_UP) and WrapDec(idx,#items) or idx
 -- Try to skip over inactive items. This also runs on the first
 -- iteration, when we have just shown the dialog, to ensure that
 -- the initially selected item is enabled.
 for i=1,#items do  -- Try at most #items
  -- If we landed on an enabled item, that's it.
  if cen[idx] then break end
  idx=Dbtnp(BTN_UP) and WrapDec(idx,#items) or WrapInc(idx, #items)
 end
 return idx
end

-- Increment an index with wraparound.
function WrapInc(i,count) return i==count and 1 or i+1 end
function WrapDec(i,count) return i==1 and count or i-1 end

-- Removes and returns a random element from the list.
--[[
function ListRemRnd(l)
 if #l<1 then return nil end
 local i=random(1,#l)
 local r=l[i]
 remove(l,i)
 return r
end
]]

-- Randomizes the given damage.
function DmgRand(d)
 return max(1,random(d//2,d))
end

-- Shows a message box as a modal Action.
--   msg: the message. Can be a single string or array for multi line.
--        Embedded \n not supported.
--   fg,bg: foreground and background colors
--   sfx?: sfx to play
--   cb?: callback to call when user dismisses the alert.
function Alert(msg,fg,bg,sfx,cb)
 msg=StrToStrArray(msg)
 fg=fg or C_WHITE
 bg=bg or C_BLUE
 local w,h=MeasureText(msg)
 w,h=w+16,h+12
 local x,y=HSCRW-w//2,HSCRH-h//2
 A_Enq(_ActAlert,{msg=msg,fg=fg,bg=bg,x=x,y=y,w=w,h=h,
   sfx=sfx or SFX_OK,cb=cb},AF_MODAL)
end
function _ActAlert(st)
 Window(st.x,st.y,st.w,st.h,st.bg)
 if st.sfx then SFX_Play(st.sfx) st.sfx=nil end
 for i=1,#st.msg do
  prn(st.msg[i],st.x+8,st.y+(i-1)*8+8,st.fg) end
 if Dbtnp(BTN_PRI) or Dbtnp(BTN_SEC) then
  _=st.cb and st.cb()
  return TRUE
 end
end

-- Measures the given text, returning w,h assuming a vertical stride
-- of 8 pixels.
--   lines: The text to measure, which can be a single string or
--          an array of strings for multiline (\n not supported).
--   mode: if PRN_MONOSPACE, will print monospace.
function MeasureText(lines,mode)
 if not lines then return 0,0 end
 lines=StrToStrArray(lines)
 local w=0
 for i=1,#lines do w=max(w,prn(lines[i],300,200,1,mode or false)) end
 return w,#lines*8
end

-- Flag that indicates that the choice dialog is cancelable.
#define CHD_F_CANCELABLE 1
-- Flag that indicates that the dialog should appear at the corner
-- of the screen rather than centered.
#define CHD_F_CORNER 2

-- Shows a dialog that asks the player to make a choice.
-- This is shown as a modal Action.
--   text: A single string or an array of strings (for multiline)
--         with the text to display.
--   choices: array of choices
--   cb: callback to call when choice is made. It will receive
--       the choice index as the argument. If the dialog was
--       canceled, it will receive nil.
--   fg,bg: Foreground and background colors.
--   udata?: arbitrary param to pass to callback
--   fl: flags
--   cen: choice enabled booleans (one boolean per choice,
--     indicates which are enabled). If cen==nil, all are enabled.
function ChoiceDialog(text,choices,cb,fg,bg,udata,fl,cen)
 local tw,th,cw,ch,s
 fg,bg,fl=fg or C_WHITE,bg or C_BLUE,fl or 0
 tw,th=MeasureText(text)
 cw,ch=MeasureText(choices)
 cw,ch=cw+16,ch+8
 s={sel=1,choices=choices,text=text,cb=cb,udata=udata,
   w=max(tw,cw)+16,h=th+ch+16,fg=fg,bg=bg,fl=fl,cen=cen}
 if fl&CHD_F_CORNER<1 then
  -- Center on screen.
  s.x,s.y=HSCRW-s.w//2,HSCRH-s.h//2
 else
  -- Right-bottom corner of screen.
  s.x,s.y=SCRW-s.w,SCRH-s.h
 end
 s.mx,s.my=s.x+s.w//2,s.y+th+4
 A_Enq(_ActChoiceDialog,s,AF_MODAL)
 return TRUE
end
function _ActChoiceDialog(s,isFg)
 if s.ended then
  return TRUE
 end
 Window(s.x,s.y,s.w,s.h,s.bg,s.title)
 PrintLines(s.text,s.x+8,s.y+8,s.fg)
 local nsel=Menu(nil,s.choices,s.mx,s.my,s.fg,nil,s.sel,s.cen)
 s.sel=isFg and nsel or s.sel
 if Dbtnp(BTN_PRI) then
  -- If current choice is not enabled, don't do anything.
  if s.cen and not s.cen[s.sel] then return FALSE end
  -- When we call the callback, we could in theory end up in a
  -- situation where the callback initiates a modal action, in which
  -- case this current action will survive and continue to be called,
  -- so we ward against that by setting s.ended=1 so we know to
  -- return TRUE and end this silently if control gets back to us.
  s.ended=1
  -- Call the callback.
  s.cb(s.sel,s.udata)
  -- We are done.
  return TRUE
 end
 if s.fl&CHD_F_CANCELABLE>0 and Dbtnp(BTN_SEC) then
  -- Cancel.
  s.ended=1
  s.cb(nil,s.udata)
  return TRUE
 end
 return FALSE
end

function StrToStrArray(s)
 return type(s)=="string" and {s} or s
end

-- Prints a single string of a set of lines (array).
--   l: the line or lines to print.
--   x,y: the position at which to start printing
--   c: the color to use.
--   lim?: how many characters to print (for animation).
--   mode: if PRN_MONOSPACE, will print monospace.
-- Returns TRUE if the full message was printed, FALSE if it
-- was chopped off due to the limit.
function PrintLines(l,x,y,c,lim,mode)
 if not l then return end
 lim=lim or 9999
 l=StrToStrArray(l)
 for i=1,#l do
  if lim<1 then break end
  local li=ssub(l[i],1,min(lim,#l[i]))
  prn(li,x,y+8*(i-1),c or C_WHITE,mode or false)
  lim=lim-#l[i]
 end
 return lim>0
end

function Zeroes(len) return ArrOf(0,len) end

-- Returns an array of v's of the given length.
function ArrOf(v,len)
 local r={}
 for i=1,len do insert(r,v) end
 return r
end

function Stipple(x0,y0,w,h,clr)
 for y=y0,y0+h-1 do
  for x=x0+y%2,x0+w-1,2 do
   pix(x,y,clr)
  end
 end
end

-- Sets the palette map.
--   map?: the set of colors to map to
--    If nil, will reset to the default map.
function PalMapSet(map)
 for i=0,15 do
  poke4(0x3FF0*2+i,map and map[i] or i)
 end
end

-- Sets the palette map to map all colors but 0 to the given one.
function PalMapSetUni(c)
 for i=1,15 do poke4(0x3FF0*2+i,c) end
end

function GetDpadP()
 return Dbtnp(BTN_RIGHT) and 1 or Dbtnp(BTN_LEFT) and -1 or 0,
   Dbtnp(BTN_DOWN) and 1 or Dbtnp(BTN_UP) and -1 or 0
end

function NilIf0(v)
 return v~=0 and v or nil
end

function Seq(from,to)
 local r={}
 for i=from,to do insert(r,i) end
 return r
end

function BoolToNum(b) return b and 1 or 0 end

function DotProd(x1,z1,x2,z2) return x1*x2+z1*z2 end

function Dbtnp(b) return G.bp[b] end

-- Draws a meter bar.
--   x,y: position where it should be drawn (top-left)
--   ic: icon (a sprite#)
--   w: width of the bar, in pixels.
--   fg,bg: fg/bg color of the bar.
--   f: fraction of the bar to fill (0-1)
--   warn: if not nil, warn (red outline and blinking message)
--     if this is below 20%. This is the message to display.
function DrawMeter(x,y,ic,w,fg,bg,f,warn)
 spr(ic,x,y)
 if warn and G.clk&64<1 and f<.2 then
  prn(warn,x+10,y+2,fg)
 else
  rect(x+10,y+2,w,4,0)
  rectb(x+10,y+2,w,4,fg)
  rect(x+10,y+2,w*f,4,fg)
  _=f<.2 and warn and rectb(x+10,y+2,w,4,C_RED)
 end
end

-- Changes a pair of (x,y) towards a target (tx,ty) by a maximum of d
-- units. Returns the updated x,y.
function ChangeXyTowards(x,y,tx,ty,d)
 d=d or 1
 return x<tx and min(tx,x+d) or max(tx,x-d),
   y<ty and min(ty,y+d) or max(ty,y-d)
end

-- Pads a string to the left with spaces until it's n chars long.
--[[
function LPad(s,n)
 s=""..s
 while #s<n do s=" "..s end
 return s
end
]]

function DecoRect(x,y,w,h,bg)
 _=bg and rect(x,y,w,h,bg)
 rectb(x,y,w,h,C_WHITE)
 rectb(x+1,y+1,w-2,h-2,C_BROWN)
 spr(234,x,y,0,1,0)
 spr(234,x+w-8,y,0,1,1)
 spr(234,x,y+h-8,0,1,2)
 spr(234,x+w-8,y+h-8,0,1,3)
end

