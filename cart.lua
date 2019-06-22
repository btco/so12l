-- title: Shadow Over the Twelve Lands
-- author: Bruno Oliveira
-- desc: An RPG game
-- script: lua
-- saveid: SO12L
sin,cos,sqrt,floor,ceil,abs,min,max,random=math.sin,math.cos,math.sqrt,math.floor,math.ceil,math.abs,math.min,math.max,math.random
insert,remove,PI,prn=table.insert,table.remove,math.pi,print
ssub,supper,schr,ast=string.sub,string.upper,string.char,assert
function f6(dir,x,z)if not dir then return x,z end
z=z+(dir==0 and 1 or dir==2 and -1 or 0)x=x+(dir==1 and 1 or dir==3 and -1 or 0)return x,z
end
function y9(dir)return (dir+2)%4 end
function f7(x1,y1,x2,y2,x)if x2<x1 then return f7(x2,y2,x1,y1,x)end
if x<x1 then return y1 end
if x>x2 then return y2 end
return y1+(y2-y1)*(x-x1)/(x2-x1)end
function d9(x1,z1,x2,z2)return (x1-x2)*(x1-x2)+(z1-z2)*(z1-z2)end
function z5(x,z)local m=sqrt(x*x+z*z)return x/m,z/m
end
function a4(t)if type(t)~="table" then return t end
local r={}for k,v in pairs(t)do
if type(v)=="table" then
r[k]=a4(v)else
r[k]=v
end
end
return r
end
function i4(a,b)local result=a4(a)for k,v in pairs(b)do
if result[k]and type(result[k])=="table" and
type(v)=="table" then
result[k]=i4(result[k],v)else
result[k]=a4(v)end
end
return result
end
function e0(list,obj)local idx=b1(list,obj)if not idx then return nil end
remove(list,idx)return 1
end
function z6(list,idx)if idx<0 or idx>#list then return nil end
local r=list[idx]list[idx]=list[#list]remove(list,#list)return r
end
function b1(list,obj)for i=1,#list do
if list[i]==obj then return i end
end
return nil
end
function n3(l1,l2)local r={}for i=1,#l1 do insert(r,l1[i])end
for i=1,#l2 do insert(r,l2[i])end
return r
end
function i5(x,y,w,h,frac,fg,bg)if h>3 then i7(x,y,w,h,bg,fg)else rect(x,y,w,h,bg)end
rect(x,y,frac>0 and max(1,a8(w*frac,0,w))or 0,h,fg)end
function a8(x,lo,hi)return min(max(x,lo),hi)end
local n4={126,48,109,121,51,91,95,112,127,123}function f8(n,x,y,c)repeat
local f=n4[(n%10)+1]n=n//10
i6(f&64,x+1,y,c)f9(f&32,x+2,y+1,c)f9(f&16,x+2,y+3,c)i6(f&8,x+1,y+4,c)f9(f&4,x,y+3,c)f9(f&2,x,y+1,c)i6(f&1,x+1,y+2,c)x=x-4
until n<=0
end
function i6(f,x,y,clr)if f>0 then line(x-1,y,x+1,y,clr)end end
function f9(f,x,y,clr)if f>0 then line(x,y-1,x,y+1,clr)end end
function a2(text,cx,cy,clr,sc,ty)local w,h=prn(text,0,-10,clr,nil,sc or 1,ty),6
prn(text,cx-w//2,cy-h//2,clr or 15,nil,sc or 1,ty)end
function i7(x,y,w,h,clr,bclr)rect(x,y,w,h,clr)rectb(x,y,w,h,bclr)end
function d0(x,y,w,h,clr,title)rect(x+3,y+3,w,h,3)c3(x,y,w,h,clr)if title then
local tw=prn(title,0,-10)local tx=x+w//2-tw//2
rect(tx-5,y-4,tw+10,8,15)prn(title,tx,y-2,clr)end
end
function i8(title,items,x,y,fg,bg,idx,cen)local w,h=e1(items)cen=cen or g1(1,#items)w,h=w+16,h+16
x=x-w//2
if bg then d0(x,y,w,h,bg,title)end
for i=1,#items do
local iy,c=y+10+(i-1)*8,fg
c=idx==i and 14 or c
c=cen[i]and c or 3
prn(items[i],x+8,iy,c)_=idx==i and G.clk&16>0 and spr(248,x+2,iy-1,0)end
idx=F(1)and c4(idx,#items)or
F(0)and g0(idx,#items)or idx
for i=1,#items do  
if cen[idx]then break end
idx=F(0)and g0(idx,#items)or c4(idx,#items)end
return idx
end
function c4(i,count)return i==count and 1 or i+1 end
function g0(i,count)return i==1 and count or i-1 end
function z7(d)return max(1,random(d//2,d))end
function U(msg,fg,bg,sfx,cb)msg=i9(msg)fg=fg or 15
bg=bg or 2
local w,h=e1(msg)w,h=w+16,h+12
local x,y=120-w//2,68-h//2
J(z8,{msg=msg,fg=fg,bg=bg,x=x,y=y,w=w,h=h,sfx=sfx or 4,cb=cb},1)end
function z8(st)d0(st.x,st.y,st.w,st.h,st.bg)if st.sfx then a3(st.sfx)st.sfx=nil end
for i=1,#st.msg do
prn(st.msg[i],st.x+8,st.y+(i-1)*8+8,st.fg)end
if F(4)or F(5)then
_=st.cb and st.cb()return 1
end
end
function e1(lines,mode)if not lines then return 0,0 end
lines=i9(lines)local w=0
for i=1,#lines do w=max(w,prn(lines[i],300,200,1,mode or false))end
return w,#lines*8
end
function b6(text,choices,cb,fg,bg,udata,fl,cen)local tw,th,cw,ch,s
fg,bg,fl=fg or 15,bg or 2,fl or 0
tw,th=e1(text)cw,ch=e1(choices)cw,ch=cw+16,ch+8
s={sel=1,choices=choices,text=text,cb=cb,udata=udata,w=max(tw,cw)+16,h=th+ch+16,fg=fg,bg=bg,fl=fl,cen=cen}if fl&2<1 then
s.x,s.y=120-s.w//2,68-s.h//2
else
s.x,s.y=240-s.w,136-s.h
end
s.mx,s.my=s.x+s.w//2,s.y+th+4
J(z9,s,1)return 1
end
function z9(s,isFg)if s.ended then
return 1
end
d0(s.x,s.y,s.w,s.h,s.bg,s.title)d1(s.text,s.x+8,s.y+8,s.fg)local nsel=i8(nil,s.choices,s.mx,s.my,s.fg,nil,s.sel,s.cen)s.sel=isFg and nsel or s.sel
if F(4)then
if s.cen and not s.cen[s.sel]then return nil end
s.ended=1
s.cb(s.sel,s.udata)return 1
end
if s.fl&1>0 and F(5)then
s.ended=1
s.cb(nil,s.udata)return 1
end
return nil
end
function i9(s)return type(s)=="string" and {s}or s
end
function d1(l,x,y,c,lim,mode)if not l then return end
lim=lim or 9999
l=i9(l)for i=1,#l do
if lim<1 then break end
local li=ssub(l[i],1,min(lim,#l[i]))prn(li,x,y+8*(i-1),c or 15,mode or false)lim=lim-#l[i]end
return lim>0
end
function n5(len)return g1(0,len)end
function g1(v,len)local r={}for i=1,len do insert(r,v)end
return r
end
function n6(x0,y0,w,h,clr)for y=y0,y0+h-1 do
for x=x0+y%2,x0+w-1,2 do
pix(x,y,clr)end
end
end
function g2(map)for i=0,15 do
poke4(0x3FF0*2+i,map and map[i]or i)end
end
function A0(c)for i=1,15 do poke4(0x3FF0*2+i,c)end
end
function A1()return F(3)and 1 or F(2)and -1 or 0,F(1)and 1 or F(0)and -1 or 0
end
function c2(v)return v~=0 and v or nil
end
function A2(from,to)local r={}for i=from,to do insert(r,i)end
return r
end
function b2(b)return b and 1 or 0 end
function A3(x1,z1,x2,z2)return x1*x2+z1*z2 end
function F(b)return G.bp[b]end
function A4(x,y,ic,w,fg,bg,f,warn)spr(ic,x,y)if warn and G.clk&64<1 and f<.2 then
prn(warn,x+10,y+2,fg)else
rect(x+10,y+2,w,4,0)rectb(x+10,y+2,w,4,fg)rect(x+10,y+2,w*f,4,fg)_=f<.2 and warn and rectb(x+10,y+2,w,4,6)end
end
function j0(x,y,tx,ty,d)d=d or 1
return x<tx and min(tx,x+d)or max(tx,x-d),y<ty and min(ty,y+d)or max(ty,y-d)end
function c3(x,y,w,h,bg)_=bg and rect(x,y,w,h,bg)rectb(x,y,w,h,15)rectb(x+1,y+1,w-2,h-2,4)spr(234,x,y,0,1,0)spr(234,x+w-8,y,0,1,1)spr(234,x,y+h-8,0,1,2)spr(234,x+w-8,y+h-8,0,1,3)end
A={
queue={},}function A5()A.queue={}end
function J(proc,state,afl)A7(proc,state,afl)end
function A6()if #A.queue<1 then return nil end
local lma=nil
for i=#A.queue,1,-1 do
if A.queue[i].afl&1>0 then lma=i break end
end
if lma then
local s=min(lma+1,#A.queue)for i=s,2,-1 do
(A.queue[i].proc)(A.queue[i],nil)end
end
local a=A.queue[1]if (a.proc)(a,1)then
remove(A.queue,b1(A.queue,a))else
a.clk=a.clk+1
end
return 1
end
function A7(proc,state,afl)ast(proc)state=state or {}state.proc=proc
state.clk=0
state.afl=afl or 0
if state.afl&1>0 then
insert(A.queue,1,state)else
insert(A.queue,state)end
end
B=nil
n7={
c={},ord={},t=nil,tac=0,nx=nil,q=nil,am=nil,rbad=nil,bgc=0,dsp=0,xp=0,gp=0,ltchi=0,sur=nil
}function n8(foes,vst)B=a4(n7)for i=1,6 do insert(B.c,{})end
for i=1,#PA do C7(i)end
ast(#foes<7)for i,e in ipairs(foes)do
C8(e,4+(i-1)//2)B.xp,B.gp=B.xp+e.xp,B.gp+e.gp
end
a1(6728,{B.gp,B.xp})B.gp,B.xp=Q()if (H(171)&1>0)then
l4(B.xp,1)h4(B.gp,1)B=nil
return
end
B.sur=(foes[1].eid==34)c5()for i,t in ipairs(B.ord)do
t.rx,t.ry=t.ch and t.cx-40 or t.cx+180//2,t.cy
end
table.sort(B.ord,A8)B.nx=#B.ord   
B.tac=0
a5()J(B3)J(function()B=nil return 1 end)J(j2,{},1)B.bgc=f2(26388)[vst]or 0
B.dsp=vst
d4(5)a1(6727,{})end
function A8(a,b)return (a.ent and a.ent.speed or l3(a.ch)or 0)>
(b.ent and b.ent.speed or l3(b.ch)or 0)end
function A9()B=nil end
function B0()cls(B.bgc)for x=0,184+8,8 do spr(B.dsp,x,0)spr(B.dsp,x,108-8)end
for i,t in ipairs(B.ord)do
local sid,ox=0,0
_=t.ent and g2(t.ent.palm)if t.po==4 then
elseif t.po==0 then
sid=t.sid+(G.clk&16>0 and t.ssz or 0)if t.ch then
if d2(t.chi,16)then sid=379+t.chi end
if d2(t.chi,2)then sid=327+t.chi end
if d2(t.chi,4)then sid=343+t.chi end
end
elseif t.po==3 then
sid,ox=t.sid,t.ch and -2 or 2
A0(14)elseif t.po<=2 then
sid=t.sid+(t.po-1+2)*t.ssz
elseif t.po==5 then
sid=t.sid+(min((G.clk-t.pocs)//10,3))*t.ssz+(t.ch and 64 or 0)elseif t.po==6 then
sid=t.sid+(min((G.clk-t.pocs)//10,3))*t.ssz-(t.ch and 4 or 0)elseif t.po==7 then sid=359+t.chi
end
if t.co&1>0 then
local os,f={0,1,2,1},1+(G.clk//8)%4
ox=ox+os[f]end
spr(sid,ox+t.rx-t.ssz*4,t.ry-t.ssz*4,0,1,0,0,t.ssz,t.ssz)g2()_=B.am and B.t==t and t.ch and G.clk&16>0 and
rectb(t.rx-7,t.ry-7,14,14,14)local o,fr
o=t.ch or t.ent
fr=o.hp/o.maxHp
_=fr<1 and t.po~=4 and
i5(ox+t.rx-3,t.ry-t.ssz*4-2,6,1,fr,fr>.8 and 11 or fr>.2 and 14 or 6,fr>.8 and 5 or fr>.2 and 9 or 1)end
end
function B1(chi)return B and B.t and B.t.chi==chi end
function B2(bad)bad.narr=B.t.ch.name.." "..bad.narr
B.rbad=bad
end
function B3(st,isFg)if s0()then return 1 end
if not isFg then return end
if B.q then
d4(L.lvl.mus)a1(6742,{B.q=="SUR" and 1 or 0})return 1
end
if D6()then
B.q=1
e4()J(D5,{},1)else
if B.t.ch then B4(B.t)else C4(B.t)end
end
end
function a5()D4()if B.tac>0 then
B.tac=B.tac-1
return
end
if B.t then B.t.co=B.t.co&~1 end
B.nx=c4(B.nx,#B.ord)B.t=B.ord[B.nx]B.tac=B.t.ch and 0 or B.t.ent.nat-1
ast(B.tac,"BTA")end
function B4(t)if not d5(t.chi)then
a5()return
end
B.am=1
local as=c9(26218)if B.sur then as[7]="SURRENDER" end
b6(t.ch.name.."?",as,B5,15,2,t,2)end
function B5(m,t)B.am=nil
local f=o0[m]ast(f)f(m,t)end
function n9(m,t)if j1(t,m<6 and 1 or -1)then
a5()return
end
U(c9(
m<1 and 26314 or 26257),15,2,2)return
end
function B6(m,t)local bad=r7(t.ch,2)if not bad then
U(c9(25772))return
end
g3(bad)end
function B7(m,t)local bad=r7(t.ch,1)if not bad then
U(c9(25840))return
end
g3(bad)end
function B8(m,t)m9(t.chi,B9)end
function B9(r)if not r then return end
if B.rbad then
local b
b,B.rbad=B.rbad,nil
g3(b)else
a5()end
end
function C0(m,t)l5(nil,nil,1,c9(26410),nil,C1)end
function C1(it)if it then
ast(B.t.chi)p2(it,B.t.chi,C2)end
end
function C2(r)if r<1 then return end
if B.rbad then
local b
b,B.rbad=B.rbad,nil
g3(b)else
a5()end
end
function C3()if B.sur then
B.q="SUR"
else
a5()end
end
o0={
B7,B6,B8,C0,n9,n9,C3,}function C4(t)local i,j,att
if t.ent.bad.ak==1 then
C5(t)else
C6(t)end
end
function C5(t)if j1(t,-1)then
a5()return
end
i,j=e2(t)if i<2 or #B.c[i]<1 then
a5()return
end
i=i-1
j=random(1,#B.c[i])local v=B.c[i][j]if v.chi and (B.ltchi and v.chi==B.ltchi or d2(v.chi,16))then
j=random(1,#B.c[i])v=B.c[i][j]end
if v.ent then
a5()return
end
B.ltchi=v.chi
j4(v,t.ent.bad)end
function C6(t)local i,j,off,cht
j=random(1,#B.ord)for i=1,#B.ord do
j=c4(j,#B.ord)cht=cht or (B.ord[j].ch and B.ord[j])end
if not cht then return end  
j4(cht,t.ent.bad)end
function e2(t)ast(t)for i,c in ipairs(B.c)do
local j=b1(B.c[i],t)if j then return i,j end
end
error("!TOK")end
function j1(t,dir)local i,j,tci
i,j=e2(t)
tci=i+dir
if tci<1 or tci>6 then return nil end
if #B.c[tci]>3 then return nil end
if #B.c[tci]>0 and not D0(B.c[tci][1],t)then
return nil end
remove(B.c[i],j)insert(B.c[tci],t)c5()J(j2,{},1)return 1
end
function j2(st)local r,d=1,1
d=((H(171)&2>0)and btn(7))and 5 or 1
for i,t in ipairs(B.ord)do
t.rx,t.ry=j0(t.rx,t.ry,t.cx,t.cy,d)r=r and d9(t.rx,t.ry,t.cx,t.cy)<1
end
return r
end
function C7(chi)local ch,tok=PA[chi]if ch.hp<1 then return end
tok={chi=chi,ch=ch,sid=252+chi*16,ssz=1,po=0,pocs=G.clk,co=0}insert(B.c[(ch.class==4 or ch.class==3)and
2 or 3],tok)insert(B.ord,tok)return tok
end
function C8(e,ci)ast(e and ci)local tok={ent=e,sid=e.sid,ssz=e.fl&2   >0 and 2 or 1,po=0,pocs=G.clk,co=0}insert(B.c[ci],tok)insert(B.ord,tok)end
function C9(t)ast(t~=B.t,"BREM")local i,j=e2(t)e0(B.c[i],t)e0(B.ord,t)B.nx=b1(B.ord,B.t)end
function c5()for i,c in ipairs(B.c)do
local h=0
for j,tk in ipairs(c)do
h=h+(j>1 and 12 or 0)tk.cx=(i-1)*30+30//2
tk.cy,h=h,h+tk.ssz*8
end
for j,tk in ipairs(c)do
tk.cy=tk.cy+(110-h)//2
end
end
end
function D0(t1,t2)return (t1.ch and t2.ch)or (t1.ent and t2.ent)end
function g3(bad)local ri,rf=1,1
if bad.ak==2 or bad.ak==3 then ri,rf=1,9 end
local i,j=e2(B.t)if not D1(i+ri,i+rf,bad)then
U(c9(26337))return
end
end
function D1(ci,cf,bad)local cs
ci,cf=a8(ci,1,6),a8(cf,1,6)for i=ci,cf do if j3(i)then cs=i break end end
if not cs then return nil end
J(D2,{ci=ci,cf=cf,cs=cs,i=1,bad=bad},1)return 1
end
function D2(st)local c=B.c[st.cs]local t=c[st.i]if st.bad.ak==3 then
_=G.clk%16>4 and rectb(t.cx-30//2,5,30,110-10,14)else
_=G.clk%16>4 and spr(248,t.rx-t.ssz*4-9,t.ry-4,0)end
st.i=F(0)and g0(st.i,#c)or st.i
st.i=F(1)and c4(st.i,#c)or st.i
if F(2)and st.cs>st.ci then
for i=st.cs-1,st.ci,-1 do if j3(i)then st.cs=i break end end
elseif F(3)and st.cs<st.cf then
for i=st.cs+1,st.cf do if j3(i)then st.cs=i break end end
end
st.i=min(st.i,#B.c[st.cs])if F(5)then return 1 end
if F(4)then
j4(t,st.bad)return 1
end
end
function j3(ci)if ci<1 or ci>#B.c then return nil end
for i,t in ipairs(B.c[ci])do
if t.ent then return 1 end
end
return nil
end
function j4(t,bad)local hit,d,def,dm,i,mad
bad=a4(bad)if bad.ak==3 then
i,_=e2(t)J(D8,{at=B.t,tc=i,bad=bad},1)return
end
def=t.ent and t.ent.def or r6(t.ch)ast(bad and def,"BDAd")a1(B.t.ch and 6771 or 6860,{
B.t.chi or B.t.ent.eid,t.chi or t.ent.eid,bad.att,def,bad.fl,bad.ak})bad.att,def,bad.fl=Q()mad=max(3,bad.att-def)d=z7(mad)if t.ch then a1(6935,{t.chi,d})d=Q()end
d=t.ch and ceil((f7(t.ch.maxHp//2,1,0,0.4,t.ch.hp))*d)or d
hit=bad.fl&32>0 or (bad.fl&16<1 and (
d>0 and
(d>1 or random(1,5)>2)and
(B.t.co&1<1 or random(1,5)<2)))if hit and bad.fl&1>0 and t.ent then
hit=hit and random(0,100)>t.ent.mr
end
J(
bad.ak==1 and D3 or D7,{at=B.t,tt=t,dmg=hit and d,bad=bad},1)end
function D3(st)local a,t,ax,ay,d,sgn,bad
bad=st.bad
d=((H(171)&2>0)and btn(7))and 5 or 2
st.p=st.p or 0
a,t=st.at,st.tt
sgn=a.cx>t.cx and 1 or -1
ax,ay=t.cx+sgn*4*(t.ssz+1),t.cy
if st.p==0 then
a.rx,a.ry=j0(a.rx,a.ry,ax,ay,d)if d9(a.rx,a.ry,ax,ay)<1 then
st.p=1
b7(a,bad.fl&1>0 and 6 or 1)end
elseif st.p==1 then
st.p1c=(st.p1c or 0)+(((H(171)&2>0)and btn(7))and 5 or 1)_=st.p1c>20 and st.p1c<40 and j8(t,st.dmg,st.p1c//4,bad)if st.p1c==20 then
a3(st.dmg and 7 or 8)j6(t,st.dmg,bad)_=bad.fl&1<1 and b7(a,2)b7(t,st.dmg and 3 or t.po)end
st.p=st.p1c>50 and 2 or 1
_=bad.narr and a2(bad.narr,92,96)else
j5(a,t)a.rx,a.ry=j0(a.rx,a.ry,a.cx,a.cy,d)if d9(a.rx,a.ry,a.cx,a.cy)<1 then
a5()return 1
end
end
end
function j5(a,t)b7(a,0)b7(t,o1(t)>0 and 0 or 4)end
function j6(t,dmg,bad)if not dmg then a3(8)return end
a3(7)local o=t.ent or t.ch
o.hp=max(0,o.hp-dmg)if bad.fl&4>0 then
if not t.ch or d5(t.chi)then
t.co=t.co|1
end
end
if bad.fl&64>0 then
j1(t,t.ent and 1 or -1)end
if t.chi then
j7(bad.fl,128,t.chi,1)j7(bad.fl,256,t.chi,2)j7(bad.fl,512,t.chi,4)end
end
function j7(v,m,chi,cm)_=v&m>0 and l7(chi,cm)end
function D4()local d=nil
for i=#B.ord,1,-1 do
local t=B.ord[i]if o1(t)<1 then
a3(10)C9(t)d=1
end
end
if d then
c5()J(j2,{},1)end
end
function D5(st)B.q=1
a2("Victory!",184//2,18,15)_=st.clk==1 and a3(14)if st.clk==100 then l4(B.xp)h4(B.gp)end
return st.clk>110
end
function D6()for i,t in ipairs(B.ord)do
if t.ent then return nil end
end
return 1
end
function o1(t)return t.ch and t.ch.hp or t.ent.hp
end
function D7(st)local a,t,sgn,x0,y0,x1,y1,px,py,bad,d
bad=st.bad
st.pfc=((H(171)&2>0)and btn(7))and 5 or (st.pfc or 20)st.p=st.p or 0
st.pc=(st.pc or 0)+1
a,t=st.at,st.tt
sgn=a.cx>t.cx and 1 or -1
x0,y0=a.cx-sgn*a.ssz,a.cy-3
x1,y1=t.cx,t.cy
if st.p==0 then
b7(a,bad.fl&2>0 and 7 or
bad.fl&1>0 and 6 or 5)if st.pc>25 then st.p,st.pc=1,0 end
elseif st.p==1 then
px,py=f7(0,x0,st.pfc,x1,st.pc),f7(0,y0,st.pfc,y1,st.pc)spr(bad.psp,px,py,0)if st.pc>st.pfc then st.p,st.pc=2,0 end
_=bad.fl&2>0 and b7(a,0)else
if st.pc==1 then
a3(st.dmg and 7 or 8)_=st.dmg and b7(t,3)j6(t,st.dmg,bad)end
_=st.pc<20 and j8(t,st.dmg,st.pc//4,bad)if st.pc>30 then
j5(a,t)a5()return 1
end
end
_=st.p>0 and bad.narr and a2(bad.narr,92,100)end
function D8(st)local a,t,ts,bad,i,def,d
bad=st.bad
st.p=st.p or 0
st.pc=(st.pc or 0)+1
a=st.at
if st.p==0 then
b7(a,bad.fl&1>0 and 6 or 5)if st.pc>35 then st.p,st.pc=1,0 end
elseif st.p==1 then
for i=8,110-16,8 do spr(bad.psp,(st.tc-1)*30+st.pc//2,i,0)end
if st.pc>45 then st.p,st.pc=2,0 end
else
ts=B.c[st.tc]if st.pc==1 then
a3(7)for i=1,#ts do
def=ts[i].ent and ts[i].ent.def or r6(ts[i].ch)assert(def,"BAAd")d=max(1,bad.att-def)b7(ts[i],3)j6(ts[i],d,bad)_=st.pc<20 and j8(ts[i],d,st.pc//4,bad)end
end
if st.pc>30 then
for i=1,#ts do j5(a,ts[i])end
a5()return 1
end
end
_=st.p>0 and bad.narr and a2(bad.narr,92,100)end
function b7(t,po)if t.po~=po then t.po,t.pocs=po,G.clk end end
function j8(t,dmg,oy,bad)if dmg and dmg<1 then return end
a2(
dmg and ("-"..dmg)or (bad.fl&1>0 and "NO EFFECT" or "MISS"),t.cx-(t.ch and -8 or 8),t.cy-t.ssz*4-oy,dmg and 6 or 7)end
function j9(chi)ast(chi>0 and chi<5,"!CEFc"..chi)return w4(244+chi-1)end
function d2(chi,mask)return 0<(j9(chi)&mask)end
function D9(chi,mask)ast(chi>0 and chi<5,"!CEFs"..chi)return h9(244+chi-1,j9(chi)|mask)end
function E0(chi,mask)ast(chi>0 and chi<5,"!CEFc"..chi)return h9(244+chi-1,j9(chi)&~mask)end
function E1(c)if not c then return end
if c==1 and B then B.q=1 end
if c==2 then for k,v in pairs(ZD)do r9(k)end end
if c==3 then E4()end
if c==4 then E5()end
end
function E2()J(E3,{c=""},1)end
function E3(st)cls(3)prn("Patch:",8,40)prn(st.c,8,50,14,true,1,true)for k=27,36 do
if keyp(k)and #st.c<64 then st.c=st.c..schr(k-27+48)end
end
for k=1,7 do
if keyp(k)and #st.c<64 then st.c=st.c..schr(k+64)end
end
if F(2)and #st.c>0 then st.c=ssub(st.c,1,#st.c-1)end
if F(4)and #st.c>0 and #st.c%2==0 then
local p=53388
for i=1,#st.c,2 do
XP[p]=tonumber(ssub(st.c,i,i+1),16)p=p+1
end
XP[p]=125
a1(53388)return 1
end
return F(5)end
function E4()end
function E5()for _,it in ipairs(P.inv)do
it.st=it.st&~1
end
for _,ch in ipairs(PA)do
for k,v in pairs(ch.eq)do
if v then v.st=v.st&~1 end
end
end
end
function E6()E8()end
function E7(eid)local entd=ENTD[eid]ast(entd,"Bad EID " .. eid)return a4(entd)end
function E8()b4(51725)ENTD={}local c=0
while 1 do
local sig,d=C(),{}if sig==0 then break end
ast(sig==151,"Bad ent db")local eid=C()ast(not ENTD[eid],"DupE"..eid)d.eid=eid
d.name=c8()d.fl=C()d.sid=a6()d.palm=d.fl&1>0 and Q2(15)d.speed=C()d.maxHp=a6()d.hp=d.maxHp
d.def=0 
d.xp=a6()d.gp=a6()d.mr=C()d.nat=C()d.bad=E9()ENTD[eid]=d
c=c+1
end
trace("ENT load "..c)end
function E9()local r={}r.ak=C()r.att=C()r.psp=C()r.narr=c8()r.fl=a6()return r.ak>0 and r or nil
end
G={
m=1,csn=0,xin=0,booted=nil,clk=0,bsr={},tbank=0,sbank=0,bsw=nil,b={},bp={},}function o2(lvlN,epnum)trace("ch lvl "..lvlN.." e"..epnum)p7(lvlN,epnum)end
function k0()A5()A9()L9()r5()q7()w3()end
function F0()a9(6)end
function F1(csn)e4()G.csn=csn a9(8)end
function F2(endn)G.endn=endn
a9(7)end
function F3()G.pok=pmem(254)==123
pmem(254,123)end
function TIC()
G.bsw=nil
G.frst=time()if G.xin==0 then
n1()G.xin=1
return
elseif G.xin==1 then
w2()G.xin=2
return
elseif G.xin==2 then
b8(4,0)G.xin=3
L8()H7()H6()E6()O5()I6()return
end
G.clk=G.clk+1
F4()G.booted=G.booted or F3()or 1
_=G.m==3 or G.m==4 or cls(3)GMTIC[G.m]()if (H(171)&4>0)then
local t=ceil(time()-G.frst)t=t<10 and "0"..t or t
prn(t,4,4,15)end
end
function F4()for b=0,7 do
G.bp[b]=btn(b)and not G.b[b]G.b[b]=btn(b)end
end
function b8(mask,bank)ast(not G.bsw,"BSW")G.bsw=1
sync(mask,bank)if mask&1>0 then G.tbank=bank end
if mask&2>0 then G.sbank=bank end
if mask&4>0 then G.mbank=bank end
end
function F5()cls(0)if G.clk==1 then
b8(1|2|4|32,4)d4(1)return
end
local off=G.clk&16>0 and 60 or 0
map(off,0,30,17,0,0)_=G.clk>40 and map(30+off,0,30,min(17,(G.clk-40)//4),0,0)e3()if G.clk<140 and not btn(7)then return end
map(0,17,30,17,0,0,0)local new=pmem(0)<1
_=G.clk&32>0 and
a2(i0(new and 25154 or 25172),120,110,14)if F(4)then
if new then a9(9)else e4()o3()end
end
if btn(1)and btn(2)and btn(6)and btnp(7)then
a9(5)end
prn(i0(27285),5,128,7,true,1,true)_=G.pok and prn("Save OK",0,0,1,true,1,true)end
function F6()map(30,0,30,17,0,0)d1(c9(26935),5,max(136-G.clk//2,5))if G.clk>260 or btn(7)then
_=G.clk&32>0 and
a2(i0(25154),120,110,14)_=btnp(4)and a9(2)end
end
function F7()assert(G.mbank==4,"INSmb")_=G.clk==1 and e4()cls(1)map(30,17,30,17,0,0,0)if G.clk>100 and G.clk&32>0 then
a2(i0(25202),120,120,15)end
_=(G.clk>100 or btn(7))and F(4)and o3()e3()end
function F8()cls(1)d1(c9(25226),20,20)G.etcks=(G.etcks or 0)+b2(F(4))if G.etcks>15 then
G.etcks=0
a3(9)pmem(0,0)a9(1)end
if F(5)then a9(1)end
end
function F9()Q1()_=F(5)and a9(3)e3()end
function o3()b8(1|2|4|32,0)k0()if pmem(0)<1 then
local sl={DBG_GAME_START_LOC}o2(sl[1]or 1,sl[2]or 1)a9(3)else
O4()a9(3)end
end
function G0()o4()g4()_=G.clk>10 and not B and H8()if s0()then
e4()a9(4)end
if btnp(6)and btn(3)and btn(0)then E2()end
e3()end
function G1()o4()clip()n6(0+1,0+1,184-2,108-2,2)a2(i0(25289),0+184//2,0+108//2,15)if G.clk>200 or (G.clk>30 and F(4))then
k0()a9(1)end
end
function G2()local off=G.clk&16>0 and 30 or 0
if G.clk==1 then
b8(63,4)d4(1)end
map((G.endn==1 and 120 or 60)+off,G.endn==1 and 0 or 17,30,17)local x,y,a=20,max(136-G.clk//2,5),G.endn==1 and c9(27343)or c9(27704)d1(a,x+1,y+1,0)d1(a,x,y)e3()end
function G3()cls(0)if G.clk<2 then
b8(2|1|4,5)return
end
local n=G.csn-1
map((n%8)*30,17*(n//8))a2(c9(26726)[G.csn],120,max(110,136-G.clk),15)if G.clk>200 then
b8(2|1|4,0)a9(3)end
end
function a9(m)G.clk,G.m=0,m
clip()end
function g4()if A6()then return end
p9()J6()end
function o4()if G.clk&1>0 then
b8(2|1,B and 6 or L.lvl.texb)clip(0,0,0,0)elseif G.clk>2 then 
clip()cls(0)clip(0-1,0-1,184+1,108+2)if B then
B0()elseif G.tbank==L.lvl.texb then
M1(L.lvl.skyc)M0()end
clip()b8(2|1|4,0)c3(0,0,184,108)J8()H9(188,0,5,5)c3(188,0,40,40)prn(L.lvl.lvlt,188,45,7,true,1,true)if R.li==1 and not B then
a2(i0(25298),0+184//2,15,3)end
a1(7161,{b2(B)})_=#PA==2 and prn("Keys\nZ: action\nX: close/cancel",100,115,3,true,1,true)end
end
function e3()local s=G.clk/30
if s>=1 then return end
rect(0,0,240,68-s*68,0)rect(0,68+s*68,240,68,0)rect(0,0,120-s*120,136,0)rect(120+s*120,0,120,136,0)end
GMTIC={
[1]=F5,[2]=F7,[3]=G0,[4]=G1,[5]=F8,[6]=F9,[7]=G2,[8]=G3,[9]=F6
}local I=nil
function o5()k1=c9(25308)I=a4(k2)g5()J(G4,{})end
k2={
grid={},cr=1,cc=11,quitf=nil,}function G4(st,isFg)if not I then return 1 end
d0(8,8,224,120,0,i0(25336))if isFg and (F(5)or I.quitf)then
I=nil
return 1
end
H3(isFg)if not isFg then return end
if F(0)then g7(0,-1)end
if F(1)then g7(0,1)end
if F(2)then g7(-1,0)end
if F(3)then g7(1,0)end
if F(4)then
G5()return nil
end
return nil
end
function g5()I.grid={}for chi=1,#PA do
local col=1
local ch=PA[chi]for k,it in pairs(ch.eq)do
if it then
I.grid[col..","..chi]={chi=chi,it=it}col=col+1
end
end
end
local col,row=11,1
for i,it in ipairs(P.inv)do
I.grid[col..","..row]={idx=i,it=it}if col==20 then
col,row=11,row+1
else
col,row=col+1,row
end
end
end
function G5()local m={sel=1}m.acts=H5()if not m.acts then return end
m.names={}for _,ac in ipairs(m.acts)do
local n
if ac>=1 and ac<=4 then
n="Equip ("..PA[ac-1+1].name..")"
else
n=k1[ac]end
insert(m.names,n)end
J(G6,m,1)end
function G6(m,isFg)m.sel=i8("Item",m.names,120,40,15,4,m.sel)if not isFg then return nil end
if F(4)then
local cell=k3()local ac=m.acts[m.sel]local fn=o9[ac]ast(fn,"No ac hnd " .. m.sel)local itd=V(cell.it.itid)return fn(ac,cell)end
if F(5)then
return 1
end
return nil
end
function k3()return I.grid[I.cc..","..I.cr]end
function g6(ac,cell)local chi=ac-1+1
local ch=PA[chi]local itd=V(cell.it.itid)if (1<<ch.class)&itd.ac<1 then
U(ch.name..i0(25345),nil,nil,2)return nil
end
if ch.eq[itd.k]then
U({ch.name..i0(25361),"current "..k4[itd.k].."."},nil,nil,2)return nil
end
if (ch.eq[5]and itd.f&2>0)or
(itd.k==5 and G7(ch))then
U(c9(25379),nil,nil,2)return nil
end
ch.eq[itd.k]=cell.it
ast(cell.idx)remove(P.inv,cell.idx)g5()o6(cell.it)a3(4)return 1
end
function G7(ch)local w=ch.eq[3]return w and (V(w.itid).f&2>0)end
function o6(it)for r=1,8 do
for c=1,20 do
local cell=I.grid[c..","..r]if cell and cell.it==it then
I.cc,I.cr=c,r
return
end
end
end
end
function G8(ac,cell)if #P.inv>=80 then
U(i0(25427),nil,nil,2)return nil
end
local itd=V(cell.it.itid)if k5(cell.it)then
o7()return nil
end
PA[I.cr].eq[itd.k]=nil
insert(P.inv,cell.it)g5()o6(cell.it)a3(4)return 1
end
function o7()U(i0(25456),nil,nil,2)end
function G9(ac,cell)J(function()p2(cell.it)return 1 end)I.quitf=1
return 1
end
function H0(ac,cell)U(p6(cell.it))return 1
end
function H1(ac,cell)local itd=V(cell.it.itid)if not itd then return 1 end
if cell.chi and k5(cell.it)then
o7()return nil
end
if itd.k==15 or (itd.v or 0)<1 then
U(i0(25485),nil,nil,2)return 1
end
b6(i0(25524).." "..itd.n.."?",c9(25538),H2)return 1
end
function H2(ans)if ans~=2 then return end
local cell=k3()if not cell then return end
local itd=V(cell.it.itid)local chi,idx=cell.chi,cell.idx
ast(chi or idx)if chi then
PA[chi].eq[itd.k]=nil
else
e6(cell.it)end
g5()a3(4)end
function g7(dc,dr)I.cc=a8(I.cc+dc,1,20)I.cr=a8(I.cr+dr,1,8)if I.grid[I.cc..","..I.cr]or (I.cc>=11 and
I.cc<=20)then
return
end
if dc>0 then
I.cc=11
elseif dc<0 and I.cr<=#PA then
o8(-1,0)elseif dc>0 and I.cr>#PA then
I.cc=11
elseif dr~=0 and I.cr<=#PA then
o8(-1,0)else
I.cc,I.cr=I.cc-dc,I.cr-dr
end
end
function o8(dc,dr)while not I.grid[I.cc..","..I.cr]do
local nc=a8(I.cc+dc,1,20)local nr=a8(I.cr+dr,1,8)if nc==I.cc and nr==I.cr then break end
I.cc,I.cr=nc,nr
end
end
function H3(isFg)for r=1,8 do
for c=1,20 do
local cell=I.grid[c..","..r]H4(cell,24+10*(c-1),26+10*(r-1),I.cc==c and I.cr==r,isFg)end
end
local icx=24-12
local icy=26-1
for i=1,#PA do
spr(PA[i].face,icx,icy+(i-1)*10)end
prn("Equipped",icx,icy-10,3)prn("Inventory",24+10*(11-1),icy-10,3)prn("Gold",icx,26+50,3)prn(P.gold .. " gp",icx,26+60,15)end
function H4(cell,x,y,sel,isFg)local ic,n
if cell then
ic,n=d3(cell.it)spr(ic,x,y)end
if sel and (not isFg or G.clk&16>0)then
rectb(x-2,y-2,11,11,14)end
_=n and sel and a2(n,8+224//2,120,14)end
function H5()local ac={}local cell=k3()if not cell then return nil end
local itd=V(cell.it.itid)if cell.chi then
insert(ac,5)else
if itd.k<=9 then
for i=1,#PA do
insert(ac,1+i-1)end
else
insert(ac,6)end
end
insert(ac,7)insert(ac,8)return ac
end
o9={
[1]=g6,[2]=g6,[3]=g6,[4]=g6,[5]=G8,[6]=G9,[7]=H0,[8]=H1,}p0={1,2,3,4,5,6}p1={
[97]=6
}ITDB={}function H6()k4=c9(25563)b4(1983)while 1 do
local h=C()if h==0 then break end
ast(h==123,"ITDB err "..h)local itid=C()ast(not ITDB[itid],"Dup ITID "..itid)local r,aod={}r.n=c8()r.sp=itid+256
r.k=C()r.f=C()r.v=c2(C()*(r.f&8>0 and 100 or 1))r.ac=C()r.def=r.att
if r.k==3 or r.k==4 then
r.att,r.def=C(),0
else
r.att,r.def=0,C()end
r.desc=Q4()ITDB[itid]=r
end
end
function V(itid)ast(itid,"null ITID")local itdef=ITDB[itid]ast(itdef,"bad ITID "..itid)return itdef
end
function p2(it,chi,cb)local idx=b1(P.inv,it)ast(idx,"ITnf")a1(7074,{it.itid,idx,chi},function(r)_=cb and cb(r)end)end
function p3(it)if it then
a0({it.itid,it.st})else
a0({0,0})end
end
function p4(f)f=f or b0
local it={}it.itid=f()it.st=f()return it.itid>0 and it or nil
end
function k5(it)ast(it.st,"IT_IC/st")return it.st&2>0
end
function k6(it)ast(it.st,"IT_GE/st")return (k5(it)and -1 or 1)*(
(it.st&28)>>2)end
function p5(itid)return b1(p0,V(itid).k)end
function d3(it)local itd,ic,s,en,br=V(it.itid)ic,s=itd.sp,itd.n
br=" [?]"
if it.st&1>0 then
if k7[itd.k]then
ic=k7[itd.k]s=c9(25563)[itd.k]..br
s=supper(ssub(s,1,1))..ssub(s,2)else
s=s..br
end
else
en=itd.k~=10 and k6(it)or 0
s=s..(en>0 and " +"..en or en<0 and " "..en or "")s=s..(it.st&2>0 and " CURSED" or "")end
return ic,s
end
function g8(itid,st)st=st or 0
local itd=V(itid)if itd.f&4>0 then st=st|2 end
return {itid=itid,st=st}end
function p6(it)ast(it and it.itid)local itd,_,n,d=V(it.itid),d3(it)d=itd.desc
if not d or #d<1 then d=c9(26917)end
if it.st&1>0 then return c9(26634)end
return n3({n,""},d)end
k7={
[12]=491,[11]=492,[8]=493,[10]=494,[9]=495,}L=nil
L_INIT={
lvlN=nil,lvl=nil,lvlt=nil,tiles={},rtiles={},}local LVLS=nil
TD=nil
OTD=nil
function H7()b4(8231)LVLS={}while 1 do
local sig=C()local l={}if sig==0 then break end
ast(sig==250,"!LVLs"..#LVLS)ast(C()==1+#LVLS,"!LVLn"..#LVLS)l.lvlt=c8()l.mc0=C()l.mr0=C()l.mcols=C()l.mrows=C()l.flags=C()l.skyc=l.flags&(1|16)>0 and 0 or 8
l.mus=C()l.texb=l.flags&8>0 and 2 or 1
l.kfL=C()l.bsn=C()l.iproc=a6()l.uproc=a6()l.wproc=a6()l.bproc=a6()l.epts={}local entptc=C()for i=1,entptc do
local ept={}local rx=C()local rz=C()ept.x,ept.z=I5(l,rx,rz)ept.dir=C()insert(l.epts,ept)end
l.tsub={}local subc=C()for i=1,subc do
local f=C()l.tsub[f]=C()end
insert(LVLS,l)end
trace("LVL init "..#LVLS)b4(38220)TD,OTD={},{}local tc,ss=0,0
while 1 do
local sig=C()local d={}if sig==255 then break end
ast(sig==249 or 248,"!Tsig"..sig..'@'..tc)local id=C()d.flags=a6()d.ftid=c2(C())d.ctid=c2(C())d.wtid=c2(C())d.stid=c2(C())d.kstid=c2(C())ss=C()d.ssize=ss>0 and ss*.01 or 1
d.wons=d.flags&2048>0 and .5 or 0
d.woew=d.flags&4096>0 and .5 or 0
ast(not d.stid or d.ssize>0,"!ZS"..id)ast(not TD[id]and not OTD[id],"!DupTI"..id)if sig==249 then
TD[id]=d
else
OTD[id]=d
end
tc=tc+1
end
trace("TILE init "..tc)end
function p7(lvlN,epnum)if L then I4()end
epnum=epnum or 1
local lvl=LVLS[lvlN]ast(lvl)L=a4(L_INIT)L.lvlN=lvlN
L.lvl=lvl
d4(lvl.mus)local nextKfi=0
for lr=0,lvl.mrows-1 do
for lc=0,lvl.mcols-1 do
local ti=q6(lc,lr)if ti.td and ti.td.flags&32>0 then
ast((nextKfi//8)<lvl.kfL,"KF over cap")ti.kfi=nextKfi
nextKfi=nextKfi+1
end
end
end
if epnum>=0 then
local ep=lvl.epts[epnum]ast(ep,"No lvl entry "..epnum.." @L"..lvlN)J7(ep.x,ep.z,ep.dir)end
p9()a1(7147)t9(lvl.flags&1>0 and 1 or 3)end
function H8()_=I9()or d4(L.lvl.mus,1)end
function b3(lc,lr)return L.tiles[lr*1000+lc]end
function g9(mc,mr)return mc-L.lvl.mc0,L.lvl.mr0-mr+L.lvl.mrows-1
end
function p8(lc,lr,lvl)lvl=lvl or L.lvl
return lc+lvl.mc0,lvl.mr0+lvl.mrows-1-lr
end
function H9(x0,y0,cols,rows)if G.tbank>0 then return end
y0=y0+(rows-1)*8
local c0,r0=P.x-cols//2,P.z-rows//2
for c=c0,c0+cols-1 do
for r=r0,r0+rows-1 do
local t,x,y=b3(c,r),x0+(c-c0)*8,y0-(r-r0)*8
spr(t and t.msp or 0,x,y)spr(t and t.mspo or 0,x,y,0)if c==P.x and r==P.z then spr(247,x,y,0,1,0,P.dir)end
end
end
end
function p9()I3()end
function q0(tc,tr)local ti=b3(tc,tr)if not ti then return end
local kf=ti.kfi and h2(L.lvlN,ti.kfi)kf=b2(kf)a1(6980,{ti.mc+256*ti.mr,tc+tr*256,ti.sid,kf})end
function q1(c,r)local ti=b3(c,r)local f=ti and ti.td.flags or 16
local k=ti.kfi and h2(L.lvlN,ti.kfi)if not k and f&64>0 then f=f|16 end
return f&16>0
end
function I0(c,r)local ti=b3(c,r)ast(ti.kfi,"Can't kill "..c..","..r)J2(L.lvlN,ti.kfi)q5(ti)end
function q2(c,r,sid)ast(TD[sid]or OTD[sid],"!CSID.."..sid)q5(q6(c,r,sid))end
function I1(c,r)local ti=b3(c,r)if not ti or not ti.kfi then return nil end
return h2(L.lvlN,ti.kfi)end
function I2(lc,lr,tile)L.tiles[lr*1000+lc]=tile
end
function q3(ti)if ti.rends or not q4(ti.x,ti.z)then return end
insert(L.rtiles,ti)local x,z,td,ons,oew=ti.x,ti.z,ti.td
local ons,oew=td.wons,td.woew
ti.rends={}if td then
_=td.ftid and insert(ti.rends,M2(x,z,h0(td.ftid)))_=td.ctid and insert(ti.rends,M3(x,z,h0(td.ctid)))if td.wtid then
local wtid=h0(td.wtid)local wf=td.flags&512>0 and 2 or 0
_=td.flags&1>0 and
insert(ti.rends,h7(x,z+1-ons,1,wtid,wf))_=td.flags&2>0 and
insert(ti.rends,h7(x+1-oew,z+1,2,wtid,wf))_=td.flags&4>0 and
insert(ti.rends,h7(x+1,z+ons,3,wtid,wf))_=td.flags&8>0 and
insert(ti.rends,h7(x+oew,z,0,wtid,wf))end
local stid=td.stid
if ti.kfi and h2(L.lvlN,ti.kfi)then
stid=td.kstid or stid
end
if stid then
stid=h0(stid)local sz,r=td.ssize,b2(td.flags&128>0)insert(ti.rends,M4(
x+0.5+r*random(-9,9)*.01,sz/2,z+0.5+r*random(-9,9)*.01,sz,stid))end
end
end
function k8(ti)if not ti.rends then return end
for i=1,#ti.rends do M5(ti.rends[i])end
ti.rends=nil
end
function I3()for i=#L.rtiles,1,-1 do
local ti=L.rtiles[i]if not q4(ti.x,ti.z)then
k8(ti)z6(L.rtiles,i)end
end
for x=P.x-5,P.x+5 do
for z=P.z-5,P.z+5 do
local ti=b3(x,z)_=ti and q3(ti)end
end
end
function q4(x,z)return max(abs(x-P.x),abs(z-P.z))<=5
end
function I4()for _,ti in ipairs(L.rtiles)do
k8(ti)end
L.rtiles={}end
function I5(l,mc,mr)return mc-l.mc0,l.mr0+l.mrows-1-mr
end
function h0(tid)return L.lvl.tsub[tid]or tid end
function q5(ti)k8(ti)q3(ti)end
function q6(lc,lr,nsid)local lvl=L.lvl
local mc,mr=p8(lc,lr,lvl)local ti=b3(lc,lr)or {}ti.x,ti.z,ti.mc,ti.mr,ti.sid=lc,lr,mc,mr,nsid or mget(mc,mr)local otd=OTD[ti.sid]if otd then
local bsid=mget(mc+1,mr)if not TD[bsid]or not TD[bsid].ftid then bsid=mget(mc-1,mr)end
if not TD[bsid]or not TD[bsid].ftid then bsid=mget(mc,mr-1)end
if not TD[bsid]or not TD[bsid].ftid then bsid=mget(mc,mr+1)end
local btd=TD[bsid]ast(btd)ti.td=i4(btd,otd)ti.msp,ti.mspo=bsid,otd.flags&1024>0 and 0 or ti.sid
else
ti.td=TD[ti.sid]ti.msp=ti.sid
end
ast(ti and ti.td,"!TD"..ti.sid)I2(lc,lr,ti)return ti
end
h1={50,100,200,300,400}k9={}function I6()for i=1,#h1 do
local tv,ci=h1[i],{}for itid,itd in pairs(ITDB)do
if itd.v and itd.v>0 and itd.v<=tv then insert(ci,itid)end
end
ast(#ci>0,"LOi"..i)insert(k9,ci)end
end
function I7(lol)local tv,can,ai,av,f,sw=h1[lol],k9[lol],{},0,0,nil
for i=1,100 do
if av>=tv or #ai>=2 then break end
i=i+1
local itid,v=can[random(1,#can)]v=V(itid).v
if av+v<=tv then
insert(ai,I8(itid))av=av+v
else
f=f+1
end
end
_=#ai>0 and h3(ai,tv>av and tv-av or nil)end
function I8(itid)local itd,f=V(itid)f=1
r=random(0,0xffff)>>8
if p5(itid)then
f=f|(r>254 and 28 or
r>252 and 24 or
r>248 and 20 or
r>240 and 16 or
r>224 and 12 or
r>192 and 8 or
r>128 and 4 or 0)elseif itd.k==10 then
f=f|(r>224 and 20 or
r>192 and 16 or
r>128 and 12 or 8)end
f=f|(random(0,3)<1 and 2 or 0)return g8(itid,f)end
MU={
M={
[1]={0},[2]={7,1,6},[3]={2,5},[4]={3},[5]={4}},lm={},cm=0
}function d4(m,k)local mt,lm=MU.M[m],MU.lm
assert(mt and #mt>0,"MU"..m)lm[m]=k and (lm[m]or 0)or c4(lm[m]or 0,#mt)_=(H(171)&8>0)or music(mt[lm[m]])MU.cm=m
end
function I9()return MU.cm>0 end
function e4()music(-1)MU.cm=0
end
PS={
gps=nil,kf=nil,}function q7()PS.gps=n5(32)PS.kf={}for i,lvl in ipairs(LVLS)do
ast(lvl.kfL)insert(PS.kf,n5(lvl.kfL))end
end
function J0(idx)local a=PS.gps
ast(a and idx>=1 and idx<=#a)return a[idx]end
function J1(idx,val)local a=PS.gps
ast(a and a[idx])ast(val and val>=0 and val<256,"GPSv")a[idx]=val
end
function h2(lvlNo,kfi)local bidx,mask=q8(kfi)return (PS.kf[lvlNo][bidx]&mask)>0
end
function J2(lvlNo,kfi)local bidx,mask=q8(kfi)local t=PS.kf[lvlNo]t[bidx]=t[bidx]|mask
end
function J3()a0(42)a0(PS.gps)for i,lvl in ipairs(LVLS)do
a0(43)a0(PS.kf[i])end
end
function J4()q7()ast(b0()==42,"Bad PS sig.")PS.gps=t4(32)for i,lvl in ipairs(LVLS)do
ast(b0()==43,"Bad PS/L sig.")PS.kf[i]=t4(lvl.kfL)end
end
function q8(kfi)return 1+kfi//8,1<<(kfi%8)end
q9={5,5,5,1}r1={2,2,1,1}r2={15,14,12,8}r3={4,5,6,3}r4={0,5,0,8}P=nil
PA=nil   
P_INIT={
x=0,z=0,dir=0,pclk=0,party=nil,inv={},gold=0,xp=0,level=1,mcd=0,}function r5()J5=c9(25646)P=a4(P_INIT)s1(nil)PA=P.party
end
function J6()if L2()then return end
if F(4)then
J(L5)end
d6()end
function J7(x,z,dir)P.x,P.z,P.dir=x or P.x,z or P.z,dir or P.dir
d6()end
function J8()for i=1,#PA do
local x,y=s5(i)L4(i,PA[i],x,y)end
local eli=l6()spr(eli and 236 or 237,232,118)f8(P.xp,226,120,eli and 15 or 5)spr(238,232,126)f8(P.gold,226,128,14)end
function l0(ch)local a,d,cu,itd,en=ch.att,ch.def
for k,it in pairs(ch.eq)do
if it then
itd,cu=V(it.itid),it.st&2>0
en=(cu and not p5(it.itid))and -1 or 1
d=d+(itd.def>0 and en*itd.def+k6(it)or 0)a=a+(itd.att>0 and en*itd.att+k6(it)or 0)end
end
return max(1,a),max(1,d)end
function r6(ch)local _,d=l0(ch)return d end
function l3(ch)local s,r=ch.speed,ch.eq[9]if r and r.itid==35 then
s=s+(r.st&2>0 and -100 or 100)end
return max(1,s)end
function r7(ch,ak)local w,bad,n,att
w=ch.eq[ak==1 and 3 or 4]if not w then return nil end
w=w and V(w.itid)att,_=l0(ch)bad={  
ak=ak,att=att,narr=ch.name..(ak==1 and " attacks" or " fires"),psp=227,fl=0} 
if ch.class~=3 and ak==2 or
ch.class==3 and ak==1 then
bad.att=max(1,bad.att//2)end
return bad
end
function r8(itid,itk)local r,it=0
for _,it in ipairs(P.inv)do
r=r+(itk and b2(V(it.itid).k==itk)or
b2(it.itid==itid))end
return r
end
function h3(its,gp)while #P.inv+#its>80 do L7()end
for i=1,#its do
ast(its[i].itid)insert(P.inv,its[i])end
J(J9,{its=its,gp=gp})end
function J9(st)local w,h=160,30+12*#st.its+(st.gp and 12 or 0)local x,y,iy=92-w//2,55-h//2
d0(x,y,w,h,0,"Received")prn(i0(26398),x+4,y+8,7)iy=y+22
for i,it in ipairs(st.its)do
local d,ic,n=V(it.itid),d3(it)spr(ic,x+4,iy)prn(n,x+14,iy+2)iy=iy+12
end
if st.gp then
spr(238,x+4,iy)prn(st.gp.." gp",x+14,iy+2,14)end
st.sfxd=st.sfxd or a3(3)or 1
if F(4)then
l9(st.gp or 0)return 1
end
end
function h4(gold,s)l9(gold)_=gold>0 and not s and
e5(nil,14,"+"..gold.." gp",12)end
function r9(zid)ast(ZD[zid],"!Z "..zid)local cls=O6(zid)and 4 or 2
local n
for i,c in ipairs(PA)do
if c.class==cls and not b1(c.zs,zid)then
n=c.name
insert(c.zs,zid)end
end
if n then
U({n..i0(26068),ZD[zid].n},14,1,3)else
U({i0(26089),ZD[zid].n},10,3)end
end
function K0(itid,idx)if idx and P.inv[idx].itid==itid then
e6(P.inv[idx])return 1
end
for i=1,#P.inv do
if P.inv[i].itid==itid then
e6(P.inv[i])return 1
end
end
return nil
end
function d5(chi)return PA[chi].hp>0 and not d2(chi,6)end
function s0()for i=1,#PA do
if d5(i)then return nil end
end
return 1
end
function K1(title,msg,cb,udata,fl,wfl)local c,en={},g1(1,#PA)wfl=wfl or 0
for i=1,#PA do
insert(c,PA[i].name)en[i]=d5(i)or (PA[i].hp>0 and wfl&1>0)end
b6(msg,c,cb,nil,nil,udata,fl,en)end
function K2()local idxs,names={},{}for i=1,#PA do
if #PA[i].zs>0 then
insert(idxs,i)insert(names,PA[i].name)end
end
return idxs,names
end
function K3(chi)local r={}for _,zid in pairs(PA[chi].zs)do
local zd=ZD[zid]ast(zd)insert(r,zd.n .. " (" .. zd.sp .. " SP)")end
return r
end
function e5(chi,clr,msg,sfx)J(K4,{chi=chi,clr=clr,msg=msg,sfx=sfx},1)end
function K4(st,isf)if not isf then return end
local chis=st.chi and {st.chi}or A2(1,#PA)for _,chi in ipairs(chis)do
local x,y=s5(chi)if st.clk&8>0 then
rectb(x,y,43,25,st.clr)end
if st.chi and st.msg then
local oy=min(5,st.clk)c3(x,y-15-oy,43,20,st.clr,15)a2(st.msg,x+43//2,y-5-oy,0)end
if st.sfx then
a3(st.sfx)st.sfx=nil
end
end
if not st.chi then
local oy=min(5,st.clk)c3(0,93-oy,184,20,st.clr,15)a2(st.msg,0+184//2,93-oy+10,0)end
return st.clk>70
end
function K5(chi,hp,sp)hp,sp=hp or 0,sp or 0
local p,c,msg=hp>0 or sp>0
for i=1,#PA do
if not chi or i==chi then
c=PA[i]ast(c,"HC")c.hp=a8(c.hp+hp,0,max(c.hp,c.maxHp))c.sp=a8(c.sp+sp,0,c.maxSp)end
end
msg=(p and "+" or "")..(hp~=0 and hp or sp)..(hp~=0 and "hp" or "sp")if hp>200 then msg="Heal" end
e5(chi,
p and 13 or 6,msg,p and 12 or 9)end
function l4(xp,shh)P.xp=min(P.xp+xp,9999999)_=shh or e5(nil,11,"+"..(xp>9999 and ((xp//1000).."K")or xp).." xp",12)end
function e6(it)local itd=V(it.itid)e0(P.inv,it)end
function l5(title,ks,rfl,nmsg,sv,cb)local its={}for _,it in ipairs(P.inv)do
local itd=V(it.itid)if (not ks or b1(ks,itd.k))and itd.f&rfl==rfl and
(itd.v or not sv)then
insert(its,it)end
end
if #its==0 then
U(nmsg,15,2,2)cb(nil,1)return
end
J(K6,{its=its,sv=sv,cb=cb,title=title},1)end
function K6(s)local x0,y0,w,h=48,10,114,105
local gx0,gy0,ic,dn=x0+6,y0+6
d0(x0,y0,w,h,0,s.title)for i=1,#s.its do
ic,dn=d3(s.its[i])local itid=s.its[i].itid
local itd=V(itid)local c,r=(i-1)%10,(i-1)//10
spr(ic,gx0+c*10,gy0+r*10)end
s.sel=s.sel or 1
local sc,sr=(s.sel-1)%10,(s.sel-1)//10
_=G.clk&16>0 and rectb(gx0-1+sc*10,gy0-1+sr*10,10,10,14)local it=s.its[s.sel]if it then
local itd=V(it.itid)ic,dn=d3(it)a2(dn,x0+w//2,y0+90,14,1,1)_=s.sv and a2(itd.v.." gp",x0+w//2,y0+98,4,1,1)end
if it and F(4)then
s.cb(it,0)return 1
end
if F(5)then
s.cb(nil,2)return 1
end
local dx,dy=A1()sc,sr=a8(sc+dx,0,9),a8(sr+dy,0,7)s.sel=1+sc+sr*10
end
function K7()a0(187)a0({P.x,P.z,P.dir,#PA})e9(P.pclk)for _,c in ipairs(PA)do
a0(186)t7(c.name)a0({c.class,c.face,c.att,c.def,c.speed})e8(c.hp)e8(c.maxHp)e8(c.sp)e8(c.maxSp)for ek=1,9 do p3(c.eq[ek])end
a0(#c.zs)for i=1,#c.zs do a0(c.zs[i])end
end
a0(#P.inv)for _,it in ipairs(P.inv)do
p3(it)end
e9(P.gold)e9(P.xp)a0(P.level)end
function s1(pm)_=pm and r5()local fB,fW,fDW,fS,dbgl=
pm and b0 or C,pm and t6 or a6,pm and m0 or w5,pm and t8 or c8
_=pm or b4(DBG_INIT_PARTY or 13086)ast(fB()==187,"Bad PMEM plr.")P.x=fB()P.z=fB()P.dir=fB()local pc=fB()P.pclk=fDW()P.party={}PA=P.party
for i=1,pc do insert(PA,s8(fB,fW,fDW,fS))end
local ic=fB()P.inv={}for i=1,ic do insert(P.inv,p4(fB))end
P.gold=fDW()P.xp=fDW()P.level=fB()while not pm and l6()do s2(1)end
end
function K8()O3()J(K9)
end
function K9(st)cls(0)if st.clk<150 then
_=st.clk&16<1 and a2(i0(25681),120,68,15)a2(i0(25690),120,126,3)elseif st.clk<230 then
_=st.clk==150 and a3(12)a2(i0(25727),120,68,11)else return 1 end
end
function l6()return P.level<30 and P.xp>=s3(P.level+1)end
function s2(q)if P.level>=30 then return end
P.level=P.level+1
for i,c in ipairs(PA)do s9(c)end
_=q or e5(nil,11,"Level Up!",12)end
function L0(ptr)local old,c
old=b4(ptr)c=s8(C,a6,w5,c8)b4(old)for i=2,P.level do s9(c)end
insert(PA,c)end
function s3(l)return l>30 and 9999999 or
1000*f3(21720+2*a8(l,1,30))end
function L1()local r,itd=P.gold
for _,it in ipairs(P.inv)do r=r+(V(it.itid).v or 0)end
for _,ch in ipairs(PA)do
for _,it in pairs(ch.eq)do
if it then
r=r+(V(it.itid).v or 0)end
end
end
return r
end
function s4(chi,cm)local r=PA[chi].eq[9]r=r and r.itid or 0
return cm==4 and r==38 or
cm==2 and
(d2(chi,32)or r==40)or
cm==1 and r==39
end
function l7(chi,cm)if chi<1 then
for i=1,#PA do l7(i,cm)end
elseif not s4(chi,cm)then
D9(chi,cm)end
end
function s5(chi)return (chi-1)*47,111
end
function L2()P.mcd=max(0,P.mcd-1)if btn(0)then
s7(1)elseif btn(1)then
s7(-1)elseif F(3)then
P.dir=(P.dir+1)%4
d6()
elseif F(2)then
P.dir=P.dir>0 and P.dir-1 or 3
d6()
else return nil end
return 1
end
function s6(c,r)if ((H(171)&2>0)and btn(7))then return 1 end
if q1(c,r)then return nil end
return 1
end
function s7(di)if P.mcd>0 then return end
local wdir=di>0 and P.dir or y9(P.dir)local tc,tr=f6(wdir,P.x,P.z)if not s6(tc,tr)then
_=di>0 and q0(tc,tr)return
end
local hx,hz=(P.x+tc+1)*.5,(P.z+tr+1)*.5
P.x,P.z=tc,tr
P.pclk=P.pclk+1
d6()local ti=b3(P.x,P.z)_=ti and J(function()a1(7024,{ti.mc+256*ti.mr,wdir})return 1 end)a3(1)L3()P.mcd=((H(171)&2>0)and btn(7))and 3 or 15
end
function L3()for i=1,#PA do
l8(i,1)l8(i,2)l8(i,4)end
end
function l8(chi,cm)_=s4(chi,cm)and E0(chi,cm)end
function d6()local x,z,yaw=P.x,P.z,P.dir*PI/2
M6(x+0.5,0.5,z+0.5)m3(yaw)end
function L4(chi,c,x0,y0)local active=d5(chi)rect(x0,y0,43,25,B1(chi)and 2 or 0)spr(c.face,x0+3,y0+1,0)prn(c.name,x0+12,y0+3,active and 15 or 3,true)spr(244,x0+4,y0+9,0)local f=c.hp/c.maxHp
local fg,bg=G.clk&16>0 and 6 or 0,1
if c.hp<=0 then
fg,bg=7,3
elseif c.hp>c.maxHp then
fg,bg=8,8
elseif c.hp==c.maxHp then
fg,bg=11,5
elseif f>0.5 then
fg,bg=14,4
elseif c.hp>10 and f>0.1 then
fg,bg=9,4
end
f8(c.hp,x0+20,y0+11,fg)i5(x0+3,y0+18,37,4,f,fg,bg)
if not active then
n6(x0+1,y0+1,43-2,25-2,2)end
c3(x0,y0,43,25)end
function L5(st)st.sel=st.sel or 1
st.sel=i8("MENU",c9(25738),200,70,15,5,st.sel)if F(5)then return 1 end
if F(4)then
if st.sel==1 then
local tc,tr=f6(P.dir,P.x,P.z)if s6(tc,tr)then
U(c9(27255))else
q0(tc,tr)end
return 1
elseif st.sel==2 then
if L.lvl.flags&2>0 then
U(c9(26468))return 1
else
o5()return 1
end
elseif st.sel==3 then
m9()return 1
elseif st.sel==4 then
J(L6,{i=1})return 1
end
end
return nil
end
function L6(st)st.i=F(3)and c4(st.i,#PA)or st.i
st.i=F(2)and g0(st.i,#PA)or st.i
a1(19556,{st.i})return F(4)or F(5)end
function L7()local wi,lv=nil,nil
for i=1,#P.inv do
local v=V(P.inv[i].itid).v
if v and (not wv or v<wv)then wi,wv=i,v end
end
ast(wi,"Inv add err")e6(P.inv[wi])end
function s8(fB,fW,fDW,fS)local c,sig={},fB()ast(sig==186,"!P_L"..sig)c.name=fS()c.class=fB()c.face=fB()c.att=fB()c.def=fB()c.speed=fB()c.hp=fW()c.maxHp=fW()c.sp=fW()c.maxSp=fW()c.eq=g1(nil,9)for ek=1,9 do c.eq[ek]=p4(fB)end
local zc=fB()c.zs={}for j=1,zc do insert(c.zs,fB())end
return c
end
function s9(c,q)c.att,c.def,c.maxHp,c.maxSp,c.speed=
min(255,c.att+q9[c.class]),min(255,c.def+r1[c.class]),min(255,c.maxHp+r2[c.class]+random(0,2)),min(255,c.maxSp+r4[c.class]),min(255,c.speed+r3[c.class]+random(0,1))c.hp,c.sp=c.maxHp,c.maxSp
end
function l9(d)P.gold=a8(P.gold+d,0,999999999)end
function t0()ast(PM.m==0,"PMor "..PM.m)PM.m,PM.o=2,0
end
function t3()ast(PM.m==0,"PMow "..PM.m)PM.m,PM.o=1,0
end
function e7()ast(PM.m~=0,"PMc")trace("PMc "..PM.o)PM.m,PM.o=0,0
end
function a0(b)ast(PM.m==2)if type(b)=="table" then
for i=1,#b do a0(b[i])end
return
end
ast(b>=0 and b<=255)local i,s=PM.o//4,(PM.o%4)*8
ast(i<=255,"PMEM out")pmem(i,(pmem(i)&~(255<<s))|(b<<s))PM.o=PM.o+1
end
function h5(n,dw)for i=1,n do
a0(dw&255)dw=dw>>8
end
end
function e8(w)h5(2,w)end
function e9(d)h5(4,d)end
function b0()ast(PM.m==1)local i,s=PM.o//4,(PM.o%4)*8
ast(i<=255,"EOPM")PM.o=PM.o+1
return (pmem(i)&(255<<s))>>s
end
function t4(n)local r={}for i=1,n do insert(r,b0())end
return r
end
function t5(n)local r=0
for i=0,n-1 do r=r|(b0()<<(i*8))end
return r
end
function t6()return t5(2)end
function m0()return t5(4)end
function t7(s)ast(#s<=255)a0(#s)for i=1,#s do a0(string.byte(s,i))end
end
function t8()local l,s=b0(),""
for i=1,l do s=s..schr(b0())end
return s
end
PM={
m=0,o=0,}R=nil
R_INIT={
ready=1,cam={x=0,y=0.6,z=0,yaw=0,fwx=0,fwz=1},flats={},mids={},rendById={},skyc=0,nextId=100,li=3,}RTT={{x=0,y=0,z=0,u=0,v=0},{x=0,y=0,z=0,u=0,v=0},{x=0,y=0,z=0,u=0,v=0}}f0=a4(RTT)d7={a4(RTT),a4(RTT)}c6={x=0,y=0,z=0,u=0,v=0}h6=a4(c6)m1=a4(c6)RVerSprite=a4(c6)function L8()local tid,t,num,hdr
m2={}b4(45102)k=0
while 1 do
ast(C()==92,"!TLUTf "..k)tid=C()if tid==0 then break end
t={int=250,fl=C()}t.nfr=t.fl&2>0 and 2 or 1
t.tids={}for i=1,2 do insert(t.tids,a6())end
m2[tid]=t
k=k+1
end
trace("TLUT "..k)end
function L9()R=a4(R_INIT)end
function M0()local sea=L.lvl.flags&4>0
clip(0,0,184,108)cls(R.li==3 and (sea and 2 or C_DGRAY)or 0)_=sea and rect(0,108//2+15-(G.clk//20%5),184,1,8)_=sea and rect(0,108//2+15-(G.clk//32%5),184,1,8)clip(0,0,184,108//2+10)cls(R.li~=3 and 0 or R.skyc)clip(0,0,184,108)local cm,nm=0,nil
if not R.ready then M7()end
for _,f in pairs(R.flats)do
if f.depth<3 or f.dcf>0.5 then
nm=u7(f.depth)
_=nm~=cm and u8(nm)cm=nm
M8(f)end
end
for _,m in ipairs(R.mids)do
if m.depth<3 or m.dcf>0.5 then
nm=u7(m.depth)
_=nm~=cm and u8(nm)cm=nm
_=m.kind==6 and N0(m)or M9(m)end
end
g2()clip()end
function M1(skyc)R.skyc=skyc
end
function t9(li)R.li=li end
function M2(x0,z0,tid,f)return h8({x=x0,z=z0,tid=tid,kind=4,f=f or 0})end
function M3(x0,z0,tid,f)return h8({x=x0,z=z0,tid=tid,kind=5,f=f or 0})end
function h7(x0,z0,dir,tid,f)ast(dir>=0 and dir<=3) 
return h8({x=x0,z=z0,tid=tid,kind=dir,f=f or 0})end
function M4(x,y,z,size,tid,f)return h8(
{x=x,y=y,z=z,size=size,tid=tid,kind=6,f=f or 0})end
function M5(hr)if not hr then return end
local r=R.rendById[hr]if r then
e0(R.mids,r)e0(R.flats,r)end
end
function u5(x,z)return d9(x,z,R.cam.x,R.cam.z)end
function M6(x,y,z)R.cam.x,R.cam.y,R.cam.z=x,y,z
R.ready=nil
end
function m3(yaw)R.cam.yaw=yaw
R.cam.fwx,R.cam.fwz=sin(yaw),cos(yaw)R.ready=nil
end
function M7()for _,r in pairs(R.flats)do u6(r)end
for _,r in pairs(R.mids)do u6(r)end
O0()R.ready=1
end
function u6(r)r.cx,r.cz=N8(r)local vx,vz=z5(r.cx-R.cam.x,r.cz-R.cam.z)r.dcf=A3(R.cam.fwx,R.cam.fwz,vx,vz)r.depth=N9(r.cx,r.cz)end
function u7(d)return R.li==3 and 0 or
R.li==1 and 2 or
(d>4 and 2 or d>3 and 1 or 0)end
function u8(mapn)m4=m4 or {f2(26358,15),f2(26373,15)}g2(mapn>0 and m4[mapn]or nil)end
function M8(flr)local x0,z0,tid=flr.x,flr.z,m8(flr)local u0,v0,u1,v1=m7(tid)local y=flr.kind==5 and 1 or 0
local distSq=u5(x0+0.5,z0+0.5)local pcount=distSq>4 and 1 or 2
local psize=1.0/pcount
local ud,vd=u1-u0,v1-v0
for r=0,pcount-1 do
for c=0,pcount-1 do
local xi,zi=x0+c*psize,z0+r*psize
local xf,zf=xi+psize,zi+psize
local ui,vi=u0+ud*c/pcount,v0+vd*r/pcount
local uf,vf=u0+ud*(c+1)/pcount,v0+vd*(r+1)/pcount
u9(
xi,y,zi,ui,vi,xf,y,zi,uf,vi,xf,y,zf,uf,vf,xi,y,zf,ui,vf)end
end
end
function M9(w)local dx,dz=f6(w.kind,0,0)local x0,z0,tid=w.x,w.z,m8(w)local x1,z1=x0+dx,z0+dz
local u0,v1,u1,v0=m7(tid)local distSq=u5((x0+x1)/2,(z0+z1)/2)local pcount=distSq>4 and 1 or 2
local psize=1.0/pcount
local ud,vd=u1-u0,v1-v0
local y0,y1=0,1
local xd,yd,zd=x1-x0,y1-y0,z1-z0
for r=0,pcount-1 do
for c=0,pcount-1 do
local rfrac,cfrac=r/pcount,c/pcount
local rfrac1,cfrac1=(r+1)/pcount,(c+1)/pcount
local xi,xf=x0+cfrac*xd,x0+cfrac1*xd
local yi,yf=y0+rfrac*yd,y0+rfrac1*yd
local zi,zf=z0+cfrac*zd,z0+cfrac1*zd
local ui,uf=u0+cfrac*ud,u0+cfrac1*ud
local vi,vf=v0+rfrac*vd,v0+rfrac1*vd
u9(
xi,yi,zi,ui,vi,xf,yi,zf,uf,vi,xf,yf,zf,uf,vf,xi,yf,zi,ui,vf,w.f&2>0 and 0)end
end
end
function N0(r)local v=RVerSprite
v.x,v.y,v.z,v.u,v.z=r.x,r.y,r.z,0,1
v7(v)v8(v)v9(v)if v.z<0.3 then return end
local sz=80*r.size/v.z
local tid=m8(r)local u0,v0,u1,v1=m7(tid)u1,v1=u1+1,v1+1
textri(
v.x-sz/2,v.y-sz/2,v.x+sz/2,v.y-sz/2,v.x+sz/2,v.y+sz/2,u0,v0,u1,v0,u1,v1,nil,0)textri(
v.x-sz/2,v.y-sz/2,v.x+sz/2,v.y+sz/2,v.x-sz/2,v.y+sz/2,u0,v0,u1,v1,u0,v1,nil,0)end
function u9(
x1,y1,z1,u1,v1,x2,y2,z2,u2,v2,x3,y3,z3,u3,v3,x4,y4,z4,u4,v4,ck)v5(f0,x1,y1,z1,u1,v1,x2,y2,z2,u2,v2,x3,y3,z3,u3,v3)v6(f0,ck)v5(f0,x1,y1,z1,u1,v1,x3,y3,z3,u3,v3,x4,y4,z4,u4,v4)v6(f0,ck)end
function v5(t,x1,y1,z1,u1,v1,x2,y2,z2,u2,v2,x3,y3,z3,u3,v3)t[1].x,t[1].y,t[1].z,t[1].u,t[1].v=x1,y1,z1,u1,v1
t[2].x,t[2].y,t[2].z,t[2].u,t[2].v=x2,y2,z2,u2,v2
t[3].x,t[3].y,t[3].z,t[3].u,t[3].v=x3,y3,z3,u3,v3
end
function m5(d,s)for i=1,3 do c7(d[i],s[i])end
end
function c7(d,s)d.x,d.y,d.z,d.u,d.v=s.x,s.y,s.z,s.u,s.v
end
function v6(t,ck)N2(t)local n=N3(t,d7)for i=1,n do
N4(d7[i])N5(d7[i])N6(d7[i],ck or -1)end
end
function N1(px,pz,ox,oz,ang)local ux,uz,ca,sa=px-ox,pz-oz,cos(ang),sin(ang)return ox+ux*ca+uz*sa,oz+uz*ca-ux*sa
end
function v7(v)local ca=R.cam
v.x=v.x-ca.x
v.y=v.y-ca.y
v.z=v.z-ca.z
v.x,v.z=N1(v.x,v.z,0,0,-ca.yaw)end
function N2(tri)for i=1,3 do v7(tri[i])end
end
function f1(a,b)ast(a.z<0.3 and b.z>=0.3)local t=(0.3-a.z)/(b.z-a.z)a.x=a.x+t*(b.x-a.x)a.y=a.y+t*(b.y-a.y)a.z=0.3
a.u=a.u+t*(b.u-a.u)a.v=a.v+t*(b.v-a.v)end
function N3(tri,out)N7(tri)
local ah={}for i=1,3 do ah[i]=tri[i].z>=0.3 end
if ah[1]then
m5(out[1],tri)return 1
end
if not ah[3]then return 0 end
if not ah[2]then
f1(tri[1],tri[3])f1(tri[2],tri[3])m5(out[1],tri)return 1
end
c7(c6,tri[1])c7(h6,tri[1])c7(m1,tri[2])f1(c6,tri[3])f1(h6,tri[2])c7(out[2][1],c6)c7(out[2][2],h6)c7(out[2][3],m1)f1(tri[1],tri[3])m5(out[1],tri)return 2
end
function v8(v)v.x=80*v.x/v.z
v.y=80*v.y/v.z
end
function N4(t)for i=1,3 do v8(t[i])end
end
function v9(v)v.x,v.y=0+184/2+v.x,0+108/2-v.y
end
function N5(t)for i=1,3 do v9(t[i])end
end
function N6(t,ck)textri(
t[1].x,t[1].y,t[2].x,t[2].y,t[3].x,t[3].y,t[1].u,t[1].v,t[2].u,t[2].v,t[3].u,t[3].v,nil,ck or -1)end
function N7(t)if t[2].z<t[1].z then m6(t,1,2)end
if t[3].z<t[2].z then m6(t,2,3)end
if t[2].z<t[1].z then m6(t,1,2)end
ast(t[1].z<=t[2].z and t[2].z<=t[3].z)end
function m6(t,i1,i2)t[i1],t[i2]=t[i2],t[i1]end
function m7(tid)ast(tid>=1000,"!TID "..tid)local sid,size=tid%1000,(tid//1000)*8
local u0,v0=8*(sid%16),8*(sid//16)return u0,v0,u0+size-1,v0+size-1
end
function N8(r)if r.kind==5 or r.kind==4 then
return r.x+0.5,r.z+0.5
elseif r.kind>=0 and r.kind<=3 then
local x1,z1=f6(r.kind,r.x,r.z)return (r.x+x1)/2,(r.z+z1)/2
else
return r.x,r.z
end
end
function N9(x,z)x,z=x-R.cam.x,z-R.cam.z
return sqrt(x*x+z*z)end
function O0()table.sort(R.mids,O1)end
function O1(a,b)local ad=a.depth-(a.f&1)*10000
local bd=b.depth-(b.f&1)*10000
if ad==bd then return a.x>b.x end
return ad>bd
end
function O2()local id=R.nextId
R.nextId=R.nextId+1
return id
end
function h8(r)r.id=O2()R.rendById[r.id]=r
if r.kind==5 or r.kind==4 then
insert(R.flats,r)else
insert(R.mids,r)end
R.ready=nil
return r.id
end
function m8(r)local t,ptid,ela,fr
t=m2[r.tid]ast(t,"!TLUT "..r.tid)ptid=t.tids[G.sbank]ast(ptid and ptid>0,"!TID "..r.tid.."@"..G.sbank)if t.nfr>1 then
ast(t.int>0,"TIN"..ptid)ela=time()-(r.astart or 0)fr=floor(ela/t.int)%t.nfr
ptid=ptid+fr*ptid//1000
end
return ptid
end
function O3()t0()a0(123)a0(L.lvlN)K7()J3()e7()end
function O4()t3()local f=b0()if f==0 then
e7()return nil
end
ast(f==123,"S FMT")k0()local lvlN=b0()s1(1)J4()e7()p7(lvlN,-1)return 1
end
SFX={
{id=1,n=16,d=30,v=8,s=1},{id=2,n=60,d=15,v=10,s=1},{id=3,n=72,d=15,v=10,s=0},{id=4,n=36,d=15,v=10,s=0},{id=5,n=36,d=30,v=10,s=-2},{id=6,n=36,d=30,v=10,s=-2},{id=7,n=48,d=15,v=10,s=1},{id=8,n=24,d=15,v=10,s=1},{id=9,n=60,d=15,v=10,s=0},{id=7,n=24,d=15,v=10,s=-1},{id=8,n=72,d=15,v=10,s=1},{id=10,n=43,d=30,v=10,s=-1},{id=11,n=36,d=30,v=10,s=-1},{id=13,n=40,d=120,v=8,s=-3},}function a3(sfxid)local s=SFX[sfxid]_=s and sfx(s.id,s.n,s.d,3,s.v,s.s)end
ZD={}function O5()local c=0
b4(31788)while 1 do
local h,z,zid=C(),{}if h==0 then break end
ast(h==204,"!ZDB/"..h)zid=C()ZD[zid]=z
z.n=c8()z.sp=C()z.proc=a6()z.f=C()c=c+1
w0(zid,z,1)w0(zid,z,nil)end
trace("ZDB "..c)end
function O6(zid)return zid>8 end
function m9(chi,pccb)if not chi then
local chis,names=K2()if #chis<1 then
U(c9(26520))_=pccb and pccb(nil)return
end
b6(i0(25906),names,O7,15,1,{chis=chis,pccb=pccb},1)return
end
local zch=K3(chi)if #zch<1 then
U(PA[chi].name..i0(25920),15,0)_=pccb and pccb(nil)return
end
b6(i0(25946)..
PA[chi].sp.." SP left)",zch,O8,15,1,{chi=chi,pccb=pccb},1)end
function O7(sel,d)if not sel then return end
local chi=d.chis[sel]ast(chi)m9(chi,d.pccb)end
function O8(idx,d)local r=nil
if idx then
local zid=PA[d.chi].zs[idx]if zid then r=n0(d.chi,zid,d.pccb)end
else
_=d.pccb and d.pccb(nil)end
end
function O9(zid)local zd=ZD[zid]ast(zd,"!ZID "..zid)return zd
end
function n0(chi,zid,cb)local zd,c=O9(zid),PA[chi]if c and c.sp<zd.sp then
U(c9(25960),15,1)_=cb and cb(nil)return
end
if B and zd.f&1<1 then
U(c9(26169))_=cb and cb(nil)return
end
if not B and zd.f&2<1 then
U(c9(26117))_=cb and cb(nil)return
end
if c then c.sp=c.sp-zd.sp end
ast(zd.proc>0,"!ZPROC/"..zid)a1(zd.proc,{chi,zid},function(r)_=cb and cb(r>0)end)end
function w0(zid,z,w)local v,itid=f2(5700)[zid],(w and 159 or 175)+zid
assert(v,"GWFS"..zid)ITDB[itid]={
n=(w and "Wand: " or "Scroll: ")..z.n.." ",sp=(w and 415 or 431)+zid,k=w and 10 or 11,f=z.f&1>0 and 1 or 0,v=v>0 and (w and 3*v or v)or nil,ac=30,att=0,def=0,desc={"Casts "..z.n},}end
function P0(face,name,msg,cb)J(P8,{face=face,name=name,msg=msg,cb=cb})end
function P1(itids,m)m=m or 1
local choices={}for _,itid in ipairs(itids)do
local itd=V(itid)insert(choices,itd.n.." ("..ceil(itd.v*m).. "gp)")end
b6({
i0(25985),"(Funds: "..P.gold.." gp)"},choices,P9,15,4,{itids=itids,m=m},1)end
function P2(ks)l5("Sell",ks,0,i0(26009),1,P3)end
function P3(it)if not it then return end
local itd=V(it.itid)b6({"Sell "..itd.n,"for "..itd.v.." gp?"},c9(26026),P4,15,5,{it=it,itd=itd},1)end
function P4(ch,d)if ch and ch==2 then
e6(d.it)h4(d.itd.v)end
end
function w1(msg,amt,cb,udata,fl)b6(n3(msg,{"Cost: "..amt.." gp"}),{"No","Yes"},P5,15,2,{cb=cb,udata=udata,amt=amt,fl=fl})end
function P5(a,d)a=a or 1
if a==2 then
if P.gold<d.amt then
U(i0(26052))a=1
else
l9(-d.amt)end
end
d.cb(a-1,d.udata)end
function P6(chi,msg,cb)local ns,ks,it,n={},{}for k=1,9 do
it=PA[chi].eq[k]if it then
_,n=d3(it)insert(ns,n)insert(ks,k)end
end
if #ns<1 then
U(PA[chi].n..i0(26693))cb(0)else
b6(msg,ns,P7,15,4,{cb=cb,ks=ks},1)end
end
function P7(i,d)d.cb(d.ks[i]or 0)end
function P8(s)local chi,tw,th,x,y,w,h,yo=
s.face<5 and s.face,e1(s.msg,true)if s.face<1 then
x,y,w,h,yo=120-tw//2-8,68-th//2,tw,th,0
else
x,y,w,h,yo=
chi and 4 or 0,chi and (108-10-th-4)or 0,chi and 184-8 or 184+1,chi and th+8 or 108+2,chi and 4 or 30
end
s.sfxp=s.sfxp or (a3(13)or 1)if s.face>0 then i7(x,y,w,h,4,15)else cls(0)end
if s.face<1 then
elseif chi then
spr(224,(2*chi-1)*43//2,y+h-1,0)else
i7(x+8,y+8,12,12,0,15)spr(s.face,0+10,0+10)prn(s.name,0+25,0+12,15)end
if ((H(171)&2>0)and btn(7))then s.clk=s.clk+10 end
local done=d1(s.msg,x+8,y+yo,15,s.clk//2,true)if s.q then return 1 end
if done and (F(4)or F(5))then
s.q=1
_=s.cb and s.cb()end
end
function P9(i,d)local itid,itd,v,err,max
if not i then return end
itid=d.itids[i]itd=V(itid)max=p1[itid]or 4
er=(#P.inv>=80 or r8(itid)>=max)and 26596
if er then U(c9(er))return end
v=ceil(itd.v*d.m)w1({"Buy "..itd.n.."?"},v,Q0,itid)end
function Q0(i,itid)_=i>0 and h3({g8(itid)})end
function Q1()cls(0)local p,c,t=24155,{}while XP[p]>0 do c[XP[p]]=XP[p+1]p=p+2 end
for x=0,179 do
for y=0,135 do
t=mget(x,y)pix(x,y,c[t]or 3)end
end
a1(24269)c3(0,0,180,136)end
function n1()b8(4,6)ast(peek(0x8000)== 123,"XL sig");
XP={}for addr=0x8000+1,0x8000+32640-1 do
insert(XP,peek(addr))end
trace("XL init LO")end
function w2()ast(XP)b8(4,7)for addr=0x8000,0x8000+32640-1 do
insert(XP,peek(addr))end
trace("XL init HI")w3()end
function w3()X=a4(X_INIT)end
function h9(vid,v)ast(vid>=128 and vid <=255,"GVID "..vid)if vid>=224 and vid<=(224+32-1)then
J1(vid-224+1,v)else
X.globs[vid]=v
end
end
function w4(vid)ast(vid>=128 and vid <=255,"GVID "..vid)if vid>=224 and vid<=(224+32-1)then
return J0(vid-224+1)else
return X.globs[vid]or 0
end
end
function a1(addr,args,retcb)args=args or {}if not addr or addr<1 then
_=retcb and retcb(0,0,0)return
end
ast(#args<=16,"#args")w9()for i=1,#args do h9(128+i-1,args[i])end
w6()b4(addr)X.tframe.retcb=retcb
n2()end
function b4(addr)ast(addr)local old=X.pc
X.pc=addr
return old
end
function C()X.pc=X.pc+1
return XP[X.pc-1]end
function f2(addr,sz)sz,addr=sz or XP[addr],addr+(sz and 0 or 1)local r={}for i=1,sz do insert(r,XP[addr+i-1])end
return r
end
function Q2(sz)local r=f2(X.pc,sz)X.pc=X.pc+#r+(sz and 0 or 1)return r
end
function a6()X.pc=X.pc+2
return f3(X.pc-2)end
function w5()X.pc=X.pc+4
return Q3(X.pc-4)end
function f3(addr)return (XP[addr+1]*256)+XP[addr]end
function Q3(addr)return f3(addr)+f3(addr+2)*256*256
end
function i0(addr)local s,_=d8(addr)return s
end
function c8()local r
r,X.pc=d8(X.pc)return r
end
function c9(addr)local s,_=w7(addr)return s
end
function Q4()local r
r,X.pc=w7(X.pc)return r
end
function Q()return H(128),H(129),H(130),H(131),H(132),H(133)end
XP=nil
X=nil
X_INIT={
pc=0,frames={},csysc=nil,tframe=nil,globs={},cmp=0,}function w6()local s,f=X.frames,{vars={},ret=X.pc}insert(s,f)X.tframe=f
end
function Q5()local s,f=X.frames
ast(#s>0)f=s[#s]remove(s,#s)X.tframe=s[#s]X.pc=f.ret
_=f.retcb and f.retcb(
H(128),H(129),H(130))end
function n2()local op,h,r
ast(not X.csysc,"CSYSCRE"..(X.csysc or 0))while 1 do
op,h=C(),Q6
h=op>119 and (XOP[op]or XOPF[op&0xf0])or h
ast(h,"!OPCODE "..op.." @"..(X.pc-1))r=h(op)if r==1 or (X.tframe and X.tframe.bsysc)then
return
end
end
end
function d8(ptr)if ptr<1 then return nil,ptr end
local s,b=""
if XP[ptr]==128 then return "",ptr+1 end
repeat b=XP[ptr]s=s..schr(b&127)ptr=ptr+1 until b>127
return s,ptr
end
function w7(addr)if addr<1 then return nil end
local count,r,s=XP[addr],{}addr=addr+1
for i=1,count do
s,addr=d8(addr)insert(r,s)end
return r,addr
end
function Q6(sys)local r,f
X.csysc=sys
f=XSYSC[sys]ast(f,"!sysc "..sys)r=f(sys)X.csysc=nil
return r
end
function b9()local fmt=C()if fmt>=243 and fmt<=252 then
return H(fmt-242)end
return fmt==255 and C()or
fmt==254 and a6()or 
fmt==253 and H(C())or fmt
end
function Q7(op)local vid=C()T(vid,b9())end
function H(vid)return vid>=128 and w4(vid)or X.tframe.vars[vid]or 0
end
function T(vid,v)ast(type(v)=="number","BADVT")if vid>=128 then
h9(vid,v)else
X.tframe.vars[vid]=v
end
end
function Q8()Q5()if not X.tframe or X.tframe.bsysc then
return 1
end
end
function w8(op)local a=H(C())if op==126 then a=a-b9()end
X.cmp=a
end
function a7(op)local addr,isc=b9(),op>=219
if addr<1 and isc then return end
op=op-(isc and 7 or 0)local cond=op==212 or
(op==213 and X.cmp==0)or (op==214 and X.cmp~=0)or 
(op==215 and X.cmp>0)or (op==216 and X.cmp>=0)or
(op==217 and X.cmp<0)or (op==218 and X.cmp<=0)if cond then
_=isc and w6()X.pc=addr
end
end
function Q9(op)local vid,a,b
vid=C()a=b9()b=b9()T(vid,random(a,b))end
function R0()trace("X @"..X.pc..": "..b9())end
function i3(op)local vid,msk,v=C()msk=b9()v=H(vid)if op==132 then
X.cmp=v&msk
else
if op==129 then msk=(~msk)&255 end
T(vid,op==130 and (v|msk)or (v&msk))end
end
function w9()for i=128,128+16-1 do T(i,0)end
end
function R1(op)local c=op-144
w9()for vid=128,128+c-1 do
T(vid,b9())end
end
function R2(op)local c,vid=op-160
for i=1,c do
vid=C()T(vid,H(128+i-1))end
end
function R3(op)local c=op-176
for i=1,c do
T(i,H(128+i-1))end
end
function f4(op)local li,lv,rv=C()lv=H(li)rv=b9()T(li,op==134 and lv+rv or op==135 and lv-rv or
op==136 and lv*rv or op==137 and lv//rv or lv%rv)end
function x5(op)local vid,a=C()a=b9()T(vid,op==139 and XP[a]or f3(a))end
function b5()X.tframe.bsysc=f5
X.tframe.bsyspc=X.pc
f5=1+f5
return f5-1
end
f5=1
function c1(scid,rets)rets=rets or {}ast(X.tframe,"SYSCR1")ast(X.tframe.bsysc==scid,"SYSCR2")X.tframe.bsysc=nil
b4(X.tframe.bsyspc)for i=1,#rets do T(128+i-1,rets[i])end
n2()end
function R4()local face,pname,pmsg,name,msg,scid
face,pname,pmsg=Q()name=i0(pname)msg=c9(pmsg)scid=b5()P0(face,name,msg,function()c1(scid)end)return 1
end
function R5()local itid,st=Q()_=itid>0 and h3({g8(itid,st)})end
function R6()local lvlN,epnum=Q()J(function(st,isFg)_=isFg and o2(lvlN,epnum>1 and epnum or 1)return 1 end)end
function R7()local pmsg,popts,fl=Q()local msg,opts,scid=c9(pmsg),c9(popts),b5()b6(msg,opts,R8,15,2,scid,fl)return 1
end
function R8(ch,scid)c1(scid,{ch or 0})end
function R9()local itid=H(128)T(128,r8(itid))end
function S0()local msg,scid=c9(H(128)),b5()U(msg,15,2,nil,function()c1(scid,{})end)return 1
end
function S1()I7(H(128))end
function S2()local g=H(128)J(function(st,isFg)_=isFg and h4(g)return 1 end)end
function S3()local itid,idx=Q()T(128,b2(K0(itid,idx>0 and idx or nil)))end
function S4()local xz,c,r=H(128)c,r=g9(xz%256,xz//256)I0(c,r)end
function S5()local xz,fi=Q()local c,r,v,ti=g9(xz%256,xz//256)ti=b3(c,r)if fi==2 then
v=b2(q1(c,r))elseif fi==1 then
v=b2(I1(c,r))elseif fi==3 then
v=ti and ti.td.flags or 16
elseif fi==4 then
v=ti and ti.sid or 0
else error("!TI"..fi)end
T(128,v)end
function S6()local ptr,m=Q()local n,itids=XP[ptr],{}for i=1,n do insert(itids,XP[ptr+i])end
P1(itids,m*0.01)end
function S7()local ks,k={}for i=128,135 do
k=H(i)_=k>0 and insert(ks,k)end
P2(ks)end
function S8()a3(H(128))end
function S9()local amt,mult=Q()J(function(st,isFg)_=isFg and l4(amt*max(mult,1))return 1 end)end
function T0()local pt,pmsg,fl,wfl=Q()local t,msg,scid=i0(pt),c9(pmsg),b5()K1(t,msg,T1,scid,fl,wfl)return 1
end
function T1(ch,scid)c1(scid,{ch or 0})end
function T2()K8()end
function T3()r9(H(128))end
function T4()local chi,pmsg=Q()local msg,scid=i0(pmsg),b5()ast(chi>=1)P6(chi,msg,function(k)c1(scid,{k or 0})end)return 1
end
x6={
[1]="class",[2]="hp",[3]="maxHp",[5]="sp",[6]="maxSp",[4]="att",[7]="speed",[10]="face",}x7={2,3,5,6,4,7,10}function x8(op)local chi,f,newv=Q()local c,fn,v1,v2,v3=PA[chi],x6[f],0,0,0
ast(c,"!SYCI")if f==8 then
v1=b2(d5(chi))elseif f==9 then
v1,v2=l0(c)v3=l3(c)else
v1=c[fn]ast(fn and v1,"SYCI2")end
if op==84 then
ast(b1(x7,f),"SYCI3/"..f)c[fn]=a8(newv,0,255)end
T(128,v1)T(129,v2)T(130,v3)end
function x9(op)local chi,k,ni,nst=Q()local c=PA[chi]ast(c,"!SYCE")T(128,c.eq[k]and c.eq[k].itid or 0)T(129,c.eq[k]and c.eq[k].st or 0)if op==102 then c.eq[k]=ni>0 and g8(ni,nst)or nil end
end
function T5()local pmsg,c,fl=Q()local msg,scid=c9(pmsg),b5()w1(msg,c,T6,scid,fl)return 1
end
function T6(a,scid)c1(scid,{a})end
function T7()s2()end
function T8()local xz,sid=Q()local c,r=g9(xz%256,xz//256)q2(c,r,sid)end
y5={
[2]="xp",[3]="level",[5]="pclk",[7]="gold",}function y6(sc)local f,v,fn,v2,mc,mr
f,v,v2=Q()if f==6 then
T(128,#PA)elseif f==1 then
mc,mr=p8(P.x,P.z)T(128,mc+mr*256)T(129,P.dir)if sc==88 then
P.x,P.z=g9(v%256,v//256)P.dir=v2
end
elseif f==4 then 
T(128,b2(l6()))elseif f==8 then
T(128,s3(P.level+1))elseif f==9 then
T(128,L1())else
fn=y5[f]ast(fn,"!SYS_PI/"..f)P[fn]=sc==88 and v or P[fn]T(128,P[fn])end
end
y7={
[1]="iproc",[2]="uproc",[3]="wproc",[4]="bproc",[5]="flags",}function T9()local f,fn,v
f=Q()fn=y7[f]ast(fn,"LIN"..f)v=L.lvl[fn]ast(v,"LINV"..fn)T(128,v)end
function U0()local chi,hp,sp=Q()K5(chi>0 and chi or nil,hp,sp)end
function U1()local ak,att,n,p,fl=Q()B2({ 
ak=ak,att=att,narr=i0(n),psp=p,fl=fl})end
function U2()local x,y,w,h,c,fl=Q()local fun=fl&2>0 and c3 or
(fl&1>0 and rectb or rect)fun(x,y,w,h,c)end
function U3()local x,y,txt,c,f=Q()prn(f&1>0 and txt or d8(txt),x,y,c,true)end
function U4()local es,eid,vst
es={}for i=0,5 do
eid=H(128+i)if eid<1 then break end
insert(es,E7(eid))end
vst=H(134)J(function(st,isf)if not isf then return end
n8(es,vst>0 and vst or L.lvl.bsn)return 1 end,{})end
function U5()t9(H(128))end
function U6()local sid,x,y=Q()spr(sid,x,y,0)end
function U7()L0(H(128))end
function U8()local chi,msg,clr,sfx=Q()e5(c2(chi),clr,d8(msg),c2(sfx))end
function U9()local zid=Q()T(128,0)for i,c in ipairs(PA)do
_=b1(c.zs,zid)and T(128,1)end
end
function V0()L.lvl.lvlt=d8(H(128))end
function V1()local f,t=Q()for lc=0,L.lvl.mcols-1 do
for lr=0,L.lvl.mrows-1 do
if b3(lc,lr).sid==f then
q2(lc,lr,t)end
end
end
end
function V2()local itid,st=Q()U(p6({itid=itid,st=st}))end
function V3()local scid=b5()l5("Item?",nil,0,"No items",nil,function(it,r)c1(scid,{it and b1(P.inv,it)or 0})end)return 1
end
function y8(op)local idx,itid,st=Q()local it=P.inv[idx]ast(it,"GSI0")if op==110 then
ast(itid>0,"GSI1")it.itid,it.st=itid,st
end
T(128,it.itid)T(129,it.st)end
function V4(op)local chi,zid=Q()local scid=b5()J(function(st,fg)_=fg and n0(chi,zid,function(r)T(128,r and 1 or 0)c1(scid)end)return 1
end,{},1)end
function V5(op)local chi=H(128)if PA[chi]then remove(PA,chi)end
end
function V6()F2(H(128))end
function V7()local chi,cm=Q()l7(chi,cm)end
function V8()F1(H(128))end
function V9()E1(H(128))end
XOP={
[124]=Q7,[125]=Q8,[126]=w8,[226]=w8,[212]=a7,[213]=a7,[214]=a7,[215]=a7,[216]=a7,[217]=a7,[218]=a7,[219]=a7,[220]=a7,[221]=a7,[222]=a7,[223]=a7,[224]=a7,[225]=a7,[127]=Q9,[128]=R0,[129]=i3,[130]=i3,[131]=i3,[132]=i3,[134]=f4,[135]=f4,[136]=f4,[137]=f4,[138]=f4,[139]=x5,[140]=x5,}XOPF={
[144]=R1,[160]=R2,[176]=R3,}XSYSC={
[61]=R4,[62]=R5,[63]=R6,[64]=R7,[65]=R9,[66]=S0,[68]=S2,[69]=S1,[70]=S3,[71]=S4,[72]=S6,
[73]=S7,[74]=S8,[75]=S9,[76]=T2,[77]=T0,[78]=x8,[79]=T5,[80]=T7,[82]=T3,[83]=S5,[84]=x8,[86]=T8,[87]=y6,[88]=y6,[90]=U0,[91]=U1,[92]=U2,[93]=U3,[94]=U4,[95]=T9,[96]=U5,[97]=U6,[98]=U7,[99]=U8,[100]=U9,[101]=x9,[102]=x9,[103]=F0,[104]=V0,[105]=V1,[106]=T4,[107]=V2,[108]=V3,[109]=y8,[110]=y8,[111]=V4,[112]=V5,[113]=V6,[114]=V7,[115]=V8,[116]=V9,}
-- <TILES>
-- 001:0000000a0000000a0000000a0000000a0000000a0000000a0000000aaaaaaaaa
-- 002:00000000000000000000000000000000000000000000000000000000aaaaaaaa
-- 003:a0000000a0000000a0000000a0000000a0000000a0000000a0000000aaaaaaaa
-- 004:0000000900000009000000090000000900000009000000090000000999999999
-- 005:0000000000000000000000000000000000000000000000000000000099999999
-- 006:9000000090000000900000009000000090000000900000009000000099999999
-- 007:555555555b55b55555555555555555b5555b555555555555555555b5b555b555
-- 008:0099990009999990999999990944449009411490094114900999999000000000
-- 009:0000000400000004000000040000000400000004000000040000000444444444
-- 010:0000000000000000000000000000000000000000000000000000000044444444
-- 011:4000000040000000400000004000000040000000400000004000000044444444
-- 012:00000004000300040033300e030303040003000e000300040003000e00000004
-- 013:00000000000000000333aaa003300aa0030000a0030000a00000000000000000
-- 014:cccccccececcccccccc3accccc373accc37377acc33733accccccccccccceccc
-- 015:9455559495594554595945955954954559549545545495455459454555555555
-- 016:00000000000000000000000000000000000000000000000009999990a999999a
-- 017:0000000a0000000a0000000a0000000a0000000a0000000a0000000a0000000a
-- 018:3333333333333333333333333333333333333333333333333333333333333333
-- 019:a0000000a0000000a0000000a0000000a0000000a0000000a0000000a0000000
-- 020:0000000900000009000000090000000900000009000000090000000900000009
-- 021:4444444444444444444444444444444444444444444444444444444444444444
-- 022:9000000090000000900000009000000090000000900000009000000090000000
-- 023:2828282882828282222222222222222282828282282828282222222222222222
-- 024:0033a0000033aa0003311a0003111aa0031111aa031111aa33333aaa00000000
-- 025:0000000400000004000000040000000400000004000000040000000400000004
-- 026:1111111111111111111111111111111111111111111111111111111111111111
-- 027:4000000040000000400000004000000040000000400000004000000040000000
-- 028:40000000e000300040003000e000300040303030e00333004000300040000000
-- 029:55555b555555bbb55555bbb55555bbb555b55b555bbb54555bbb545555455455
-- 030:ccccccc7c7c3ac7c7c377ac7c37737ac3773777a3337337a3773773ac7cc7c7c
-- 031:099999900009009000999090009990900a0000a00aaaaaa00aaaaaa00aaaaaa0
-- 032:0000000a0000009900000099000000990000009900000099000000990000000a
-- 033:aaaaaaaa0000000a0000000a0000000a0000000a0000000a0000000a0000000a
-- 034:aaaaaaaa00000000000000000000000000000000000000000000000000000000
-- 035:aaaaaaaaa0000000a0000000a0000000a0000000a0000000a0000000a0000000
-- 036:9999999900000009000000090000000900000009000000090000000900000009
-- 037:9999999900000000000000000000000000000000000000000000000000000000
-- 038:9999999990000000900000009000000090000000900000009000000090000000
-- 039:0bbbbbb0bbbbbbbbbbbbbbbb0bbbb00000044000004444000444444000000000
-- 040:00000000000000000099990004444440099ee990099999900999999000000000
-- 041:4444444400000004000000040000000400000004000000040000000400000004
-- 042:4444444400000000000000000000000000000000000000000000000000000000
-- 043:4444444440000000400000004000000040000000400000004000000040000000
-- 044:cccccccccccccceccceccccccccccccccccceccccccccceccecccccccccccecc
-- 045:5bbbbb55bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb55bb919455919194559191945
-- 046:ceccccccc4c4cccec4c4cccccc44c4cccc4ccc4ccc4ccc4cc44cc4ccc4cec4cc
-- 047:0060000000006000000e0000004ef400000440000aaaaaa00aaaaaa00aaaaaa0
-- 048:00000000000000000000000000000000000000000000000003f3f3f0af3f3f3a
-- 049:9494949494949494944994949449949494499494949994999494949494949494
-- 050:0bbbbbb0bb6bbbbbbbbbb6bb0bbbb00000044000004444000444444000000000
-- 051:000aa000000aa00000000000000aa000000aa00000000000000aa000000aa000
-- 052:0000000009000000009000000009000000009000033333700333337003333370
-- 053:1999999914444449147777491444444911119111000190000001900000000000
-- 054:008000000800d0000008d0d00808d0000aaaaaf000aaaf00000af00000aaaf00
-- 055:4444444444444494494444444444444444449444444444444944449444444444
-- 056:9444444904444440000000000000000000000000000000000000000000000000
-- 057:0000000000000000000000000000000000000000000000000444444094444449
-- 058:5555555b5b5555555553a55555373a55537377a5533733a5555555555555b555
-- 059:555555575753a57575377a57537737a53773777a3337337a3773773a57557575
-- 060:0bb00bbb000bbb000bbbbbb0bb040bbbb004000b000440000004400000444400
-- 061:5555555eeb5eb5b555e55555b5b5ebbe5b5b5b555b55e5be55e5b5b5b555b55e
-- 062:1511111551411111111115111111111111114151151114111111111114111115
-- 063:000000000000000000000000000be00000800e00000000000000000000000000
-- 064:af3f3f3a03f3f3f0000000000000000000000000000000000000000000000000
-- 065:00aaaa00000aa000000aa000000aa000000aa000000aa000000aa00000aaaa00
-- 066:11111111111111111111111144aaaa4411111111111111111111111111111111
-- 067:4444444400000000000000000000000000000000000000000000000044444444
-- 068:4000000440000004400000044000000440000004400000044000000440000004
-- 069:4444444400000004000000040000000400000004000000040000000444444444
-- 070:4000000440000004400000044000000440000004400000044000000444444444
-- 071:4444444440000000400000004000000040000000400000004000000044444444
-- 072:4444444440000004400000044000000440000004400000044000000440000004
-- 073:1111111111111111111111114499994444999944111111111111111111111111
-- 074:11111111111111111111111144ffff4444ffff44111111111111111111111111
-- 075:1114411111144111111991111119911111199111111991111114411111144111
-- 076:1114411111144111111ff111111ff111111ff111111ff1111114411111144111
-- 077:0000000000446400004c6400004444000aaaaaa00aaaaaa00aaaaaa00aaaaaa0
-- 078:000100000100601000066000006ee6000aaaaaf000aaaf00000af00000aaaf00
-- 079:000000000000000000000000000000000aaafff00aeeeef00a3333f00a3333a0
-- 080:44444444494464949444444444444464444e444449444444449444946444e444
-- 081:44444e444444eee44444eee44444eee444e44e444eee47444eee474444744744
-- 082:4444444e4e4444444443a44444373a44437377a4433733a4444444444444e444
-- 083:444444474743a47474377a47437737a43773777a3337337a3773773a47447474
-- 084:00000000000000000000000000000000000000000000000001f1f1f04f1f1f14
-- 085:4f1f1f1401f1f1f0000000000000000000000000000000000000000000000000
-- 086:4eeeee44eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee44ee919444919194449191944
-- 087:5e55555e5e55e55e5e5e555e5e5b5ebe5b5e5b5e5e5e5e575b5b5ebebe5ebe5b
-- 088:28282828828282822222222222222222444eeeee249999e8249999e222499e22
-- 089:00000000000ff000007aaf00007aaf00007aaf00003aa700003aa70000037000
-- 090:4444444440000004400000044000000440000004400000044000000444444444
-- 091:555555569b5eb5b555655555b5b5ebb95b5b5b555b5565b95565b5b5b555b556
-- 092:00000000000dd00000d22d0000d22d0000d22d0000d22d000a0dd0a00aaaaaa0
-- 093:fffffffffaffafffffffffffffffffaffffaffffffffffffffffffafafffafff
-- 094:fffffaffffffaaafffffaaafffffaaafffaffafffaaaf3fffaaaf3ffff3ff3ff
-- 095:aaaaaaaaafaafaaaaaaaaaaaaaaaaafaaaafaaaaaaaaaaaaaaaaaafafaaafaaa
-- 096:fffffffafafffffffff3afffff3a3afff3a3aaaff33a33afffffffffffffafff
-- 097:fffffffafaf3afafaf3aaafaf3aa3aaf3aa3aaaa333a33aa3aa3aa3afaffafaf
-- 098:0077f70007777f70777777f70744447007411470074114700777777000000000
-- 099:d8d8d8d88d8d8d8ddddddddddddddddd8d8d8d8dd8d8d8d8dddddddddddddddd
-- 100:faaaaaffaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaffaa7137ff317137ff317137f
-- 101:a0000000990000009900000099000000990000009900000099000000a0000000
-- 102:a999999a09999990000000000000000000000000000000000000000000000000
-- 103:a0000000f30000003f000000f30000003f000000f30000003f000000a0000000
-- 104:0000000a0000003f000000f30000003f000000f30000003f000000f30000000a
-- 105:5555555558558582552552555558558558585855555555528258558585258558
-- 106:00000000000000000003f00000377f00037777f0037777f0037777f0037777f0
-- 107:15111115514b11b11b1115b111b11b1111b1b1511511141111b11b1114111115
-- 108:1111111b1b1111111113a11111373a11152572b1155255b1111111111111b111
-- 109:0000000006000600060060000666000006006000060006000600006000000000
-- 110:afaaaaffffa777faff7070ffff7777ffaff77ffaffaaaafff333333ff333333f
-- 111:00000000006699000666669006666690ee6666eeee4444ee0ee4e4e00e4e4ee0
-- 112:696e696e96e696e6666666666666666696e6e69669696e696666666666666666
-- 113:3333333337373333373733333377373333733373337333733773373337333733
-- 116:6666666666666666666666666666666666666666666666666666666666666666
-- 128:666666666000f0066000f0066000f0066000f0066000f0066000000666666666
-- 129:6666666660fff0066000f00660fff00660f0000660fff0066000000666666666
-- 130:6666666660fff0066000f00660fff0066000f00660fff0066000000666666666
-- 131:6666666660f0f00660f0f00660fff0066000f0066000f0066000000666666666
-- 132:6666666660fff00660f0000660fff0066000f00660fff0066000000666666666
-- 133:6666666660fff00660f0000660fff00660f0f00660fff0066000000666666666
-- 204:666666666666666666449966664ccc6666cece6666cccc66666cc66666555566
-- 205:33363333633363363636666333666633666e6e36336666633699999999999999
-- 206:0000000000000000000eee0000eccc0000e7d7d00eeccc000eecc00000999900
-- 207:0000000000000000007ff000000f00000070f00007000f000077f00000000000
-- 208:00ee0f0000eeff0000444400004ccc000041c100004ccc00000c440000666400
-- 209:00ee0f0000eeff0000669900066ccc000662c200066ccc00066cc00006dddd00
-- 210:00000000000af00000aaaf0000accc0000a1c10000cccc00000ac00000aaaa00
-- 211:0000000000000000007777000073330000763600007ccc00007cc00000777700
-- 212:0000000000000000001111000011110000161600001111000011100000111100
-- 213:0000bb0000b0b00b005b0b000555b0b005555000055ff00000fff00000000000
-- 214:000066000060600900e609000eee60900eeee0000efff00000fff00000000000
-- 215:0000000b011111b001515b100115b110011b111001b515100b115110b0000000
-- 216:00000000000000000060e06000066e00006666e000066e000060e06000000000
-- 217:0000000000000ff00000f0000fff0ff000f00000000ff00000000ff000000000
-- 218:42224444f424fffff44f0000f4f00000ff000000f00000000000000000000000
-- 219:dddd8ddddfdd8dfd8f8dddf28d8ddfd2dd8fdfddfddf8d8df2dd8d8fd2dddd8f
-- 220:d000000d0d0220d000200200020ff020020ff020002002000d0220d0d000000d
-- 221:3333333333333333333333333333333333373733333333333333333333333333
-- 222:0000000020020000000020000202d000000ddd00000ff0000000000000000000
-- 223:0000000000000000000fff0000fccc0000f7d7d0007ccc00000cff0000555f00
-- 224:f444444ff44444f0f4444f00f444f000f44f0000f4f00000ff000000f0000000
-- 225:00000000000000000044440004444400044a3a00044333000443300004444000
-- 226:0000000000000000000ccc00009ccc000093c300009ccc00000c990000ddd900
-- 227:00000000000000000000000000fff00000000000000000000000000000000000
-- 228:000000000000600900060000000e609000eee000000ff0000000000000000000
-- 229:6666666666666666666ccc6666eccc6666eece6666eccc66666cee6666ddde66
-- 230:000000000000000000cccc0000fccc0000f2c20000cccc00000cc00000444400
-- 231:000000000000000000666600066ccc000662c20006cccc00060cc00006bbbb00
-- 232:0000000000000000000aaa0000accc0000a1c10000accc00000caa0000555a00
-- 233:000000000000000000000000005bff00005bff00000000000000000000000000
-- 234:eeeeeeffee4e4444e4e00000ee000000e4000000e4000000f4000000f4000000
-- 235:000000000bbbbbe00bbbbbe00bbbbbe00bbbbbe000bbbe00000be00000000000
-- 236:00000000000bf00000bbbf000bbbbbf0000bf000000bf000000bf00000000000
-- 237:0000000000000000050505500505050500500555050505000505050000000000
-- 238:0ff000009eef00009eef0000099000000000ff000009eef00009eef000009900
-- 239:00000000000044900000449000044900000490000ff0000000f0000000000000
-- 240:000000000000000000449900004ccc0000c2c20000cccc00000cc00000555500
-- 241:000000000000000000669900006ccc000662c20006cccc00000cc00000999900
-- 242:000000000000000000aaff0000accc0000c2c20000cccc00000cc00000444400
-- 243:0dd8000000dd80000ddddd8000fccc0000f2c20000fccc00000fff0000dddf00
-- 244:000000000000000006606c00611611c0611111c006111c000061c000000c0000
-- 245:000000000000000000333300003ccc000031c10000cccc00000cc00000333300
-- 246:000000000000000000444400004ccc0000c1c10000cccc00000cc00000666600
-- 247:001fa10001fffa101fffffa1111fa110001fa100001fa100001fa10000000000
-- 248:0000000000e00000000e0000eeeee000111e100000e100000010000000000000
-- 249:1001010001161610116666110166666116666661111666610161161001000101
-- 250:000000000000000000333300033ccc000331c10003cccc00000cc00000444400
-- 251:0000000000000000000ccc0000fccc0000f1c10000fccc00000cff0000555f00
-- 252:0a0000000033300003333330004ccc000041c10000cccc00000cc00000777700
-- 253:000000000000000000eeee000eeccc000ee2c2000ecccc0000ecc00000666600
-- 254:000000000000000000999900099ccc000992c20009cccc00009cc00000888800
-- 255:000000000000000000444400004ccc000041c10000cccc00000c440000555400
-- </TILES>

-- <TILES2>
-- 002:0000000000000000000000000000000000033777003777770037737700337337
-- 003:000000000000000000000000000000007ffff00077777f0037737f00a7377a00
-- 005:0000000000000000000000000000000000000000000000000000000005000000
-- 006:000000000000000a000000130000015b0000125b00013733000171a5000131a2
-- 007:0000000000000000a00000003a00000033b00000a55b00002255b0007333b000
-- 010:fffdfffdaafdaafddddddddd888daddda8fffdffadaafdaaddadddd8ddddd888
-- 011:fff7fffdaaf8aafddd888dddddddddddfdfffdfffdaafdaa8dddd88ddddddd8d
-- 012:fffdfffd77fd2222ddd2fddfaa2dfdfffa2dfdf2fafd2dffdafdddffda2d2dff
-- 013:fff7fffd2222ddfddddd2ddd2dddd2ddddfdd2ffdd2dd2dddd2dd2ad2d2dd2ad
-- 014:ddd22222aa2fffffd2f77777f2f02020d2f02020d2f02020a2f02020f2f02020
-- 015:22222dddfffff2dd77777f2d20202f2f20202f2f20202f2f20202f2d20202f2d
-- 018:003773770037777700333aa70033773700377777003777770033777700377777
-- 019:37377a0077777a0037737a003a777f0077777700777a7a0077777a0077777700
-- 020:00050000005050200000500205025002505205b25052b5250052b5252b252525
-- 021:505000005000000050020550502050055025000000250200b0b500b0b2b52b2b
-- 022:0013533a0053773500112553002ab33502225b2502555511225257552553a551
-- 023:37353a00a5a75a0075753b00335355b0525725105a13555a15a555755755a555
-- 024:0000000000000000000000000000033700003777000077a70033737700377777
-- 025:000000000000000000000000300ff0007777ff00777a7f00a7777a0077777700
-- 026:fffdfff8aafdaafddddddddd888dddddf8fffdffa8aafdaadadd88dddddddddd
-- 027:fffdfffdaafdaafdddddddddddddddddfdfffdfffdaaf8aadddd888ddddddddd
-- 028:ff2d2dff772d2d2fdd2d2f2faa2ddf2ffafdfaafaafdfddfda2dfddfdd2dfadf
-- 029:2dffd2fdddffd2fd2dd2d2dd2dd2d2dd22d2d2ffa2fdd2aaddddd25dadddd2dd
-- 030:f2f02020a2f02020d2f02020a2f7a7a7d2f03030f2f7a7a7d2f02020d2f02020
-- 031:20202f2d20202f2a20202f2aa7a7af2a30303f2aa7a7af2f20202f2d20202f2d
-- 032:0000000000000000000000aa000000a7000000730000007700000007000000aa
-- 033:0000000000000000ff00600077000000730090607700900070099900af00e000
-- 034:0000000000000000000000aa000000a7000000730000007700000007000000aa
-- 035:0000060000000000ff06000077000000730090007700900070099900af00f000
-- 036:0000000000000000000000aa000000a7000000730000007700000007000000aa
-- 037:0000000000000000ff00000077000000730000007700000070000000af000000
-- 038:666666666666666666666666666996966696696666666666666666666666666e
-- 039:666666667666666667666e666666666666e6666666666666e669696666669666
-- 040:66666666666666666666666a6666666666666666669666666a6e666666666666
-- 041:66666666666666666666676696696666699666e666666e666666e66666766666
-- 042:333733333333e73333a337733a3337393333333a3333333769e3333733373773
-- 043:333733333a7333a337333333e37333a3633e63a3333a3933733333e6a3333333
-- 044:333733333333673333a337733a3337363333333a333333376963333733373773
-- 045:333733333a7333a337333333637333a36336e3a3333a3633733333eea3333333
-- 048:00000aaa0000333f000377770037a33700377377003777a70033377300337777
-- 049:aaf0e000fffff0007777e0003737ef007777ff007737ef0077a77a0077777a00
-- 050:00000aaa0000333f000377770037a33700377377003777a70033377300337777
-- 051:aaf0e000ffffe0007777e0003737ff007777ef007737ef0077a77a0077777a00
-- 052:00000aaa0000333f000377770037a33700377377003777a70033377300337777
-- 053:aaf00000ffff00007777f00037377f0077777f0077377f0077a77a0077777a00
-- 054:66666666666e666666969666666666666666666666666666666766e66666666e
-- 055:667766666666666666666666699666669669666666666766ee66666666e66666
-- 056:6666666e6e6e666666e666666666696666699696669666666666666666666666
-- 057:66669666e669696666666666666666666666666667666e667666666666666666
-- 058:33373333333333a33a73333333333339737333633337e3a3333376333a333933
-- 059:3a6333333693333ee33336733363633333393373333373333336733333996e37
-- 060:33373333333333a33a73333333333336737333e3333763a3333379333a333633
-- 061:3a63333336e33336e33336733363933333363373333373333339733333966637
-- 064:0000377a00003377000007370000003300000037000000330000003700000077
-- 065:77af000037af00007af000007f0000007a0000007a0000007a00000077000000
-- 066:0000377a00003377000007370000003300000037000000330000003700000077
-- 067:77af000037af00007af000007f0000007a0000007a0000007a00000077000000
-- 068:0000000000000000000007030700070000707000000700000007000000030030
-- 069:0000000000000000700000000700037007007000007070000003000000707000
-- 070:aaa3aaa377a377a33333333311137333a1aaa3aaa377a3773373333133333111
-- 071:aaa7aaa377a177a33311133333333373a3aaa3aaa377a3771333311333373313
-- 072:aaa3aaa377a377a33333333311137333a1aaa3aaa377a3773373333133333111
-- 073:aaa7aaa377a177a33311133333333373a3aaa3aaa377a3771333311333373313
-- 074:00000000000066690066cccc006c6666006c6666006c6666006c66660efff666
-- 075:0000000099990000cccc99006666c9006666c9006666c9006666c900666eeff0
-- 080:000000330000003a0000003700000043000000e30000033700003a7e00003697
-- 081:7a0000007a000000ea0000007a000000790000007a600000a7a6000037e90000
-- 082:000000330000003a0000003700000043000000430000033700003a7e00003e97
-- 083:7a0000007a0000006a0000007a0000007e0000007a600000a7a60000376e0000
-- 084:0007070000037000000070000000700000003000000070000000700000077000
-- 085:0077000003700000003000000070000000700000003000000037000000770000
-- 086:aaa3aaa177a377a36e64413311133e63a1aaa3aa7377a377644644696699ee66
-- 087:aaa3aaa377a377a33333e6117e311133a6aaa3aaa677ae779e66eee666666666
-- 088:aaa3aaa177a377a3e661113311133663a1aaa3aa7377a3776766e46966e99666
-- 089:aaa3aaa377a377a333336e1176311133aeaaa3aaa677a47799664446ee666eee
-- 090:0e44f6660e44e6660eeee66600ee111100ee444400eee4e400ee4e4e00ee4444
-- 091:666e44f0666e44e0666eeee01111ee004444ee00e4e4ee004e4eee004444ee00
-- 238:0000377a00003377000007370000003300000037000000330000003700000077
-- 239:77af000037af00007af000007f0000007a0000007a0000007a00000077000000
-- 254:000000330000003a0000003700000033000000730000033700003a7700003777
-- 255:7a0000007a0000007a0000007a0000007f0000007af00000a7af0000377a0000
-- </TILES2>

-- <TILES4>
-- 001:8888888888888888888888888888888888888888888888888888888888888888
-- 002:555555552bbbb2b2222222222525552222222222222222222225522222222222
-- 003:2222222222222222222222222222222222222222222222222882222222222222
-- 004:777777772aaaa2a2222222222323332222222222222222222223322222222222
-- 005:4444444429999292222222222424442222222222222222222221122222222222
-- 006:eeeeeeee2eeee2e2222222222e2eee2222222222222222222229922222222222
-- 007:2222222222222222222222222228822222222222222222222222222222222222
-- 008:dddddddddddddddddddddddddddddddddddddddddddddddd3dadadad33aaaaad
-- 009:8888888888888888989898988989898998989898998999899999999999999999
-- 010:2222222222222222222299222222222222222222222222222622222222222222
-- 011:ddddddddddddddddddddddddddddddddddddddddddddddddd3dadadad33aaaaa
-- 012:44444444444444444444444444444444444444444444444434a4a4a433aaaaa4
-- 013:444444444444444444444444444444444444444444444444434a4a4a433aaaaa
-- 014:0000000000000000000000000000000000333000033a33700333a33733a33333
-- 015:0000000000000000000000000000000007000000337000003333033333a333a3
-- 016:ddddddd2dddddd25ddddd255dddd2555ddd25555dd255b55d255555b25555555
-- 017:eddddddd5edddddd55eddddd555edddd5555eddd55555edd5b5555ed5555555e
-- 018:555555555b555555555555b5555555555555555555555b555555555555555555
-- 019:edddddd25edddd2555edd255555e25b55555e5555555555b5b555555555555b5
-- 020:dddddddddddddddd44444444494949494a4dd4a4a4dddd4a4dddddd44dddddd4
-- 021:999eeeee2999e2e22222222229222222222222ee222922222222222222222222
-- 022:000000000000000041414544451515555a5004a15500001a1000000140000004
-- 023:70000000370000003374145433375919733375543333375a3373337433333334
-- 024:377777ad377377ad337377ad377377ad3777aaa733377aaaa3777a77a3737aaa
-- 025:ddddddddddddddddddddddddadadadad77777777aaaaaaaaaaaaaaaaaa9aa77a
-- 026:ddddddddddddddddddddddddadadadad77777777aaaaaaaa77aa6aa7aaaaa9aa
-- 027:d377777ad3773a7ad377377aa377a73a7377777aa33377aa7a377aaaaa3737aa
-- 028:444444444444444444444444a4a4a4a477777777aaaaaaaaaaaaaaaaaa9aa77a
-- 029:444444444444444444444444a4a4a4a477777777aaaaaaaa77aa6aa7aaaaa9aa
-- 030:3337337332337337272a33377717137717171711171711711717117117117117
-- 031:3333733332a33373a723333711713a1111717177177171711711717117117171
-- 032:00000000000000000000000000000000000000000000000030a0a0f033aaaaa0
-- 033:444444424444442544444255444425554442555544255b554255555b25555555
-- 034:e44444445e44444455e44444555e44445555e44455555e445b5555e45555555e
-- 035:000000000000000000000000000000000000000000000000030a0a0a033aaaaa
-- 036:eddddddd5edddddd55e44444555e4949b555e4a455555e4a55b555e455555554
-- 038:888888828888882544444255494925554a425555a42555b5425b555525555555
-- 039:1111111111111111111111111111111111111111111111111111111111111111
-- 040:a373aaaaa3777aaaa3773aaaa3777aaaa3777aa7a333a7aaa37777aa73777777
-- 041:a6e9aaaaaefeaaaaaa4aaa44aa4aa4307a4a4030aaaa403077aa403077777777
-- 042:aaaa9e9aaaaaefea44aaa4aa304aa4aa3034a4aa3034aaaa3034a77a77777777
-- 043:aa3737aaaa3777aaaa337aaaaa37777aaa37777aaa37337aaa37777a77377777
-- 044:444444444444444411111111191919191a1441a1a144441a1444444114444441
-- 045:377777a4377377a4337377a4377377a43777aaa733377aaaa3777a77a3737aaa
-- 046:4377777a43773a7a4377377af377a73a7377777aa33377aa7a377aaaaa3737aa
-- 048:311111a0311311a0331311a0311311a03111aaa733311aa103111a7703131a11
-- 049:000000000000000000000000f0f0f0f077777777111111111111111111911771
-- 050:000000000000000000000000f0f0f0f077777777111111117711611711111911
-- 051:0311111a03113a1a0311311af311a13a7311111a133311aa71311aa0113131a0
-- 052:777777771aaaa1a1111111111313331111111111111111111115511111111111
-- 053:4444444444444444444444444444444444444444444444444444444444444444
-- 054:dddddddddddddddddddddddddddddddddd555dddd55b55edd555b55e55b55555
-- 055:dddddddddddddddddddddddddddddddddedddddd55eddddd5555d55555b555b5
-- 056:2222222222222882222222222222222222222222222222222222222222222222
-- 057:2222222222222222222222222222222222222222222222222222222222222222
-- 058:99999999999999999999999999999999999999999999999999999999e99999ee
-- 059:999999999999999999999999999999999999eeee99eeeeeeeeeeeeeeeeeeeeee
-- 060:99999999999999999999999999999999eeee9999eeeeee99eeeeeeeeeeeeeeee
-- 061:99999999999999999999999999999999999999999999999999999999ee99999e
-- 062:e44444445e44444455e11111555e1919b555e1a155555e1a55b555e155555551
-- 064:0313aa1103111a1103113a1103111a1103111a17033311110371111173771777
-- 065:16e911111efe1111114111441141143071414030111140307711403077777777
-- 066:11119e911111efe1441114113041141130341411303411113034177177777777
-- 067:113131a0113111a011331aa01131111011311110113133101131111077311111
-- 068:1111111111111111111111111111111111111111111111111551111111111111
-- 069:e44444425e44442555e44255555e25b55555e5555555555b5b555555555555b5
-- 070:555e55e55255e55e252b55544414154414141455141411411414114114114114
-- 071:5555e55552b555e5b525555e11415b1111414155144141411411414114114141
-- 072:1111111111111111111111111111551111111111111111111111111111111111
-- 073:aaaaaaaa33333333333333333333333333333333333333333333333333333333
-- 074:4e999eee44e9eeee444eeeee4444eeee44444eee444444ee4444444e44444444
-- 075:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 076:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 077:eee999e4eeee9e44eeeee444eeee4444eee44444ee444444e444444444444444
-- 078:0000000000000000000000000000000000700000000000000000000000000000
-- 079:2222222222222222292222222222222222222222222226622222222222222222
-- 080:8888888d888888dd88888ddd8888dddd888ddddd88dddddd8ddddddddddddddd
-- 081:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 082:d8888888dd888888ddd88888dddd8888ddddd888dddddd88ddddddd8dddddddd
-- 083:3333333313333131111111111313331111111111111111111113311111111111
-- 084:0000000100000013000001330000133300013333001331330133333113333333
-- 085:7000000037000000337000003337000033337000333337003733337033333337
-- 086:3333333337333333333333733333333333333333333337333333333333333333
-- 087:7000000137000013337001333337137333337333333333373733333333333373
-- 088:1111111111111551111111111111111111111111111111111111111111111111
-- 089:9999999999999999999999999999999999999999999999999999999999999999
-- 090:4999999944999999444999994444999944444999444444994444444944444444
-- 091:4eeeeeee44eeeeee444eeeee4444eeee44444eee444444ee4444444e44444444
-- 092:eeeeeee4eeeeee44eeeee444eeee4444eee44444ee444444e444444444444444
-- 093:9999999499999944999994449999444499944444994444449444444444444444
-- 094:99999eee299222222222222e2299222222222222292222e22222222222222222
-- 095:eeeeeeee2e22eee22222222222eee22e22222222222222222222292222222222
-- 096:00000000000000000000ff00000f000f000f000f000f000f0000ff0000000000
-- 097:0000000000000000f00ff00f0f0f0f000f0f0f000f0f0f00f00f0f0000000000
-- 098:0000000000000000ff0fff00f00f0f0ff00ff00ff00f0f0ff00f0f0000000000
-- 099:0000000000000000f00f00000f0f000f0f0f00000f0f0000f00fff0f00000000
-- 100:0000000000000000ff00000000000000f00000000f000000f000000000000000
-- 112:000aaaaa00003333000000000000000000000000000000000000000000000000
-- 113:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 114:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 115:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 116:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 117:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 118:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 119:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 120:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 121:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 122:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 123:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 124:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 125:aaaaaaaa33333333000000000000000000000000000000000000000000000000
-- 126:aaaaaaa033333333000000000000000000000000000000000000000000000000
-- 130:0000000000000000000000000000000000000000000000b000000b0b00000bbb
-- 131:000000000000000000000000000000000000000000bb0bbb0b0000b00b0000b0
-- 132:00000000000000000000000000000000000000000b00b00b0b0b0b0b0b0b0b0b
-- 133:0000000000000000000000000000000000000000b00000000b0000000b000000
-- 139:00000000000000000000000000000000000000000000000000000f0000000ff0
-- 140:0000000000000000000000000000000000000000000000000f00f00fff0f0f0f
-- 141:0000000000000000000000000000000000000000000000000f0fff000f0f0000
-- 142:0000000000000000000000000000000000000000000000000003000000300000
-- 144:00000a0a0000000000000a000000000000000a000000000000000a0000000000
-- 145:0a0a0a0a00000000000000000000000000000000000000000000000000000000
-- 146:0a0a0b0b00000b0b000000000000000000000000000000000000006600000600
-- 147:0b0000b000bb00b0000000000000000000000000000000000060066006060606
-- 148:0b0b0b0b0b00b00b000000000000000000000000000000000066066606000600
-- 149:0b0000000b000000000000000000000000000000000000000600000006000000
-- 152:000000a000000000000000a000000000000000a000000000000aaaaa000aaafa
-- 153:a0a0a0a00000000000000000000000000000000000000000aa000000aa300000
-- 154:a0a0a0a000000000000000000000000000000000000000000000000000000000
-- 155:a0a00f0f00000f0000000f000000000000000000000000ff00000f00000000f0
-- 156:0f0f0f0f0f0f0f0f0f00f00000000000000000000fff0f000f000f000ff00f00
-- 157:0f0ff0000f0f0000f00fff0300000000000000000fff00ff0f000f000ff00f00
-- 158:03000000300000000000000000000000000000000fff000000f0000000f00000
-- 160:00000a000000000000000a000000000000000a000000000000bbbbbb00bbfffb
-- 161:0000000a000000000000000a000000000000000a00000000b0006666b30066f6
-- 162:0a0a0600000006000000006600000000000000000000000066600000f6630000
-- 163:0666060606060606060606060000000000000000000000000000000000000000
-- 164:0600066006000600006606660000000000000000000000000000000000000000
-- 165:0600000006000000066600000000000000000000000000000000000000000000
-- 167:000000000000000000000000000000000000000000000000000aaaaa000aaafa
-- 168:000aafff000afafa000aaafa000aaafa000aaaaa00003333aa0aaaaaaa3aaafa
-- 169:aa300000fa300000aa300000aa300000aa30000033300000aa0aaaaaaa3aaafa
-- 170:000000000000000000000000000000000000000000000000aa000000aa300000
-- 171:0000000f00000ff0000000000000000000000000000000000000000000000000
-- 172:0f000f000fff0fff000000000000000000000000000000000000000000000000
-- 173:0f000f000fff00ff000000000000000000000000000000000000000000000000
-- 174:00f0000000f00000000000000000000000000000000000000000000000000000
-- 176:00bbbbfb00bbbfbb00bbfbbb00bbfffb00bbbbbb000333330000000000000000
-- 177:b30066f6b300666fb30066f6b30066f6b3006666330003330000000000000000
-- 178:f663000066630000f6630000f663000066630000333300000000000000000000
-- 183:000aafaa000affff000aafaa000aaafa000aaaaa000033330000000000000000
-- 184:aa3aaafafa3afafaaa3aafffaa3aaafaaa3aaaaa333033330000000000000000
-- 185:aa3aaaaffa3affffaa3aaaafaa3aaafaaa3aaaaa333033330000000000000000
-- 186:aa300000fa300000aa300000aa300000aa300000333000000000000000000000
-- 192:00000000000000000000000f0000000f000000000000000a0000000000000000
-- 193:00000000fff0f0000000f0f0ff00ff0f00a0a00aaa00a00a0000000000000000
-- 194:000000ff00ff000f0f00f0f00ff0f0f00a0aa0a00a00a00a0000000000000000
-- 195:00000000f000ff000f0f00f00f0f00f00a0a00a0a000aa000000000000000000
-- 196:000000000f0f0000f000f000f0f0f000a0a0a0000aaa00000000000000000000
-- 197:000000000ff00f0ff00f0f00f00f0f00a00a0a0a0aa000a00000000000000000
-- 198:00000000000ff00ff0f00f0ff0f0f00f00aa000a000aaa0a0000000000000000
-- 199:000000000f000ffff0f000f000000f0000000a00000000aa0000000000000000
-- 200:0000000000f00000f0f0f00f00ff0f0fa0a00a0a00a00a000000000000000000
-- 201:00000000ff00000000f000000f000000a0000000aaa000000000000000000000
-- 208:0000000000e000000e0ee00000000eee000ee0ee000ee00300eee00300eee003
-- 209:0000000000000000000e0000eee00000ee000000000000000000000030000000
-- 211:0000000000000000000e00000000ee000000ee000000ee000000ee000000ee00
-- 213:00000000000000ee0000000e0000000000000000000000000000000000000000
-- 214:000000000eee0000eee30000ee030000ee033000ee030000ee330000ee030000
-- 216:0000000000000000000000000000000000eeee000e000ee0000000ee0000000e
-- 217:00000000000000000000000000000000000000000000000000000000e0000000
-- 218:000000000000000033130000311311a03111aaa733311aa103111a7703131a11
-- 219:0000000000000000000000000000000070000007100010111100111111101771
-- 220:00000000000000000000000011f1101071111117111111117711111711111111
-- 221:00000000000011100011311a0111a13a7311111a133311aa71311aa0113131a0
-- 224:00eee03300eee00300fff00000eee00300eee003000eee03000000ee00000000
-- 225:00000e00000000ee000000ff0000e0ee000e00ee0ee000eee000000000000000
-- 226:0000000e0e0ee0ee0f0ff0ff0e0ee0ee0e0ee0ee0e0ee0eee0e0000000000000
-- 227:ee00ee0e0ee0ee000ff0ff000ee0ee00e000ee0000e0ee00ee00ee0000000000
-- 228:000e00eeee0e0ee0ff0f0ff0ee0e0ee0ee0e0eeeee0e0ee00ee000ee00000000
-- 229:e0000000ee000000ff000000ee000000000000000e00000ee00000ee00000000
-- 230:ee030000ee030000ff000000ee030000ee0300eeeee3eee000ee000000000000
-- 231:0eeee00e0000ee0e0000ff0f000eee0e0ee0ee0e0ee0ee0e00eee00e00000000
-- 232:eee0000ee0ee0ee0f0ff0ff0e0ee0ee0e0ee0ee0e0ee0ee0e0ee00ee00000000
-- 233:ee00eee0ee0ee0eeff0ff000ee0eee00ee0000eeee0ee0eee000eee000000000
-- 234:0313aa1103111a1103113a1103111a1103111a17033311110371111173771777
-- 235:1111111111111111114111441141143071414030111140307711403077777777
-- 236:1111111111111111441114113041141130341411303411113034177177777777
-- 237:113131a0113111a011331aa01131111011311110113133101131111177311111
-- 238:00000000000000000001a0000011a00000111a0010111a00111111a0111111a0
-- 248:0000000000e00000000e0000eeeee000111e100000e100000010000000000000
-- </TILES4>

-- <TILES5>
-- 001:2222222222222222222222aa22222af22222af222222af2222222af2222222aa
-- 002:2222222222222222222222222222222228222222222222222222222222222222
-- 003:2222222222222222222222222222222222222222222222222222222222222222
-- 004:888888888888858855855b585b5555b555b5555b555555555555555555555555
-- 005:8888888888888888888888888888888888888888888888888888888888888888
-- 006:88888888888888888888888888888888888888888888888838f8f8f833fffff8
-- 007:8888888888888888888888888888888888888888888888888888888888888888
-- 008:8888888888888888888888888888888888888888888888888888888888888888
-- 009:888888888888888888888888888888888888888888888888838f8f8f833fffff
-- 010:44477aa7aaa77aa787aa44aa88477447888744a78888874488888aa788888877
-- 011:7aaaa777777444777aaa77aa44474447aaa7aa7777aa47a77a7aaa4744477aa7
-- 012:333037703733377333777a77377377733730373037333733377777773373aa77
-- 013:7770fff0aa77f7ff7777777f3777377f0373037f3373337f7a37777f7777a77f
-- 014:2222222222222222222222d222222222222222222d2222222222222222222222
-- 015:cccccccccccccc4cceccccccccccccccccccccccccccccccc4cccccccccccecc
-- 016:2222222222222222222222222020202002020202202020200022002222002200
-- 017:2222222222222222222222222020202002020202202020200022002222002201
-- 018:2222222222111111221111112111111921111119111111991111119911111999
-- 019:2222222292222222922222229920202099020202999020209992002299ee2200
-- 020:0000000600000060000000000000000000000006000000000000000000000006
-- 021:000000000000000000000000600000006660000069e00000699e00009999e000
-- 022:377777f8377377f8337377f8377377f83777aaf733377ffaa3777f77a3737faa
-- 023:888888888888888888888888f8f8f8f877777777aaaaaaaaaaaaaaaaaa9aa77a
-- 024:888888888888888888888888f8f8f8f877777777aaaaaaaa77aa6aa7aaaaa9aa
-- 025:8377777f83773a7f8377377ff377a73f7377777fa33377ff7a377afaaa3737fa
-- 026:888888888888888888888888f8f8f8f877777777aaaaaaaaaaaaaaaaaaaaa77a
-- 027:888888888888888888888888f8f8f8f877777777aaaaaaaaaaaa4aaaaaa4347a
-- 028:37777aaf3777777733373777337aa77737777773377773303377773033773730
-- 029:7777777f77aaa77f777ff77f7377777f3777aaaf0377777f0377737f0377777f
-- 030:888888888888888888888888f8f8f8f879999997a999999aa9eeee9aa999999a
-- 031:ffffffffffffffaffffffffffffffffffffffffffffffffffafffffffffffaff
-- 033:0000000100000011000000110000011100000111000011110000111100000000
-- 034:11111999111199991111999e111999ee111999ee119999ee119999ee00000000
-- 035:1eee00001eeee0001eeee00011eeee0011eeee0011eeeee011eeeee000000000
-- 036:000000690000069900000699007f009e0077aa4e0000a74407ff7047077aaa07
-- 037:9ee99e00eeeeee00efeee000fffef770ffe44500ee457af7aa74a777777a7700
-- 038:a373afaaa3777faaa3773faaa3777faaa3777fa7a333a7aaa37777aa73777777
-- 039:a6e9aaaaaefeaaaaaa4aaa44aa4aa4307a4a4030aaaa403077aa403077777777
-- 040:aaaa9e9aaaaaefea44aaa4aa304aa4aa3034a4aa3034aaaa3034a77a77777777
-- 041:aa3737faaa3777faaa337afaaa37777aaa37777aaa37337aaa37777a77377777
-- 042:aaaaaaaaaa7aaaaaaaaaaaaaaaaaa77a7aaaaaaaaaaaaaaa77aaaaaa77777777
-- 043:aaa434aaaaa434aaaaa444aaaaaaaaaa7aaaaaaaaaaaaaaa77aaa77a77777777
-- 044:3777773337733777377aa73733377777373773a7377777773733777a33a37777
-- 045:337aa77f7777777f7733777f777ff77f7aa7777f773f777fa777777fff77aa7f
-- 046:a9eeee9aa999999aa999999aaa99997a7aa99aaaaaaaaaaa77aaaaaa77777777
-- 047:0000000000000000000000000000000000000000000000000000000044444444
-- 048:2222222222222222222222222222222228222222222222112222211322222111
-- 049:2222222222222222222222222222222222222222111111113333333311111111
-- 050:2222222222222222222223322233233222332332111113313333133111111331
-- 051:2222222222222222222222222222222222222222112222223112222211122222
-- 052:0000034700000740000037000000000400037400000007043740000037004447
-- 053:7003000040047000040073000000000004300000700000000000000030000000
-- 054:85e88bee888bbb8885b55be85b8985beb884888b888498888884488888444988
-- 055:000003a7000007a0000037000000000a00037a000000070a37a000003700aaa7
-- 056:70030000a00a70000a007300000000000a300000700000000000000030000000
-- 057:8888888a888888aa88888aaa8888aaaa888aaaaa88aaaaaa8aaaaaaaaaaaaaaa
-- 058:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 059:a8888888aa888888aaa88888aaaa8888aaaaa888aaaaaa88aaaaaaa8aaaaaaaa
-- 060:8888888f888888ff88888fff8888ffff888affff88faaaff8fffaaaafaaaaaaa
-- 061:f8888888ff888888fff88888ffff8888ffffa888fffafa88afaaaaf8aaafaaaa
-- 062:0000000400000004000000040000000400000004000000040000000400000004
-- 063:4110000041100000411000004110000041100000411000004110000041100000
-- 064:2222111122221111222111112021111102111111201111110066116622006633
-- 065:1111111111111111111111111111111111111111111111111166116666336633
-- 066:1111133111111111111111111111111111111111111111111166116666316631
-- 067:1111222211112222111112221111102011111102111111201166112266316600
-- 068:0000000003404404000000000000374400000374000370000003744000000000
-- 069:4730000040000000000000000000000004473000040000000004473047073000
-- 070:55555555555555b55e5555555555555555555555555555555b55555555555555
-- 071:0000000003a0aa0a00000000000037aa0000037a0003700000037aa000000000
-- 072:a7300000a000000000000000000000000aa730000a000000000aa730a7073000
-- 073:1111111111111111111111111111111111111111111111111111111111111111
-- 079:4444444411111111111111110000000000000000000000000000000000000000
-- 080:000013310000133100001331000013340000137400001777000014440000177a
-- 081:1131113391319133e434e477e474e477447444777a7aaaa7444464447af9ffff
-- 082:3311131133191319774e434e774e474e7744a744a7aaaa7744444644faff9ffa
-- 083:13310000133100001331000043310000473100007771441144410441a7710441
-- 084:3323232333333333333773337371173733799733337ee733337ee73333777733
-- 085:2222222222222222222222222222222222222222222222222223322222333322
-- 086:44444444444444944e4444444444444444444444444444444944444444444644
-- 087:1111111111111141151111111111111111111111111111111411111111111511
-- 096:00001777000047740000477400004774000047a4000047770000477700004777
-- 097:affe9faf44efe44414f4f499e4f4f44444f4f4997afff499a7aaf4447777a499
-- 098:ffffe9ff444efe44994f4f41444f4f4e994f4f44994fff7a444ffa77994a77a7
-- 099:a77104414774000047740000477400004a740000a77400007774000077740000
-- 100:33333333337333373333333333333777333737733377a777377aaa3a37aaa6aa
-- 101:233773323371173337133173713003177130031777133177aa7117a677aaaaaa
-- 102:233773323371173337133173713003177130031777133177aa7117a677aaaaaa
-- 103:333333333333373333333033777333333773733377aa7733aaaaa7336a7aa773
-- 112:0000000000330033003300030000000003303330033030000030003700000003
-- 113:00000000700aa000700aa0aa00000000077700aa0077a000700000aa70000077
-- 114:00000000000aa0000aa000a700aa0a70a00a070000000000a707770777000300
-- 115:0000000007300000073033300000033073300000333033003000000300333000
-- 116:37a7aa691111149e37aaaaef377aaaa4377a77a4373a7aaa3777aaa73777a7aa
-- 117:aaaa77aa44444444eaa7a444aaaa4999aa7a4444aaaa49997aaa4444aa7a4999
-- 118:aaaa77aa444444494447aaae9994aaaa4444aaaa9994a7aa4444aaa79994aaaa
-- 119:9a77a773e4441111feaaaa734a7aa7734aa7a333a7aa77737aa77373aaa7aa73
-- 128:8888888888888888888888888888888888888888888888888888888888888888
-- 129:88888888888888848888888488888884888888849999999994444444944e4449
-- 130:88888888b8b88888bb8b888888888888888888889eeeeeee4444444ee444e44e
-- 131:8888888888888888888888888888888888888888888888888888888888888888
-- 132:eeeeeeeee99eeeeeeeeffeeeeeeeee66eeeeeeeeffeeeeefeeee999eeeeeeeee
-- 133:888888888888888888888888888888888d88888ddb8d8d8bbbb5b5bbb5bb5bb5
-- 134:55555555555555d55d555525525555555555555555555d555d55525552555555
-- 144:8888888888ee8ee8889e89e88899899899999999444444444944494449441944
-- 145:9491e49194919491949994999444444499999999444414944444149114941491
-- 146:1e491e4e1949194e994999494444444999999999441444444414644149444941
-- 147:888888888ee8ee8889e89e888998998899999999444444444144414941494149
-- 148:8888888888888bb885555bbb555555bb55555555555555555555555544555555
-- 149:8888888888888888bbbeeee8bbbbbbbebbbbbbbb5bbbbbbb555bbbbb55555944
-- 150:3f7f7ff8377377f8337377f8377377f83777aaf533377ff7a3777f55a3737f77
-- 151:888888888888888888888888f8f8f8f855555555777777777777777777977557
-- 152:888888888888888888888888f8f8f8f855555555777777775577577577777977
-- 153:8f7f7fff8377777f8377377ff377a73f7377777f733377ff57377af7773737f7
-- 154:888888888888888888888888f8f8f8f855555555777777777777475775743477
-- 160:4949194944491949414919499149494494491944994419444944144444444444
-- 161:16e944444efe4444443444554434453091445030914450309444503044445030
-- 162:49449e914444efe15b44434430b44344303b4494303b4494303b4494303b4444
-- 163:9449414994494444914949149149491491494914414449144444494444444444
-- 164:4949555549494911494949114919491149144941441444414414444444444444
-- 165:5555594454491944144911441111194411114444111491491114914911149449
-- 166:a373af77a3577f7753555f775311555513115555131111551311111173777777
-- 167:76e977777efe7755754575545555543071414030111540301111403017777777
-- 168:77779e975577efe74555a4773045545530341411303411113034177177777777
-- 169:773737f7773777f777337af75737711711511515113155111131111177377777
-- 170:7774347777743477777444777777777555171151111111517755117177777777
-- 176:888888888888888888888888888888888877f88888377f88a3777f88a373cf88
-- 177:888888888888888888888888888888888888888888888888888883ff8833377a
-- 178:88888888888888888888888888888888888888888888888888888888ffaff888
-- 179:88888888888888888888888888888888888888888888888888887af8888737fa
-- 180:888888888888888888888888f8f8f8f822222222333888edd3888e88d3838edd
-- 181:888888888888888888888888f8f8f8f8222fffffddddffffdddddddfdd9dd88d
-- 182:888888888888888888888888f8f8f8f822222222dddddddd88dd6dd8ddddd9dd
-- 183:888888888888888888888888f8f8f8f822222222d333888e8d388aeddd3838ed
-- 184:888888888888888888888888f8f8f8f822222222ddddddddddddddddddddd88d
-- 192:a373af88a3777f83a3773f33a3777faaa3777faca333a7aaa37ccccc7ccccccc
-- 193:83aaaaac3ccaaaaaaaaa7a44aaaaa4307cca4030aaaa4030c7aa4030c7777777
-- 194:aaacc888aaaaaf8844aaac88304aaac83034aaa83034aaa83034a77877777ccc
-- 195:883737fa883777fa88337afa8837777a8837777a883c337accc7777accc77077
-- 196:d383aeddd3888eddd3883eddd3888eddd3888ed8d333aeddd3888edd838888e8
-- 197:d6e9dddddefedddddd4ddd44dd4dd4308d4d4030dddd4030fffd4030fff88888
-- 198:dddd9e9dddddefed44ddd4dd304dd4dd3034d4dd3034dddd3034ffff88ffffff
-- 199:dd3838eddd3888eddd338aeddd3888eddd3888eddd3833eddd3888ed8838888e
-- 200:dddddddddd8dddddddddddddddddd88d8ddddddddddddddd88dddddd88888888
-- 204:3f0f0f0f3777777f3773377f3731137f3731137f3731137f3733337f3777777f
-- 208:333333313333333133333331333333313333333333333333a3333333a3777f73
-- 209:1111111111111111111111113131313133333333333333333333333373737373
-- 210:1111111111111111111111111313131333333333333333333333333337373737
-- 211:1333333313333333133333331333333333333333333333333333333737f77737
-- 212:1111111111111111111111113131313133333333333333337333433377743477
-- 220:37777aaf3777777733373777337aa77737777777377773373377773733773737
-- 221:7777777777311377731111377111111771111117731111377731137773777777
-- 222:7777777f77aaa77f777ff77f7377777f7777aaaf7377777f7777737f7377777f
-- 224:a3777f77a3aa7faac3cc3facc3cccfccc3cccfcc6999666699ee9999eeeeeeee
-- 225:77777444aaaa4030acac4030cccc4030c66c40306996666699e99999eeeeeeee
-- 226:444777770304aaaa0304caca0304cccc0304c66c6666699699999e99eeeeeeee
-- 227:77f77737aaf7aa3acaf3cc3cccfccc3cccfccc3c666699969999ee99eeeeeeee
-- 228:77743477aaa434aaaaa444aacccaaccccccccccc66996699999e99eeeeeeeeee
-- 229:111111111111111111111111111111111111111166996699999e99eeeeeeeeee
-- 236:3777773337733777377aa73733377777373773a7377777773733777a33a37777
-- 237:337aa7777777777777337777774444777499994774999947a4999947f4999947
-- 238:337aa77f7777777f7733777f777ff77f7aa7777f773f777fa777777fff77aa7f
-- </TILES5>

-- <TILES6>
-- 001:55555b555555bbb55555bbb55555bbb555b55b555bbb54555bbb545555455455
-- 002:1114431311131111331114413441334311111111114314441444111411111111
-- 003:3733333373334a333333773333333333a3377a3333373333333333437433373a
-- 004:ceccccccc4c4cccec4c4cccccc44c4cccc4ccc4ccc4ccc4cc44cc4ccc4cec4cc
-- 005:2828282882828282222222222222222282828282282828282222222222222222
-- 006:15111115514b11b11b1115b111b11b1111b1b1511511141111b11b1114111115
-- 007:fffffaffffffaaafffffaaafffffaaafffaffafffaaaf3fffaaaf3ffff3ff3ff
-- 008:44444e444444eee44444eee44444eee444e44e444eee47444eee474444744744
-- 009:696e696e96e696e6666666666666666696e6e69669696e696666666666666666
-- 224:0000000000000000000000000770000000070077000707770000777700000777
-- 225:0000000000000000000000000000077077007000777070007777000077700000
-- 240:000777f7077003f7000033f30000333300033333033003330000303300000000
-- 241:7f7770007f3007703f3300003333000033333000333003303303000000000000
-- </TILES6>

-- <TILES7>
-- 248:0000000000e00000000e0000eeeee000111e100000e100000010000000000000
-- </TILES7>

-- <SPRITES>
-- 001:000000000000000000f00000000f00000000f040000004000000404000000000
-- 002:000000000f00000000f00000000f00000000f440000044000000404000000000
-- 003:0000000000373000007f70000037300000040000000400000004000000000000
-- 004:0000000000040000000400000004000000040000000400000004000000000000
-- 005:000000000000000000f00000000f700000077000000007000000000000000000
-- 006:00f0000000af4f0000aa4a0000a0400000004000000040000000400000000000
-- 007:0000000004400000003400000030400000304000003400000440000000000000
-- 008:0444000000304000003004000030090000300400003040000444000000000000
-- 009:0009000000444000040404009004009093343390000400000004000000000000
-- 010:000000000ff0000000ff0000000ff0000000f440000044000000404000000000
-- 012:000000000fa0000000fa0000000fa0900000f900000099000009009000000000
-- 013:0f000000faaa9aa0faaa9a70faaa97000f009000000090000000900000009000
-- 014:00000000fff9fff0aaa9aaa07aa9aa7000090000000900000009000000090000
-- 016:0000000000404000044444004044404000444000001110000044400000000000
-- 017:0040400004444400444444404044404000444000001e10000044400000000000
-- 018:0040400004444400477777407077707000444000001e10000044400000000000
-- 019:007070000747470043747340304740300074700000afa0000074700000000000
-- 020:0070700007a7a700aa777aa0a0aaa0a00077700000afa000007a700000000000
-- 021:00f0f000077f770077a7a770707a707000a7a00000fff00000a7a00000000000
-- 022:00f0f0000f7f7f00f7ada7f070dad07000ada00000fff00000dad00000000000
-- 023:00a0a000aafffaa0afffffa0f0fff0f000fff00000aea00000fff00000000000
-- 024:000000000044400004444400044a440004444400004440000000000000000000
-- 025:000000000077700007777700077f770007777700007770000000000000000000
-- 026:0000000000aaa0000aaaaa000aafaa000aaaaa0000aaa0000000000000000000
-- 027:000000000fffff000ffaff000aaaaa000ffaff000fffff0000fff00000000000
-- 028:00000000000000000440044004400440044004400e300e304440444000000000
-- 029:00000000000000000330033007700770077007700f300f307770777000000000
-- 030:0000000000000000033003300aa00aa00aa00aa00f300f30aaa0aaa000000000
-- 031:00000000000000000aa00aa00ff00ff00ff00ff00e300e30fff0fff000000000
-- 032:00aaaf000a0000f00a0000f00a0000f000a00f000006c0000006600000000000
-- 033:000000000080800008888800808880808088808080eee0800088800000888000
-- 034:00aaaf000a0000f00a0000f00a0000f000a00f000008d0000008800000000000
-- 035:00000000000000000005b00000a55f0000a00f00000af0000000000000000000
-- 036:0000000000d0d0000ddddd00d0ddd0d080ddd08080eee08000ddd00000ddd000
-- 037:00000000000000000888d00000888d00088888d0000000000000000000000000
-- 038:00000000000000000008d00000a88f0000a00f00000af0000000000000000000
-- 039:0000000000000000000be000005bbe0000500e000005e0000000000000000000
-- 040:00000000000000000004600000a44f0000a00f00000af0000000000000000000
-- 041:00000000000000000002800000a22f0000a00f00000af0000000000000000000
-- 042:00000000000000000002800000a82f0000a00f00000af0000000000000000000
-- 043:00000000000000000008800000a82f0000a00f00000af0000000000000000000
-- 044:0000000000044000004444000494444004944440040000400000000000000000
-- 045:000000000007f00000777f0007a777f007a77770070000700000000000000000
-- 046:00000000000ad00000aaad000afaaad00afaaaa00a0000a00a0000a000000000
-- 047:00000000000fa00000fffa000fafffa00faffff00f0000f00f0000f000000000
-- 048:00aaaf000a0000f00a0000f00a0000f000a00f00000eb000000ee00000000000
-- 064:000006000000ee000000ef600000400000040000004000000400000000000000
-- 065:0044400000040000000400000004000000aaf00000aaf000000f000000000000
-- 096:00005b00000050000046660004666e60046666e0046666600046660000000000
-- 097:014a4900144a4490144a44907aaaaaf0144a4490144a4490014a490000000000
-- 098:000055b00002bb00002bbb0002bbbeb002bbbbe002bbbbb0002bbb0000000000
-- 099:00000000008d00000028000000008d0008d0280002800000000008d000000280
-- 144:07777a000070a0000076a000076e6a007666e6a0766666a00377aa0000000000
-- 145:07777a000070a000007ba00007beba007bbbeba07bbbbba00377aa0000000000
-- 146:07777a000070a0000070a000070d0a007000d0a0700000a00377aa0000000000
-- 147:07777a000070a0000074a000074f4a007444f4a0744444a00377aa0000000000
-- 148:04444600004060000040600004b5b6004b5b5b6045b5b5600344660000000000
-- 149:0444460000406000004060000481860048181860418181600344660000000000
-- 150:07777a000070a0000079a00007969a007eeeeea07efffea00377aa0000000000
-- 151:07777a000070a0000075a000075b5a007555b5a0755555a00377aa0000000000
-- 152:044446000040600000406000048f860048f8f8604f8f8f600344660000000000
-- 160:000000000660000000700000000700000000700000000f00000000f000000000
-- 161:000000000ee0000000700000000700000000700000000f00000000f000000000
-- 162:000000000550000000700000000700000000700000000f00000000f000000000
-- 163:000000000dd0000000700000000700000000700000000f00000000f000000000
-- 164:6666666666666666666666666666666666666666666666666666666666666666
-- 165:000000000ff0000000700000000700000000700000000f00000000f000000000
-- 166:000000000bb0000000700000000700000000700000000f00000000f000000000
-- 167:000000000880000000700000000700000000700000000f00000000f000000000
-- 168:000000000990000009700000000700000000700000000e00000000e000000000
-- 169:000000000dd000000d700000000700000000700000000e00000000e000000000
-- 170:000000000ee000000e700000000700000000700000000e00000000e000000000
-- 171:000000000ff000000f700000000700000000700000000e00000000e000000000
-- 172:000000000aa000000a700000000700000000700000000e00000000e000000000
-- 173:000000000770000007300000000a00000000300000000e00000000e000000000
-- 174:000000000880000008f00000000700000000700000000e00000000e000000000
-- 176:faaaaaaf0444444004466400044444400044444004444440faaaaaaf00000000
-- 177:faaaaaaf04444440044ee400044444400044444004444440faaaaaaf00000000
-- 178:faaaaaaf0444444004455400044444400044444004444440faaaaaaf00000000
-- 179:faaaaaaf04444440044dd400044444400044444004444440faaaaaaf00000000
-- 180:6666666666666666666666666666666666666666666666666666666666666666
-- 181:faaaaaaf04444440044ff400044444400044444004444440faaaaaaf00000000
-- 182:faaaaaaf04444440044bb400044444400044444004444440faaaaaaf00000000
-- 183:faaaaaaf0444444004488400044444400044444004444440faaaaaaf00000000
-- 184:faaaaaaf0444444004499400044934400044444004444440faaaaaaf00000000
-- 185:faaaaaaf04444440044dd400044d34400044444004444440faaaaaaf00000000
-- 186:faaaaaaf04444440044ee400044e34400044444004444440faaaaaaf00000000
-- 187:faaaaaaf04444440044ff400044f34400044444004444440faaaaaaf00000000
-- 188:faaaaaaf04444440044aa400044a74400044444004444440faaaaaaf00000000
-- 189:faaaaaaf0444444004477400044734400044444004444440faaaaaaf00000000
-- 190:faaaaaaf04444440044884000448f4400044444004444440faaaaaaf00000000
-- 192:00a0a000aae9eaa0a99e99a09099909000eee00000aea0000099900000000000
-- 193:000e00e00e60900000e60000000e60900000e900000099000009009000000000
-- 194:00000000000000000009600000e99e0000e00e00000ee0000000000000000000
-- 195:0000000000000000909090f04999eef0449eeff0000000000000000000000000
-- 196:000e000000eee0000b0a0b00a00b00a0a55455a0000b0000000b000000000000
-- 197:6666666666666666666666666666666666666666666666666666666666666666
-- 198:6666666666666666666666666666666666666666666666666666666666666666
-- 199:6666666666666666666666666666666666666666666666666666666666666666
-- 208:000000000bbbbb50055555200bf6fb500befeb5005f8f5200bbbbb5000000000
-- 209:000003000000700000000e000000500000050000405000040444444000000000
-- 210:0000000000eeeee0040fffff000eeeee00099999040494940044444000000000
-- 211:000000000000000000000000144ee0001444eff01444e0ff1444e00000000000
-- 212:faaaaaaf04444440044f4400044ff440004ff44004999940faaaaaaf00000000
-- 213:0000000000000a00a00000a00affaffa007f07f0000000000000000000000000
-- 214:00000000094444c009444770094444c0094444c009444770094444c000000000
-- 235:0777770000707000007370000733370073333370733333700777770000000000
-- 236:aaaaaaaa0777777007777700077777700077777007777770aaaaaaaa00000000
-- 237:0077770007000070070000700700007000700700000aa000000aa00000000000
-- 238:0000000007700000037000000007000000007000000007000000007000000000
-- 239:00000000000000000007700000a77f0000a00f00000af0000000000000000000
-- 240:011111001669ff10666666f116666f1001669100001610000001000000000000
-- 241:055555005bbeff50bbbbbbf55bbbbf5005bbe500005b50000005000000000000
-- 242:022222002ddeff20ddddddf22ddddf2002dde200002d20000002000000000000
-- 243:044444004eefff40eeeeeef44eeeef4004eef400004e40000004000000000000
-- 244:00fff00000a7f00000a77f000a777a000aaaaa00000000000033300000000000
-- 245:faaaaaaf0422224004bb720004bb7740002bbb4004222240faaaaaaf00000000
-- 246:000000000aaaff0000a0f0000a777f000a111f000a111f000aaaaa0000000000
-- 247:00000000000000d000000b0dbbbbbb0df5f55b0bf0000b0b000000b000000000
-- 248:000000000dd0dd0000ddd00000d8d0000d888d00028882000222220000000000
-- 249:00000000000e00000099e00009090e004499eee004090e000049900000090000
-- 253:0b0000000050000006fb5000066005b500000b0000006f000000660000000000
-- 254:faaaaaaf0444444004444400044444400044444004444440faaaaaaf00000000
-- 255:0000be000be0bbe0bbbe0bb00bb05500000005e000005bbe0055000000000000
-- </SPRITES>

-- <SPRITES1>
-- 000:3000000000000003000300000030000003000003000003000000303000300000
-- 001:0003000003000300300000300000000000000300300030030000000000300003
-- 002:3333333337773337337a37773333333337733a7333333773333333333337a333
-- 003:33333333a337a7337377333333333373334733733377a333333333333a337773
-- 004:3331111177103030313777775170303031303030313030307130303031303030
-- 005:1111137730303133777770133030371730303013303030173030301330303013
-- 006:0001000000001100000001100000010100000001000000011110000100010110
-- 007:0001000000100000010000001010000010011000000001001000001100000000
-- 008:1133311111114111134331341114314311111111113113443341114334413111
-- 009:4433143111111133113431113111331111111111111133311113341113111111
-- 010:1111111111133333113000001300000013000011130000001300011113000000
-- 011:1111111133333111000003110000003111000031000000311110003100000031
-- 012:1111111111133333113000001300000013000000130000001300000013000000
-- 013:1111111133333111000003110000003100000031000000310000003100000031
-- 014:0000000000000000000000000000000000000000000000000000033300000033
-- 015:00000000000000000000000000000000000000000000000033a000003a000000
-- 016:0000000000300000030000030000000030000030000003000000000000030000
-- 017:3000000000303000000300000000000000003000000300000030003000000000
-- 018:3773333377a3337733333a773333333333373377337343373337a33333777333
-- 019:3733333373334a333333773333333333a3377a3333373333333333437433373a
-- 020:31303030713030303130303051a7a7a73130303071a7a7a73130303031303030
-- 021:303030133030301730303017a7a7a71730303013a7a7a7173030301330303013
-- 022:0001000000000000001000000000000110100010000110000000110000000100
-- 023:0010000001100001100001000010100000010000000010000001100000100100
-- 024:1114431311131111331114413441334311111111114314441444111411111111
-- 025:3411433111111131134141111134431111111141414431114134441111111111
-- 026:1300111113000000130111111301111113000000131111111311111113111111
-- 027:1111003100000031111110311111103100000031111111311111113111111131
-- 028:1300000013000000130000001300000013001111130111111311111113111111
-- 029:0000003100000031000000310000003111110031111110311111113111111131
-- 030:001111aa001a33310013333300133133001331330013113700113a7300133313
-- 031:aaffff003333af0033333f00a3333f0033a33f0073333f003133af0077313a00
-- 032:22222222222222d22d22282d2222222222222222222222222222222222222222
-- 033:222222222222d28222282d2222222222222222222d22222282d2222222222222
-- 034:2222222222222222222d28222282d2d222222222222222222222222222222d22
-- 035:22222222222222222222d22222282d222222222222222222222222222222d222
-- 036:333a333a03a003a001a003a001a001a003a001a003a003a0034003a003a00340
-- 037:333a334303a003a003a001a0034003a003a003a003a0034001a003a003a003a0
-- 038:333a333a04a003a003a004a0333a333a00000000000000000000000000000000
-- 039:333a333404a003a003a004a0333a333300000000000000000000000000000000
-- 040:0000000000000000000000000000000000490000000490000000490000000490
-- 043:0000000000000000000000000000000000003700000370000037000003700000
-- 044:000000000000000000000006000000000000000e0000000f0000044400000044
-- 045:000000000000000000000000e0000000f0000000600000004490000049000000
-- 046:0000000e0000000000000000000000000000000e0000000f0000044400000044
-- 047:00000000000000000000000060000000e0000000f00000004490000049000000
-- 048:222222222222d22222282d22222222222222222222222222222222d222222222
-- 049:22222222222222222222222222222222222222222222d22222282d2222222222
-- 050:222282d2222222222222222222222222222d22222282d2222222222222222222
-- 051:2222222222222222222222222222d22222282d22d22222222222222222222222
-- 052:034003a003a003a001a0034003a003a003a003a003a003a0433a333a333a343a
-- 053:01a003a001a001a003a00140034001a003a003a003a003a0343a343a333a333a
-- 056:0000004900000004000333330001373300013a33000133330001133300031137
-- 057:000000009000000033aaa0003333a000a33770003373a00033a3a0003333a000
-- 058:0000000000000003000333330001373300013a33000133330001133300031137
-- 059:370000007000000033aaa0003333a000a33770003373a00033a3a0003333a000
-- 060:001111aa001a33310013333300133133001331330013113700113a7300133313
-- 061:aaffff003333af0033333f00a3333f0033a33f0073333f003133af0077313a00
-- 062:001111aa001a33310013333300133133001331330013113700113a7300133313
-- 063:aaffff003333af0033333f00a3333f0033a33f0073333f003133af0077313a00
-- 064:0000377a00003377000007370000003300000037000000330000003700000077
-- 065:77af000037af00007af000007f0000007a0000007a0000007a00000077000000
-- 066:0000000000000000004996000499996003777730049ee9600499996004999960
-- 067:0000000000033000003000000300000003777730073ee3700733337007333370
-- 068:4341344143413341534133415341434143114341333113514311434143114441
-- 069:4341334143113341435133414351144143511441434114414341444143411441
-- 070:333333333777333a33733aa7333aa77337a7700033a3030333a0003033a30300
-- 071:33333333a33737337aa73333077aa37330377a7300030a3330303a3303000a73
-- 072:3333333337773337337a111133314144371341443315413533e5113533e31135
-- 073:33333333a337a733111133331441137313414173134131331341513313115173
-- 074:3333333337773337337a111133310000371400003314000033e4000033e40000
-- 075:33333333a337a733111133330000137300000173000001330000013300000173
-- 076:3333333337773337337a11113331414437134144331aaaaa33f3333333faaaaa
-- 077:33333333a337a733111133331441137313414173aaaaa13333333133aaaaa173
-- 078:13331113496e5c56396e5c56396e5c5633311113450240e035924ce945924ce9
-- 079:33311133024c0623524ce624524ce623331113332ce550642ce552632ce55263
-- 080:000000330000003a0000003700000033000000730000033700003a7700003777
-- 081:7a0000007a0000007a0000007a0000007f0000007af00000a7af0000377a0000
-- 084:4431444134311341343133413431534134315141343153413431433134414331
-- 085:4341134133413341434135314341351133413531334133313341343133413431
-- 086:37a0303077a3000333aaaaaa3377777733373377337343373337a33333777333
-- 087:30303a3300030a33aaaaaa3377777733a3377a3333373333333333437433373a
-- 088:3714413377145143331451433314514433e3441433e341453313414533144144
-- 089:1311513314ee313314ee3133143131331331513313415133313411433141413a
-- 090:3714000077140000331400003314000033e4000033e400003314000033140000
-- 091:000001330000013300000133000001330000013300000133000001430000013a
-- 092:3714413377145143331451433314514433faaaaa33f33333331aaaaa33144144
-- 093:1311513314ff313314ff313314313133aaaaa13333333133aaaaa1433141413a
-- 094:1133311142c06e0c42c46e5c32c46e5c133333114e2905603e2925694e292569
-- 095:113333335440c0235442ce235442ce2411331111e5022c94e5c22c94e5c22c93
-- 096:000000000000000000114999001377970014cc4c0013374700144c4c00114449
-- 097:000006000000000069900e6067900f006c900fe0679007f0cc90077099900770
-- 098:0000000000000000001144990013334700144c4c001333470014444c00114444
-- 099:00000060000000006990060067900e006c900f60679007f0cc90077099900770
-- 100:0000000000000000000000000000000d000000020000020d0000000200002002
-- 101:0000000000000000ddaf000000af000000af000000af000000af000000af0000
-- 102:0000000000000000000000000000000000000002000000020000000d0000020d
-- 103:00000000000000000daf000020af000000af000000af000000af00000daf0000
-- 104:4441444177417741111111113331711143444144417741771171111311111333
-- 105:4447444177437741113331111111117141444144417741773111133111171131
-- 106:444966667749666611196666333966664349666e4179666e1179666611196666
-- 107:6666e4416666e7416666e1116666e171e666e144e666e1776666e3316666e131
-- 108:0000000000000000000000000000000000000006000000000000000e0003000f
-- 109:0000000000000000000000000000000000000000e0000000f00000006000f000
-- 110:0000000000000000000000000000000e00000000000000000000000e0003000f
-- 111:000000000000000000000000000000000000000060000000e0000000f000f000
-- 112:111111aa133a3331133333331333313301333333013313370013317300133113
-- 113:afffffff3333777f3333373fa333377f33a377f0733737703170770073373700
-- 114:111111aa133a3331133333331333313301333333013313370013317300133113
-- 115:aaafffff3333777f3333373aa333377a33a377a0733737703170770073373700
-- 116:001111aa001a33310013333300133133001331330013113700113a7300133313
-- 117:aaffff003333af0033333f00a3333f0033a33f0073333f003133af0077313a00
-- 118:001111aa001a33310013333300133133001331330013113700113a7300133313
-- 119:aaffff003333af0033333f00a3333f0033a33f0073333f003133af0077313a00
-- 120:4441444377417741111111113331111173444144737741771711331111111111
-- 121:4441444177417741111111117111111141444144417743771111333111111111
-- 122:4449666677496666111966663339696973499194737941771711331111111111
-- 123:6666e4416666e7416666e111e6e6e1114e4ee1444177e3771111333111111111
-- 124:0000377a000003a700000007000000090000000a000000090000000300000003
-- 125:a7af0000fff00000f000000060000000f000000060000000f0000000f0000000
-- 126:0000377a000003a700000007000000090000000a000000090000000300000003
-- 127:a7af0000fff00000f000000060000000f000000060000000f0000000f0000000
-- 128:4441444177417aaa111aa07333a7000743a7303741a0737011a0070011a03730
-- 129:44474441aaa37741707aa11100073a7130373a4473707a7707000a3137303a31
-- 130:444144417741779e111119373331930743497307419373071193730711f37307
-- 131:44474441ee43774133e33111037e11710373e14403733e7703730e3133730e31
-- 132:1111114017371111137a777317a7111111711111117114110131111111a11001
-- 133:1111111111117a717a7777711111a73110111711114117101110131111111a11
-- 134:33ccc333333343333c4cc3c43334c34c3333333333c33c44cc43334cc4433333
-- 135:44cc34cc333333cc33c4c333c333cc33333333333333ccc3333cc4333c333333
-- 136:33ccc333333343333caccccc33ac44c433acc4cc33acccccccac4c44c4acccc4
-- 137:44cc34cc333333ccccccca33c4c4ca33ccc4ca33cccccac3c4c4ca33c4ccca33
-- 138:0003000000004400000004400000040400000003000000033330000300040330
-- 139:0003000000300000040000003030000040044000000003004000004400000000
-- 140:333333333337777733700000370000003700004c37000000370004cc37000000
-- 141:33333333777773330000073300000073c400007300000073cc40007300000073
-- 142:3333333333377777337000003700000037000000370000003700000037000000
-- 143:3333333377777333000007330000007300000073000000730000007300000073
-- 144:44a3707377a7000711aaaaaa3333333373444144737741771711331111111111
-- 145:70737a4100073a41aaaaaa113333331141444144417743771111333111111111
-- 146:44f3733777907307119070373393730773f3730773f373071793700711937337
-- 147:33733e4137ff3e41337f3e1130733e1133730e4433730e7730730e3133733e11
-- 148:1471111111a110111171111111711111173714111a7a7773173a111101111101
-- 149:1111170101111711111113111411171111117771773773711111a73111111114
-- 150:33344c3c333c3333cc333443c443cc4333333333334c34443444333433333333
-- 151:c4334cc3333333c33c43433333c44c33333333434344c33343c4443333333333
-- 152:33accccc33ac4cc4ccac44c4c4accccc33ac4c4433accccc3444333433333333
-- 153:cccccac34cc4cac3cc4cca33ccccca334c4cca43ccccca3343c4443333333333
-- 154:0004000000000000003000000000000330300030000430000000430000000400
-- 155:0040000004300003300003000030300000030000000040000004400000300300
-- 156:37004ccc3700000037044ccc3704c44437000000374ccccc374c4444374cccc4
-- 157:444c00730000007344c440734c4cc07300000073c4444473cc4cc47344c44473
-- 158:370000003700000037000000370000003700444c37044c44374444c4374c4444
-- 159:00000073000000730000007300000073cccc007344444073ccc444734cc44473
-- 160:33ccc333333343333c4cc3443334c4003333400033c40000cc400000c4400000
-- 161:44cc34cc333333cc44c4c3330043cc330004333300004cc30000043300000433
-- 162:00000000000000000000000000000000000000000a00000007a000000a9a7f7f
-- 163:00000000000000000000000000000000000000000000ff0000ffeef0ffeeeef0
-- 164:00000000000066690066cccc006c6666006c6666006c6666006c66660efff666
-- 165:0000000099990000cccc99006666c9006666c9006666c9006666c900666eeff0
-- 166:0000000000000000001177770013334300144444001333430014444400117777
-- 167:0000000000000000677000006370000064700a00637007a04470077077700770
-- 176:3340000033400000cc344444c443cc4333333333334c34443444333433333333
-- 177:000004c3000004c34444433333c44c33333333434344c33343c4443333333333
-- 178:0a9999990aa7aa7f077373a70a9999990a79b979074444440a773a7a0a737777
-- 179:eeeeeef0afafaff0737737f0999999f039b979a0444444f0a77377a037a737f0
-- 180:0e44f6660e44e6660eeee66600ee111100ee444400eee4e400ee4e4e00ee4444
-- 181:666e44f0666e44e0666eeee01111ee004444ee00e4e4ee004e4eee004444ee00
-- 182:111111aa133a3331133333331333313301333333013313370013317300133113
-- 183:aaafffff3333777f3333373aa333377a33a377a0733737703170770073373700
-- </SPRITES1>

-- <SPRITES2>
-- 000:3000000000000003000300000030000003000003000003000000303000300000
-- 001:0003000003000300300000300000000000000300300030030000000000300003
-- 002:aaa3aaa377a377a33333333355537333a5aaa3aaa377a3773373333533333555
-- 003:aaa7aaa377a577a33355533333333373a3aaa3aaa377a3775333355333373353
-- 004:aaa3aaa377a311113331944955149499a5149491a3e4149933e4449933141499
-- 005:aaa7aaa3111177a34494133314944173449441aa441441774414415314144153
-- 006:9491499194914491949144919491949194119491444114919411949194119991
-- 007:9491449194114491949144919491199194911991949119919491999194911991
-- 008:4441111199144444414777779140303041403030414030309140303041403030
-- 009:1eeee44444444e44777774e4303034e9303034e9303034e9303034e4303034e4
-- 010:949449949494433394443311944313449431434444e1434494e1444494314344
-- 011:949444943ee44494344e44943443e49434434e9434444e9434434e9434434e94
-- 012:3331111177103030313777775170303031303030313030307130303031303030
-- 013:1111137730303133777770133030371730303013303030173030301330303013
-- 014:33aa5777a3a3333377300000a300000033000000730000005300000033000000
-- 015:77aa3aa333333a5a00000377000000330000003a000000370000003300000035
-- 016:0000000000300000030000030000000030000030000003000000000000030000
-- 017:3000000000303000000300000000000000003000000300000030003000000000
-- 018:aaa3aaa577a377a33333333355533333a5aaa3aa7377a3773733553333333333
-- 019:aaa3aaa377a377a33333333373333333a3aaa3aaa377a5773333555333333333
-- 020:aa141499771414193314191955144919a5e4944973e494493714944933149449
-- 021:14ee41a344ee41a31491413314914133119141aa419441774414415344144133
-- 022:9941999149411491494144914941949149419191494194914941944149919441
-- 023:9491149144914491949144419491441144914441449144414491494144914941
-- 024:4140303091403030414030309147a7a7414030309147a7a74140303041403030
-- 025:303034e4303034e9303034e9a7a7a4e9303034e3a7a7a4e9303034e4303034e4
-- 026:9931434449314344493143444931444349e1434349e143444931434449314344
-- 027:34434e9434ee4e9434ee4e4444434e4444434e4434444e4434434e4434434e44
-- 028:31303030713030303130303051a7a7a73130303071a7a7a73130303031303030
-- 029:303030133030301730303017a7a7a71730303013a7a7a7173030301330303013
-- 030:73000000a3000000330000007300000033007331a30a773373aaa77353aaaa77
-- 031:000000370000003a0000003a000000373111003313111035313111373333113a
-- 032:5555555555e5555b55b555555555555555555555555555555e5555555555b555
-- 033:555555555555b555555555555555555e55b555555b5b555b5555e55555555555
-- 034:2222222222222222222d28222282d2d222222222222222222222222222222d22
-- 035:22222222222222222222d22222282d222222222222222222222222222222d222
-- 036:22222222222222d22d22282d2222222222222222222222222222222222222222
-- 037:222222222222d28222282d2222222222222222222d22222282d2222222222222
-- 038:00888bbb08555555858555558555b55b8555555e858555550855b5550088bbb5
-- 039:bbbbe0005e555e0055eb55e0555555e0b55b555ee555b55e5b555ee0bbbee000
-- 040:0000054400005114000511440051141405114114511411415555444405439149
-- 041:eee00000444e000044e4e000414e4e001414e4e04141444e4444eeee194944e0
-- 042:0000003a00003773000373770007777700073711000777110003711100077111
-- 043:00000000aa0000007aa0000077a000007aaa0000173aa0001a77a0001177aa00
-- 044:000006000001000000006006000006690000069e0000069e000069ef0777aacc
-- 045:00101000606000006010600096000000e9600000e9600000fe960000ccaffff0
-- 046:000000600000000000060006000001690001069e0000699f000099ef0777accc
-- 047:0000000001000000000600006000000096110600e9600000fe600000cacffff0
-- 048:55555555555555555555555555b5555555eb5555555555555555555555555b55
-- 049:5555555555555555b55555e555555555555555555e55b555555555555555555b
-- 050:222282d2222222222222222222222222222d22222282d2222222222222222222
-- 051:2222222222222222222222222222d22222282d22d22222222222222222222222
-- 052:222222222222d22222282d22222222222222222222222222222222d222222222
-- 053:22222222222222222222222222222222222222222222d22222282d2222222222
-- 054:000004bb04440414000144140000041400004141000041410004414100441414
-- 055:4444000041900000449000004149099049149000449900004441900044941900
-- 056:0594944905941111059411110594111105441111054411110549111105141111
-- 057:194444e0491114e0491114e0491114e0441114e0419994e0449914e0499949e0
-- 058:0037311100373111037731110373111107731111073111113731111173111111
-- 059:11117aa01111a7aa1111a77a1111177a1111177a111111a7111111a711111173
-- 060:0333777700373773000333770000373700000333000000370000033300003733
-- 061:777777f077377f007773a000377a000077a000007a00000073a00000777a0000
-- 062:0333777700373773000333770000373700000333000000370000033300003733
-- 063:777777f077377f007773a000377a000077a000007a00000073a00000777a0000
-- 064:1999999914444449147777491444444911119111000190000001900000000000
-- 066:00888bbb08555555858555558555b6cb8555566e858555550855b5550088bbb5
-- 067:bbbbe0005e555e0055eb55e0555555e0b55b555ee56cb55e5b665ee0bbbee000
-- 068:000037a70000037a000000370000003700000037000000370000003700000037
-- 069:a7af00007af00000af000000af000000af000000af000000af000000af000000
-- 070:000000000000000000000006000000000000000e0000000f0000044400000044
-- 071:000000000000000000000000e0000000f0000000600000004490000049000000
-- 072:0000000e0000000000000000000000000000000e0000000f0000044400000044
-- 073:00000000000000000000000060000000e0000000f00000004490000049000000
-- 074:88888888a888888873388888a333388833333338733333385333333a33333373
-- 075:888888888888888a88888337888333338333333a83333337f333333375333335
-- 076:33aa5777a3a3333377388888a388888833888888738888885388888833888888
-- 077:77aa3aa333333a5a88888377888888338888883a888888378888883388888835
-- 078:4443444444443344449443344944434344444445444454433334444344434334
-- 079:4443444445344454434444443434449434433454444943443444443354444444
-- 080:000000000000000000000000000000000000e00000bb4e000b4555e000000000
-- 081:0000000000000000000000000000000000000000000000000400343000334000
-- 082:000004bb04440414000144140000041400004141000041410004414100441414
-- 083:4444000041900000449000004149099049149000449900004441900044941900
-- 084:0000003700000037000000370000003700000037000000370000037a000037a7
-- 085:af000000af000000af000000af000000af000000af0000007af00000a7af0000
-- 086:001111aa001a33310013333300133133001331330013113700113a7300133313
-- 087:aaffff003333af0033333f00a3333f0033a33f0073333f003133af0077313a00
-- 088:001111aa001a33310013333300133133001331330013113700113a7300133313
-- 089:aaffff003333af0033333f00a3333f0033a33f0073333f003133af0077313a00
-- 090:73333aaaa3333757333373377333aaaa333aaaaaa33777777377773753773337
-- 091:fff333373373333a7737333aafff3337aafff33333377335777777377777773a
-- 092:73888888a3888888338888887388888833887aafa38377aa7333377a53333377
-- 093:888888378888883a8888883a88888837afff8833fafff835afafff37aaaaff3a
-- 094:4443444444444494453444444444444334344434444334544444334449444344
-- 095:4534444443344443344443544434344444434454444454444443544444333345
-- 096:0000000000000200000000020002000200000202000000020777aaaa03337777
-- 097:000000000d000000000d0000d0000000d000d000d0000000aaaffff0777777f0
-- 098:0000000000000000000000000000020200000002000200020777aaaa03337777
-- 099:0000000000000000d0000000d0d00000d00d0d00d0000000aaaffff0777777f0
-- 100:000000000000000a00000013000001370000137a00013733000171a3000131a3
-- 101:0000000000000000a00000003a00000033a00000a37a00007733a0007333a000
-- 102:cccccccccceccccecc7ccccccccccccccccccccccccccccccecccecccccc7ccc
-- 103:cccccccc7cccaccccccccccccccccccaccecccccceccccc7cccceccccccccccc
-- 104:0005be0000000be00000005e0000ee5500eeb5b50e55555be5b00005e5000004
-- 105:000eee0000e550005bb50000b5e50000555eee005b55b5e0b5055be04900055e
-- 108:0000000000000000000000000000000000000e00000005e000000b5000000500
-- 109:000000000000000000000000000000000000000000000000000000000005e000
-- 110:00500e0005e00e0005e02e00555055e02be02be05be055b025b02b505b50b5b0
-- 111:000000005000500050005e00e00ee5005e05b0005e02e0502e0b50e5250250e5
-- 112:0037377300033377000037370000033300000033000000370000033300003733
-- 113:77377f007773a000377a000077a000007a0000007a00000073a00000777a0000
-- 114:0037377300033377000037370000033300000033000000370000033300003733
-- 115:77377f007773a000377a000077a000007a0000007a00000073a00000777a0000
-- 116:0013333a0013773300113373001a13370117a73301333313113a37331313a331
-- 117:37373a00a3a73a00717a3a00333333a0333733a03a73373a13aa337a3733a333
-- 118:ccccccccccccccccccccccccccaccccccceacccccccccccccccccccccccccecc
-- 119:cccc7ccccccccccceccccceccccccccccccccccc7eccecccccccccccccccccce
-- 120:0000000100000001000000410000004100000041000004140000041400000414
-- 121:4900000e49000000490000004900000044900000149000001490000041490000
-- 122:0000000000000000000000e00000c00c00e0c00c000e0b0e0b0e0b0cb0cbebbc
-- 123:000000000000000000000000000e0000c0c000e0c0b00e0be0b0be0bbe0be0b0
-- 124:0000b50000000500000002000000040000001900000014000000140000004400
-- 125:000be00000050000000b00000005000000020000000100000014000000490000
-- 126:05e0040005e00902005009050040040400401901004014410140111004004140
-- 127:5b0b50555e00b02e550050209000e04041090040900104109014044040490400
-- 128:0000044400004141000414140041444404144000414400004440000044000000
-- 129:4490000041490000141490004491490000091490000091490000091900000099
-- 130:000000000000000c000000130000013700001ccc000137440001c1c4000141c4
-- 131:0000000000000000c00000004c00000044c00000c47c00007744c0007444c000
-- 132:0000000000000000000000000004400400009104000001440000009000000040
-- 133:0000000000000000400000009000000000000000000000000000400004404000
-- 134:1111111111111111111515111151515111111111113111141111114114111511
-- 135:1111111111111111131151111555151111111111111111111113141111111111
-- 136:1111111111111151111415151111411111111111111111111113111114111111
-- 137:1111111111115151131515111111111111111111151111115151131111111111
-- 138:00000ddd0000d030000d030300d035550d03d050503500505355005055050050
-- 139:ddb00000303b00000303b00055b03b00050b03b00500b03b05005b0b050050bb
-- 140:0000000000044444000440040000000400000049000000440000004400000044
-- 141:0000000044999900000009000000090090000900900004004000040040000400
-- 142:944444444464444e44e44494444e44444944446444944444464446444444e449
-- 143:444444444444e4464e49444444444446449444444949444e4444644444444444
-- 144:4000000040000000400000004000000040000000400000004000000040000000
-- 145:0000000900000009000000090000000900000009000000090000000900000009
-- 146:0014444c0014774400114474001c14470117c74401444314113c37441313c441
-- 147:37474c00c3c74c0071774c00444444c0444744c04c74473c13cc447c7733c444
-- 148:0400040000440900000049000000040000001900000014000000140000004400
-- 149:0004100000090000000100000004000000090000000100000014000000490000
-- 150:4115515511111111111111111111111111151131115551111111111411111111
-- 151:1111111111411111141111111111511111151551111111111111311141111111
-- 152:1111111411115111111515111111111111111111131111411111111111111114
-- 153:1111111141111111113114111111111111111111111151111115151111111111
-- 154:500500505005005050050050500500505bb5bb5b5dd5dd5d5005005055555555
-- 155:0500500b0500500b0500500b0500500bb5bb5bbbd5dd5ddb0500500b55555bbb
-- 156:000aa37700a11111001a11110013a773001733330011a3370013177700133a33
-- 157:37aaa40011111a001111aa00777a3a0073333a0033a3aa00777a3a0033a33a00
-- 158:44444444446449e4444494449494449444e94444444444644446444494444e44
-- 159:449444494444e444e444446444944444444444944644e444944444444494444e
-- 160:00000000000040000000e00000019e000001e90000096e000001e90000049600
-- 161:00000000049e0000049600000949000004e60000149e00001eee40001e694000
-- 162:00600e0004e00e0004e01e00444044e019e019e069e044901490196069609690
-- 163:000000004000400040004e00e00ee6004e0690004e01e0601e0940e4160140e4
-- 164:00000000005e0005007e0005007e0007005b00070033000b005b000b007e005e
-- 165:005e0000e07e05b0e07b07e0b05b07e0705b07b0003335b0005e3300007e5e00
-- 166:3331111177149494313eeeee51e4949431949494319494947194949431949494
-- 167:1111137794949133eeeee41394949e1794949413949494179494941394949413
-- 168:0000000000000000004996000499996003777730049ee9600499996004999960
-- 169:0000000000033000003000000300000003777730073ee3700733337007333370
-- 170:7f7e7e7feefeeeee99999999aaaa7777aaaa7777333333337777aaaa7777aaaa
-- 171:7e7e7f7efeeeeefe99999999aaaa7777aaaa7777333333337777aaaa7777aaaa
-- 172:0000000000000000000000000000000000000000000000000333333341111e11
-- 173:000000000000000000000000000000000000000040000000333333301111111e
-- 174:0000000000000000000000000000000000000000000000000000000003333333
-- 175:0000000000000000000000000000000000000000000000004000000033333330
-- 176:0001440000007000000070000000700000003000000070000000700000077000
-- 177:0077400000700000003000000070000000700000007000000037000000770000
-- 178:04e0070004e00701006003040070070700301301007017710170111007007170
-- 179:490940444e00901e440060107000e07071070030300107107017037070730700
-- 180:005e005e007e005e007b005b00330077005b00b0007e05e0007e05e0005e05b0
-- 181:007b7e00005b5b0000033300005b5e00007e7e00007e7b00005e5b00005b5b00
-- 182:31949494719494943194949451eeeeee3144444471eeeeee3194949431949494
-- 183:949494139494941794949417eeeeee1744444413eeeeee179494941394949413
-- 186:33333333aaaa7777aaaa7777333333337777aaaa7777aaaaefeeefeeee77ee77
-- 187:33333333aaaa7777aaaa7777333333337777aaaa7777aaaaefeeefeeee77ee77
-- 188:441111e14444991e449444410449999900444444000999990880888800000000
-- 189:111111ee99eeee9ee444499e1e9994e041ee4e0091ee10008880880000000000
-- 190:41111e11441111e14444991e4494444104499999804444440889999900000000
-- 191:1111111e111111ee99eeee9ee444499e1e9994e041ee4e0891ee188000000000
-- 192:000000000000000f000000f700000a770000a7770000a7a7000037af00003777
-- 193:00000000f00000007f00000077f00000777f00007f7f00007a7f0000777f0000
-- 194:ccc3ccc377c377c33337777744437333c4ccc3ccc377c3773373333437777744
-- 195:ccc7ccc37744ccc33344433333333373c3ccc3ccc377c3774377344333373343
-- 196:ccc3ccc377c377773337733744407337c4033a33c3037a373303733737037337
-- 197:ccc7ccc3fff4ccc3a33f4333a373f37333733fcc33733f77a3733f4333333f43
-- 198:33311111cc10303031377777417030304130303031303030c130303031303030
-- 199:111113cc30303133777770133030371c303030133030301c3030301330303014
-- 202:00000000000000000000000000d000000d500000503000005350000055500000
-- 203:00000000000000000000000000000500000003b00000053b0000030b000005bb
-- 204:00000000000000dd00000d220000d22d0000d2d20000d2d20000d2d20000d2d2
-- 205:00000000dd00000022d00000d22d00002d2d00002d2d00002d2d00002d2d0000
-- 206:0000000000000088000008220000822200008222000082280000822800008228
-- 207:0000000088000000228000002228000022280000822800008228000082280000
-- 208:000037a70000377700003777000037af0000377a000037770000337700000333
-- 209:af7a00007a7a0000777a00007a7a0000777a0000777a000077aa00003aa00000
-- 210:ccc3ccc477c377c33333333344477333c4ccc3cc7377c3773733443733333333
-- 211:ccc3ccc377c377c33377773373333333c3ccc3ccc377c4777773444333333333
-- 212:cc037337770333373303733344037a33c4037a37730333373703733733037337
-- 213:33a33fc333ff3fc333ff3f33a3733f33a37a3fcca33a3f77a3733f4333733f33
-- 214:31303030c13030303130303041a7a7a741303030c1a7a7a73130303031303030
-- 215:303030143030301c3030301ca7a7a71c30303013a7a7a71c3030301330303013
-- 216:00000000000000000000000060600000060006000b505b095b05e50b50b5b05b
-- 217:000000000000000000000000000090006060900006e0b06eeb50b5b55b0b50b5
-- 218:505000005050000050500000505000005bb000005dd000005050000055500000
-- 219:0000050b0000050b0000050b0000050b00000bbb00000ddb0000050b000005bb
-- 220:0000d2d20000d2d20000d2d20000d22d00000d22003000dd0033700000333777
-- 221:2d2d00002d2d00002d2d0000d22d000022d00000dd000f000007ff0077777f00
-- 222:0000822800008228000082220000822200000822003000880033700000333777
-- 223:822800008228000022280000222800002280000088000f000007ff0077777f00
-- 224:fffffffffffff7faffafffffffffffffffffffffffffffff7fffffffffffafff
-- 225:ffffffffffffafffffffffffffffffffffaffffffafafffaffffffffffffffff
-- 226:000000000000a0000000f0000001ff000001ff0000033f000003f30000033100
-- 227:0000000001a1000001f100000af3000001ff3000111f3000113f300011133000
-- 228:aaafaaaaaaaaa7aaa7faaaaaaaaaaaafaaa7aaaaaaaafaaa7aaaaaaaaafaaaaa
-- 229:faaaaaaaaaaaaafaaaafaaaaaaaaafaaaa7aa7aafaaaaaaaaafaaaaf7aaaafaa
-- 230:000000000000000a0000001f000001ff0000137f00013733000171f3000131ff
-- 231:0000000000000000a0000000fa000000ffa00000fffa000077ffa0007333a000
-- 232:000003ff0000311f000311ff0031171f0311411731141171333344440343914f
-- 233:aaa00000f7fa0000f7afa000ff7ffa001ff7afa071ff7ffa4fffaaaa194944a0
-- 234:dddddddddddddd8dddddd8d8dddddddddddddddddddddddddddddddddddddddd
-- 235:dddddddddddd8d8dddd8d8ddddddddddddddddddd8dddddd8d8ddddddddddddd
-- 236:00100a000aa00a0001a01a001fa0afa01fa01fa0aff01fa011f01af011f01af0
-- 237:00000000a000a000a000aa00a00ff100aa01a0001f01f0a01f0a10fa1f01a0fa
-- 240:ffffffffffff7fffffffffffffaffffffffafffffffffffffffffffffffffaff
-- 241:ffffffffffffff7fafffffffffffffffffffffffffffaffff7fffffffffffffa
-- 242:00013f000000a000000070000000a0000000300000007000000070000007a000
-- 243:0077300000700000003000000070000000a000000070000000a7000000770000
-- 244:aaaaaaaaaafa7afaaaaaaaaaaaaaaaafa7afaaaaaaaaaaaaaaaaafaaaafaaaaa
-- 245:aaaaaaaaaaaaaa7aaa7faaaaaaaafaaaaaaaaaaaaafaaaaaa7aaa7faaaaafaaa
-- 246:0013333f0013773300113373001f133f0117fff301333313113ff7331313f331
-- 247:f7373a00a3f73a00717f3a00333333a0f33733a03f73ff3a13ff33fa3733f333
-- 248:03f49449039f1111039f1111039f1111034f11110344f1110349f1110314ffff
-- 249:1944f4a0f91114a0f91114a049f114a044fff4a0419994a044fff4a0499ff9a0
-- 250:dddddddddddd8dddddd8d8dddddddddddddddddddddddddddddddddddddddddd
-- 251:dddddddddddddddddddddddddddddddddddddddddddd8dddddd8d8dddddddddd
-- 252:01f0070001a007010010030a0070070700301301007017710170111007007170
-- 253:fa0aa011fa00f01ffa0010107000a07071070030300107107017037070730700
-- 254:d0000000d0d0d00020d02d0dd020d00d0d002d000b50db0d5b05e50b50b5b05b
-- 255:0000000020d000d00dd0d02000d020ddd0d0d0200de0b0ddeb50b5b55b0b50b5
-- </SPRITES2>

-- <SPRITES6>
-- 008:000440000004c000000cc00000bbbb000b0bb0b0000ee000000bb00000044000
-- 009:000440000004c090000cc9e900bbbb900b0bb000000ee000000bb00000044000
-- 010:000440000004ceee000ccefe00bbbeee0b0bb000000ee000000bb00000044000
-- 011:000440000004c000000cc00000bbbbb000bbb000000ee000000bb00000044000
-- 012:000440000004c0f0000cc0f000bbbbf00b0bb0b0000ee000000bb00000044000
-- 013:000440000004c0f0000cc0f000bbbbf00b0bb0b0000ee000000bb00000044000
-- 014:0f04400000f4c000000fc00000bbbb000b0bbb00000ee000000bb00000044000
-- 015:00440000004c000000cc000f0bbbb0f0b0bbbf0000ee000000bb000000440000
-- 016:0000000000bbbe000b5555e00bf5f5e00b5555e00b5b5be0b5b0b0be00000000
-- 017:00bbbe000b5555e00bf5f5e00b5555e00b5555e00bb5bbe0bb0b00be00000000
-- 018:00bbbe0e0b5555ee0bf5f5eb0bf5f5e00b5555e00bb5bbe0bb0b00be00000000
-- 019:0000000000bbee000b5555e0bb5555e0bbf5f5e00b5b5be00bb0b0be00000000
-- 020:000aa0000f06a0000f0070000fa7a7000a0070a00000a00000007000000aa000
-- 021:000aa0000006a0000f0070000f07a7000fa070a00a00a00000007000000aa000
-- 022:000aa0f00006af000000f00000a7a700000a70a00000a00000007000000aa000
-- 023:0000aa0000006a00f00007000f007a7000fa070a00000a00000007000000aa00
-- 024:000770000007c000000cc0000044440004044040000ee00000044000000aa000
-- 025:090770009e97c090090cc9e90044449000044000000ee00000044000000aa000
-- 026:eee77000efe7ceeeeeeccefe00444eee00044000000ee00000044000000aa000
-- 027:000770000007c000000cc0000044444000444000000ee00000044000000aa000
-- 028:000770000007c0f0000cc0f0004444f004044040000ee00000044000000aa000
-- 029:000770000007c0f0000cc0f0004444f004044040000ee00000044000000aa000
-- 030:0f07700000f7c000000fc0000044440004044400000ee00000044000000aa000
-- 031:00770000007c000000cc000f044440f04044040000ee00000044000000aa0000
-- 032:aaa00000f3a0000033a37000003a3700003aa3700303aa0000003aa000000330
-- 033:00000000aaa00070f3a0373033a37373003a3737003aa3700303aa0000000330
-- 034:00faa00000f3a0000033a7000003a3700003aa3700303aa0000003aa00000033
-- 035:00000000faa00070f3a0373063a37373003a3737003aa3703303aa0000000330
-- 036:0008800000068000000030000088880008008380000063000000830000088030
-- 037:00088060060686e66e6030600688880000008300000063000000830000088030
-- 038:00088eeeeee68efeefe03eeeeee8880000008300000063000000830000088030
-- 039:0008800000068000000030000888830000008800000063000000830000088030
-- 040:000990000009c0000099c0000066660006066060000ee0000006600000044000
-- 041:000990000009c0900099c9e90066669006066000000ee0000006600000044000
-- 042:000990000009ceee0099cefe00666eee06066000000ee0000006600000044000
-- 043:000990000009c0000099c0000066666000666000000ee0000006600000044000
-- 044:000990000009c0f00099c0f0006666f006066060000ee0000006600000044000
-- 045:000990000009c0f00099c0f0006666f006066060000ee0000006600000044000
-- 046:0f09900000f9c000009fc0000066660006066600000ee0000006600000044000
-- 047:00990000009c0000099c000f066660f060666f0000ee00000066000000440000
-- 048:00000000094900000f94900000009400000049000009400f004900f000494900
-- 049:0000000000000000094900000f949000000094000000490f004900f000494900
-- 050:0094900000f949000000094000000490000049000009400f004900f000494900
-- 051:00000000000000000f4900006f949000600094000000490f004900f000494900
-- 052:0000000000ee00000f9f000000eeee0000099000000eee0000e99e0000000000
-- 053:00000000000eee000f9f0000eeee0000099000000000eee00999000000000000
-- 054:000000000000ee00000f9f000000eee000099000000eee0000e9900000000000
-- 055:00000000000ee0000f9f0000eeee000009900000eee000000999000000000000
-- 056:000ff000000fc000000cf0000088f80008088080000ee0000008800000088000
-- 057:090ff0009e9fc090090cf9e90088f89000088000000ee0000008800000088000
-- 058:eeeff000efefceeeeeecfefe0088feee00088000000ee0000008800000088000
-- 059:000ff000000fc000000cf0000088f88000888000000ee0000008800000088000
-- 060:000ff000000fc000000cf0d00088f8d008088080000ee0000008800000088000
-- 061:000ff000000fc000000cf0d00088f8d008088080000ee0000008800000088000
-- 062:0d0ff00000dfc000000df0000088880008088800000ee0000008800000088000
-- 063:00ff000000fc000000cf000d088f80d08088880000ee00000088000008880000
-- 064:000330000f0c30000f0cc0000f999900090990900004400000044000000aa000
-- 065:000330000f0c30000f0cc0000f999900090990900004400000044000000aa000
-- 066:000330f0000c3f00000cf00000999900009990900004400000044000000aa000
-- 067:000033000000c300f000cc000f09999000f9990900004400000044000000aa00
-- 068:00000000000000000f0f00000000000000000000000000000000000000000000
-- 069:0000000000000000000000000f0f000000000000000000000000000000000000
-- 070:0000000000660660006606600000000000000000000000000000000000000000
-- 071:0000000000000000660660006606600000000000600000000600000000000000
-- 072:00000000000b00000000b0004bebbcc44bebbc440000b000000b000000000000
-- 073:000000000004000000004000a4e44cc7a4e44c77000040000004000000000000
-- 074:00000000000600000000600046e66cc946e66999000069000006000000000000
-- 075:00000000000800000000800088e8ffcf88e88cff000080000008000000000000
-- 076:000440000f04c0900f0cc00900bbb0b9000bbb09000ee009000bb09000044000
-- 077:000440000004c090000cc009000bbb09000bbbff000ee009000bb09000044000
-- 078:000440000004c090000cc00900bbbb0900bbbfff000ee009000bb09000044000
-- 079:000440000004c090000cc00900bbbb090b0bb0b9000ee009000bb09000044000
-- 080:00cc0000007c000c07fa000cc777aa0c007777a007a77aa0077a77a00c70c700
-- 081:0000000000cc0000007c000c07fa000cc777aa0c007777a0077a77a00c70c700
-- 082:000cc000000fc00c007fa00c0c777a0c007777a007a77aa0077a77a00c70c700
-- 083:000000000cc000000fc0000c7fa0000c777aaa0c677777a0077a77a06c70c700
-- 084:00000000088800000f88800000008d000000d8000008800f008800f000888800
-- 085:0000000000000000088800000f8880000000dd000008800f008800f000888800
-- 086:000000000088800000f8880000000dd0000088000008800f008800f000888800
-- 087:000000000000000088800000f8880000000dd0000088000f008800f000888800
-- 088:000880000008d0d0000dd0d0008888d008088080000dd00000088000000dd000
-- 089:000880000008d0d0000dd0d0008888d008088080000dd00000088000000dd000
-- 090:000880000008d0d00088d0d0008888d008088080000dd00000088000000dd000
-- 091:000dd000000d80000008d0d00088d8d008088080000dd00000088000000dd000
-- 092:000770000f07c0900f0cc0090044404900044409000ee00900044090000aa000
-- 093:000770000007c090000cc00900044409000444ff000ee00900044090000aa000
-- 094:000770000007c090000cc0090044440900444fff000ee00900044090000aa000
-- 095:000770000007c090000cc0090044440904044049000ee00900044090000aa000
-- 096:00e0900000eee900001e190000eee900000e900000eee90000eee90000e00900
-- 097:0000000000e0900000eee900001e190000eee900000e900000eee90000e00900
-- 098:00e0900000eee909001e196000eeee00000ee00000eee90000eee90000e00900
-- 099:0000000000e0900000eee900001e19009eeee90000ee900000eee90000e00900
-- 100:00ddf000006d600000ddf0000dddff000ddddf000ddddf000ddddf000dd0df00
-- 101:0000000000ddf000006d600000ddf0000dddff000ddddf000ddddf000dd0df00
-- 102:006d6000006d600f00ddf0ff0dddfff00ddddf000ddddf000ddddf000dd0df00
-- 103:0000000000ddf000006dd000fffff000ffffff0000dddf0000dddf0000d0df00
-- 104:000440000004c0000b0cc00000bbb000000bb000000ee000000bb00000044000
-- 105:000770000007c000040cc0000044400000044000000ee00000044000000aa000
-- 106:000990000009c0000699c0000066600000066000000ee0000006600000044000
-- 107:000ff000000fc000080cf0000088f00000088000000ee0000008800000088000
-- 108:000990000f09c0900f9cc0090066606900066609000ee0090006609000044000
-- 109:000990000009c090009cc00900066609000666ff000ee0090006609000044000
-- 110:000990000009c090009cc0090066660900666fff000ee0090006609000044000
-- 111:000990000009c090009cc0090066660906066069000ee0090006609000044000
-- 112:0044900000f4f000004490000444990004444900044449000444490004404900
-- 113:000000000044900000f4f0000044900004449900044449000444490004404900
-- 114:00f4f00000f4f009004490990444999004444900044449000444490004404900
-- 115:000000000044900000f440009999900099999900004449000044490000404900
-- 116:faaaaaaf0444444004f4f400044444400044444004444440faaaaaaf00000000
-- 117:00000000faaaaaaf0444444004f4f4000044444004444440faaaaaaf00000000
-- 118:faaaaaaf0664664006646600044444400044444004444440faaaaaaf00000000
-- 119:00000000aaaaaaf066466400664660000044444004444440faaaaaaf00000000
-- 124:0007700000073030000330300033333003033030000330000003300000033000
-- 125:0007700000073030000330300033333003033030000330000003300000033000
-- 126:0007700000073030007730300033333003033030000330000003300000033000
-- 127:0007700000073000000370300033733003033030000330000003300000033000
-- 128:0404040400a4aaa00a6a77a00a7777a00a6a77a000a4aaa00404040440040404
-- 129:00404044000a4aa000a6a7a000a777a000a6a7a0000a4aa00040404404004044
-- 130:0040404400066aa00fa667a000a777a00fa667a000066aa00040404404004044
-- 131:040404040066aaa0ff6677a00a7777a0ff6677a00066aaa00404040440040404
-- 132:0000000000060000000660000066660000669660066999600699ee00006ef600
-- 133:000000000600000000060000000660000066960000699e600699ee00006fe600
-- 134:0000000000006000000066000006666000666966066699960699ee00006ef600
-- 135:00000000000000000060000000660000066960000699e600699ee000066fe600
-- 136:0000060000000060066016990006166600001ff6060011660066016600000016
-- 137:0000000000660000990066006699000066900000690600006900660066900000
-- 138:000006000000006000000060000016990006166606601ff60000116600060166
-- 139:0000000000000000006606009900600066990000669000006906060069006000
-- 140:00000060000000060066016900006166000001ff006001160006601600000001
-- 141:0000000000066000999006606669900066690000669060006690066066690000
-- 142:0000000000000000000060000000060000016999006166660601ff6600011666
-- 143:0000000000000000000000000660600090060000699000006900000090606000
-- 144:000000000f737300073737300000037000000030000000700007373000000000
-- 145:00000000000000000f7373000737373000000370000000300007373000000000
-- 146:0000000000ff3730007373730000003700000030000000700007373000000000
-- 147:0000000000000000ff3730007373730060003770000000700007373000000000
-- 148:00066000000e60000000300000666600060063600000e3000000630000066030
-- 149:00066060060e66e66e60306006666600000063000000e3000000630000066030
-- 150:00066eeeeeee6efeefe03eeeeee66600000063000000e3000000630000066030
-- 151:00066000000e60000000300006666300000066000000e3000000630000066030
-- 152:0000001600011166000166690001666900016696000166960001690000019000
-- 153:6690000066690000696690006966900069669000696690006900900090009000
-- 154:0060001606011166000166690001666900016696000166960001690000019000
-- 155:6690000066690000696690006966900069669000696690006900900090009000
-- 156:0000001100000166000001690000166900016696000066960001690000019000
-- 157:6669000066690000696690006966900069669000696690006900900090009000
-- 158:0060166606000166001116660001666900016696000166960001690000019000
-- 159:9006000069000000669000006966900069669000696690006900900090009000
-- 160:0007700000067000000770000077770007077070000770000007700000007700
-- 161:0000000000077000000670000007700000777700070770700007700000077000
-- 162:00077eeeeee67efeefe77eeeeee7770000077000000770000007700000007700
-- 163:0007700000067000000770000777770000077700000770000007700000007700
-- 164:000990000f0c90000f0c99000f66660006066060000ee0000006600000044000
-- 165:000990000f0c90000f0c99000f66660006066060000ee0000006600000044000
-- 166:00099000090c90f0900cc9f09606660090666000900ee0000906600000044000
-- 167:00099000090c9000900cc90090666600fff66600900ee0000906600000044000
-- 168:000000e0000f00ee000f003a000f003a000f0036000f003a000f0000000f0000
-- 169:e0000000ee000000ff000000af000000af000000af000000a0000000a0000000
-- 170:00000000000000e0000f00ee000f003a000f003a000f0036000f003a000f0000
-- 171:00000000e0000000ee000000ff000000af000000af000000af000000a0000000
-- 172:000000e0000000ee0000003a00000066000000660000003a0000000000000000
-- 173:e0000000ee000000ff0000f0af000f00af00f000af0f0000a0f00000af000000
-- 174:000000000000000e0000000e00000003f00000060f00000600f00003000f0000
-- 175:000000000e000000eee00000aff000006af000006af00000aaf000000a000000
-- 176:00077000000c7000000c300000777700070773700006630000077300000aa030
-- 177:00077060060c76e66e6c306006777700000773000006630000077300000aa030
-- 178:00077eeeeeec7efeefec3eeeeee77700000773000006630000077300000aa030
-- 179:00077000000c7000000c300007777700000777000006630000077300000aa030
-- 180:000770000f0c70000f0cc0000f44440004044040000ee00000044000000aa000
-- 181:000770000f0c70000f0cc0000f44440004044040000ee00000044000000aa000
-- 182:000770f0000c7f00000cf0000044440000444040000ee00000044000000aa000
-- 183:000077000000c700f000cc000f044440004044040000ee00000044000000aa00
-- 184:00a4aaaa00040000000000aa00000000000000aa0000000a0000000a0000000a
-- 185:aaff0000a000f000aaf00f00a0000000aaf000000f0000000f0000000f000000
-- 186:000f000000a4aaaa00040000000000aa00000000000000aa0000000a0000000a
-- 187:a0000000aaff0000a000f000aaf00f00a0000000aaf000000f0000000f000000
-- 188:000000aa000000a4000000aa00000000000000aa0000000a0000000a0000000a
-- 189:4aaf0000a000f000aaf00f00a0000000aaf000000f0000000f0000000f000000
-- 190:0000f000000004aa000000400000000a000000000000000a0000000000000000
-- 191:0a000000aaaaf0000a000f00aaaf00f00a000000aaaf0000a0f00000a0f00000
-- 192:000330000f0c30000f0cc0000f666600060660600007700000077000000aa000
-- 193:000330000f0c30000f0cc0000f666600060660600007700000077000000aa000
-- 194:000330f0000c3f00000cf00000666600006660600007700000077000000aa000
-- 195:000033000000c300f000cc000f06666000f6660600007700000077000000aa00
-- 196:000ff000000cf000000fc000008f880008088080000ee0000008800000088000
-- 197:000ff000000cf000000fc000008f880008088080000ee0000008800000088000
-- 198:000ff090090cf9e99e9fc090098f880000088000000ee0000008800000088000
-- 199:000ffeeeeeecfefeefefceeeeeef880000088000000ee0000008800000088000
-- 200:000000000000e00000009e00000009e00000009099e0009e009e009900099999
-- 201:000000000000e0000000e000000990000009000000990000ee900000999e0000
-- 202:0000000000000000000000000009e00000009e00000009900000009e99ee0099
-- 203:000000000000000000000e0000000e00000099000009000000990000ee9000ee
-- 204:000000000000000000000e000000e00000090009000900090009e00900009999
-- 205:000000000e0000000e000000e000000e000000e0e0099e009ee900009999e000
-- 206:000000000000e00000000e0099e0009e009e00000009900000009e009e0099ee
-- 207:00000000000000000000000000000000e0000000090e00009900e00090009000
-- 208:0000000000ff9440000000040000000440000004049494900649490040404000
-- 209:000000000000000000ff94400000000400000004400000040494949006494900
-- 210:0000ff9000000004000000040000000440000004049494900649490040404000
-- 211:000000000000000000000000fff9440000000040040000040049494900649490
-- 216:00009999000099990009999900d99d9d0d0dd0d0000000000000000000000000
-- 217:9999e9999999990099999000d9ddd0000d000d00000000000000000000000000
-- 218:000e9999000099990009999900d99d9d0d0dd0d0000000000000000000000000
-- 219:999e09009999e00099999000d9ddd0000d000d00000000000000000000000000
-- 220:00000999000009990009999900d99d9d0d0dd0d0000000000000000000000000
-- 221:99999e999999999099999000d9ddd0000d000d00000000000000000000000000
-- 222:0e999999009999990999999900d99d9d0d0dd0d0000000000000000000000000
-- 223:9e09000099e0000099900000d9ddd0000d000d00000000000000000000000000
-- 224:00a7000000003a07ff06373a007a3a3700a7373aff063a370000370a00a70000
-- 225:000a7000000003a70ff0637a0007a3a7000a737a0ff063a70000037a000a7000
-- 226:00f3a770000066a70ff0667a0007a3a7000a667a0ff066a70000037a00f3a770
-- 227:ffa7000000066a07ff06673a007a3a3700a6673aff066a370000370affa70000
-- 232:0000000000000000000000000660000000060066000606660000666600000666
-- 233:000000000000000000000000000006606c00600066c06000666c000066c00000
-- 234:0000000000000000000000000660000006060066060606660000666606600666
-- 235:000000000000000000000660000006066c00600066c06000666c000066c00000
-- 236:0000000000000000000000660000660000066006060060660066066600060066
-- 237:0000000000000000000000000000006666c00600666c06006666c000666c0000
-- 238:0000000000000000000000006600000060600666606066660006666666006666
-- 239:00000000000000000000660000006060c00600006c06000066c000006c000000
-- 240:000000000777330077f7f7770337777007733700007770000007000000000000
-- 241:00000000000000000337770077f7f77707773330033777000007000000000000
-- 242:0000000006676600766766770337777007733700007770000007000000000000
-- 243:0000000000000000066766007667667077773330033777000007000000000000
-- 248:000666f6066009f6000099f90000999900099999099009990000909900000000
-- 249:6f6c60006f9006609f9900009999000099999000999009909909000000000000
-- 250:000666f6000009f6000099f90090999909099999000009990000909900000000
-- 251:6f6c60606f9006009f9900009999090099999090999000009909000000000000
-- 252:0000666f0000009f0000099f0000999900099999009009990000909900000000
-- 253:66f6c60066f9006699f990009999000099999000999009909909000000000000
-- 254:00666f6600009f6600099f990090999909099999000009990000909900000000
-- 255:f6c60600f9006000f99000009999090099999090999000009909000000000000
-- </SPRITES6>

-- <MAP>
-- 000:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171005050505050504550505050505000005050505050504550505050505000000000000000000000000000000000000000000000000000000000000000
-- 001:7171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171714173737373737321737373b6b6b661419672969696962196969696729661000000a0a0a0a0a0a0a0a000000000000000000000a0a000000000000000
-- 002:71717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717141737373737325212121212121e361419696967296962121212121219661000091a1a1a1a1a1a1a1a1b10000000000a0a0a09082a1b1000000000000
-- 003:7171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171714152524273737321b6e3e362835261415252429696962196969662835261000091a1b2a2a2a292a1a1b10000000091a1a1a1a1a1a1b1000000000000
-- 004:7171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171714150934073737321e3e3e360505061415093409672962196729660505061000091a1b10000000092a1b10000000090a1b2a2a2a2a200000000000000
-- 005:71717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717141732121212121218073e361000061419621212121212180969661000061000090a1b0000000a090a1b0a0000091a1a1b100000000000000a0a00000
-- 006:7171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171714173217373e32121e3e3e3609350614172219696962121219696609350610091a1a1a1b10091a1a1a1a1a1b10090a1b2000000a0a0a0a090a1a1b100
-- 007:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171417321e3b6e32163212121212173614196219696962163212121212121610091a182a1b10091a182a163a1b090a1a1b0a0a090a1a1a1a1a1a182b100
-- 008:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171415283525242212121737373737361415283525242212121969621e421610000a2a2a200a090a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1b292a1a1b100
-- 009:71717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171c2c2c2c2c2c27171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171410000000041737373737373737361410000000041969696967221212161000000000090a1a118a1a1a1a1b2a2a2a2a2a2a29228a1b20000a2a20000
-- 010:71717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171c2c2c2c2c2c2c2c2c2c271c2c2717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171710052525252525252525252525252000052525252525252525252525252000000000091a1a1b2a2a2a2a2a20000000000000091a1b200000000000000
-- 011:71717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171c2c2c2c2c2c2c2c2c2c2c280c27171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717100000000a0a0000000a0a0a0a0a00000a0a0a0a0a0a0a0a00000000000000000000091a1b20000000000000000000000000091a1b100000000000000
-- 012:7171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171c2c2c27171c2c2e0c2c2c2c27171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717100a0a090a1a1b1a090a1a1a1a182b190a1a1a118a1a1a1a1b0a0a0a0a000000000a090a1b10000000000000000000000000090a1b0a0000000000000
-- 013:7171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171c2c2c271717171e0c2c2c27171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171c0a1a1a1a1a144a1a1a184a1a1a164a1a1b2a2a2a2a292a1a1a1a1a1a1b1000090a1a1a1b100000000000000000000000091a1a1a1a1b00000000000
-- 014:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717180e371717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171c2c2c27171e0e0c2c2c271717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171e3e3e3e3e3e3e3e371717171717171717171717171717100a2a292a1a164a1743490a1a1a1a1a174a0a0a0a0a0a0343454a182a1b100c0a108a1a1b10000000000000000000000009182a1a1a1a1c100000000
-- 015:71717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171b6e3e3717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171c2c2c2c2c2e0c2c2c2c27171717171717171717171717171717171717171717171717171717171717171717171717171717171717171e3e3e3e3e3e3e3e3e3e3e3e371717171717171717171717171710000009182a108a1a1a1a1a1b2a292a1a1a1a1a118a1a1a1a1a1a1a1a1b1000092a1a182b100000000000000000000000091a1a1a1a1b20000000000
-- 016:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171b6b6e3e3e371717171717171717171717171717171717171717171717171717171717171717171717171717171717171c2c2c2c2e0e0c2c2c271717171717171717171717171717171717171717171717171717171717171717171717171717171717171e3e3e3e3e3e3e3e3e3e3b6b6b6e3e3e3e3e3e37171717171717171717100000000a2a2a2a2a2a2a2a2000000a2a2a2a2a2a2a2a2a2a2a2a2a2a200000000a2a2a20000000000000000000000000000a2a2a2a2000000000000
-- 017:71717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171e3e3e3e3e3e3e3e3717171717171717171717171717171e1e1e1e1e0e0c2c2c27171717171717171717171717171717171c2c2c2c2c2c2c2c2e2717171717171717171717171717171717171717171717171e3e37171717171b6b6e3e3e3187171717171e3e3e3e3e3e3e3e3e3e3e3e3e3b6e3e3e3e3e3e3e3e37171717171717171710020202020200320202020200000a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:71717171717171717171717171717171717171719696969696969671717171717171717171717171717171717171e3e3e3e3e3e3e3e3e3e3e3e3e3717171717171717171717171e1e1e1e0e0e0c2c2c2c2c271717171717171717171717171717171e2c2c2c2c2c2c2c2e2e27171717171717171717171717171717171e3e371717171e3e3e3e3e3e3e3e3e3e3e3b6b67171e3e3e3e3e3e3e3e3e3c6c6e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3717171717171717111717171717121717171717131c0a1a1a1b10000a0a0a0a0000000000000000000a0a0a000000000000000a0a0a00000000000000000000000000000
-- 019:717171717171717171717171717171719696969696969696969696717171717171717171717171717171717171e3e3e3e3e3e3e3e3f121e3e3e3e3e3e3e3e3c2c2717171717171e1e1e0e0c2c2c2c2c2c2c2c2717171717171717171717171c2c2e2e2c2c2c2c2c2c2c2c2e2e2c2717171717171717171717171717171e30871e3e3e3e3e3e3e3e3e3c6c6e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3c6c6e3e3e3e3e3e3e3e3c6c6e3e3e3e3e3717171717171711171d170237021702370d171310054a174a0a090a1a1a1a1b100000000000000c0a1a1a1b1000000000091a182a1b10000a0a0a00000000000000000
-- 020:717171717171717171717171969696969696969696969696969696717171717171717171717171717171717171e3e380e3b6b6b6e3e3e3e3e3e3e3e3e371c280c2c27171717171e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e07171c2c2c208c2c2c2c2c2e0e0c2c218c2c2c2c2c271717171717171717171717171e3e3e3e3e3e3e3e3e3b6b6c6c6c6c6c6c6c6e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3c6c6e3e3e3e3717171717171711121212170702170702121213191a1a1a1a133a1a1a1a1a1b10000000000000000a292a1b1000000000091a1a1a1b10091a1a1a1c100000000000000
-- 021:71717171717171717171719696969696969662524296969696967171717171717171717121717171e3e3717171e3e3e3b6b6b6b6e3e3e3e3e3e37171717171e2c2c2c213c27171e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2c2c2c2c2c2e0e0e0e0c2c2c2c2c2c2c2c2c2717171717171717171717171e3e3e3e3e3e3e3e3e3e3b6b6e3e3c6c6c6c6c6e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3c6c6c6e3e3717171717171711121f221212121212121f2213191a1a1a1b2a292a1a1a1a1b100000000000000000091a1b000000000000092a1b2000091a1b2a20000000000000000
-- 022:71717171717171717171719696969696969660454096969696717171717171717132221221717171e3e3e3717171e3e3e3e3e3e3e3e3c6c6e371717171717171e2c27171c2e2e2e2c2c2c2c2c2c2e0e0c2e2e2e2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2131313131313f0131313e3e3e3e3e3e3c6c6e3e3e3e3e3e3e3e3e3e3c6c6c6c6c6c6e3e3e3e3e3c6e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3b6c6e3e3e37171717171711121212170702170702121213191a114a1b10000343434340000000000000000000090a1a1b0a0a0a0000091a1b100a090a1b1000000000000000000
-- 023:71717171717171717171719696969696969696969696969671717171717171712130031021b67171e3e3e3e371717171e3e3e3e3e3e3c6c6c67171717171717171717171e0e0e0e2e2e2c2c2c2c2e0e0e2e2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c271717171717171717171e3e3e3e3e3c6c6e3e3e3e3e3e3e3e3e3e3e3c6c6c6b3b3c6e3e3e3e3c6c6c6e3e3e3b6b6e3e3e3e3e3e3e3e3e3c6c6c6e3e3717171717171711171d170702121217070d1713191a1a1a1b0a090a1a1a1a1b1000000000000000091a1a1a1a182a1a1b0a090a1b19163a1a1b1000000000000000000
-- 024:71717171717171717171719696969696969672967296967171717171717171e32114211421b67171e3e3e3e3e371717171e3e3e3e3e3c6c6c6c6e3717171e0e0e1e1e1e1e1e1e0e2c2e2c2c2c2c2e0e0c2c2c2c2c2c2c2e0e0e0e0c2e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2e2e2e2c2c2c271717171717171717171e3e3e3e3c6c6b6b6b6e3e3e3e3e3e3e3c6c6c6b3b3b3b3c6e3e3e3e3c6c6c6e3e3e3b6b6b6e3e3e3e3e3e3e3c6c6e3e3e3e3717171717171711171d1707021e4217070d1713191a1a1a1a133a1a1a1a1a1b1000000000000000091a1a1a1a1a1a1a1a1a1a1a1b191a1a1a1b10000a0a0a000000000
-- 025:71717171717171717171717196969696969696969696967171717171717171e3e3e3e3e3b6e37171b6b6e3e3e3e371717171e3e3e3e3e3e3c6c6c6e3717171e0e0e1e1e1e1e1e0c2c2c2c2c2c2e0e0e0c2c2c2c2e0e0e0e0e018c2c2e0e0e0c2c2c2c2c2c2c2c2c2c280c2c2e2e2c2c2c2717171717171717171e3b6b6e3c6c6c6b6b6b6e3e3e3e3e3e3c6c6b3b3b3b3b3b3c6e3e3e3e3e3e3c6e3e3e3b6b6b6e3e3e3c6e3e3c6c6e3e3e3e3e3717171717171711171702370212121702370713191a1a1a1b2a292a1a1a1a1b1000000000000000091a163a1a1a1a1a1b2a2a2a20091a1a1a1b10091a143a1b1000000
-- 026:71717171717171717171717196969696969672967296969671717171717171b6b6e3e3e3e3e37171b6b6e3e3e3e3e3e3717171e3e3e3e3e3e3e3e371717171f1c2e0e1e1e1e1e0c2c2c2c2c2c2e0e0e0c2c2c2c2e0e0e0e0c2c2c2e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2717171717171717171e3e3b6b6b6b6e3e3e3e3e3e3e3e3e3c6c6b3b3b3b3b3b3c6c6e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3c6c6e3e3e3e3e3e3e3e371717171717171710022222222222222222222220091a1a1a1b100003434343400000000000000000000a2a2a2a2a292a1b1000000009128a1a1b10091a1a1a1b1000000
-- 027:717171717171717171717171969696969696969696969696967171717171b6b6b6e3e3e3e37171b6b6e3c6e3e3e3e3f2e37171e3e3e3e3b6b6b67171717171c2c2e0e1e1e1e1e0c2c2c2c2c2e2e0e0c2c2c2c2c2c2c2c2c2c2c2e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2212121717171717171717171e3e3e3b6b6b6e3e3e3e3e3e3e3e3e3c6c6b3b3b3b3b3b3b3c6e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3c6e3e3e3e3e3e3e3e371717171717171717100a0a0a0a0a045a0a0a0a0a00091a114a1b0a090a1a1a1a1b1000000000000000000000000000091a1b00000000091a1b2a200009118a1a1b1000000
-- 028:717171717171717171717171969696969696729672969696969671717171b6b6c6c6c6e3e37171c6c6e3e3b6b6e3e3e3e3717171e3e3e3b6b6e3e371717171e0c2e0e0e1e1e0c2c208c2c2c2e2c2e0c2c2c2c2c2c2c2c2c2c2c2e0e1e0c2c2c2c2d1d1d170c2c2c2c2c2c2c2c221e421717171717171717171e3e3e3e3e3e3e3e3e3e3e3e3e3c6c6b3b3b3b3b3b3b3b3b3c6c6e3e328e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e37171717171717171717111b6c6c664e3e3e364b6b6e33191a1a1a1a13318a108a1a1b100000000000000000000000000009108a1b0a0a0a090a1b100000091a1b2a200a0a000
-- 029:71717171717171717171717196967196969696969696969696717171717171b6b6e3c6c6e37171b6c6e3e3c6c6c6e3e3e3131313e3e3e3b6e3e3c6c671717171c2c2e0e1e1e0c2c2c2c2c2c2e2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e0e0c2c2c2c2f170716370c2c2c2c2c2e0e0212121717171717171717171e3e3e3e3e3e3e3e3e3e3e3e3c6c6b3b3b3b3b3b3b3b3b3b3c6c670d1e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3707171717171717171717111212121e3e3e3e3c6e3e3323191a1a1a1b2a292a1a1a1a1b1000000000000000000a0a0a0a0a090a1a1a1a1a1a133a1b100000091a1b1009182a1b1
-- 030:71717171717171717171717171717196969696969696969671717171717171e3e3e3e3e3e371b6b6e3e3e3e3e3c6c6e3e3e37171e3e3e3e3c6c6c6e3717171717171e0e1e1e0c2c2c2e0e0e0e0e0e0e0c2c2c2c2c2c2e2e2e2e0e1e0e0c2c2c2c2d17171d18070c2c2c2e0e0c271717171717171717171717171e3e3b6e3e380e3e3e3c6c6c6b3b3b3b3b3b3b3b3b3b3b3c6c6d1d1d1e3e3e3e3e3c6c6e3e3e3e3e3e3e3e3e3e37070707171717171717171717111216321e3e3e3e3e3e3e3563100a2a2a2000000a2a2a2a20000000000000000009182a1a1a1a1a1a1a1b292a1b2a2a2000000a090a1b00091a1a1b1
-- 031:71717171717171717171717171717196969696969696967171717171717171e3e3e3e3e3b6b6b6e3c6c6e3e3e3e3c6e3e3b6b67171e3e3e3e3e3e37171717171e080c2e0e0e0c2c2c2e0e0e0e0e1e1e0e0e0e0c2c2c2e2e2e2e0e1e0c2c2c2c2c2c270d170c2c2e0e0e0e0c2c271717171717171717171717171e3e3b6b6b6e3e3c6c6c6b3b3b3b3b3b3b3b3b3b3b3b3b3b3c6d2d2d2e3e3e3e3c6c6c6e3e3e3e3e3e3707070707070707071717171717171717111212121e3e3e3e3e3b6e33031000000000000000000000000000000000000000000a2a2a2a2a2a2a2a20091a1b0a0a0a0a090a1a1a1a1b090a1b200
-- 032:717171717171717171717171717171717171711371717171717171717171b6b6b6e3e3b6b6b6e3c6a3a3c6e3e3e3e3e3b6b6b6b67171e3e3b6b6b671717171e1e0e2c2c2c2c2c2c2c2e0e0c2c2e0e1e1e0e1e0e0c2c2c2c2e0e0e0e0c2c2c2c2c2c2c2c2c2c2e0e0e0c2c2e2c271717171717171717171717171e3e3e3e3e3e3c6c6b3b3b3b3b3b3b3b3b3b3b3b3b3b3a3a3d2d2d27171717171c6c6c6e3e3e3707070707070707070707071717171717171717111b6b6c6e3e3e3e3e3b6b6e33100000000000000000000000000000000000000000000000000000000000091a1a1a1a1a1a1a1a1a1a1a1a1a1a1b100
-- 033:717171717171717171717171717171717171711371717171717171717171b6b6b6e3b6b6e3e3e3e3a3a3a3c6e3e3e3b6b6b6b6b6717171717171717171717171e0e0e0c2e2e2c2e0e0e0e0c2e0e0e0e1e1e1e0e0e0e0e0e0e0e1e0c2c2c2c2c2c2c2c2c2e0e0e0e0c2c2c2e2e27171717171717171717171717171e3e3e3c6c6c6b3b3b3b3a3a3a3a3a3a3a3b3b3b3a3a3d1d1d2d2717171717171c6c6c6e37070707070707070707070707171717171717171710022222222220422222222220000000000000000000000000000000000000000000000000000000000000000a2a2a2a2a2a2a2a2a2a2a2a2a2a20000
-- 034:7171717171717171717171717171d1d1d171711371717171717171717171e3b6b6b6b6e3e3e37171c6a3a3a3c67171717113717171717171717171717171717171e0e2c2e2e2c2e0c2c2c2c2e2e2e2e0e0e0e1e0e0e0e0e0e0e1e0c2c2c2c2c2c2c2c2e0e0c2c2c2c2c2c2c2c2c2717171717171717171717171717171c6c6b3b3b3a3a3a3d2d2d2d2d2d2d1a3b3a3a3d1d1d1d1d271717171717171c6c67070707070707070d1d1d1d1d1717171717171717171002020202020202020000020202020202020200000000000000000000000000000202020202020202020202020202020202020202003202020200000
-- 035:71717171717171717171d1d171d1d1d1d1d171137171717171717171717171e3e3b67171137171b6b6c6a3b3a3c6b6b6b6b671717171717171717171717171717171c2c2e2e2e0e0c2c2c2c2e2e2e2e2e2e0e0e0e0c2c2e0e0e0e0c2c2c2c2c2c2e0e0e0c2c2c2c2c2c2c2c2c2c2717171717171717171717171717171c6c6c6c6c6d1d1d2d2d2d2d2d2d170a3a3a37070d1d1d1d171717171717171c6c6707070707070d1d1d1d1d17171717171717171717171110011252505310000311105252505140530203100001505050515152531000011001121310011213100117170703100000011702121213100003100
-- 036:71717171717171717171f170d1d17171d1d1d1d1d17171717171717171717171e37171e3e3e3e3b6b6b6c6b3b3a3c6e3c6b6b6b6b6b6b67171717171717171717171c218c2c2e0e0e0c2c2c2e0e0c2e2e2e2e0e0c2212121e0e0e2e2e2e2e2c2c2e0e0c2c2c2c2c2c2c2c2c2c2c2e07171717171717171717171717171c6c67070d1d1d2d2d2d2d2d1d17070707070707070d1d180d17171717171c6c6c6707070717070d170f17070717171717171717171717111000221210530012031112212252121212121c1001505058005050805c1000011001121300110703001107171713020012010237021213100013100
-- 037:71717171717171717171717171717171d1d1d1d1d1d1717171717171717171717171e3e3c6c6e3b6b6b6c6b3b3b3a3c6e3c6e3e3b6b6e37171717171717171717171c2c2c2c2c2c2e0e0e0e0e0e0c2c2c2c2c2c280216321c2e0c2e2e2e2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e07171717171717171717171707070d1d1d1d2d2d2d2d2d1d17070a670a670a6707070d1d17171717171c6c67070707171717171717171717171717171717171717171112010152115152105311100022121140532223100151505050505052531000011000221212121707070707071717171137171707021213111213100
-- 038:7171717171717171717171717171717171d1d1d1d1d1707171717171717171b6b6b6b6c6c6c6e3e3e3b6b6c6b3b3b3a3c6e3e3e3e3b6b6b6717171717171717171c2c2c2c2c2c2c2e0e1e1e1e0e0c2c2c2c2c2c2c2212121c2e0c2c2c2c2c2c2c2c2c2c2c2c2c214c214c2c2c2c2c2e0e0e0e071717171717171717171707070d1d1d1d2d2d2d2d2d163707070707070707070707071717171717171717171717171717171717171717171717171717171717171c021212121212121323111001115210505300131000015050505f1152531000011201021212121217070707070717171137171707070213111213100
-- 039:7171717171717171717171717171717171d1d1d1d17070707071717171717171b6b6b6b6b6e3e3e3c6e3e3c6a3b3b3b3c6c6e3e3e3e3e3e3717171717171717171c2c2e0c2c2c2e0e0e0e0c2e0c2c208c2c2c2c2c2c2c2c2c2e0e0c2c2c2c2c27171c2c2c2c2c2320412c2c2c2c2c2d6c3c271717171717171717170707070d1d1d1d2d2d2d2d2d2d1d17070a670a670a670707071717171717171717171717171717171717171717171717171717171717171711122122121632121563111201015212121210531000000050515151525310000110011213212212170637070c5707171137170237070213010213100
-- 040:7171717171717171717171707071717171d1d1d17070707070a371717171717171b6b6b6b6b6e3e3e3e3e3e3c6b3b3b3b3c6e3e3e3e3e3b67171717171717171c2c2c2e0e0c2c2c2c2c2e0e0e0e0c2c2c2c271c2c27113c2c2e0e0c2c2c2c2717171c2c2c2c2c2302010c2c2c2c2c2c2e07171717171717171717070707070d1a3d2d2d2d2d2d2d1d1d170707070707070707171717171717171717171717171717171717171717171717171717171717171717111000221212121213031112505152121e421053100000000000000000000000011001121310221217070707070717171137170707070182121213100
-- 041:717171717171717171717070707070d1d1d1d170707070a3a3a3b371717171717171717171b6b6b6e3e3e3e3c6c6b3b3b3c6e3e3e3b6e3b67171717171717171c2c2c2e0e0e0c2c2c2c2c2e0e0e0c2c2c271717171711371c2e0e0c2c2c27171717171c2c2c2c2c2c2c2c2c2c2c2c2c271717171717171717171707070707070a3a3d2d2d2d2d2d1a3a3707070707070717171717171717171717171717171717171717171717171717171717171717171717171112010211525252125311125251521212121053141b3b3b3b3b3b3b3b361000011001121301021212113131313131313131313212121213222223100
-- 042:717171717171717171717070707070707070707070a3a3a3b3b3b3717171717171717171717171b6e3e3e3e380c6b3b3b3c6e3e3b6b6e3717171717171717171c2c2e0e0e0c2c2c2c2e2c2c2c2c2c2c27171717171718571717171c2c271717171717171c2e2e2e2c2c2c2c2c2c2c2717171717171717171717171717070707070a3a3a3a3a3a3a3a370717071717171717171717171717171717171717171717171717171717171717171717171717171717171110505211515252115311125250521151515153141b3b3a3a3a3a3b3b361000011000221212121212170237070717171717021212121213001203100
-- 043:717171717171717171717170707070707072707070a3b3b3b3b3a3a371717171717171717171718070e3e3e3d2c6b3b3b3c6e3e3e3e371717171717171717171c2e0e0c2c2c2c27171e2c2c2c2c271717171717171717171717171717171717171717171c2e2e2e2c2c2c2c2c2717171717171717171717171717171717113717170a3a3a3a3a3a37171717171717171717171717171717171717171717171717171717171717171717171717171717171717171112515211515152115311122120521151515153141a3a3a3d16252425261000011001121322212212121707071717171707021213212212121213100
-- 044:7171717171717171717171707070b5b5b5b5b5a3a3a3b3b3b3a3a3707171717171717171717171717070e3d2d2c6c6b3b3c6e3e3e3e37171e3e3e3717171717171717171c2c271717171c2c27171717171717171717171717171717171717171717171717171c2c2c2c2c2c27171717171717171717171717171717171711371717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171711125152132221221153111000221211515322231412212d1636093409361000011201021300110532121707071717170702121213102217070703100
-- 045:71717171717171717171717171b5b5b5b5b5b5a3a3b3b3b3a3a3237070717171717171717171717171d2e3d2d2d2c6c6b3c6c6e3e3e3e308e3b6807371717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171710571717113717171717171717171717171717171717115717171717171717171717171717171717171717171717171717171717171717171717111050521300110211531110011052115253001314100027070707070d161000011212121212121212121707171717170702121213010217070703100
-- 046:71717171717171717171c275711375b5b5b5b5b5a3a3b3b3a37373737313131313281313131313131313e3e37373d2c6b3c6c6b6e3e373e3e3e373737171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171151515150571717171717171717171717171710505051515157171717171717171717171717171717171717171717171717171717171717171711122122121212121153111201005212525732131412010d1707070d13261000011707072702121212121131313131313212121212121217023703100
-- 047:717171717171717171c2c2757513757575b5b5b5b5a3a3a3a3737070717171717171717171717171717171d2d273d2c6c6c6b6b6e3e37373e3e3e37171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171711515150505150505050571717171717105050505050505717171717171717171717171717171717171717171717171717171717171717171717111000221150515211531c021212121212121213141000270707070d15661000011707070702121082170707171717270212132223212217070703000
-- 048:71717171717171c3c2c2c270701371717575b573737373737373707171717171717171717171717171717171d273d2d2e3e3e380737373717171e3e37171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171050505151505050505131313130525251515717171157171717171717171717171717171717171717171717171717171717171717171711120102105051521153111221225250505050531410011d1147014d131610000117072707021142114707071717170702121560031022123707021c1
-- 049:71717171717171c2c2c2c2707070757171757573b5b5b5b5b5b5b5717171717171717171717171717171717171737318e3e373737371717171711371717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171712525631505050571717171717171052515150505052525717171717171717171717171717171717171717171717171717171717171717171002222222222220422000022222222222222220000525252525552525200000000222222222222042222222222222222222222222222222222222200
-- 050:71717171717171c2c2c2c2c2707075757171757375b5b5b5b5b5b5b5717171717171717171717171717171717171d2e3e37171717171717171717171717171717171717171717171717171717171717171718571717171717171717171717171717171717171717171717171717171717171717171717171717171150525250505717171717171717171711515050505252525717171717171717171717171717171717171717171717171717171717171717171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 051:71717171713212c3c2c3c2c3c270707575717113757575b5b5b5b5b571717171717171717171717171c2c271717171717171717171c2c2717171137171c2c2c2c2c2c2c2c280c27070d171717171717171711371a3b3b3b3717171757575757575757575757575757575757571717171717171717171717171711515150505137171717171717171717171710505050505717171717171717171717171717171717171717171717171717171717171717171717100202020202020032020202020200000a020a000a0209320a000a020a00000000000000000000000000000000000b3b3b3b3b3b3b3b3b3b3b3b3b3b3
-- 052:7171717171318673737373737373a3a37575751371717175b5b5b570707171717171717171717171c3c2c2717171717171717171c2c281c27171c2c280c2c3c2c2707070c2c2707070707171d170717171d313d3b3b3a3a3717171757373737373737575757373737375757575757575d1d17071717171717171157105057113717171717171717171717171717171050513137171717171717171717171717171717171717171717171717171717171717171711115151515057121710505153100319114a1a144a1a1a1a1a144a1a1a1b100505050505050935050505050505000b3a38270a3a3a3a3a3a3a3a3a3b3
-- 053:71717171713010c3c2c3c2c3c273a3a3707270737575717575757070707171717171717171717171c2c2c27171c2c3c2717171c2c2c2c2c2c27171c2c2c2c270707023707070707070237070d1707070707073d3a3a3a3717171757573a3a3a3757375757573a3a3737575757575757570d1d1717171717171710571717171137171717171f2057171717171717171717171137105057171717171717171717171717171717171717171717171717171717171711122121505057121710521215600319182a1a144a1a1a1a1a164a184a13141707070707070707070707070707061b3d1737373737373737373d070b3
-- 054:71717171717171c2c2c2c2c2a373a3a3a37070737075717171757570707071717171717171717171c2f1c271c2c2c2c2c271c2c2c3c2c280c27171c2737373737308737373737373187373737373737373737371717171717171757573757575a37373737373a3a37373737375757575707070717171717171717171717171137171717105050515151505717171717171711371710571717171717171717171717171717171717171717171717171717171717111000221210571217105210531003100a292a144a1140814a1a1a144a1b141707270727072707270237023707061b3d173a3a3a3a3d1d1a3a3a3a3b3
-- 055:71717171717171c2c2c2c2a3a373a3b3a370707370757575717175757070707171717171717171717171717171c2c3c2717170c2c2c273707171717073d1d3d3807370d1d1d1708073707073707070d3d371717171c2c271717171757373187375717171757575a37575737575757570707070707171717171717171717171131313131305052505151525050505717171050571717171717171717171717171717171717171717171717171717171717171717111001105212113211321213222223100a090a1447171a17171b23490a13141087070707070707070707070827061b3a373187373a3a3a3d1d18270b3
-- 056:71717171717171d1a3a3a3a3a373a3a3a3a3a373737373757571717575707070717171717171717171717171717171717171707070d173707171717073d1d3d3707370d1d1d1707073706283427070d3d3d1d1d17180c2e0717171757575757375717171717575a375757375757171d3d3d370707171717105717171717171717171717171252505057171050505050505058105717171717171710505717171717171717171717171717171717171717171717111221205057171217171053001203191a1a1a1447171a171714482a1a1b141706252525252525252525252525200b3a370717173737370d1a3a3a3b3
-- 057:71717171717171d1d1d1a3a37373737373737373d1d173707575717175757570717171717171717171717171717171212121d17070d1732370d1717073d17171717370d1d1707070737060504070708070d1d1a3a3c2c2c2c27171717175757375717171717175a375757375717171d3d3d370d17171717105257171717171717171717171250505050571710505052525052571717171717105050505717171717171717171717171717171717171717171717111001105057121212171050521053191a18418647171a1717144a1a1a1b141706050505050505050505050505000b3a371717171717370708070a3b3
-- 058:71717171717171718070d1d173d1d1d2d2d2d2d2d1d17370707575717171757570717171717171717171717171717121e421737373737370d3d1717173d17171717370d1702370707370a3d670707070d1d1a3a3a3a3a3c2c271717171717573757575717171a3a375287375717171d3d370d1d17171717105257171717171717171717171717113050505130505252505050513131313131313050580057171717171717171717171717171717171717171717111000221212121632121212121053111a144a1a1a114a114a1b05424b20041707070707070187070707070827061b3a3717171717113717171a3a3b3
-- 059:71717171717171717171707073707070d2d2d2d2d1d17370707075757171717570717171717171717171717171717121212170d1d1d3737373d1322204127071d37370d1707070a37370d1d1d1707070d1d1a3b3b3b3a3c3c2e0717171717573737373737571a37573737575717171717070d1d17171717105717171718005050571717171717113717171717125252515151571717171717171050515157171717171717171717171717171717171717171717111201005057121212171050521053191a1b1a292a1a1a1a1a1a1a1a1b00041707270237072702370727072707061b3a3d1717170711371717171a3b3
-- 060:717171717171717171717170f27071717070d2d2d1d1737023707575717071757570717171717171717171717171717171717170d3d3707073703100001170d3d37370d3d370a3a373737373732873d1d1d1a3b3b3b3a3a3c2e0717171717575757575737575a37573a3a3c6c671717170d1d1d17171717171717171050505051515717171717113717171717171251515051571717171717105051515157171717171717171717171717171717171717171717111001105057171217171052121213191a1b0a000a212a132a292a1a1a13141717171717171137171717171717161b3a373737373737370707071a3b3
-- 061:7171717171717171717171717171717171d2d2d2d1d173707075757171d17171757571717171717171717171717171717171707023708070707030032010702114211421d3a3a37171137171d3d373d1d1a3a3a3b3b3b3a3c2e0717171717171757575737575a3757373e3e3e37171717070d17071717171717171712525051515157171717171137171717171717171711371717171717171717171717171717171717171717171717171717171717171717171110002212121132113050521e4213111a1a1a1b10091a1b0a09082a1a1b141707070707070707070707070707061b3a373a3a3a3707070707070a3b3
-- 062:7171717171717171717171717171717171d2d2d2d1b5b5b57075717171f1d1717175d17171717171717171717171717171717070707070d3707070737171a32132041221a3a371717113717171f173d1d1d1d1a3b3b3b3a3c2c2717171717171757575737575a375b6b6e3e3e3717171e370b6717171717171717171712505151505717171717113717171717171717171131371717171717171717171717171717171717171717171717171717171717171717111201005050571217105052121213191a18424b0a091a1a133a184a1b20000525252525242706252525252525200b3a3737070a3a3a3a3a3a3a3a3b3
-- 063:71717171717171717171717171717171d2d2d1d1d1b5b5b5b5757571717171717175d1d171717171717171717171717171717070707070d3d3d323737171a32130201021717171d370707171707073d1a3a3d3a3b3a3a3a3c3c27171717171717575757375a3c6e3e3e3e3e375717171e3e3b6717171717171717171717171710505131313130505717171717171717171711371717171717171717171717171717171717171717171717171717171717171717111151515151571217115151515153191a14463a1a16424b254386424600000000000005040706050500000000000b3a3737373087373a3b3b3b3b3b3
-- 064:71717171717171717171717171717180c2c2d1d1b5b5b5b5b5707575757171757575d1d17171717171717171717171717171717270707080d3707073717171a3a37171717171a3d37080707170707370a3a3d3a3b3d3d0d3c2c27171717171717508757375a3c6c6e3b67073707171717070707171717171717171717171717171717171710505050571057171717171250505257171717171717171717171717171717171717171717171717171717171717171111515b2922114211421b29215153111a1b19243a1a1a144a1a1a1a1a16100000000417070287070706100000000b3a37070a3a3a373a3b3b3b3b3b3
-- 065:71717171717171717171717171717171c2c2c2c2c2c2c2c2b570707075757575d1d1d1d1717171717171717171711313131313707070737373737373807071b3a3a3d1d17171717171717171d3d37370d1a3d0d3b3a3a3a3c3c2717171717171717575737575a3c6757570807071717170f170717171717171252525717171717171717171051571717105051313131305050525057171717171717171717171717171717171717171717171717171717171717111a2a20000a2a255a2a20000a2a23191a1b0a0343454a144a163a1d4a16100000000417023702382706100000000b3a38270a3b3a3d070b3b3b3b3b3
-- 066:71717171717171717171717171717171c2c3c2c2c2c380c2c2c270707070d1d1d1d17171717171717171717171717171717171d3d3707023d1d1d1d1717171b3a3a3a3d1d1717171717171717170738070a3d3a3b3b3a3a37171717171717171717175737575a3a37575707070717171a3a370717171717171712525257171717171717105051571710505050571717105251515157171717171717171717171717171717171717171717171717171717171717111000000000000000000000000003191a1a1a128a1a1a144a1a1a1a1a16100000000005252525252520000000000b3a3a3a3a3b3a370a3b3b3b3b3b3
-- 067:717171717171717171717171717171717171717171717171c2c3c2c27071717171717171717171717171717171717171717171d3a3a3a3a3a3a3a3a3717171b371d1d1d1d1d1d1d17071717171711371d1a3b3b3b3b371717171717171717171717175737575a3a3a3757575a3a3a37171a371717171717171717125717171717171717171151515150571717171717171151515717171717171717171717171717171717171717171717171717171717171717100222222222222222222222222220000a2a2a2a2a2a2a20052525252520000000000000000000000000000000000b3b3b3b3b3b3b3b3b3b3b3b3b3b3
-- 068:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171d171d1d1d1d170b5b571717171717171717171717171717171717171717171757573757575a3a3a3a3a3a370717171717171717171717171717171717171717171717171717171137171d5d5717171717171717171717171717171717171717171717171717171717171717171717171717100202020202020032020202020200000a020a020a000000020a020000000000000000000000000000000000000000000000000000000000000000000
-- 069:71717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171f2707171717171b5b57171717171d3b5b5b5b5711371717171717171717171717171717171757575757375757575a3a3a3a3a3707071717171717171717171717171717171717171717171717171711371d5d536717171717171717171717171717171717171717171717171717171717171717171717171717111e2e2c2c2c214c214c2c2e2e2e231c0a1a1a1a1a1b1a090a1a1a1b100000000000000000000000000000000000000a0a0a0a0a0a0a0a00000000000
-- 070:7171717171717171717171717171717171717171a3d2717171717171717171717171d2d2d27171717171717171717171717171717171707070707070717171b5b5b5b5b571717171d3b5b5b5b5b573b5b57070707070a3a3b571b5b5b5b5b570707070738070707070707070707070717171717171717171717171717171717171717171717171d5d5d5d5d53636717171717171717171717171717171717171717171717171717171717171717171717171717111e2c2c2c2c2c208c2c2c2e2e2e231003492a1a5a144a1a1a18418b100000000a0a0a0a0a0a0a0a0a0a0a000000091a1a1a1a1a1a1a1a1b100a0a000
-- 071:717171717171717171717171d1d1d171717171a3a3d2d2d27171717171717171d2d2d2d2d2d271717171d3707071717171717171d37070a3a3a3a3a3717171b5b5b5b5b5b5a3a3a3a3b5b5b5b5b573b5b52370707070a3a3b5b5b5b5b5b5b5b570707073707070707070707070b5b5717171717171717171717121142114211421717171d5d5d5d5d5d5d53636f5e57171717171717171717171717171d57171717171717171717171717171717171717171717111e2322212c2212121c2322212c231118244a1a1a144a163a144a1b1000000c0a1a1a1a1a1a1a1a1a1a108b1000091a1b2a2a2a2a292a1b09082a1b1
-- 072:7171717171717171717171d1d1d1d1d1d2d2a3a3d2d2d2d2d2d271717171d2d2d2d2d2d2d2d2d2d1d1d370707070707070d3d37373737373737308731313737373b5b5b5d1a3b3a3a3a3a3a3b5b5737171b5b5b5b5a3a3a3b5b5b5b5b5b5b5b573737373b5b57070707070b5b5b5b5b571717170707171717171212121212121217171d563d5d5d5d5d5d53636f5e5e5d5d5717171717171717171d5d5d5d5d5717171717171717171717171717171717171717111c2300110e0216321c2300110183191a164a1743490a1a1a144a1b000000000a2a2a2a2a292a1b2a292a1b0a0a090a1b1000000009138a1a1a1a1b1
-- 073:717171717171717171707070d1d128d1d2d2d2a3d2d2d2d2d2d2d2d27171d2d2d2d2d2d2d2d2d1d1707070707070708070737373d3a3a3a3a3a3a3a37171d1d173b5b5d1d1a3a3b3b3a3a3a3a3b573081373737373b5a3a3b5b5b5b5b5b5b5b573b5b5b5b5b5c2c2c2c2c228b5b5b5b5131313807071717171712121c521212121131313f5f5f5f5d5263636e5f5e5e5d5d5d571717171717171d5d5d5d5e5e5717171717171717171717171717171717171717111c2c2e2e0e0c2c2c2c2c2c2e0c23191a1a108a1a1a1a1a18244a1a1c1000000000000000091a1b10091a1a1a1a1a1a1b10000000091a1b29282a1b1
-- 074:71717171717171d1707070e0d6c2d1d2d2d2d2a3d218d2d271d2d2d27171d2d2d2d2d2d2d2d2807070707373737373737373a3a3a3a3b3b3b3b3a3a37171d1d173d1d1d1d2a3a3a3b3b3b3a3a3b573717171b5b57373a3a3737373730873737373b5b5b5b5c2c2c271c2c2c2c2b5b5b571717070717171717171212121212121217171d5d5d5d5f5d5e53636e5f5d5d5d5d5d5d57171717171d5d5e5e5e5e5e5717171717171717171717171717171717171717111c2322212e0322212c2322212c23100a222a222a222a222a200a2a200000000000000000091a1b10091a1b2a2a2a2a200a0a0a0a090a1b100a2a200
-- 075:717171717171d1d1707171c2717171d2d2d2d2d2d2d2d2717171d2d2717171d2d2d2d2d2d2d17070d3d3137070d170a3a3a3a3b3b3b3b3b3b3b3b3a37171d1d173d1d1d2d2d2d2a3a3b3b3b3a3b573b5b5b5b5b5807070a370b5b5b5b5b5b5b5b5b5b5b5b518c2717171c2c2c2c2b5b57171717171717171717121142114211421717171d5d5d5f5e5e5f513f5f5f5f5f5f5d5d57171717171d5d5d5e5e5e571717171717171717171717171717171717171717111c2300110e0300110e0300110c23100a020a020a020a020a00000a0a00000000000a0a0a090a1b10091a1b0a0a0a0a090a1a1a1a1a1a1b100000000
-- 076:71717171717171c2c271717171717171d2d2d2d2d2d2d271717108d2d27171d2d2d2d2d228d170d3d3e313b670a3a3a3a3a3a3b3b3b3625242b3b3a37171d1d173d1d1d2d2d2d2d2a3a3a3a3a3b573b5b5b5b5b570a3a3a3d3c2c2c2c2c2c2c2c2c2c2c2c2c2c271717171c2c3c2c2c27171717171717171717171717171717171717171d5d5d5f5f5f5f536363636d5d5f5d5d571717171d5d5d5d5d5e5e571717171717171717171717171717171717171717111c2c2c2e0c2c2c2c238c2c2c228319143a144a1a1a1a1a1a1b1c0a1a1b100000091a1a1a1a1a1b10091a1a1a1a1a1a1a1a1a1a1a1a1a1b100000000
-- 077:71717171717171c2c2717171717171a3a3d2d2d2d2d2d2717171d2d1d17171d1d1d2d2d2d17070e3e3e313b6b6d2d2d2d2d2d2a3a3a3604540a3b3a37171d1d1737373731873737373737373737373b5b5b5b5b5a37023a3d3c2c2c2c2c2c2c3c2c2c2c2c2c3c2717171717171c2c2c2c27171717171717171717171717171717171717171d5d5d5d5363636d5d53636d5f5d5d5131313f5f5f5f5d5d5d5d571717171717171717171717171717171717171717111c2322212c2212121c2322212e03191a1a144a17454a184a1b0a054a1b100000091a1b2a292a1b10000a2a2a2a2a2a292a128a1a1b2a20000000000
-- 078:71717171717171c3c2c2717171a3b3b3a3d2707070d2d2717171d1d171717171d1d2d2d2d1d170e3e3e313e3e3d2d2d2d2d2d271d2d2d273a3a3a3707171d1d173d3d1d1d2d2d1d1d123b5b5b5b5b571717171b5a37070d3c2c271717171717171717171c2c271717171717171717171717171717171717171717171717171717171717171d5d5d5d536d5d5d5d5d53636f5d518d57171d5d5d5d5d526d5d571717171717171717171717171717171717171717111e0300110c2219521e2300110c23111a17490a1a1a1a164a1a108a1a1b100000091a1b10091a1b100000000a0a0a0a00092a1b2a200000000a0a000
-- 079:7171717171717171c2c271d2d2d2a3b3a3d270f270d2d2717171d1d171717171d1d2d2d2d2d170b6e3e313131373737373d27171d273737373d3d3707171d1d173d370a3a3a3a3a3a37070b5b5b57171717171a3a370c2c2c27171717171717171717171717171717171717171717171717171717171717171717171717171717171717171d5d5d5d536d5d5e526e5d536f5d5d5d5717171d5d5d5d5d5d57171717171717171717171717171717171717171717111e0e0c2c2c2212121e2e2c2c2c23191a1a1a1a1b292a1a1a1b292a1b20000000091a1b10091a1b0a0a0a090a1a1a1a1b191a1b100000000c0a1a1b1
-- 080:7171717171717171c2d2d2d2d2d2a3b3a3a3707070d271717171d2d1d17171d1d1d2d2d2d2d1b6b6b6e3e313e3d2d2d2137171d2d273d2d2737318731313737373a3a3a3c2c2c2a3a3a3a3a3a3a3a3717171a3a3a3c2c2c2c271717171717171717171717171717171717171717171717171717171717171717171717171717171717171d5d508d5d53636d5d5e5e5d536d5d57171717171d5d5d5d5d5717171717171717171717171717171717171717171717100222222222222222222222222220091242424b2a0902424b2009133b00000000091a1b0009118a1a1a1a1a1a1a182a1b191a1b1000000000092a1b1
-- 081:717171717171717171d2d238d2d2a37171a3d2d2d2d2717171d2d2d2d1d1d1d1d2d2d2d2d2d1b6b6b6e3e313e3d2717173d2d2d2d273d2d2d3d373a3717171c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2a3a3a3a3a3c2c2c2c2c27171717171717171717171717171717171717171717171717171717171717171717171717171717171717171d5d5d5e5e5e5363636d5d5d536d57171717171717171717171717171717171717171717171717171717171717171717100a0a0a000a0a0a0a0a0a0a000000011a1f4a16482a118a1b0a090a1a1b10000a090a1a1b100a2a2a2a2a292a1a1a1a1b191a1b0a0a0a0a0a090a1b1
-- 082:71717171717171717171d2d2d2d271717171c27070d2717171d2d2d2d2d2d2d2d2d2d2d2d2d2c2c2c2c2c213c2c271d1737313737373d2d2d270738070717180c2c3c2c2c2c2c271c2c2c3c2c2c2c228c2c2c2c2c2c2f1c271717171717171717171717171717171717171717171717171717171717171717171717171717171717171d5d5d5d5e50606e5e53636363636717171717171717171717171717171e5d5d5d57171717171717171717171717171717191a1a1a164a1a108a1d4a182b0000091a1a1a1a1a1a184a1a1a1a1a1a1310091a1a1a1a1b100000000000000a2a2a2a20091a1a1a1a1a1a1a1a1a1b1
-- 083:717171717171717171717113d271717171c2c2c2707070717171d2d2d2d2d2d2d2d2d2d2d2c2c3c2c280c213c3c271d1d2d2d2d2d2d2d2d2d2d173707071717171717171717171717171717171717171c2c271717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171d5d5d5d5e5e506060606060606717171717171717171717171717171e5e5d5e6d5d571717171717171717171717171717100a212a1a1a18284a1a1a1a1a1c1009171717171717144717171717163b100009282a1a1b100000000000000000000000000a2a2a2a2a2a2a2a2a200
-- 084:717171717171717171717113717171717171c2c2c2c27070717171212121d2d2d2717171717171c2c2c2711371717171d2d2d2d2d2d2d2d2d2d1817071717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171d5e5e5e5d5d5e5e50606060606717171717171717171717171717171e5e5e5d5d5d5d5717171717171717171717171717171000000a2a2a2a200a2a222a2a2000000a222a2a222a200a222a2a222a200000000a2a2a2000000000000000000000000000000000000000000000000
-- 085:71717171717171717171711371717171717171717171717171717121e42171717171717171717171717171717171717171717171717171717171717171717171c2c2c2c2c215717171717171717171717171717171717171717171717171717171717171d5d5d506161616161671717171717171717171717171717171717171d5d5d5e5363636d5d5e5e5d5d50671717171717171717171e5e5e5e5e5e5e536d518d5d5d5e5e571717171717171717171717171002020202020200320202020202000202020202020202020202020202000000000000000000000000000000000000000a0a0a0a0a0a0a0a0a0a00000
-- 086:71717171717171717171711371717171717171717171717171717121212171707070d1717171717171717171717171717171717171717171717171717171c2c280c2c2c2151505050571717171717171717171717171717171717171717171717171717171d5d506060616161616161671717171717171717171717171717171d5d5d5e5363636d5d5d5f5d5d5d57171717171717136e5e5d5e5e5d5e5363636e5d5d5d5d5e5e571717171717171717171717171110011d5d5d5e5f5e531000000003171717171713111c2c2310011000031417171717171717171717171717171610091a1a1a1a1a1a1a1a118a1b100
-- 087:717171717171717171717113717171717171717171d2d2d2717171717171717170d1d1d371717171717171717171717171717171717171717171717171e0c2c2c2c2c221212121210571717171717171057171717171717171717171717171717171717171d5d5d5d506061616161616160606717171717171717171d5d571717171d5e5e5e536e5e5d5f5d5d5717171060606d53636e5e5d5d5d536e536e5d5d5d5d5e5e5717171717171717171717171717171110002f5f5d5e5f5e53001200120317171717171310273c2300110012031417171717171717171717171717171610091a1a1b292a1b2a2a292a1b100
-- 088:7171717171717171717171137171c2c2c27171d2d2d2d2d2d27171717171717171d1f1d371717171717171137171717171717171717171717171c2c2e0e0c2c2c2252515151515210505050505057105050505057171717171717171717171717171717171d5d5d5d5d50606060606060606d5d5d5d57171717171d5d5d5d571717171d5d5e5e5e5e5d5f506067106060616060636e5e5e5d53636363636e5e5e5e5e57171717171717171717171717171717171112010d5f5f5f5f5f5f5f5f5f5d5317171717171301073c2c273c2733131417171717171717171717171717171610090a1b20091a1b1000091a1b100
-- 089:717171717171717171717113717171c280c2717171d2d2d2717171717171717171717171717171717171c21371717171717171717171717171c2c2c2e0e0e0c22525251515151521150505050505050505050580051313131313f0131313131313131313131313f5f5f5f5f5f506e508d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d57171d5d5d5e5e5e5e5d5f50606360616161616063636e5e5363663d53636e5363636363671717171717171717171717171717171110011d5f5d5d5f5d5d5d5f5d532317171717171717173737373c273313141717171717171717171717171717161c0a1a1b10090a1b0000090a1b000
-- 090:7171717171717171717171c2c27171c2c2c2717171717171717171717171717171717171717171717171c2c2c2c27171717171c2c2c2c2c2c2c2c2e0e02525252535252525251521151505050505050505151505057171717171717171717171717171717171d5d5d5d5d5d5f5e5e5e5e5d5d5d5d5d5d5d5d5d5d526d5d5d5d5d5d5d5d5d5d5d5d5d5d5f506d5360606161616060636e5e5e536363636363636e5e5e5e5e5717171717171717171717171717171110002f5f5d5f5f5f5d5d5f5f556317171717171717171c27373737330314171717171717171717171717171716100a2a20091a1a1a1b191a1a1a1b1
-- 091:71717171717171717171c2c3c2c213c2c2c271717171717171e071717171717171717171717171717171c2c2c2c3c2c2c2c2c2c2c2c2c2c2c2c21515252535353535353535252521151515050505050515151515157171717171717171717171717171717171d5d5d5d5e5e5f5e5e5e5e5e5d5d5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f508f5f5f5f5f5f5f5d5d536d506161616160636e53636363636e5e5e5e5e5e5e5e5e5717171717171717171717171717171112010e5f5d5f563f5d5d5f5d5303171717171717171c3c27363737373764171717171717171717171717171716100a0a00091a182a1b19182a1a1b1
-- 092:71717171717171717171c2c2c2c2717171c2717171717171e0e0717162524271717171717171717171717171c2c2c2c2c2c2c2c281c2051515151525253535353535353535256521656525252525252515151515057171717171717171717171717171717171d5d5e5e5e5e5f5e5e5e5e5e5d5d5d5d5d5d5d5d5d5d5363636363636d5d5d5d5d5d5d5d5d5e5e536d506161616160636e536e5e5e53636e5e5e5e5e5e5e5e57171717171717171717171717171711136363613e5f5f5f5d5f5f5f5d531717171717171c27373737373c33231416252425242717171717171717171619182a1b191a1a1a1b10092a1b200
-- 093:71717171717171717171c208c2c2717171717171717171e0e0c271716045407171717171717171717171717171c2c2c2c205051521150515151525253535353535353535258005050565252525353525252515151571717171717171717171717171717171d5d5e5e5e5e5e5d5e5e5e5e5e5d5d5d5d5d5d5d5d5d53636e5e5e5e536363613363636d5d5d5e53636d5061616161606363636e5e5e5e536e5e5e5e5e5e5e5e5717171717171717171717171717171112212361336e5e5e5326622662231717171717171c273c2c273c2c25631416093409340c3c2c3c2c2717171716191a1a1b191242424b10091a1b000
-- 094:7171717171717171717171c2c3c27171c3c27171717171c2e0c27171711371717171717171717171717171717171c205051515152115151515252535353535353535353525050563052121252525353535252505050571717171717171717171717171710606d5d5d5e5e5e5d5e5e5e5e5e5d5363636d5d5d5363636e5e5d5d5e5e5e5e5e5e536363636363636d5d50616161616063636e5e5e5e5e536363636e5e5e5e571717171717171717171717171717171110002f5f536363636310000000031717171717171c2e4c2326612c2303141c273c273c2c2c2c2c262526252426191a1a1b19114a114b10091a1a1b1
-- 095:7171717171717171717171c2c271717118c27171717171c3c2c2131313137171717171717171717171717171717171050505051521801515252525252525353535353535258005050565211515252525353525250505717171717171717171717171710616060606d5d5d5d5d5d5d5d5d5d5363636363636363646e5e5d5d5d5d5e5e5e5e506e5e5e5d5d5d5d5d5d506061616060636e5e5e5e5e5e5e5e5e536363636717171717171717171717171717171717100222222222222222222222222220022222222222222222222222222220041c273c273c2c2c2c2c260936093406191a1b20091a1a1a1b10091a1a1b1
-- 096:717171717171717171717171717171e0c2717171c3c271c2c2c2717171137171717171717171717171717171717171050505151521212121212121d02121253535353535252525056565211515052525252535250505050571717171717171717171710616160606d5d5d5d5d5d5d5d5d53636e5e536364646464646d5d5d5d5d5d5e5e5e5060606060606d5d5d5d506061616063636e5e5d5d5d5d5d5e5e5e5e5e57171717171717171717171717171717171710000a0a0a0a0a0000000202020202020202020202020202020202020200041c273c273c3c2c263c2c273c208736191a1b0a09014a114b0a090a1a1b1
-- 097:717171717171717171717171717171c2c2c213c2c2c271e0c2c271717113717171717171717171717171717171717105050505802115151525252525252535353535353535352525256521151505050505252525050505057171717171717171717106061616161606d5d5d5d5d5d5d5d53636e53636364646464646464646d5d5d5e5e5e50606161616060618060606061616063606e5e5d508d5d5d5e5e5e5e5e57171717171717171717171717171717171710091a114f614a1b10011a1a114a1a1a1a1310011300110a1a1a1a156003141c2737373737373737373737373c2619108a1a1a1a1a1a1a1a1a1a182b1
-- 098:71717171717171717171e0e071717171e0e071c2c27171e0c2c27171711371717171717171717171717171717171132121212121211515151525253535353535353535353535353525252121212121212121212121212105057171717171717171710606161616160606d5d5d506d5d5d5d53636360606d5d5464646464646464646d5e5e50616160606060606060606061616063606e5e5d5d5d5d571e5e5e5e5717171717171717171717171717171717171710091a1a1a1a1a1b10086a1a1a1a1a1a1a1300110a1a1a1a163a1a130203141212121c273c2c273c2c273c273c26100a2a292a114a114a1b2a2a2a200
-- 099:717171717171717171c3c2f1c27171717171717171717171e028c27171137171717171717171717171717171717171710505151505050515152535353535353535353535353535353525150515151521050505050505210505717171717171717171710606060606060606d5d50606d5d518d506060606d5d5d546464646464646464646e5060606063606060606d5d5061616063606e5e5e5d5d5717171717171717171717171717171717171717171717171710091a1a1a1a1a1b10011a1a114a1a1a1a1a1a1a1a1a1a1a1a1a1a1a156314121e421628342c273c262834283426100000091a1a1a1a1a1b100000000
-- 100:7171717171717171717171717171717171717171717171c2c2c2c2717113717171717171717171717171717171717171050505050505051515253535353535353535353535252525251505050515152105212121050521050571717171717171717171d5d5d5060606d5d5d57171060606d5d5d50606d5d5d5d5d5d54646464646464646464606060636d5d5d5d5d5d5061616063636e5e5e5d5d5717171717171717171717171717171717171717171717171710091a1a1a1a1a1b10000222222326612a1a1a1a1326612226612a1a1313141212121605040c273c260504050406100000000a292a1b2a20000000000
-- 101:717171717171717171c2c271717171717171717171717171c3c27171711371717171717171717171717171717171716505050505056565656525353535353535353535352525232515150505050515210521e4210505210571717171717171717171717171e5e5e5d57171717171d50606d5d5d50606d5e5e5e5e5e5e546464646464646464606063636d5e5d5d5d506061616060636e5e5e5e571717171717171717171717171717171717171717171717171710000a2a255a2a20000000000002222222222222222222222222222222200005252525252525255525252525252000000000000000400000000000000
-- 102:71717171717171717171c2c271717171717171717171717171717171711371717171717171717171717171717171716565056565656565656565353535353535353535352525d60515050505050515210521212105711371717171717171717171717171717171717171710606d5d50606d5d5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f51313363626d5d5d5d5d506161616160636e5e5e571717171717171717171717171717171717171717171717171717100a0a0a0a0a0a0a0a0a0a0a0a0a00000a0a000a0a0a0a0a0a00000a0a0000000000000a0a0a0a0a0a000000000000000000000000000000000000000
-- 103:71717171717171717171c3c271c2c271717171717171717171717171c2c2717171717171050571717171717171656565656565656565656565653535353535353535352525051505052525050505152105050571717121050571717171717171717171717171717171e5060606d5d5d5d5d5d5d5d5d5d5d5d5d5d5f5d5d5464646f546464646e536e5e5e5e5d5d5d506161616160636e5e5e571717171717171717171717171717171717171717171717171717100d5d5d5d5d0d5d5d5d5d5d5d5d5b102a1a164a1a118a1a1a1b190a1d4b10000a0a0907171717171a1b0a0a00000a0a0a0a0a0a0a0a0a0a0a0a0a000
-- 104:71717171717171717171717171c271717171717171c2c2c2c2c2c2c2c2c27171717171710505050505050505656565656565656565656565656535353535353535352525151515050525252525051521057171710505210505717171717171717171717171e5e5e5e506060606e5d5d5d5d5d5d5d5d5d5d5d5d5b20492d5d54646f5464646e53636e5e5e5e5d5d5d506061616160636e5e5717171717171717171717171717171717171717171717171717171710034343434a234343454d57454d5b1009208a1a184a1b292a144a1a1a1b100c0a1a1a17171717113a1a1a1a1c191a1a133a1a1a1a1a1a1a1a1a1a1c1
-- 105:717171717171717171717171717171c3c2c2c2c2c2c2c2c3c208e0e0e0e071717171717105050580050505056565656565656565656565086525253535353535252525151515150505050525252505137171252505052105057171717171717171717171d5d5d5d5d5e5e5e5e5e5e5d5d5d5d5d5363636363636b0a090d5d5462121214646e536e5e5e5e5e5d5d5d5d5061616160636e5e57171717171717171717171717171717171717171717171717171717191d5d5d5d544d5d508d5d5d5d5d5b10091a1a17491a1b090a164a1a182b10000a2a2927171717171a1b2a2a20091a1b2a2922424b292a1a1a1b2a200
-- 106:717171717171717171717171c2c2c218c2c2c2c2e0e0e0e0e0e071717171717171717171710505050505050505056565656565656565711371712525252525257171717115151515150505052525711371253525050521380571717171717171717171e5e5d5d5d5d5d5d5d5e5e5e5e5d5d5363636717171713636d5d5d5464621e4214646e536e5e5e5e5e5d5d5d5d5061616060636e5e57171717171717171717171717171717171717171717171717171717100a292d5d564d5d5b2343434343400009163a1a144a1a1a128a1a1a1a1b100a0a0a090a1b2a2a292a1b0a0a00091a1b0a091a1a1b191a1a1a1b10000
-- 107:717171717171717171c2c280c2c2c2c2c2c2c2e071717171717171717171717171717171717171050505050505656565651515717171711515156565656565656571717165651515151505050528712105253525050521057171717171717171717171d5e5e5d5d5d5d5d5d536363636363636717171717171713636d546464621212146e5e536e5e5e5e5e546d5d5d5060606063636e5e57171717171717171717171717171717171717171717171717171717100a0a054d5d5d5d544d5d5d5d5d5b100a034343490a184a1a1b292a1a1b19182a1a1a1a1b1000091a1a1a1a1b191a1a1a1b192a1b00092a1b2000000
-- 108:7171717171717171c2c3c2c2c2c2c2c2c2c2e07171717171c2c2c2c271717171717171717171712805050505651515151571717105151515156565656565656565657171656565651515150505710521052535352505210571717171717171717171e5e5e5e526d5d5361336363671717171717171717171717171364646464646464646e53636e5e5e5e5464646d5d50606063636e5e5717171717171717171717171717171717171717171717171717171717191d5d5d5d5b292d544d5b23492d5b191d4a1a1a1a1a144d4a1b191d4a1b19182a1a1b2a200a0a090a114a1a1b191a114a1b191a182b191a1b0a0a000
-- 109:7171717171717171c2c2c2c2c2c2c27171717171717153c2c2c263c2c27171717171717171717171717105151515717171710505151515156565656565656508656571716565656565651515717105210525353525052105717171717171717171e5e57171717171363613363636367171717171717136367171713646464646464646463636e5e5e5e54646464646d506363636e5e5e5717171717171717171717171717171717171717171717171717171717191d5b292d5b090d544d544d544d5b100a2a2a2a2a2a200a2a20000a2a20000a2a2a2000091a1a1a108a1a182b191a1a171b090a1a1b19008a17171b1
-- 110:717171717171717171c2c2c2c27171717171717171131313c2c238c2c27171717171717171717171717171711371710505050515151515656565656565656565656571717165656565656571710505210525352525052105717171717171717171717171717171e5e5e51336d5d5363671717171713636d53671713646464646464646e53636e5e5e546464646464606063636e5e57171717171717171717171717171717171717171717171717171717171717191d5b191d5d5d5d544d564d544d5b100000000000000000000000000000000a0a0a0000091a1b292a114a1a1b191a114717171a1b291a1a1a1a1a1b1
-- 111:717171717171717171c2c2c271717171717171717113717171c2c2c2c271717171717171717171712525050521050505050505151565656565656565656565656565657171656565212113132121212125253525050521057171717171717171717171717171e5e5e5e5f5d5d5d5d536717171717136d5d6d536713646464646464646e51313e5e5e54646464646060616f13636e57171717171717171717171717171717171717171717171717171717171717191d5b090d563d5d544d5d5d544d5b100000000000000000000000000000091a1a1a1b10090a1b091a1a1a1a1b191a1717171a1a1b10092a1b292a1b1
-- 112:717171717171717171c2c271717171717171717171137171717171c2c27171717171717171717125250505052105050505050515156565656565656571717171656565717165656565657171050580052535352505052105717171717171717171717171e5e5e5e5e5e5f5d5d5d5d53636717171363636f13671713636464646464606363636e546464646464606061616161636e5e571717171717171717171717171717171717171717171717171717171717191d5d5d5d5d5d5d544d5b23490d5b10000000000000000000000000000009182a1a1b090a1a1a1b1a292a1b20091a11471717171b1009071b191a1b1
-- 113:717171717171717171c2c271c27171717171717132041271717171c2c271717171717171717125250580050521212121212121212121216565656565717171656565717165656571717171050505052525353525050521057171717171717171717171e5e5e5e5e5e5e5f5d5d5d5d5d536367171713636363671717136364646464606360836464646464646060616161616162836e5e5717171717171717171717171717171717171717171717171717171717191d5b23454d584d544d544d5d528b100000000000000000000000000000000a292a1a1a1a163a1b10090a1b10091a1a1a1a1a171b1917171b191a1b1
-- 114:717171717171717171717171c2c271717171717130201071717171c2c271717171717171717171710505050505050505051815211515656565656571716565656565717165651371151515050505052535353525050521057171717171717171717171e5e5e5e5e5e5d5f5d5d5d5d5d5d536717171717171717171363636464646060636364646064646060606061616161616163636e5e57171717171717171717171717171717171717171717171717171717191d564d5d5d544d544d544d584d5b100000000000000000000000000000000a0a0a2a292a1a1a1b090a1a1b00000a2a2a292a1b20090a171b090a1b1
-- 115:7171717171717171717171c3c2c2717171717171717171717171c3c2717171717171717171717171710505050505050505151521151515156565657171656565656571717171131515151515050505253535352525628342717171717171717171717171e5e5e5e5d5d5f5d5d5d5d5d5d5363671717171717136363646464646460606364646060606060606d5d5161616161616163636e5e571717171717171717171717171717171717171717171717171717191d5d5d5a5d544d544d5b1a290d5b00000000000000000000000000000009182a1b0a00092a1a1a1a1a1a1a1b10000000091a1b191a1a17171a1a1b1
-- 116:7171717171717171717171c2c2c2c2c2c2717171717171717171c2c2717171717171717171717171711371710505050515151521151515151565717171656565656571717115151515151525250505253535353525605040717171717171717171717171e5e5e5d5d5d5f5d5d5d5d5d526d5363671717171713646464646464606060636464606d5d5d5d5d5d50606161616060606063636e571717171717171717171717171717171717171717171717171717191d5a5d5d5d544d564d5b191d5d5d5b100000000000000000000000000009143a1a1a1b090a1b2a292a1a1a1b10000a0a090a1b19163a1a1a1a1a1b1
-- 117:717171717171717171717171c228c2c2c27171c3c2c213c2c2c2c271717171717171717171717171710571717105050515151521151515151515717165656565657171711515151515152525150505253535353525717171717171717171717171717171e5e5d5d5d5d5f5d5d5d5d5d5d5d5463636363671713646464646460606160636464606d53636363636360606060606d5d5d5d536e571717171717171717171717171717171717171717171717171717191d5d5d5b2a29118d5d5b191d580d5b100000000000000000000000000009182a1a1a118a1a1b10091a1a1a1b100c0a1a118a1b100a2a29243a182b1
-- 118:717171717171717171717171717171c2c271c2c2c27171c2c27171717171717171717171717171710505717171710505151515210515151515717171656565656571717115151515252525151505050571717171717171717171717171717171717171d5d5d5d5d5d5d5f5d5d5d5d5464646464646463636363646464646460616060636464606d5360606061836360606d5d5d5d5d5d536e571717171717171717171717171717171717171717171717171717100a2a2a2000000a2a2a20000a2a2a200000000000000000000000000000000a2a2a2a2a2a2a2000000a2a2a2000000a2a2a2a20000000000a2a2a200
-- 119:717171717171717171717171c271717171717171717171717171717171717171717171717171710505717171717171051505052115051515157171716565656565717171717113717171717171050571717171717105050505057171717171717171d5d5d5d5d5d5d5d5f5f5f5f5f5464646464646464646464646464606060616063636460606d536363606d5d5360606d5d5d5d5d5d536e5e57171717171717171717171717171717171717171717171717171000000a00000a0a0a0a0a0a0a0a00000000000a0a0a000a0a0a0a0a0000000a0a0a0a0a0a0a0a0a0a0a0a0a00000a0a0a0a0a0a001a0a0a0a0a0a000
-- 120:717171717171717171717171c2c27171717171717171717171717171717171717171717171717113717171717171710515140521151405151571717171656565657171717171137171717171717171710505712505050505f105717171717171717136d5d5d5d5d5d5d5d5d5d5d5f54646464646464646464646464606061616060636d54606d5d5d5363606d5d5360606d5d5d5d5d5d536e5e5717171717171717171717171717171717171717171717171717100009021b0902121212121212121b100a0a091212121442121f62121b1009121212144212121214421210821b191a1a1a1a1a1a1a1a1a1a1a1a182b1
-- 121:71717171717171717171717171c2c2717171717171717171717171717171717171717171717171050505717171717105051505210515150505717171716565656571717171711371717171717171717105052525250505717171717171717171717136363636d5d53636d5d5d5d5f54646464646464646460606060606161616063636464606d5d5d5d53606d5d536d5d5d5d5d5d5d5d53636e571717171717171717171717171717171717171717171717171710091212121212184212184070721b19021216421a521442121212121b1009121711364137171136413718221b141a1a1a1a1a114a114a1a1a1a18261
-- 122:7171717171717171717171717171c271c2c271717171717171717171717171717171717171717171050571717171717105140521051405057171717171656565651571717171137171717171717171050515152525150571717171717171717171717136363636363636d5d5d5d5f54646464646464646060616161616161606363646460606d5d536363606d53636d5d5d5d536d5d5d536e5e5e57171717171717171717171717171717171717171717171717100912121b29221b03434910707214421212121212121442121382121b1009171711313137171131313717121b141a1a1a1a1a1a1a1a1a1a1a1a1a161
-- 123:71717171717171717171717171717171c3c2c2717171717171717171717171717171717171717171710571717171717105050521051515717171717171716565651515717171137171717171717105151515717171157171717171717171717171717171717171363636d5d5d5e5f5464646464646460606161616161616060636d5d54606d5d536360606060636d5d5d5d5363606d53636e5e5717171717171717171717171717171717171717171717171717100005421b09021212121640707216421212121842121b1345421b2a200009113717171717171717171717121b141a162525242a1d4a162525242a161
-- 124:717171717171717171717171717171717171c27171717171717171717171717171717171717171717113717171717171051405210514157171717171717165656515151515151315c2c2c2c2131315151571717115157171717171717171717171717171717171713636d5d5e5e5f546464606060606061616161616160606363636d50606363636060616063636d5d5d5d53606060606e5e57171717171717171717171717171717171717171717171717171710091212121212184070707070718212121212144212144212121b1a0a000917171743454822174a234547121b141a16100000052525200000041a161
-- 125:7171717171717171717171717171717171717171717171717171717171717171717171717171717171137171717171713222220422221271717171717171651515181515c2c2c2e2e2c2c271710505051515151505717171717171717171717171717171717171713636d5e5e5e5f5f5f5f5f5d0d50616161616161606060606063636363636060606161606360606d5d5d536060606e5e5717171717171717171717171717171717171717171717171717171710091212174922144210707070721b2a292212144212144212121442121b19121212121212121216471212121b141a16050505050505050505040a161
-- 126:717171717171717171717171717171717171c2c27171717171717171717171717171717171717171711371717171717131000000000011717171717171717115c2c2c2c2c2c2e2e2c2c2c271c20505c2c2c2c2c20505717171717171717171717171717171717136363636e5e5e5e5e5e5e50606060616161616160606161616060606060606061616161606363606063636360606167171717171717171717171717171717171717171717171717171717171710091212121b0a290212107070721b0a0a0922144212144218421442121b19134343454147113711471717174b141a1a1a1a1a1a163a1a1a1a1a1a161
-- 127:717171717171717171717171717171717171f1c2c27171717171717171717171717171717171717171f07171717171713100000000001171717171717171717171c2c2c2c2c280c2c2e27171c2c2c2c271717180c27171717171717171717171717171717171363636363636e5e5e5e5e5060606061616161616161616167116161616161616161671711606063636363606060616167171717171717171717171717171717171717171717171717171717171710091212121216421082121070721212121442164212144214421442121b10221137171717171717171137121c1005252525242a1a1a1625252525200
-- 128:717171717171717171717171717171717171717171717171717171717171717171717171717171717113717171717171302020202020107171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171713636363636363636e5e50606060616161616161616717171717171717171717171717116160606060606161616167171717171717171717171717171717171717171717171717171717171717100912121a5212121218421070721b2922144282121b2912164216421b2009154717171142113211471717174b100000000000042a162000000000000
-- 129:7171717171717171717171717171717171717171717171717171717171717171717171717171717105137171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171363636363606161671717171717171717171717171717171717171717116161616161616717171717171717171717171717171717171717171717171717171717171717171710091212121218421b29021070721b09121442174a2a0902121212121b1009171717171212121212121717171b100505050505040a160505050505000
-- 130:717171717171717171717171717171717171717171717171717171717171717171717171717171050505057171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171713636367171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171009121b2922144214421210707212164214421214421212184217434a0009143211471217434343434343434b141a1a1a1a1a1a108a1a1a1a1a1a161
-- 131:717171717171717171717171717171717171717171717171717171717171717171717171717171050505057171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171009121b090214421442121070707212121442121642174349021212121b19121217171212121212121212182b141a1a1624214a1a1a1146242a1a161
-- 132:7171717171717171717171717171717171717171717171717171717171717171717171717171717171a60571717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171710091212121214421442121210707212121442121212121212121745421b19121217171717171712121212121b141a1a16141a1a1a1a1a16141a1a161
-- 133:7171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171710091218421749021442121210707212121b09221217454218421212121b19182217434343434343454212182b141a1a1604014a1d4a1146141a1a161
-- 134:717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171009121442121212144212121070707212121b1922121212144212121b2009163212121211821212121212121b141a1a1a1a1a1a1a1a1a1614182a161
-- 135:7171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171710000a200a2a2a2a200a2a2a2000000a2a2a20000a2a2a2a200a2a2a2000000a2a2a2a2a2a2a2a2a2a2a2a2a200005252525252525252525252525200
-- </MAP>

-- <MAP1>
-- 000:e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0e0e0e0e0e0e0e0e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0e0e0e0e0e0e0e0e0e0e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0e0e0e0e03222222212e0e0e0e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e1e1e1e1e1e1e1e1e1e1e1e1e0e1e1e0e0c2c2e0e0e03100000011e0e0e0e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:e1e1e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0e0e0e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e1e1e1e1e1e1e1e1e0e0e0e1e1e1e0e0c2c2c2e03100000011c2c2c2e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:e1e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2c2c2c2e0e0e1e1e0e0e0e0e0e0e0e0e0e0e0e1e1e1e0c2c2c2c23020032010c2c2c2e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:e1e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e0c2c2c2c2c2c2c2c2c2e0e1e1e1e0c2c2c2c2c2c273c2c2c2c2c2e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e0c2c2c2c2c2c2c2c2c2e0e1e1e1e0c2c2c2c2e2c273c2c2e0c2c2e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2c2c2c2c2e0e0e0c2c2c2c2c2c2c2c2c2e0e0e1e0e0e0e0c2c2e2e273c2c2c2c2c2e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e1e0e0c2e2e273c2c2c2c2c2e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e0e0e0e1e1e0e0e0e0c2c2c2c2c2c2c2e0e0c2c2c2e0e0e1e1e0e0c2c2c2c2c2e2e2e2c2c2c2c2c2c2c2c2c2e0c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e1e0c2c2e2e273c2e2e2c2c2e0e0e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e0e0e1e1e1e0c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2e0e0e1e1e1e0c2c2c2c2c2c2c2e2e2e2c2c2e0c2c2c2c2c2e0c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e0e0c2c2737373c2e2e2c2e0e0e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e0c2c2c273c2c2c2c2c2e0e0e0e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e0c2c2c273e0c2c2c2c2e0e0e0e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e0e0c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2c2c2c2c2e0e0e1e1e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e0c2c2c273c2c2c2e0e0e0e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e0e2c2c273c2c2e0e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2e0e0e0e1e1e1e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e0e2c2c273c2e0e0e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 017:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c3c2c3c2c3c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e0c2c2c273c2e0e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c271717171c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e0c2c2c273c2e0e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c3c271637071c2c3c2c2c2c2c2e1e1e1e0c2c2c2c2c2e0c2c2c2c2e2e2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e0c2e0e273c2e0e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c271137171c2c2c2c2c2e0e0e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2e2e2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e0c2c2e273c2e0e0e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 021:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c3c2c3c2c3c2c2c2e0e0e1e1e1e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0c2c2c273c2c2e0e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e1e1e1e1e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e0c2c2c273c2c2e0e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0c2c2e2c2e2e2c2c2c2e0e1e1e1e1e1e1e0c2c2e0e0e0e0e0e0e0e0e0e0c2e0e0e0e0e1e1e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e0e0c2c2c2c2c2c2e0e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e2c2c2e2e2c2c2c2e0e0e0e0e1e1e1e0e0e0e0e1e1e1e1e1e1e1e1e1e0e0e1e1e1e1e0e0c2c2c2c2c2e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e0c2c2c2c2c2c2c2e0e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e2e0e0c2c2c2c2c2e0e1e1e1e1e0e1e1e1e1e1e0e0e1e1e1e0e1e1e0e1e1c2e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0e0c2c2c2e2e2c2c2e0e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e1e1e1c2c2c2c2e0e0e0e1e1e1e1e0e0e0e0e0e0e0e0e1e1e1e1e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0e0c2c2c2c2e2e2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0e0c2c2c2c2c2c2e0e0e0e0e0c2c2c2c2c2c2c2c2e0e0e1e1e1e1e0e0c2c2c2c2e2e2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e0e0c2c2c2c2e2e2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0c2e0e0e0c2c2c2c2c2e2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e1e1e1e0c2c2c2e2e2e2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0c2c2e0c2c2c2c2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e0c2e2e2c2c2c2c2e0c2e2c2c2c2c2e0e0e0c2c2c2c2c2c2e2c2c2c2c2e0e0e0e1e0c2c2c2c2e2e2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0e0e0c2c2c2c2c2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e0e2c2c2c2c2c2c2c2c2e2c2c2c2e0e0e1e0e0c2c2c2c2c2e2e2e2c2c2c2c2e0e1e0e0c2c2c2e2e2c2c2c2c2e0e1e1e0c2c2c2c2c2c2c2c2c2e0e0e1e1e1e0e0c2c2c2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0e2c2c2c2c2c2e0c2c2c2c2c2e0e0e1e1e1e0e0c2c2c2c2c2e2c2c2c2c2c2e0e1e1e0c2c2c2c2c2c2c2c2e0e0e1e1e0c2c2c2c2c2c2c2c2c2e0e0e1e1e1e0e0c2c2c2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e1e1e0e0c2c2c2c2c2c2e0c2c2c2e0e1e1e0c2c2c2c2c2c2c2c2e0e1e1e1e0e0c2c2c2c2c2c2c2c2c2e0e1e1e1e0e0c2c2c2c2c2e0e0e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 033:e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0c2c2c2e2e2e2c2c2c2c2c2c2e0e0e1e1e1e1e1e0e0c2c2c2c2c2c2c2c2c2e0e0e1e1e0c2c2c2c2c2c2c2c2e0e1e1e1e1e0c2c2c2c2c2c2c2c2c2e0e1e1e1e1e0c2c2c2c2c2e0e0e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 034:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2e2e0e0e0e2c2c2c2c2e0e0e1e1e1e1e1e1e1e0c2c2c2c2c2c2c2c2c2e0e1e1e0e0c2c2e0c2c2c2c2e0e0e1e1e1e0e0c2c2c2c2c2c2c2c2c2e0e1e1e1e0e0c2c2c2c2c2e0e0e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 035:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0c2c2c2c2e0e0e1e0e2c2c2e2c2e0e1e1e1e1e1e0e1e1e0c2c2c2c2c2c2c2c2c2e0e1e1e0c2c2c2c2c2c2c2c2e0e1e1e1e1e0c2c2c2c2c2c2c2c2c2c2c2c2e0e0e0e0c2c2c2c2c2e0e0e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 036:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0c2c2c2e2e0e0e1e1e1e0e0e0e0e0e0c2c2c2c2c2c2c2c2c2e0e1e1e0c2c2c2c2c2c2c2c2e0e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2e0e0c2e0c2c2c2c2c2e0e0e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 037:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e0c2c2e2e0e0e1e1e0e0e0c2c2c2c2c2c2c2e0c2c2c2c2c2e0e0e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 038:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0e0c2c2e0e0e1e1e1e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e1e1e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 039:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e0e0e2e0e0e1e1e1e0e0c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 040:e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e1e1e1e0e0e0e1e1e1e0e0c2c2c2c2c2c2e2c2c2c2c2c2c2c2c2e0e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 041:e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e0e0e1e1e1e1e1e1e0e0e0c2c2c2c2c2c2c2e2e2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 042:e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 043:e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 044:e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 045:e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 046:e1e1e1e1e1e1c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1c2c2c2e1e1e1e1e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 047:e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1c2c2c2c2e1e1e1e1e1e1e1e1e1e1e1e1e1e1c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2e1e1e1e1e1c2c2c2e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 048:e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 050:e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP1>

-- <MAP4>
-- 000:101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:1010101010101010101010101010101010101010101010101010101010100000000000000000000000e4000000000000000000000000000000e400001010101010101010101010101010101010101010101010101010101010100000000000000000000000e4000000000000000000000000000000e40000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:101010101010101005251010101010101010101010101010101010101010000000000000000000000000000000000000000000000000e40000000000101010101010101005251010101010101010101010101010101010101010000000000000000000000000000000000000000000000000e40000000000909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:101010101010100515152510101010101010101010101010101010052510000000000000e40000000000000000000000e40000000000000000000000101010101010100515152510101010101010101010101010101010052510000000000000e40000000000000000000000e4000000000000000000000095959595959595d5a595959595959595959595d5a59595d5a5959595959595959595959595d5a595959595959595959595d5a59595d5a59595959595000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:1010052510100515151515251010101010101010101010101010051515250000000000000000000000000000000000000000000000000000000000001010052510100515151515251010101010101010101010101010051515250000000000000000000000000000000000000000000000000000000000009595d5a59595d55353a59595959595959595d55353a5d55353a5959595959595d5a59595d55353a59595959595959595d55353a5d55353a595959595000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:10051515250515151515151525101005251010101005251010051515151500000000000000000000000000000000000000000000e40000000000000010051515250515151515151525101005251010101005251010051515151500000000000000000000000000000000000000000000e40000000000000095d55353a5d553535353a5959595959595d55353535353535353a595959595d55353a5d553535353a5959595959595d55353535353535353a5959595000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:0515151515151515151515011125051515251010051515250515151515150000000000000000000000455500000000e400000000000000e4000000000515151515151515151515011125051515251010051515250515151515150000000000000000000000455500000000e400000000000000e400000000d553535353535353535353a5a3b3c3d3d553535353535353535353a59595d553535353535353535353a5a3b3c3d3d553535353535353535353a59595000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:15151515150111151515012121111515151525051515801515b01515151500000000004555000000456565550000000000000000020000320000e40015151515150111151515012121111515151525051515801515b01515151500000000004555000000456565550000000000000000020000320000e400535353535353c05353d05353a4b4c4d4535353122253535353535353a595535353535353c05353d05353a4b4c4d4535353122253535353535353a595000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:151515150121211115012121212111151515151515158191a1b1636373630000000045656555004565656565550000000000000003132333e0f0e0f0151515150121211115012121212111151515151515158191a1b1636373630000000045656555004565656565550000000000000003132333e0f0e0f0531222535353d2c1d1e2535353b5c55353531221215422535353535353a5531222535353d2c1d1e2535353b5c55353531221215422535353535353a5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:011115012121212131212121212121424141414141418292a2b2646464744555004565656565756565656565657161616161616104142434e1f1e1f1011115012121212131212121212121424141414141418292a2b2646464744555004565656565756565656565657161616161616104142434e1f1e1f112212154e3c28292a2b253535353535353122121212121e3c2c2c2c2c2c212212154e3c28292a2b253535353535353122121212121e3c2c2c2c2c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:202020202020202020202020202020205050505050504040404040202020353535353535353535353535353535358485844484443535353535353535202020202020202020202020202020205050505050504040404040202020353535353535353535353535353535354485854485443535353535353535308383a03030a030a08383a051606051a03083a030303083a0308330833093709370939383939370f483e5f5f5e530f4839370837083838393703093000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:30307030303030833083833083303083303030308330833083303083303044448585448444844484444485448544854485448544448444448544854430303030703030703030303030307030303070303030308330307030307044444444854444448544444444444444854444444485444444444444448583a0707030708370707070a070a0a070a03070708383a03083708370a0709330303030f4703030833070f4f4f430f430833030f43030303083703083000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:303083838330833083833070303083303083303070303083303083307030444485858544854444448544448584444484854444858544854444448544307030303070307030308370303030308370303030703030703030308330444444444444444444444485448544444444444444444485444444444444703070707070837070a08370703083837070307070708383707070707070933083303083308330f430303070f43030308383303030308330f4308393000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:308393309330703030708330937030303070309330833093938383939330448572444444847272728472448544727244447244857272448572844444309330833093933030933070938330933030309330703070309370303070854472727244728544724444447244447244447272444444727272444444708370837070707083707030838370707070837070707070708330707070833030703070307030703030839330308370703030307030303030833093000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:309393308393839393938393938393933093938393939393939393939370448472728544447272727272727272844472857285728572727244727244709330939330703093303030939393937030939330309330938393937093448572728544727244444472444472728544724485727244727244724485707030709393307070837093839393709393939370837093939393939393939393933070303083308330309330307093939393303030309393938393000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:309393939330933093939370939383939383833093933093937030838393447272727284727244847272727244727272724472727272847272727244309393309393939330709393939393939330939370939393933093937030447272447272727272447285448544724472727272444472444472447272939393939393939393708370939393933070939393707093939393939393938393309393938330939393839393939330939393703093937093939393000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:939393939393939393939393939393939393939393939393939393939393727272727272727272727272727272727272727272727272727272727272939393939393939393939393939393939393939393939393939393939393727272727272727272727272727272727272727272727272727272727272939393939393939393939393939393939393709393939393939393939370939393939393939393939393939393939383939393939393939393939370000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e40000000000e40000000000000000000000000000000000000000000000e40000000000e40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:0000000000000000000000000000000000000000ac000000000000000000000000000000000006162636465666768696a6b6c6d6e600000000000000000000e4000000000000000000000000000000000000e400000000e40000000000e4000000000000000000000000000000000000e400000000e40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 021:000000000000000000000c1c2c3c4c5c6c7c8c9c00000000000000000000000000000000000007172737475767778797a7b7c7d7e700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:000000000000000000000d1d2d3d4d5d6d7d8d9d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e40000000000000000000000000000000000000000000000000000000000e400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:000000000000000000000e1e2e3e4e5e6e7e8e9eaf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e4000000000000e400000000000000000000000000000000000000000000e4000000000000e40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:000000000000000000000000000000000000000000000000000000000000000000000000000008182838485868788898a8b8c8d8e800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:000000000000000000000000000000000000000000000000000000000000000000000000000009192939495969798999a9b9c9d9e90000000000000000e400000000e4000000000000000000000000000000000000e40000000000e400000000e4000000000000000000000000000000000000e400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:00000000000000000000000000000000000000000000000000000000000000000000000000000a1a2a3a4a5a6a7a8a9aaabacadaea0000000000000000000000000000000000000000000000e40000000000000000000000000000000000000000000000000000000000e400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:00000000000000000000000000000000000000000000000000000000000000000000000000000b1b2b3b4b5b6b7b8b9babbbcbdbeb000000000000000000000000000000adbdcddded00000000000000000000000000000000000000000000000000adbdcddded0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aebecedeee00000000000000000000000000000000000000000000000000aebecedeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000448484444484444343434343434384448485858584858584858584858485444444444444444343434343434344444444444444444485444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444448544444485444444444444448544448444844444448444448585854472727244728544844444447244447244447272444444727272444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444444444444444444485448584444444844444444485444444448585448572728544727244444472444472728544724485727244727244724485000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000447272447272727272447285448544724472727272444472444472448484447272447272727272447285448544724472727272444472444472447244000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 033:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000727272727272727272727272727272727272727272727272727272728484727272727272727272727272727272727272727272727272727272727284000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP4>

-- <MAP5>
-- 004:0000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f20000000000000000
-- 005:00000000000000e33030203030303030303030303020f30000000000000000000000000000e33030303030303030303030303030f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e30808080808080808080808080808f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e37070707070707070707070707070f300000000000000
-- 006:00000000000000e33030303030203030303010303030f30000000000000000000000000000e33020303030303020303010303030f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e30808080808500808080808080808f30000000000000000000000000000e350505050c0d05050c0d050505050f30000000000000000000000000000e35050505050505060508090505050f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e37070707070707070707070707070f300000000000000
-- 007:00000000000000e33020303030303020303030302030f30000000000000000000000000000e33030303030031323333030302030f30000000000000000000000000000e35050505050607080905050505050f30000000000000000000000000000e30808080808081828380808080808f30000000000000000000000000000e350505050c0d0c0d0c0d050505050f30000000000000000000000000000e35050505050505061718191a1b1b1f30000000000000000000000000000e35050505050081828385050505050f30000000000000000000000000000e35050505050607080905050505050f300000000000000
-- 008:00000000000000e30101011121310101010101010101f30000000000000000000000000000e30101010101041424340101010101f30000000000000000000000000000e3a1a1b1a1a161718191a1a1a1b1a1f30000000000000000000000000000e35049594959091929394959495950f30000000000000000000000000000e350505050c1d1c1d1c1d150505050f30000000000000000000000000000e35050505050505062728292a2b2b2f30000000000000000000000000000e35050505039091929393950505050f30000000000000000000000000000e3e1b1e1b1e161718191e1b1e1b1e1f300000000000000
-- 009:00000000000000e30000001222320041510000000000f30000000000000000000000000000e30000000000051525350000000000f30000000000000000000000000000e3a2a2b2a2a262728292a2a2a2b2a2f30000000000000000000000000000e3404a5a4a5a0a1a2a3a4a5a4a5a40f30000000000000000000000000000e350505050c2d2c2d2c2d250505050f30000000000000000000000000000e350c3d35050a0b0b0b0b0b0b0b0b0f30000000000000000000000000000e3e0e0e0e03a0a1a2a3a3ae0e0e0e0f30000000000000000000000000000e3e2b2e2b2e262728292e2b2e2b2e2f300000000000000
-- 010:00000000000000e30000000000000042520000000000f30000000000000000000000000000e30000000000061626360000000000f30000000000000000000000000000e36464646464646464646464646464f30000000000000000000000000000e36464646464646464646464646464f30000000000000000000000000000e3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f30000000000000000000000000000e393a3a3b3c3d3a0b0b0b0b0b0b0b0f30000000000000000000000000000e3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f30000000000000000000000000000e36565656565656565656565656565f300000000000000
-- 011:00000000000000e30000000000000000000000000000f30000000000000000000000000000e30000000000071727370000000000f30000000000000000000000000000e36464646464646464646464646464f30000000000000000000000000000e36464646464646464646464646464f30000000000000000000000000000e3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f30000000000000000000000000000e3a3a3a3a3a3a3b3b0b0b0b0b0b0b0f30000000000000000000000000000e3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f30000000000000000000000000000e36565656565656565656565656565f300000000000000
-- 012:0000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f40000000000000000
-- 021:0000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f200000000000000000000000000000000f2f2f2f2f2f2f2f2f2f2f2f2f2f20000000000000000
-- 022:00000000000000e33030302030303030303030303030f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e33030303030303020303030303030f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e39494949494949494949494949494f30000000000000000000000000000e35050505050505050505050505050f300000000000000
-- 023:00000000000000e33030303030303030303030303020f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e33030302030303030301030303030f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e39494949494949494949494949494f30000000000000000000000000000e35050505050505050505050505050f300000000000000
-- 024:00000000000000e33030303030455555453030303030f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e33030303030302030303030302030f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e35050505050607080905050505050f30000000000000000000000000000e35050505050505050505050505050f30000000000000000000000000000e39494949494949494949494949494f30000000000000000000000000000e35050505050081828385050505050f300000000000000
-- 025:00000000000000e30101010101465666760101010101f30000000000000000000000000000e350505050500b1b2b3b5050505050f30000000000000000000000000000e30101010101010101010101010101f30000000000000000000000000000e3507b7b8b8b4b5b6b7b8b8b7b7b50f30000000000000000000000000000e350a1b1a1b161718191b1a1b1a150f30000000000000000000000000000e350a969a9a969798999a9a999a950f30000000000000000000000000000e39494949494949494949494949494f30000000000000000000000000000e35050505039091929393950505050f300000000000000
-- 026:00000000000000e30000000000475767770000000000f30000000000000000000000000000e350506363500c1c2c3c5063635050f30000000000000000000000000000e3b0b000b0b0b0b0b0b0b0b0b0b0b0f30000000000000000000000000000e3507c7c8c8c4c5c6c7c8c8c7c7c50f30000000000000000000000000000e3e0a2b2a2b262728292b2a2b2a2e0f30000000000000000000000000000e3e0aa6aaaaa6a7a8a9aaaaa9aaae0f30000000000000000000000000000e34d0d4d4d4d0d1d2d3d4d4d4d3d4df30000000000000000000000000000e3585858583a0a1a2a3a3a58585858f300000000000000
-- 027:00000000000000e30000000000007383000000000000f30000000000000000000000000000e3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f30000000000000000000000000000e3b0b000000062728292a2b2a2b2a2f30000000000000000000000000000e3f1f1f1f1f1f1f1f1f1f1f1f1f1f1f30000000000000000000000000000e3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f30000000000000000000000000000e37575757575757575757575757575f30000000000000000000000000000e34e0e4e4e4e0e1e2e3e4e4e4e3e4ef30000000000000000000000000000e36868686868686868686868686868f300000000000000
-- 028:00000000000000e30000000000007484000000000000f30000000000000000000000000000e3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f30000000000000000000000000000e3b0b0b0b0b0b0b0b0b0b0b0b0b0b0f30000000000000000000000000000e3f1f1f1f1f1f1f1f1f1f1f1f1f1f1f30000000000000000000000000000e3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f30000000000000000000000000000e37575757575757575757575757575f30000000000000000000000000000e34848484848484848484848484848f30000000000000000000000000000e36868686868686868686868686868f300000000000000
-- 029:0000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f400000000000000000000000000000000f4f4f4f4f4f4f4f4f4f4f4f4f4f40000000000000000
-- 034:00000000000000000000000000000000000000000071711371710000000000b3b3b3b3b3b300007070d1d10000000000d1d1d170707070707070707070707070707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2c2e0c2c2c2e0c2e20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000202020202020202020202020202020202020202003202020200000
-- 035:0000000000000000000000000000000000000000002370737023000000000000b3b3b3b3b3b3007070d1d100000000000000d170707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2c2e0e0c2e0e0c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011311121322212213100117170703100000011702121217070703100
-- 036:00000000000000000000000000000000000000000071711371710000000000000000b3b3b3b3000070d1d1d1d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2c2c213c2c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011311121300110703001107171713020012010237021212370703100
-- 037:0000000000000000000000000000000000000000000000730000000000000000000000b3b3b3b30070d1d170d1d1d1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2c2c213c2c2c2e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011310221212121707070707071717171137171707021217070703100
-- 038:00000000000000000000000000000000000000000000007300000000d3d3d30000000000b3b30000d1d1d1d1d170d10000000000000000000000000000000000000000000000000000000000000062524200000000000000000000000000000000d1d100000000000000000000000000000000000000000000000000000000000000000000000000e0e0c2c2c2c2c2e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011311121212121217070707071717171137171707070217023703100
-- 039:0000000000000000000000000000000000000000000000730000000000d3d3000000000000b3b30000d1d1d1d1d1d10000000000000000000000000000d2d2d2d2d2d2d2d2d2d1d1d1d1d1000000610041000000000000000000000000000000d1d1d100000000000000000000000000000000000000000000000000000000000000000000000000e0e0c2c2c2c2c2e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011321221321221217063707071717171137170707070212170703100
-- 040:000000000000000000000000000000000000000000000073737373737373d3000000000000b3b3b30000d1d1d1d1c20000000000000000d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d1d1d1d1d1d1d1c26093400000000000000000000000000000d1d100000000000000000000000000000000000000000000000000000000000000000000000000000000e0c2c2c2c2c2e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011311121310221217070707070717171137170707070212121213100
-- 041:00000000000000000000000000000000000000000000000000000000007300000000000000b3b3b3b300d1c2c2c20000000000d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d1d1d1d1c2c3c273c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2c2e213e2c2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011311121301021212113131313131313131313212121213222223100
-- 042:00000000000000000000000000000000000000000000000000000000007300000000d10000b3b3b3b300c2c2000000000000d2d2d1d1d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2737373737373737373131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001313c21313e2c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011310221212121212170237070717171717021212121213001203100
-- 043:00000000000000000000000000000000000000000000000000000000007300d1d1d1d100b3b3b3b3b300c200000000000000d270f370d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d273d1d1d1c2c2c2c253c20000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d1d1000000000000000000000000c2c2c2c2e200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011311121322212212121707071717171707021213212212121213100
-- 044:000000000000000000000000000000000000000000000000d3d3d300007300d1c2c2c200b3b3000000000000000000000000d2d17070d2d2d2d2d273737373737373d2d2d2d2d2d273d1d1c2c3c2c2c2c20000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d1d1d1d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011301021300110532121707071717170702121213102212121213100
-- 045:00000000000000000000000000000000000000000000000000d3d372007300c2c2c2c20000000000000000000000000000d2d2d2d2d2d2d2d2d2d273d2d2d2d2d273d2d2d2d2d27373d2d2c2c2c2c3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000d1d1d1d1d1d1d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011212121212121212121707171717170702121213010217070703100
-- 046:00000000000000000000000000000000000000000000000000d3d3d3d3d3c2c2c2c3c2c200000000000000000000000000d2d2d2d2d2d2d2d2d2d273d2d2d2d2d273d2d2d2d2d273d2d2c2c2c2c200000000000000000000000000000000000000d1d1d1000000d1d100000000000000000000000000000000d1d1d1d1d1d1d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011707072702121212121131313131313212121212121217023703100
-- 047:0000000000000000000000000000000000000000000000000000d3d3d3d37070c2c2c280c2000000000000000000000000d2d2d2d2d2d2d2d2d2d273d2d2d2d2d273d2d273737373d2d20000000000000000000000000000000000000000000000d1d1d1d100d1d1d1000000000000000000000000000000000000d1d1d1d1d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011707070702121212170707171717270212121213212217070703000
-- 048:00000000000000000000000000000000000000000000000000000000d370707070c2c2c2c2c20000000000000000000000d2d2d2d2d2d2d2d2d2d273d2d2d2d2d273737373d2d2d2d200000000000000000000000000000000000000000000000000d1d1d1d1d10000000000000000000000000000000000000000000000d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000117072707021212121707071717170702121212131022123707021c1
-- 049:000000000000000000000000000000000000000000000000000000007070707070707070c3c2c2c20000000000000000d2d2d2d2d2d2d2d2d2d2d273d2d2d2d2d2d2d2d2d2d2d20000000000000000000000000000000000000000000000000000000000d1d1d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222222222222042222222222222222222222222222222222222200
-- 050:0000000000000000000000000000000000000000000000000000000000d1d1d170707070707070c2c2c2c2c2c2000000d2d2d2d2d2d2d2d2d2d2d273d2d2d2d2d2d2d2d2d2000000000000000000000000000000000000000000000000000000000000000000000000707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 051:0000000000000000000000000000000000000000000000000000000000d1d1d1d1d1d1707070707070707070c2c2c3c2c2d2d2d2d2d2d2d2d2d2d273d2d2d2d2d2d2d2d20000000000000000000000000000000000000000000000000000000000000000000000a370707070707070707070a3b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b3b3b3b3b3b3b3b3b3b3b3b3b3b3
-- 052:0000000000000000000000000000000000000000000000000000000000000000d1d1d1d170707270d3d3a3707070707070a3a3d2d2d2d2d2d2d2d273d2d2d2d2d2d20000000000000000000000007070707000007070000000000000000000b3b3b3b3b3b3b3b3a3707070707070707070a3a3b3b300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000505050505050935050505050505000b3d1d1d17070d1a3a3a3a3a3a3b3
-- 053:000000000000000000000000000000000000000000000000000000000000000000d1d1a3a37070707070707070a3707072a3a3a3d2d2d2d2d2d2d273d2d2d2000000000000000000000000000000707070707070707070700000000000b3b3b3b3b3b3b3b3b3a3a370707070707070a3a3a3b3b3b3b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041707070707070700870187070707061b3d1d17070707070707070d070b3
-- 054:000000000000000000000000000000000000000000000000000000000000000000000000a3a370a3707373737370707253a3a3a3d2d2d2d2d2d2d273d2d200000000000000000000000000000000707070707070707070707070a3b3b3b3b3b3b3b3b3b3b3b3a37070707070707070a3b3b3b3b3b3b3a30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041707270727072707270237023707061b3d1d1a3a3a3a3a3a3a3a3a3a3b3
-- 055:0000000000000000000000000000000000000000000000000000000000000000000000000000a370707072707373737373737373737373d2d2d2d273d2d20000000000000000000000d100000000007070707070707070707070a3a3b3b3b3b3b3b3b3b3b3a3a37070d1d170707070a3b3b3b3b3a3b3a3c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041187070701870707070187070827061b3a370707070a3a3a3d1d18270b3
-- 056:0000000000000000000000000000000000000000000000000000000000000000000000000000000000707070d3d3707073707070d3d3737373737373c2c20000000000000000000000d1d1d1000000000070707070707070707070a3a3a3b3b3b3b3b3b3b3a370d1d1d171d1d1d170a3a3b3b3b3a3a3a3c3c2c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041706252525252525252525252525200b3a370717118707070d1a3a3a3b3
-- 057:00000000000000000000000000000000000000000000000000000000000000000000000000000000000070d3d3d3707073707072d3d3d3c2c2c280c2c2c2000000000000000000000000d1d1d100000000007070707070707070707070a3a3b3b3b3b3b3a3a370d17171717171d1d170a3b3b3a3e3e3e3c2c2c2c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041706050505050505050505050505000b3a371717171717070d18070a3b3
-- 058:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000d3d3707270737070d3d370d3d3c2c2c2c2000000000000000000000000000000d1d10000000000000070707070d1d1d1707070a3a3a3a3a3a3a370d171717171717171d170a3b3b3a3e3e3e3e3c2c2c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041187070087070707070701870827061b3a3717171717113717171a3a3b3
-- 059:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070707073d3d3d3d3d300000000000000000000000000000000000000000000000000000000000000d1d1d1d1d1d1d17070707070707070707070d17171717171d1d170a3b3b3a3e3e3e3e3e3c3c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041707270237072702370727072707061b3a3d1717170711371717171a3b3
-- 060:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707073d3d3d30000000000000000000000000000000000000000000000000000000000000000000000d1d1d1d1d17070707070707070707070d1d171717171d17070a3b3b3a3e3e3e3e3e3c2c2c2c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041717171717171137171717171717161b3a3d1d17070707070707071a3b3
-- 061:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000d1d1d1d1d17070707373737373737373737373d1d1d1d17070a3a3b3b3e3e3e3e3e3e3c2c2c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041707018707070707070707070187061b3a3d1a3a3a3707070701870a3b3
-- 062:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013000000000000000000000000000000000000000000000000000000000000000000000000000000d1d1d1d1707070737070707070d1d1d1d17370707070707070a3a3b3e3e3e3e3e3e3e3c2c3c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000525252525242706252525252525200b3a3d17070a3a3a3a3a3a3a3a3b3
-- 063:000000000000000000000000000000000000000000d1d1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707070707070737070707021212121211321212121217070a3a3b3a3e381e3e3e3e3e3e3c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005040706050500000000000b3a3d17018700870a3b3b3b3b3b3
-- 064:000000000000000000000000000000000000000000d1d1d1d1d1d30000000000000000000000000000000000000000001300700000000000000000000000000000000000000000000000000000000000000000000000707070707070707070737070707021717171711371717171217070a3a3b3a3e3e3e3e3e3e3e3e3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000417018707070706100000000b3a370a3a3a3a370a3b3b3b3b3b3
-- 065:00000000000000000000000000000000000000000000d1d1d1d3d3d300000000000000000000000000000000000000701380700000000000000000000000000000000000000000000000000000000000000000707070707070707070707070737070707021712121211321212171217070a3a3b3a3a3e3e3e3e3e3e3e3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000417023702370706100000000b3a370a3a3b3a3d0a3b3b3b3b3b3
-- 066:00000000000000000000000000000000000000000000d1d181d3d3d30000000000000000000000000070707070707070737070700000000000000000000000000000000000000000000000000000000000007070707073737373737373737373d1d1d1702171217171137171217121707070a3b3b3a3e3e3e3e3e3e3e3e3e3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005252525252520000000000b3a3a3a3a3b3a370a3b3b3b3b3b3
-- 067:00000000000000000000000000000000000000000000d17070707070d300000000000000000000007070707270707070737072700000d1d1d10000000000000000000000000000000000000000000000007070707070737070707070d1d1d17171d170702171217132041271217121707070a3b3b3a3e3e3e3e3e3e3e3e3e3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b3b3b3b3b3b3b3b3b3b3b3b3b3b3
-- 068:00000000000000000000000000000000000000000000707070707080700000000000d1d1d1d1707070707070707070707370707070d1d1d1d1d1d1d1d1d17070700000000000000000000000000000000000707070707370707070d1d1717171d170707021722171310011712172217070e3a3b3b3a3a3a3e3e3e3e3e3e3e3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 069:0000000000000000000000000000000000000000000000d3d37070707000007070d1d1d1d1d1d170707070707070707073707070d1d1d1d1d1d1d1d1d1d1d170707070000000000000000000000000000070707070707370707070d171717171d1707070217121713003107121712170e3e3a3b3b3b3a3a3a3e3e3e3e3e3e3e3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a0a0a0a0a0a00000000000
-- 070:000000000000000000000000000000000000000000000000d3d37070700000707373737373737373737373737373737373737373737373737373737373d1d170707070707070000000000000000000007070707070707370707070d1717171d1d1707070217121717113717121712170e3e3a3a3b3b3b3b3a3a3e3e3e3e3e3e3e30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a0a0a0a0a0a0a0a0a000000091a1a1a1a1a1a1a1a1b100a0a000
-- 071:000000000000000000000000000000000000000000d3707070707070700000d17370707070707070707270737070707073807070d1d1d1d1d1d1d1d1735370d17070707070707070131313f0131313737373737373737373737373d1d1d1d1d1707070702171212121132121217121e3e3e3e3a3a3a3b3b3b3a3a3e3e3e3e3e3e3e3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0a1a1a1a1a1a1a1a1a1a1a1b1000091a1b2a2a2a2a292a1b09082a1b1
-- 072:0000000000000000000000000000000000000000007072707070703222222222042212707070707070707073707070707370707070d1d1d1d1d1d1628342d1707070707070707070000000000000000000707070707070707070737070707070707070702171717171137171717121e3e3e3e3e3e3a3b3b3b3b3a3a3a3e3e3e3e3e3e3e3c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2a2a2a2a292a1b2a292a1b0a0a090a1b10000000091a1a1a1a1a1b1
-- 073:000000000000000000000000000000000000000000707070707070310000000000001170707070707070707370707072737072707070d17071d1d1605040d1d17070707070707000000000000000000000000000707070707070737070707070707070702121212121132121212121e3e3e3e3e3e3a3a3b3b3b3b3a3a3a3e3e3e3e3e3e3c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1b10091a1a1a1a1a1a1b10000000091a1b29282a1b1
-- 074:000000000000000000000000000000000000000000007070707070310000000000001170707070707070737370707070737070707070717171d1d1d1d1d1d1d1707070000070000000000000000000000000000000707070707073707070707070d1d1d1d17070707073d1d1d1e3e3e3e3e3e3e3e3e3a3a3a3b3b3b3b3a3a3a3e3e3e3e3c2c2c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1b10091a1b2a2a2a2a200a0a0a0a090a1b100a2a200
-- 075:00000000000000000000000000000000000000000000007070707031000000000000117070707070707073707070707073707070707171717171d1d1d1a3a3a3a3a30000000000000000000000000000000000000000007070707370707070707070d1d1d1d1d1707073d1d1e3e3e3e3e3e3e3e3e3e3e3e3a3a3a3b3b3b3b3a3e3e3e3e3e3c2c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a090a1b10091a1b0a0a0a0a090a1a1a1a1a1a1b100000000
-- 076:00000000000000000000000000000000000000000000702370707030032020202020107070707070707073707270707073737370d371d17171717171d1a3b3b3b3b300000000000000000000000000000000000000000000007073737373737373737373737373737373d1e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3a3a3b3b3b3a3e3e3e3e3e3c2c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1a1a1a1a1b10091a1a1a1a1a1a1a1a1a1a1a1a1a1b100000000
-- 077:0000000000000000000000000000000000000000000000d3707070707300000070707070707070707070737070707070237073d3d3d3d1717171d1d1d1a3b3b3b3b3b3a3a3c2000000000000000000000000000000000000000000000070707070d1d1d1d1d1d170000000e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3a3a3a3a3a3e3e3e3e3c2c3c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1b2a292a1b10000a2a2a2a2a2a292a1a1a1a1b2a20000000000
-- 078:0000000000000000000000000000007070000000000070d3d37070707300000000707070707070707070737070707070707073d3d3d1d1d1d171d1d1a3a3b3b3b3b3b3a3c2c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1b10091a1b100000000a0a0a0a00092a1b2a200000000a0a000
-- 079:0000000000000000000000007070707070700000707070d1d3707070730000000070707070707070d3d3737070707270707073d3d3d1d1d17171d1d1a3b3a3a3a3a3a3a3c2c3c280c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e3e3e3e3e3e3e3e3e3e3c2c2c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1b10091a1b0a0a0a090a1a1a1a1b191a1b100000000c0a1a1b1
-- 080:0000000000000000000000008073737373d37070707070d3d3707070737000000070d3d370707070d3d373d370707070707073d3d371717171d1d1d1a3b370d0707070c2c2c2c2c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1b00091a1a1a1a1a1a1a1a182a1b191a1b1000000000092a1b1
-- 081:0000000000000000000000007070707073d37070707070d370707070737000007070d3d370707070d37373d3d3707070707013717171d1d1d1d1d1a3a3b3a3a3a3a370c2c3c2c2c3c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a090a1a1b100a2a2a2a2a292a1a1a1a1b191a1b0a0a0a0a0a090a1b1
-- 082:0000000000000000000000007070707073707070707171717070d3d3737000007070d1d1707070d3d373d370707070707171137072d3d1d1d1d1a3a3b3b3b3b3a3a370a3a3a3a3c2a3a3a3a30000000000d1d1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1a1a1a1b100000000000000a2a2a2a20091a1a1a1a1a1a1a1a1a1b1
-- 083:000000000000000000000000000070707370707071717171717070d3737000007070d1700000d372d373707070707171717173707070d1d1d1a3a3b3b3b3b3b3b3a3a3a3b3b3a3a3a3b3a3a3b300000000d1d1d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009282a1a1b100000000000000000000000000a2a2a2a2a2a2a2a2a200
-- 084:0000000000000000000000000000707073d370717171717171d3d370730000007070707000d3d37170137171717171717070737070707070a3a3b3b3b3b3b3b3b3b3a3b3b3b3b3b3b3b3b3b3b30000000000d1d1d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2a2a2000000000000000000000000000000000000000000000000
-- 085:00000000000000000000000000007070737071717171717171707070730000007270707000d1707171137171717070717070738070707070a3b3b3b3b3b3b3b3b3b3b3b3b3a3a3a3a3a3a3a3a30000000000d1d1d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a0a0a0a0a0a0a0a00000
-- 086:00000000000000000000000000007070737070717171717171702370737000707070700000d17171212121707070717172707370707070a3a3b3b3b3b3b3b3b3b3b3b3a3a3a37171717171d1d1d10000000000d1000000000000000000000000000000000000000000000000000000000000e3e3e3e3e3e3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000417171717171717171717171717171610091a1a1a1a1a1a1a1a1a1a1b100
-- 087:0000000000000000000000000000007073707071717171717170707073700070707070000070717121e421707070717070707323707070a3b3b3b3b3b3b3b3a3a3a3a3a3a3d17132221271d1d1d100000000000000000000000000000000000000000000000000000000000000000000e3e3e3e3e3e3e3e3e30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000417171717171717171717171717171610091a1a1b292a1b2a2a292a1b100
-- 088:000000000000000000000000000000707323707071717171717070707370000070700000d1d171712121217270701370707073707070a3a3b3b3b3b3b3b3a3a3d1d1d1d1d1d17131001171d1d1d10000000000000000000000000000000000000000000000000000000000000000e3e3e3e3e3322212e3e3e30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000417171717171717171717171717171610090a1b20091a1b1000091a1b100
-- 089:0000000000000000000000000000007073707070707171717171707073700000d3700000d1d1712114211421707071707070737070a3a3b3b3b3b3b3b3b3a3d1d170d1d1d1d17130031071d1d1d1700000000000000000000070d1d1700000000000000000000000000000000000e3e3e3e3e3300310e3e3e3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041717171717171717171717171717161c0a1a1b10090a1b0000090a1b000
-- 090:0000000000000000000000000000007073707070707171717171707073700000d3700000d1d1712132041221707171d12370737070a3a3b3b3b3b3b3b3b3a3d1d1d1d1d1d1d17171137171d1d1d1d1000000000000000000000070d1707000000000d10000000000000000000000e3e3e3e3e3e3e3e3e3e3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004171717171717171717171717171716100a2a20091a108a1b191a108a1b1
-- 091:0000000000000000000000000000707073707070707071717171707073700000707000007070712131001121707070707070737070d3a3b3b3b3b3b3b3b3a3a3a3d1d1d1d1d1d1d17353d1d1d1d1d100000000000000000000007070d170000000d170701313131313f013131313e3e3e3e3e3e3e3e3e3e30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004171717171717171717171717171716100a0a00091a182a1b19182a1a1b1
-- 092:0000000000000000000000000000707073d170707070707171d18070737000007000007070727121302010217070707073737372d3d3a3b3b3b3b3b3b3b3b3b3a3d1d1d1d1d1d1d17370d1d1d1d170000000000000000000000000007000000000d1707000000000000000000000e3e3e3e3e3e3e3e3c2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000416252427171717171717171717171619182a1b191a1a1a1b10092a1b200
-- 093:0000000000000000000000000000707073d1d1d1707070d171d1d170737000000000707070707121212121217070d3d373d3d3d3d3d1a3a3a3a3a3a3b3b3b3b3b3a3a3a3d1d1d1d17370d1d1d1d100000000000000000000000000000000000000d17070000000000000000000000000e3e3e3e3c2c2c2c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041609340c3c2c3c2c3c2c2717171716191a1a1b191242424b10091a1b000
-- 094:000000000000000000000000000000707373d1d1707070d123d17070730000000000707070707171717171707270d3f173d3d3d3d3d1d1707070d070b3b3b3b3b3b3b3a3d1d1d1d17373d2d2d2d1e30000000000000000000000000000000000d1d170700000000000000000000000000000e3c2c2e2e2c200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c273c2c2c2c2c2c2c2c2c26252426191a1a1b19114a114b10091a1a1b1
-- 095:00000000000000000000000000000070737373737373737373737373730000000000d3d3807070717171237070d3d3d373d3d3d3d3d1a3a3a3a3a3a3a3b3b3b3b3b3b3a3d2d2d2d2d273d2d2d2d1e3e3e3e3e3e3e3000000000000000000000070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c273c2c2c2c2c2c2c2c3c26093406191a1b20091a1a1a1b1009108a1b1
-- 096:000000000000000000000000000000707070707070707070707073737070000000d3d3d37070707171707070d3d3d3d373d3d3d3d37270a3b3b3b3b3b3b3b3b3b3b3b3a3e3e3e3e3e313e3e3e3e3e3e3e3e3e3e3e3e3e3e3000000000000007070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c273c2c2c3c2c2e4c2c2c2c273c26191a1b0a09014a114b0a090a1a1b1
-- 097:000000000000000000000000000000707070717170707070707073707000000000d3d3d3d370717170707070d3d3d3d37372d3d3d37070a3b3b3b3b3b3b3b3b3b3b3b3a3a3e3e3e3e313e3e3e3a3e3e3e3e3e3e3e3e3e3e3e3e300000000707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c2737373737373737373737373c26191a1a1a1a1a1a1a1a1a1a1a182b1
-- 098:000000000000000000000000000000707171717171702370707073727000000000d3d3d3d3701370707070d1717172d373d3d3d3707070a3b3b3b3b3b3b3b3b3b3b3b3a3a3a3e3e3e313e3e3e3a3a3e3e3e3e3e3e3e3e3e3e3e3e3d1d1d1707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c2c2c3c2c2c2c273c2c2c2c273c26100a2a292a114a114a1b2a2a2a200
-- 099:000000000000000000000000000070707171717171717070707073707000000000d3d3d3d37171707070d1d1717171717323d1d1d1d1d1a3b3b3b3b3b3b3b3b3b3b3b3a3a3e3e3e3e313e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3d1d1d1707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c2c2c2c2c2c2c273c2c3c26283426100000091a1a1a1a1a1b100000000
-- 100:0000000000000000000000000000707071717171717171d3d3707370700000000000d3d30070707070d1d171717171717373d1d1d1d1d1a3b3b3b3b3b3b3b3b3b3b3b3a3e3e3e3e3e313e3e3e3e3e3e3e3e3e3e3e3e3e3d1e3e3e3d1d2d1d1d1d1707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c2c2c2c2c2c2c273c2c2c26050406100000000a292a1b2a20000000000
-- 101:0000000000000000000000000000707070717170707071d3d3d37370700000000000d30000707270d1d1d171717171717173d1d1d1d1d1d1a3b3b3b3b3b3b3b3b3b3a3a3a3a3d1d1e313e3e3e3e3e3e3d1d1e3e3e3e3e3d1e3e3d1d1d2d2d1d1d1d1d1707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005252525252525283525252525252000000000000000400000000000000
-- 102:000000000000000000000000000000707071717070707023d3d37370700000000000000070707070d1d17171717171717173d1d1d1d1d1d1a3b3b3b3b3b3b3b3b3a3a3d2d2d2d2d1d173e3d1e3e3d1d1d1d1d1d1e3e3e3e3e3d1d1d2d2d2d2d1d1d1d1d1d1d1d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a0a0a0a000000000000000000000000000000000000000
-- 103:00000000000000000000000000000070707071717080737373737370700000000000007070707070d1d1d1717171d1d1d173d1d1d1d1d170a3b3b3b3b3b3b3b3b3a3d2d2d2d2d2d2d173d1d1d1d1d1d1d1d2d2d1d1d1d1e3d1d1d2d2d2d2d2d2d2d2d2d2d1d1d100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0907171717171a1b0a0a00000a0a0a0a0a0a0a0a0a0a0a0a0a000
-- 104:0000000000000000000000000000000070707171702370d37070737070700000000070707070707070d1d1d1d1d1d1d1d173d1d1d1d170a3a3b3b3b3b3b3b3b3b3a3d2d2d2d2d2d2d273d2d2d2d2d2d2d2d2d2d2d2d1d1d1d1d2d2d2d2d2d2d2d2d2d2d2d2d2a3a3a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0a108a1717171711308a1a1a1c191a1a133a1a1a1a1a108a1a1a1a1c1
-- 105:00000000000000000000000000000000707070707070d1d1d1707370707200000000707070707070707070d1d1d1d1d1d173d1d1a3a3a3a3b3b3b3b3b3b3b3b3a3a3d2d2d2d2d2d2d273d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2a3a3b3b3b3b3000000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2a2927171717171a1b2a2a20091a1b2a2922424b292a1a1a1b2a200
-- 106:00000000000000000000000000000000007070707070d1d1d170737070d1000000008070707070707070727070d1d173737323a3a3a3a3b3b3b3b3b3b3b3b3b3a3d2d2d2d2d2d2d2d273d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2a3b3b3b3b3b3b3a3000000000000000000000000000000000000000000000000000000707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a090a1b2a2a292a1b0a0a00091a1b0a091a1a1b191a1a1a1b10000
-- 107:00000000000000000000000000000000000000707070d1d1d1d173707070000000007070707073737373737373737373a373a3a3b3b3b3b3b3b3a3a3b3b3b3a3a3d2d2d2d2d2d2d2737373d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2a3a3a3a3a3a3a3b3a3c20000000000000000000000000000000000000000000000007070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009182a1a1a1a1b1000091a1a1a1a1b191a1a1a1b192a1b00092a1b2000000
-- 108:0000000000000000000000000000000000000000707070d1d1d17370707000000000007070d173537070d1d1d1d1a3a3a381a3b3b3b3b3b3b3a3a3a3b3b3a3a3d2d27373737373737373737373737373737373737373737373737373737373737373737373d2d2d2d2d2a3a3e3a3c2c2c2000000000000000000000000000000000000c2c2d1d17070703222221270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009182a1a1b2a200a0a090a114a1a1b191a114a1b191a182b191a1b0a0a000
-- 109:0000000000000000000000000000000000000000007070d1d17073727070000000000070706283427070d1d1d1a3a3b3b3b3b3b3b3b3a3a3a3a3d3a3a3a3d2d2d2d273d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d273d2d2d1d173737373737373e3e3e3e3e3c2c20000000000000000000000000000000000c2c3c2d1d1d1707031000011707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2a2a2000091a1a1a108a1a182b191a1a171b090a1a1b19008a17171b1
-- 110:0000000000000000000000000000000000000000000070d1d17073737370000000000000706050407070d1a3a3a3b3b3b3b3b3b3b3a3a3d3d3d3d3d3d1d1d2d2d2d273d2d2d2d2d2a3d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2a3d2d2d2d273d2d2d1717171d1d173d2d2e3e3e3e3e3e3c2c2000000000000000000000000000000c2c2c2c2d1d1d1d1d130032010707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a0000091a1b292a114a1a1b191a114717171a1b291a1a1a1a1a1b1
-- 111:00000000000000000000000000000000000000000000d1d1d1d17370807000000000000070707070a3a3a3a3b3b3b3b3b3b3b3a3a3a37070d3d3d3d1d1d1d2d2d2d273d2d2d2d2a3a3d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2a3a3d2d2d2d273d2d2d1717171717173d2d2e3e3e3e3e3e3c2c2c2c2130000000000000000000013c2c2c2c2c2c2d1d1d1d170737070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091a1a1a1b10090a1b091a1a1a1a1b191a1717171a1a1b10092a1b292a1b1
-- 112:00000000000000000000000000000000000000000000008073737370700000000000000000a3a3a3a3b3b3b3b3b3b3a3a3a3a3a381737373d3d3d3d3d1d1d2d2d2d273d2d2d2a3a3a3d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2a3d2d2d2d2d273d2d2d1d17171717173d2e3e3e3e3e3e3e3c2c280c200000000000000000000000080c2c2c2c2c2d1d1d1d17073707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009182a1a1b090a1a1a1b1a292a1b20091a11471717171b1009071b191a1b1
-- 113:0000000000000000000000000000000000000000000000d1d1d17370700000000000000000b3b3b3b3b3b3b3b3a3a3a372707070707070737373737373737373737373d2d1d1a3a3a3d1d2d2d2d2d2d2d2d1d1d1d1d1d1a3a3d1d1d2d2d273d2d2d2d1d171718073d2e3e3e3e3e3e3c2c20000000000000000000000000000000000c2c2c2c2c273737373737070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a292a1a1a108a1a1b10090a1b1009108a1a1a1a171b1917171b191a1b1
-- 114:000000000000000000000000000000000000000000000000d1d17370700000000000000000b3b3b3b3b3a3a3a3a3707070707070707070707070707070d1d1d2d2d1d1d1d1c2c2c2c2d1d1d1d2d2d2d1d1d1c2c2c200000000c2d1d1d2d273d2d2d2d2d171d1d173d2e3e3e3e3e3e3c2c20000000000000000000000000000000000c2c3c2c2c2d1d1d1d1707171717170707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a2a292a1a1a1b090a1a1b00000a2a2a292a1b20090a171b090a1b1
-- 115:00000000000000000000000000000000000000000000000070d173727000000000000000000000b3b3a3a37070d3d3d3d3d3d3d3707070707070707070d1d1d1d1d1c2c2c2c3c2c2c2c2c2d1d1d1d1d1c2c2c2000000000000c2c2d1d1d17373737373d1d1d1d273e3e3e3e3e3e3e3c200000000000000000000000000000000000000c2c2c2c2c2d1d1d1d1717171717170700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009182a1b0a00092a1a1a1a1a1a1a1b10000000091a1b191a1a17171a1a1b1
-- 116:00000000000000000000000000000000000000000000000070d1d1d17000000000000000000000b3a3a3d3d3d3d3d3d3d3d3d3d1d1707070707070d1d170d1d1d1c2c2c2000000c2c2c2c2c2c2d1d1c2c20000000000000000c2c2c2c2628342d2d273d2d2d2d2e3e3e3e3e3e3e3c2c200000000000000000000000000000000000000c2c2c2c2c2d1d1d1d1d17171717170700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009143a1a1a1b090a1b2a29208a1a1b10000a0a090a1b191a108a1a1a1a1b1
-- 117:000000000000000000000000000000000000000000000000007070d17000000000000000000000a3d3d3d3d3d3d3d3d3d3d3d1d1d170707070d1d1d1d1d1d10000000000000000c2c2c2c2c3c2c2c2c200000000000000000000c2c2c2610041d2d27370d2d2d2e3e3e3e3e3e3c2c2c20000000000000000000000000000000000000000c2c2c2c2c2d1d1d1d17171717170707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009182a1a1a1a1a1a1b10091a1a1a1b100c0a1a1a1a1b100a2a29243a1a1b1
-- 118:00000000000000000000000000000000000000000000000000007070000000000000000000000000d3d3d3c2c2c2c2d1d1d1d1d1d1d1c2c2c2d1d1d1d100000000000000000000c2c3c2c2c2c2c2c2c200000000000000000000000000605040d1d17370d1d1e3e3e3e3e3e3e3c2c200000000000000000000000000000000000000000000c2c3c2c2c2d1d1d1d1717170707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2a2a2a2a2a2a2000000a2a2a2000000a2a2a2a20000000000a2a2a200
-- 119:00000000000000000000000000000000000000000000000000000000000000000000000000000000c2c2c2c2c2c2c2c2c2c2c2c2c2c2c3c2c2c2d100000000000000000000000000c2c2c2c2c2c200000000000000000000000000000000c2c2c2c27353c2e3e3e3e3e3e3e3c2c2000000000000000000000000000000000000000000000000c2c2c2c2d1d1d1d1707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0a0a0a0a0a0a0a0a0a0a0a00000a0a0a0a0a0a001a0a0a0a0a0a000
-- 120:0000000000000000000000000000000000000000000000000000000000000000000000000000000000c2c2c2c2c2c2c2c2c2c3c2c2c2c2c2c200000000000000000000000000000000c2c2c3c2c2c2000000000000000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000c2c2c2d1d1d1d1707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009108212144210821214421212121b191a1a1a1a1a1a1a1a1a1a1a1a182b1
-- 121:000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2c3c2c2c2c2c2c2c2c2c200000000000000000000000000000000000000000000c2c2c2c2c2000000000000000000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000c2c2c2d1d1d1707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009121711364137171136413718221b141a1a1a1a1a114a114a1a1a1a18261
-- 122:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009171711313137171131313717121b141a1a1a1a1a1a1a1a1a1a1a1a1a161
-- 123:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009113717171717171717171717121b141a16252525252525252525242a161
-- 124:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000917171743454822174a234547121b141a16100000000000000000041a161
-- 125:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000032041200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009121212121212121216471212121b141a16050505050505050505040a161
-- 126:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009134343454147113711471717174b141a1a1a1a1a1a1a1a1a1a1a1a1a161
-- 127:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000221137171717171717171137121c100525252525242a162525252525200
-- 128:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009154717171142113211471717174b100505050505040a160505050505000
-- 129:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009171717171212121212121717171b141a1a1a1a1a1a1a1a1a1a1a1a1a161
-- 130:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009143211471217434343434343434b141a1a1a1a114a1a1a114a1a1a1a161
-- 131:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009121217171212121212121210821b141a1a16242a1a1a1a1a16242a1a161
-- 132:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009121217171717171712121212121b141a1a16141a1a1a1a1a16141a1a161
-- 133:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009182217434343434343454212182b141a1a1604014a1d4a1146141a1a161
-- 134:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009108212121212108212121212121b102a1a1a1a1a1a1a1a1a16141a1a161
-- 135:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2a2a2a2a2a2a2a2a2a2a2a2a200005252525252525252525252525200
-- </MAP5>

-- <MAP6>
-- 000:b71c35f220db25a32000003c54da300d942a300000ecc48e304cc43f30fc0576405c1588403c25b270000029ef5600efb062041a10e710205defd300d7390000ef9800d3390000efe010d3390000ef8310d3390000efd710d3390000ef0b10d329a110f3d72025561646024786560296e637362796074796f6eef6e60247865602f42656c69637b6fb604586560296e637362796074796f6e602f6e60247865602f42656c69637be963702772796474756e60296e6021602c616e676571676560297f65f46f6e672470257e6465627374716e646c2022657470237f6d65686f67f97f657023616e60227561646024786
-- 001:560277f6274637ea0895f6570237075616b602478656d60216c6f65746ea20e4f6478696e676028616070756e637e20235f602d65736860266f62f37570756273747964796f6e6ea50245747023757464656e6c69702478656027627f657e64e46963716070756162737026627f6d6022656e6561647860297f6572f66565647ea0895f657026616c6c6e2e2ea3095f65702b6565607026616c6c696e676e2e2ea64f627027786164702375656d63702c696b6560216ee56475627e6964797ea6014c6c60276f6563702461627b6ea08758656e60297f657027716b656c20297f6570216275e465656070257e6465627
-- 002:7627f657e6460296e6027786164fc6f6f6b63702c696b65602160247f6d6260246577ec6f6e676021676f6ead74b293fef1000bdef6f19e73082293f39cdef72b3d72b49103fef952961bdefe0a1d739ef7f52b110bdefebe8d7390000ef0520d3390000ef0c20d3390000efe030d3d7504586560226f6f6b6024756c6c63702478656023747f6279ff6660247865602052796e6365602f666023516e6460284166756e6ca7786f6c20216024786f6573716e6460297561627370276f6cad61646560216020716364702779647860247865e35f627365627562702b496e676ea3045865602052796e636560277163702
-- 003:76966756e602762756164f07f677562737c20216e6460226563616d6560247865e36573747f6469616e602f666024786560225564602342797374716c6ea5045865602052796e636560277163702265727965646027796478e4786560225564602342797374716c6ea08458656022657279616c602368616d62656270296370216470247865e26f64747f6d602c6566756c602f66602478696370236f6d607c65687ead74b293fefb000bdef6f19e73082293f40cdef90b3d72b59103fef95296161bdefe0a149203fef952971bdefe0a1d739ef7f52c110bdefebe8d739ef2e52a120bdefebe8d74b293fef5100bdef
-- 004:6f19e73082293f40cdef90b3d72b59103fef95296161bdefe0a169203fef9529616171bdefe0a1d739ef2e52b120bdefebe8d72b293f10351a202e206deff040193f7419effc0574390000ef0140d3d74095f657020757c6c60247865602c656675627ea458656023656e6475727965637d2f6c64602d656368616e69637de475727e637e20295f65702865616270216027616475ef60756e696e676026616270216771697ead719efd64024d72045869637027616475602f60756e63f56c637567786562756ead7484e026def5c40390000efbc40d329ef3250efb062041a10e710206def4c40390000ef9350d33900
-- 005:00efa750d3390000ef6b50d3c799efd5601981e5d719efee5024d74014e602f627e61647560237162736f607861676573f275637473702164702478656023656e647562702f66e4786560227f6f6d6e20294470296370286577656ca163702966602d61646560266f627021602769616e647ea10f40756e6024786560237162736f6078616765737fb30758656e60297f65702075737860247865602c69646ca4786560237162736f60786167657370226567696e63f47f6022757d626c6560216e64602378616b656ea3095f6570277164736860296e60247562727f62f1637021602769616e6470237b656c6564716
-- 006:ce669676572756022796375637026627f6d6029647ea3095f6570286166756024696374757272656460247865e052796e6365602f666023516e6460284166756e6ea84560296370216e6762797ea4095f6570246f6e67247026696e6460216e697478696e6760256c6375e96e6024786560237162736f6078616765737e20294470277163fa65737470247865602f6e65602769616e6470257e64656164e37b656c65647f6e602072796e63656c202e6f6478696e6760256c63756ead7284e02390000ef6860d3390000ef8e60d3190fe319ef04f1bdef409b29ef9c25716529ef3c25c065d74095f657027716473686
-- 007:02163702478656028657765e37b656c65647f6e6026696765727560236f6c6c61607375637ea94e6024786560237162736f6078616765737c20297f65f6696e646021602378696e696e6760225564602342797374716c6ea30140236f6d607162747d656e64702f60756e63702f6e60247865e77563747027716c6c6c2022756675616c696e67602160237563627564f374716962736163756ead7484e025defd370390000efe370d3299120f3d75095f6570236c696d6260257070247865602374756560f37471696273702261636b60247f60247865602f6574737964656ea95f657026696e6460247861647024786
-- 008:5602f42656c69637be8616370236f6c6c61607375646c20216e6460296e60296473f07c616365602478656275602963702e6f67702160207f6274716c6ead7b7103586f62747023777f6274e300023e03000b720c4f6e676023577f6274e308030e05000b7a02427f61646023577f6274e308070e08000b730d416365e300014e02000b740155716475627374716666e3000e1e11000b75044167676562f3000e1e12000b7608416e6460216875e30804160a000b7703586f627470226f67f4000afe05000b780c4f6e6760226f67f4080c0e08000b7903427f6373726f67f40803280c000b74c54d6562716c6460234
-- 009:27f6373726f67f408023804100b7c04577f6d28616e6465646023777f6274e30a08220f000b7e024164747c656028416d6d6562f30a064202100b7d024164747c6560214875e30a0f5209100b70134c6f64786563f1000a0e10000b711c4561647865627021627d6f62f100069e01000b7212427967616e64696e65e108070e02000b731353616c656021627d6f62f1080c0e04000b7412596e676021627d6f62f108032e0a000b75134861696e6021627d6f62f10801460f000b7613507c696e6475646021627d6f62f108055604100b77105c6164756021627d6f62f108069609100b70cb496e67602651686e67237
-- 010:021427d6f62f10000020322045869637026696e656023757964702f666021627d6f62f2656c6f6e67656460247f602b496e67602651686e6eab71cb496e67602651686e67237023577f6274e30200020e12045869637026696e656023777f62746022656c6f6e676564e47f602b496e67602651686e6eab73cb496e67602651686e67237023427f677ee20000020002045869637026696e656023627f677e602f6660237f6c6964e76f6c646022656c6f6e67656460247f602b496e67602651686e6eab72cb496e67602651686e67237022596e67e90000020002045869637026696e656022796e676022656c6f6e676
-- 011:564e47f602b496e67602651686e6eab7127596a71627460227f626563f10008c01a020f4666656273702b213030246566656e63756ead416368696e656027716378602771627d6e2024557d626c65602462797eab7427596a7162746026756374f108032014110f4666656273702b223030246566656e63756eab7527596a71627460286164f2080f001a010f4666656273702b213030246566656e63756eab78175f6f64656e60237869656c64e5000e1601000b7919427f6e60237869656c64e500069602000b7a135475656c60237869656c64e508040604000b7b124164747c6560237869656c64e508070606000
-- 012:b7c2c4561647865627028656c6de200023e01000b7d29427f6e6028656c6de2000afe02000b7e235475656c6028656c6de208050e03000b7f224164747c656028656c6de208080604000b7c1c45616478656270226f6f6473f600082e11000b7d19427f6e60226f6f6473f60008ce12000b7e135475656c60226f6f6473f608040e03000b7f124164747c6560226f6f6473f608070604000b70214d657c6564702f66602845616c6478e8080f0e1002025567656e656271647563702865616c6478e164702561636860237475607eab72214d657c6564702f666027596a7162746279f80804101f030742716e64737ab
-- 013:02b213530246566656e6375e02b223535202370756c6c6024616d616765eb70314d657c6564702f66602354756164696e656373f808041e100200527566756e64737024786560277561627562f6627f6d602265696e67602374757e6e65646eab7322596e67602f66602350756564e908040e10020742716e647370256874727160237075656460237fe97f657021636470266962737470296e60226164747c656eab7622596e67602f6660244566627f6374796e67e908040e10020742716e647370227563796374716e6365e16761696e637470266275656a756021647471636b637eab7722596e67602f6660255e6
-- 014:07f69637f6e696e67e908010e10020742716e647370227563796374716e6365e16761696e637470207f69637f6e6eab7822596e67602f6660265967696c616e6365e908020e10020742716e647370227563796374716e6365e16761696e6374702d6167696360237c6565607eab7922596e67602f6660244566656e6375e908010e11010742716e6473702b2130246566656e63756eab7a22596e67602f6660244566656e6375602949c908020e13010742716e6473702b2330246566656e63756eab7b22596e67602f6660244566656e637560294949c908040e16010742716e6473702b2630246566656e63756eab7
-- 015:0445f627368ee00080e1001074f6f6460237f65727365602f66602c696768647eab7143586f66756cee00023e100205537560296470247f60246967602478696e6763f6627f6d602478656027627f657e646eab709845616c696e6760207f64796f6eec01023e10010845616c637021303028607eab719d416e6160207f64796f6eec0102341001025563747f6275637021303023707eab72994e6679637962696c69647970207f64796f6eec01046e10040d416b656370297f6570296e66796379626c656c20256e656d696563f16275602c656373702c696b656c6970247f6028696470297f657ea24574702d6f627
-- 016:5602c696b656c6970247f6028696470297f6572f66279656e64637eab73905f64796f6e602f66602147716b656e696e67ec01046e10030d4973747562796f657370226964747562702461627b602c69617579646ea34f657e64756273702d61676963616c60237c6565607ca3616573796e67602462796e6b656270247f602167716b656e6eab74905f64796f6e602f6660205f69637f6eec01023e1003005f69637f6e6f6573702c69617579646ea64f62702265637470227563757c64737c20246fee6f64702462796e6b6eab75905f64796f6e602f6660235c656560796e67ec01023e10030d41697023616573756
-- 017:024627f6773796e6563737ea44f602e6f64702f607562716475602d616368696e656279ff62702669676864702d6f6e63747562737eab76905f64796f6e602f666026496275ec0108ce10020c496175796460266962756c20207275647479702d6573686ea74275616470266f6270246566627f6374796e676eab77914e6479646f647560207f64796f6eec01046e1001034572756370207f69637f6e6eab78905f64796f6e602f6660294365ec01046e100101402675627970236f6c64602462796e6b6eab706140707c65ed00020e10020845616c64786970237e61636b6ea24574702e6f6470216026657c6c602d6
-- 018:5616c6eab72635f65747865627e6020556162fd000e1e100204456c69636163697026627f6d6024786560235f65747865627eeb496e67646f6d6e2023416e602365727560207f69637f6e637eab73694e6469676f60224c657562656272796563fd00023e10020742716e64737024756d607f6271627970237472756e6764786ea82b2235352024616d616765692eab71664f6f6460227164796f6e63fd000a0e10030354716e646162746024727166756c60227164796f6e637ea455627279626c656024716374756c20226574702162776571626c69f26564747562702478616e602469796e67602f666028657e676
-- 019:5627eab70da4567756c627970226f68ff00000e10030f427e616475602a6567756c627970226f687ea2456c6f6e676370247f602c456e616ca7786f602c6966756370296e6023557e60205f62747eab71d94e63656e6375ef00000e100302457e646c65602f6660296e63656e63756ea2456c6f6e676370247f60247865602c6f63616ce4756d607c6560296e602259667562737964656eab72d74f6c64656e6022627163656c6564ff00000e1003074f6c64656e6022427163656c65647ea2556475727e60296470247f60247865602f677e656270296ee4786560264f627563747026596c6c6167656eab73dd45737
-- 020:96360224f68ff00000e10030d4573796360224f687ea2556475727e60296470247f60247865602f677e656270296ee7556374707f627470245f677e6eab74d351696c696e67602055627d6964ff00000e10030351696c696e67602055627d69647ea14c6c6f677370297f6570247f60226f61627460247865e26f616470247f60247865602445637562747eab75d35075636471636c6563ff00000e1003035075636471636c6563702f666024527574786ea14c6c6f677370297f6570247f6023756560237563627564f56e6472716e6365637eab76d4496364796f6e616279ff00000e1003014e6369656e647024496
-- 021:364796f6e6162797ea2556475727e602478696370247f60247865e373686f6c616270296e6027556374707f62747eab70f25564602342797374716cef00000e100101402378696e696e6760227564602362797374716c6eab71f74275656e602342797374716cef00000e100101402378696e696e6760276275656e602362797374716c6eab72f24c6575602342797374716cef00000e100101402378696e696e6760226c6575602362797374716c6eab73f9556c6c6f67702342797374716cef00000e100101402378696e696e676029756c6c6f67702362797374716c6eab74fc456160796e676023547f6e65ef000
-- 022:00e100205537560296470247f602a657d60702163627f6373f37d616c6c60226f64696563702f666027716475627eab75f75f627c64602d4160ff00000e100401402d6160702f666024786560277f627c646ea4516c6b60247f60236162747f6762716078656273f47f602570746164756029647027796478602e6567f1627561637eab76f05572707c6560235175796460294e6bef00000e10030251627560296e6b6ea140236162747f6762716078656270277f657c64e37572756c6970216070727563696164756029647eab77f54d6562716c64602b4569ff00000e10020f40756e63702d61676963616c60256d6
-- 023:562716c64e76164756370296e6024786560277f627c646eab78f94e6469676f60235471647575647475ef00000e100302456c6f6e676370247f60294e6469676f60245f677e6ea9447023616e60227563747f6275602478656023696479f47f602c6966656eab79f45f6b656e602f6660225966756273796465ef00000e1003055375602478696370247f6022756475727e60247fe2596675627379646560296e6023616375602f66e4696275602e6565646ea00f023e182e100e191e1e1e146d791e1823b194fd62a10704870c15def7861787040394f3f9fe6f7800046e780e19defc7614870206defd861c7603f78
-- 024:60f929008ff6d719ef8a4e24d7393f4f5fbdefb468d7d7ac00bd61fc306e61fc60b271bc50b9715c401a715c80aa71000019ff8f141a102e10edefbc61d74b293fef7961bdef6f19d71bd719ef85b1bdef409b284e0819ff8f64d739ef82621051bdefebe8d769ffcfefce92ef9f61ef827146d0bdef7ad8d7207556023756c6c60294e6469676f60224c6575626562727965637ea4586569702162756024656c6963696f65737ea1036d74950ef73710000bdef0f29d760940247561636860247865602370756c6c602f66e143696460225563796374716e63656ea0875964786024786963702370756c6c6c20297f6
-- 025:57023616ee7716c6b602f6675627024786560207572707c656021636964e377716d607021627561637ead719eff86224d719ef426ebdef8c5bd719efc48ebdefde5bd739ef0c71d110bdefebe81900d72054e6475627024786560247f677eef666027556374707f62747fbd74b293fef6b91bdef6f19d72bd739ef82621041bdefebe8d7484e046defb181193d141a102e107def628139ffbfef0082eff381d339ffbfef0082efba81d3d739ffbfef0082ef0ca2d3d7284e0439ffbfef0082eff291d319ef8831bdef409b193d64d7409556162737021676f602d69702762716e646661647865627ca66c6565696e676
-- 026:026627f6d60256e656d6965637c20226572796564e16026616d696c6970286569627c6f6f6d60247f6023747f60702964f6627f6d602265696e676024716b656e6026627f6d6028696d6ea709447027716370226572796564602a657374702e6f627478602f66e478656027756c6c602f6e602478656029637c616e64602164f478656023656e647562702f6660247865602c616b6560296ee478656026427f63747c616e64637ea0894660297f65702275636f6675627029647c202262796e67602964f261636b60247f602d6561a20f486120295f657022627f65776864702d65602d69702d65737963e26f6871202
-- 027:458616e6b60297f657026756279702d65736861ad719b0bdef9c64d719ef439fbdefde5bd7485e206defca91196d141a102e106def199139ecef55b2efc58fd3d739ecef55b2ef357ed3196d6419ef0172bdef409b285e20d7285e2039ecef55b2ef7b0ed3d71db59e71dc75516bdce54f71fc7556919c75c6910dd5579100002b1960751a30c74010e7405f7def6f91296f80561a50e75002196fcdef7f916840104def9d91d71b1950751a20a820202e205defd0a1293f10bdefb6e8d79bc7a00868a03f78a010294f40351ab0e7a0dfb06def64a1294f10351ac02ec06def64a1696f7f8f9fafbfbd5f1ac02ec05d
-- 028:ef64a1194f74d7d72b293f4fbdef829b1a10293f4fd71b1869101901bdefac7b2e997def76a1d7c720df99c79900193fbd4fd76b193fbdefe37b1a90293f80561a70e770225def3aa14890806def7ba1e760106defe9a1293f01bdef0a7b395f6f7fd74850105def98a1c7805f9880406830af4def98a14850106def09a1c7805f9880406830af4def09a1d75b4869105def7da1684050194fbdefe37b1a704870015def9ea1684050294f80561a90e790036def9fa1185040f78000ffffe780f77def21b11850081850ef00101850ef0020395f6f7fd72bc74001293f30e41a50293f20e41a3088308098307f4830ff
-- 029:cf6defb3b1c7405f6840c088206f982001194fd74b393f5f6fbdef78f51910f51a50493f4f5f6fbd7fd71b293f40351a20e720e3cdeff5c1e720b6cdeff5c1d72b193fbdefa5b1688910193fbdef86f5293f4fbdef0d91293f4fbdef9b8b2e2fadef79b1782f101930f51a30293f4fbd5fd73b1920f51a402e405defdbb1393f4f5fbd6f1a802e805defdbb1d7c750ef04dab8607f2e605def5eb1685010c8707f685020e7603f6def2cb1393f4f5fbd9f4defaeb119efc39224d7bdefa3c11940f51a101900bd3fd71b6879102e10cdefa3c12e2f5def71c159ef0410cb04df2fffffbdeffb294869105def62c139be
-- 030:8c04bdeffb29483f105def53c1397d4d04bdeffb29bdef8d7bd7bdefd2bb1a102e105def94c1c72010bdef3cfb1a102e105def85c1c72010194fbdefd929d7483f106def17c1f730a04129005fbdef4059d7b78630642a352ac137d7203bc794a006986669f166c6baf19894adf107474ef1b7a5fef1c9e4aff1d8f4300200002bd71b293f10351a202e206def2fc1390000ef3fc1d3390000efb2d1d3390000efacd1d3390000ef32e1d3390000efe7e1d329efdbe1ef6de1041a30390000ef15f1d3191ce3193f7419ef8831bdef409bd7d7204586963702963702160237471647575602f66602b496e67602651686
-- 031:e6ea140207c616175756024756c6c63702964737023747f62797ea80b496e67602651686e6723702762756564602275796e656460286963fb696e67646f6d602778656e60286560237f6c6460296470247fe4786560235f627365627562702b496e6760296ee5687368616e676560266f6270207f6775627ea08845602c6164756270227560756e64756460216e646027756e64ff6e602160217575637470247f6024656665616470247865e35f627365627562702b496e676ea4084560207562796378656460286562756c202669676864796e67e4786560235f627365627562702b496e676723702d696e696f6e637
-- 032:ea45869637023747164757560277163702265796c6470296ee8696370286f6e6f627ea40849637023777f62746022756d61696e6370286562756eac4567656e646023716973702b496e67602651686e6027796c6ce2756475727e60247f60236c61696d60296470216e64e6696e69637860286963702d696373796f6e6ea30355736860216022656165747966657c6023777f62746e2e2ea95f65702665656c60236f6d60756c6c656460247fe4727970247f60237475616c6029647ea1035475616c602b496e67602651686e67237023777f62746fb40955637e20284560277f657c6460286166756027716e6475646
-- 033:0257370247f6ea955637e2029447723702e6f6025737560247f6028696d602e6f677ea955637e202f4572702d696373796f6e602963702362757369616c6ea955637e20294470246f65637e6724702d616474756270277869702f6270286f677ea4095f657024716b65602478656023777f62746ea95f65702c696b656029647ea95f65702665656c602478616470297f65702465637562767560247fe86166756029647ead739ffbfef0082ef8dfdd339ffbfef0082ef2dfed3d7bdeff8391a10e710106def9df128df0228df0428df0828ef0128ef0228ef0428ef0828ff0128ff0228ff0428ff08d7397eef0082ef
-- 034:753ed3d739ffefef0082ef35edd3d739ffafef0082efd28fd3d719eff27bbdef4f6bd769ffefef97a2ef6102ef9e7e4680bdef7ad8d71094023756c6c60216d657c6564737ead7af10ea00004b888020411055c36dd317d33fc3a1e21410b3e320c3a30063532014d300b47300250400750410a3063073e420a3350043d520d1e52051070033c700652700866200659200844320704310317120228120b7760019833027d7308a613010d8acaf202596675627023416675602c41b2d00e1111040302025e40000dce40000204de010aee03000af302596675627023416675602c42b2d11e1111040202033f4000088f4
-- 035:0000105d311000af4025966756273796465e2d22e11180301010df8700007ba7809750bd03009e3220ee0330de5220fd723000af50f427368616274e2d330111803030103e35000035450000109d532000af60d4f657e6471696e6020516373f2e33e011803020206e8a0000239a0000209e0400ce533000af704557e6e656ce2d44e11110402020e423000036230000204d7410def41000af803557e60205f627470245f677ee2d5501118030104060e6000037f6000010ad460000af90f4c6460245f677562702c41b2e55e01110402030a8f30000aef30000208e46003e951020d8b8c807afa0f4c6460245f67756
-- 036:2702c42b2d66f0111040203030040000a604d50420fd86304d861020d8b8c807afb0f4c6460245f677562702c43b1e66f011104020309a1400001424000020ee86303e571020d8b8c807afc0f4c6460245f677562702c44b2d77f01100402030d524000002341d2420fdf7303df71030d8b8c8072789afd0f4c6460245f677562702c45b1e77f01110401030c33400003f440000108e872040d8b8c807278937b9afe094e6469676f60282275796e69a4b00f0b080300010c5650000ea65000010bb102000aff094e6469676fe3c00f0b080300010eb6100009c611b6120ac1020ac501000af013456c6c6162f4bb0e1
-- 037:60104010206155000034550000105bd01000af1135f6574786024556d607c65e4b11d0a08030101077b900000000000010ab212000af21a41696ce1c11c0e021403020185800002de7cce710bcc13000af310596e6e61636c65602c41b4b22a01180301080fac900000000000020bb03005b621000af410596e6e61636c65602c42beb22a0118030108029d9000000000000206c4230fbf21000af510596e6e61636c65602c43b8c22a070c03010808c0a0000ed0a0000100d423000af6164f627563747023496479f8c92a0a080300010c4a400000000000010dc030000af7134163747c6560235f657478e4b33f011
-- 038:80300080dc0d00008d0d000010bb4320204a7ad88aaf8145865602d4f6e616374756279f3c33f01110403030d17800003478000010ac432070d8aa17ba37b959ca79da47eac8faaf913516e6460284166756ee4b44f0d0803010406eb200001fb28db220bb5420bbd40030171b272b573bafa13516e6460245f6d62602c41b4b15f04010401020d020000022200000205b25100c353060d84bc86b175be87bf88b79bbafb13516e6460245f6d62602c42b3c44f070104010204730000098300000204c5410fc943060d84bc86b175be87bf88b79bbafc13516e6460245f6d62602c43b3cb4f0a0104010208b300000dc
-- 039:30000010fcc41060d84bc86b175be87bf88b79bbafd17556374707f627470245f677ee3c55f0c080301010cd7100007e710000100db53000afe1e4f627478602b456560f4bb1d070803010604faa0000ffaa8eaa20ab0200abc120204a7ad88aaff174c6163696563f4b55f0b080301070036400000000000010bb65202017ac27bcaf02458627f6e6560225f6f6de4b06906000401060df25000000000000108b4600304aeac8fad8aaaf1245f677e602f6660255d626271edb065160104010204bfa00000000000010eb26102017b82789af2294365602d416a75e4b66011180401070323b0000933b000010ab7610
-- 040:10d8acaf329476e6963f4b77e11190401090850600003606000010eb580040d84d071dc81d592daf42c4f6374702c496262716279f3c66f080104010306e9a00001f9a0000104c761030d8b9c80727890010e4f6478696e6760296e60286562756ea1034c696d6260257070247865602374716962737fb1074f60246f677e60247865602374716962737fb20e4fe95563f103486f6f63756ab2024579f3556c6ce10c456166756fb10c4561667560247f677e6fb10c456166756024786560236163747c656fb45f677e6027616475ef427368616274e2045869637029637024786560256e6472716e636560247f60216
-- 041:024656560f57e64656277627f657e646024757e6e656c6e20254e6475627fb1045869637028657470296370256d6074797ea10255616460247865602370756c6c626f6f6b6fb45f677e602f6660294e6469676fe45f677e602d41697f62702f6660294e6469676fe30f4c6460237471696273702c65616460296e647fe47865602461627b6e6563737022656c6f677ea4456373656e646fb2035471696273702c65616460257070247f60247865602f6574737964656ea548796470236166756fb24c61636b637d696478e1407f64786563616279f2596e676023586f60f353627f6c6c6023586f60f1427d6f6270235
-- 042:86f60f24f6f647023586f60f45f677e6028416c6ce45271696e696e676028416c6ce7456e6562716c6023547f6275e94e6ee35f6574786027416475ee4f6274786027416475e3456c6c6162f745716274e45f677e602f6660225966756273796465e35f6574786024556d607c65e4556d607c65e45f677e602f666023557e60205f6274f2054e6475627024786560247f677e602f66e259667562737964656fb6596c6c61676562f845616c6562f34c65627963e84f6f64656460266967657275ed4f657e6471696e6020516373f3014027796e64696e6760247271696c602c65616463f96e647f6021602d6f657e647
-- 043:1696e60207163737ea54e6475627fb3014027796e64696e6760247271696c602c65616463ff6574702f6660247865602d6f657e6471696e637ea54e6475627fb45271696ee20458656275602963702e6f6478696e67602d6f6275e7756023616e60247561636860297f6570286562756ea4095f6570216275602e6f6470227561646970247fe16466716e6365602975647e20234f6d65602261636bec616475627ea082054c696769626c6560247f602c6566756c6025707ea44f60297f65702779637860247f60247271696e6fb107586f6027796c6c602561647fb107586f6027796c6c602462796e6b6fb10e4f647
-- 044:8696e676028616070756e65646eac497c61e65963e503416e6724702c6561627e602370756c6c6ea0895f65702d657374702265602c6566756c6023bf627021626f66756ea503416e6724702c6561627e602370756c6c6ea0895f65702d657374702265602c6566756c6024bf627021626f66756ea45271696c60247f6020596e6e61636c6560245f677ee64f627563747026596c6c616765e051677e6023586f60f3586f607b6565607562f6427579647023586f60f34162747f67627160786562f65f696365e64c656473686562f05f49435f4ec1435c454540d354525f4e47c94e4659435ea6425f4a554ec14c454
-- 045:254d34163747c6560235f657478e7416475e458627f6e6560225f6f6deb496e67602f666024786560235f657478e15575656e602f666024786560235f657478ed4f6e616374756279fd45627368616e64f24f61647d616ee20c4561667560296470257e6469637475727265646eac4f6f6470296470266f627026716c6571626c65637ea7596a716274e45271646562f20458616e6b6370216761696e6120274f6f64602c65736be96e60297f657270216466756e647572756371ae4f627478602b456560f7486f6374f45f677e602f6660274c6163696563f458696566ed41627b65737c20267963656d276f6675627
-- 046:e6f62f103416374702f6e6027786f6d6fb548707562747023586f60f54870756274f2556374f10944656e6479666970277861647fb353686f6c6162f20944702568707c6f64656370216370297f65f4727970247f6025737560296471a4000306100409000503100608000707100808100909100a01200b0f100c0d100d0e100e03200f0f00001e00001000039ef9bb29110bdefebe81900d72054e64756270247865602275796e63ff666023516e6460284166756e6fbd7484e025def5eb229efbbe4c565d74b293fef9df2bdef6f19d72b39103fef62c2bdefe0a139203fef71d2bdefe0a139303fef7ad2bdefe0a1
-- 047:39403fefcfd2bdefe0a1d739ef82621011bdefebe8d7390000ef73c2d3390000ef7ac2d31910d760144702c61637470297f65702861667560266f657e646029647ea45865602275796e63702f666023516e6460284166756e6ea08458656275602963702e6f6478696e6760226574f56d6074796e6563737028656275602e6f677e202458656275e963702e6f626f6469702c6566647ea60e2e2e2f627029637024786562756fb0814020727563756e63656029637023616c6c696e6760297f657ca46962756364796e6760297f6570247f60247865ef42656c69637b602f66602478656023557e60216470247865e37
-- 048:f6574786020716274702f666024786560236964797ead7390000ef62d2d3390000efa3d2d3d710140267f6963656027786963707562737e2e2ea6094470296370216e60216e6369656e64702c616e6765716765e97f6570246f6e672470257e6465627374716e646ea082457470297f65702665656c60247861647029647723f37f6d6560237f6274702f66602771627e696e67e1626f657470247865602f42656c69637b6ead7390000effad2d3d7404586560267f69636560236f6e64796e65756370247fe778696370756270296473702771627e696e6760296ee97f657270256162737c202e6f67702d6f6275e96
-- 049:e63796374756e647c697ead7390000efb0e2d3390000efd4e2d3d73045865602778696370756273702265636f6d65602c6f657465627ca16024786f6573716e6460267f6963656370237075616b696e67e96e60297f6572702561627ea6095f6570257e64656374716e64602478616470297f65f16275602e6f6470247f602275616460247865e96e637362796074796f6e602f6e60247865602f42656c69637b6ea08955647c20297f65702665656c60237472716e67656c69f46271677e60247f60246f60237f6ead759df4e40ef4de200c0bdeff4f21a102e106def0de2d7284e40d7204586963702160707561627
-- 050:370247f60226560216e602162616e646f6e6564e24c61636b637d6964786023786f607ead759df4e80eff1f20041bdeff4f21a102e106defb1f2d7284e80d7204586963702160707561627370247f60226560216e602162616e646f6e6564e1627d6f62756277237023786f607ead75b48104f6def38f23900005fd32900ef88a2041a60e760205defe6f21900d72e405def77f2196f442e505def08f2197fe31910d719ef1d52241900d7484e026def79f2bdefb200d749ef5af24050efc3c3bdef2e49d720458696370207f6274716c6027796c6c6024716b6560297f65f261636b60247f602259667562737964656
-- 051:e20254e6475627fbd7bb44b1c27b84abe27bb450f2bbe4b8f200001b29efa30310f41a202e205def9303293f10351a302e306def3303193f74c740df0fa840c0680f10a80fffffc7506f8850306850ef7503b8607f685010c8707f298f9fbdefb703d719efc39224d7d710458627f67702160236f696e60296e647f602478656027756c6c6fbd720000030000040000050000010af00604f10200000300000400000500000104f10608e302be710105def7a03e710205def0b03e710305defcc03e710405def8e03e710505defdf03e710605def2113d719ef771324194f44d719efb11324293030bdefb9f8292030bd
-- 052:efb9f84900ef102380c036d719eff31324296030bdefb9f8295030bdefb9f84900efa02380c036d719ef4b1324294010bdefb9f84900ef312380c036d719ef6e1324297020bdefb9f84900ef912380c036d719ef4a1324194fb4d72095f65702665656c602d6f627560227563796374716e647ea82b23302d416870284059a3095f65702665656c60297f6572702370756c6c63616374796e67e162696c69647970296d60727f66796e676ea82b23302d416870235059a2095f65702665656c602478616470297f657270207f636b656473f1627560216022696470286561667965627ea1095f65702665656c6027796
-- 053:375627ea2095f65702665656c602d6f627560237b696c6c656460296ee36f6d62616470282b213021647471636b6023736f6275692ea2095f65702665656c602661637475627ea82b2230237075656469ab23302d4168702840db23302d4168702350db2130214474fb22302350756564ed71960751a10e710409def932339ef65627010bdefebe8d72930ef7e9fbdef6629d739ef65627020bdefebe8d74b293fef2b23bdef6f19e73082293f20cdef90b3d72b59103fef95295050bdefe0a169203fef9529505021bdefe0a179303fef952950502121bdefe0a179403fef952950502121bdefe0a1d749ef2e5210b0
-- 054:50bdefebe8d749ef2e5210c050bdefebe8d73d74a923cef46a230000ab65963e403f00304190009000f000f0000100000050000000000000000000000000002090a0abc497c61e301f506091e000e0000000000011000000000070000000000000000000000000f03331337133b13314c6568fc456f6eec497c61e65963ebb0000002000000000ab14c6568f100f5040a0310031000000000001000000500000000000000000000000000000abc456f6ee202f5040a02100210050005000010000005000000000000000000000000000002009001600870000000000000010bb0000004000000000ab14c6568f100f50
-- 055:40a0310031000000000041000000c0008000a100e10000000000000000abc456f6ee202f5040a0210021005000800041000000600070000000e100000000000000501030402050abc497c61e301f506091e000e0000000000041000000000090000000e10000000000000000ab65963e403f00304190009000f000f0001200000050000000000000000000220000005090a0b0c0d0440ae10ae10ae10ae11a802a803a8089205a806a807a808a809a80aa80ba80ca80da8020f129203c201c202c2004200420042016204f20092019205f201420362032200f203f201f202f2039204920491059205920592059206920
-- 056:79200b201b202b203b204b205b206b207b208b209b20ab20bb20cb20db20eb20ea409220a220b2209220a220b2200eb00000c62f0000100000000001955d43d1d5ddd661d65c53511721f3b0366d53b0b6737b0000484e206def1053390000ef7053d32900efd453041a10e710206def6053284e20390000efd853d319ff6fe3d719ef675324d7304586963702865747021607075616273702162616e646f6e65646ea458656275602162756020796c6563702f6660227f6474796e67e26f6f6b6370216e646020716075627ea20c456166756029647021637029647029637eac4f6f6470296470266f627026716c657
-- 057:1626c65637ea10e4f6478696e67602f666026716c657560286562756ea4095f65702375616273686029647ea0895f657026696e64602160237472716e6765602679616cef6660207572707c6560296e6b6ead72bd719efbc5324d710f4c6460245f677562fd71b293f10351a302e306def0363193f7439ddef20a2ef6363d32900ef7663041a20e720105def4263e720205def8263e720305defc263e720405defc263390000efd863d379d0d0d0d0d0d040e5d7194644d719a044d7191044d719efc39224d7407556c636f6d6560247f602478656027556c6cef666027427565646ea08758616470246f60297f65702
-- 058:465637962756fb60e4f6478696e67e13760f1303760f130303760f13c2030303760f13c2030303c2030303760f203516e6460277f627d63702a657d60702f6574f6627f6d602478656027756c6c6ead760433b713161cc6361249273f0047673c0c3077380a3e77300002bd7484e086defed6339ef9e63e010bdefebe8d739eff073f010bdefebe8d72054e64756270247865602275796e63702f66e4786560245f677e602f6660294e6469676f6fb2054e6475627024786560247f677eef6660294e6469676f6fbd769ffafef97a2efc373efbf6f4620bdef7ad8d7208496120294023756c6c602478656022656374f
-- 059:8656c6d65647370296e6024786560227567696f6e6ead719efa3cfbdefbd5bd74960ef449e30ef5592bdef0f29d7bdeff8391a10e710106def797328af1028af2028af4028af80d74664e383b614ea7345b41d833794cea3f32500b30000484e086defdc7319ff8f141a102e107defdc73390000ef3d73d319ff8fe3d719ef1d5224d75035561627368696e6760247865602865747c20297f657026696e64e16e602f627e61647560294e6469676f602354716475756474756ea089447022656c6f6e676370247f602478656023696479702f66e94e6469676f6c20296e60247865602e6f627478677563747ead739ff
-- 060:afef0082ef9483d3d7504586963702963702478656022416d626f6f6027427f66756ea341627566657c612029447029637026657c6c602f666026756279f4616e6765627f6573702d6f6e63747562737e20294660297f65f3616e67247022656164702478656d602e6f677c2022756475727ee778656e60297f6570216275602d6f627560207f67756276657c6ead72bd719ff5f141a102e107def139319ff6f141a102e107def3f8339fdef6f92efb393d3d739fdef6f92ef90a3d319ff6f64390000ef73a3d339fdef6f92ef96a3d3390000efd8a3d339fdef6f92ef0aa3d319ff5fe319ef8e30bdef409bbdeff4f5
-- 061:d739fdef6f92ef6a93d3d7509472d602d616b696e67602160275f627c64602d41607ea45f6026696e6963786029647029402e65656460205572707c65e35175796460294e6b6e20294477237026756279702271627561a94660297f657026696e6460216e697c202262796e67602964f47f602d6561a40940286f607560297f657021627560256e6a6f69796e6760247865e75f627c64602d416071202242796e6760296470247fef6478656270236162747f676271607865627370237f6024786569f3616e6025707461647560296470266f6270297f657ea201486120295f657022627f65776864702d65602160267
-- 062:9616cef6660205572707c6560235175796460294e6b61a2095f657028616e64602f66756270247865602679616c602f66e96e6b60247f6024786560236162747f676271607865627ea2045869637027796c6c602f6e6c697024716b656021e66567702d696e657475637e2e2ea104577f60286f657273702c616475627e2e2ea30143702940237169646c202964702f6e6c6970247f6f6b6021e6656770286f6572737e2021437021602275677162746ca8656275602963702160236f6079702f6660247865602d616071ad7bdeff8391a10e710106defffa328df8028df01d719ef627bbdef4f6bd72b493f00004fbd
-- 063:ef63b31a30195fd72b493f4f0000bdef63b31a30195fd72b493f004f00bdef63b31a30195fd74b293f10351a502e506def46b3193f742e207def85b32e307defe5b3196f541910d7194f441910d7195fe31910d719ef1d52241900d7000000000000000084c384c3c1c333c372c372c384c384c341c333c372c372c384c384c341c3ccb3ccb3eeb384c384c35db35db31eb31eb3e3c3e3c370c3afb3afb3e3c3e3c3e3c370c3afb3afb3e3c3e3c3e3c370c3afb3afb3e3c3e3c3e3c325966756273796465e3556270756e647029437c65e24c6f63737f6d60205c61696ee2416d626f6f6027427f6675e35f657478602
-- 064:b496e67646f6de3516e64697029437c616e6463f7556374707f6274f24c6575602649656c6463f74275616470244563756274f45865602d416273786563f6427f63747c616e6463fe496768647029637c616e6463f4b293fefbb9cbdef6f19293fef9b3abdef6f19293fef169bbdef6f19293fefbb43bdef6f19293fef761abdef6f19293fef0b63bdef6f19293fef8973bdef6f19293fef8095bdef6f19293fef27c1bdef6f19293feff9fbbdef6f19d7295f6fbdefffe8d71910751a10193fbdef25092a20309820e1983011c7405f8840c068404f68404f6840efc6b3c8406f2e405defbec3196f86d719ef1fc386
-- 065:d7fbd72e295def00d319df29bdef409b2e395defa0d319df39e3c72900c73900482e10ddef54d3484e02cdefa6d3484e08cdef08e3bdef9bc3485e10ddef83d3d729ef9a618165d729e3969629b6d39629c6a396d729ef4117716529ef5117716529ef6117716529ef4127716529ef5127716529ef61277165d729ef8433d165d72bbdef9bc3193fbdef47741a302e306def5dd3293f4fbdefb43c293f4fbdef985a293f4fbdefc5bb293f4fbdef3c53293f4fbdef981a293f4fbdefac63293f4fbdeffc83293f4fbdefa295293f4fbdef0ac1293f4fbdefdbfb195d141a402e40ddef13d3d73be710ff7f5def9ed3e7
-- 066:10145def0fd31900d7bdefbfd31910d719ef8ce3bdef70d51910d7bdefc1291a10293f40351a20e720f06def91e3193f74390000ef65e3d3d719eff1e324d7204586560254d6562716c64602b45697023616e602f6e6c69f265602573756460247f602f60756e60254d6562716c646027416475637ea2095f6570257e6c6f636b6024786560276164756027796478e4786560254d6562716c64602b45697ead7c72021e720f17def7ce3c710b0e710a17def0ce3293f4fbdef76091a30295f40351a40e740965def5be3e740725def5be34def9be3295f73656810104defd8e36820104def38e3d7c0a4020057d56466
-- 067:d000ffd5b4a3190057d5c85223009bd5e8520000c29509520c0057d5c87200003395e872220057d509723c0057d577f63d0057d5f672e000ffd592485d0057d50000482e106def53f31960751a10e710406def03f339ef47f39010bdefebe8d719ef63f324d73045865602f4c6460245f6775627029637020727f647563647564e2697021602370756c6c6e20295f6570246f602e6f6470286f67f47f60256e6475627ea1054e64756270247865602f4c6460245f6775627fbd74be710ef8e565defcaf3e710ef8eb55def4cf3e730825def1bf3e730c05def9bf3d7bdefdcf3d7293f20bdef90b3d739ef2e52a010bd
-- 068:efebe8d7293f12bdef72b3d7d739ef8df310e0bdefebe8d710c456166756024786560247f6775627fbd72b49103fef9529b0bdefe0a159203fef9529b0b0bdefe0a1d74be710ef3d575def5504e730825defe204e710ef0e865deff304e710ef3d865defa404e730435def6304d7293f20bdef90b3d7393f5f6fbdef7014d739ef7f529020bdefebe8d739ef2e52b010bdefebe8d7293f16bdef72b3d7482e016def5604d7bdefe914d71b69103fef9529b0b0b0bdefe0a169203fef9529b0b040bdefe0a1e710efad865def8904e710ef8d865defea04d7482e026def2c0419ef0f04243900ef3c04ef8c04d3d7482e
-- 069:026def2c04282e023900ef3c04ef9d04d3d7d765f696365e1094023616e6023756560297f657e2e2ea107586970246f60297f657024696374757272602d656fb1095f657028656162702160277869637075627e2e2ead73b2e306defe114282e01bdefe914193f7419eff11424d7d76045865602d656368616e69637d60277869627c63702e6f6963796c697ea4586560226279646765602f6675627024786560266c6f6f646564e27f6f6d60286163702265656e60256874756e6465646ea0845865602e6f696375602d6169702861667560216474727163647564e37f6d6560216474756e64796f6e6e2e2ead739ef
-- 070:7d861040bdefe809d74be710effe865def4e14e710efee575defaf14e730825def4d14e730435defcd14e710ef2e575deffe14d7293f20bdef90b3d7293f6fbdef2024d739ef7f52a020bdefebe8d739ef2e52c010bdefebe8d7293f16bdef72b3d72b2e206def612419ef4e8674193f7419ef712424d72095f657020757c6c60247865602c656675627ea458656027616475602963702e6f67702f60756e6ead72b79103fef9529b0b0b0b0bdefe0a159203fef9529b0c0bdefe0a1d74be710ef0ef75def0924e710ef8e385defea24e730825def8824e730435def6a24e710ef2df75defb924d7293f20bdef90b3d7
-- 071:39ef7f52b020bdefebe8d739efdb24d010bdefebe8d7293f6fbdefed24d7293f16bdef72b3d7c496262716279f1054e64756270247865602c4962627162797fbd7482e046def9d24d7bdef5134d72b2e206def4f24282e04bdef5134193f7419ef5f2424d720458656023656e64756270226279646765e7716370256874756e6465646ead739ef5df71090bdefe809d72b69103fef9529b030c0bdefe0a169203fef9529b0b0c0bdefe0a1d74be710ef8eb75def8634e710ef8e775deff634e730825def0634e710ef8e585def5734d7293f09bdef72b3d719b0bdef93f8d719ef9a3424d7390000ef7d34d3390000ef
-- 072:5144d3390000efc544d32900ef5844041a50e750105defa934d7390000ef9a44d3282e102910e0f3d7204586560246f6f62702963702d61676963616c6c69702c6f636b65646ea95f657023616e6724702c656166756ea302556164696e676024786560226f6f6b6c20297f65f46963736f66756270247865602c6f636164796f6e602f66e4786560225564602342797374716c6ea309447029637028696464656e6022656e65616478e47865602f42656c69637b60296e6023516e6460284166756e6ca1602369647970296e602445637562747029437c616e646ea204586562756021627560237472716e676560277
-- 073:f627463ff6e60247865602c61637470207167656ea20351697024786560277f62746370216c6f65746ea34c6f63756024786560226f6f6b6ea50758656e60297f657025747475627024786560277f6274637ca4786560247f67756270226567696e6370247fe36f6c6c616073756ea0895f6570226162756c69702563736160756ead71b39103fefff44bdefe0a1d73900ef4154ef1254d3c799ef455449b0b0c0e0e5d77486f63747c6970267f696365e409402771627e656460297f657ea0895f657027796c6c602e6f64702c656166756024786963f47f67756270216c6966756ead7390000eff654d3390000ef1d
-- 074:54d319ff3fe319ef8831bdef409bd740458656027686f6374702469637160707561627370296ee160236c6f6574602f6660237d6f6b656e20295f65702665656ce47861647021602762756164702566796c60286163702265656eec69666475646026627f6d6024786560277f627c646ea201437024786560237d6f6b6560236c656162737c20297f65f6696e64602478656029556c6c6f67702342797374716c61ad739ef0164f110bdefebe81900d72054e64756270274c61636965637c20247865e3496479702f66602943656fbd74b293fef3a64bdef6f19d739ef82621071bdefebe8d739ffdfef0082ef73afd3
-- 075:39ffdfef0082ef2c4fd3d719c0bdef9c64d719efd16ebdef8c5bd719efdeafbdefde5bd739ffffef0864d2bdef4a09d7107556c636f6d6560247f602478656029436560294e6e6ead7397eef0082eff91fd3d7bb55b3646b7564640c75b564eb752664ebd5b6640cd5516b1ca52b6b6be547646ba5996400001b39ff6fef5772efe074d31930751a20e720e18defc474e7203f8defc4741940751a302e305def7574c7404f68401088406f8840a029ef3f826ff41a502e505def267405d73064f62702160237d616c6c602665656c2027756023616ee47271696e60297f6570247f60216466716e636560247f6024786
-- 076:5ee656874702c6566756c6ea39ff6fef5772ef5982d3d739ff6fef5772ef1c82d3d7d7107586f6027796c6c60247271696e6fbd71bbdef13842a20302e205defe874295f4fbdef19741a40196fd71900d72b193fbdef25092a40509840e1985011c760efcc3bb8808f686010b8708f686010c8908f686020e780ffff5defad74e7806f6def6a74e7707f6def6a7429bf4fbdefdd741a30195fd71900d72bb8403f681010b8b03f681010e720dfb07defe284c7304f78301088306068105fb8503f681010b8603f681010b8703f681010b8803f681010b8903f681010b8a03f681010797f8f9fafbfcf6fe51910d71900
-- 077:d71910751a10193fbdef25092a2030c7404fc7505f782030783030684030685030c7605fe7607f7def5a84c7704fe7706f7defe984299f8fbdef76091a10293f40351a807880f72e80adef7984e780607def7984293f10351a902e906def7984193f7429af3fd76870104defe5846860104def4584290000d73b194fd62a1050f7600046e760e19def2c844850206defd4942e306defcd844900efc2921010d41a302e305def65944deffe842900ef095e041a40293f4f64e740205def5494293f4f64e71009195fcdef7594e71019195fcdefa694e71029195fcdef6794e71039195fcdef4894e71049195fcdef9994
-- 078:e71059195fcdef4a94e71069195fcdefab94e71079195fcdef4e94e71089195fcdeffa94d7295f3fbdef2f94d7393f4f5fbdefb468d7d71b393f9c00a5293f10bdef0a7b19ef329f24d71b393f0041a519ef386f24d71b293f01bdef867b19efb01e24d71b293f20bdef0a7b293f02bdef867b19efdbad24d71b293f102719ef38dd24d71b293f202719ef66fd24d71b293f402719ef03cd24d71b193fbdefe37b1a204820406def7d9419ef41ed24293fe1bdef4059d7293f40bdef0a7b19efc17f24d71b293f10bdef0a7b19ef4d7f24d72bc740a0c75041e720495def41a4c750e1e720695def41a459206fefb1a4
-- 079:fc22b5d7c7407f4defa0a4478627f6773702160207f64796f6eed739ef83a46110bdefebe81900d71054e647562702478656026796c6c6167656fbd74b293fefa4c4bdef6f19d71910bdefc88b1a102e107deff6a4398eef8082ef69a4d3d7398eef8082ef7ba4d329efdfa441f41a202e205def59a41910bdefac7b398eef8082eff0b4d3d72094660297f657027656470207f69637f6e65646ca2756475727e60286562756ea4095f65702e65656460296d6d656469616475e4727561647d656e6470266f6270207f69637f6e6ea94023616e602365727560297f6570266f627021e37d616c6c602665656ea102556
-- 080:36569667560216e6479646f64756fb2095f657023786f657c64602265602665656c696e676021e2696470226564747562702e6f6771ad739ef826210a0bdefebe8d7483e806def16b4192d141a102e107defb6b4283e40398eef0082ef38b4d3d7398eef0082ef3bb4d3d7398eef0082efadb4d319ef8bb0bdef409b192d64283e80d72094660297f657026696e64602d6970276f6c64656ee2627163656c65647c2022756475727e60296470247f602d656ea20458616e6b6370216761696e60266f627022756475727e696e67ed697022627163656c656471a40f486120295f6570266f657e64602d6970226271636
-- 081:56c656471a08458616e6b60297f6570237f602d65736860266f62f2756475727e696e6760296471ad739ffffef52c4f0bdef4a09d7107556c636f6d6560247f6024786560264f6275637470294e6e6ead719eff5bdbdefde5bd7dc1373b40dc275a4ecc291c4acf2516bacd224b40df214c400001bc750806900008bc62020c5c7203f7820108820f268204139ad4fa616c7403f7840106840efe4e4b8306f395f807f16c7403f7840108840206840ef7033c8406f68501049617f6ff0d5293f10e41a60c7408f7840108840206840ef9446c8406f49c37f6fa0d51930751a6049d77fef9dd48fbdef31e46850f0293f
-- 082:20e41a60293f30e41a7069807fefcdd48f9f21bdef52e4293f50e41a60293f60e41a7069a57fefedd48f9f21bdef52e46850a0293f90e43a8090a049807fef0ed4afbdef31e449a57fef6ed4cfbdef31e46850a049807fef3ed4bfbdef31e46850a049807feffed4f0d5c7b07f69427f603f10eff0a2bdef4fd41a5069427f303f20ef51a2bdef4fd41a5069427fd03f40ef72a2bdef4fd41a50c750dfb069057fb03f80efb1a2bdef4fd41a5069057fb03f01ef12a2bdef4fd41a5069057fb03f02efd2a2bdef4fd41a50c750651970751a6049807fef9ed48fbdef31e46850a01920751a601980751a7069807fefde
-- 083:d48f9fa2bdef52e4d7c467ce840d350d14474f44566e35074e74f6c64e850d34f6e64ed76b196fbdefe37b1a7048707f6def70e4194fd7493f4f8f5fd56820a0194fd74b493f4f5ff0d56810c1593f4f6fa010d5d76b493f4f5ff0d56810c1593f4f6fa010d568108f493f4fefc4e4a0d5681080593f4f7fa010d5d7fad70f2f1f3f4be730c05defb8e4e730c15def89e4e730f25defdae4e710efbd705defd9e4e710ef6ee05defd9e4e710ef7e205def5ae4e730825def09e4d7bdef5be4d7293f10bdef90b3d7bdef1ce4d7293f04bdef72b3d7293f09bdef72b3d7293f6fbdef29e8d749ef8072104050bdefebe8
-- 084:d749ef7f52301060bdefebe8d72b39103fef0fe4bdefe0a159203fef95291010bdefe0a149303fef952920bdefe0a1d72e2f7defffe42920ef00f4bdef6629d7209447723702461627b6e2027556023786f657c64602c69676864f160247f62736860247f60237565602f6572702771697ead74be710efad715def08f4e730c05def16f4e730825def66f4e730435defe6f4e730335def67f4e730c15defb7f4d7bdefdaf4d7293f10bdef90b3d7293f6fbdef5005d7bdef6cf4d7bdef0905d7293f04bdef72b3d72b49103fef952920bdefe0a159203fef95291020bdefe0a159303fef95292020bdefe0a1d729ef2e
-- 085:52efb062041a10e710206def5cf41950a4292020f3d719efccf424d73095f657023616e6e6f64702f60756e60247865e9627f6e60226162737e202d416972656024786569ff60756e60256c637567786562756fbd72b2e206defa10519ef2ed174193f7419ef550524d719ef020524d72045865602c6566756270296370216c62756164697020757c6c65646ea458656029627f6e60276164756370216275602f60756e6ea3095f657020757c6c60247865602c656675627ea458656029627f6e602261627370247f60247865e775637470216275602e6f67702f60756e6ead7390000ef7f05d3390000efb415d339ff
-- 086:ffef4e05ef7715d3390000ef4d15d3190fe3191fe3192fe319ff3fe3390000ef4025d339ffffef4e05efa525d3390000efe925d3280e20c729ef0d701950a4291040f3d7c457361637c2024786560276f6675627e6f62f3014370297f657024656373656e6460247865602374716962737c20297f6570236f6d65e163627f637370216e60257e636f6e6373696f6573702d616e6e202845602963f7627166756c6970277f657e6465646ea20845602167716b656e637c20216e6460237075616b637027796478ed65736860246966666963657c64797ea60940216d602c457361637e2e2e20276f6675627e6f627e2e2
-- 087:eaf66602259667562737964656e2e2ea08940286166756e2e2e202661696c65646ea95f65702d65737470236f6d607c656475602d69fd696373796f6e602e6f677e2e2ea2084560256874756e6463702869637028616e6460216e64e76966756370297f6570266f6572702362797374716c637ea4014370297f65702275636569667560247865602362797374716c637ca97f65702665656c60216027627561647023756e6375602f66e27563707f6e637962696c696479702775696768696e67e5707f6e60297f657ea302556475727e60247f602259667562737964656e2e2ea35565602d41627b65737e2e2e20267
-- 088:963656d276f6675627e6f627ea8456027796c6c6e2e2028656c607e2e2ea20445637079647560297f65727022656374702566666f6274737c20247865e76f6675627e6f6270246965637026627f6d6028696370277f657e64637ead739ef9e250210bdefebe81900d71054e647562702458627f6e6560225f6f6d6fbd74b293fef1535bdef6f19d739ef1262e120bdefebe8d7bdefc0ba1a102e105def9435485e106def1435390000ef609ed3192fe3390000ef2dadd3390000efeedfd3285e10390000efb2add3d7390000eff89ed3d78b5680358b1631350000480e805def6735480e016defe73539ef68355010bd
-- 089:efebe81900d719ef2b35241900d719ef9935241900d71054e64756270247865602f6273686162746fb10e4f6478696e67602c65666470247f60246f60286562756ea2005279667164756020727f60756274797ea355656023547566756c20247865602f427368616274602b45656075627ead74be730825def8f35e730935def3f35d7bdef0045d7293f10bdef90b3d7480e015def8145280e012920ef8c0ebdef6629291060f3d739ef42451060bdefebe8d7d72095f6570286166756e6724702b696c6c656460216c6c6024786560226577637eac4561667560216e697771697fbd72bbdefe74549103fef952930bd
-- 090:efe0a169203fef9529303010bdefe0a169303fef9529303020bdefe0a1d7480e016def7d4529ef9d0410351a102e105def7d45280e012920ef0a45bdef6629d7304586f6375602775627560247865602c616374f26577637e202c4564772370276564702261636be47f6023547566756723702865747ead700000000200050009000e0004100b1003200c20004006500e60088004a002c002e0040108210e410a8109c10b020052089203e20133028306d30d2405a404be730c05deff255e710effce05def4355e730825defb355d7bdefb365d7193fbdef6465d7293f10bdef90b3d71be710ef7bd05def965569103f
-- 091:ef9529202020bdefe0a179203fef952970702020bdefe0a1d7482e405def1755d7282e4039ffbfefe082eff755d3d790940216d602160236c65627963602164702478656024556d607c656ea94027716370247279796e6760247f60276f60276564f96e63656e637560266f62702f65727022796475716c6370226574f478656023656c6c61627029637026657c6c602f66ed6f6e637475627371a0805c656163756c202765647024786560296e63656e637560216e64e2756475727e60296470247f602478656024756d607c656ea9447723702a6573747025616374702f666024786560236964797ead739ef2e5240
-- 092:30bdefebe8d71b293f1dbdef72b31a202e205defb56519efd9de24d74be730835defc865e730935defc865e710efcb505defc765e710bb5def1865d7bdef0b65d739ef82621051bdefebe8d719ef296524d71045865602265796c64696e67602963702162616e646f6e65646ead71bd719ff8f141a102e107defbd6539ffefef4c62efbf65d339ffefef4c62efe375d339ffefef4c62ef3a75d3d739ffefef4c62efd085d3390000ef3585d339ffefef4c62ef9b85d329f020f3d730940216d60247865602d61697f62702f666024786560245f677eef6660294e6469676f6e20214370297f657023616e602375656ca
-- 093:964772370296e602275796e637ea501402d696e696f6e602f666024786560235f627365627562fb496e676023747f6c6560216e60294e6469676fe354716475756474756026627f6d6025737e20294473f56e656277697029637027786164702b656074702f6572f47f677e60216c6966756ea60944702771637024716b656e60247f602478656022416d626f6fe7427f66756025616374702f66602259667562737964656ca16e64602963702765716274656460226970207f67756276657ced6f6e63747562737ea083416e60297f65702275636f6675627029647fb3095f657022627f65776864702261636b60247
-- 094:86560294e6469676fe35471647575647475612027556023616e60227563747f6275ef657270247f677e60247f602c69666561a4045865602d61697f6270207c616365637024786560237471647575ef6e6029647370207564656374716c6e20274271637370216e64e66c6f67756273702370727f6574702566756279777865627560296ee16e646021627f657e646024786560236964797ea3030458656023786f607370296e60247f677e60216275602e6f67ff60756e6e202245602375727560247f6022627f677375e66f627025737566657c602964756d6370216e64602370756c6c637ead73303939572b294b5
-- 095:a3d2dbb553e0f0b52271ebaaf2412b6bf2b161c5c2a242c500002bd74961616161e5d739616171e5d739ffdfef0082efc795d32900efb062041a10e710205def3595d739ffdfef0082ef8a95d339ffdfef0082efef95d339ffdfef0082ef64a5d339ffdfef0082efbba5d3d72044f60297f65702779637860247f602865616270247865ec6567656e64602f66602b496e67602651686e6fb4014024786f6573716e646029756162737021676f6c202b496e67e651686e60237f6c6460286963702275616c6d60247f60247865e35f627365627562702b496e6760296e6022756475727ee66f6270207f6775627ea3045
-- 096:8656020716274702f6660286963702275616c6d6024786164f86560237f6c6460226563616d65602478696370247f687963e377716d60702e6f627478602f6660286562756ea5084560227560756e6475646c20216e646027756e64702f6ee160217575637470247f6024656374727f6970247865e35f627365627562702b496e676e20284560246965646ca16e64602771637022657279656460296e60247865e7627166756971627460296e602e496768647029437c616e646ea40e496768647029437c616e64602c6965637025616374ff6660247865602742756164702445637562747c20216e64e97f65702e656
-- 097:56460216e60254d6562716c64602b4569f47f602765647024786562756ead739ffffefb1b523bdef4a09d7207556c636f6d6560247f602e4f62747860254e6460294e6e6ea354716970266f6270247865602e696768647fbd739ffdfef0082ef45b5d3d750458656970237169702b496e67602651686e602963f2657279656460296e602e496768647029437c656c2025616374ff6660247865602742756164702445637562747e20295f65fe65656460216e60254d6562716c64602b456970247f60276564f4786562756ead779ffbfef4ba2ef1db5ef4acd461020bdef7ad8d7307556c636f6d65612027556023756
-- 098:c6c60227566696e6564e163636563737f6279656370266f6270247f6461697723f469637365627e696e6760237f6273656275627ead74970ef55de30ef5592bdef0f29d7bdeff8391a10e710106defa3c528bf1028bf2028bf40d71b1930751a708870502e105def35c539ecefc3b2efc79dd339ef64b2efb57f10041a202e205def40d5e720105defddc53900ef17dd10d41a302e305def40d5295fefc1cda61a402e405def40d5295f6f562a50602e505def40d54860105def0fc52e105def0bc529efb06f9ff41a802e805def40d51860102e105def2cc539ecefc3b2ef0bcdd3297f8fb62e906def5dc5495f6f7f
-- 099:8f661910d739bf7f8fe61910d7c61a902e905def40d519bfd62a50604deff8c519effa6f24d7944656e6479666970277861647fb1900d71b1910751a40bdefc1291a50296f3fbdef53d51a20297f3fbdef53d51a3028205f2e205deff2d5d719ef1d5224d72bc7304fc8405f2e405def05d5e7403f5def35d56830604def93d51900d7293f10351a502e506def05d5193f74683020c8605f683020c8705f198fbd9f1910d71b390000ef18d5d3193fe3d7301466475627024696767696e6760266f627021602269647ca97f657026696e6460237f6d656478696e6760226572796564e86562756ead71b390000ef5cd5
-- 100:d3193f44d7301466475627024696767696e6760266f627021602269647ca97f657026696e6460216023686563747027796478e76f6c6460236f696e637ead71b390000efb0e5d3193f25d7501466475627024696767696e6760266f627021602269647ca97f657026696e6460216e60216e6369656e64f370756c6c626f6f6b6ea0895f65702f60756e60296470216e6460227561646029647ead710702070307040905090609070508090d040e0c00170117021703170419051906190d150e170f140027012702270327042905290629072b0c2c0d2b0e2c0f2400370139023b07340a370b370c3b0d350e310047005
-- 101:40154025703570755065e07120d5f0e5f0f5a00670167036d046a00000bdeff4f529ffff00bdefa2f529dfaf00bdefa2f529dfbfe1bdefa2f529dfcfc3bdefa2f529dfdfa5bdefa2f529dfef87bdefa2f529dfff69bdefa2f56879104879015def92f5c710df8fc720df9f781030782030693f4f7070f010c5d72bc73010c7400048105f6deff3f5594f6fe11130c5684011883020e730ef00109def13f5d728af0128af0228af0428af0828bf8028bf0128cf8028cf01d71b193fbdef25092a2030e7204b8def68f5e730888def68f5c78f4fc79f5fd73be72072393f4f5fcdefffe8e72023393f4f5fcdefffe8e720
-- 102:63cdef9dd8e720f1193fcdefbef2e720e4cdefe2c8e720f0cdefdbf5d719ef3cf524d75045869637027616475602963702d61676963616c6c69f375616c65646ea08f4e6c697024786560254d6562716c64602b4569f3616e602f60756e602478696370276164756ead7190f141a102e105def0506191f141a102e105def050619ff3f141a102e105def0506192f141a102e105def0506390000efda0fd3390000efc7fdd339efdcdf3210bdefebe8d7390000ef535fd3d74b293fef0426bdef6f19d72b59103fef9529f1f1bdefe0a169203fef9529f1f102bdefe0a169303fef9529f10202bdefe0a139403fef5906
-- 103:bdefe0a1d7395eefe0b2ef484ed3395eefe0b2ef1beed3395eefe0b2ef360ed3395eefe0b2ef8fafd3395eefe0b2efde7ed32900ef81ee041a10e710105defad06395eefe0b2ef1fcfd3390000eff31fd339dcefe0b2ef8f5fd339dcefe0b2ef809fd339dcefe0b2efd61ed339dcefe0b2ef87ced3c799ef31161912bdef95291910d7390000efc9edd3395eefe0b2ef3f5ed3395eefe0b2efb74fd3395eefe0b2efcf0fd3395eefe0b2ef10eed3390000ef334fd3390000ef607fd3390000effdbdd32910ef8e30bdefb6e82920ef8e30bdefb6e82930ef8e30bdefb6e82940ef8e30bdefb6e8c74f00c75f00c76f00
-- 104:c77f003910a0cc452920efc39fbdef66292930ef27efbdef66292920efe97ebdef66292940ef356fbdef6629390000ef63bed3390000ef1eaed3390000efe0ddd32920ef15efbdef66292930efc1bdbdef6629390000ef752fd3391030ffaf45391020ffaf45194007193007192007c799efff1639223242bdef95291910d71b2e106def0226390000ef059fd3390000ef913ed3190017390000ef5b3ed317d7390000ef1b6ed3390000ef658ed3390000ef1adfd3390000ef44cdd3191017d70000052756373702b5a5d50247f602374716274f052756373702b5a5d50247f60227563757d656023716675646027616
-- 105:d65e05275637370214344594f4e40247f60236f6e64796e6575e3054251435540237166756f3fb052756373702b5a5d5021353024796d656370247f60236f6e6669627d6ea052756373702b585d50247f6023616e63656c6ea7414d45402f465542d9447723702461627b61a80eaeaeaea2556d6f6675e55375e548716d696e65e4496373616274e94e66756e647f6279f023616e67247025737560247869637ea02d6573747026696273747022756d6f6675e2014024777f6d28616e64656460277561607f6e6023616e6724702265e57375646027796478602160237869656c646ea3416e67247022756d6f66756e2
-- 106:0294e66756e647f62797026657c6c6ea3416e67247022756d6f66756e202944756d602963702365727375646ea3416e6724702469637361627460247869637e202944702c6f6f6b6370296d607f6274716e647ea255616c6c697024696373616274e20e4f6c2023616e63656c6ea955637c20246963736162746eaf01627d6f62f8656c6de77561607f6ee2716e67656460277561607f6ee37869656c64e26f6f64f2656c64f16d657c6564f2796e67e7716e64e373627f6c6ce07f64796f6ee66f6f64e478696e67e175756374f406496768647562f0516c6164696ee14273686562f7596a716274ef2466346d34634
-- 107:4635166796e676e2e2ea44f602e6f6470207f677562702f6666602f627022756d6f6675602361627472796467656ea7416d656023716675646ea4094e647562716364f944756d63f3416374702370756c6ce05162747970296e666fe30e4f6022716e67656460277561607f6e6ea45f60256175796070216022716e67656460277561607f6e6c20257375e4786560296e66756e647f62797023736275656e6ea30e4f602d656c656560277561607f6e6ea45f6025617579607021602d656c656560277561607f6e6c20257375e4786560296e66756e647f62797023736275656e6ea7586f6027796c6c60236163747fb
-- 108:0246f6563702e6f64702b6e6f6770216e69702370756c6c637ea3486f6f6375602370756c6c6028a10e4f6470256e6f657768602370756c6c60207f696e64737ea758616470246f60297f657027716e6470247f602265797fbe4f602964756d6370247f6023756c6c6ea20e4f6c20246f6e67247023756c6c6ea955637c2023756c6c6eae4f6470256e6f65776860276f6c646ea02c6561627e65646021602e6567702370756c6c6ab95f6570216c6275616469702b6e6f677024786963702370756c6c6ab204586963702370756c6c6023616e602f6e6c697022656023616374f778696c6560256e676167656460296
-- 109:e60236f6d6261647ea204586963702370756c6c6023616e67247022656023616374f778696c6560256e676167656460296e60236f6d6261647ea701447471636be142727f67f350756c6ce944756ded4f6675602d2ebd4f6675602c3da0516373f203416e672470216466716e63656e20254e656d6965637021627560296ee47865602771697e20244566656164702478656d6026696273747ea103416e6724702275647275616470266572747865627ea10e4f60256e656d69656370296e6022716e67656ea00000010104030204030504020403000000010101010101010101010303090501030c02010a0101095f6
-- 110:5702275636569667564e2095f6570246f6e6724702861667560216e69702964756d637024786164f3616e6022656025737564602778696c6560296e60226164747c656ea2095f6570246f6e6724702861667560216e69702f6660297f6572f964756d63702779647860297f65702279676864702e6f677ea1095f6570246f6e6724702b6e6f6770216e69702370756c6c63702975647ea2095f657021627560216c6275616469702361627279796e67e47f6f602d616e6970266f6f64602964756d637ea2095f657023616e672470236162727970216e69702d6f6275ef666024786164702964756d6ea3055e6964656
-- 111:e647966696564602964756d6ea45f602b6e6f67702d6f62756021626f65747029647ca964656e647966697029647026696273747ea0286163702e6f6478696e676025617579607075646ead2024584540254e44402da012556374796e676e2e2ea2556374796e676021647024786560296e6e6e2e2ea45f677e602f6660225966756273796465e64f627563747026596c6c616765ef4c6460245f677562f0596e6e61636c6560245f677ee3557e60205f6274f34163747c6560235f657478ed4f6e616374756279f3516e6460284166756ee45f677e602f6660255d626271e45f677e602f6660274c6163696563f7556
-- 112:374707f627470245f677eee4f627478602b456560f9476e6963f94e6469676f60245f677ee1082e4f602665727478656270296e666f69ac03545f4259d95f6572702e616d6560296370214c65687ea08146647562702d6f6e647863702164702375616c20297f6570216e6460297f6572f2627f64786562702c456f6e6028616675602162727966756460296e602259667562737964656ca361607964716c602f66602478656020727f637075627f6573702457756c6675602c416e64637ea08055627861607370297f657027796c6c602265636f6d65602865627f65637c2023757e67e478627f6577686f657470247
-- 113:865602c616e646e202f42702075627861607370297f657027796c6cea65737470246965602071647865647963616c6c69702f6e602478616470266962737470226164747c65e47861647027716370237570707f63756460247f60226560256163797e2027586f602b6e6f67737fbf4e6c69702f6e656027716970247f6026696e64602f65747ea20e4f6478696e6760247f60296e647562716364f779647860286562756ea34f60797279676864702823692022303139302269702242757e6f602f4c6966756962716e20214c6c602279676864737022756375627675646ea014586560237861646f67702f666024786
-- 114:560235f627365627562702b496e6760277163fc6966647564602164702c6163747026627f6d60247865602457756c6675602c416e64637ea08b496e67602651686e6029494022757c656460266f62702d616e6970246563616465637ca164667963756460226970286963702c6f69716c60266279656e6463702c497c61e16e64602c456f6e6ea08845602e6566756270237f6c6460286963702b696e67646f6d60247f60216e69f566796c6026796c6c61696e637c2021602d61627b656460296d60727f66756d656e64ff66756270286963702072756465636563737f62737ea086596360256e6a6f6973702160236
-- 115:1627566627565602275647962756d656e6470296ee3557e60205f62747c20296e647562727570747564602f6e6c6970226970247865ef63636163796f6e616c602769616e64702370796465627ea080202020202020202020202020202020202024584540254e44cf014c6568702478656024527561636865627f657370226563616d6560247865ee656770235f627365627562702b496e676e2020556f607c656024786f65776864fd41627b657370277163702261646c2022657470214c65687021636475716c6c69f2627f657768647021626f657470216023757270727963796e6760216d6f657e64ff6660296e6
-- 116:e6f667164796f6e60296e60247865602375726a656364702f66e665616270216e6460246563707169627c202265636f6d696e676021e472757c69702f65747374716e64696e6760235f627365627562702b496e676ea0894d6d6f6274716c60216e646025687472756d656c6970207f67756276657c6c20286963f27569676e602378616c6c602c61637470266f6270256475627e6964797ea08f42702164702c6561637470257e64796c60216e6f64786562702071627479702f66e16466756e6475727562737026696e646024786560264f6572702342797374716c637e2e2ea080202020202020202020202020202
-- 117:020202024584540254e44c4dd5c1e6ad5611e6fdf55b07fd36bb877d36516bdd364e87ddf5be876dd54f87000039efaed68010bdefebe81900d72054e6475627024786560247f677e602f66e3557e60205f62747fbd74b293fefbbd6bdef6f19d739ef826210d0bdefebe8d7481e016def95e6481e026def46e6190d141a102e107def34e6281e8039ffafeff6e6ef37e6d3d7281e0139ffafeff6e6ef5de6d319ef0d70bdef409bd739ffafeff6e6ef71f6d3d739ffafeff6e6ef52f6d3d7c456e61e40d49702e616d65602963702c456e616e2029556162737021676fe16024786965666023747f6c656021602a456
-- 118:7756c627970224f68f6627f6d602d656e20294660297f657026696e646029647ca262796e67602964702261636b60247f602d6561a30f4861202d49702a6567756c627970226f687120294470286163f265656e60237f602c6f6e676023796e63656029402c6f6374f9647e202458616e6b60297f6571a10458616e6b6370216761696e61a3094023616e6e6f647022656c6965667560297f6570237f6c64602d69fa6567756c627970226f687e20294024786f6577686470297f65f775627560286f6e6f6271626c65602865627f65637ead71b39103fefd607bdefe0a1e710efad366def2cf6481e046def2cf6190d
-- 119:141a202e205def2cf6281e04391eef3cf6ef0df6d329ef9407efb062041a30e730206def2cf619ef4f1044190d64281e02d7d784f6f64656460266967657275e6005373747e202e496365602a6567756c627970226f687e2029c8656162746029647022656c6f6e676370247f602c456e616ea0894e6374756164602f666022756475727e696e6760296470247fe865627c20286f677021626f657470297f657023756c6c602964f47f602d6560266f62702530303027607fb203556c6c602c456e616723702a6567756c627970226f68f66f62702530303027607fbd7293080e41a102e105def0807393000ef3807d3
-- 120:1910d7204586963702963702964712024586963702963702659636723f86f6573756e2028456027796c6c6028656c607025737ead7483e026def7817283e02390000ef3a17d3390000effe17d339ff3fef2592ef7227d32900ef2327041a10e710105def8f07e710205def8f07e710305def60174def411739ff3fef2592efb727d34def221739ff3fef2592ef6c27d34def221739ff3fef2592ef6237d34def22172900ef5737041a10e710105defc317e710205defa4174def851739ff3fef2592efb347d34def661739ff3fef2592ef3d37d34def661739ff3fef2592ef3947d34def6617390000ef8f47d339ff3f
-- 121:ef2592ef6857d319efcb2326c799efc06739b0b0b0e5d719efd81724d710458656275602963702e6f602f6e6560286562756ea5035f6d656478696e676029637027727f6e676ea084586560296e647562796f627029637024656374727f697564e16370296660247865627560277163702160227563656e64f6696768647ea20458656275602963702e6f6963756026627f6d6025707374716962737ea35f6d656f6e656023786f6574737026627f6d6024786562756ea107586f6029637029647fb407556021627560266279656e64637ea75560216275602865627560247f6028656c607ea755602e65656460297f6
-- 122:5727028656c607ea35f6272797c2027727f6e6760286f6573756ea4054873656c6c656e647e202c4564702d656021637b60297f65ff6e65602175756374796f6e6c20266279656e64637ea081427560297f6570216662716964602f6660237079646562737fb5095f65702e656564602d697028656c607f3027556c6c6ca1637029647028616070756e637c2029402e65656460295f4552d8656c6070216470247865602d6f6d656e647ea081427560297f6570216662716964602f6660237079646562737fb402456024786164702163702964702d61697c202265666f6275e97f65702c656166756c202c6564702d6
-- 123:56021637b60297f657ea081427560297f6570216662716964602f6660237079646562737fb30e4f6c20277560216275602e6f6470216662716964602f6660237079646562737ea955637c2027756021627560216662716964602f6660237079646562737ea7556028616675602e6f602f60796e696f6e602f6660237079646562737ea607556c6c6c202940216d602160226964702f6660216ee16271636e6f60786f626963602d6973756c6660247f6f6ea0894e60216e6970236163756c20236f657c6460297f65f075627861607370236f6d6560257073747169627370266f62f1602375636f6e646fb5054873656
-- 124:c6c656e64712027586164702762756164702c65736be47f6022756365696675602e6f6e6d216271636e6f60786f626963e6796379647f62737ea0834f657c6460297f6570236f6d656025707374716962737fb60e4f602f60796e696f6e602f666023707964656273702164f16c6c6f3024586164772370257e657375716c6ea089472d602375727560297f657027796c6c6028616675602f6e65e37f6f6e6e20234f657c6460297f6570236f6d65e5707374716962737fb7014370297f6570216373656e646024786560237471696273f97f65702375656021602d616e60277964786027627169f8616962702462756
-- 125:373756460296e60226c657560227f6265637ea0884560296370237572727f657e646564602269702478627565e769616e6470237079646562737027786f602162756021626f6574f47f6021647471636b6028696d6ea707556c6c6c20246f6e6724702a657374702374716e646024786562756ea8456c60702d6561a0844f6e672470297f65702b6e6f6770247861647029647723f96d607f6c69647560247f602374716e64602269f8656c607c6563737c6970216370297f657270286f6374702963fb696c6c6564602269702769616e6470237079646562737fbd71940bdef75e839ff3fef2592efd667d32900ef68
-- 126:67041a10e710205def0467e710305defe46739ff3fef2592effc67d34defc16739ff3fef2592efb277d34defc16739ff3fef2592ef2a77d339ff3fef2592efd287d339ff3fef2592efb787d3d710458616e6b60297f6570266f6270297f65727028656c607ea301426f65747024786560237079646562737e2e2ea1426f65747024786560235f627365627562702b496e676e2e2ea1426f65747024786560264f6572702342797374716c637e2e2ea50955637c2024786963702162756160286163702769616e64f37079646562737024786164702f63636163796f6e616c6c69f4727970247f602b696c6c60297f657
-- 127:ea08245747024786560277561647865627029637027627561647ea504586560235f627365627562702b496e67602d41627b6573f2757c6563702f66756270216c6c60247865602c616e64e16e6460296370277275616b696e67602861667f63e56675627977786562756e202458656023707964656273f16e64602d6f6e6374756273702162756028696370246f696e676ea70940286561627460247861647024756e6029756162737021676fe37f6d656f6e656023796d607c697028616e646564602f667562f4786560266f6572702362797374716c6370247f60247865e35f627365627562702b496e676121a0834
-- 128:16e60297f657022656c6965667560237f6d656f6e65e77f657c64602265602478616470236c65756c6563737fb3014e697771697c202964772370257070247f602573702e6f6770247fe275636f66756270247865602362797374716c6370216e64e465666561647024786560235f627365627562702b496e676ea30c4564772370237471627470216470247865602f4c6460245f677562f665727478656270237f6574786e2029402b6e6f6770286f67f47f60256e6475627ead739ffffef7c8741bdef4a09d7107556c636f6d6560247f60247865602355616379646560294e6e6ead71950bdef9c64d719ef03bfbd
-- 129:ef8c5bd719efff8ebdefde5bd74b293fef2eb7bdef6f19d7484e02cdefd197480e205defc19729efbdc22165d729ef0e727065d719efa29724d75025547514254c64f627027786f65667562702275637365756370247865e76f6675627e6f627eac416374702375656e60276f696e6760247f677162746370247865e3616675602e6f62747867756374702f666024786560236964797ead719ef515ebdef8c5bd719ef202ebdefde5bd719efff1ebdef306bd739ef82621020bdefebe8d7480e405def0c9739ef82621030bdefebe8d739ffcfefca72efbc97d3d73045865602e4f627478602741647560296370236c6
-- 130:f637564e57e64796c6024786560276f6675627e6f627022756475727e637ea452797024786560235f65747860274164756ead7480e406def33a7480e206defe2a7280e10392eefe0b2ef66bdd3d7bdefcfa7d739ffcfefca72ef9a2fd3d71940bdef9c64d7480e405def75a739efd5a70110bdefebe8d719ef8baf24d72035471696273702c65616460246f677e60296e647f6021602461627be3656c6c61627e2024456373656e646fbd739ffffef79a7a0bdef4a09d7207556c636f6d6560247f6022596675627379646560294e6e6ea35471697fbd72b59103fef662920ef631ebdefe0a139203fef18b7bdefe0a1
-- 131:d749effda79120ef8672bdef2e49d72005f6274716c60247f6023516e6460284166756e6ea54e6475627fbd7190f64191f64192f6419ff3f64280e40392eefe0b2ef2d2ed32900ef73bf041a10e710105defc4b7392eefe0b2efef1fd32900ef423f041a10e710105defc4b7392eefe0b2ef6e7fd3390000ef9a9fd3390000ef4d4ed3395eefe0b2efe5cfd3395eefe0b2ef42fdd3390000ef417ed3395eefe0b2eff1aed3390000ef8d8dd3292110f3d7480e405deffab719ff9f141a102e106deffab739ffdfef0082ef8eedd339ffdfef0082efe99dd319ff9fe31910d71900d719efd14e24d739ffafef0082ef0a
-- 132:bfd3d739ffbfef0082efdb8ed3d739ffdfef0082efb93fd3d719ef7a6bbdef376bd76da288979d8219976d52a997bd133a979e22ea974e4231a79d42e3a79dc2516bfe0354a7dd42b8a7bdc242970e721da7cea2737bde422bb7cea28bb79ec23cb79e03ecb76e039db70000cc10845616ce5070d730cc20c49676864f3035d720cc300527f64756364f50b5d710cc40354757ee40aed710cc50143696460225563796374716e6365e5047d720cc60147716b656ee50e7e730cc70345727560205f69637f6eea088e730cc8035472756e676478656eef029e730cc90245727ee30b3d710cca064f6273656022456164e
-- 133:4010e710ccb04556d60756374ff0f1e710ccc0c496768647e696e6760226c616374fe1a3e710ccd0055737860256e656d69f80d5e710cce094e6679637962696c696479f2157e730ccf0944656e64796669f41b9e720001b2900eff2d7d41a202e205defc2d71930751a30c7405f884070684050394f6f00a51910d71900d710845616c6027786f6d6fbd71b591082ef84d74e12b51910d7361637473702245727eed71bc72fffff1910d72869104900ef96d7b0c0361910d7b2530244566656e6375ed7283f1019eff7d7241910d76095f6570216275602e6f6770227563796374716e6470247fe16369646024616d6
-- 134:167656c20296e636c6574696e67e07572707c656021636964602377716d607021627561637ea084586560256666656364702775616273702f6666602778656ee97f65702275637471ad7592010ef6fd79e52b51910d7361637473702354757eed71b592041efe0e7ed12b51910d736163747370264f6273656022456164ed71b593082efc2e7bd12b51910d73616374737024556d60756374fd71b592014ef74e79d12b51910d7361637473702c496768647e696e6760224c616374fd71b592010efa6e7ed16b51910d73616374737020557378ed71b293f01bdef7ae7d71b393f0220bdef7ae7d71b393f0010bdef7a
-- 135:e7d71b293f80bdef7ae7d71b1900bdefb3c51a20194fd73b4900ef32b21010d41a402e405def9ce7296f5fbdef0a7b296f4fbdef867b1910d71900d71950751a49d72b1950751a307830df49e730a0cdef00f7e73041cdefe8f7e730e1cdef2ff7e73082cdef3808e73023cdefbf08d7298070bdef5368390000eff0f7d3d780f4e65602975616270286163702071637375646ea08d41627b65737c2024786560267963656d276f6675627e6f627027786fe96d607279637f6e656460297f657c2024656e69656460297f65f36c656d656e63697ea0895f657028616675602239302975616273702c65666470296e602
-- </MAP6>

-- <MAP7>
-- 000:97f6572f3756e64756e63656ead7296050bdef5368390000efd9f7d3d7504577f6029756162737028616675602071637375646ea0895f6570286561627024786164702d41627b6573702c65666470247f677ee779647860247865602362797374716c6370216e64e6716e69637865646ead7295040bdef5368390000ef1008d3d76064966756029756162737028616675602071637375646ea080556f607c6560237075616b602f666021602e6567702566796ce36f6d696e676026627f6d6024786560254163747c2026627f6de478656023696479702f666029476e69637e2021402e6567f35f627365627562702b4
-- 001:96e6760227f637560247f60207f6775627ead74940302010bdef5368390000ef4908d3d7604556e6029756162737028616675602071637375646ea0845865602f6e636560207561636566657c60277f627c64602963fe6f677026657c6c602f66602d6f6e63747562737ca36f6e64727f6c6c656460226970247865e35f627365627562702b496e676ead7292010bdef5368390000ef4c18d3391eef4182ef3028d32900ef0428041a10e710406defa218391eef4182efc728d3390000ef6d28d3391fefe492ef3f28d3391fefe492ef4038d3391fefe492efb338d3391fefe492efd738d3391fefe492effb38d32900
-- 002:ef9f38041a10391fefe492efe448d3391fefe492efb748d3391fefe492ef9a48d3390000efcd48d3391fefe492ef1f48d32900efb062041a10e710205def9a18391fefe492eff158d319ef2e2326390000ef0558d3391fefe492ef9658d319ef6cc174d73095f65702865616270266f6f6473747560737ea140286f6f6465646026696765727560216070756162737ea95f65727026696273747026796379647f6271a3035075616b6021757965647c697e202940276f64f27964602f66602478656027657162746370226574fd6f6275602d616970226560236f6d696e676ea4074f602f6e6ea7586f6021627560297
-- 003:f657fb758697021627560297f657028656c60796e676025737fb75560246f6e6724702e65656460297f657ea40940216d60297f6572702f6e6c6970286f6075602f66e563736160756e20294660297f6570216275602e6f64f2756164697c2023786f657c64602940236f6d65602261636be96e60216e6f647865627021303029756162737fb1045865602669676572756022756d6f6675637028656270286f6f646ea10d49702e616d65602963702c497c616ea204556e6029756162737021676f6c20297f657022627f65776864f4786560264f6572702342797374716c6370247f602d41627b65737ea3045865602
-- 004:342797374716c63702f60756e60247865602761647563ff666029476e69637c2024786560216e6369656e647023696479f96e6024786560254163747ea30d41627b6573702573756460247865602362797374716c6370247fe56e64756270216e6460226563616d6560247865602e6567f35f627365627562702b496e676ea3094e6023757d6d6162797c20297f657028616675602c6564fc6f6f63756021602762756164702566796c6025707f6ee4786560277f627c646ea40755602162756e2e2e20237f6272797fb94470277163702e6f64702f6572702661657c647ea4586560276f6675627e6f6270247f6c646
-- 005:0257370247f6ea84f67702461627560297f65702163636573756025737fb2045865602071637470246f6563702e6f64702d61647475627ea755602d65737470266968702478696e67637ea20c4567656e6460237075616b63702f6660216e6f6478656270237564ff6660264f6572702342797374716c637ea30755602d6573747026696e646024786560264f6572f342797374716c6370216e6460276f60246566656164fd41627b65737ea10c497c616020727f64657365637021602b65697ea209466029402662756560297f657c2027796c6c60297f65fa6f696e602d6560296e60247869637021757563747fb20
-- 006:940277163702a657374702265696e6760207f6c6964756ea95f6570246f6e6724702861667560216023686f6963656ea1035865602f60756e63702478656023656c6c60246f6f627ea10c4564772370276564702f6574702f6660286562756ead74be730c0cdef1958e73033cdef2268d7390000ef6a58d3391fefe492ef0e58d3294040f3d72014370297f6570256879647c20297f6570236f6c6c65636470297f6572f964756d637026627f6d60247865602765716274637720227f6f6d6ea30755602d657374702375656b602659636c20216027796a716274e7786f602c6966756370296e6023557e60205f62747
-- 007:ea8456027796c6c6028656c607025737ead72910ef24cfbdef66292920efb7eebdef6629d72b3910203f453920204f4539105000453920500045d73b2e306defc768f7401020e740205def16684def276819ef6a8d24290041bdef4059293f4f64d719ef06fe2429001027d7393f4f5fbdef5868d73bf7401041e74010adefbe68e74040adef0e68e74070adef2c68e740a0adefcc68e740d0adef6d684def1b6819efc5b224295f41bdef4059293f4f64d719ef7c8d24295f2027d719efd53f24295f1027d719efb09d24295f4027d719ef8ece24395f500045d719efdd8f24395f200045293f4f64d739ef70788110
-- 008:bdefebe81900d71054e64756270247865602d4f6e6163747562797fbd74b293fef02c8bdef6f19e710ef6cf35defb378e73082293f30cdef90b3d7293f22bdef72b3d72b39103fef9778bdefe0a169203fef95290101f0bdefe0a179303fef952901b0f0f0bdefe0a189403fef9529010101f0f0bdefe0a1d7390000efdc78d3393defe082ef4f78d32900efb388041a10e710305def0b78e710405def6c78393defe082ef4a88d3390101f0e51910d7393defe082ef5c88d3393defe082ef2498d34def9878291001f31900d720140236c6562796360296e602762716970216e6460227564e27f62656370216070756
-- 009:162737ea307556023756276756024786560235f627365627562702b496e676ea95f6570216275602e6f647027756c636f6d6560286562756eac4561667560296d6d6564696164756c697ea407556023616d6560247f602c69666470247865602345727375602f66602e49676864f7556023616d6560247f6024656374727f6970297f657ea35f627365627562702b496e676f3027586f60296370247861647fb6496e656e2027556027796c6c602c656166756ea2045861647027796c6c602e6f6470226560237f60256163797ea7457162746371a507586f602963702478656e2e2e20277861647c2021627560297f6
-- 010:5f37562796f65737f3024586560235f627365627562702b496e6761a45865602d4163747562702f66602546796c6120245865e8416272696e676562702f66602e496768647d616275637ca47865602d4f6e61627368602f6660235861646f67737fb7084560296370216c637f602b6e6f677e602163702d41627b6573f47865602659636560274f6675627e6f627c202265747024786963f479647c656029637e672470216370237361627970216370247865ef64786562702f6e65637ea088456020727566656273702d4f6e61627368602f66e35861646f67737c202e496768647d616275637c202564736ead739ef
-- 011:9d981001bdefebe8d710c4561667560247865602d4f6e6163747562797fbd74b2e406def50a8193f7419efcce374390000ef60a8d3d74095f65702075737860247865602c656675627ea0895f65702865616270216027616475602f60756e696e67e96e602478656024696374716e63656ead7483e086def57a8390000efb7a8d329ef51b8efb062041a10e710206def47a8390000ef2ca8d3c799ef44b8283e081990e5d719ef62b824d7304586963702370756c6c626f6f6b6029637026696c6c6564e779647860216273616e656022757e65637ea944702665756c6370247865602345727375602f66602e4967686
-- 012:47ea4095f657024727970247f60226275616b60247865602370756c6c6ea0814370297f6570246f60237f6c20216024656d6f6e602c65616073f6627f6d60247865602071676563702f666024786560226f6f6b61a1024275616b60247865602370756c6c6fb1045865602370756c6c60296370216c62756164697022627f6b656e6ead7390000efa5b8d3390000efeab8d3c7391f291001f3d75095f6570246566656164702478656024656d6f6e60216e64e6696e616c6c6970226275616b60247865602370756c6c6ea08441697c6967686470296370227563747f62756460247fe4786560227567696f6e61a6014
-- 013:3702478656024656d6f6e672370226f6469f6716e696378656370296e60236c6f6574602f6660237d6f6b656ca97f657026696e64602478616470237f6d656478696e67e378696e6970277163702c65666470226568696e646e2e2ea084586560274275656e602342797374716c61ad7ac33ec987c04fe98fc1434a80000396eefe082ef504fd33900ef48bf10041a10e71010cdeff4c8e71020cdef04d8d71930751a20c7104f881050396eefe082ef0bc8d3496eefe082ef39c83fbdefe0191a302e305def29c81910bdefac7b1920bdefac7b1940bdefac7b4900ef03d8d0c036d710255636569667560247865602
-- 014:4756d607c6560226c656373796e676fb60458656024756d607c6560226c656373796e676027796c6ce2756d6f66756021696c6d656e64737023757368602163f07f69637f6e6370216e64602370756c6c60256666656364737ca265747027796c6c602e6f64702865616c60277f657e64637ea087556022756175796275602160237d616c6c60246f6e6164796f6e6ea4556d607c6560226c656373796e67ed7396eefe082ef9a5ed339000010d41a202e205def6ad8294fef850ea61a302e305def6ad8294f5f562a40504850205defd9d81930751a10881041496eefe082efc63f3fbdefe0191a602e605def6ad849
-- 015:4f5f000066185010296f7fe3d7396eefe082eff16fd3d7bbc75046393f4f5fd339ef1162ef916210041ac0e7c0105defacd8e7c0205deffcd8d7296f7f84d7698f9fafbfcfdfb094d739efded8efb06210041a10e710206defced8c4d71035166756027616d656fbd71b1960751a40c72010e7206f7def23e8294f30e41a30c7505f88503f9850a068307f394f205f45294f60e41a30394f505f456820104def20e81980bdefac7b1901bdefac7b1902bdefac7b183f10c760202e107def35e8c76010198f37d71b293f20e41a20e720107defa6e8393f201045d72b293f30e41a30293f20e41a40e7405f7def19e868
-- 016:404f396f105fbdef67091a40393f206f45d72b2e206defdbe829ef2be8efb062041a30e730206defdbe8193f74bdef9dd8d71035166756027616d656fbd74b293fefb062041a80e780206defefe8196fa4294f5ff3c750efd7b2c8607fe7604f5def1fe82e605defefe86850304defade8685020b8707f199f374defefe8d73be720235deff0f8e720725defc1f8d72e306defc1f81906e3193f74d719ef22f824d710e4f6478696e6760296e602478696370247275656ead71b39ef2a62efb06210041a20e720205deff4f81900d7193f251910d72bc7303f6830ef0010c7503f7850ef0010c7403f684010c7603f78
-- 017:6010e7203f5def89f8e7205f5def89f8e7207f5def89f8e7206f5def89f8e7208f5def89f81900d71910d72b1960751a60c73010e7308f7defdef8e710505defdbf8e710605defdbf84def8df8295f10e41a50e750205def8df8e750405def8df86830104def4af8295f3fe41a4068404f395f3f6f456830104def4af8d73b193fbdef25092a40502e205def6109e720205defd109e720105def4209e720305defb209193fd778505f4def230968505f4def230968405f4def230978405f4def2309396f00febdef67091a40397f0078bdef67091a50296f7fbdef76091a10193fd71bc7203fa820ef0010c7303f9830
-- 018:ef0010294f5fd72bc7304f8830ef001068303f195fd73be7104f9def8809e7105f7defb809193fd7194fd7195fd73b2e305def3a09783010293f136568104f4deff809d73b393fef40194fd3493fef4019ef9c095fbdefe0191a402e405def8c091910bdef9fd8c4d73035471697021647024786560296e6e60266f62702f6e65ee696768647f30245869637027796c6c602275636f667562f6657c6c6028405f23505ea94e6e6b6565607562fd74b1970751a50e7506f9defd219295f6ff41a602e607defa2191900d71910d7393f4fef7519d32900ef9719041a70e770205def64191900d7390000ef9819d3393f4f
-- 019:ef0c19d31910d72095f6570246f6e6724702861667560256e6f657768e76f6c6460247f602071697ea2074966756025707ea94e637963747ea2095f6570296e637963747c2021627765796e676024786164f97f6570216275602f6e60216e60296d607f6274716e647021757563747ea2065562797027756c6c6e20294022656c6965667560297f657ea2457470297f65702d65737470207169702e6568747024796d656ead72bc7304fc8405f2e405defb129683020c8505fe7403f5def71296830204defaf19193fbd7fd71910752a1020393f4f10bdefeef81a10193fd72b2e205def8529bdefc1291a30e7303f6d
-- 020:ef85295900269be020c56900269be0f010c54940664ff0d5d77b793f4f5f6f7f8f9fe51910d72b1960751a40293f80e41a302e306def5929c71010293f80e41a302e306def5929e7106f8def59296810104defb729393f004fd31910d71b1950f51a2028203f4820106def1b29193006d72e2f7defbb29191006d7192006d75b393f4f5f162e505deffe296830a0594f5f801040c5c7606f88608098607f398f0080bdef67091a60594f5f8f10e0c5d74b396eefe0824fd31930751a50193f461a602e606def2339e7505f9def833939ef5239efb06210041a70e770206def4239193f25d710c4561627e602370756c6
-- 021:c6fb19efc33924d7196f24d71095f6570216c6275616469702b6e6f677024786963702370756c6c6ead75b3900efe19210d41a602e605def0839298f5fa5298f6fbdef0a7b298f7fbdef867b293f4f64d71bc7203f7820108820f2294ff6d719ff5f141a102e105def1c3939fdef6f92efd349d329ef8c49efb062041a20e720206defac3939fdef6f92efb849d31910d739fdef6f92efdc39d31900d76094023616e6025707461647560277f627c64602d6160737ea34f6d65602261636b602778656e60297f657028616675602f6e6561a0894660297f65702e656564602f6e656c2023756560247865e36162747f6
-- 022:762716078656270296e6024786560224c6f63737f6de649656c64637ea308456c6c6f6120294023616e6025707461647560277f627c64ed6160737e202358616c6c60294025707461647560297f6572f77f627c64602d6160702779647860277861647029402b6e6f677fb3044f6e656120295f6572702d6160702e6f6770236f6e6471696e63f16c6c60247865602162756163702478616470294028616675e36861627475646ea10c45647028696d6025707461647560297f6572702d61607fbd74b293fefb062041a50e750206defcf49294f5ff3196fbdef86f5d71b78203f194fd72b194fbdefdf491a20293f4f
-- 023:a5d71b390000efe3dfd3193fbdef93f8d74b293f10351a502e506def6459394fefb06210041a60e760206defb459193f74196fbd5fd719ef602e24d79f0001000000000000009f1061000000170000009f2041000000170000009f30c1000000170000009f1121000000170000009f3181000000170000009f1231000000170000009f2211000000170000009f3291000000170000009f2100000700000000009f4061000000370000009f5041000000370000009f60c1000000370000009f4121000000370000009f6181000000370000009f4231000000370000009f5211000000370000009f629100000037000000
-- 024:9f9061000000d80000009fa041000000d80000009fb0c1000000d80000009f9121000000d80000009fb181000000d80000009f9231000000d80000009fa211000000d80000009fb291000000d80000009f3451000000d80000009f44a1000000d80000009f5471000000d80000009f64e1000000d80000009f74d1000000d80000009f84b1000000d80000009fa5f1000000d80000009f2411a0c800790000009fc021000000e80000009fc181000000f80000009f5100003737000000009fa10000c8c8000000009f0141000000270000009f0221000000270000009f5681000000270000009f661100000027000000
-- 025:9f7000006700000000009fc20000f700000000009f7101106600000000009fe30010a600000000009fb60800a600007c00059fd308006700001800a59fb508006700009b00a59f9608006700005c00a59f7508006700006a00879fd208006700003800879fd108006700002800469f730000b700000000009fa30900670000e700469fb30900670000e7008c9fe00900f700005800469fe10900f7000058008c9fc60900a600008c00059fe20800f700006800a59f8311000000470000009f9341000000470000009f0341000000570000009f0411000000570000009f7681000000570000009f862100000057000000
-- 026:9f1300003700000000009f9411a00000890000009fa421210000890000009fb411a00000a90000009fc421210000a90000008f8101000000009700468f8001000000008700468f7201000000007700468f230300000000a777468fc301000000000800468ff103000000008800058ff20100000000b600058f82030000000098a8828f3306000000000919468f4303000000002939c38f5301000000006900828f6301000000007600058fe401000000001a00059ff0060037000078ab468ff30200000000c7d7828f1401000000005900468fd40300000000c9d9c38fd001000000004800468f080240000000000046
-- 027:8f1802400000000000468f2802400000000000468f3802400000000000468f4802400000000000468f5802400000000000469f0500002a00000000469f1508002a00003a00469f2509002a0000e700469f3509002a0000e7008c9f6508002a00005a00879fd50000eb00000000009ff500000c00000000009fe50800eb0000fb00469f460800eb00004c00879f060900eb00001c00a59f160900eb00001c008c8f2601000000002c00469f3600003c00000000009f45410000004a0000009f55110000004a0000009f8501006600009a00058f9501000000000b00468ff40100000000cb00468fc50100000000db00a5
-- 028:8fa603000000006c9ca58fd602400000000000468fe60300000000dcec468ff60100c80000fc00469f0701100d00000000009f1700001d00003d0005ff482e806def44a9191d141a102e107defc2a9482e406def22a9396eefe082ef16a9d3282e40396eefe082ef4aa9d3d7191d64396eefe082ef22b9d319ef4f10bdef409b282e80d739eff4a91110bdefebe8d71054e647562702478656024756d607c656fb30458656024756d607c6560296370236c6f63756460246575e47f6021602c61636b602f6660296e63656e63756ea055627861607370297f657023616e6028656c607ea5094660297f65702262796e6
-- 029:760257370296e63656e63756026627f6de4786560247f677e6023656c6c61627c2027756027796c6ce2756f60756e6e202458656023656c6c616270296370296ee4786560237f6574786d2561637475627e60236f627e6562702f66e478656023696479702f66602259667562737964656ea4095f657022627f6577686470257370296e63656e637561a7556023616e602e6f677022756f60756e6e20295f6570216275e7756c636f6d6560247f602374756070296e63796465602164f16e697024796d656ead74b293fefb5c9bdef6f19d739efd8b91050bdefebe8d710c45616675602478656024756d607c656fbd7
-- 030:4910efeab90000bdef0f291900d740940247561636860247865602370756c6c602f66602845616c6ea084586963702370756c6c60216c6c6f677370297f6570247fe865616c60297f657273756c66602f62702f64786562737ead74930efb0c930ef5592bdef0f291900d7509402475616368602478656020527f64756364702370756c6c6ea084586963702370756c6c602275646573656370247865e4616d6167656026627f6d60256e656d69656370296ee26164747c656ead7ab1128b96b510ab9eb51bfb90000bb13abc94b625cc9bb420dc96bf298d96b829dc99bd2516bcb72737b6b4224d900007c428ad9eb
-- 031:f2d9d96cd23bd90c52fa0a0cc26b0a6c62fb0a00001d423d0acc42211a00004b293fef96c9bdef6f19d739ef82621090bdefebe8d739ef2e524110bdefebe8d719efd3cfbdef8c5bd769ffcfefce92efcec9eff3d946d0bdef7ad8d7407556c636f6d65612027556023756c6c6026616d6f6573f35f65747865627e6020756162737e2021407162747026627f6de4656c6963696f65737c20247865697023657275602d6f6374f07f69637f6e637ea1026d739ffffefe4d991bdef4a09d7307556c636f6d6560247f6020596e6e61636c6560294e6e6ea44f60297f65702779637860247f602374716970266f62f4786
-- 032:5602e696768647fbd719efba6bbdef376bd74b293fefb8c9bdef6f19d739ef2e525110bdefebe8d739ef7f523120bdefebe8d7483e806def84e9192d141a102e107def84e9483e406def7dd939ff6fef2e92ef26e9d3d7390000ef58e9d339ff6fef2e92ef8ee9d32900ef92f9041a20e720105def91e9e720205def60e9e720305def91e9d729ef67f969f41a302e307def51e9d7192de3d739ff6fef2e92ef48f9d32900ef6df9041a20e720105def33e9d739ff6fef2e92ef500ad3c799efa40a39606060e5d719efe4e924d710458656023786f6070296370236c6f6375646ea20e4f6478696e6760247f6023756
-- 033:560286562756ea7556021627560236c6f6375646ea4014370297f657027716c6b60296e647f602478656023747f6275e47865602f677e6562702c6f6f6b6370216470297f65f37573707963696f65737c697e20295f65702375656021e76f6c64656e6022627163656c6564702f6e60246963707c61697ea30458696370276f6c64656e6022627163656c6564702a657374f76f6470296e6e202e4963656c2029637e67247029647fb9447723702f6e6c697022303037607ea401437b60277865627560286560276f64702964f1437b60247f6022657970296470266f62702135303760f143636573756028696d602f6
-- 034:660237475616c696e67602964f7516c6b6021677169f10245797022627163656c65647fb40940276f6470247869637022627163656c65647026627f6d6e2e2ead697e2e2e20237570707c696562737ea94021637375727560297f65702478656970216275e07562766563647c6970286f6e6563747ea20755602b6e6f6770296477237023747f6c656e6ea14c6c602279676864702478656e6e202e456675627d696e646ea307556c6c602478656e6e202055627861607370297f65f77f657c64602c696b6560247f60246963736573737024786963f7796478602d6970226f64697765716274637ead7390000ef550a
-- 035:d3192de3d73014664756270246566656164796e676024786560226f64697765716274637ca97f65702275636f667562702478656023747f6c656e6022627163656c65647ea458656023786f607b65656075627022757e6370216771697ead71970bdef9c64d719ef8acdbdefde5bd719efaeafbdefbd5bd74b293fef5ac9bdef6f19d739ef7f524120bdefebe8d72b59103fef662920efee0abdefe0a1d72075f677c20296477237021602e69636560267965677026627f6de570702865627561ad7bdeff8391a10e710106def821a28bf0228bf0428bf08d73b194fd62a1050293f4f64f7700046e770649def641a48
-- 036:50206defe51ac7403f7840fa29006ff61a602e605defb51a1910d71900d7393f4f5fbdefb468d74552b81a65a2491a56e17c1af341183a8672cab214f11a3a96918a3af6b00b3a00002bd719efe68dbdefc16bd729efea1aefb062041a10e710205def6a1ad73910ef25332085d710351696c602261636b60247f602259667562737964656fbd739ffbfefaba2ef632ad32900ef852a041a10e710105deffe1ae710205def402ae710305deff02ad769ffbfefaba2efa12aeff22aef0910e0bdef7ad8d739ffbfefaba2ef8a2ad3d739ffbfefaba2ef513ad3d71084562756029637027786164702940286166756ea60
-- 037:16260409395b207556c636f6d6560247f60247865602f416379637024727164696e67e07f63747ea30758616470246f60297f65702861667560266f627023716c656fb755672275602c6f6f6b696e6760266f627023516e6460284166756e6ea84f67702963702c6966656021627f657e6460286562756fb503516e6460284166756e60296370247f6024786560237f6574786ea94470277163702162616e646f6e6564602c6f6e676021676f6ea35f6d656023716970247865602f42656c69637b60296e60247865e36964797723702d61696e60237175716275602963f365727375646ea5054675627023796e63656
-- 038:024786560235f627365627562702b496e67e27f637560247f60207f6775627c2024786560244563756274702963f6696c6c65646027796478602d6f6e63747562737eae4f64702d616e697024727166756c6562737023796e6365e478656e6ead7bdeff8391a10e710106def0a3a28cf1028cf2028cf4028df1028df2028df40d719c0bdef2159d7390000ef8ceed3d719ef927bbdef4f6bd7f294bd3ab325634a92359a4a73d4b2a4a3452223a354f87a31f49e7a62a4515a000039ffafef0082ef6e3ad3d730751647368602f657470266f6270237e616b65637120294660297f65f765647022696474756e6c20237
-- 039:5656b60247865602f6c64ed616e60296e6024786560266f627563747026796c6c6167656ead739ffdfef0082ef144ad3d74045861647023616675602c6561646370247f6024786560235f657478eb496e67646f6d6e20245865627560296370216023696479f4786562756023616c6c65646020596e6e61636c656c202164f4786560247f60702f6660247865602d6f657e6471696e637ead739ffefef0082ef4b4ad3d74045f6024786560237f657478602c6965637024786560235f657478eb496e67646f6d6e202458696370226279646765602963f2627f6b656e6022657470297f657023616e602573756024786
-- 040:5e4757e6e656c60247f6024786560256163747ead739ffefef0082ef025ad3d76045865637560277f6f6463702162756023616c6c6564e3556270756e6470275f6f64637ea08940286561627460247865627560296370216e60216c647162f96e602160236c656162796e6760277865627560297f657023616eec6561627e6021602370756c6c6ead72b293fef0305bdef55f81a302e30ddefc95ad7483e406defe87a283e40390000ef4f5ad329efa76aef336a041a10e710205defdc5ae710305def1d5ae710405defcd5ad74def3e5a390000ef5b6ad34def3e5a390000efc86ad3390000efcd6ad3398eef0082ef
-- 041:f07ad3d73095f6570237565602160247869656660237475616c696e676021e76f6c64656e6022627163656c656e647026627f6d6021e8656c607c656373702d616e6ea409476e6f6275602478656d6ea8456c6070247865602d616e6ea2557e602166647562702478656024786965666eab496c6c602478696566602779647860216e602162727f677ea1075861647027796c6c60297f6570246f6fb2095f65702669627560216e602162727f677022657470297f65fd696373702478656024786965666ea2095f697024727970247f6022757e6022657470247865e478696566602765647370216771697ea20458656
-- 042:02478696566602469637160707561627370247fe4786560256163747027796478602478656022627163656c65647ea60458616e6b60297f6570266f627028656c60796e67602d6561a458656022627163656c6564702963702f66602762756164f3756e64796d656e64716c6026716c65756e20294660297f65f275636f6675627029647c202679637964702d6560296ee478656026796c6c616765602a6573747025616374702f66e86562756ead74920efd97a0000bdef0f291900d740940247561636860247865602370756c6c602f66602c496768647ea0845865602370756c6c602f66602c49676864702262796
-- 043:e6763fc6967686470247f602461627b60207c616365637ead74940ef9f7a40ef5892bdef0f291900d750940247561636860247865602354757e602370756c6c6ea084586963702370756c6c602374757e6370216e60256e656d697ca2756e646562796e6760296470257e61626c6560247f60216364f66f6270216023786f6274702778696c656ead7481e105defc68a39efe2826010bdefebe8d7d7390000ef478ad3d74075964786f657470246962756364796f6e637c20297f6570276564f36f6d607c6564756c69702c6f637470296e60247865602d6f657e6471696ee07164786e2022457470297f65702566756
-- 044:e6475716c6c697026696e64e97f657270277169702261636b6ead739efe2826020bdefebe8d74be710ef9e145defa09ae710efde535deff09ae730825def419ae710efce93cdeff49ad7bdefc19ad7bdef729ad7293f10bdef90b3d739eff5821070bdefebe8d739eff5821080bdefebe8d71b69103fef9529703040bdefe0a179203fef952970704040bdefe0a1d739ffafef0082efa59ad3d7501427560297f65702c6f6f6b696e6760266f62702d4972716fb34f6e64796e657560247f60266f6c6c6f6770247865e47271696c6024786560277563747e202758656e60297f65f1627279667560216470247865602
-- 045:2656163686c20276fee6f6274786ead739efdc9a4210bdefebe81900d71054e64756270247865602c4f6374702c4962627162797fbd74b293fef4aaabdef6f19d72b59103fef662940ef440fbdefe0a149203fef9529e1bdefe0a159303fef9529e1e1bdefe0a1d739ef126210a1bdefebe8d71b393fefd27eef13aabdef1259d7294050bdefb9f84900ef52ad80c036d71b393fef903feff4aabdef1259d72970f0bdefb9f84900efd2be80c036d71b19f0bdef93f81a202e205def17aa193f74d71b393fef6a2eef08aabdef1259d7390000ef997fd319ef0172bdef409bd71b293f10351a202e206def3aaa196de3
-- 046:193f74d73c7681aa4cc632aabcc614aa0d76f5aafcc627aa0d9609aa000039ef9caae110bdefebe8d72054e64756270247865602275796e63702f66ee4f627478602b4565607fbd7485e105def3faabdef83d3d74b293fef23dabdef6f19d72bd739ef82621061bdefebe8d7291030561a10291090561a20291020561a30e7101c6def63bae7202c6def63bae7303c6def63ba1910d71900d7bdefc0ba1a102e106def89ba193c141a102e106def2aba291020561a30e7303c5def2aba19ff7f141a102e106defe8ba394def5fa2efd1cad32900efb062041a20e720105def13da394def5fa2efb9cad319ff7fe3394d
-- 047:ef5fa2effdcad3d7394def5fa2ef38fed3d7394def5fa2efa15ed3d7707586f6021627560297f657f30295f6570227563756d626c65eb496e67602651686e6c2029756470297f6570216275602e6f64f8696d6ea0894660297f6570277562756028696d6c20297f6570277f657c64e8616675602869637023425f475e4c2023575f425440216e64e2594e474ea8045865602b496e67602771637022657279656460296ee478656023656d656475627970296e602e49676864f9437c616e646c2025616374702f6660247865e742756164702445637562747ea087596c6c60297f65702a6f65727e656970247f6028696
-- 048:3f76271667560247f6020716970297f6572f2756370756364737fb3054873656c6c656e647e20245f60256e64756270247865ee496768647029437c616e646c20297f657027796c6cee656564602478696370254d6562716c64602b45697ea40a4f65727e656970247f602e496768647029437c616e646ca5616374702f6660247865602742756164702445637562747ea95f657027796c6c6026696e64602478656023656d6564756279f4786562756ead7ab1210baabb1cd25fbe193ba0000068cda262dda099a84199a84299a84399a84499a84599a84699a84799a84899a840a45611a45612a45613a45615a4561
-- 049:6a45617a45618a45619a4561aa4561ba4561ca4561da4561ea45610b921a1b921a2b921a3b921a5b921a6b921a7b921a8b921a9b921aab921abb921acb921adb921aeb921a16ddda0403ea4f54ea5f3eea365eea9fe5fa002b393f4f30bdefa539d72b493f4f4010bdefa539d72b39ef00eaefb06210041a30e730206defdfda1900bdef9fd8293f4f641910d71900d720255637470216e646025616470227164796f6e637fb827596c6c60227563747f62756028607f2370792ea2556374fd72b682f4639df2f00ffffbdef67091a2f293f4f64d71910752a1020393f4f10bdefeef81a30393f4f20bdefeef81a4029
-- 050:5f30351a504850ef00105def88ea296f20351a602e606def09ea39106f4f85196fbdefa5b11900d719ef89ea241900d719efebea241900d720c456160702661696c65646e20295f657023616e6724702c656160ff66756270247869637ea20c456160702661696c65646e202c416e64696e676021627561ee6f6470236c6561627ead776d72b19ef6fea24593f4f100080bdefa539d76054164796e6760216e60296e6469676f60226c65756265627279fd616b656370297f65702374727f6e676562f82b22353520226164747c656024616d616765692ea084586560256666656364702c61637473702f6e6c6970257
-- 051:e64796ce97f65702275637471ad729ef7b1eefb062041a10e710206defa8fa29ef0befefb062041a10e710206defa8fa294020f3c78fc3c79fb3d739ef89fa1210bdefebe81900d72054e64756270247865e55e64656277627f657e6460234964797fbd74b293fefc00bbdef6f19d739ef82621081bdefebe8d719efb05ebdefde5bd719efb7dfbdef8c5bd739ffffef8efae1bdef4a09d7107556c636f6d6560247f6024786560255d62627160294e6e6ead719efba6bbdef376bd7db26fbfa9c16516bfc16acfa9c463dfa6c26300bcc46e2c80d36737b2c46cdfa0000c566200f802f80c5762043900390c5a62000
-- 052:006590c5b620cf806190c507000d800d80c5170000002d80c5270000004d80c5370041906d80c547000000ad80c557004d80cd80c54a0000008d80c5670000000f80c5770000006f80c5870000008f80c597000000af80c5a70000002190c5b7000000e190c5c70000008350c5d70000009350c5e70000004390c5f70000006390c5080000008390c518000000a390c528000000c390c538000000e390c5480000000590c5580000002590c5680000004590c578000000a590c5ab000000a990c588000000c590c59800a2500950c5a800b2501950c5b8002d800000c5c8006d800000c5d8008d800000c5e800ad80a1
-- 053:90c5f800cd80c190c509004f800000c519006f800000c529008f800000c53900af800000c54900ed800000c5590001904190c5690000008250c5790061900000c5890081900000c59900a1900000c5a900c1900000c5b900e1900000c5c92003900000c5d90067900000c5a900c1900000c51a200000cf80c52a000000e590c53a0000000790c55a0000002790c56a0000004790c57a0000006790c58a000000a790c59a200000c790c5aa0083900000c5ba00a3900000c5ca20c3900000c5da0005900000c5ea0025900000c5fa0045900000c50b0000000990c51b0000002990c52b0000004990c53b0000006990c5
-- 054:4b0065900000c55b0085900000c56b00a5900000c57b00c5900000c58b00e5900000c59b0000008990c5bb0007900000c5cb0027900000c5db200000c990c5eb0000000b90c5fb0000002b90c50c0000004b90c51c0000006b90c52c0000008b90c53c000000ab90c54c000000cb90c55c000000eb90c56c0000002d70c57c0000004d70c58c0000006d70c59c0000008d70c5ac000000ad70c5bc000000cd70c5cc000000ed70c5dc2000000f70c5ec0000004f70c5fc004790a180c50d2000006f70c51d200000af70c52d2000000180c53d0000004180c54d2000006180c5000039eff03b2210bdefebe81900d720
-- 055:54e64756270247865e94365602d416a756fbd74b293fef2c3bbdef6f19d739ef12621091bdefebe8d72b49103fef9529d1bdefe0a159203fef9529c1d1bdefe0a159303fef9529d1d1bdefe0a1d7192c141a102e107defd93b291090561a20e7202c5defd93b394def5fa2efe0ded3394def5fa2efb22ed3394def5fa2ef4addd3394def5fa2ef28efd3192ce3394def5fa2efc26ed3394def5fa2ef78cfd3394def5fa2ef2c7ed3c729ef0af0291091f3d79b76e23b1c57e53b00002030824b2040c34b3040054b3030e54b0040684b1040274b00508c4b0060cd4b10200a4b10104b4b10606f4b2060a05b2050425b
-- 056:2020e35b2010c45b3010a55b4010865b4040c75b4050895b3050a85b40606a5b5050ab5bffff00001030102000000000702000000000307020000000103030304000000030704000000040404000000010203040400000003030404000001030a1000000000051a100000000a1a100000000103050000000000050500000000050300000000010405050000000005050500000005030300000003040500000006030a0a000000000502121212121a021000000006030a0a000000000a0a0a0000000a0a0a0a000004030d0d000000000d03000000000d000000000004040d0d000000000d0b000000000b00000000000
-- 057:b0d000000000803021210000000021c0000000002121c000000080402121000000001111111100005021c01100001111f000000080402150000000001111c000000050211100000021f0f00000004020312100000000315021000000402041210000000041315100000040204141510000004121510000006030b10000000000b1a000000000b1b1000000007020c1c100000000c1c1000000007020c1c1c1000000c1c1000000007020c1c1c1000000c1c1000000007030c1c1c1000000d10000000000d100000000007020d1c100000000c1d1000000001b79ffafef1372ef4e3f3f463040bdef7ad8d71b69ffefef
-- 058:70a2ef4abe3f4640bdef7ad8d71ba9ffbfef9572ef28df3f461020506070bdef7ad8d71b69ffcfef3672efa77f3f4660bdef7ad8d71900bdefc16bd71b2e106def826bc710ef936b69ffcfef28723fefd66b46e0bdef7ad8d7207556c636f6d65612027556023756c6c6027656e6562716ce37570707c6965637e202758616470246f60297f65702e6565646fb4016040614d71ba9ffbfefb372ef986b3f46c0b0a09080bdef7ad8d7207556c636f6d6561a75560247271646560296e60207f64796f6e637ead73009192960091929396979a9ffbfefe472ef9c6bef6e6b46b0c0a09080bdef7ad8d7207556c636f6d6
-- 059:561a75560247271646560296e602373627f6c6c637eac00b1b2b3b5b6b7b9babbbcbdbd71ba9ffefef5472efa07b3f46b0c0a09080bdef7ad8d7207556c636f6d6561a75560247271646560296e6022796e67637ead72032925032728292a2703262728292a2b21910bdefb3c5d71be710105def857be710205defc57be710305def067b4def467b19df4fd719df5fd719df6fd719df7fd72be710105def287be710205def687be710305defa87b4defe87b284f4fd7285f4fd7286f4fd7287f4fd71b284f3f285f3f286f3f287f3fd72be710105defab7be710205defeb7be710305def2c7b4def6c7b184f4fd7185f
-- 060:4fd7186f4fd7187f4fd71b184f3f185f3f186f3f187f3fd71960751a10c72010e7203f7defa48b194fbdefe37b1a30483010494f60eff0a200ddefb48b483002494fe0efd2a210ddefb48b483020494fe0ef51a210ddefb48b483040494fd0ef72a220ddefb48b483080494fb0efb1a230ddefb48b483001494fb0ef12a240ddefb48b6820104def0e7bd74bc790df799890e1a89060e7906f6defb88b193fbdef18392a5060c770b2c780916850206860a07870407880d0597f8f9faf00c5685020686030497f8f5f4fd5d71b1960751a30c72010e7205f7def3b8b294f6fbdefe37b1a4048403f6def6b8b6820104d
-- 061:ef598b1900d7194fd71960751a10c72010e7203f7def0e8b194fbdefe37b1a30483010194fddef1e8b6820104def1c8bd72bc730df89a830502e306def309b293f20e41a202e20adef309b782010393f204f45d71b193fbdefa49b1a20982023882023e720ef4f107def129bc720ef4f10194f44193fb4d72bc73050c7403f884020194fbdefa49b1a5068107f393f5f6fbdef67091a10193fd71b1920751a2068203f9820201990751a3078205f194fd7b306f99b53f5ad9b331690ab43c53423729669ab921722bb33d7da0d6537af6835f715dbe40786db64f7dddb54f5516b54d5f1cb046582cb3595cfcb000039
-- 062:efaa9b3110bdefebe8d720140237475656c60247271696c602c65616463702570f47f6020596e6e61636c6560245f677e6e20234c696d626fbd739ffffef0082ef5e9bd3d7204527166756c602561637470247f60276f60247fe0596e6e61636c6560245f677e6ead739ffefef0082ef41abd3d750940286561627460247865602561637475627e6023796465602f66e47865602b696e67646f6d60296370296e6020756270756475716ce461627b6e6563737e202944772370216023657273756024786164f56d616e616475637026627f6d6024786560214e6369656e64fd4f6e61637475627970247f60247865602
-- 063:56163747ead739ffcfef0082ef1aabd3d7704586569702371697024786562756029637021602472756163757275e26572796564602f6e6024786560226561636860247fe47865602e6f62747867756374702f666023556270756e64f75f6f64637ea08944772370216024796e6970226561636860277964786021e3796e676c6560227f636b6c2024786569702371697ead739ffafef0082efa19dd3d7483e086def95bb1910751a10193fbdef25092a20309820e1983011e720206def95bbe730509def95bb1910d71900d74bbdefd2bb1a502e506defa6bbd7483e046def96bb193fbdef25092a3040e730e39def96
-- 064:bb390000ef99bbd3392defca72efdcbbd33910ef33171085d72095f657026696e6460297f657273756c6660237572727f657e646564e26970216027627f6570702f6660237f6c64696562737ea4095f65702d6169702e6f647027716e64656270247865602461627be379646560277964786f657470227f69716c60216070727f66716c6ea087556027796c6c602563736f627470297f65702261636b6ead719ef8a0fbdef8c5bd719c0461a102e106def84cb483e085def35cb39ffbfef4ba2ef6bcbd319c025d739ffbfef4ba2efd9cbd3d739ffbfef4ba2efe5cbd3d73094660297f65702c6966647024786560234
-- 065:5727375602f66ee496768647c20294027796c6c60247561636860297f65f16025737566657c602370756c6c61a1074f6f64602c65736b60296e60297f657270217575637471a3095f6570286166756022627f65776864702261636b60247865ec696768647e20214370216022756771627460294027796c6ce47561636860297f657021602370756c6c6ead739ffafef0082ef70dbd3d73044f6e672470266f6277656470247f60267963796470247865e7796a71627460247f602c69667563702f6e60247865e36f616374702e6f6274786d27756374702f6660286562756ead7bdeff8391a10e710106def76db28cf
-- 066:0228cf0428cf08d739ffffef0082ef37dbd3d7504496460297f65702b6e6f67702478656275602963702f6e6c69ff6e65602160707c656024727565602f6e6024786963f7786f6c656029637c616e646f3024586562756029637021e47275616375727560226572796564602a65737470237f657478ef666029647ead7481e016def14eb481e026def14eb190d141a102e107def14eb393def90b2ef84ebd32900efe5fb041a20e720105defc2ebe720205def74eb393def90b2ef99ebd3c799efb9fb69606060606060e5d729ef04fbefc210f41a302e305def74ebbdefb9fbd719eff86224d7d730845697120295f6
-- 067:5702c6f6f6b602c696b65602160237d616274f2657975627e2027556e2e2e20266f657e646e2e2e2024786963fa6567756c627970226f687e2027516e6470247f602265797029647fb803547f6c656029647f30295f6570216363657375602d656fb95f657027796c6c6020716970266f6270297f6572702c696665e779647860297f657270296e637f6c656e6365612029402d65616e6ca97f657270296e637f6c656e63656027796c6c60226560247865e072796365602f666e2e2e202e6f6e2e20297f6572702c494645c7796c6c6e2e202e6f6e2e2ea0814e697771697c202072756071627560247f6024696561a
-- 068:1024579702a6567756c627970226f687026627f6d60247869656675637fb30955637c2027756027796c6c602265797029647eae4f6c202478616e6b637ea64f657e646f302755602b6e6f6770297f657023747f6c6560296471ad7190de3d72983b8faf7e12b6b58532ffbd7b3000c9a610c9a4942620cc9a3b30c00002bd73b1900d71910751a10193fbdef25092a20309820e1983011e720409deffefbe720507deffefbe730307deffefb1910d71900d74980ef134e30ef5592bdef0f29d7bdeff8391a10e710106def520c28ef1028ef2028ef4028ef8028ff1028ff2028ff4028ff80d739ffafef0082efdbcdd3
-- 069:39ffafef0082efd3ddd3d719efbf1ebdefbd5bd739ef4e724010bdefebe8d739ef4e724020bdefebe8d7480e206defd60c49ef8d62201060bdefebe8d719ef370c24d720e4f6478696e67602d6f627560247f60246f60296ee478696370236166756ead739ffafef0082eff90cd3d740458616470247f677e602a6573747025616374ff666028656275602963702259667562737964656ea94028656162746024786560276f6675627e6f62f7756e64702d696373796e676ead739ffbfef0082ef5f0cd3d73035f6d656f6e65602e6565646370247f60276f60296e647fe4786164702361667560247f60247865602e6
-- 070:f627478e16e646026696e646024786560276f6675627e6f6271ad739ffcfef0082ef641cd3d74014c6771697370236162727970266f6f6460216e64e47f6273686563702778656e60216466756e647572796e676ea95f657023616e60226579702478656d60296e60247865e7456e6562716c6023547f627560296e6024786560236964797ead739ffdfef0082ef2b1cd3d73034166756370216275602461627b6e20244f60297f65f8616675602160247f6273686f30295f657023616e60226579ff6e6560296e6024786560236964797ead739ffcfef0082efef1cd3d730458656023696479702f666023557e60205
-- 071:f62747f3029447723f47f6024786560237f6574786c2029402478696e6b6eaf427027716370296470237f6574786d277563747fbd739ffefef0082ef052cd3d740458656022627964676560247f6024786560237f657478602963f2627f6b656e6e2029402865616274602478616470296660297f65f86166756021602370756369616c6023747f6e6560297f65f3616e6025737560296470247f602a657d60702163627f63737ead739ffffef0082ef4c2cd3d75035f6d656f6e6560226572796564602160207f64796f6eee65687470247f6024786560226f657c646562702a657374f37f657478602f66602478656
-- 072:02f6273686162746e20244967e779647860216023786f66756c60216e6460297f657027796c6ce6696e646029647ead739ff6fef0082efd1ced3d739ffbfef0082ef78aed319efbbbe24d72be710ef33145def653cd7483e206def963c2920efdfbfbdef6629283e20d7481e406def3b3c481e206def993c39ffbfefbb3cef9c3cd339ffbfefbb3ceff04cd3390000efa84cd3281e101900d739ffdfef5c3cef6d4cd319ff4fe319efcad0bdef409b281e40d719eff862241900d7f4c646027596a716274ed497271e309402861667560216e602964756d60247861647027796c6ce2656025737566657c60247f60297
-- 073:f657e20294660297f65f8656c60702d656c20296470296370297f6572737ea606496e64602d4972716c202d69702e696563656e2024556c6ce8656270247f60236f6d656e202940216d6026756279702379636b6ea0845f6026696e64602865627c2023747162747026627f6d60247865e7756c6c60216e646028656164602561637470296e647f60247865ed6f657e6471696e60207164786ea3045865602f6c64602d616e60276966756370297f657024656471696c6564e46962756364796f6e637e2022556d656d6265627a3028656164e56163747026627f6d602478656027756c6c61a30d4970257e636c65602
-- 074:86163702071637375646021677169f26574702865602c65666470297f65702478696370237472716e6765e3747f6e656021637021602275677162746ead7481e406defc35c481e206defc35c39ffdfef445cef845cd3281e201900d719eff862241900d7d497271e608496e202940216d602d4972716ea75861647f302d4970257e636c656023756e6470297f657fb845602963702379636b6f3029402d65737470276f60237565e8696d602164702f6e63656ea08d456564702d6560216470286963702865747ead7390000ef5b5cd3291021f3d76095f6570216272796675602164702478656027427561647024456
-- 075:37562747ea0845865602a6f65727e65697023786f657c6460226560237166656026627f6de8656275602f6e6e20295f6570216275602365627471696e6024786164f478656024616e67656273702f6660247865602465637562747028616675e265656e602c616277656c69702f6675627374716475646ead7484e016defaa6c194d141a302e305deff96c39ffcfef18a2effb6cd329eff77c8cf41a20e720106defe96c284e0139ffcfef18a2ef997cd3390000ef808cd3390000ef718cd3c799ef9a5c7991000000000050e5d7d739ffcfef18a2ef237cd3d739ffcfef18a2ef617cd339eff77c1021bdefebe8d740
-- 076:94023616e6024716b6560297f6570247f60247865602742756164f445637562747e2029402771627e60297f65712029447723f67562797024616e6765627f65737ea051637371676560236f6374737022303037607ea102556475727e60247f60247865602742756164702445637562747fb3094660297f65702765647021602351696c696e67602055627d6964f6627f6d60247865602b496e676c20294023616e6024716b65e97f6570247f60247865602742756164702445637562747ea10351696c60247f60247865602742756164702445637562747fb5005c656163756022756c616870216e6460256e6a6f69f
-- 077:47865602a6f65727e65697e20244563707964756027786164f97f65702d616970286166756028656162746c20237561ed6f6e6374756273702162756025687472756d656c69f57e6c696b656c69702e6f6771646169737ea1095f65702371696c60216771697ea10140237561602d6f6e63747562702160707561627371ad7480e026def378c480e016defd58c480e806def258c39ff5fefe78cef798cd3280e80d739ff5fefe78cef919cd3d7280e0239ff5fefe78cef369cd319ef0d70bdef409bd739ff5fefe78cef699cd3d73547566756c20247865602f427368616274602b4565607562f609402f677e6024786
-- 078:5602f427368616274602a6573747025616374ff6660286562756e202245776370216e6460237c696d6563f86166756024716b656e602f667562702d697020727f60756274797ea0894660297f657023616e6027656470227964602f6660247865e26577637c20294027796c6c6022756771627460297f6571a3045865627560216275602374796c6c60237f6d656022657763f96e60247865602f6273686162746e202d416b65e375727560247f6027656470227964602f66602478656d60216c6c6ea20458616e6b60297f6570266f6270237166796e6760247865ef627368616274612028456275602963702160227
-- 079:5677162746ea20458616e6b6370216761696e60266f6270237166796e6760247865ef62736861627461ad7b3d3440cc3b3f40c7304490c63d3ae0cc314b31c73637a1c04733f1c7473f28c9404a63cf424542c54339b2c6343a50c14e3df99b483b5352514958a6504bd8a5583e15c2523946cc343033cf493b33c0000791074275656e60237c696d65e000110e1e00041003000001010a0004586560237c696d656021647471636b63f000079202556460237c696d65e100110102030406060708090a090c0d0e0f082e00082006000002010a000458656022756460237c696d656021647471636b63f000079702516
-- 080:4f00051082e1008200600000101021004586560227164702269647563f00007930742716970226577e0002108291001400a00000101091004586560226577602269647563f00007940649627560226577e100210102090405060f0809060b0c0d0e0e0238200a5004100002020914e45865602669627560226577602370796473f0000795035e616b65e00031023e1008700e10000101032004586560237e616b65602269647563f080079602416e646964f000410233200af0005000020102300458656022616e6469647028696473f000079b035079646562f00081023c300c8009100001010320045865602370796
-- 081:46562702269647563f000079c024c657560235079646562f100810102030a050f0208090d0b0c0d0e0e06423002d00230000202032cd45865602370796465627021647471636b63f4000799094d60f208810464b004f108c00234020734e4586560296d607021647471636b63f000079d03516e6460277f627de00091023d2000500410000201082004586560277f627d602269647563f000079e07486f6374f000a1046e6008e304600823020e14e458656027686f63747021647471636b63f000079f0441627b60234c65627963e000b10c34600c2104600912020c34e4586560236c656279636021647471636b63f
-- 082:000079014556d607c65602745716274e000c10230500870023000010102300458656027657162746021647471636b63f0000791164f627563747024656d6f6ee000610c346008c002300001020734e458656024656d6f6e6021647471636b63f040079212556460237e616b65e100310102030605060708010a0b0c0d0e0f064a50069008200002010734e458656022756460237e616b65602269647563f080079313536f6270796f6ee000d10c3fa00af002300002010144e458656023736f6270796f6e60237472796b6563f080079414456375627470226577e000e10c36900cd00c300001010644e458656024656
-- 083:375627470226577602269647563f400079514577963747562f000f10c38700c2104600002020c38d4586560247779637475627021647471636b63f0400796155e6465616460274571627469616ee00411005690009104600f01010644e4586560276571627469616e60237472796b6563f4000797155e64656164602d416765e00421005690062208700231020644e4586560257e64656164602d6167656021647471636b63f1010798155e64656164602052796e6365e208a1046c7108bb08e30e12010054e4586560257e64656164602072796e636560237472796b6563f4400799135561602d4f6e63747562f208c
-- 084:100540104f108c00914020c36d45865602d6f6e637475627021647471636b63f000079a0d41627378656370274f6c656de0007106487008c002300f04020145d4586560276f6c656d6021647471636b63f080079a164f627563747027596e64e004310058700c2106900003020a58d4586560266f627563747027796e6460237472796b6563f040079b1e496768647024456d6f6ee004410050f00c210c300e12010465d45865602e696768647024656d6f6e6021647471636b63f001079c19436560235e616b65e00451023a50009100500e12010a55d4586560237e616b65602269647563f080079d19436560274f6
-- 085:c656de00461005cd00cb208c00412020878d458656029636560276f6c656d60237472796b6563f002079e105160756270274f6c656de004710a54b00c2106900412010468d4586560207160756270276f6c656d60237472796b6563f000079f164c616d65e004810c387008c002300413010a58d4586560266c616d6560237472796b6563f400079029476e696370234c65627963e004910646e00c2106900e12020c88d45865602669627560236c6562796360237472796b6563f0010791235f627365627562702b496e67e208e10874f1088310d70824020878d4586560235f627365627562702b496e67602164747
-- 086:1636b63f4c307922c456f6ee004b1000c3004f100000001010238dc456f6e6021647471636b63f00007932c497c61e004a1000c3004f100000001020233ec497c61602669627563f0000794265963e004c100082004f100000001020236d659636021647471636b63f000000d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d739efab0d7110bdefebe81900d71054e6475627024786560234163747c656fbd74b293fef058dbdef6f19d72bd739ef436210f0bdefebe8d7484e106defd22d483e086def1f1d483e046defed1d283e041930bdef75e8390defd4a2ef732dd3391defe5
-- 087:a2efa42dd3391defe5a2efd72dd3390000efea2dd3391fefe492ef4f2dd3391defe5a2efc53dd32900ef273d041a10e710105def851de710205def851de710305defc51d4def961d4defd71d391defe5a2ef4e3dd34defe21d391defe5a2ef504dd3390000efc34dd34defe21d391defe5a2efe94dd3391fefe492ef8b4dd3390000ef015dd3391defe5a2ef935dd3390defd4a2ef455dd3391fefe492efe75dd3391defe5a2ef3b5dd3390defd4a2efee5dd3391defe5a2efb36dd3390defd4a2ef156dd3391defe5a2ef296dd3391defe5a2efee6dd3390defd4a2ef327dd3d7391defe5a2efa47dd3390defd4a2ef
-- 088:b77dd3391defe5a2ef197dd3390defd4a2ef7a7dd3391defe5a2ef3d7dd3284e1019ef85b1bdef409b194de3d7390defd4a2ef018dd3d7107556c636f6d656c202375726a6563647371a207556022757c656024786560235f657478602b496e67646f6d6ea758616470246f6e2e2e20277169647e2e2e202c497c616fb20c497c6161202758697021627560297f6570296e60247865e36f6d60716e69702f666024786563756020756f607c656fb3095f6570216c6c602475727e60247f602c497c616e20235865e375656d6370256d626162716373756460297564f16d6573756460226970297f65727023757270727
-- 089:963756ea60940246f6e672470227563616c6c60216e69702f6660297f65fa21637b696e676a202966602940277163702052796e63656373ff666024786560235f657478602b496e67646f6d6ea0894470246f6563702e6f6470216666656364702f6572fd696373796f6e6ea10758616470296370297f6572702d696373796f6e6fb4045f602465666561647024786560235f627365627562702b496e676ea45f60237166756024786560277f627c646ea45f602d6168796d696a75602378616275686f6c6465627026716c65756ea940246f6e6724702b6e6f677c2027786164702963702a297f65727a202d6963737
-- 090:96f6e6fb204586560235f657478602b496e646f6d6029637021ee6f6e6d20727f6669647ea30a2f45727a202d696373796f6e6fb94e647562756374796e676c202e6f626f64697025667562f1637b656460257370247861647e2e2ea4095f65702f626375627675602163702478656970236f6e6379646562f4786560207f63737962696c69647970247861647024786569f16275602378616c6c6f6770236861627163647562737027796478ec696d69647564602469616c6f6765756ea1014e6460286f677027796c6c60297f6570246f60247861647fb407556027796c6c6027656470216c6c60266f6572f362797
-- 091:374716c637c202478656e60276f6025616374f47f6029476e696370216e6460246566656164702d41627b65737ca4786560235f627365627562702b496e676ea2045865602b696e6760216e6460217575656e602374716274fc61657768696e67602c6f65746c697ea10c497c616c20216c677169737024786560236f6d656469616e6ea30955637c20216c6771697371ae2ea5427e2e2021627560297f6570237562796f65737c202c497c616fb20955637e2027556027796c6c602765647024786560266f6572f362797374716c6370216e6460246566656164702d41627b65737ea307556c6c6c20266f627769667
-- 092:56024786560237b656074796369637de265747e2e2e20297f657027796c6c602371667560247865e77f627c646fb4034f6d65602f6e60246561627c20237166796e6760247865e77f627c64602963702160207562766563647c69f1636365607471626c656027716970247f602370756e6460286562f4796d656ea1014c6c6022796768647c20216c6c6022796768647ea3064962737470297f65702d657374702662756560247865e561637475627e6028616c66602f6660247865eb696e67646f6d6026627f6d602461627b6e6563737ea4045865602345727375602f66602e4967686470236f6d6563f6627f6d602
-- 093:47865602d4f6e61637475627970247f60247865e56163747e20254e64756270296470216e6460226275616be4786560216e6369656e647023657273756ea2074f6f64602c65736b6120295f657023616e602e6f6770276fe47f602461627b6023796465602f66602478656029637c616e646ea202556d656d6265627a30276f60247865602d6f6e616374756279f47f6024786560256163747ea2095f65702469646029647120295f6570227563747f627564e461697c6967686470247f60247865602b696e67646f6d61a10755602e6566756270246f657264756460297f657ea10e4f6c202e6f6470266f627021602
-- 094:375636f6e646ea207556c6c6c202d6169726560266f627021602375636f6e646ea2457470277560277562756027727f6e676ea3084562756029637021602351696c696e67602055627d69647ea3586f6770296470247f6024786560226f61647d616ee96e602259667562737964656ea1074f6f64602c65736b61ad71990bdef9c64d719efff6fbdefde5bd739ffffef838de1bdef4a09d7107556c636f6d6560247f60234163747c6560294e6e6ead7bb33ad0dbb145e0d0c83c18d6b63516b6ba3328d0c53737b6bd3c28d00003045865602465637562747029637024727561636865627f65737ea34162727970207
-- 095:c656e6479702f6660266f6f646027796478e97f657ea20944702568707c6f64656370216370297f65f4727970247f6025737560296471a1095f65702665656c60237c656560797ea2095f6570216275602462716767656460247f602a61696c6ead41627b6573702b6565607370247865602362797374716c637ea1095f65702665656c60236f6c646ea40449627563647c6970237f657478602f666028656275e96370216027627166756022656c6f6e67696e6760247fef6e656027786f60236f657c64602375656023756362756473f0716478637024786164702f6478656270236f657c64602e6f647ea20758616
-- 096:4702964756d60246f60297f657027716e6470247fe964656e647966697fb70845627560296370216e602964756d6024786164702d6169f2656025737566657c60296e60297f65727021757563747ea08946602566756270297f657026696e6460297f657273756c66e96e6027627166756024616e6765627c20257375602964f47f602265602472716e63707f6274756460237166656c69f47f602259667562737964656eab2530216474f7095f65702665656c6024786560276275616470277569676864702f66e97f657270227563707f6e637962696c6964797ea0895f65702d657374702a6f65727e65697025616
-- 097:37470247f60247865e05f6274716c602f666029476e69637c2023747560702478627f657768e96470216e6460246566656164702d41627b65737c20247865e35f627365627562702b496e676ea1095f65702665656c6027796465602167716b656ea3014370297f657024716b6560296470296e60297f65727028616e64637ca97f65702665656c602478616470297f6572702b696e67646f6de86163702265656e60227563747f6275646ea3014c65687120295f657021627560257e64656270247865e365727375602f666024786560235f627365627562702b496e676ea4586963702963702e6f6470297f6571a60
-- 098:11218191d1c260940216d602d41627b65737c20267963656d276f6675627e6f627ea7556021627560277f62727965646021626f657470247865e76f6675627e6f627e2028456027756e6470247f60247865e3616675602e6f6274786d27756374702f6660247f677e6ea083416e60297f6570276f6026696e646028696d6fb30758656e60297f657027716b656025707c20297f6570237565e97f657270236f6d60716e696f6e63702761647865627564e1627f657e6460297f657ea758696368602561757960707564602964756d6fb1095f65702665656c6e2e2e20236f6c646e2e2ea50758656e60297f657021677
-- 099:16b656c20297f6570216275e261636b60296e602259667562737964656ea08458656020756f607c656022756a6f6963656021637024786569f8656162702f66602b496e67602651686e67237022756475727e6ea301242527021318191d1e1d210c45647723702375656e2e2ea40c4567656e6460237075616b63702f666021602c4f6374fc4962627162797c20237f6d65677865627560296ee47865602e6f6274786d2561637475627e60256e64ef6660247869637029637c616e646ea204586569702d657374702265602465616c647027796478ee6f677e2029447023786f657c6460226560256163797ea3045f6
-- 100:02375656024786560256e6472716e63656ca97f65702d65737470207f637375637370247865e35075636471636c65637ea10541757960707564602f6e6027786f6d6fb204586164702471637475646026657e6e697ea95f65702665656c602379636b6ea50940246965646023656e6475727965637021676f60226574fd69702370796279647022756d61696e656460247fe771647368602f66756270247865602b496e6767237022596e67e57e64796c602160277f627478697020716274797023616d65e47f6022756472796566756029647ea30758656e60297f6570257e636f627b6024786560207f64796f6e6ca
-- 101:97f657021627560256e67657c66656460296e60266c616d656371a82d233030286079a30940286561627460247865627560296370237f6d656478696e67e26572796564602f6e602478656029637c616e6460296e60247865ed6964646c65602f6660247865602c616b656ea40458656024656d6f6e60236f6c6c616073756370247fe478656027627f657e6460216e646023747162747370247fed656c64702167716970296e602160236c6f6574602f66e37d6f6b656ea3094022756d656d62656270297f657120295f65702472796564e47f60237166756024786560276f6675627e6f627024756ee975616273702
-- 102:1676f6ea30940246f602e6f647022656c6965667560297f657ea4586560276f6675627e6f6270277f657c646e6724fa657374702769667560247865637560247f60297f657ea1095f65702665656c60237f6e2e2e2024796275646ea401402669656279702c616e64637361607560216771696473ff6e60247865602f6478656270237964656c20247865e3696479702f666029476e69637c20247865602275616c6def666024786560235f627365627562702b496e676ea70f486e2e2e20297f65702c6f6f6b6026616d696c6961627ea4586562756723702160237471647575602f6660237f6d656f6e65e7786f602
-- 103:c6f6f6b637026756279702d657368602c696b65e97f657ea089447723702160237471647575602f66602b496e67602651686ee77964786028696370264c616d656023577f62746ea758696368602964756d6fb407556c6c6e2e2e202940246f6e6724702861667560216ee5607963602370756563686020727560716275646e2029c469646e67247025687075636470297f6570247f602d616b65e9647024786963702661627ea10458616e6b60297f6570216761696e61a303547566756027796c6c60226560276c616460247f6028656162f77560276f6470227964602f6660226577637e202c45647723f76f60247
-- 104:16c6b60247f6028696d6ea2095f65702e6f602c6f6e6765627023756560297f657273756c666ea8296e6679637962696c696479792ea307556023786f657c646022657970237570707c6965637ea64f6f646c20247f62736865637c20277561607f6e637ca1627d6f627e2e2ea4095f6570216275602b496e67602651686e6c2027786fe861637022756475727e656460247f60236f6d607c656475e86963702d696373796f6e602f6660246566656164796e67ed656ea30140207f6274716c60247f60225966756273796465602f60756e63f96e6026627f6e64702f6660297f657ea2556475727e60247f602259667
-- 105:56273796465602e6f677fb304c908020c1d1301121812095f65702c6561627e602e6f6478696e67ee65677026627f6d602478696370226f6f6b6ea50940216d6029476f627c20247865602b496e67672370266f627d6562f1646679637f627e202758656e6028656027756e64702d6164e779647860207f6775627c20236f62727570747564602269f35f627365627562702b496e676c20294025637361607564e16e646028696460296e6024786963702d616a756ea3022c4f627560216e64602755616c6478602f66e4786560214e6369656e6473722ea255616460226f6f6b6fb3075861647f3024586560276f667
-- 106:5627e6f6270296370246561646fb845602761667560297f657024786f6375602362797374716c637fb7496675602478656d60247f602d656ea3014370247865602e656770235f627365627562702b496e676ca97f65702265636f6d6560247865602162637f6c657475e2757c6562702f6660216c6c6ea4024567716275602f6660296365602362756164757275637ea94660297f65702265636f6d656026627f6a756e6c20297f65f3616e602462796e6b602160205f64796f6e602f666026496275e47f6022756475727e60247f602c6966656ea5095f657270227569676e6027796c6c60236f6e64796e6575e66f6
-- 107:270256475627e6964797e202f42702c65616374f57e64796c60216e6f64786562702071627479702f66e16466756e6475727562737026696e646370247865e64f6572702342797374716c637ea104586560246f6f62702963702c6f636b65646ea4094024756163686024786560235472756e676478656ee370756c6c6e2029447027796c6c60296e636275616375e97f65727024616d616765602778656e60297f65f1647471636b602f60707f6e656e64737ea2095f65712f30284f677024696460297f657026696e64e47865602362797374716c637fb2095f657024727970247f60257375602478656027716e64e
-- 108:26574702e6f6478696e676028616070756e637ea20d41627b65737024716b656370247865602362797374716c637ea84963702569756370237071627b6c6560277964786027627565646ea9071615141b1a191f2e240102040505094023756560297f6570266f657e6460247865602b496e676723f3427f677e6e202758656e60297f65702162756027756162796e67e47865602b696e6767237023425f475e4c2023575f425440216e64e2594e474c20297f657023616e60236c61696d60247865eb496e676723702458627f6e656ea20442796e6b60207f64796f6ee458627f6770207f64796f6ee30458696370277
-- 109:96c6c6022756d6f6675602160236572737564e964756d60237f6d656f6e656028616370207574702f6e6ea7586f602861637024786560236572737564602964756d6fb20b496e67602651686e6e2e2e20295f657028616675e6696e616c6c69702465666561647564602d656ea60e0d0c060209070d0c0602010809060759647860247865602b496e6767237022796e676c2023777f6274e16e646023627f677e6c20297f657027796c6c6022656021626c65e47f6024716b6560247865602b496e676723702478627f6e656ea089402f6e6c697021637b602478616470297f657022656021e26564747562702b696e6
-- 110:7602478616e602b496e67602651686e6ea5095f65727024627f6070297f657270277561607f6e6ea95f657270266279656e64637024627f60702478656962f77561607f6e6370247f6f6e20295f65702665656ce47865602566796c60296e63796465602f6660297f65f6716e696378696e676ea10458656027657162746370237572727f657e6460297f657ea20d416e65716c602f666025466665636479667560234f6d6261647ea255616460226f6f6b6fb40f486120295f657022627f65776864702d6560247865e14e6369656e647024496364796f6e6162797120294027796c6ce66f627566756270226560247
-- 111:8616e6b66657c60247fe97f6571a207586164702d616b656370297f65702478696e6b602865e963702e6f647027756c6c6fb2094027796c6c602e6f677024756c65607f627470297f65f47f60247865602f6574737964656ea3002220340940237570707f637560297f657023616d65602865627560247feb696c6c602d6560216e64602662756560247865602c616e64ef6660247865602365727375602f6660247865e35f627365627562702b496e676c202564736c202564736fb906151413191a1d1e1e26035c6f677c697c20297f657022756475727e60247fe97f6572702e6f627d616c6023756c666ea087586
-- 112:9636860246f65637e67247023747f60702c456f6ee6627f6d602b6e6f636b696e6760297f65f57e636f6e6373696f657370266f62702371666564797ea30944756d6370297f657026696e64602d6169702265e365727375646e20234572737564602964756d637023616e6724f26560256163796c697022756d6f6675646ea60d2c2d1c121114045865602b496e67602861637022756475727e656461a0895f65727023756276716e6473702262796e6760297f657021e0727563696f65737027656d6ea40940247561636860247865602147716b656e602370756c6c6ea944702167716b656e6370216e697f6e65602
-- 113:7786fe76564737020757470257e646562702d61676963616ce37c6565607ea60140267f69636560237169737ab0222f4e6c6970247865602b496e676023616e602275636c61696de020247865602478627f6e656e202758656e6028656021627279667563f02027756162796e67602869637023575f42544c2022594e4740216e64e02023425f475e4c202865602378616c6c602f6e636560216761696ee02022757c6560247865602c616e646e22a60458656275602963702f6e6c69702f6e65602c6f676963616ce568707c616e6164796f6e6e20295f65702b494c4c454440247865e76f6675627e6f6270247f602
-- 114:37475616c60247865e362797374716c637ea08745716274637c20216272756374702478656d61a40758656e60297f657028616675602761696e656460256e6f657768e56870756279656e63656c202375656b602160247271696e6562f96e60247f677e60247f60216466716e636560247f60247865ee656874702c6566756c6ea3045865637560266f6f6c637c2027786f602775627560297f6572f4727166756c60236f6d60716e696f6e637c2021627560247865ef6e6c69702478696e6760296e60297f6572702771697eab2135302370756564e5095f65702167716b656e6c20297f6572702d696e6460237c6f6
-- 115:77c69f1646a657374796e6760247f6021602e6567702275616c6964797ea95f657021627560207f67756276657c602e6f677ea4586560256e6479627560277f627c6460296370297f657273f47f6022757c656ea107556c636f6d65612027556023756c6c60226f67737ea408496e647a3024786560285050236f657e64756270282c6f677562f27967686470296e602478656023736275656e692027796c6ce86967686c69676864702778656e60297f65772275602275616469f47f60216466716e6365602c6566756c637ea40458696e6b602477796365602265666f627560276f696e67e47f60247865602e6f627
-- 116:4786029637c616e64637e2029447723f67562797024616e6765627f65737024786562756e20294724e76f60237f6574786026696273747ea5094021646d69627560297f65727020756273796374756e63656ea9402861667560246566656164756460297f65f477756e64797d237566756e6024796d65637c202b496e67e651686e6e20294027796c6c602e6f64702c6f6375602f6ee47865602477756e64797d2569676864786ea2095f65702665656c60297f6572702d61676963e56e6562776970246271696e60216771697ea6095f6572702d416a6563747971a0845861647029637e2e2e2021627560297f65702
-- 117:b496e67e651686e6fb084586560227563756d626c616e636560296370257e63616e6e697ea40940247561636860247865602345727560205f69637f6ee370756c6c6e20294470296370216026756279f5737566657c602370756c6c60266f6270297f6572f4727166756c637ea4094e637964656024786560236865637470297f657026696e646021e2657e646c65602f66602662716762716e6470296e63656e6375e2656c6f6e67696e6760247f602478656024556d607c65602a657374f5616374702f66602259667562737964656ea1054e6a6f6970297f6572702e656770207f677562737ea4095563712020527
-- 118:56071627560247f6024696561a1436475716c6c69702775672275602c6f63747ea7586f6f3027586164702963702160235f627365627562702b496e676fb3416e60277560216c6c60226560235f627365627562702b496e67637fb2094724602371697024786164772370216e60256373756e6479616ce0716274702f66602160207279637f6e67237024656379676e6ea1064f6f6c637e20295f657027796c6c602e6f677e2e2ea60458696370286574702963702162616e646f6e65646ea1402469616279702f6e60247865602471626c656022756164637ab02022245f602478656025616374702f666023516e646
-- 119:0284166756ee020247865627560296370216023796e676c656020716c6d60247275656ea02022457279656460257e64656270296470296370216026716c6571626c65e0202370756c6c626f6f6b6e22a20140236c6f6574602f6660207f69637f6ee66f627d637021627f657e6460297f6571a4095f6572702d416a65637479702861637022756475727e656461a05c656163756c20276f60247f60247865602478627f6e65e27f6f6d60216e64602275636c61696d60297f6572f478627f6e6561a6045f6026696e6460247865602374716475756c20266f6c6c6f67f47865602d65616e646562796e6760207164786
-- 120:02f666024786963f6627f6a756e6022796675627ea0895f657027796c6c6026696e6460296470277865627560247865e279667562702d6565647370247865602375616ea4045865602c4f6374702c49626271627971202458656275e1627560216e6369656e6470216e6460207f67756276657ce26f6f6b6370286562756e2027556023786f657c6460216c637fec6f6f6b602f657470266f6270207160756270276f6c656d637ea40c09060803095f6570227561636860296e647f6024786560207f6274716c6ea9447027756c636f6d656370297f657c202e6f677024786164f97f6570286f6c646024786560264f6
-- 121:572702342797374716c637ea3014e697f6e656027786f602465666561647370247865e35f627365627562702b496e67602265636f6d656370247865ee65687470235f627365627562702b496e676ea40d41627b65737022796375637026627f6d60286963f478627f6e6560216e646028696370226f646970237471627473f47f602368616e676560296e647f6021602769616e64f4656d6f6e6027796478602d616e697024756e6471636c65637ea50c4567656e64602371697370247861647027786f65667562f86163702b496e67602651686e67237023575f42544ca3425f475e40216e646022594e474023616ee
-- 122:36c61696d60247865602478627f6e6560296eee4f627478602b4565607ea4075560216275602f6e602478656023716d6560237964656ea940216c67716973702861646024786560276f6675627e6f627723f4727573747e202940296e637963747e2027496675602d65e47865602362797374716c637ea5095f6570246f6e6724702c696374756e60247f602478656375e66f6f6c637e2024586569702f6e6c697027716e6470247fe37475616c60297f657270207f6775627ea0845865697027796c6c602071697ea4095f65702c6f6f6b6026616d696c6961627e2e2ea142756e672470297f65702478656027627f6
-- 123:57070247861647ca4756e6029756162737021676f6e2e2e2025786e2e2eae456675627d696e646e2028416675602160276f6f646024616971a20d416e65716c602f666023507565646ea255616460226f6f6b6fb2065562797027756c6c6e20284562756024786569702162756ea755602275666573756e20295f657023616e67247028616675602478656d6ea1095f65702665656c602379636b6ea207556023616e6022756d6f6675602478616470236572737564e964756d60266f62702160237d616c6c602665656ea30458656024756d607c65602a6573747025616374702f66e47f677e6024756163686563702
-- 124:d616e697025737566657ce370756c6c637e202245602375727560247f60267963796471a207556c636f6d65612027556022657970216e646023756c6ce77561607f6e637ea207556c636f6d6560247f602478656024556d607c656ea75861647023616e60277560246f60266f6270297f657fb30143702d41627b657370246963796e6475676271647563f96e647f60216020796c65602f666021637865637ca97f65702665656c60237f6d656478696e6760237472716e67656ea4095f657020727f6261626c69702469646e672470207c616ee66f6270277861647028616070756e63702e6568747ea0835f6022627
-- 125:166756c2029756470237f602e616966756ea60458656021646679637f627c202b6e6f67796e6760247865e2796e67672370207f6775627c202275666573756460247fe2756475727e60296470216e6460247f6f6b60227566657765e96e6024786560294365602d416a756ea08944772370237f6574786d27756374702f6660286562756ea804586560207f6274716c602378696d6d65627370296e60216e64602f6574ff66602568796374756e63656e202458627f6577686029647c20297f65f375656021602461627b6c202669656279702c616e6463736160756ca47865602c6567656e646162797023696479702
-- 126:f666029476e69637ea0895f657024727970247f60227561636860296e647f60296470226574f96470227560756c6370297f657e20295f65702e65656460247865e64f6572702342797374716c6370247f60256e6475627ea109402275636f676e696a7560297f657e2e2ea10944656e647966697024786963702964756d6fb204586164702964756d602963702e6f64702365727375646ea95f657023616e6022756d6f667560296470297f657273756c666ea207556c6c6c202947246023716970247865602566796c6025697563f16275602160246561646027696675616771697ea2095f65702665656c602160237
-- 127:5727765602f66602d61676963616ce56e6562776970282b2230302370792ea404586963702964756d60296370216c6275616469f964656e6479666965646e20295f657023616e60237565e9647370296e666f60296e6024786560296e66756e647f6279f3736275656e6ea30f2e2d260314191a1e1d2105467562797478696e6760276f6563702461627b6ea304586560207f64796f6e672370266c616d6563702478616770297f65f261636b60296e647f602c6966656e20295f657023616e602d6f6675e16761696e6ea20944756d60296e60296e66756e647f6279f541757960707564602964756de207556c636f6
-- 128:d65612027556022657970216e646023756c6ce26f6f64737ea2014664756022756164696e676c20297f65702665656c602d657368e7796375627c20216e64602160226964702775616c647869656270247f6f6ea1095f65702665656c602865616c6478697ea30940226567696e60247f602375737075636470297f6572f76f6f6460296e64756e64796f6e637c20266279656e64637eaf427021627560297f65702d6970256e656d6965637fb2045865602963656023696479702f6660274c6163696563fc696563702a65737470247f6024786560237f6574786ea60c4567656e6460237075616b63702f666021602
-- 129:c4f6374fc49626271627970237f6d65677865627560296e60247865e6616270254163747e20294e60296470247865627560296370216ee14e6369656e647024496364796f6e6162797e20294660297f65f6696e646029647c202262796e67602964702261636be47f602d6561a20140267f62747568702f60756e6370216e646020757c6c63f97f6570296e647f6024786560267f69646ea106427f6d60216024786f6573716e646029756162737021676f6ea1095f65702665656c602865616c656461a705141b1a191e1d11014c65687f3021427560297f65702f6b61697fb4095f6572702775616b60266279656e6
-- 130:46370236f6c6c61607375e56163796c697c20216370297f657025687075636475646ea45865697027796c6c602e6f602c6f6e676562702265e16024786275616470247f60297f657ea304586560276571627463702375696a7560247865602362797374716c63f6627f6d60297f6570216e646028616e64602478656d60247fed41627b65737ea404586164702361667560276f656370247f60247865e35f657478602b496e67646f6d6e202245666f6275602775e76f6c2027756023786f657c64602d65656470265963e96e6023557e60205f62747ea50458656970237169702b496e67602651686e6020727563756
-- 131:e647564e869637022796e6760247f60286963702d6f63747024727573747564e1646679637f627e20284f67756675627c20216664756270247865eb496e676027756e64702d6164602779647860207f6775627ca8656024656d616e646564602964702261636b6ea203456c6c616270257e64656270236f6e637472757364796f6e6ea34865636b602261636b60296e6021303029756162737ea207080a071615141b1a191f2e2f14035562796f65737c697c20276f6f64602a6f626ca97f6570216c6c6ea0824574702c656477237027656470247f60226573796e6563737ea6060a02010503030955637e202845627
-- 132:56024786569702162756eae4f6e20245865602362797374716c6370216275602f455253502e6f677ea75169647e202758697027696675602478656d60247f60297f657fb204556d607c6560226c656373796e67e2556d6f6675602365727375e5035c656560796e6760216470216e60296e6e6027796c6ced616b6560297f65702665656c602d657368602265647475627ea0845865627560296370216e60296e6e60296e60247865ee6f62747867756374702071627470247f677e6ea3094028656162746022757d6f6273702478616470247865e76f6675627e6f62702963702d696373796e676e202c45647723f16
-- 133:37b6021627f657e646ea2090804060205030107556023616e6724702f60756e60247865637560226162737e2e2ea2045865602c6567656e64616279702362797374716c637e2e2ea35f6022656165747966657c6e2e2ea609402d65616e6c20296660297f6570246f6e67247023756c6cef657470297f65727027786f6c65602b696e67646f6d60247fe16e602566796c6026796c6c61696e6c20247861647723f16c6275616469702160276f6f646023747162747ea0874f6f64602c65736b61a4065562797026657e6e697e20295f657028616675602e6f64fc6f637470297f65727023756e6375602f666028657d6
-- 134:f627ea08c45647723702375656027786f602c6165776863702c6163747ea304586560286574702963702162616e646f6e65646ea95f657023756162736860296470216e646026696e6460216eef6c64602370756c6c626f6f6b6ea60e0d0c0602090207556c636f6d65612027556022657970216e646023756c6ce1627d6f627ea202457470247861647723702f6b61697c20297f65f0727f6261626c6970246563756276756460247861647ea203547560702478627f65776860247865e07f6274716c60247f6029476e69637fb4084f67756675627c20297f657021627560216761696e60226f657e64e47f6024786
-- 135:56023716d6560267f6770297f65702d616465e16024786f6573716e646029756162737021676f6ab465666561647024786560235f627365627562702b496e676ea2014c65687e2e2e20214c65687fb75861647021627560297f6570246f696e676fb10845602963702e6f647027756c6c6ea20944702375656d6370247869637024616970286163f16272796675646e2024516b6560247869637022796e676ea101427560297f6570237572756fb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP7>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:9bcccb75323578887777788888888888
-- 004:012beffeb63100000009999987653211
-- 005:87769aa98776334667789aa998765332
-- 006:7789aa98777777777777777899877777
-- 007:0000000000001579b975100000000000
-- </WAVES>

-- <WAVES4>
-- 000:0123456789abcdefffedcba987654321
-- </WAVES4>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000204000000000
-- 001:8f303f20af10cf00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00202000000000
-- 002:317021607140e120f110f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100312000000000
-- 003:113021503170418061a091c0e1e0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0f1f0302000000000
-- 004:60008020a040c050e070e090f0b0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0f0c0207000000000
-- 005:3f00ff00ff00ff006f10ff10ff10ff107f20ff20ff20ff20af30ff30ff30ff30df30ff30ff30ff30ef30ff30ff30ff30ef30ff30ff30ff30ff30ff30262000000000
-- 006:3f30ff30ff30ff306f20ff20ff20ff207f10ff10ff10ff10af00ff00ff00ff00df00ff00ff00ff00ef00ff00ff00ff00ef00ff00ff00ff00ff00ff00267000000000
-- 007:9f107f206f207f208f309f30af30af40bf40cf40cf50df50ef50ef50ff50ff50ff50ff50ff60ff60ff60ff60ff60ff60ff60ff60ff60ff60ff60ff60310000000000
-- 008:9f408f808f907f906f806f606f406f306f206f107f007f008f008f009f00af00bf00bf00cf00df00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00110000000000
-- 009:3fd04fb05f706f607f408f30af20bf10cf00cf00df00ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00400000000000
-- 010:4520254015600570159035b055d075e085e0b5e0d5e0e5e0e5e0e5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0f5e0277000000000
-- 011:507060709090c090d0b0e0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0f0b0277000000000
-- 012:25201520154045507550a550b550c550d550f550f550f550f550f550f550f550f550f550f550f550f550f550f550f550f550f550f550f550f550f550307000000000
-- 013:317021702190119011b011b001c001c001e001e001e001e011e031e061e091e0b1e0d1e0e1e0f1e0f1e0f1e0f1e0f1e0f1e0f1e0f1e0f1e0f1e0f1e0350000000000
-- 049:b800d800e800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800f800304000000000
-- 050:010001000140014001000100014001400100010001400140010001000140014001000100014001400100010001400140010001000140014001000100367000000000
-- 051:0100110041007100a100c100d100e100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100300000000000
-- 052:2100210021002100210021002100210021002100210021003100410041005100610081009100a100b100c100d100e100f100f100f100f100f100f100404000000000
-- 053:000000000040004000000000004000400000000000400040000000000040004000000000004000400000000000400040000000000040004000000000277000000000
-- 054:4000600080009000d000e000e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000303000000000
-- 055:a10e610f410f5100a100c100d100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100300000000000
-- 056:670047003700270017000700070007000700070007001700170027002700270027003700370037003700370037003700370037003700370037003700304000000000
-- 057:b100a1008100810071006100610061006100610061006100610061006100610061006100610061006100610061006100610061006100610061006100401000000000
-- 058:1600260046007600b600e600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600404000000000
-- 059:0000200060009000b000d000e000e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000107000000000
-- 060:010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100409000000000
-- 061:250045008500a500c500d500e500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500f500007000000000
-- 062:03000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300230053009300f300300000000000
-- 063:0f007f00af00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00307000000000
-- </SFX>

-- <SFX4>
-- 049:a1009100a100c100d100e100e100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100305000000000
-- 052:900a800c700d600d600e500e500f400f4000400030003000300020002000200020002000200030003000300030004000400040004000500060007000400000000000
-- 053:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000305000000000
-- </SFX4>

-- <PATTERNS>
-- 000:b70899000000000000000000870899000000000000000000470899000000000000000000870899000000b70899000000f70899000000000000000000b70899000000000000000000670899000000000000000000f70897000000670899000000d70899000000000000000000870899000000000000000000470899000000000000000000d70897000000470899000000970899000000000000000000470899000000000000000000d70897000000000000000000b70897000000000000000000
-- 001:4b08d58b08d5bb08d58b08d54b08d58b08d5bb08d58b08d54b08d58b08d5bb08d58b08d54b08d58b08d5bb08d58b08d5bb08d5fb08d56b08d7fb08d5bb08d5fb08d56b08d7fb08d5bb08d5fb08d56b08d7fb08d5bb08d5fb08d56b08d7fb08d5db08d54b08d78b08d74b08d7db08d54b08d78b08d74b08d7db08d54b08d78b08d74b08d7db08d54b08d78b08d74b08d79b08d7db08d74b08d9db08d79b08d7db08d74b08d9db08d79b08d7db08d74b08d9db08d74b08d78b08d7bb08d74b08d7
-- 002:b70879000000870879000000470879000000b70877000000470879000000870879000000b70879000000870879000000b70879000000670879000000f70877000000b70877000000670879000000b70879000000f70879000000670879000000d70879000000870879000000470879000000d70877000000870877000000000000000000d70877000000000000000000970879000000000000000000470879000000000000000000970879000000000000000000d70879000000000000000000
-- 003:4b08190000000000000000004b08190000000000000000004b08190000000000004b08194b08190000000000000000004b08190000000000000000004b08190000000000000000004b08190000000000004b08194b08190000000000000000004b08190000000000000000004b08190000000000000000004b08190000000000004b08194b08190000000000000000004b08190000000000000000004b08190000000000000000004b08190000000000004b08194b0819000000000000000000
-- 004:4908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d54908d54908d59908d59908d5
-- 005:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b908d90000009908d98908d99908d9000000000000000000000000000000000000000000000000000000000000000000b908d90000009908d98908d99908d9000000000000000000000000000000000000000000000000000000000000000000d908d9000000b908d99908d9b908d9000000000000000000000000000000000000000000000000000000000000000000
-- 006:f908d9000000d908d9b908d9d908d9000000b908d90000009908d90000008908d90000006908d90000008908d90000009908d90000008908d90000006908d90000004908d9000000b908d99908d9b908d99908d98908d96908d98908d96908d9b908d99908d98908d96908d94908d90000004908d9000000000000000000000000000000000000000000000000000000b908db0000009908db8908db9908db000000000000000000b908d90000009908d98908d99908d9000000000000000000
-- 007:4908e70000006908e70000008908e7000000d908e7000000b908e70000009908e70000004908e70000006908e70000008908e7000000d908e7000000b908e70000009908e70000004908e90000006908e90000008908e9000000d908e9000000b908e90000009908e90000004908e90000006908e90000008908e90000009908e9000000b908e90000009908e98908e99908e90000000000000000008908e90000006908e94908e96908e9000000000000000000b908e98908e99908e96908e9
-- 008:8908e94908e96908e9f908e74908e9d908e7f908e7d908e7b908e70000008908e70000006908e70000004908e70000008908e7000000b908e70000004908eb000000f908e9000000d908e9000000d908e9000000b908e9000000b908e90000009908e90000009908e90000008908e90000008908e9000000d908e9000000d908e9000000b908e9000000b908e90000009908e90000009908e90000008908e90000008908e9000000b908e99908e98908e96908e94908e9000000000000000000
-- 009:4b08c74b08c78b08c7bb08c7bb08c78b08c79b08c76b08c74b08c74b08c78b08c7bb08c7bb08c78b08c79b08c76b08c74b08c74b08c78b08c7bb08c7bb08c78b08c79b08c76b08c74b08c74b08c78b08c7bb08c7bb08c78b08c79b08c76b08c74b08c74b08c78b08c7bb08c7bb08c78b08c79b08c76b08c74b08c74b08c78b08c7bb08c7bb08c78b08c79b08c76b08c74b08c74b08c78b08c7bb08c7bb08c78b08c79b08c76b08c74b08c74b08c78b08c7bb08c7bb08c78b08c79b08c76b08c7
-- 010:0000000000000000000000000000000000000000000000000000000000000000000000004708d76708d78708d7b708d70000000000000000000000000000000000000000000000004708d76708d78708d7b708d7000000000000000000000000000000000000000000000000b708d79708d78708d76708d70000000000000000000000000000000000000000000000004708d76708d78708d7b708d79708d78708d76708d7000000000000000000000000000000000000000000000000000000
-- 011:4708d74708d7b708d7b708d79708d78708d76708d76708d78708d98708d9f708d9f708d9d708d9b708d99708d99708d94708d78708d7b708d78708d74708d78708d7b708d78708d76708d99708d9d708d99708d96708d99708d9d708d99708d9f708d7d708d7b708d79708d78708d76708d74708d76708d7f708d9d708d9b708d99708d98708d96708d94708d9b708d7d708d70000008708d70000006708d7000000d708d9000000b708d90000009708d90000006708d90000004708d9000000
-- 014:4a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f34a08f3ba08f39a08f3ba08f3
-- 015:0000000000000000000000000000000000000000000000004708e50000004708e50000000000000000000000000000000000000000000000000000000000000000000000000000004708e50000004708e50000000000000000000000000000000000000000000000000000000000000000000000000000006708e50000006708e50000000000000000000000000000000000000000000000000000000000000000000000000000004708e50000004708e5000000000000000000000000000000
-- 016:000000000000000000000000000000000000000000000000d708e5000000d708e50000009708e50000009708e5000000b708e5000000b708e50000008708e50000008708e5000000b708e50000009708e50000006708e50000006708e50000004708e50000004708e50000004708e56708e58708e50000004708e50000004708e50000004708e56708e58708e50000006708e50000006708e5000000b708e50000009708e50000008708e50000006708e50000004708e50000004708e5000000
-- 017:4c08f5000000dc08f5bc08f50000006c08f59c08f50000004c08f5000000dc08f5bc08f50000006c08f59c08f50000004c08f5000000dc08f5bc08f50000006c08f59c08f50000004c08f5000000dc08f5bc08f50000006c08f59c08f50000004c08f5000000dc08f5bc08f50000006c08f59c08f50000004c08f5000000dc08f5bc08f50000006c08f59c08f50000004c08f5000000dc08f5bc08f50000006c08f59c08f50000004c08f5000000dc08f5bc08f50000006c08f59c08f5000000
-- 018:4b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b34b08b38b08b3bb08b38b08b3
-- 019:0000000000000000000000004708e5b708e58708e50000000000000000000000000000006708e5d708e59708e50000000000000000000000000000008708e5100000f708e5100000d708e5100000b708e51000009708e51000008708e50000000000000000000000000000004708e5b708e58708e50000000000000000000000000000006708e5d708e59708e50000000000000000000000000000008708e5100000f708e5100000d708e5100000b708e51000009708e5100000d708e5000000
-- 020:f708e5100000f708e5100000f708e5d708e5000000100000b708e5100000b708e5100000b708e59708e50000001000008708e51000008708e51000008708e56708e50000001000004708e5d708e5b708e50000004708e5d708e5b708e50000004708e5f708e5d708e50000004708e5f708e5b708e5d708e59708e5b708e58708e59708e56708e54708e51000004708e51000006708e51908a16708e5100000b708e5100000b708e51000009708e51000009708e51000008708e51000008708e5
-- 021:b708e56708e5000000000000b708e56708e5000000000000b708e56708e5000000000000d708e58708e5000000000000d708e58708e5000000000000d708e58708e50000000000004708e56708e58708e56708e5b708e51908a1d708e5100000f708e51908a14708e7100000f708e51908a1d708e5100000b708e51908a19708e5100000d708e5b708e5000000000000f708e5d708e50000000000006708e71000004708e7100000f708e5100000b708e5100000d708e51000009708e5100000
-- 022:4708e5d708e51000009708e5b708e58708e50000001000006708e5f708e5100000b708e5d708e59708e50000001000004708e5d708e51000009708e5b708e58708e50000001000006708e5f708e5100000b708e5d708e59708e58708e51000006708e51000004708e5100000f708e5100000d708e51908a1f708e51000004708e5100000f708e5100000d708e5100000b708e59708e58708e56708e58708e59708e58708e56708e5b708e59708e58708e5d708e5b708e59708e5000000000000
-- 024:4d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a54d08a58d08a5bd08a58d08a5
-- 025:4c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f54c08f11b08f14c08f39c08f5
-- 026:b708a90000000000000000006708a90000000000000000009708a90000008708a90000006708a90000008708a99708a9b708a90000000000000000006708a9000000000000000000d708a9000000b708a90000009708a90000008708a90000009708a90000000000000000006708a90000000000000000009708a90000008708a90000006708a90000004708a90000006708a9000000000000000000f708a9d708a9b708a99708a98708a90000000000000000006708a9000000000000000000
-- 027:4708a9b708a98708a9b708a90000000000000000000000004708a9b708a98708a9b708a9000000000000000000000000d708a9b708a99708a98708a9000000000000000000000000d708a9b708a99708a98708a90000000000000000000000004708a90000008708a9000000b708a90000008708a90000006708a90000009708a9000000d708a90000009708a90000004708a90000008708a9000000b708a90000008708a90000004708ab000000b708a90000008708a90000004708a9000000
-- 031:4c08f31008f1bc08f1fc08f34c08f3000000dc08f5fc08f54c08f31008f1bc08f1fc08f34c08f3000000dc08f5fc08f54c08f31008f1bc08f1fc08f34c08f3000000dc08f5fc08f54c08f31008f1bc08f1fc08f34c08f3000000dc08f5fc08f54c08f31008f1bc08f1fc08f34c08f3000000dc08f5fc08f54c08f31008f1bc08f1fc08f34c08f3000000dc08f5fc08f54c08f31008f1bc08f1fc08f34c08f3000000dc08f5fc08f54c08f31008f1bc08f1fc08f34c08f3000000dc08f5fc08f5
-- 032:4a08d38a08d3ba08d38a08d34a08d38a08d3ba08d38a08d34a08d38a08d3ba08d38a08d34a08d38a08d3ba08d38a08d3da08d34a08d38a08d34a08d3da08d34a08d38a08d34a08d3da08d34a08d38a08d34a08d3da08d34a08d38a08d34a08d34a08d38a08d3ba08d38a08d3ba08d3fa08d36a08d3fa08d3ba08d3fa08d36a08d3fa08d3ba08d3fa08d36a08d3fa08d3ba08d3fa08d36a08d3fa08d3ba08d3fa08d36a08d3fa08d3ba08d3fa08d36a08d3fa08d3ba08d3fa08d36a08d3fa08d3
-- 033:4708d7d708d7b708d7d708d70000000000000000006708d74708d7d708d7b708d7d708d7000000000000000000f708d7d708d74708d99708d98708d96708d94708d9f708d7d708d78708d79708d7b708d79708d78708d70000006708d70000004708d70000000000000000004708d7d708d7b708d7d708d70000000000000000006708d74708d7d708d7b708d7d708d7000000000000000000f708d7d708d74708d99708d98708d96708d94708d9f708d7d708d78708d79708d7b708d79708d7
-- 034:8708d70000006708d70000004708d70000000000000000004708d7000000b708d70000004708d7000000b708d7000000d708d70000004708d9000000d708d70000004708d9000000d708d7f708d74708d96708d98708d96708db4708dbf708d9b708d9000000b708d7000000b708d7b708d76708d96708d9b708d7b708d78708d98708d96708d94708d9f708d7d708d7b708d7a708d78708d76708d7b708d7b708d78708d98708d96708d94708d9f708d7d708d7b708d7a708d78708d76708d7
-- 035:4708db1000008708db100000b708db1000008708db1000004708db1000006708db1000004708d78708d7b708d78708d7d708d7b708d79708d78708d7d708d79708d78708d76708d7d708d79708d78708d76708d7d708d9b708d99708d98708d96708d94708d9f708d7d708d7b708d7f708d76708d9b708d76708d7a708d7d708d7a708d76708d7a708d7d708d7a708d7b708d9a708d98708d96708d94708d9b708d7a708d78708d76708d70000004708d7000000b708d5000000000000000000
-- 039:4708c5000000b708c50000008708c5000000b708c5000000d708c50000008708c70000004708c70000008708c70000009708c50000004708c7000000d708c50000004708c7000000b708c50000006708c7000000f708c50000006708c7000000b708c50000006708c7000000f708c50000006708c70000006708c5000000d708c50000009708c5000000d708c50000004708c5000000b708c50000008708c5000000b708c50000004708c5000000b708c50000008708c5000000b708c5000000
-- 040:400887000000000000000000b00887000000800887000000d00887000000000000000000400887000000000000800887900887000000000000000000000000000000000000000000b00887000000600887000000b00887f00887b00887000000600887000000b00887000000000000000000000000000000600887000000900887000000600887000000900887000000b00887000000800887000000400887000000800887000000b00887000000b00887900887800887600887400887000000
-- 041:400889000000000000000000b00889900889800889b00889d00889000000800889b00889400889000000800889000000900889400889900889d00889400889900889d00889900889b00889000000000000000000000000000000000000000000f00889b00889600889000000b00889600889f00887000000600889900889d00889900889600889900889d00889900889b00889900889800889600889400889600889800889900889b00889000000800889600889400889f00887400889000000
-- 042:6708c50000009708c5000000d708c50000009708c5000000b708c50000006708c7000000e708c50000006708c7000000b708c50000006708c7000000e708c50000006708c7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 043:d00887900887600887000000d00887900887600887000000e00887b00887e00887b00887600887b00887e00887b00887600887b00887e00887b00887600887b00887e00887b00887000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 044:d00889000000000000900889d00889000000000000000000e00889000000600889b00889e00889000000600889b00889e00889b00889600889b00889e00889000000600889000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:470849000000000000000000870849000000000000b70849d70849000000870849000000d70849000000000000000000000000000000000000000000000000000000000000000000870849000000b70849000000f70849000000000000000000b70849000000000000000000870849000000000000000000f70847000000000000000000a70849000000000000000000000000000000000000000000000000000000000000000000f70847000000000000770849a70849000000000000000000
-- 050:4b08470000008b0847000000bb08470000008b0847000000db08470000004b08490000008b08490000004b0849000000db08470000004b08490000008b08490000004b08490000008b0847000000bb0847000000fb0847000000bb08470000008b0847000000bb0847000000fb0847000000bb0847000000fb08470000008b0847000000ab08470000007b0847000000fb08470000007b0847000000ab08470000007b0847000000fb08470000007b0847000000fb0847000000bb0847000000
-- 051:bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb0819000000000000000000bb0819000000000000000000bb0819000000000000000000bb0819000000000000000000
-- 052:470849000000870849000000b70849000000870849000000d7084900000047084b00000087084b00000047084b000000d7084b00000087084b00000047084b000000d7084900000087084b000000f70849000000b70849000000870849000000870849000000000000b70849870849000000000000b70849f70849000000000000000000a7084b00000077084b000000f70849000000a7084900000077084b000000f70849000000a70849000000770849000000a70849000000000000000000
-- 053:470867bb08650000004708658708670000004b0865b70867d70867db08658708678b0865d70867db08658b08654b086500000000000000000000000087086b8b086500000000000047086b4b0865000000b70869f70869fb0865bb08658b0865bb0863000000000000000000000000000000000000000000f70865000000000000000000770867000000000000a70867d70867000000770867000000a70867000000f70867000000a70867000000770867000000a70867000000f70867000000
-- 054:470849000000000000000000b70849000000000000000000d70849000000000000000000470849000000000000000000d7084900000000000000000087084b00000000000000000047084b000000000000000000f70849000000000000000000b70849000000000000000000870849000000000000000000b70849000000000000000000000000000000000000000000000000000000000000000000a70849000000000000000000000000000000000000000000000000000000000000000000
-- 055:b70867000000870867000000470867000000b70865000000d70865000000870865000000470865000000870863000000d70869000000870869000000470869000000d70867000000f70867000000b70867000000870867000000b70865000000870865000000b70865000000f70865000000b70865000000f70865000000870867000000a70867000000770867000000770865000000a70867000000f70865000000770865000000f70865000000770867000000f70867000000b70867000000
-- 056:470849000000870849000000b70849000000870849000000d70849000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000870849000000b70849000000f70849000000b70849000000870849000000000000000000000000000000000000000000000000000000000000000000a70849000000770849000000f70847000000770849000000a70849000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <PATTERNS1>
-- 000:b70008000000000000000000870008000000000000000000470008000000000000000000870008000000b70008000000f70008000000000000000000b70008000000000000000000670008000000000000000000f70006000000670008000000d70008000000000000000000870008000000000000000000470008000000000000000000d70006000000470008000000970008000000000000000000470008000000000000000000d70006000000000000000000b70006000000000000000000
-- 001:4b00168b0016bb00168b00164b00168b0016bb00168b00164b00168b0016bb00168b00164b00168b0016bb00168b0016bb0016fb00166b0018fb0016bb0016fb00166b0018fb0016bb0016fb00166b0018fb0016bb0016fb00166b0018fb0016db00164b00188b00184b0018db00164b00188b00184b0018db00164b00188b00184b0018db00164b00188b00184b00189b0018db00184b001adb00189b0018db00184b001adb00189b0018db00184b001adb00184b00188b0018bb00184b0018
-- 002:b7000a00000087000a00000047000a000000b70008000000470008000000870008000000b70008000000870008000000b7000a00000067000a000000f70008000000b70008000000670008000000b70008000000f70008000000670008000000d70008000000870008000000470008000000d70006000000870006000000000000000000d70006000000000000000000970008000000000000000000470008000000000000000000970008000000000000000000d70008000000000000000000
-- 003:4b00380000000000000000004b00380000000000000000004b00380000000000004b00384b00380000000000000000004b00380000000000000000004b00380000000000000000004b00380000000000004b00384b00380000000000000000004b00380000000000000000004b00380000000000000000004b00380000000000004b00384b00380000000000000000004b00380000000000000000004b00380000000000000000004b00380000000000004b00384b0038000000000000000000
-- </PATTERNS1>

-- <PATTERNS4>
-- 000:600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:470849000000000000000000870849000000000000b70849d70849000000870849000000d70849000000000000000000000000000000000000000000000000000000000000000000870849000000b70849000000f70849000000000000000000b70849000000000000000000870849000000000000000000f70847000000000000000000a70849000000000000000000000000000000000000000000000000000000000000000000f70847000000000000770849a70849000000000000000000
-- 050:4b08470000008b0847000000bb08470000008b0847000000db08470000004b08490000008b08490000004b0849000000db08470000004b08490000008b08490000004b08490000008b0847000000bb0847000000fb0847000000bb08470000008b0847000000bb0847000000fb0847000000bb0847000000fb08470000008b0847000000ab08470000007b0847000000fb08470000007b0847000000ab08470000007b0847000000fb08470000007b0847000000fb0847000000bb0847000000
-- 051:bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb08190000000000000000004b0819000000000000000000bb0819000000000000000000bb0819000000000000000000bb0819000000000000000000bb0819000000000000000000
-- 052:470849000000870849000000b70849000000870849000000d7084900000047084b00000087084b00000047084b000000d7084b00000087084b00000047084b000000d7084900000087084b000000f70849000000b70849000000870849000000870849000000000000b70849870849000000000000b70849f70849000000000000000000a7084b00000077084b000000f70849000000a7084900000077084b000000f70849000000a70849000000770849000000a70849000000000000000000
-- 053:4b000a0000000000000000008b000a000000000000bb000adb000a0000008b000a000000db000a0000000000000000000000000000000000000000000000000000000000000000008b000a000000bb000a000000fb000a000000000000000000bb000a0000000000000000008b000a000000000000000000fb0008000000000000000000ab000a000000000000000000000000000000000000000000000000000000000000000000fb00080000000000007b000aab000a000000000000000000
-- 054:470849000000000000000000b70849000000000000000000d70849000000000000000000470849000000000000000000d7084900000000000000000087084b00000000000000000047084b000000000000000000f70849000000000000000000b70849000000000000000000870849000000000000000000b70849000000000000000000000000000000000000000000000000000000000000000000a70849000000000000000000000000000000000000000000000000000000000000000000
-- 055:b70867000000870867000000470867000000b70865000000d70865000000870865000000470865000000870863000000d70869000000870869000000470869000000d70867000000f70867000000b70867000000870867000000b70865000000870865000000b70865000000f70865000000b70865000000f70865000000870867000000a70867000000770867000000770865000000a70867000000f70865000000770865000000f70865000000770867000000f70867000000b70867000000
-- 056:470849000000870849000000b70849000000870849000000d70849000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000870849000000b70849000000f70849000000b70849000000870849000000000000000000000000000000000000000000000000000000000000000000a70849000000770849000000f70847000000770849000000a70849000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS4>

-- <TRACKS>
-- 000:1804003804000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d0000
-- 001:5810005c10005c1000502000542000542000000000000000000000000000000000000000000000000000000000000000c90000
-- 002:ac2000ac2000a030000000000000000000000000000000000000000000000000000000000000000000000000000000006a0000
-- 003:f04000f04000f44000000000000000000000000000000000000000000000000000000000000000000000000000000000c90000
-- 004:2d44102d44102d45102105102d46102d46102d47102d47100000000000000000000000000000000000000000000000004c0000
-- 005:996b10996b10996c100000000000000000000000000000000000000000000000000000000000000000000000000000006a0000
-- 006:068220068220068320068320068420048420000000000000000000000000000000000000000000000000000000000000c90000
-- 007:2fc0002fc4305fc4305fc4307fc4307fc4306fc4308fc4306fc4308fc4309fc4300000000000000000000000000000004c0000
-- </TRACKS>

-- <TRACKS1>
-- 000:180400380400000000000000000000000000000000000000000000000000000000000000000000000000000000000000ec0000
-- </TRACKS1>

-- <TRACKS4>
-- 000:2fc4bd2fc4bd5fc4305fc4300000000000000000000000000000000000000000000000000000000000000000000000006a0000
-- </TRACKS4>

-- <PALETTE>
-- 000:140c1c30142c30346d2828248159302c481cd04648757161597dced27d2c8595a16daa2cd6ae796dc2cadad45edeeed6
-- </PALETTE>

-- <PALETTE1>
-- 000:140c1c30142c30346d282824815930346524d04648757161597dced27d2c8595a16daa2cd6ae796dc2cadad45edeeed6
-- </PALETTE1>

-- <PALETTE2>
-- 000:140c1c30142c30346d282824815930346524d04648757161597dced27d2c8595a16daa2cd6ae796dc2cadad45edeeed6
-- </PALETTE2>

-- <PALETTE3>
-- 000:140c1c30142c30346d2828248159302c481cd04648757161597dced27d2c8595a16daa2cd6ae796dc2cadad45edeeed6
-- </PALETTE3>

-- <PALETTE4>
-- 000:140c1c30142c30346d2828248159302c481cd04648757161597dced27d2c8595a16daa2cd6ae795d8dd6dad45edeeed6
-- </PALETTE4>

-- <PALETTE5>
-- 000:140c1c30142c30346d2828248159302c481cd04648757161597dced27d2c8595a16daa2cd6ae796dc2cadad45edeeed6
-- </PALETTE5>

-- <PALETTE6>
-- 000:140c1c30142c30346d2828248159302c481cd04648757161597dced27d2c8595a16daa2cd6ae796dc2cadad45edeeed6
-- </PALETTE6>

-- <PALETTE7>
-- 000:140c1c30142c30346d282824815930346524d04648757161597dced27d2c8595a16daa2cd6ae796dc2cadad45edeeed6
-- </PALETTE7>

-- <COVER>
-- 000:9ab000007494648393160f00880077000012ffb0e45445353414055423e2033010000000129f40402000ff00c2000000000f0088007841c0c1828242edee6d58591aad4de50341c25717160d64842dd7c20343d6189503c284c100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080ff001080c1840b0a1c388031a2c58c0b1a3c780132a4c9841b2a5cb88133a6cd8c1b3a7cf80234a8c1942b4a9c398235aac59c2b5abc790336acc9943b6adcb98337aecd9c3b7afcf90438a0d1a44b8a1d3a8439a2d5ac4b56086a23f924d9a45baa5dba853ba6ddac5bba7dfa063ca8d1b46bca957925fcaad5bc6bdabd7b073eacd9b47beaddbb87b86a50bb73fafdfb0830b0e1c85508002cc6d0f1e3c40d0f047c20123085c501235e8cc8f2f46bc599132689e972b8e1d79b4f8e3d9994ba67ce992b9e3df9b5a26cc2a95fae8c5b153ee4dfaf17367d0b36fbc10008871f3e3088b175e209933f6e0df972f186c9a74f8e5d587bc4ebcfaf1f2e5d7a73ff71f4d3c314eefdfc77ffe8e5bbbf7f0f3ebcf9b4065218af7fbefcfb98f5f314ffc0108f05e7404f5bf9d440ed711928b06d760e182392840a44c0244a0600f0a143127491e18c0678b055830a38d09f722248f15e720188a0d9852618c2e14e22a8b19a80006831dc81229841a0843a64a22e8ff10050810a123821e04af9d850d58d4ad8b1a0405ae8f3a58f1e19104f700848a5e698f97906e3973224c528956699556543bd145081610800600b6b8dc94b1d929d361a91427e66c7ee996e5463ee550ed795669a52a9942a9ff1f8f4e1ae8a79e3ef965ae7961c848e0adf998b4e79c4a892517968a99f8a2919294136c514a798161079a1a600291662ffab463a89e6a2aeda7669a29e884041081efacaebafba1984a6a4aa085ce196b61ba9aeabb244ebefa2de4b10819fc69454a941d25bcd65b7de841da5b2258bcda105ee7b02d6bed684aea4b6e25bfeeab8ee64deacbd15dbdd67b2eecb711eb6fa64ef6eb7eef57a6a41d2ebbf2647079bc03cbcf654deafa1fefb01f4b10bebee605f413797634b132784d5c917fb2079c9f62cb3168cd197f09acb2f1522f4b8234b627dc307f410410a3bec9d93493fec504fc1419b0fedc1111d2373c94b3c83becf3b0dc0dfc10c0014715efe4c3ce0b21d5da4bbba4fcc63daaf4b44253fc445cc2038d801ad6379ca6fc45675d0cdcd5bd3deb24dc31bd96b34a77bffdb7be4f370d9c9104871e68f1e5870e66fd824a0406ffa40dbde1d2c5475e2333449f2da9b7d69f8c8310b2830d2af8eb338e3d9ac81a199ab148ab7bba36b61bfd5da7ec66ce2b7bd31b4ef250e3001e4a719608ec708ecebf3d6cdfa304ae2d23ef412fac34e09f74d7bdc06f4f7bbbd935ec9335db33204c70f2ab7f5abfa557be3d62f6e3af7eb3fc6aeea095f4db140ff5ff778d7737f50c104088f3a320bff8fbd36edbb0b685b9d9103b6d8b1848b822843ecd6e01879350e3fe1831470a501284b38bdec0f7400104fa847d1cf029fcc610840c3fcc59005fdbbc4860441aa0bf2ae27f5148b6d93c0240da5434a0e10f2851cb1a20a00a0850820ffe7844412e011880443221139834c52601b9884c72e11b8834cb193d0f7844d9531f78a540adaa6a3900304a0785db3616ae2c836c4d5919675f291a046e77bb0ede09e747c27d20cb780802610610b7c508019f8084f3ae1309f7cd36f1b0948c14e12da8c330a171510dc300c32db8043008fe4e8ebb22dddeb7a9ca618f4e8cd390a1ded757c83692f49e04308027103085080441045365ab25291bc65eb2b693b485ee1d694bcd56e29a6c8c0a10f2a836a6ed217c7b332250f69904366e525390e32e1431782636a1925b753ce1a637e871c20273fb9edc07ad1b593bc73293902143f32a3fc9a0467a935d9de46edfe4105ccb1171929ba256a627f9fffccf42f3939cc4225ce2777d4061a213670d48e40d00f349f510c1a01d91e3452a2fbb154393904ca7600e7899c11aec4f9efcf7af334a3257a5dcaa7a059d97335a4fba2614c5a40189e0446afa4a7eb4d6a13537d52117c35e9a2e4a92259629458a44569a15f8a84d55dfe69ac4d6ae2539ac2557d805a535538a945c6755de565baa8559aa4dcaae5ddae75bba45d1ba653ca8657aaf1d9ac6d7a285bca26d8b2a51ea3750b6b5fea87dcbae57fac7debaf5ffa08d0ce8e0b91832c20059a4e30d52611b6857ad6be0b58d7ca3651bd8d5c64692b295bc246747b656b6765dac746a65674b9952d266f4bc8dcca0675bcad6dab6f5b0bd8dac676b4bdadffad6f6bba54c69ee7a7031d9e6d4a385edef6b7be541ea1738b8c5fde1759bcadfc635d9b5cd4e64799b4dd9ea5777b8bdcea677bbcddeea77fbb0ed0fa8779a0dde3e877fa5edfd5a7947be5ec68614bedd6fa8e4eb7edafad7feb8f5fceb7f9bbf56a2d73fbaddff20870c40e20b18f0c80e40fa6bcb2062f6f7d1cd6d60338f1cae5a03b7d2ceed803687ebf069077873c043f0b2874c42e21b98f4c82efbe4833caf57d638b2c6bd71f5895c0fd6dac835c83ec1be87cb736e0fe8f7c04e02b0978c4464fe78d5c02ed9da8d7cd26623f579cf4e327f554ce4652729576d3e22b697bcc5ee2b873bc93603708fac97513b79fcc8669da9916c96eceea9bffdc07e83bc97ec6ed92b4934c466cd2593ac436ef229ffc556a3b0a70d48e24be5fdcb5ed3bf9d0dc862432a5bcf8e64b4a72d49ea4ba93fca2eb378913d6063374ad2d0ae05b8a74d4ae25b9a17cf96c237ad1dbae35bbaf5d0be507ba7bb9ae23fcaf0d7becf6da36d28ee8ed5f2a04d06b8e08d0c6c8e039f9ebed7e2539da7df4643b8d3cedba3bd8dfbb26f541ad1b5c674b7763d68625b10aec6b637b34a3a376e1b999dcc2963319dedee8a8b9cdcd667f0b799ad6f6b2b1adcced9e7fabd9e6c8662ffd6ee377db3ed445373ab18a6071631cfad4a35778b3ad10f1770b31e7072aedbb0eff456f1bb1eff628fab71ede648b8bb0e52d7678cb2ebc37e8770cf99b0fe7a2c11ef1f893ab91ebe6e736c13e117b8b9c1874f609b5cb1e917d8b0bf1e33798bccf9dd3fb7bebdede4de8f6c99ea1f883eb10ac1f4a71ec3e4d6263cbd5e2471939b19e03fd7fbcd99b35267cc34e24d1938b52e43718fbcb9e7670abd770e546ab3fafee87fcbfa6302000b3
-- </COVER>

