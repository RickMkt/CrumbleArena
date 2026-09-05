--!strict
-- SpectatorService.lua
-- Cria a plataforma de espectador e teleporta jogadores eliminados para ela.

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local ArenaConfig = require(Shared.ArenaConfig)

local SpectatorService = {}

local platform: BasePart? = nil

local function getRoot(): Folder
	local root = Workspace:FindFirstChild("CrumbleArena")
	if not root then
		root = Instance.new("Folder")
		root.Name = "CrumbleArena"
		root.Parent = Workspace
	end
	return root
end

function SpectatorService.init()
	if platform then
		return
	end
	local root = getRoot()
	local container = root:FindFirstChild("Spectator")
	if container then
		container:Destroy()
	end
	container = Instance.new("Folder")
	container.Name = "Spectator"
	container.Parent = root

	local arenaCenter = Config.ArenaCenter
	local pos = arenaCenter + Config.SpectatorPlatformOffset

	local part = Instance.new("Part")
	part.Name = "SpectatorPlatform"
	part.Anchored = true
	part.CanCollide = true
	part.Size = Vector3.new(20, 1, 20)
	part.CFrame = CFrame.new(pos)
	part.Material = Enum.Material.ForceField
	part.Color = Color3.fromRGB(80, 90, 110)
	part.Transparency = 0.4
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = container

	-- guard rail invisível
	local rail = Instance.new("Part")
	rail.Name = "Guard"
	rail.Anchored = true
	rail.CanCollide = true
	rail.Transparency = 1
	rail.Size = Vector3.new(22, 12, 22)
	rail.CFrame = CFrame.new(pos + Vector3.new(0, 6, 0))
	rail.Parent = container

	platform = part
end

function SpectatorService.getSpawnCFrame(): CFrame
	if platform then
		return platform.CFrame + Vector3.new(0, 4, 0)
	end
	return CFrame.new(Config.ArenaCenter + Config.SpectatorPlatformOffset + Vector3.new(0, 4, 0))
end

function SpectatorService.sendToSpectator(player: Player)
	local character = player.Character
	if not character then
		return
	end
	local jitter = Vector3.new((math.random() - 0.5) * 8, 0, (math.random() - 0.5) * 8)
	character:PivotTo(SpectatorService.getSpawnCFrame() + jitter)
end

return SpectatorService
