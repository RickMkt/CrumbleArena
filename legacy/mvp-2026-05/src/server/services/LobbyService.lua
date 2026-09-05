--!strict
-- LobbyService.lua
-- Constrói o lobby por código (plataforma, banner, decorações simples).

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)

local LobbyService = {}

local lobbyFolder: Folder? = nil
local spawnPart: SpawnLocation? = nil

local LOBBY_PLATFORM_SIZE = Vector3.new(80, 4, 80)
local LOBBY_BORDER_SIZE = Vector3.new(82, 8, 82)
local LOBBY_COLOR = Color3.fromRGB(50, 56, 70)
local LOBBY_ACCENT = Color3.fromRGB(86, 180, 255)

local function getOrCreateRoot(): Folder
	local root = Workspace:FindFirstChild("CrumbleArena")
	if not root then
		root = Instance.new("Folder")
		root.Name = "CrumbleArena"
		root.Parent = Workspace
	end
	return root
end

local function buildPlatform(parent: Folder, center: Vector3)
	local platform = Instance.new("Part")
	platform.Name = "Platform"
	platform.Anchored = true
	platform.CanCollide = true
	platform.Material = Enum.Material.SmoothPlastic
	platform.Color = LOBBY_COLOR
	platform.Size = LOBBY_PLATFORM_SIZE
	platform.CFrame = CFrame.new(center)
	platform.TopSurface = Enum.SurfaceType.Smooth
	platform.BottomSurface = Enum.SurfaceType.Smooth
	platform.Parent = parent

	-- borda decorativa um pouco mais escura
	local border = Instance.new("Part")
	border.Name = "Border"
	border.Anchored = true
	border.CanCollide = false
	border.Material = Enum.Material.SmoothPlastic
	border.Color = Color3.fromRGB(28, 32, 42)
	border.Size = LOBBY_BORDER_SIZE
	border.CFrame = CFrame.new(center - Vector3.new(0, 2, 0))
	border.Parent = parent

	return platform
end

local function buildSpawn(parent: Folder, center: Vector3)
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "LobbySpawn"
	spawn.Anchored = true
	spawn.CanCollide = true
	spawn.Size = Vector3.new(8, 1, 8)
	spawn.CFrame = CFrame.new(center + Vector3.new(0, LOBBY_PLATFORM_SIZE.Y / 2 + 0.5, 0))
	spawn.Material = Enum.Material.Neon
	spawn.Color = LOBBY_ACCENT
	spawn.TopSurface = Enum.SurfaceType.Smooth
	spawn.BottomSurface = Enum.SurfaceType.Smooth
	spawn.Neutral = true
	spawn.AllowTeamChangeOnTouch = false
	spawn.Duration = 0
	spawn.Parent = parent
	return spawn
end

local function buildBanner(parent: Folder, center: Vector3)
	local pole = Instance.new("Part")
	pole.Name = "BannerPole"
	pole.Anchored = true
	pole.CanCollide = false
	pole.Material = Enum.Material.SmoothPlastic
	pole.Color = Color3.fromRGB(30, 32, 40)
	pole.Size = Vector3.new(1, 18, 1)
	pole.CFrame = CFrame.new(center + Vector3.new(0, 9 + LOBBY_PLATFORM_SIZE.Y / 2, -20))
	pole.Parent = parent

	local sign = Instance.new("Part")
	sign.Name = "Banner"
	sign.Anchored = true
	sign.CanCollide = false
	sign.Material = Enum.Material.SmoothPlastic
	sign.Color = Color3.fromRGB(28, 31, 42)
	sign.Size = Vector3.new(28, 8, 0.5)
	sign.CFrame = CFrame.new(center + Vector3.new(0, 16 + LOBBY_PLATFORM_SIZE.Y / 2, -20))
	sign.Parent = parent

	for _, faceNormal in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
		local gui = Instance.new("SurfaceGui")
		gui.Name = "BannerGui"
		gui.Face = faceNormal
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 50
		gui.Parent = sign

		local title = Instance.new("TextLabel")
		title.BackgroundTransparency = 1
		title.Size = UDim2.new(1, 0, 0.6, 0)
		title.Position = UDim2.new(0, 0, 0, 0)
		title.TextColor3 = LOBBY_ACCENT
		title.Font = Enum.Font.GothamBlack
		title.TextScaled = true
		title.Text = string.upper(Config.GameName)
		title.Parent = gui

		local subtitle = Instance.new("TextLabel")
		subtitle.BackgroundTransparency = 1
		subtitle.Size = UDim2.new(1, 0, 0.35, 0)
		subtitle.Position = UDim2.new(0, 0, 0.6, 0)
		subtitle.TextColor3 = Color3.fromRGB(220, 230, 240)
		subtitle.Font = Enum.Font.Gotham
		subtitle.TextScaled = true
		subtitle.Text = Config.ModeName
		subtitle.Parent = gui
	end
