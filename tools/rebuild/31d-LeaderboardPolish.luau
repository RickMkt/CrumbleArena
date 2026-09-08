local I=workspace.CrumbleArena.Lobby.Information
for _,v in I.Leaderboard["First Place Avatar"].Pedestal:GetDescendants() do
 if v:IsA("Decal") then v.Parent=game.ServerStorage.AstraLeaderboard31.Retired end
end
for _,v in I.RankingFinish:GetDescendants() do if v:IsA("PointLight") then v.Brightness=.85 end end
return "Old gold pedestal decals archived; softer light"
