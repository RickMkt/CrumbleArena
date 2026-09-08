assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby;local S=L.SocialArea
assert(game.ServerStorage:FindFirstChild("AstraSocialRefinement_20260906"),"Need rollback")
assert(not S:FindFirstChild("CampSupplies"),"Already applied")
local center=Vector3.new(-52,0,12)
local layout={{S.FunctionalCampfireChairs.CampChair_01,-58,23},{S.FunctionalCampfireChairs.CampChair_02,-49,24},{S.FunctionalCampfireChairs.CampChair_03,-42.5,20},{S.FunctionalCampfireChairs.CampChair_04,-63,16},{S.Bench_West,-59,9},{S.Bench_East,-49,5.8}}
local changes={}
for _,row in layout do
 local m,x,z=row[1],row[2],row[3];local seat=m:FindFirstChildWhichIsA("Seat",true);assert(seat)
 local old=seat.CFrame;local target=CFrame.lookAt(Vector3.new(x,seat.Position.Y,z),Vector3.new(center.X,seat.Position.Y,center.Z))
 local delta=target*old:Inverse()
 for _,p in m:GetDescendants() do if p:IsA("BasePart") then
 p.CFrame=delta*p.CFrame;p.Anchored=true;p.CanTouch=p:IsA("Seat");p.CanQuery=true
 p.Color=p:IsA("Seat") and Color3.fromRGB(140,96,58) or Color3.fromRGB(103,65,39);p.Material=Enum.Material.Wood
 end end
 changes[#changes+1]={model=m.Name,old=tostring(old),new=tostring(seat.CFrame)}
end
local props=Instance.new("Model");props.Name="CampSupplies";props.Parent=S
local box,barrel
for _,p in game.ServerStorage.CrumbleArenaLibraries:GetDescendants() do if p:IsA("MeshPart") then
 if p.MeshId:match("71764690630135") then box=p elseif p.MeshId:match("117416911463463") then barrel=p end end end
assert(box and barrel,"Approved source absent");assert(#box:GetDescendants()==0 and #barrel:GetDescendants()==0,"Inspect sources")
local function prop(source,name,size,pos,angle,color)
 local p=source:Clone();p.Name=name;p.Size=size;p.CFrame=CFrame.new(pos)*CFrame.Angles(0,math.rad(angle),0)
 p.TextureID="";p.Material=Enum.Material.Wood;p.Color=color;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 p:SetAttribute("SourceAssetId","78867862192359");p:SetAttribute("License","CC0");p.Parent=props;return p
end
prop(barrel,"WaterBarrel",Vector3.new(2.6,2.6,2.6),Vector3.new(-57,1.9,28.5),12,Color3.fromRGB(115,78,46))
prop(box,"SupplyCrateLower",Vector3.new(2.6,2.8,2.6),Vector3.new(-53.6,2,29),-8,Color3.fromRGB(143,106,64))
prop(box,"SupplyCrateUpper",Vector3.new(1.7,1.9,1.7),Vector3.new(-53.5,4.35,29),7,Color3.fromRGB(128,89,50))
-- Reuse sanitized firewood geometry already supplied by the user, with no effects on clones.
local source=S.CreatorStore_Campfire_User["Camp Fire"]:FindFirstChildWhichIsA("MeshPart")
assert(source,"Missing firewood")
for i,data in {{-63,1.03,24.7},{-62.1,1.03,24.7},{-62.55,1.73,24.7}} do
 local p=source:Clone();for _,d in p:GetChildren() do d:Destroy() end
 p.Name="StoredFirewood_"..i;p.Size=Vector3.new(.8,.85,3.8);p.CFrame=CFrame.new(data[1],data[2],data[3])*CFrame.Angles(0,math.rad(-12),0)
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Parent=props
end
for _,p in S.CreatorStore_Campfire_User:GetDescendants() do
 if p:IsA("PointLight") then p.Brightness=1.4;p.Range=13;p.Color=Color3.fromRGB(255,184,98);p.Shadows=false
 elseif p:IsA("Fire") then p.Size=3.5;p.Heat=3;p.Color=Color3.fromRGB(255,177,67);p.SecondaryColor=Color3.fromRGB(232,97,33)
 elseif p:IsA("BasePart") then p.CanTouch=false end
end
return {seats=changes,newDecor=6}
