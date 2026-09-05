--!strict
-- Theme.lua
-- Paleta e estilos compartilhados pela GUI.

local Theme = {}

Theme.Colors = {
	Background = Color3.fromRGB(18, 20, 28),
	Panel = Color3.fromRGB(28, 31, 42),
	PanelAlt = Color3.fromRGB(36, 40, 54),
	Accent = Color3.fromRGB(86, 180, 255),
	AccentDim = Color3.fromRGB(50, 110, 170),
	Warn = Color3.fromRGB(255, 210, 90),
	Bad = Color3.fromRGB(255, 95, 95),
	Good = Color3.fromRGB(120, 230, 130),
	TextPrimary = Color3.fromRGB(245, 247, 255),
	TextSecondary = Color3.fromRGB(170, 180, 195),
	TextMuted = Color3.fromRGB(120, 130, 145),
}

Theme.Fonts = {
	Title = Enum.Font.GothamBlack,
	Heading = Enum.Font.GothamBold,
	Body = Enum.Font.Gotham,
	Mono = Enum.Font.RobotoMono,
}

Theme.CornerRadius = UDim.new(0, 8)
Theme.PanelTransparency = 0.15

function Theme.applyPanel(frame: GuiObject)
	frame.BackgroundColor3 = Theme.Colors.Panel
	frame.BackgroundTransparency = Theme.PanelTransparency
	frame.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.CornerRadius
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Theme.Colors.PanelAlt
	stroke.Transparency = 0.4
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = frame
end

function Theme.makeText(parent: GuiObject, opts: { [string]: any })
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextColor3 = opts.Color or Theme.Colors.TextPrimary
	label.Font = opts.Font or Theme.Fonts.Body
	label.TextSize = opts.TextSize or 16
	label.TextXAlignment = opts.XAlign or Enum.TextXAlignment.Left
	label.TextYAlignment = opts.YAlign or Enum.TextYAlignment.Center
	label.Text = opts.Text or ""
	label.RichText = opts.RichText or false
	label.Size = opts.Size or UDim2.fromScale(1, 1)
	label.Position = opts.Position or UDim2.fromScale(0, 0)
	label.AnchorPoint = opts.AnchorPoint or Vector2.new(0, 0)
	label.Name = opts.Name or "Label"
	label.Parent = parent
	return label
end

return Theme
