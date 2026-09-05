--!strict
-- Paleta e medidas da interface do Crumble Arena.
-- Sem logica e sem API do Roblox alem de Color3, para poder ser lido em teste puro.
--
-- Copia versionada. A instancia viva fica em ReplicatedStorage.CrumbleArena.UI.UIConfig
-- dentro do place. Ver D-017 em docs/DECISIONS.md.

local UIConfig = {}

UIConfig.Color = {
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

-- contorno grosso e canto arredondado sao a assinatura da interface
UIConfig.Stroke = { Button = 3, Panel = 4, Chip = 2 }
UIConfig.Corner = { Button = 12, Panel = 18, Chip = 8 }
-- a sombra e uma copia escura deslocada, nao um gradiente
UIConfig.ShadowOffset = 5

UIConfig.Font = Enum.Font.FredokaOne

-- abaixo desta largura de tela o layout vira coluna unica
UIConfig.MobileBreakpoint = 700
UIConfig.SafeAreaTop = 46

return UIConfig
