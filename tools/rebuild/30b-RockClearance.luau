local L=workspace.CrumbleArena.Lobby
for _,v in {{1,-78,-34,1.6},{4,-75,22,1.28},{8,77,3,.96},{9,73,-23,.64},{14,-19,-65,1.28},{16,-57,-52,.8}} do
 local p=L.Rocks["IntegratedRock_"..v[1]]
 p.CFrame=CFrame.new(v[2],v[4],v[3])*p.CFrame.Rotation
end
return "Clearance refinement applied"
