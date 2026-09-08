-- Market refinement. Edit only. Requires the saved Claude stall and rollback.
local L=workspace.CrumbleArena.Lobby
local M=L.Market
assert(game.ServerStorage:FindFirstChild("MarketRefinementRollback_1121"),"Missing rollback")
if M:GetAttribute("AstraRefinementV1") then return "Already applied" end
local V=Vector3.new
local C=Color3.fromRGB
local teal=C(30,112,120)
local navy=C(34,49,62)
local cream=C(231,216,181)
local wood=C(111,77,51)
local gold=C(204,153,66)
local function part(parent,name,size,cf,col,shape)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Color=col
 p.Material=Enum.Material.Plastic;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.CastShadow=false
 if shape then p.Shape=shape end;p.Parent=parent;return p
end
local function label(p,text,size)
 local g=p:FindFirstChildOfClass("SurfaceGui") or Instance.new("SurfaceGui");g.Name="Display";g.Face=Enum.NormalId.Front;g.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize;g.CanvasSize=Vector2.new(600,180);g.Parent=p
 g:ClearAllChildren();local t=Instance.new("TextLabel");t.Name="Label";t.BackgroundTransparency=1;t.Position=UDim2.fromScale(.05,.07);t.Size=UDim2.fromScale(.90,.86);t.Font=Enum.Font.GothamBold;t.TextSize=size;t.TextColor3=cream;t.Text=text;t.TextWrapped=true;t.Parent=g
end
local retained={}
for _,name in {"Gamepass_VIP","Gamepass_Coins"} do retained[name]=M:FindFirstChild(name,true):Clone() end
M.PassBoards:Destroy()
M.ServicePad:Destroy()
for _,p in M.Frame:GetChildren() do
 if p:IsA("BasePart") then
  if p.Name:match("BackCourse") then p.Color=C(119,88,63)
  elseif p.Name:match("TimberPost") or p.Name:match("Beam") then p.Color=wood end
 end
end
for _,p in M.Awning:GetChildren() do if p:IsA("BasePart") then
 p.Position+=V(0,.7,0)
 if p.Name:match("Stripe") or p.Name:match("Tab") then local i=tonumber(p.Name:match("(%d+)$"));p.Color=(i%2==0) and cream or teal end
 if p.Name:match("Tab") then p.Size=V(p.Size.X,.55,p.Size.Z);p.Position=V(p.Position.X,11.08,p.Position.Z) end
end end
M.Frame.FrontBeam.Position+=V(0,.7,0)
for _,p in M.Frame:GetChildren() do if p:IsA("BasePart") and (p.Name:match("Lantern") or p.Name:match("Brace")) then p.Position+=V(0,.7,0) end end
for _,p in M.Counter:GetChildren() do if p:IsA("BasePart") then
 if p.Name:match("Stripe") then p.Color=teal;p.FrontSurface=Enum.SurfaceType.Studs;p.BackSurface=Enum.SurfaceType.Studs
 elseif p.Name=="CounterBody" then p.Color=wood
 elseif p.Name=="CounterTop" or p.Name=="CounterLip" then p.Color=C(172,134,89);p.TopSurface=Enum.SurfaceType.Studs end
end end
local sign=M.Signage.MarketSign;sign.Color=teal;label(sign,"PIP'S MARKET",60)
sign.Display.Label.TextWrapped=false
M.Signage.SignTrimTop.Color=wood;M.Signage.SignTrimBottom.Color=wood;M.Signage.SignBacking.Color=wood
for i,name in {"Gamepass_VIP","Gamepass_Coins"} do
 local x=i==1 and -55.0 or -38.0
 local backing=part(M.Signage,name.."_Frame",V(4.7,2.65,.35),CFrame.new(x,8.25,-34.15),wood)
 local p=retained[name];p.Size=V(4.3,2.25,.18);p.CFrame=CFrame.new(x,8.25,-33.87)*CFrame.Angles(0,math.pi,0);p.Color=navy;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Parent=M.Signage;label(p,i==1 and "VIP\nCOMING SOON" or "2X COINS\nCOMING SOON",48)
 part(M.Signage,name.."_Hanger",V(.16,1.5,.18),CFrame.new(x,10.3,-34.15),wood)
end
for _,p in M.DisplayGoods:GetChildren() do if p.Name:match("ShelfBox") then p:Destroy() end end
-- Three grouped supplies replace a uniform rainbow row.
for i,t in {{-54,7.8,-43,1.2,1.2,1.2},{-52.4,8,-43,1.3,1.6,1.1},{-39.2,7.75,-43,1.6,1.1,1.2}} do
 local p=part(M.DisplayGoods,"SupplyCase_"..i,V(t[4],t[5],t[6]),CFrame.new(t[1],t[2],t[3]),i==2 and gold or teal);p.TopSurface=Enum.SurfaceType.Studs
