assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby
local F=L.CentralPlaza.Floor
assert(not F:FindFirstChild("SE_RecessedLanding"),"Already applied")
local store=game.ServerStorage.AstraPhase1Takeover
local rollback=Instance.new("Folder");rollback.Name="Stage4_SE_OriginalCorner";rollback.Parent=store
local base=F.PlazaFoundation.Face2_2;local surface=F.PlazaPaving.Face2_2
local model=Instance.new("Model");model.Name="SE_RecessedLanding";model.Parent=F
local function piece(source,name,center,height,legs)
local p=source:Clone();p.Name=name;p.Size=Vector3.new(height,legs,legs)
p.CFrame=CFrame.new(center)*source.CFrame.Rotation
p.Anchored=true;p.CanCollide=true;p.CanTouch=false;p.CanQuery=true;p.CastShadow=true
for _,face in {"Top","Bottom","Left","Right","Front","Back"} do p[face.."Surface"]=Enum.SurfaceType.Smooth end
if name:match("Paving") then p.RightSurface=Enum.SurfaceType.Studs end
p.Parent=model;return p
end
piece(base,"LandingFoundation",Vector3.new(17,.3,-13),.6,10)
piece(surface,"LandingPaving",Vector3.new(17,.9,-13),.6,10)
piece(base,"RecessedFoundation",Vector3.new(15,1.5,-11),.6,6)
piece(surface,"RecessedPaving",Vector3.new(15,2.1,-11),.6,6)
base.Parent=rollback;surface.Parent=rollback
model:SetAttribute("Intent","Replace SE corner with recessed upper floor and one integrated landing; no overlay")
return {replaced=2,new=4,landingTop=1.2,plazaTop=2.4,recessionDiagonal=2.828427,rollback=rollback:GetFullName()}
