local L=workspace.CrumbleArena.Lobby
assert(not game.ServerStorage:FindFirstChild("AstraVegetationHarmony29"),"Already applied")
local backup=Instance.new("Folder") backup.Name="AstraVegetationHarmony29" backup.Parent=game.ServerStorage
local snap=L:Clone() snap.Name="LobbyBefore" snap.Parent=backup
local D=L.SelectedDecoration
local colors={Color3.fromRGB(51,119,72),Color3.fromRGB(58,132,79),Color3.fromRGB(47,115,70),Color3.fromRGB(61,130,78)}
for i=1,4 do
 for _,p in D["SelectedTree_"..i]:GetDescendants() do
  if p:IsA("BasePart") then
   if p.Name=="Grass" or p.Name:find("Sphere") then
    p.Color=colors[i] p.Material=Enum.Material.SmoothPlastic p.Reflectance=0
   elseif p.Name=="Branch" or p.Name:find("Cylinder") then p.Color=Color3.fromRGB(107,77,51) end
  end
 end
end
local rp=RaycastParams.new() rp.FilterType=Enum.RaycastFilterType.Include
rp.FilterDescendantsInstances={L.Architecture.IslandFoundation,L.Architecture.NaturalTerraces}
local function plant(m,x,z,height)
 local hit=workspace:Raycast(Vector3.new(x,25,z),Vector3.new(0,-50,0),rp)
 assert(hit,"Missing natural ground")
 if m:IsA("Model") then
  local _,s=m:GetBoundingBox() if height then m:ScaleTo(m:GetScale()*height/s.Y) end
  local c,size=m:GetBoundingBox() m:PivotTo(m:GetPivot()+Vector3.new(x-c.X,hit.Position.Y+size.Y/2-.04-c.Y,z-c.Z))
 else
  if height then m.Size=m.Size*(height/m.Size.Y) end
  m.CFrame=CFrame.new(x,hit.Position.Y+m.Size.Y/2-.09,z)*m.CFrame.Rotation
 end
end
local G=L.SocialArea.RefugeGarden
plant(G.bush_3,-69,22,2.1)
plant(G.bush_4,-58,39,2.4)
plant(G.bush_5,-35,29,2.1)
for _,p in G:GetChildren() do if p:IsA("BasePart") and p.Name:find("bush") then p.Color=Color3.fromRGB(62,124,74) p.CanCollide=false p.CanTouch=false p.CanQuery=false end end
plant(D.SelectedShrub_3,30,-27,1.9)
plant(D.SelectedShrub_4,47,-37,2.1)
plant(D.SelectedShrub_8,74,3,2.0)
plant(D.GrassAccent_15,71,1,1.4)
plant(D.GrassAccent_16,75,6,1.6)
local points={{-70,25},{-66,21},{-58,41},{-54,39},{-35,33},{-33,28},{-70,-11},{-65,-15},{33,-31},{44,-22},{54,-40},{63,-30}}
for i,p in points do
 local m=D.GrassAccent_1:Clone() m.Name="GrassHarmony_"..i
 plant(m,p[1],p[2],i%3==0 and 1.55 or 1.25)
 m.Parent=D
end
for _,m in D:GetChildren() do
 if m.Name:find("Grass") or m.Name:find("SelectedShrub") then
  for _,p in m:GetDescendants() do if p:IsA("BasePart") then
   p.Color=m.Name:find("Grass") and Color3.fromRGB(92,146,69) or Color3.fromRGB(53,112,65)
   p.Reflectance=0 p.CanCollide=false p.CanTouch=false p.CanQuery=false
  end end
 end
end
return "Four tree palettes harmonized; camp shrubs grounded outside furniture; twelve subtle grass accents"
