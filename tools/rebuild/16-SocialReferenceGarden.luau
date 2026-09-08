assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby
assert(not L.SocialArea:FindFirstChild("RefugeGarden"),"Already applied")
local R=Instance.new("Folder");R.Name="AstraSocialReferenceRollback";R.Parent=game.ServerStorage
local snap=L:Clone();snap.Name="LobbyBefore";snap.Parent=R
local garden=Instance.new("Model");garden.Name="RefugeGarden";garden.Parent=L.SocialArea
local sources={}
for _,p in game.ServerStorage.CrumbleArenaLibraries:GetDescendants() do if p:IsA("MeshPart") then
 for name,id in {bush="120362304717138",grass="91291478360434",rock="117365476866296"} do if p.MeshId:match(id) then assert(#p:GetDescendants()==0,"Source requires audit");sources[name]=p end end end end
assert(sources.bush and sources.grass and sources.rock)
local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Include;rp.FilterDescendantsInstances={L.Architecture}
local function ground(x,z)local hit=workspace:Raycast(Vector3.new(x,40,z),Vector3.new(0,-80,0),rp);assert(hit,"No ground");return hit.Position.Y end
local corrected={}
for _,folder in {L.Vegetation.Understory,L.Vegetation.GrassClumps} do for _,p in folder:GetChildren() do if p:IsA("BasePart") then
 local y=ground(p.Position.X,p.Position.Z)+p.Size.Y/2-.12
 if math.abs(y-p.Position.Y)>.3 then corrected[#corrected+1]={name=p:GetFullName(),oldY=p.Position.Y,newY=y};p.Position=Vector3.new(p.Position.X,y,p.Position.Z) end
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
end end end
local counts={bush=0,grass=0,rock=0}
local function plant(kind,x,z,size,angle)
 local p=sources[kind]:Clone();counts[kind]+=1;p.Name=kind.."_"..counts[kind]
 p.Size=size;p.CFrame=CFrame.new(x,ground(x,z)+size.Y*.5-(kind=="rock" and .25 or .12),z)*CFrame.Angles(0,math.rad(angle),0)
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 p.CastShadow=kind~="grass";p.Color=kind=="rock" and Color3.fromRGB(121,132,139) or Color3.fromRGB(48,113,59)
 p:SetAttribute("SourceAssetId","111025409160294");p:SetAttribute("License","CC0");p.Parent=garden;return p
end
for _,v in {{-66,13,3.5,3,2.9,25},{-67,22,4.4,3.5,3.7,100},{-63,29,3.1,2.5,2.8,180},{-55,32,4.2,3.4,3.5,70},{-45,31,3.5,2.8,3.2,15},{-38,25,3.6,2.7,3.1,140},{-58,3,3,2.4,2.8,95},{-41,1,2.8,2.3,2.5,35}} do plant("bush",v[1],v[2],Vector3.new(v[3],v[4],v[5]),v[6]) end
for _,v in {{-65,10,3.2,2.1,2.7,30},{-67,18,2.5,2.6,2.5,120},{-61,31,3,1.8,2.6,90},{-46,32,2.6,1.7,2.3,160},{-38.8,22,2.5,1.5,2,0},{-56,2.5,3.3,.8,2.6,50}} do plant("rock",v[1],v[2],Vector3.new(v[3],v[4],v[5]),v[6]) end
for i,v in {{-64.5,10.5},{-66,15.5},{-67,24.5},{-63,30.5},{-58,32},{-52,32},{-43,30.5},{-39,27},{-37.6,23},{-58.5,2},{-55,1.5},{-42,1}} do plant("grass",v[1],v[2],Vector3.new(1.3,1.9+(i%3)*.25,.75),i*39) end
return {new=counts,corrected=corrected}
