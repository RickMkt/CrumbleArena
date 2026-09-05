--!strict
-- CreateLobbyUI.lua
-- Painel discreto exibido enquanto o jogador está em estado de lobby/intermission.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(ReplicatedStorage.UI.Theme)

local CreateLobbyUI = {}

function CreateLobbyUI.build(parent: GuiObject)
	local frame = Instance.new("Frame")
	frame.Name = "LobbyPanel"
	frame.Size = UDim2.new(0, 320, 0, 64)
	frame.Position = UDim2.new(0.5, 0, 1, -24)
	frame.AnchorPoint = Vector2.new(0.5, 1)
	frame.Visible = false
	frame.Parent = parent
	Theme.applyPanel(frame)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 14)
	padding.PaddingRight = UDim.new(0, 14)
	padding.Parent = frame

	local title = Theme.makeText(frame, {
		Name = "Title",
		Text = "WAITING FOR PLAYERS",
		Font = Theme.Fonts.Title,
		TextSize = 18,
		Color = Theme.Colors.Accent,
		XAlign = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 0, 20),
	})

	local subtitle = Theme.makeText(frame, {
		Name = "Subtitle",
		Text = "Walk around the lobby until enough players join.",
		Font = Theme.Fonts.Body,
		TextSize = 13,
		Color = Theme.Colors.TextSecondary,
		XAlign = Enum.TextXAlignment.Center,
		Position = UDim2.new(0, 0, 0, 22),
		Size = UDim2.new(1, 0, 0, 18),
	})

	return {
		Frame = frame,
		Title = title,
		Subtitle = subtitle,
	}
end

return CreateLobbyUI
