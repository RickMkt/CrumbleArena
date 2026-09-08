local M=workspace.CrumbleArena.Lobby.Market
local backup=game.ServerStorage.AstraMarketDetailRollback
assert(not backup:FindFirstChild("OldShopkeeper"),"Already applied")
local desc=Instance.new("HumanoidDescription")
desc.HeadColor=Color3.fromRGB(239,196,132)
desc.LeftArmColor=desc.HeadColor desc.RightArmColor=desc.HeadColor
desc.TorsoColor=Color3.fromRGB(18,117,123)
desc.LeftLegColor=Color3.fromRGB(57,66,74) desc.RightLegColor=desc.LeftLegColor
local rig=game.Players:CreateHumanoidModelFromDescriptionAsync(desc,Enum.HumanoidRigType.R6)
rig.Name="Shopkeeper"
for _,p in rig:GetDescendants() do
 if p:IsA("LuaSourceContainer") then p:Destroy() end
 if p:IsA("BasePart") then p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false end
end
rig:PivotTo(CFrame.new(-46.5,6.6,-38.8)*CFrame.Angles(0,math.pi,0))
local minimum=math.huge
for _,name in {"Left Leg","Right Leg"} do local p=rig[name] minimum=math.min(minimum,p.Position.Y-p.Size.Y/2) end
rig:PivotTo(rig:GetPivot()+Vector3.new(0,3.6-minimum,0))
rig.Humanoid.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
rig.Humanoid.BreakJointsOnDeath=false
local old=M.Shopkeeper
local outfit=old.Outfit:Clone()
outfit.Parent=rig
for _,p in outfit:GetChildren() do
 if p:IsA("BasePart") then
  local headItem=p.Name:find("Hair") or p.Name:find("Hat") or p.Name:find("Explorer") or p.Name:find("Goggle")
  local source=headItem and old.Head or old.UpperTorso
  local target=headItem and rig.Head or rig.Torso
  p.CFrame=target.CFrame*source.CFrame:ToObjectSpace(p.CFrame)
  p.CanCollide=false p.CanTouch=false p.CanQuery=false p.Anchored=true
 end
end
local function sleeve(name,arm)
 local p=Instance.new("Part") p.Name=name p.Size=Vector3.new(1.035,1.35,1.035)
 p.Color=desc.TorsoColor p.Material=Enum.Material.SmoothPlastic
 p.CFrame=arm.CFrame*CFrame.new(0,.325,0)
 p.Anchored=true p.CanCollide=false p.CanTouch=false p.CanQuery=false p.Parent=outfit
 return p
end
sleeve("RightSleeve",rig["Right Arm"])
sleeve("LeftSleeve",rig["Left Arm"])
old.Name="OldShopkeeper" old.Parent=backup
rig.Parent=M
local animation=Instance.new("Script")
animation.Name="KeeperGreeting"
animation.RunContext=Enum.RunContext.Client
animation.Source=[=[
-- Cosmetic R6 greeting only. Anchored limbs preserve the non-physical display rig.
local RunService=game:GetService("RunService")
local rig=script.Parent
local arm=rig:WaitForChild("Right Arm")
local torso=rig:WaitForChild("Torso")
local sleeve=rig:WaitForChild("Outfit"):WaitForChild("RightSleeve")
local rest=torso.CFrame:ToObjectSpace(arm.CFrame)
local elapsed,acc=0,0
RunService.Heartbeat:Connect(function(dt)
 elapsed+=dt acc+=dt
 if acc<1/30 then return end
 acc=0
 local camera=workspace.CurrentCamera
 if not camera or (camera.CFrame.Position-torso.Position).Magnitude>90 then return end
 local phase=elapsed%10
 local angle=0
 if phase<3 then
  local envelope=math.min(phase/.65,1,(3-phase)/.65)
  angle=math.rad(115+9*math.sin(phase*8))*math.clamp(envelope,0,1)
 end
 if angle==0 then arm.CFrame=torso.CFrame*rest
 else arm.CFrame=torso.CFrame*CFrame.new(1,1,0)*CFrame.Angles(0,0,angle)*CFrame.new(.5,-1,0) end
 sleeve.CFrame=arm.CFrame*CFrame.new(0,.325,0)
end)
]=]
animation.Parent=rig
for _,name in {"Gamepass_VIP","Gamepass_Coins"} do
 M.Signage[name].Display.Label.TextSize=86
end
local badge=M.Counter.PipBadge
badge.Size=Vector3.new(5.3,.95,.16)
badge.Display.CanvasSize=Vector2.new(650,116)
badge.Display.Label.TextSize=65
return {rig=tostring(rig.Humanoid.RigType),parts=#rig:GetDescendants(),footY=3.6}
