--!strict
-- CreateRoundUI.lua
-- Cria o painel central de informação de round (Round X/Y e Modo).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(ReplicatedStorage.UI.Theme)

local CreateRoundUI = {}

function CreateRoundUI.build(parent: GuiObject)
	local frame = Instance.new("Frame")
	frame.Name = "RoundInfo"
	frame.Size = UDim2.new(0, 240, 0, 56)
	frame.Position = UDim2.new(0.5, 0, 0, 12)
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Parent = parent
	Theme.applyPanel(frame)

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 2)
	layout.Parent = frame

	local roundLabel = Theme.makeText(frame, {
		Name = "RoundLabel",
		Text = "ROUND --",
		Font = Theme.Fonts.Title,
		TextSize = 22,
		Color = Theme.Colors.TextPrimary,
		XAlign = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 0, 24),
	})

	local modeLabel = Theme.makeText(frame, {
		Name = "ModeLabel",
		Text = "Snowball Classic",
		Font = Theme.Fonts.Body,
		TextSize = 14,
		Color = Theme.Colors.TextSecondary,
		XAlign = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 0, 16),
	})

	return {
		Frame = frame,
		RoundLabel = roundLabel,
		ModeLabel = modeLabel,
	}
end

return CreateRoundUI
