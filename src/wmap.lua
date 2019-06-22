-- World map

function WM_DrawWorldMap()
 cls(0)
 local p,c,t=SYM_TileWMapColors,{}
 -- Read the look-up table from tile ID to color.
 while XP[p]>0 do c[XP[p]]=XP[p+1] p=p+2 end
 for x=0,179 do
  for y=0,135 do
   t=mget(x,y)
   pix(x,y,c[t] or C_GRAY)
  end
 end
 -- Overlay XL-drawn stuff
 X_Call(SYM_WMAP_DrawFrame)
 DecoRect(0,0,180,136)
end

