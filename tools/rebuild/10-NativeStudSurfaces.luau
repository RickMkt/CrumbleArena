-- Edit-only native surface pass. Does not claim texture coverage on meshes.
assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby
assert(game.ServerStorage:FindFirstChild("MarketRefinementRollback_1121"),"Missing rollback")
local changed,faces=0,0
for _,p in L:GetDescendants() do
 if p.ClassName=="Part" and p.Shape==Enum.PartType.Block and p.Transparency==0 and p.Material~=Enum.Material.Neon and not p:FindFirstChildOfClass("SpecialMesh") then
  local ancestor=p.Parent;local character=false
  while ancestor and ancestor~=L do
   if ancestor:FindFirstChildOfClass("Humanoid") then character=true;break end
   ancestor=ancestor.Parent
  end
  if not character then
   local any=false
   for _,face in {"Top","Bottom","Front","Back","Left","Right"} do
    local obscured=false
    for _,d in p:GetChildren() do
     if (d:IsA("SurfaceGui") or d:IsA("Decal")) and d.Face.Name==face then obscured=true end
    end
    if not obscured and p[face.."Surface"]~=Enum.SurfaceType.Studs then
     p[face.."Surface"]=Enum.SurfaceType.Studs;faces+=1;any=true
    end
   end
   p.Material=Enum.Material.Plastic
   if any then changed+=1 end
  end
 end
end
L:SetAttribute("NativeStudPass","Block Parts only; meshes, characters, light emitters and text faces excluded")
return {changedParts=changed,changedFaces=faces}
