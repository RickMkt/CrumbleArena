--!strict
-- ArenaService.lua
-- Cria, destroi e reseta a arena procedural de 3 camadas.

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local ArenaConfig = require(Shared.ArenaConfig)

local ArenaService = {}

local arenaFolder: Folder? = nil
local killZone: BasePart? = nil
local spawnPoints: { CFrame } = {}

local function getOrCreateRoot(): Folder
	local root = Workspace:FindFirstChild("CrumbleArena")
	if not root then
		root = Instance.new("Folder")
		root.Name = "CrumbleArena"
		root.Parent = Workspace
	end
	return root
end

local function gridToWorld(gx: number, gz: number, layerY: number): Vector3
	local center = Config.ArenaCenter
	local size = ArenaConfig.GridSize
	local tile = ArenaConfig.TileSize
	local offset = (size + 1) / 2
	local worldX = center.X + (gx - offset) * tile
	local worldZ = center.Z + (gz - offset) * tile
	return Vector3.new(worldX, layerY, worldZ)
end

local function distanceFromGridCenter(gx: number, gz: number): number
	local size = ArenaConfig.GridSize
	local center = (size + 1) / 2
	local dx = gx - center
	local dz = gz - center
	return math.sqrt(dx * dx + dz * dz)
end

local function buildLayer(parent: Folder, layerIndex: number, layerY: number)
	local style = ArenaConfig.LayerStyles[layerIndex] or ArenaConfig.LayerStyles[1]

	local layerFolder = Instance.new("Folder")
	layerFolder.Name = "Layer" .. layerIndex
	layerFolder.Parent = parent

	local size = ArenaConfig.GridSize
	local tile = ArenaConfig.TileSize
	local height = ArenaConfig.TileHeight
	local radius = ArenaConfig.RoundRadius

	for gx = 1, size do
		for gz = 1, size do
			if distanceFromGridCenter(gx, gz) <= radius then
				local pos = gridToWorld(gx, gz, layerY)
				local block = Instance.new("Part")
				block.Name = "ArenaTile"
				block.Anchored = true
				block.CanCollide = true
				block.Material = style.Material
				block.Color = style.Color
				block.Size = Vector3.new(tile, height, tile)
				block.CFrame = CFrame.new(pos)
				block.TopSurface = Enum.SurfaceType.Smooth
				block.BottomSurface = Enum.SurfaceType.Smooth

				block:SetAttribute("ArenaTile", true)
				block:SetAttribute("Breakable", true)
				block:SetAttribute("Broken", false)
				block:SetAttribute("Layer", layerIndex)
				block:SetAttribute("GridX", gx)
				block:SetAttribute("GridZ", gz)

				block.Parent = layerFolder
			end
		end
	end
end

local function buildKillZone(parent: Folder, lastLayerY: number)
	local part = Instance.new("Part")
	part.Name = "KillZonePart"
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(400, 4, 400)
	part.CFrame = CFrame.new(
		Vector3.new(Config.ArenaCenter.X, lastLayerY - Config.KillZoneOffsetBelowLastLayer, Config.ArenaCenter.Z)
	)
	part.Parent = parent
	return part
end

local function buildSpawnPoints(topLayerY: number)
	local points: { CFrame } = {}
	local radius = (ArenaConfig.RoundRadius - 1.5) * ArenaConfig.TileSize
	local count = ArenaConfig.MaxSpawnPoints
	local center = Config.ArenaCenter
	local spawnY = topLayerY + ArenaConfig.TileHeight / 2 + 4

	for i = 1, count do
		local theta = (i - 1) * (math.pi * 2 / count)
		local x = center.X + math.cos(theta) * radius
		local z = center.Z + math.sin(theta) * radius
		local lookAt = Vector3.new(center.X, spawnY, center.Z)
		local pos = Vector3.new(x, spawnY, z)
		table.insert(points, CFrame.lookAt(pos, lookAt))
	end
	return points
end

function ArenaService.create()
	ArenaService.destroy()

	local root = getOrCreateRoot()
	local arenaContainer = root:FindFirstChild("CurrentArena")
	if not arenaContainer then
		arenaContainer = Instance.new("Folder")
		arenaContainer.Name = "CurrentArena"
		arenaContainer.Parent = root
	end

	local arena = Instance.new("Folder")
	arena.Name = "Arena"
	arena.Parent = arenaContainer

	local layers = ArenaConfig.Layers
	local layerHeight = ArenaConfig.LayerHeight
	local topY = Config.ArenaCenter.Y

	for layerIndex = 1, layers do
		local layerY = topY - (layerIndex - 1) * layerHeight
		buildLayer(arena, layerIndex, layerY)
	end

	local lastLayerY = topY - (layers - 1) * layerHeight

	local killZoneFolder = root:FindFirstChild("KillZone")
	if not killZoneFolder then
		killZoneFolder = Instance.new("Folder")
		killZoneFolder.Name = "KillZone"
		killZoneFolder.Parent = root
	end
	for _, child in ipairs(killZoneFolder:GetChildren()) do
		child:Destroy()
	end
	killZone = buildKillZone(killZoneFolder, lastLayerY)

	spawnPoints = buildSpawnPoints(topY)
	arenaFolder = arena
	return arena
end

function ArenaService.destroy()
	local root = Workspace:FindFirstChild("CrumbleArena")
	if not root then
		return
	end
	local arenaContainer = root:FindFirstChild("CurrentArena")
	if arenaContainer then
		for _, child in ipairs(arenaContainer:GetChildren()) do
			child:Destroy()
		end
	end
	local kz = root:FindFirstChild("KillZone")
	if kz then
		for _, child in ipairs(kz:GetChildren()) do
			child:Destroy()
		end
	end
	-- limpa projéteis em voo
	local projectiles = root:FindFirstChild("Projectiles")
	if projectiles then
		for _, child in ipairs(projectiles:GetChildren()) do
			child:Destroy()
		end
	end
	arenaFolder = nil
	killZone = nil
	spawnPoints = {}
end

function ArenaService.reset()
	ArenaService.destroy()
	return ArenaService.create()
end

function ArenaService.getArenaFolder(): Folder?
	return arenaFolder
end

function ArenaService.getKillZone(): BasePart?
	return killZone
end

function ArenaService.getSpawnPoints(): { CFrame }
	return spawnPoints
end

function ArenaService.getProjectilesFolder(): Folder
	local root = getOrCreateRoot()
	local folder = root:FindFirstChild("Projectiles")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Projectiles"
		folder.Parent = root
	end
	return folder
end

return ArenaService
