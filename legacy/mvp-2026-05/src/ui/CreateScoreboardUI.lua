--!strict
-- CreateScoreboardUI.lua
-- Painel lateral mostrando vitórias por jogador na partida atual.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(ReplicatedStorage.UI.Theme)

local CreateScoreboardUI = {}

local MAX_ROWS = 8

function CreateScoreboardUI.build(parent: GuiObject)
	local frame = Instance.new("Frame")
	frame.Name = "Scoreboard"
	frame.Size = UDim2.new(0, 220, 0, 220)
	frame.Position = UDim2.new(1, -16, 0, 80)
	frame.AnchorPoint = Vector2.new(1, 0)
	frame.Parent = parent
	Theme.applyPanel(frame)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = frame

	Theme.makeText(frame, {
		Name = "Title",
		Text = "SCOREBOARD",
		Font = Theme.Fonts.Title,
		TextSize = 16,
		Color = Theme.Colors.Accent,
		XAlign = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 22),
	})

	local rows: { [number]: { Container: Frame, Name: TextLabel, Wins: TextLabel } } = {}
	for i = 1, MAX_ROWS do
		local row = Instance.new("Frame")
		row.Name = "Row" .. i
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, 18)
		row.LayoutOrder = i
		row.Visible = false
		row.Parent = frame

		local nameLabel = Theme.makeText(row, {
			Name = "PlayerName",
			Text = "",
			Font = Theme.Fonts.Body,
			TextSize = 14,
			Color = Theme.Colors.TextPrimary,
			XAlign = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 1, 0),
		})

		local winsLabel = Theme.makeText(row, {
			Name = "Wins",
			Text = "0",
			Font = Theme.Fonts.Heading,
			TextSize = 14,
			Color = Theme.Colors.Warn,
			XAlign = Enum.TextXAlignment.Right,
			Size = UDim2.new(0, 40, 1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(1, 0),
		})

		rows[i] = { Container = row, Name = nameLabel, Wins = winsLabel }
	end

	return {
		Frame = frame,
		Rows = rows,
	}
end

return CreateScoreboardUI
