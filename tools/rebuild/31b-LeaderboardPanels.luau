local I=workspace.CrumbleArena.Lobby.Information
local B=game.ServerStorage.AstraLeaderboard31
assert(not I:FindFirstChild("RankingPanels"),"Already applied")
for _,n in {"LeaderboardBoard","EliminationsBoard"} do I.Leaderboard[n].Parent=B.Retired end
for _,p in I.ChampionsPavilion:GetChildren() do
 if p.Name=="BoardUpright" or p.Name=="BoardCrosspiece" or p.Name=="ChampionNiche" or p.Name=="NicheBorder" then p.Parent=B.Retired end
end
local F=Instance.new("Model") F.Name="RankingPanels" F.Parent=I
local C=Color3.fromRGB local navy=C(26,40,54) local teal=C(32,112,121) local stone=C(112,129,140)
local function part(n,s,cf,c)
 local p=Instance.new("Part") p.Name=n p.Size=s p.CFrame=cf p.Color=c p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false p.Material=Enum.Material.SmoothPlastic p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth p.Parent=F return p
end
local function txt(g,n,t,x,y,w,h,sz,c)
 local a=Instance.new("TextLabel") a.Name=n a.Text=t a.Position=UDim2.fromScale(x,y) a.Size=UDim2.fromScale(w,h) a.BackgroundTransparency=1 a.TextColor3=c a.Font=Enum.Font.GothamBold a.TextSize=sz a.Parent=g return a
end
for i,z in {-0.5,9,18.5} do
 local center=i==2 local width=center and 8 or 8.7 local height=center and 10.2 or 9.2
 local cf=CFrame.new(68.35,2.8+height/2,z)*CFrame.Angles(0,math.pi/2,0)
 local board=part(center and "MostDonates" or i==1 and "MostWins" or "MostKOs",Vector3.new(width,height,.65),cf,navy)
 for _,x in {-width/2,width/2} do part("FrameUpright",Vector3.new(.24,height+.24,.25),cf*CFrame.new(x,0,-.46),center and teal or stone) end
 for _,y in {-height/2,height/2} do part("FrameRail",Vector3.new(width+.24,.24,.25),cf*CFrame.new(0,y,-.46),center and teal or stone) end
 part("PanelFoot",Vector3.new(width+.35,1,1.25),CFrame.new(68.15,2.3,z)*CFrame.Angles(0,math.pi/2,0),stone)
 local g=Instance.new("SurfaceGui") g.Name="Display" g.Face=Enum.NormalId.Front g.CanvasSize=Vector2.new(600,660) g.LightInfluence=0 g.Parent=board
 txt(g,"Title",center and "MOST DONATES" or i==1 and "MOST WINS" or "MOST KOs",.035,.055,.93,.14,center and 43 or 49,C(238,234,219))
 local line=Instance.new("Frame") line.Name="Divider" line.BackgroundColor3=teal line.BorderSizePixel=0 line.Position=UDim2.fromScale(.08,.22) line.Size=UDim2.fromScale(.84,.008) line.Parent=g
 if not center then
  for j=1,3 do
   local row=Instance.new("Frame") row.Name="RankRow"..j row.BackgroundColor3=C(43,59,76) row.BorderSizePixel=0 row.Position=UDim2.fromScale(.065,.30+(j-1)*.20) row.Size=UDim2.fromScale(.87,.16) row.Parent=g
   txt(row,"Rank",string.format("%02d",j),.02,0,.18,1,47,C(232,185,75))
   local name=txt(row,"Player","--",.25,0,.7,1,43,C(228,232,235)) name.TextXAlignment=Enum.TextXAlignment.Left
  end
 end
 board:SetAttribute("DataStatus","VISUAL_PREVIEW_NO_LIVE_DATA")
end
I:SetAttribute("RankingMetrics","Wins; Donates avatar only; KOs. Visual preview, no transactions.")
return "Three panels aligned; ranking placeholders only"
