--!strict
-- Reconstroi a interface do lobby: ReplicatedStorage.CrumbleArena.UI,
-- StarterGui.CrumbleUI, SoundService e o UIController.
--
-- Como rodar: colar no Command Bar do Studio, em modo Edit, e executar.
-- Rodar de novo e seguro, o script apaga o que criou antes.
--
-- Este arquivo existe porque a interface foi construida a mao no place e quase se
-- perdeu quando o Studio fechou sem salvar em 2026-09-04. O trabalho voltou pela
-- recuperacao automatica, mas o susto virou regra: geometria de interface nasce de
-- script versionado, nunca de instancia solta no place. Ver D-018 em docs/DECISIONS.md.
--
-- Hoje ele e rede de seguranca, nao necessidade. Se a interface estiver no place e
-- funcionando, nao rode. Rode quando ela se perder, ou quando quiser recriar do zero.

local RS = game:GetService("ReplicatedStorage")
local SG = game:GetService("StarterGui")
local SP = game:GetService("StarterPlayer")
local SoundService = game:GetService("SoundService")

local C = {
	Ink = Color3.fromRGB(16, 18, 30),
	InkSoft = Color3.fromRGB(34, 38, 58),
	Navy = Color3.fromRGB(30, 36, 62),
	NavyLight = Color3.fromRGB(46, 55, 90),
	NavyDeep = Color3.fromRGB(21, 25, 44),
	Cream = Color3.fromRGB(248, 244, 232),
	Muted = Color3.fromRGB(168, 178, 204),
	Green = Color3.fromRGB(88, 198, 98),
	GreenDark = Color3.fromRGB(52, 148, 70),
	Cyan = Color3.fromRGB(88, 198, 226),
	CyanDark = Color3.fromRGB(44, 140, 178),
	Amber = Color3.fromRGB(250, 196, 60),
	AmberDark = Color3.fromRGB(206, 142, 26),
	Purple = Color3.fromRGB(152, 98, 222),
	PurpleDark = Color3.fromRGB(104, 58, 168),
	Red = Color3.fromRGB(230, 88, 80),
	RedDark = Color3.fromRGB(176, 52, 48),
}
local FONTE = Enum.Font.FredokaOne

local function novo(classe: string, props: { [string]: any }, pai: Instance?): any
	local i = Instance.new(classe)
	for k, v in pairs(props) do
		(i :: any)[k] = v
	end
	i.Parent = pai
	return i
end
local function canto(p: Instance, r: number)
	novo("UICorner", { CornerRadius = UDim.new(0, r) }, p)
end
local function contorno(p: Instance, esp: number, cor: Color3?)
	return novo("UIStroke", {
		Thickness = esp,
		Color = cor or C.Ink,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		LineJoinMode = Enum.LineJoinMode.Round,
	}, p)
end
local function grad(p: Instance, a: Color3, b: Color3, rot: number?)
	novo("UIGradient", { Color = ColorSequence.new(a, b), Rotation = rot or 90 }, p)
end

-- ============================================================
-- 1. ReplicatedStorage.CrumbleArena.UI
-- ============================================================
local antigoRS = RS:FindFirstChild("CrumbleArena")
if antigoRS then
	antigoRS:Destroy()
end
local raiz = novo("Folder", { Name = "CrumbleArena" }, RS)
local pastaUI = novo("Folder", { Name = "UI" }, raiz)

-- O conteudo destes dois modulos vive versionado em src/client/UI/.
-- Se editar la, colar aqui tambem, ate a D-P01 fechar e o Rojo virar o caminho.
local cfg = novo("ModuleScript", { Name = "UIConfig" }, pastaUI)
cfg.Source = [==[
--!strict
local UIConfig = {}
UIConfig.Color = {
	Ink = Color3.fromRGB(16, 18, 30), InkSoft = Color3.fromRGB(34, 38, 58),
	Navy = Color3.fromRGB(30, 36, 62), NavyLight = Color3.fromRGB(46, 55, 90),
	NavyDeep = Color3.fromRGB(21, 25, 44), Cream = Color3.fromRGB(248, 244, 232),
	Muted = Color3.fromRGB(168, 178, 204),
	Green = Color3.fromRGB(88, 198, 98), GreenDark = Color3.fromRGB(52, 148, 70),
	Cyan = Color3.fromRGB(88, 198, 226), CyanDark = Color3.fromRGB(44, 140, 178),
	Amber = Color3.fromRGB(250, 196, 60), AmberDark = Color3.fromRGB(206, 142, 26),
	Purple = Color3.fromRGB(152, 98, 222), PurpleDark = Color3.fromRGB(104, 58, 168),
	Red = Color3.fromRGB(230, 88, 80), RedDark = Color3.fromRGB(176, 52, 48),
}
UIConfig.Stroke = { Button = 3, Panel = 4, Chip = 2 }
UIConfig.Corner = { Button = 12, Panel = 18, Chip = 8 }
UIConfig.ShadowOffset = 5
UIConfig.Font = Enum.Font.FredokaOne
UIConfig.MobileBreakpoint = 700
UIConfig.SafeAreaTop = 46
return UIConfig
]==]

