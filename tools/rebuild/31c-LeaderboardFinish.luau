local I=workspace.CrumbleArena.Lobby.Information local B=game.ServerStorage.AstraLeaderboard31
assert(not I:FindFirstChild("RankingFinish"),"Already applied")
local F=Instance.new("Model") F.Name="RankingFinish" F.Parent=I
local C=Color3.fromRGB
local function p(n,s,pos,c,mat)
 local a=Instance.new("Part") a.Name=n a.Size=s a.Position=pos a.Color=c a.Material=mat or Enum.Material.SmoothPlastic a.Anchored=true a.CanCollide=false a.CanTouch=false a.CanQuery=false a.TopSurface=Enum.SurfaceType.Smooth a.BottomSurface=Enum.SurfaceType.Smooth a.Parent=F return a
end
local A=I.Leaderboard["First Place Avatar"]
for _,v in A:GetDescendants() do if v:IsA("BillboardGui") then v.Enabled=false end end
I.Leaderboard.AvatarPedestal.Color=C(85,106,119)
for _,v in A.Pedestal:GetChildren() do
 if v:IsA("BasePart") then v.Color=v.Name=="PedestalPiece_3" and C(41,168,180) or C(29,67,80) v.Material=Enum.Material.SmoothPlastic end
end
local lip=p("PedestalTealLip",Vector3.new(.09,.10,3.4),Vector3.new(63.79,3.82,9.025),C(63,199,207),Enum.Material.Neon)
for _,b in I.RankingPanels:GetChildren() do if b:FindFirstChild("Display") then
 local g=b.Display
 g.Title.TextSize=b.Name=="MostDonates" and 56 or 64
 local bg=Instance.new("Frame") bg.Name="NavyBackground" bg.Size=UDim2.fromScale(1,1) bg.BackgroundColor3=C(26,40,54) bg.BorderSizePixel=0 bg.ZIndex=0 bg.Parent=g
 for _,t in g:GetDescendants() do if t:IsA("TextLabel") and t.Name=="Rank" then t.TextSize=57 end end
end end
for _,z in {-2.5,20.5} do
 local x,y=59,11.9
 p("LanternHanger",Vector3.new(.16,1.1,.16),Vector3.new(x,y+1.1,z),C(55,50,42))
 p("LanternCap",Vector3.new(1.15,.18,1.15),Vector3.new(x,y+.55,z),C(61,51,39))
 p("LanternBase",Vector3.new(1.15,.18,1.15),Vector3.new(x,y-.55,z),C(61,51,39))
 local core=p("LanternGlow",Vector3.new(.72,.9,.72),Vector3.new(x,y,z),C(255,215,141),Enum.Material.Neon)
 for _,dx in {-.46,.46} do for _,dz in {-.46,.46} do p("LanternCorner",Vector3.new(.12,1,.12),Vector3.new(x+dx,y,z+dz),C(61,51,39)) end end
 local light=Instance.new("PointLight") light.Color=C(255,227,184) light.Brightness=1.3 light.Range=18 light.Shadows=false light.Parent=core
end
for _,v in {{64.8,3.3,5.9,1.2,3,1.1},{64.65,2.45,12.15,1.6,1.3,1.1},{64.85,3.8,12.35,1.15,1.35,1.05}} do
 local a=p("FracturedStone",Vector3.new(v[4],v[5],v[6]),Vector3.new(v[1],v[2],v[3]),C(115,132,143))
 a.Orientation=Vector3.new(0,0,0) a.TopSurface=Enum.SurfaceType.Studs
end
return "Single donor avatar retained; two lanterns and restrained stone details"
