-- RENDERING ENGINE
--[[
This module takes care of rendering 3D graphics to the screen.

WORLD COORDINATES: are given in tile lengths (the width/length of a
tile is defined to be 1). So the center of tile c,r is (c+0.5,r+0.5).


IMPLEMENTATION DETAILS:

PIPELINE:

TRI IN WORLD SPACE
  --view transformation-->
TRI IN CLIP SPACE (camera at 0,0,0, orthogonal projection)
  --clipping-->
TRI(s) IN CLIP SPACE (tris may be broken up)
  --projection-->
TRI IN EYE SPACE (with perspective)
  --viewport transformation -->
TRI IN VIEWPORT COORDS
]]

-- Near clipping plane.
#define NCLIP 0.3

-- When a wall of width 1 is viewed at dist 1,
-- it will be REND_S pixels wide on the viewport
#define REND_S 80

-- Viewport dimensions.
#define VP_X 0
#define VP_Y 0
#define VP_W 184
#define VP_H 108

-- Viewport center.
#define VP_CX VP_X+VP_W/2
#define VP_CY VP_Y+VP_H/2

#define FLOOR_Y 0
#define CEIL_Y 1

-- Cutoff dcf (dot product with camera forward) for rendering.
-- Renderables whose dot product fall BELOW this value will not
-- be rendered.
#define CUTOFF_DCF 0.5

-- Renderable types.
#define RK_WALL_N 0
#define RK_WALL_E 1
#define RK_WALL_S 2
#define RK_WALL_W 3
#define RK_FLOOR 4
#define RK_CEIL 5
#define RK_SPRITE 6

-- Lighting settings
-- Fully dark.
#define LIGHT_NONE 1
-- Partially lit (limited light).
#define LIGHT_LIMITED 2
-- Fully lit
#define LIGHT_FULL 3

-- Renderable flags:
-- If set, forces renderable to render on top of everything.
#define RF_REND_TOP 1
-- If set, this is a transparent wall. This has no effect on sprites,
-- which are always transparent.
#define RF_TRANSPARENT 2

-- TYPE: Renderable
--  id: the unique ID of the renderable, assigned at creation
--  x,z: position of start of renderable (SW corner for floor/ceil,
--   center position for SPRITE, start pos for WALL_*).
--  kind: one of RK_*
--  tid: texture ID.
--  size: sprite size (for SPRITE only). Ceilings and walls always
--   have size 1.
--  y: Y position (used for SPRITE only).
--  depth: (computed) depth in clip space
--  cx,cz: (computed) position of renderable's center.
--  dcf: (computed) dot product with camera forward vector.
--  astart?: animation start time (as given by time())
--  f: flags (RF_*)

-- Global render context
R=nil
R_INIT={
 -- If TRUE, we are ready to render (all preparations done). Whenever
 -- something changes that requires us to recompute the render, we
 -- set this to FALSE.
 ready=TRUE,
 -- Camera world pos and yaw (radians, CW from North)
 -- fwx,fwz is the camera forward vector.
 cam={x=0,y=0.6,z=0,yaw=0,fwx=0,fwz=1},
 -- List of flats (ceilings and floors) (Renderable[]). 
 flats={},
 -- List of walls and sprites to render. (Renderable[]).
 mids={},
 -- Index of renderables by ID.
 rendById={},
 -- Sky color.
 skyc=0,
 -- Next renderable ID to assign
 nextId=100,
 -- Lighting setting.
 li=LIGHT_FULL,
}

-- Template for a triangle (we deep-copy this).
RTT={{x=0,y=0,z=0,u=0,v=0},{x=0,y=0,z=0,u=0,v=0},{x=0,y=0,z=0,u=0,v=0}}

-- To avoid allocation, we only use these triangle structures:
#id RTriA
RTriA=DeepCopy(RTT)
#id RTriL
RTriL={DeepCopy(RTT),DeepCopy(RTT)}
#id RVerA
#id RVerB
#id RVerC
RVerA={x=0,y=0,z=0,u=0,v=0}
RVerB=DeepCopy(RVerA)
RVerC=DeepCopy(RVerA)
RVerSprite=DeepCopy(RVerA)