local mock = novo("ModuleScript", { Name = "MockData" }, pastaUI)
mock.Source = [==[
--!strict
-- Dados falsos, so para a interface ter o que desenhar.
local MockData = {}
MockData.Cosmetics = {
	{ name = "Dust Trail", rarity = "Common", owned = true },
	{ name = "Frost Steps", rarity = "Rare", owned = false },
	{ name = "Crumble Aura", rarity = "Epic", owned = false },
	{ name = "Golden Pick", rarity = "Legendary", owned = false },
	{ name = "Leaf Burst", rarity = "Common", owned = true },
	{ name = "Stone Skin", rarity = "Rare", owned = false },
}
MockData.Gamepasses = {
	{ name = "VIP", blurb = "Badge, chat tag and a lobby emote", price = "TBD" },
	{ name = "2X COINS", blurb = "Double coins from every round", price = "TBD" },
	{ name = "EARLY MAPS", blurb = "Play new arenas one week early", price = "TBD" },
}
MockData.Leaderboard = {
	{ rank = 1, name = "PLAYER ONE", wins = 128, kos = 940 },
	{ rank = 2, name = "PLAYER TWO", wins = 117, kos = 902 },
	{ rank = 3, name = "PLAYER THREE", wins = 96, kos = 812 },
	{ rank = 4, name = "PLAYER FOUR", wins = 88, kos = 745 },
	{ rank = 5, name = "PLAYER FIVE", wins = 74, kos = 690 },
}
MockData.Maps = {
	{ name = "FROSTBREAK", votes = 0 },
	{ name = "SKY GARDEN", votes = 0 },
	{ name = "STONEFALL", votes = 0 },
}
return MockData
]==]

-- ============================================================
-- 2. SoundService
-- ============================================================
local grupo = SoundService:FindFirstChild("SFX")
if not grupo then
	grupo = novo("SoundGroup", { Name = "SFX", Volume = 1 }, SoundService)
end
local musica = SoundService:FindFirstChild("LobbyMusic")
if not musica then
	musica = novo("Sound", { Name = "LobbyMusic" }, SoundService)
end
local m = musica :: Sound
-- APM Music, biblioteca de producao licenciada e parceira oficial do Roblox.
-- Skip in Your Step (b), album Upbeat Acoustic, 125 s, instrumental sem voz.
m.SoundId = "rbxassetid://9038305339"
m.Looped = true
m.Volume = 0.16
m.Playing = false
m:SetAttribute("Nome", "Skip in Your Step (b)")
m:SetAttribute("AssetId", 9038305339)
m:SetAttribute("Criador", "APMOfficial")
m:SetAttribute("Duracao", "125 s")

-- ============================================================
-- 3. StarterGui.CrumbleUI
-- ============================================================
local antigo = SG:FindFirstChild("CrumbleUI")
if antigo then
	antigo:Destroy()
end

local gui = novo("ScreenGui", {
	Name = "CrumbleUI",
	ResetOnSpawn = false,
	IgnoreGuiInset = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
}, SG)
novo("UIScale", { Name = "GlobalScale", Scale = 1 }, gui)

-- ---------- botoes laterais ----------
local barra = novo("Frame", {
	Name = "SideButtons",
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 18, 0.5, 20),
	Size = UDim2.fromOffset(84, 380),
}, gui)
novo("UIListLayout", {
	FillDirection = Enum.FillDirection.Vertical,
	Padding = UDim.new(0, 12),
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
}, barra)

