local L=workspace.CrumbleArena.Lobby
local I=L.Information
assert(not game:GetService("RunService"):IsRunning(),"Edit only")
assert(not I:FindFirstChild("RankingRefinement"),"Already refined")
local backup=Instance.new("Folder");backup.Name="LeaderboardBeforeRefinement";backup.Parent=game.ServerStorage;I:Clone().Parent=backup
local F=Instance.new("Folder");F.Name="RankingRefinement";F.Parent=I
local C=Color3.fromRGB
local navy=C(27,43,58);local teal=C(36,115,120);local cream=C(237,225,195);local gold=C(224,175,65)
local board=I.Leaderboard.LeaderboardBoard
board.Color=navy
local g=board.Display
for _,d in g:GetChildren() do d:Destroy() end
g.CanvasSize=Vector2.new(1000,500);g.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize
local function text(parent,name,value,x,y,w,h,size,col)
local t=Instance.new("TextLabel");t.Name=name;t.BackgroundTransparency=1;t.Position=UDim2.fromScale(x,y);t.Size=UDim2.fromScale(w,h);t.Text=value;t.TextSize=size;t.Font=Enum.Font.GothamBold;t.TextColor3=col;t.TextWrapped=false;t.Parent=parent;return t end
text(g,"Title","TOP PLAYERS",.05,.035,.9,.14,68,cream)
text(g,"Subtitle","CRUMBLE ARENA",.05,.18,.9,.07,26,gold)
for i,col in {gold,C(173,198,208),C(192,134,94)} do
local row=Instance.new("Frame");row.Name="RankRow"..i;row.Position=UDim2.fromScale(.055,.29+(i-1)*.18);row.Size=UDim2.fromScale(.89,.15);row.BackgroundColor3=C(40+i*3,58+i*3,74+i*3);row.BorderSizePixel=0;row.Parent=g
text(row,"Rank",string.format("%02d",i),.025,0,.12,1,52,col)
local name=text(row,"Player","---",.19,0,.53,1,48,cream);name.TextXAlignment=Enum.TextXAlignment.Left
text(row,"Wins","--",.77,0,.19,1,48,cream)
end
text(g,"Footer","RANKING PREVIEW  /  WINS",.05,.86,.9,.09,20,C(166,187,195))
local function part(name,size,cf,col)
local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Color=col;p.Material=Enum.Material.Plastic;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.TopSurface=Enum.SurfaceType.Studs;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=F;return p end
for _,x in {-8.8,8.8} do part("BoardSideTrim",Vector3.new(.35,9.1,.4),board.CFrame*CFrame.new(x,0,-.12),teal) end
for _,y in {-4.55,4.55} do part("BoardHorizontalTrim",Vector3.new(17.95,.35,.4),board.CFrame*CFrame.new(0,y,-.12),teal) end
I.InformationArchitecture.ShadeRoof.Color=teal
I.InformationArchitecture.RankingCap.Color=C(93,66,46)
I.InformationArchitecture.RearStoneWall.Color=C(91,111,125)
I.InformationArchitecture.LowReturnWall.Color=C(91,111,125)
local pedestal=I.Leaderboard.AvatarPedestal;pedestal.Color=navy
part("ChampionBackdrop",Vector3.new(.45,8.7,6.6),CFrame.new(67.4,6.15,20),teal)
local badge=part("ChampionPlaque",Vector3.new(5.4,.8,.16),CFrame.new(60.91,2.4,20)*CFrame.Angles(0,math.pi/2,0),navy)
local bg=Instance.new("SurfaceGui");bg.Face=Enum.NormalId.Front;bg.CanvasSize=Vector2.new(600,100);bg.Parent=badge
text(bg,"Title","1ST PLACE",.02,.03,.96,.94,52,gold)
local event=I.EventBoard.EventBoard
event.Color=navy;event.Display.Label.Text="COMMUNITY\nEVENTS SOON";event.Display.Label.TextSize=44
for _,x in {-6.25,6.25} do part("CommunityTrim",Vector3.new(.3,5.4,.3),event.CFrame*CFrame.new(x,0,-.12),teal) end
return "Leaderboard visual refinement applied; no runtime or screen GUI changes"
