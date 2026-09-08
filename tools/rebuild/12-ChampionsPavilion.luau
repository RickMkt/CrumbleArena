assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby;local I=L.Information
assert(not I:FindFirstChild("ChampionsPavilion"),"Already built")
local B=Instance.new("Folder");B.Name="BeforeChampionsPavilion";B.Parent=game.ServerStorage;I:Clone().Parent=B
local removed=Instance.new("Folder");removed.Name="ReplacedElements";removed.Parent=B
for _,name in {"ShadeRoof","RankingPost_1","RankingPost_2","RankingCap"} do I.InformationArchitecture[name].Parent=removed end
for _,d in I.RankingRefinement:GetChildren() do if not d.Name:match("Community") then d.Parent=removed end end
local F=Instance.new("Model");F.Name="ChampionsPavilion";F.Parent=I
local V=Vector3.new;local C=Color3.fromRGB;local wood=C(103,72,49);local teal=C(32,99,108);local stone=C(103,120,130);local gold=C(224,175,65);local navy=C(27,43,58)
local function p(name,size,cf,col,collide)
local a=Instance.new("Part");a.Name=name;a.Size=size;a.CFrame=cf;a.Color=col;a.Material=Enum.Material.Plastic;a.Anchored=true;a.CanCollide=collide or false;a.CanTouch=false;a.CanQuery=collide or false;a.TopSurface=Enum.SurfaceType.Studs;a.BottomSurface=Enum.SurfaceType.Smooth;a.Parent=F;return a end
for _,x in {55,70} do for _,z in {-5,23} do
p("StoneFoot",V(2.4,1.4,2.4),CFrame.new(x,2.5,z),stone,true)
p("TimberColumn",V(1.2,10.6,1.2),CFrame.new(x,8.5,z),wood,true)
p("ColumnCapital",V(1.9,.5,1.9),CFrame.new(x,14.05,z),wood)
end end
for _,x in {55,70} do p("LongBeam",V(1.1,1,30),CFrame.new(x,14.75,9),wood) end
for _,z in {-5,23} do p("CrossBeam",V(16.1,.8,1),CFrame.new(62.5,14.8,z),wood) end
local angle=math.atan2(3.2,9.5);local length=math.sqrt(9.5^2+3.2^2)
for _,side in {-1,1} do
p("RoofSlope",V(length,.6,32),CFrame.new(62.5+side*4.75,16.6,9)*CFrame.Angles(0,0,-side*angle),teal)
for _,z in {-7.2,25.2} do p("GableTrim",V(length,.8,.65),CFrame.new(62.5+side*4.75,16.58,z)*CFrame.Angles(0,0,-side*angle),wood) end
end
p("RoofRidge",V(.9,.7,32.8),CFrame.new(62.5,18.25,9),gold)
local function sign(name,value,size,cf,color,font)
local a=p(name,size,cf,color);local g=Instance.new("SurfaceGui");g.Face=Enum.NormalId.Front;g.CanvasSize=Vector2.new(1000,180);g.Parent=a
local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(.94,.9);t.Position=UDim2.fromScale(.03,.05);t.BackgroundTransparency=1;t.Font=Enum.Font.GothamBold;t.TextSize=font;t.TextColor3=C(237,225,195);t.Text=value;t.Parent=g;return a end
sign("PavilionTitle","HALL OF CHAMPIONS",V(22,1.8,.3),CFrame.new(54.3,13.25,9)*CFrame.Angles(0,math.pi/2,0),navy,66)
local original=I.Leaderboard.LeaderboardBoard
local second=original:Clone();second.Name="EliminationsBoard";second.Parent=I.Leaderboard
for i,b in {original,second} do
b.Size=V(10,8,.65);b.CFrame=CFrame.new(68.5,7.2,i==1 and -.5 or 18.5)*CFrame.Angles(0,math.pi/2,0)
local g=b.Display;g.CanvasSize=Vector2.new(700,560);g.Title.Text=i==1 and "MOST WINS" or "MOST KOs";g.Title.TextSize=52;g.Subtitle.Text="ALL TIME";g.Subtitle.TextSize=24;g.Footer.Text="PREVIEW - NO LIVE DATA";g.Footer.TextSize=20
for j=1,3 do local row=g["RankRow"..j];row.Rank.TextSize=42;row.Player.TextSize=38;row.Wins.TextSize=38 end
for _,u in {-5.3,5.3} do p("BoardUpright",V(.4,8.6,.5),b.CFrame*CFrame.new(u,0,-.1),wood) end
for _,v in {-4.3,4.3} do p("BoardCrosspiece",V(10.2,.4,.5),b.CFrame*CFrame.new(0,v,-.1),wood) end
end
local avatar=I.Leaderboard["First Place Avatar"];local delta=V(1,0,-11)
for _,d in avatar:GetDescendants() do if d:IsA("BasePart") then d.Position+=delta end end
I.Leaderboard.AvatarPedestal.Position+=delta
p("ChampionNiche",V(.6,10,6.8),CFrame.new(69,6.8,9),teal)
sign("WinnerPlaque","WINS CHAMPION",V(6,.9,.18),CFrame.new(61.9,2.5,9)*CFrame.Angles(0,math.pi/2,0),navy,65)
for _,z in {5.8,12.2} do p("NicheBorder",V(.7,10.4,.25),CFrame.new(68.55,7,z),gold) end
I:SetAttribute("RankingMetrics","Wins and KOs, visual preview only")
return "Pavilion built; existing floor and access preserved"