-- Texture LUT. For each texture ID, this gives an object with:
--  nfr: number of animation frames
--  int: animation frame interval, in ms
--  fl: texture flags
--  tids: array of mappings from bank# to TID. Bank 1 is tids[1],
--      Bank 2 is tids[2].
#id TEXTURE_LUT

function R_Init()
 local tid,t,num,hdr
 TEXTURE_LUT={}
 X_SetPc(SYM_TextureLUT)
 k=0
 while 1 do
  ast(X_FetchB()==TLUT_HDR,"!TLUTf "..k)
  tid=X_FetchB()
  if tid==0 then break end
  t={int=250,fl=X_FetchB()}
  t.nfr=t.fl&TXF_ANIM2>0 and 2 or 1
  t.tids={}
  for i=1,2 do insert(t.tids,X_FetchW()) end
  TEXTURE_LUT[tid]=t
  k=k+1
 end
 trace("TLUT "..k)
end

-- Resets the renderer.
function R_Reset()
 R=DeepCopy(R_INIT)
end

-- Renders.
function R_Rend()
 local sea=L.lvl.flags&LVLF_SEA_BG>0
 -- Clear bottom half of screen as gray or black to mitigate glitching.
 clip(VP_X,VP_Y,VP_W,VP_H)
 cls(R.li==LIGHT_FULL and (sea and C_BLUE or C_DGRAY) or C_BLACK)
 _=sea and rect(VP_X,VP_H//2+15-(G.clk//20%5),VP_W,1,8)
 _=sea and rect(VP_X,VP_H//2+15-(G.clk//32%5),VP_W,1,8)
 clip(VP_X,VP_Y,VP_W,VP_H//2+10)
 cls(R.li~=LIGHT_FULL and 0 or R.skyc)
 clip(VP_X,VP_Y,VP_W,VP_H)
 -- cm: current palmap number.
 -- nm: needed palmap number.
 local cm,nm=PALMAP_LIT,nil
 if not R.ready then RendPrep() end
 for _,f in pairs(R.flats) do
  if f.depth<3 or f.dcf>CUTOFF_DCF then
   nm=PalMapNoForDepth(f.depth) 
   _=nm~=cm and SetPalMap(nm)
   cm=nm
   RendFlat(f)
  end
 end
 for _,m in ipairs(R.mids) do
  if m.depth<3 or m.dcf>CUTOFF_DCF then
   nm=PalMapNoForDepth(m.depth) 
   _=nm~=cm and SetPalMap(nm)
   cm=nm
   _=m.kind==RK_SPRITE and RendSprite(m) or RendWall(m)
  end
 end
 PalMapSet()
 clip()
end

function R_SetSkyColor(skyc)
 R.skyc=skyc
end

function R_SetLight(li) R.li=li end

-- Adds a floor. Returns a handle to the floor that can later
-- be used to modify it.
function R_AddFloor(x0,z0,tid,f)
 return AddRenderable({x=x0,z=z0,tid=tid,kind=RK_FLOOR,f=f or 0})
end

-- Adds a ceiling. Returns a handle to the renderable that can
-- later be used to modify it.
function R_AddCeil(x0,z0,tid,f)
 return AddRenderable({x=x0,z=z0,tid=tid,kind=RK_CEIL,f=f or 0})
end

-- Adds a wall.
--  dir: the direction of the wall (DIR_*).
-- Returns a handle to the renderable that can later be used to
-- modify it.
function R_AddWall(x0,z0,dir,tid,f)
 ast(dir>=0 and dir<=3)  -- must be a valid Dir
 return AddRenderable({x=x0,z=z0,tid=tid,kind=dir,f=f or 0})
end

-- Adds a sprite.
function R_AddSprite(x,y,z,size,tid,f)
 return AddRenderable(
   {x=x,y=y,z=z,size=size,tid=tid,kind=RK_SPRITE,f=f or 0})
end

-- Changes sprite position.
--   x,y,z: the new position (nils mean "keep existing value").
--[[
function R_SprMove(hspr,x,y,z)
 local r=R.rendById[hspr]
 oldx,oldy,oldz=r.x,r.y,r.z
 ast(r,"!spr " .. hspr)
 r.x,r.y,r.z=x or r.x,y or r.y,z or r.z
 R.ready=FALSE
end

function R_SprGetPos(hspr)
 local r=R.rendById[hspr]
 ast(r,"!spr " .. hspr)
 return r.x,r.y,r.z
end

function R_SprSetTid(hspr,tid) R.rendById[hspr].tid=tid end
]]

-- Deletes a renderable given its handle.
function R_Del(hr)
 if not hr then return end
 local r=R.rendById[hr]
 if r then
  ListRem(R.mids,r)
  ListRem(R.flats,r)
 end
 -- Removing a renderable doesn't alter the render z-sort, so
 -- we don't need to set R.ready=FALSE.
end

-- Forces the given sprite to render on top of everything from
-- now on.
--[[
function R_SprRendTop(hspr)
 local r=R.rendById[hspr]
 r.f=r.f|RF_REND_TOP
 R.ready=FALSE
end
]]

-- Returns the squared distance from the camera to the given point.
-- in world coords.
function R_DistSqToCam(x,z)
 return DistSqXz(x,z,R.cam.x,R.cam.z)
end

-- Repositions the camera.
function R_SetCamPos(x,y,z)
 R.cam.x,R.cam.y,R.cam.z=x,y,z
 R.ready=FALSE
end

-- Set camera yaw.
function R_SetCamYaw(yaw)
 R.cam.yaw=yaw
 -- Forward vector:
 R.cam.fwx,R.cam.fwz=sin(yaw),cos(yaw)
 R.ready=FALSE
end

--END OF API---------------------------------------------------------
---------------------------------------------------------------------

-- Prepares the render.
function RendPrep()
 -- Calculate the depth of all things.
 for _,r in pairs(R.flats) do RendPrepRenderable(r) end
 for _,r in pairs(R.mids) do RendPrepRenderable(r) end
 SortMids()
 R.ready=TRUE
end

function RendPrepRenderable(r)
 r.cx,r.cz=RenderableCenter(r)
 local vx,vz=Normalize(r.cx-R.cam.x,r.cz-R.cam.z)
 r.dcf=DotProd(R.cam.fwx,R.cam.fwz,vx,vz)
 r.depth=CalcDepth(r.cx,r.cz)
end

#define PALMAP_LIT 0
#define PALMAP_PENUMBRA 1
#define PALMAP_UMBRA 2

-- Returns what palette map should be used to render something
-- that's at the specified depth.
--   d: depth
function PalMapNoForDepth(d)
 return R.li==LIGHT_FULL and PALMAP_LIT or
  R.li==LIGHT_NONE and PALMAP_UMBRA or
  (d>4 and PALMAP_UMBRA or d>3 and PALMAP_PENUMBRA or PALMAP_LIT)
end

#id PALMAP_DEFS

-- Sets the palette map.
-- mapn: Map number (PALMAP_*)
function SetPalMap(mapn)
 PALMAP_DEFS=PALMAP_DEFS or {X_ReadBs(SYM_BsPalmapPenumbra,15),
   X_ReadBs(SYM_BsPalmapUmbra,15)}
 PalMapSet(mapn>0 and PALMAP_DEFS[mapn] or nil)
end

-- Renders a world space floor/ceiling tile, tesselating as needed.
function RendFlat(flr)
 local x0,z0,tid=flr.x,flr.z,ResolveTid(flr)
 local u0,v0,u1,v1=TidToUvs(tid)
 local y=flr.kind==RK_CEIL and CEIL_Y or FLOOR_Y
 -- Figure out how much to tesselate based on distance to camera.
 local distSq=R_DistSqToCam(x0+0.5,z0+0.5)
 local pcount=distSq>4 and 1 or 2
 local psize=1.0/pcount
 local ud,vd=u1-u0,v1-v0
 for r=0,pcount-1 do
  for c=0,pcount-1 do
   local xi,zi=x0+c*psize,z0+r*psize
   local xf,zf=xi+psize,zi+psize
   local ui,vi=u0+ud*c/pcount,v0+vd*r/pcount
   local uf,vf=u0+ud*(c+1)/pcount,v0+vd*(r+1)/pcount
   RendQ(
     xi,y,zi,ui,vi,
     xf,y,zi,uf,vi,
     xf,y,zf,uf,vf,
     xi,y,zf,ui,vf)
  end
 end
end

-- Renders a world space wall, tesselating as needed.
function RendWall(w)
 local dx,dz=ApplyDir(w.kind,0,0)
 local x0,z0,tid=w.x,w.z,ResolveTid(w)
 local x1,z1=x0+dx,z0+dz
 -- Note: we invert v0 and v1 to render textures the right way up.
 local u0,v1,u1,v0=TidToUvs(tid)
 -- Figure out how much to tesselate based on distance to camera.
 local distSq=R_DistSqToCam((x0+x1)/2,(z0+z1)/2)
 local pcount=distSq>4 and 1 or 2
 -- assumption: wall has length 1.
 local psize=1.0/pcount
 local ud,vd=u1-u0,v1-v0
 local y0,y1=0,1
 local xd,yd,zd=x1-x0,y1-y0,z1-z0

 for r=0,pcount-1 do
  for c=0,pcount-1 do
   local rfrac,cfrac=r/pcount,c/pcount
   local rfrac1,cfrac1=(r+1)/pcount,(c+1)/pcount
   -- X and Z vary with c (column), Y varies with r (row).
   local xi,xf=x0+cfrac*xd,x0+cfrac1*xd
   local yi,yf=y0+rfrac*yd,y0+rfrac1*yd
   local zi,zf=z0+cfrac*zd,z0+cfrac1*zd
   local ui,uf=u0+cfrac*ud,u0+cfrac1*ud
   local vi,vf=v0+rfrac*vd,v0+rfrac1*vd
   RendQ(
     xi,yi,zi,ui,vi,
     xf,yi,zf,uf,vi,
     xf,yf,zf,uf,vf,
     xi,yf,zi,ui,vf,
     w.f&RF_TRANSPARENT>0 and 0)
  end
 end
end

function RendSprite(r)
 local v=RVerSprite
 v.x,v.y,v.z,v.u,v.z=r.x,r.y,r.z,0,1
 ViewTrV(v)
 ProjV(v)
 VpTrV(v)
 if v.z<NCLIP then return end
 -- Size of sprite on viewport:
 local sz=REND_S*r.size/v.z
 local tid=ResolveTid(r)
 local u0,v0,u1,v1=TidToUvs(tid)
 -- HACK: force all texels to render (I don't know why this hack
 -- works):
 u1,v1=u1+1,v1+1
 textri(
   v.x-sz/2,v.y-sz/2,
   v.x+sz/2,v.y-sz/2,
   v.x+sz/2,v.y+sz/2,
   u0,v0,
   u1,v0,
   u1,v1,FALSE,0)
 textri(
   v.x-sz/2,v.y-sz/2,
   v.x+sz/2,v.y+sz/2,
   v.x-sz/2,v.y+sz/2,
   u0,v0,
   u1,v1,
   u0,v1,FALSE,0)
end

-- Renders a world space quad.
--   ck: color key
function RendQ(
  x1,y1,z1,u1,v1,
  x2,y2,z2,u2,v2,
  x3,y3,z3,u3,v3,
  x4,y4,z4,u4,v4,ck)
 SetT(RTriA,
  x1,y1,z1,u1,v1,
  x2,y2,z2,u2,v2,
  x3,y3,z3,u3,v3)
 RendT(RTriA,ck)
 SetT(RTriA,
  x1,y1,z1,u1,v1,
  x3,y3,z3,u3,v3,
  x4,y4,z4,u4,v4)
 RendT(RTriA,ck)
end

function SetT(t,
  x1,y1,z1,u1,v1,
  x2,y2,z2,u2,v2,
  x3,y3,z3,u3,v3)
 t[1].x,t[1].y,t[1].z,t[1].u,t[1].v=x1,y1,z1,u1,v1
 t[2].x,t[2].y,t[2].z,t[2].u,t[2].v=x2,y2,z2,u2,v2
 t[3].x,t[3].y,t[3].z,t[3].u,t[3].v=x3,y3,z3,u3,v3
end

function CopyT(d,s)
 for i=1,3 do CopyV(d[i],s[i]) end
end

function CopyV(d,s)
 d.x,d.y,d.z,d.u,d.v=s.x,s.y,s.z,s.u,s.v
end

-- Renders a world space triangle.
--   ck: color key
function RendT(t,ck)
 ViewTrT(t)
 -- t is now in clip space
 -- Clipping converts into 0, 1 or 2 triangles, writing them to RTriL
 -- and returns the # of triangles.
 local n=ClipT(t,RTriL)
 -- tris are in clip space, still
 for i=1,n do
  ProjT(RTriL[i])
  -- tri is now in eye space
  VpTrT(RTriL[i])
  -- tri is now in viewport space
  RastT(RTriL[i],ck or -1)
 end
end

-- Rotates point P about O by ang radians clockwise.
function Rot2d(px,pz,ox,oz,ang)
 local ux,uz,ca,sa=px-ox,pz-oz,cos(ang),sin(ang)
 return ox+ux*ca+uz*sa,oz+uz*ca-ux*sa
end

-- View transformation.
-- v: vertex in world space (in/out)
-- Ret: vertex in view space (clip space).
function ViewTrV(v)
 local ca=R.cam
 v.x=v.x-ca.x
 v.y=v.y-ca.y
 v.z=v.z-ca.z
 v.x,v.z=Rot2d(v.x,v.z,0,0,-ca.yaw)
end

-- View transformation (triangle).
-- tri: tri in world space (in/out).
function ViewTrT(tri)
 for i=1,3 do ViewTrV(tri[i]) end
end

-- Clips a line segment AB by the near clip plane.
-- REQUIRES that A be behind NCLIP and B be in front,
-- that is, a.z < NCLIP and b.z >= NCLIP.
-- a,b: vertices.
-- Modifies a in place.
function NClipSeg(a,b)
 ast(a.z<NCLIP and b.z>=NCLIP)
 local t=(NCLIP-a.z)/(b.z-a.z)
 a.x=a.x+t*(b.x-a.x)
 a.y=a.y+t*(b.y-a.y)
 a.z=NCLIP
 a.u=a.u+t*(b.u-a.u)
 a.v=a.v+t*(b.v-a.v)
end

-- Given a tri in clip space, clips it by NCLIP,
-- yielding 0, 1 or 2 triangles.
-- May modify tri.
-- Writes the output triangles to the out list.
-- Returns how many triangles (0, 1 or 2)
function ClipT(tri,out)
 ZSortT(tri) 
 local ah={}
 for i=1,3 do ah[i]=tri[i].z>=NCLIP end
 -- If entire tri is ahead of NCLIP, no clip needed.
 if ah[1] then
  CopyT(out[1],tri)
  return 1
 end
 -- If entire tri is behind NCLIP, draw nothing.
 if not ah[3] then return 0 end
 -- tri is part ahead, part behind NCLIP.
 if not ah[2] then
  -- Only vertex 3 is ahead of NCLIP.
  NClipSeg(tri[1],tri[3])
  NClipSeg(tri[2],tri[3])
  CopyT(out[1],tri)
  return 1
 end

 -- Vertices 2 and 3 are ahead of NCLIP, 1 behind.
 CopyV(RVerA,tri[1])
 CopyV(RVerB,tri[1])
 CopyV(RVerC,tri[2])
 NClipSeg(RVerA,tri[3])
 NClipSeg(RVerB,tri[2])
 CopyV(out[2][1],RVerA)
 CopyV(out[2][2],RVerB)
 CopyV(out[2][3],RVerC)
 NClipSeg(tri[1],tri[3])
 CopyT(out[1],tri)
 return 2
end

-- Projects a vertex from clip space to eye space.
function ProjV(v)
 v.x=REND_S*v.x/v.z
 v.y=REND_S*v.y/v.z
end

-- Projects a tri from clip space to eye space.
function ProjT(t)
 for i=1,3 do ProjV(t[i]) end
end

-- Applies viewport transformation to a vertex in eye space.
function VpTrV(v)
 v.x,v.y=VP_CX+v.x,VP_CY-v.y
end

function VpTrT(t)
 for i=1,3 do VpTrV(t[i]) end
end

-- Rasterizes a triangle
--   t: triangle
--   ck: color key to use (default -1)
function RastT(t,ck)
 textri(
   t[1].x,t[1].y,
   t[2].x,t[2].y,
   t[3].x,t[3].y,
   t[1].u,t[1].v,
   t[2].u,t[2].v,
   t[3].u,t[3].v,
   FALSE,ck or -1)
end

-- Reorder tri vertices by increasing Z.
function ZSortT(t)
 if t[2].z<t[1].z then SwapV(t,1,2) end
 if t[3].z<t[2].z then SwapV(t,2,3) end
 if t[2].z<t[1].z then SwapV(t,1,2) end
 ast(t[1].z<=t[2].z and t[2].z<=t[3].z)
end

function SwapV(t,i1,i2) t[i1],t[i2]=t[i2],t[i1] end

-- Converts a texture ID (TID) to a quadruple of spritesheet texture
-- coordinates u0,v0,u1,v1. The TID is formed by sprite ID + 1000*s
-- where s is the size of the texture in sprites. So, for example,
-- 2062 means it starts at sprite 62 and extends for 2x2 sprites,
-- (16x16 pixels).
function TidToUvs(tid)
 ast(tid>=1000,"!TID "..tid)
 local sid,size=tid%1000,(tid//1000)*8
 local u0,v0=8*(sid%16),8*(sid//16)
 return u0,v0,u0+size-1,v0+size-1
end

-- Computes the center of the renderable (x,z)
function RenderableCenter(r)
 if r.kind==RK_CEIL or r.kind==RK_FLOOR then
  return r.x+0.5,r.z+0.5
 elseif r.kind>=0 and r.kind<=3 then
  -- Wall
  local x1,z1=ApplyDir(r.kind,r.x,r.z)
  return (r.x+x1)/2,(r.z+z1)/2
 else
  -- Sprite
  return r.x,r.z
 end
end

function CalcDepth(x,z)
 x,z=x-R.cam.x,z-R.cam.z
 return sqrt(x*x+z*z)
end
 
-- Depth-sorts all walls/sprites back to front.
function SortMids()
 table.sort(R.mids,MidSortFn)
end
function MidSortFn(a,b)
 local ad=a.depth-(a.f&RF_REND_TOP)*10000
 local bd=b.depth-(b.f&RF_REND_TOP)*10000
 -- For stability (prevents z-fighting):
 if ad==bd then return a.x>b.x end
 return ad>bd
end

-- Generates a new renderable ID.
function GenRendId()
 local id=R.nextId
 R.nextId=R.nextId+1
 return id
end

-- Adds a new renderable and returns its ID.
function AddRenderable(r)
 r.id=GenRendId()
 R.rendById[r.id]=r
 if r.kind==RK_CEIL or r.kind==RK_FLOOR then
  insert(R.flats,r)
 else
  insert(R.mids,r)
 end
 R.ready=FALSE
 return r.id
end

function ResolveTid(r)
 local t,ptid,ela,fr
 t=TEXTURE_LUT[r.tid]
 ast(t,"!TLUT "..r.tid)
 -- What's the texture's TID for the currently active texture bank?
 ptid=t.tids[G.sbank]
 ast(ptid and ptid>0,"!TID "..r.tid.."@"..G.sbank)
 -- Is it animated? If so, adjust.
 if t.nfr>1 then
  ast(t.int>0,"TIN"..ptid)
  ela=time()-(r.astart or 0)
  -- Figure out frame.
  fr=floor(ela/t.int)%t.nfr
  -- Adjust ptid to take frame into account. Frame 0 is the ptid
  -- itself, ptid is the texture to the right of it, etc.
  -- Reminder: ptid//1000 is the size of the texture in 8x8 cells:
  ptid=ptid+fr*ptid//1000
 end
 return ptid
end

