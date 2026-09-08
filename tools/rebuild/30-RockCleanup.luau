local L=workspace.CrumbleArena.Lobby
assert(not game:GetService("RunService"):IsRunning(),"Edit required")
assert(not game.ServerStorage:FindFirstChild("AstraRockCleanup30"),"Already applied")
local backup=Instance.new("Folder") backup.Name="AstraRockCleanup30" backup.Parent=game.ServerStorage
local snap=L:Clone() snap.Name="LobbyBefore" snap.Parent=backup
local rp=RaycastParams.new() rp.FilterType=Enum.RaycastFilterType.Include
rp.FilterDescendantsInstances={L.Architecture.IslandFoundation,L.Architecture.NaturalTerraces}
local changes={{1,-79,-35,5},{2,-72,-22,2.6},{3,-64,-51,3.2},{4,-77,24,4},{7,76,-23,4.5},{8,77,13,3},{9,72,9,2},{14,-19,-71,4},{16,-56,-49,2.5},{6,35,-40,2.6}}
local log={}
for _,v in changes do
 local p=L.Rocks["IntegratedRock_"..v[1]]
 local old={position=tostring(p.Position),size=tostring(p.Size),rotation=tostring(p.Orientation)}
 local hit=workspace:Raycast(Vector3.new(v[2],25,v[3]),Vector3.new(0,-50,0),rp)
 assert(hit,"No ground")
 p.Size=p.Size*(v[4]/p.Size.Y)
 p.CFrame=CFrame.new(v[2],hit.Position.Y+p.Size.Y/2-math.max(.35,p.Size.Y*.18),v[3])*p.CFrame.Rotation
 p.Anchored=true
 table.insert(log,{name=p.Name,before=old,after={position=tostring(p.Position),size=tostring(p.Size),rotation=tostring(p.Orientation)},collide=p.CanCollide,touch=p.CanTouch,query=p.CanQuery})
end
local record=Instance.new("StringValue") record.Name="ChangeLog" record.Value=game:GetService("HttpService"):JSONEncode(log) record.Parent=backup
return record.Value