end

local function buildDecorBlocks(parent: Folder, center: Vector3)
	local positions = {
		Vector3.new(20, 1, 14),
		Vector3.new(24, 3, 18),
		Vector3.new(-22, 1, 14),
		Vector3.new(-26, 3, 18),
		Vector3.new(0, 1, 28),
	}
	for i, offset in ipairs(positions) do
		local block = Instance.new("Part")
		block.Name = "Decor" .. i
		block.Anchored = true
		block.CanCollide = true
		block.Material = Enum.Material.SmoothPlastic
		block.Color = (i % 2 == 0) and Color3.fromRGB(218, 232, 245) or Color3.fromRGB(120, 150, 180)
		block.Size = Vector3.new(4, 2, 4)
		block.CFrame = CFrame.new(center + offset + Vector3.new(0, LOBBY_PLATFORM_SIZE.Y / 2, 0))
		block.Parent = parent
	end

	-- bolinha decorativa gigante
	local ball = Instance.new("Part")
	ball.Name = "DecorBall"
	ball.Shape = Enum.PartType.Ball
	ball.Anchored = true
	ball.CanCollide = false
	ball.Material = Enum.Material.SmoothPlastic
	ball.Color = Color3.fromRGB(245, 250, 255)
	ball.Size = Vector3.new(10, 10, 10)
	ball.CFrame = CFrame.new(center + Vector3.new(20, 7, -8))
	ball.Parent = parent
end

local function buildBarriers(parent: Folder, center: Vector3)
	-- barreira invisível baixa para evitar quedas acidentais
	local sides = {
		{ Vector3.new(0, 4, LOBBY_PLATFORM_SIZE.Z / 2), Vector3.new(LOBBY_PLATFORM_SIZE.X, 12, 1) },
		{ Vector3.new(0, 4, -LOBBY_PLATFORM_SIZE.Z / 2), Vector3.new(LOBBY_PLATFORM_SIZE.X, 12, 1) },
		{ Vector3.new(LOBBY_PLATFORM_SIZE.X / 2, 4, 0), Vector3.new(1, 12, LOBBY_PLATFORM_SIZE.Z) },
		{ Vector3.new(-LOBBY_PLATFORM_SIZE.X / 2, 4, 0), Vector3.new(1, 12, LOBBY_PLATFORM_SIZE.Z) },
	}
	for i, info in ipairs(sides) do
		local wall = Instance.new("Part")
		wall.Name = "Barrier" .. i
		wall.Anchored = true
		wall.CanCollide = true
		wall.Transparency = 1
		wall.Size = info[2]
		wall.CFrame = CFrame.new(center + info[1])
		wall.Parent = parent
	end
end

function LobbyService.init()
	if lobbyFolder then
		return
	end
	local root = getOrCreateRoot()

	local lobby = root:FindFirstChild("Lobby")
	if lobby then
		lobby:Destroy()
	end

	lobby = Instance.new("Folder")
	lobby.Name = "Lobby"
	lobby.Parent = root

	local center = Config.LobbyCenter
	buildPlatform(lobby, center)
	spawnPart = buildSpawn(lobby, center)
	buildBanner(lobby, center)
	buildDecorBlocks(lobby, center)
	buildBarriers(lobby, center)

	lobbyFolder = lobby

	-- garante que outras pastas esperadas existem
	for _, name in ipairs({ "CurrentArena", "Projectiles", "KillZone" }) do
		if not root:FindFirstChild(name) then
			local f = Instance.new("Folder")
			f.Name = name
			f.Parent = root
		end
	end
end

function LobbyService.getSpawnCFrame(): CFrame
	if spawnPart then
		return spawnPart.CFrame + Vector3.new(0, 4, 0)
	end
	return CFrame.new(Config.LobbyCenter + Vector3.new(0, 6, 0))
end

function LobbyService.teleport(player: Player)
	local character = player.Character
	if not character then
		return
	end
	local hrp = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not hrp then
		return
	end
	local spawnCF = LobbyService.getSpawnCFrame()
	-- distribui os jogadores aleatoriamente na plataforma para não empilhar
	local jitter = Vector3.new((math.random() - 0.5) * 12, 0, (math.random() - 0.5) * 12)
	character:PivotTo(spawnCF + jitter)
end

return LobbyService
