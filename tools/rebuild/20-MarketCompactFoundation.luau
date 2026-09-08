assert(not game:GetService("RunService"):IsRunning(),"Edit only")
local L=workspace.CrumbleArena.Lobby
assert(not game.ServerStorage:FindFirstChild("AstraMarketPrecisionRollback"),"Already applied")
local R=Instance.new("Folder");R.Name="AstraMarketPrecisionRollback";R.Parent=game.ServerStorage
local snap=L:Clone();snap.Name="LobbyBefore";snap.Parent=R
local old=L.Architecture.Paths.MarketTerrace;old.Parent=R
local floor=Instance.new("Folder");floor.Name="MarketTerrace";floor.Parent=L.Architecture.Paths
local poly={{-64,-24},{-67,-37},{-62,-46},{-32,-46},{-24,-38},{-24,-20},{-36,-20}}
local function triangle(a,b,c,t,color,name,stud)
local ab,ac,bc=b-a,c-a,c-b
if ab:Dot(ab)>ac:Dot(ac) and ab:Dot(ab)>bc:Dot(bc) then c,a=a,c elseif ac:Dot(ac)>bc:Dot(bc) then a,b=b,a end
ab,ac,bc=b-a,c-a,c-b
local right=ac:Cross(ab).Unit;local up=bc:Cross(right).Unit;local back=bc.Unit
local h=math.abs(ab:Dot(up))
for i,v in {{(a+b)/2,right,up,back,math.abs(ab:Dot(back))},{(a+c)/2,-right,up,-back,math.abs(ac:Dot(back))}} do
if v[5]>.001 then local p=Instance.new("WedgePart");p.Name=name.."_"..i;p.Size=Vector3.new(t,h,v[5]);p.CFrame=CFrame.fromMatrix(v[1],v[2],v[3],v[4]);p.Color=color;p.Material=Enum.Material.Plastic;p.Anchored=true;p.CanCollide=true;p.CanTouch=false;p.CanQuery=true
for _,face in {"Top","Bottom","Left","Right","Front","Back"} do p[face.."Surface"]=Enum.SurfaceType.Smooth end
if stud then if p.CFrame.RightVector.Y>.9 then p.RightSurface=Enum.SurfaceType.Studs else p.LeftSurface=Enum.SurfaceType.Studs end end;p.Parent=floor end end
end
for _,layer in {{1.4,2.8,Color3.fromRGB(110,121,125),"Foundation",false},{3,.4,Color3.fromRGB(181,169,142),"Paving",true}} do
for i=2,#poly-1 do local function v(k)return Vector3.new(poly[k][1],layer[1],poly[k][2])end;triangle(v(1),v(i),v(i+1),layer[2],layer[3],layer[4]..i,layer[5]) end end
return {old=8,new=#floor:GetChildren(),top=3.2,entryPreserved="x -36 to -24, z -20"}
