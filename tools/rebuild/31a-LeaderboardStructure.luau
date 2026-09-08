local L=workspace.CrumbleArena.Lobby local I=L.Information
assert(not game:GetService("RunService"):IsRunning(),"Edit required")
assert(not game.ServerStorage:FindFirstChild("AstraLeaderboard31"),"Already applied")
local B=Instance.new("Folder") B.Name="AstraLeaderboard31" B.Parent=game.ServerStorage
local snap=L:Clone() snap.Name="LobbyBefore" snap.Parent=B
local retired=Instance.new("Folder") retired.Name="Retired" retired.Parent=B
local P=I.ChampionsPavilion
for _,p in P:GetChildren() do
 if p.Name=="PavilionTitle" or p.Name=="WinnerPlaque" then p.Parent=retired
 elseif p:IsA("BasePart") then
  if p.Name=="TimberColumn" then p.Size-=Vector3.new(0,.8,0) p.Position-=Vector3.new(0,.4,0)
  elseif p.Name=="LongBeam" or p.Name=="CrossBeam" or p.Name=="ColumnCapital" or p.Name=="RoofSlope" or p.Name=="GableTrim" or p.Name=="RoofRidge" then p.Position-=Vector3.new(0,.8,0) end
  if p.Name=="RoofRidge" then p.Color=Color3.fromRGB(29,100,110) end
  if p.Name=="TimberColumn" or p.Name=="LongBeam" or p.Name=="CrossBeam" or p.Name=="ColumnCapital" then p.TopSurface=Enum.SurfaceType.Smooth end
 end
end
I.EventBoard.Parent=retired
I.RankingRefinement.Parent=retired
for _,p in L.Architecture.Paths.InformationTerrace:GetDescendants() do
 if p:IsA("BasePart") then p.Color=Color3.fromRGB(132,145,151) end
end
for _,p in I.InformationArchitecture:GetChildren() do
 if p:IsA("BasePart") then p.Color=Color3.fromRGB(99,117,129) end
end
return "Structure refined; access geometry unchanged"
