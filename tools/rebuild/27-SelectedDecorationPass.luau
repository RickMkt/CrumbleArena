local L=workspace.CrumbleArena.Lobby
local selected=workspace.CrumbleArena.AssetStaging.UserSelectedAssets.SelectedModels
assert(not L:FindFirstChild("SelectedDecoration"),"Already applied")
local backup=Instance.new("Folder") backup.Name="AstraDecorationPass27" backup.Parent=game.ServerStorage
local old=L:Clone() old.Name="LobbyBefore" old.Parent=backup
local retired=Instance.new("Folder") retired.Name="ReplacedProps" retired.Parent=backup
local root=Instance.new("Folder") root.Name="SelectedDecoration" root.Parent=L
local grounds={}
for _,p in L.Architecture:GetDescendants() do if p:IsA("BasePart") and p.CanCollide then grounds[#grounds+1]=p end end
for _,p in L.IslandOutline:GetDescendants() do if p:IsA("BasePart") and p.CanCollide then grounds[#grounds+1]=p end end
local rp=RaycastParams.new() rp.FilterType=Enum.RaycastFilterType.Include rp.FilterDescendantsInstances=grounds
local function ground(x,z)
 local hit=workspace:Raycast(Vector3.new(x,40,z),Vector3.new(0,-100,0),rp)
 assert(hit,"No ground at "..x..","..z)
 return hit.Position.Y
end
local function clone(source,name,x,z,height,yaw,y)
 local m=assert(selected:FindFirstChild(source),source):Clone() m.Name=name
 for _,p in m:GetDescendants() do
  if p:IsA("LuaSourceContainer") or p:IsA("RemoteEvent") or p:IsA("RemoteFunction") or p:IsA("PackageLink") then p:Destroy()
  elseif p:IsA("BasePart") then p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false end
 end
 local _,sz=m:GetBoundingBox() m:ScaleTo(m:GetScale()*height/sz.Y)
 m:PivotTo(CFrame.Angles(0,math.rad(yaw or 0),0))
 local cf,size=m:GetBoundingBox()
 m:PivotTo(m:GetPivot()+Vector3.new(x-cf.X,(y or ground(x,z))+.01-size.Y/-2-cf.Y,z-cf.Z))
 m:SetAttribute("IntegratedBy","Astra27") m.Parent=root return m
end
-- Two different banners attached to front columns, above circulation.
clone("Bandeira_azul","MarketBannerLeft",-58.2,-32.7,4.7,0,8.5)
clone("Bandeira_roxa","MarketBannerRight",-34.8,-32.7,5.1,0,8.1)
-- Replace selected broad crowns with narrower user-picked silhouettes.
local trees={
 {"Broadleaf_2","Arvore_B",-72,-44,13,24},
 {"Broadleaf_4","Arvore_Hapy_A",-61,34,10,105},
 {"Broadleaf_7","Arvore_Hapy_C",-24,63,12,205},
 {"Broadleaf_5","Arvore_Hapy_B",77,-10,13,310},
}
for i,e in trees do
 clone(e[2],"SelectedTree_"..i,e[3],e[4],e[5],e[6])
 local p=L.Vegetation.Trees:FindFirstChild(e[1]) if p then p.Parent=retired end
end
-- Small shrubs group around trunks/rocks, away from central paths.
for i,e in {{-69,-40,2.2,30},{-74,-24,2.7,80},{-67,33,1.8,155},{-60,38,2.3,220},{-27,61,2.0,40},{22,63,2.4,100},{73,-16,2.5,240},{72,10,2.1,300}} do
 clone("Arbusto_Hapy","SelectedShrub_"..i,e[1],e[2],e[3],e[4])
 local oldShrub=L.Vegetation.Understory:FindFirstChild("Understory_"..i) if oldShrub then oldShrub.Parent=retired end
end
for i,e in {{-68,-38},{-70,-40},{-76,-25},{-74,-26},{-66,32},{-68,34},{-61,37},{-63,39},{-26,60},{-28,63},{20,63},{22,65},{72,-17},{74,-15},{71,9},{73,12},{-62,-31},{-62,-33},{-28,-37},{-29,-39}} do
 clone("Tufo_de_grama","GrassAccent_"..i,e[1],e[2],i%3==0 and 1.4 or 1.05,(i*47)%360)
end
for i,e in {{-68,-42,2.4},{-62,36,1.8},{-27,64,2.1},{73,-13,2.6}} do
 clone("Pedras_Orze","StoneCluster_"..i,e[1],e[2],e[3],i*63)
end
-- Terrace corners, leaving the rug and counter approach open.
clone("Caixote","MarketSupplyCrate",-62.2,-29.4,2,15,3.2)
for _,n in {"YardCrate_1","YardCrate_1_Band"} do local p=L.Market.SideProps:FindFirstChild(n) if p then p.Parent=retired end end
return {added=#root:GetChildren(),rollback=backup:GetFullName()}
