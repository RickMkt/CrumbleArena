assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby
assert(not game.ServerStorage:FindFirstChild("AstraSocialRefinement_20260906"),"Already started")
local R=Instance.new("Folder");R.Name="AstraSocialRefinement_20260906";R.Parent=game.ServerStorage
local snapshot=L:Clone();snapshot.Name="LobbyBefore";snapshot.Parent=R
local rejected=Instance.new("Folder");rejected.Name="OverlappingClearingEdges";rejected.Parent=R
for _,name in {"SW_TerraTransborda","SE_CantoSome"} do
 local f=L.SocialArea.ClearingEdge:FindFirstChild(name);assert(f,name);f.Parent=rejected
end
return {removedFromWorld=11,rollback=R:GetFullName()}
