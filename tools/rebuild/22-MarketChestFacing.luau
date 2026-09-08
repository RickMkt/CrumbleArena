-- Apply once in Edit. Market-only reversible orientation correction.
local M = workspace.CrumbleArena.Lobby.Market
local S = game:GetService("ServerStorage")
assert(not S:FindFirstChild("AstraMarketDetailRollback"), "Already applied")
local backup = Instance.new("Folder")
backup.Name = "AstraMarketDetailRollback"
backup.Parent = S
M:Clone().Parent = backup
local chest = M.SideProps.TreasureChest
local pivot = Vector3.new(-58.5, 0, -27)
local turn = CFrame.new(pivot) * CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-pivot)
for _, p in chest:GetDescendants() do
 if p:IsA("BasePart") then p.CFrame = turn * p.CFrame end
end
local pick = M.ArenaEquipment.Pickaxe
local handle = pick:FindFirstChild("WoodHandle", true)
assert(handle, "Missing handle")
local old = handle.CFrame
-- Grip/handle heel meets pallet; upper shaft leans toward chest front.
local rot = CFrame.Angles(math.rad(-16), 0, math.rad(-8))
local up = rot.UpVector
local heel = Vector3.new(-59.7, 3.61, -24.95)
local target = CFrame.new(heel + up * (handle.Size.Y / 2)) * rot
for _, p in pick:GetDescendants() do
 if p:IsA("BasePart") then p.CFrame = target * old:ToObjectSpace(p.CFrame) end
end
return "Chest facing +Z; pickaxe heel on pallet; backup preserved"