-- Icone desenhado com Frame, sem depender de imagem externa.
local function icone(pai: Instance, tipo: string, cor: Color3)
	local h = novo("Frame", {
		Name = "Icon",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.4),
		Size = UDim2.fromOffset(34, 34),
		ZIndex = 4,
	}, pai)
	if tipo == "cosmetics" then
		local d = novo("Frame", {
			Name = "Gem", BackgroundColor3 = cor, ZIndex = 4, Rotation = 45,
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(21, 21),
		}, h)
		canto(d, 4)
		contorno(d, 2.5)
		local s = novo("Frame", {
			Name = "Spark", BackgroundColor3 = cor, ZIndex = 4, Rotation = 45,
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.82, 0.2),
			Size = UDim2.fromOffset(9, 9),
		}, h)
		canto(s, 2)
		contorno(s, 2)
	elseif tipo == "gamepasses" then
		local t = novo("Frame", {
			Name = "Tag", BackgroundColor3 = cor, ZIndex = 4, Rotation = -12,
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(30, 22),
		}, h)
		canto(t, 5)
		contorno(t, 2.5)
		local furo = novo("Frame", {
			Name = "Hole", BackgroundColor3 = C.Ink, ZIndex = 5,
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.24, 0.5),
			Size = UDim2.fromOffset(7, 7),
		}, t)
		canto(furo, 4)
	elseif tipo == "leaderboard" then
		local alturas = { 15, 24, 11 }
		for i = 1, 3 do
			local b = novo("Frame", {
				Name = "Bar" .. i, BackgroundColor3 = cor, ZIndex = 4,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0, (i - 2) * 11 + 17, 1, -2),
				Size = UDim2.fromOffset(9, alturas[i]),
			}, h)
			canto(b, 3)
			contorno(b, 2)
		end
	elseif tipo == "settings" then
		for i = 1, 3 do
			local l = novo("Frame", {
				Name = "Line" .. i, BackgroundColor3 = cor, ZIndex = 4,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0, i * 9 + 2),
				Size = UDim2.fromOffset(28, 5),
			}, h)
			canto(l, 3)
			contorno(l, 2)
			local k = novo("Frame", {
				Name = "Knob" .. i, BackgroundColor3 = C.Cream, ZIndex = 5,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(i == 2 and 0.72 or (i == 1 and 0.3 or 0.55), 0, 0.5, 0),
				Size = UDim2.fromOffset(9, 9),
			}, l)
			canto(k, 5)
			contorno(k, 2)
		end
	end
end

local BOTOES = {
	{ id = "Cosmetics", rotulo = "SKINS", claro = C.Cyan, escuro = C.CyanDark, ic = "cosmetics" },
	{ id = "Gamepasses", rotulo = "PASSES", claro = C.Purple, escuro = C.PurpleDark, ic = "gamepasses" },
	{ id = "Leaderboard", rotulo = "RANKS", claro = C.Amber, escuro = C.AmberDark, ic = "leaderboard" },
	{ id = "Settings", rotulo = "SETUP", claro = C.Green, escuro = C.GreenDark, ic = "settings" },
}
for i, b in ipairs(BOTOES) do
	local slot = novo("Frame", {
		Name = "Slot_" .. b.id, BackgroundTransparency = 1,
		Size = UDim2.fromOffset(84, 84), LayoutOrder = i,
	}, barra)
	local sombra = novo("Frame", {
		Name = "Shadow", BackgroundColor3 = C.Ink, BackgroundTransparency = 0.35,
		Position = UDim2.fromOffset(0, 5), Size = UDim2.fromOffset(76, 76), ZIndex = 1,
	}, slot)
	canto(sombra, 14)
	local btn = novo("TextButton", {
		Name = "Button", Text = "", AutoButtonColor = false,
		BackgroundColor3 = b.claro, Size = UDim2.fromOffset(76, 76), ZIndex = 2,
	}, slot)
	canto(btn, 14)
	contorno(btn, 3)
	grad(btn, b.claro, b.escuro)
	local brilho = novo("Frame", {
		Name = "Gloss", BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.75,
		Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 0, 22), ZIndex = 3,
	}, btn)
	canto(brilho, 9)
	icone(btn, b.ic, C.Cream)
	local rot = novo("TextLabel", {
		Name = "Label", BackgroundTransparency = 1, Text = b.rotulo,
		Font = FONTE, TextColor3 = C.Cream, TextSize = 14, ZIndex = 4,
		AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -8),
		Size = UDim2.new(1, -10, 0, 16),
	}, btn)
	contorno(rot, 2)
	btn:SetAttribute("PanelId", b.id)
end