end
-- PIP: authored expedition shopkeeper, retaining the existing native rig and smile.
local S=M.Shopkeeper
if S:FindFirstChild("Outfit") then S.Outfit:Destroy() end
local outfit=Instance.new("Folder");outfit.Name="Outfit";outfit.Parent=S
local skin=C(229,179,137)
for _,p in S:GetChildren() do if p:IsA("BasePart") then
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 if p.Name=="Head" or p.Name:match("Hand") then p.Color=skin
 elseif p.Name:match("Foot") then p.Color=C(58,43,34)
 elseif p.Name:match("Leg") or p.Name=="LowerTorso" then p.Color=C(71,76,81)
 else p.Color=teal end
end end
local bc=S:FindFirstChildOfClass("BodyColors");if bc then bc.HeadColor3=skin;bc.LeftArmColor3=teal;bc.RightArmColor3=teal;bc.TorsoColor3=teal;bc.LeftLegColor3=C(71,76,81);bc.RightLegColor3=C(71,76,81) end
local h=S.Head.CFrame
part(outfit,"HairBack",V(1.24,.62,.32),h*CFrame.new(0,.28,.49),C(67,45,32))
for i,x in {-0.42,0,.42} do
 part(outfit,"HairLock_"..i,V(.48,.20,.24),h*CFrame.new(x,.53,-.48)*CFrame.Angles(0,0,math.rad(i*7-14)),C(67,45,32))
end
part(outfit,"ExplorerBrim",V(.13,1.95,1.65),h*CFrame.new(0,.64,0)*CFrame.Angles(0,0,math.pi/2),cream,Enum.PartType.Cylinder)
part(outfit,"ExplorerCrown",V(.5,1.34,1.30),h*CFrame.new(0,.93,0)*CFrame.Angles(0,0,math.pi/2),C(170,126,74),Enum.PartType.Cylinder)
part(outfit,"HatBand",V(.14,1.40,1.36),h*CFrame.new(0,.75,0)*CFrame.Angles(0,0,math.pi/2),wood,Enum.PartType.Cylinder)
for i,x in {-.34,.34} do
 part(outfit,"GoggleRim_"..i,V(.55,.45,.13),h*CFrame.new(x,.9,-.63),wood)
 part(outfit,"GoggleLens_"..i,V(.39,.29,.05),h*CFrame.new(x,.9,-.73),C(90,191,202))
end
part(outfit,"GoggleBridge",V(.18,.08,.08),h*CFrame.new(0,.9,-.72),gold)
local torso=S.UpperTorso.CFrame
part(outfit,"Undershirt",V(.60,1.32,.08),torso*CFrame.new(0,-.08,-.54),cream)
for i,x in {-.62,.62} do
 part(outfit,"JacketLapel_"..i,V(.33,1.02,.12),torso*CFrame.new(x,.06,-.57)*CFrame.Angles(0,0,math.rad(i==1 and -12 or 12)),C(22,82,92))
end
part(outfit,"LeatherSatchelStrap",V(.19,1.65,.13),torso*CFrame.new(.14,0,-.66)*CFrame.Angles(0,0,math.rad(-27)),wood)
part(outfit,"ChestBadge",V(.26,.27,.07),torso*CFrame.new(-.61,.43,-.69),gold)
part(outfit,"Belt",V(1.99,.22,1.04),S.LowerTorso.CFrame*CFrame.new(0,.04,0),wood)
part(outfit,"Buckle",V(.30,.24,.07),S.LowerTorso.CFrame*CFrame.new(0,.04,-.57),gold)
part(outfit,"SideSatchel",V(.67,.88,.43),S.LowerTorso.CFrame*CFrame.new(-1.02,-.25,0),C(134,89,49))
local tag=S.Head:FindFirstChild("NameTag");if tag then tag.Enabled=false end
-- Small counter badge, not an additional screen GUI.
local badge=part(M.Counter,"PipBadge",V(3.9,.84,.12),CFrame.new(-46.5,4.65,-35.55)*CFrame.Angles(0,math.pi,0),navy);label(badge,"PIP  •  TRADER",64)
for _,d in M:GetDescendants() do if d:IsA("BasePart") and not d.CanCollide then d.CanTouch=false;d.CanQuery=false end end
M:SetAttribute("AstraRefinementV1",true)
return "Market and authored shopkeeper refined"
