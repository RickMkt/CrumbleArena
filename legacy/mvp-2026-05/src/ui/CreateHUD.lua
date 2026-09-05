--!strict
-- CreateHUD.lua
-- Constrói a ScreenGui completa do Crumble Arena e retorna handles para
-- atualização runtime (top bar, alive counter, mensagem central, etc).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(ReplicatedStorage.UI.Theme)
local CreateRoundUI = require(ReplicatedStorage.UI.CreateRoundUI)
local CreateScoreboardUI = require(ReplicatedStorage.UI.CreateScoreboardUI)
local CreateLobbyUI = require(ReplicatedStorage.UI.CreateLobbyUI)

local CreateHUD = {}

local function buildTopBar(parent: GuiObject, gameName: string)
	local bar = Instance.new("Frame")
	bar.Name = "TopBar"
	bar.Size = UDim2.new(0, 360, 0, 56)
	bar.Position = UDim2.new(0, 16, 0, 12)
	bar.Parent = parent
	Theme.applyPanel(bar)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 6)
	padding.PaddingBottom = UDim.new(0, 6)
	padding.PaddingLeft = UDim.new(0, 14)
	padding.PaddingRight = UDim.new(0, 14)
	padding.Parent = bar

	local titleLabel = Theme.makeText(bar, {
		Name = "GameName",
		Text = string.upper(gameName),
		Font = Theme.Fonts.Title,
		TextSize = 18,
		Color = Theme.Colors.Accent,
		XAlign = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 20),
	})

	local stateLabel = Theme.makeText(bar, {
		Name = "StateLabel",
		Text = "Loading...",
		Font = Theme.Fonts.Body,
		TextSize = 13,
		Color = Theme.Colors.TextSecondary,
		XAlign = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 0, 0, 22),
		Size = UDim2.new(0.6, 0, 0, 18),
	})

	local timeLabel = Theme.makeText(bar, {
		Name = "TimeLabel",
		Text = "--:--",
		Font = Theme.Fonts.Mono,
		TextSize = 22,
		Color = Theme.Colors.TextPrimary,
		XAlign = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, 0, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(0.4, 0, 1, 0),
	})

	return { Bar = bar, GameName = titleLabel, StateLabel = stateLabel, TimeLabel = timeLabel }
end

local function buildAliveCounter(parent: GuiObject)
	local frame = Instance.new("Frame")
	frame.Name = "AliveCounter"
	frame.Size = UDim2.new(0, 160, 0, 50)
	frame.Position = UDim2.new(0, 16, 0, 76)
	frame.Parent = parent
	Theme.applyPanel(frame)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 6)
	padding.PaddingBottom = UDim.new(0, 6)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = frame

	Theme.makeText(frame, {
		Name = "Caption",
		Text = "ALIVE",
		Font = Theme.Fonts.Body,
		TextSize = 12,
		Color = Theme.Colors.TextSecondary,
		XAlign = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 14),
	})

	local valueLabel = Theme.makeText(frame, {
		Name = "Value",
		Text = "0/0",
		Font = Theme.Fonts.Title,
		TextSize = 22,
		Color = Theme.Colors.Good,
		XAlign = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 0, 0, 14),
		Size = UDim2.new(1, 0, 0, 24),
	})

	return { Frame = frame, Value = valueLabel }
end

local function buildCenterMessage(parent: GuiObject)
	local container = Instance.new("Frame")
	container.Name = "CenterMessage"
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(1, 0, 0, 120)
	container.Position = UDim2.new(0, 0, 0.32, 0)
	container.AnchorPoint = Vector2.new(0, 0)
	container.Parent = parent

	local label = Theme.makeText(container, {
		Name = "Text",
		Text = "",
		Font = Theme.Fonts.Title,
		TextSize = 56,
		Color = Theme.Colors.TextPrimary,
		XAlign = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 1, 0),
	})

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 3
	stroke.Color = Color3.fromRGB(10, 12, 18)
	stroke.Transparency = 0.3
	stroke.Parent = label

	local subtitle = Theme.makeText(container, {
		Name = "Subtitle",
		Text = "",
		Font = Theme.Fonts.Body,
		TextSize = 20,
		Color = Theme.Colors.TextSecondary,
		XAlign = Enum.TextXAlignment.Center,
		Position = UDim2.new(0, 0, 1, -8),
		AnchorPoint = Vector2.new(0, 1),
		Size = UDim2.new(1, 0, 0, 24),
	})

	return { Frame = container, Text = label, Subtitle = subtitle }
end

local function buildSpectatorBar(parent: GuiObject)
	local frame = Instance.new("Frame")
	frame.Name = "SpectatorBar"
	frame.Size = UDim2.new(0, 360, 0, 44)
	frame.Position = UDim2.new(0.5, 0, 1, -24)
	frame.AnchorPoint = Vector2.new(0.5, 1)
	frame.Visible = false
	frame.Parent = parent
	frame.BackgroundColor3 = Theme.Colors.Bad
	frame.BackgroundTransparency = 0.4
	frame.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.CornerRadius
	corner.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)
	padding.Parent = frame

	local title = Theme.makeText(frame, {
		Name = "Title",
		Text = "SPECTATING",
		Font = Theme.Fonts.Title,
		TextSize = 16,
		Color = Theme.Colors.TextPrimary,
		XAlign = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 0, 18),
	})

	local subtitle = Theme.makeText(frame, {
		Name = "Subtitle",
		Text = "You will return next round.",
		Font = Theme.Fonts.Body,
		TextSize = 13,
		Color = Theme.Colors.TextPrimary,
		XAlign = Enum.TextXAlignment.Center,
		Position = UDim2.new(0, 0, 0, 20),
		Size = UDim2.new(1, 0, 0, 16),
	})

	return { Frame = frame, Title = title, Subtitle = subtitle }
end

function CreateHUD.build(player: Player, gameName: string)
	local existing = player:FindFirstChild("PlayerGui")
		and player.PlayerGui:FindFirstChild("CrumbleArenaHUD")
	if existing then
		existing:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CrumbleArenaHUD"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local root = Instance.new("Frame")
	root.Name = "Root"
	root.BackgroundTransparency = 1
	root.Size = UDim2.fromScale(1, 1)
	root.Parent = screenGui

	local topBar = buildTopBar(root, gameName)
	local roundInfo = CreateRoundUI.build(root)
	local aliveCounter = buildAliveCounter(root)
	local centerMessage = buildCenterMessage(root)
	local scoreboard = CreateScoreboardUI.build(root)
	local lobbyPanel = CreateLobbyUI.build(root)
	local spectatorBar = buildSpectatorBar(root)

	return {
		ScreenGui = screenGui,
		Root = root,
		TopBar = topBar,
		RoundInfo = roundInfo,
		AliveCounter = aliveCounter,
		CenterMessage = centerMessage,
		Scoreboard = scoreboard,
		LobbyPanel = lobbyPanel,
		SpectatorBar = spectatorBar,
	}
end

return CreateHUD