-- ---------- HUD de preview ----------
local hud = novo("Frame", {
	Name = "TopHud", BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 12),
	Size = UDim2.fromOffset(300, 118), ZIndex = 2,
}, gui)
local chipSombra = novo("Frame", {
	Name = "ChipShadow", BackgroundColor3 = C.Ink, BackgroundTransparency = 0.35,
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 5),
	Size = UDim2.fromOffset(228, 38), ZIndex = 1,
}, hud)
canto(chipSombra, 12)
local chip = novo("Frame", {
	Name = "StatusChip", BackgroundColor3 = C.Navy,
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0),
	Size = UDim2.fromOffset(228, 38), ZIndex = 2,
}, hud)
canto(chip, 12)
contorno(chip, 3)
local pip = novo("Frame", {
	Name = "Pip", BackgroundColor3 = C.Cyan, AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(11, 11), ZIndex = 3,
}, chip)
canto(pip, 6)
contorno(pip, 2)
contorno(novo("TextLabel", {
	Name = "StatusText", BackgroundTransparency = 1, Text = "INTERMISSION",
	Font = FONTE, TextColor3 = C.Cream, TextSize = 19, ZIndex = 3,
	Position = UDim2.new(0, 30, 0, 0), Size = UDim2.new(1, -40, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Left,
}, chip), 2)

local relSombra = novo("Frame", {
	Name = "TimerShadow", BackgroundColor3 = C.Ink, BackgroundTransparency = 0.35,
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 51),
	Size = UDim2.fromOffset(150, 56), ZIndex = 1,
}, hud)
canto(relSombra, 14)
local relogio = novo("Frame", {
	Name = "TimerBox", BackgroundColor3 = C.NavyDeep,
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 46),
	Size = UDim2.fromOffset(150, 56), ZIndex = 2,
}, hud)
canto(relogio, 14)
contorno(relogio, 3)
contorno(novo("TextLabel", {
	Name = "TimerText", BackgroundTransparency = 1, Text = "0:45",
	Font = FONTE, TextColor3 = C.Amber, TextSize = 38, ZIndex = 3,
	Size = UDim2.fromScale(1, 1),
}, relogio), 2.5)

local vivos = novo("Frame", {
	Name = "AliveChip", BackgroundColor3 = C.Navy, Visible = false,
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 14),
	Size = UDim2.fromOffset(122, 40), ZIndex = 2,
}, gui)
canto(vivos, 12)
contorno(vivos, 3)
local vpip = novo("Frame", {
	Name = "Pip", BackgroundColor3 = C.Green, AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(11, 11), ZIndex = 3,
}, vivos)
canto(vpip, 6)
contorno(vpip, 2)
contorno(novo("TextLabel", {
	Name = "AliveText", BackgroundTransparency = 1, Text = "ALIVE  8",
	Font = FONTE, TextColor3 = C.Cream, TextSize = 18, ZIndex = 3,
	Position = UDim2.new(0, 30, 0, 0), Size = UDim2.new(1, -38, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Left,
}, vivos), 2)

local function faixa(nome: string, texto: string, cor: Color3)
	local f = novo("Frame", {
		Name = nome, BackgroundColor3 = cor, Visible = false,
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -60),
		Size = UDim2.fromOffset(360, 62), ZIndex = 6,
	}, gui)
	canto(f, 14)
	contorno(f, 4)
	contorno(novo("TextLabel", {
		Name = "Text", BackgroundTransparency = 1, Text = texto, Font = FONTE,
		TextColor3 = C.Cream, TextSize = 30, ZIndex = 7, Size = UDim2.fromScale(1, 1),
	}, f), 3)
end
faixa("SpectatingBanner", "SPECTATING", C.Navy)
faixa("EliminatedBanner", "ELIMINATED", C.Red)

novo("TextButton", {
	Name = "Scrim", Text = "", AutoButtonColor = false, BackgroundColor3 = C.Ink,
	BackgroundTransparency = 0.45, Visible = false, Size = UDim2.fromScale(1, 1),
	ZIndex = 8, Modal = true,
}, gui)
local painesRaiz = novo("Frame", {
	Name = "Panels", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 9,
}, gui)

-- ---------- moldura comum de painel ----------
local function botao(pai: Instance, nome: string, texto: string, larg: number, alt: number, claro: Color3, escuro: Color3, ordem: number?)
	local slot = novo("Frame", {
		Name = nome .. "Slot", BackgroundTransparency = 1,
		Size = UDim2.fromOffset(larg, alt + 5), LayoutOrder = ordem or 1, ZIndex = 11,
	}, pai)
	local s = novo("Frame", {
		Name = "Shadow", BackgroundColor3 = C.Ink, BackgroundTransparency = 0.3,
		Position = UDim2.fromOffset(0, 5), Size = UDim2.fromOffset(larg, alt), ZIndex = 11,
	}, slot)
	canto(s, 11)
	local b = novo("TextButton", {
		Name = nome, Text = "", AutoButtonColor = false, BackgroundColor3 = claro,
		Size = UDim2.fromOffset(larg, alt), ZIndex = 12,
	}, slot)
	canto(b, 11)
	contorno(b, 3)
	grad(b, claro, escuro)
	local g = novo("Frame", {
		Name = "Gloss", BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.78,
		Position = UDim2.fromOffset(5, 5), Size = UDim2.new(1, -10, 0, math.max(10, alt * 0.34)), ZIndex = 13,
	}, b)
	canto(g, 8)
	contorno(novo("TextLabel", {
		Name = "Text", BackgroundTransparency = 1, Text = texto, Font = FONTE,
		TextColor3 = C.Cream, TextSize = math.min(22, alt * 0.42), ZIndex = 14,
		Size = UDim2.fromScale(1, 1),
	}, b), 2.5)
	return b, slot
