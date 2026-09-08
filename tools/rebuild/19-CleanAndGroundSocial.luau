assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby;local S=L.SocialArea
assert(not game.ServerStorage:FindFirstChild("AstraSocialCleanupRollback"),"Already applied")
local R=Instance.new("Folder");R.Name="AstraSocialCleanupRollback";R.Parent=game.ServerStorage
local snapshot=S:Clone();snapshot.Name="SocialBefore";snapshot.Parent=R
local removed=Instance.new("Folder");removed.Name="ExcessGarden";removed.Parent=R
local keep={bush_3=true,bush_4=true,bush_5=true,rock_2=true,rock_3=true,rock_4=true}
local count=0;for _,p in S.RefugeGarden:GetChildren() do if not keep[p.Name] then p.Parent=removed;count+=1 end end
local fire=S.CreatorStore_Campfire_User
for _,p in fire:GetDescendants() do if p:IsA("BasePart") then p.Position-=Vector3.new(0,1.157,0) end end
local function bottom(p)
 local low=math.huge
 for _,x in {-1,1} do for _,y in {-1,1} do for _,z in {-1,1} do low=math.min(low,p.CFrame:PointToWorldSpace(p.Size*Vector3.new(x,y,z)*.5).Y) end end end
 return low
end
local changes={}
for _,p in fire.RockRing:GetChildren() do if p:IsA("BasePart") then
local b=bottom(p);p.Position+=Vector3.new(0,.52-b,0);p.CanCollide=false;p.CanTouch=false
changes[#changes+1]={name=p.Name,oldBottom=b,newBottom=bottom(p)}
end end
-- Keep ornamental shrubs behind seating, not on the usable clearing.
local locations={bush_3=Vector3.new(-65,0,30),bush_4=Vector3.new(-55,0,34.5),bush_5=Vector3.new(-43,0,33)}
local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Include;rp.FilterDescendantsInstances={L.Architecture}
for name,pos in locations do local p=S.RefugeGarden[name];local hit=workspace:Raycast(pos+Vector3.new(0,30,0),Vector3.new(0,-60,0),rp);assert(hit);p.Position=Vector3.new(pos.X,hit.Position.Y+p.Size.Y/2-.15,pos.Z) end
return {removed=count,rockContacts=changes}
