assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby;local M=L.Market;assert(not M:FindFirstChild("ArenaEquipment"),"Already applied")
local R=game.ServerStorage.AstraMarketPrecisionRollback
local extra=Instance.new("Folder");extra.Name="RemovedMarketClutter";extra.Parent=R
-- These objects belong to the Market despite being stored outside its folder.
L.Props.Supplies.MarketSupply_3.Parent=extra
local repair=L.Architecture.ModularAccents.RepairModule_7;repair.Position=Vector3.new(-56,3.27,-24.7)
local F=Instance.new("Model");F.Name="ArenaEquipment";F.Parent=M
local function p(name,size,cf,color,mat,parent)
local q=Instance.new("Part");q.Name=name;q.Size=size;q.CFrame=cf;q.Color=color;q.Material=mat or Enum.Material.Wood;q.Anchored=true;q.CanCollide=false;q.CanTouch=false;q.CanQuery=false;q.TopSurface=Enum.SurfaceType.Smooth;q.BottomSurface=Enum.SurfaceType.Smooth;q.Parent=parent or F;return q end
local wood=Color3.fromRGB(112,76,45);local steel=Color3.fromRGB(126,147,153);local teal=Color3.fromRGB(29,112,122)
p("EntryRug",Vector3.new(11,.045,5.5),CFrame.new(-46.5,3.2225,-29.6),teal,Enum.Material.Fabric)
for _,x in {-51.5,-41.5} do p("RugStitch",Vector3.new(.08,.012,4.7),CFrame.new(x,3.251,-29.6),Color3.fromRGB(221,203,164),Enum.Material.Fabric) end
-- Relocate the two right-hand crates beneath a compact equipment display.
for i=3,4 do local q=M.SideProps["YardCrate_"..i];local delta=Vector3.new(i==3 and -31.7 or -29.5,q.Position.Y,-32.5)-q.Position;q.Position+=delta;M.SideProps["YardCrateBand_"..i].Position+=delta end
for _,x in {-34,-28.2} do p("RackUpright",Vector3.new(.4,4.5,.55),CFrame.new(x,5.45,-32.7),wood) end
for i,y in {3.5,5.55,7.55} do p("RackShelf"..i,Vector3.new(6.2,.25,2),CFrame.new(-31.1,y,-32.3),wood) end
for i,v in {{-33,6.1,-32.3},{-31.5,6.1,-32.3},{-30,6.05,-32.3}} do
local q=p("ArenaBlock"..i,Vector3.new(.85,.85,.85),CFrame.new(v[1],v[2],v[3]),i==2 and teal or steel,Enum.Material.Plastic);q.TopSurface=Enum.SurfaceType.Studs end
local function tool(name,base)
local model=Instance.new("Model");model.Name=name;model.Parent=F
local function t(n,s,c,col,mat)return p(n,s,base*c,col,mat,model)end
t("WoodHandle",Vector3.new(.28,3.7,.28),CFrame.new(0,2.2,0),wood)
if name=="Pickaxe" then
t("HeadSocket",Vector3.new(.55,.6,.5),CFrame.new(0,3.8,0),steel,Enum.Material.Metal)
t("PickLeft",Vector3.new(1.5,.25,.3),CFrame.new(-.8,3.65,0)*CFrame.Angles(0,0,math.rad(13)),steel,Enum.Material.Metal)
t("PickRight",Vector3.new(1.5,.25,.3),CFrame.new(.8,3.65,0)*CFrame.Angles(0,0,math.rad(-13)),steel,Enum.Material.Metal)
else
t("SpadeBlade",Vector3.new(1.1,1.35,.18),CFrame.new(0,.65,0),steel,Enum.Material.Metal)
t("GripLeft",Vector3.new(.15,.6,.2),CFrame.new(-.3,4.1,0),wood)
t("GripRight",Vector3.new(.15,.6,.2),CFrame.new(.3,4.1,0),wood)
t("GripTop",Vector3.new(.75,.17,.22),CFrame.new(0,4.4,0),wood)
end
local low=math.huge;for _,q in model:GetChildren() do for _,x in {-1,1} do for _,y in {-1,1} do for _,z in {-1,1} do low=math.min(low,q.CFrame:PointToWorldSpace(q.Size*Vector3.new(x,y,z)/2).Y) end end end end
for _,q in model:GetChildren() do q.Position+=Vector3.new(0,3.2-low,0) end
end
tool("Pickaxe",CFrame.new(-61.3,3.2,-27.8)*CFrame.Angles(0,0,math.rad(-12)))
tool("Shovel",CFrame.new(-27.3,3.2,-31)*CFrame.Angles(0,0,math.rad(9)))
return {newParts=#F:GetDescendants(),tools={"Pickaxe","Shovel"},removed=1}