end

local function painel(id: string, titulo: string, larg: number, alt: number, corTitulo: Color3)
	local p = novo("Frame", {
		Name = "Panel_" .. id, BackgroundTransparency = 1, Visible = false,
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(larg, alt), ZIndex = 10,
	}, painesRaiz)
	local s = novo("Frame", {
		Name = "Shadow", BackgroundColor3 = C.Ink, BackgroundTransparency = 0.3,
		Position = UDim2.fromOffset(0, 8), Size = UDim2.fromScale(1, 1), ZIndex = 9,
	}, p)
	canto(s, 20)
	local corpo = novo("Frame", { Name = "Body", BackgroundColor3 = C.Navy, Size = UDim2.fromScale(1, 1), ZIndex = 10 }, p)
	canto(corpo, 20)
	contorno(corpo, 4)
	grad(corpo, C.NavyLight, C.NavyDeep)
	local barraT = novo("Frame", {
		Name = "TitleBar", BackgroundColor3 = corTitulo,
		Size = UDim2.new(1, -20, 0, 52), Position = UDim2.fromOffset(10, 10), ZIndex = 11,
	}, corpo)
	canto(barraT, 13)
	contorno(barraT, 3)
	grad(barraT, corTitulo, corTitulo:Lerp(C.Ink, 0.38))
	contorno(novo("TextLabel", {
		Name = "Title", BackgroundTransparency = 1, Text = titulo, Font = FONTE,
		TextColor3 = C.Cream, TextSize = 26, ZIndex = 12,
		Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -80, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, barraT), 2.5)
	local fechar = novo("TextButton", {
		Name = "Close", Text = "X", AutoButtonColor = false, Font = FONTE,
		TextColor3 = C.Cream, TextSize = 22, BackgroundColor3 = C.Red,
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -9, 0.5, 0),
		Size = UDim2.fromOffset(36, 36), ZIndex = 13,
	}, barraT)
	canto(fechar, 10)
	contorno(fechar, 3)
	grad(fechar, C.Red, C.RedDark)
	local conteudo = novo("Frame", {
		Name = "Content", BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 72), Size = UDim2.new(1, -28, 1, -110), ZIndex = 11,
	}, corpo)
	return p, conteudo, corpo
end

local function rodape(corpo: Instance, texto: string)
	novo("TextLabel", {
		Name = "Note", BackgroundTransparency = 1, Text = texto, Font = FONTE,
		TextColor3 = C.Muted, TextSize = 13, ZIndex = 12,
		AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -12),
		Size = UDim2.new(1, -28, 0, 18),
	}, corpo)
end

