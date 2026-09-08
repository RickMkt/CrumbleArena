assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local S=workspace.CrumbleArena.Lobby.SocialArea
assert(not S:FindFirstChild("CampLanterns"),"Already applied")
local M=Instance.new("Model");M.Name="CampLanterns";M.Parent=S
local function part(name,size,pos,color,material)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=CFrame.new(pos);p.Color=color;p.Material=material or Enum.Material.Wood
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=M;return p
end
local metal=Color3.fromRGB(58,47,36);local wood=Color3.fromRGB(105,69,41)
local function lantern(name,pos)
 part(name.."Base",Vector3.new(1.2,.18,1.2),pos,metal,Enum.Material.Metal)
 part(name.."Roof",Vector3.new(1.3,.24,1.3),pos+Vector3.new(0,1.65,0),metal,Enum.Material.Metal)
 local glass=part(name.."Glow",Vector3.new(.78,1.26,.78),pos+Vector3.new(0,.84,0),Color3.fromRGB(255,198,99),Enum.Material.Neon);glass.CastShadow=false
 for i,v in {Vector3.new(-.48,.82,-.48),Vector3.new(.48,.82,-.48),Vector3.new(-.48,.82,.48),Vector3.new(.48,.82,.48)} do part(name.."Frame"..i,Vector3.new(.14,1.5,.14),pos+v,metal,Enum.Material.Metal) end
 local light=Instance.new("PointLight");light.Color=Color3.fromRGB(255,195,113);light.Range=9;light.Brightness=.65;light.Shadows=false;light.Parent=glass
end
lantern("CrateLantern",Vector3.new(-53.5,5.39,29))
part("PostStoneFoot",Vector3.new(1.8,.7,1.8),Vector3.new(-39.6,.95,27),Color3.fromRGB(112,125,131),Enum.Material.Slate)
part("LanternPost",Vector3.new(.75,6.4,.75),Vector3.new(-39.6,4.5,27),wood)
part("HangingBeam",Vector3.new(2.7,.55,.6),Vector3.new(-40.5,7.3,27),wood)
part("Suspension",Vector3.new(.12,.85,.12),Vector3.new(-41.4,6.63,27),metal,Enum.Material.Metal)
lantern("HangingLantern",Vector3.new(-41.4,4.87,27))
for _,p in S.RefugeGarden:GetChildren() do if p:IsA("MeshPart") then p.TextureID="";p.Material=Enum.Material.Plastic
if p.Name:match("bush") or p.Name:match("grass") then p.Color=Color3.fromRGB(52,116,61) end end end
return {lanterns=2,lights=2,parts=18}
