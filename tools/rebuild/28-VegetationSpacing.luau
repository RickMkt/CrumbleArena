local L=workspace.CrumbleArena.Lobby
assert(not game.ServerStorage:FindFirstChild("AstraVegetationSpacing28"),"Already applied")
local backup=Instance.new("Folder") backup.Name="AstraVegetationSpacing28" backup.Parent=game.ServerStorage
local snapshot=L:Clone() snapshot.Name="LobbyBefore" snapshot.Parent=backup
local surfaces={}
for _,p in L.Architecture:GetDescendants() do if p:IsA("BasePart") and p.CanCollide then surfaces[#surfaces+1]=p end end
local rp=RaycastParams.new() rp.FilterType=Enum.RaycastFilterType.Include rp.FilterDescendantsInstances=surfaces
local log={}
local function place(m,x,z,height)
 local before=m:IsA("Model") and m:GetPivot() or m.CFrame
 local hit=workspace:Raycast(Vector3.new(x,35,z),Vector3.new(0,-90,0),rp)
 assert(hit,"No surface at "..x..","..z)
 if m:IsA("Model") then
  local _,s=m:GetBoundingBox() if height then m:ScaleTo(m:GetScale()*height/s.Y) end
  local c,size=m:GetBoundingBox()
  m:PivotTo(m:GetPivot()+Vector3.new(x-c.X,hit.Position.Y+.03+size.Y/2-c.Y,z-c.Z))
 else
  m.CFrame=CFrame.new(x,hit.Position.Y+m.Size.Y/2-.08,z)*m.CFrame.Rotation
 end
 log[#log+1]={name=m:GetFullName(),before=tostring(before),ground=hit.Instance:GetFullName(),y=hit.Position.Y}
end
local D=L.SelectedDecoration
-- Relocate crowded trees to open lawn beside the information/outlook approach.
place(D.SelectedTree_2,38,-27,11)
place(L.Vegetation.Trees.Pine_1,58,-34,16)
place(L.Vegetation.Trees.Broadleaf_1,-76,-27,13)
place(L.Vegetation.Trees.Broadleaf_3,-73,14,12)
place(D.SelectedTree_3,-24,59,11)
local shrubs={{-66,-39},{-67,-20},{32,-23},{48,-33},{-31,55},{17,60},{68,-17},{65,9}}
for i,p in shrubs do place(D["SelectedShrub_"..i],p[1],p[2],i%2==0 and 2.4 or 2.0) end
local grass={{-65,-37},{-69,-18},{-70,4},{-70,9},{29,-24},{34,-20},{45,-31},{49,-36},{-29,52},{-34,55},{15,58},{19,63},{66,-15},{70,-19},{63,7},{67,11},{-66,-32},{-68,-35},{-24,-39},{-25,-43}}
for i,p in grass do place(D["GrassAccent_"..i],p[1],p[2],i%3==0 and 1.8 or 1.4) end
place(D.StoneCluster_1,-68,-44,2.2)
place(D.StoneCluster_2,43,-29,2.2)
place(D.StoneCluster_3,-30,63,2.0)
place(D.StoneCluster_4,70,-10,2.3)
-- Open the congested front edge of the campfire clearing.
local G=L.SocialArea.RefugeGarden
place(G.bush_3,-66,25)
place(G.bush_4,-58,32)
place(G.bush_5,-40,28)
place(G.rock_3,-63,28)
place(G.rock_4,-43,32)
place(L.Rocks.IntegratedRock_5,48,-45)
place(L.Rocks.IntegratedRock_6,35,-40)
place(D.GrassAccent_1,-69,-37,1.4)
return log