-- ---------- COSMETICS ----------
do
	local _, conteudo, corpo = painel("Cosmetics", "COSMETICS", 640, 358, C.Cyan)
	local grade = novo("ScrollingFrame", {
		Name = "Grid", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 11,
		ScrollBarThickness = 6, ScrollBarImageColor3 = C.Cyan, CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, BorderSizePixel = 0,
	}, conteudo)
	novo("UIGridLayout", {
		CellSize = UDim2.fromOffset(192, 104), CellPadding = UDim2.fromOffset(12, 10),
		HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
	}, grade)
	novo("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8) }, grade)
	local itens = {
		{ "DUST TRAIL", "COMMON", C.Muted, true },
		{ "FROST STEPS", "RARE", C.Cyan, false },
		{ "CRUMBLE AURA", "EPIC", C.Purple, false },
		{ "GOLDEN PICK", "LEGENDARY", C.Amber, false },
		{ "LEAF BURST", "COMMON", C.Muted, true },
		{ "STONE SKIN", "RARE", C.Cyan, false },
	}
	for i, it in ipairs(itens) do
		local card = novo("Frame", { Name = "Item_" .. i, BackgroundColor3 = C.NavyDeep, LayoutOrder = i, ZIndex = 12 }, grade)
		canto(card, 12)
		contorno(card, 3)
		local faixaR = novo("Frame", {
			Name = "Rarity", BackgroundColor3 = it[3] :: Color3,
			Size = UDim2.new(1, -14, 0, 6), Position = UDim2.fromOffset(7, 7), ZIndex = 13,
		}, card)
		canto(faixaR, 3)
		contorno(novo("TextLabel", {
			Name = "Name", BackgroundTransparency = 1, Text = it[1] :: string, Font = FONTE,
			TextColor3 = C.Cream, TextSize = 18, ZIndex = 13,
			Position = UDim2.fromOffset(10, 20), Size = UDim2.new(1, -20, 0, 24),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, card), 2)
		novo("TextLabel", {
			Name = "Rar", BackgroundTransparency = 1, Text = it[2] :: string, Font = FONTE,
			TextColor3 = it[3] :: Color3, TextSize = 13, ZIndex = 13,
			Position = UDim2.fromOffset(10, 44), Size = UDim2.new(1, -20, 0, 16),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, card)
		local dono = it[4] :: boolean
		local _, slot = botao(card, "Action", dono and "EQUIPPED" or "LOCKED", 168, 32, dono and C.Green or C.InkSoft, dono and C.GreenDark or C.Ink, 1)
		slot.Position = UDim2.fromOffset(11, 62)
	end
	rodape(corpo, "Preview only. Nothing is purchasable yet.")
end

-- ---------- GAMEPASSES ----------
do
	local _, conteudo, corpo = painel("Gamepasses", "GAMEPASSES", 620, 402, C.Purple)
	local lista = novo("Frame", { Name = "List", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 11 }, conteudo)
	novo("UIListLayout", {
		Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	}, lista)
	local passes = {
		{ "VIP", "Badge, chat tag and a lobby emote" },
		{ "2X COINS", "Double coins from every round" },
		{ "EARLY MAPS", "Play new arenas one week early" },
	}
	for i, gp in ipairs(passes) do
		local linha = novo("Frame", {
			Name = "Pass_" .. i, BackgroundColor3 = C.NavyDeep,
			Size = UDim2.new(1, -6, 0, 84), LayoutOrder = i, ZIndex = 12,
		}, lista)
		canto(linha, 13)
		contorno(linha, 3)
		local selo = novo("Frame", {
			Name = "Badge", BackgroundColor3 = C.Purple,
			Position = UDim2.fromOffset(12, 14), Size = UDim2.fromOffset(56, 56), ZIndex = 13,
		}, linha)
		canto(selo, 11)
		contorno(selo, 3)
		grad(selo, C.Purple, C.PurpleDark)
		novo("TextLabel", {
			Name = "R", BackgroundTransparency = 1, Text = "R$", Font = FONTE,
			TextColor3 = C.Amber, TextSize = 24, ZIndex = 14, Size = UDim2.fromScale(1, 1),
		}, selo)
		contorno(novo("TextLabel", {
			Name = "Name", BackgroundTransparency = 1, Text = gp[1], Font = FONTE,
			TextColor3 = C.Cream, TextSize = 22, ZIndex = 13,
			Position = UDim2.fromOffset(82, 16), Size = UDim2.new(1, -260, 0, 26),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, linha), 2)
		novo("TextLabel", {
			Name = "Blurb", BackgroundTransparency = 1, Text = gp[2], Font = FONTE,
			TextColor3 = C.Muted, TextSize = 14, ZIndex = 13,
			Position = UDim2.fromOffset(82, 44), Size = UDim2.new(1, -260, 0, 20),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, linha)
		local _, slot = botao(linha, "Buy", "PRICE TBD", 150, 42, C.InkSoft, C.Ink, 1)
		slot.AnchorPoint = Vector2.new(1, 0.5)
		slot.Position = UDim2.new(1, -14, 0.5, 0)
	end
	rodape(corpo, "MarketplaceService is not wired. These are placeholders.")
end

-- ---------- LEADERBOARD ----------
do
	local _, conteudo, corpo = painel("Leaderboard", "LEADERBOARD", 600, 400, C.Amber)
	local cab = novo("Frame", {
		Name = "Header", BackgroundColor3 = C.Ink, BackgroundTransparency = 0.35,
		Size = UDim2.new(1, 0, 0, 32), ZIndex = 12,
	}, conteudo)
	canto(cab, 9)
	for _, col in ipairs({ { "#", 0, 46 }, { "PLAYER", 52, 250 }, { "WINS", 320, 100 }, { "KOs", 428, 110 } }) do
		novo("TextLabel", {
			Name = "H_" .. (col[1] :: string), BackgroundTransparency = 1, Text = col[1] :: string,
			Font = FONTE, TextColor3 = C.Muted, TextSize = 15, ZIndex = 13,
			Position = UDim2.fromOffset((col[2] :: number) + 12, 0), Size = UDim2.fromOffset(col[3] :: number, 32),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, cab)
	end
	local linhas = {
		{ 1, "PLAYER ONE", 128, 940 }, { 2, "PLAYER TWO", 117, 902 }, { 3, "PLAYER THREE", 96, 812 },
		{ 4, "PLAYER FOUR", 88, 745 }, { 5, "PLAYER FIVE", 74, 690 },
	}
	local medalhas = { C.Amber, Color3.fromRGB(196, 202, 214), Color3.fromRGB(198, 128, 72) }
	for i, l in ipairs(linhas) do
		local linha = novo("Frame", {
			Name = "Row_" .. i, BackgroundColor3 = C.NavyDeep,
			BackgroundTransparency = (i % 2 == 0) and 0.35 or 0,
			Position = UDim2.fromOffset(0, 38 + (i - 1) * 50), Size = UDim2.new(1, 0, 0, 44), ZIndex = 12,
		}, conteudo)
		canto(linha, 10)
		contorno(linha, i <= 3 and 2.5 or 2, medalhas[i] or C.Ink)
		local sel = novo("Frame", {
			Name = "Rank", BackgroundColor3 = medalhas[i] or C.InkSoft,
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
			Size = UDim2.fromOffset(32, 32), ZIndex = 13,
		}, linha)
		canto(sel, 8)
		contorno(sel, 2.5)
		novo("TextLabel", {
			BackgroundTransparency = 1, Text = tostring(l[1]), Font = FONTE,
			TextColor3 = i <= 3 and C.Ink or C.Cream, TextSize = 18, ZIndex = 14, Size = UDim2.fromScale(1, 1),
		}, sel)
		novo("TextLabel", {
			Name = "Name", BackgroundTransparency = 1, Text = l[2] :: string, Font = FONTE,
			TextColor3 = C.Cream, TextSize = 18, ZIndex = 13, Position = UDim2.fromOffset(64, 0),
			Size = UDim2.fromOffset(250, 44), TextXAlignment = Enum.TextXAlignment.Left,
		}, linha)
		novo("TextLabel", {
			Name = "Wins", BackgroundTransparency = 1, Text = tostring(l[3]), Font = FONTE,
			TextColor3 = C.Green, TextSize = 18, ZIndex = 13, Position = UDim2.fromOffset(332, 0),
			Size = UDim2.fromOffset(100, 44), TextXAlignment = Enum.TextXAlignment.Left,
		}, linha)
		novo("TextLabel", {
			Name = "Kos", BackgroundTransparency = 1, Text = tostring(l[4]), Font = FONTE,
			TextColor3 = C.Cyan, TextSize = 18, ZIndex = 13, Position = UDim2.fromOffset(440, 0),
			Size = UDim2.fromOffset(110, 44), TextXAlignment = Enum.TextXAlignment.Left,
		}, linha)
	end
	rodape(corpo, "Sample data. No DataStore is connected.")
end

-- ---------- SETTINGS ----------
do
	local _, conteudo, corpo = painel("Settings", "SETTINGS", 540, 392, C.Green)
	local function chave(nome: string, rotulo: string, y: number, ligado: boolean)
		local linha = novo("Frame", {
			Name = nome, BackgroundColor3 = C.NavyDeep,
			Position = UDim2.fromOffset(0, y), Size = UDim2.new(1, 0, 0, 54), ZIndex = 12,
		}, conteudo)
		canto(linha, 11)
		contorno(linha, 3)
		novo("TextLabel", {
			Name = "Label", BackgroundTransparency = 1, Text = rotulo, Font = FONTE,
			TextColor3 = C.Cream, TextSize = 19, ZIndex = 13, Position = UDim2.fromOffset(16, 0),
			Size = UDim2.new(1, -140, 1, 0), TextXAlignment = Enum.TextXAlignment.Left,
		}, linha)
		local trilho = novo("TextButton", {
			Name = "Toggle", Text = "", AutoButtonColor = false,
			BackgroundColor3 = ligado and C.Green or C.InkSoft, AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(84, 36), ZIndex = 13,
		}, linha)
		canto(trilho, 18)
		contorno(trilho, 3)
		local knob = novo("Frame", {
			Name = "Knob", BackgroundColor3 = C.Cream, AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(ligado and 0.72 or 0.28, 0, 0.5, 0), Size = UDim2.fromOffset(26, 26), ZIndex = 14,
		}, trilho)
		canto(knob, 13)
		contorno(knob, 2.5)
		trilho:SetAttribute("On", ligado)
	end
	chave("MusicRow", "MUSIC", 0, true)
	chave("SfxRow", "SOUND EFFECTS", 64, true)

	local prev = novo("Frame", {
		Name = "HudPreview", BackgroundColor3 = C.NavyDeep,
		Position = UDim2.fromOffset(0, 132), Size = UDim2.new(1, 0, 0, 118), ZIndex = 12,
	}, conteudo)
	canto(prev, 11)
	contorno(prev, 3)
	novo("TextLabel", {
		Name = "Label", BackgroundTransparency = 1, Text = "HUD PREVIEW", Font = FONTE,
		TextColor3 = C.Amber, TextSize = 16, ZIndex = 13, Position = UDim2.fromOffset(16, 8),
		Size = UDim2.new(1, -32, 0, 22), TextXAlignment = Enum.TextXAlignment.Left,
	}, prev)
	novo("TextLabel", {
		Name = "Hint", BackgroundTransparency = 1,
		Text = "No round system yet. These only change the HUD.", Font = FONTE,
		TextColor3 = C.Muted, TextSize = 12, ZIndex = 13, Position = UDim2.fromOffset(16, 28),
		Size = UDim2.new(1, -32, 0, 18), TextXAlignment = Enum.TextXAlignment.Left,
	}, prev)
	local fila = novo("Frame", {
		Name = "States", BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 52), Size = UDim2.new(1, -28, 0, 56), ZIndex = 13,
	}, prev)
	novo("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Left,
	}, fila)
	local estados = {
		{ "Intermission", "WAIT", C.Cyan, C.CyanDark }, { "MapVote", "VOTE", C.Amber, C.AmberDark },
		{ "Starting", "START", C.Green, C.GreenDark }, { "Spectating", "SPEC", C.Purple, C.PurpleDark },
		{ "Eliminated", "OUT", C.Red, C.RedDark },
	}
	for i, e in ipairs(estados) do
		local b = botao(fila, "State_" .. (e[1] :: string), e[2] :: string, 88, 40, e[3] :: Color3, e[4] :: Color3, i)
		b:SetAttribute("HudState", e[1])
	end
	rodape(corpo, "Settings are not saved between sessions yet.")
end

-- ---------- COMING SOON ----------
do
	local p = novo("Frame", {
		Name = "Panel_ComingSoon", BackgroundTransparency = 1, Visible = false,
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(430, 250), ZIndex = 10,
	}, painesRaiz)
	local s = novo("Frame", {
		Name = "Shadow", BackgroundColor3 = C.Ink, BackgroundTransparency = 0.3,
		Position = UDim2.fromOffset(0, 8), Size = UDim2.fromScale(1, 1), ZIndex = 9,
	}, p)
	canto(s, 20)
	local corpo = novo("Frame", { Name = "Body", BackgroundColor3 = C.Navy, Size = UDim2.fromScale(1, 1), ZIndex = 10 }, p)
	canto(corpo, 20)
	contorno(corpo, 4)
	grad(corpo, C.NavyLight, C.NavyDeep)
	for i = 1, 3 do
		novo("Frame", {
			Name = "Crack_" .. i, BackgroundColor3 = C.Ink, BackgroundTransparency = 0.72,
			Position = UDim2.fromOffset(24 + (i - 1) * 150, 0), Size = UDim2.fromOffset(3, 30),
			Rotation = 12 - i * 9, ZIndex = 11,
		}, corpo)
	end
	novo("TextLabel", {
		Name = "Area", BackgroundTransparency = 1, Text = "TRAINING", Font = FONTE,
		TextColor3 = C.Amber, TextSize = 18, ZIndex = 12, Position = UDim2.fromOffset(0, 34),
		Size = UDim2.new(1, 0, 0, 22),
	}, corpo)
	contorno(novo("TextLabel", {
		Name = "Title", BackgroundTransparency = 1, Text = "COMING SOON", Font = FONTE,
		TextColor3 = C.Cream, TextSize = 40, ZIndex = 12,
		Position = UDim2.fromOffset(0, 62), Size = UDim2.new(1, 0, 0, 48),
	}, corpo), 3)
	novo("TextLabel", {
		Name = "Body", BackgroundTransparency = 1, Text = "This area is still being built.",
		Font = FONTE, TextColor3 = C.Muted, TextSize = 19, ZIndex = 12,
		Position = UDim2.fromOffset(24, 118), Size = UDim2.new(1, -48, 0, 30), TextWrapped = true,
	}, corpo)
	local _, slot = botao(corpo, "GotIt", "GOT IT", 190, 52, C.Green, C.GreenDark, 1)
	slot.AnchorPoint = Vector2.new(0.5, 1)
	slot.Position = UDim2.new(0.5, 0, 1, -22)
end

-- ============================================================
-- 4. UIController
-- ============================================================
-- A fonte canonica esta em src/client/Controllers/UIController.client.luau.
-- Este script nao a duplica. Ele avisa se o controller estiver faltando.
local sps = SP:WaitForChild("StarterPlayerScripts")
local ctrl = sps:FindFirstChild("UIController")
local avisoController = ctrl and "UIController ja existe, nao foi tocado"
	or "FALTA o UIController. Copiar src/client/Controllers/UIController.client.luau para StarterPlayer.StarterPlayerScripts como LocalScript chamado UIController."

print(string.format(
	"[BuildLobbyUI] pronto. CrumbleUI com %d descendentes, %d paineis. %s",
	#gui:GetDescendants(),
	#painesRaiz:GetChildren(),
	avisoController
))

return {
	descendentes = #gui:GetDescendants(),
	paineis = #painesRaiz:GetChildren(),
	controller = avisoController,
}
