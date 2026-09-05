--!strict
-- ArenaConfig.lua
-- Configurações visuais e estruturais da arena procedural.

local ArenaConfig = {}

ArenaConfig.Layers = 3
ArenaConfig.GridSize = 17
ArenaConfig.TileSize = 6
ArenaConfig.TileHeight = 1
ArenaConfig.LayerHeight = 18

-- Raio (em "células do grid") usado para arredondar a arena.
-- Tiles cuja distância ao centro do grid for maior que este valor são removidos.
ArenaConfig.RoundRadius = 8.4

-- Estilo visual de cada camada (de cima para baixo).
ArenaConfig.LayerStyles = {
	[1] = {
		Color = Color3.fromRGB(218, 232, 245),
		Material = Enum.Material.SmoothPlastic,
		BorderColor = Color3.fromRGB(150, 190, 220),
	},
	[2] = {
		Color = Color3.fromRGB(120, 150, 180),
		Material = Enum.Material.SmoothPlastic,
		BorderColor = Color3.fromRGB(80, 110, 140),
	},
	[3] = {
		Color = Color3.fromRGB(70, 78, 92),
		Material = Enum.Material.Slate,
		BorderColor = Color3.fromRGB(40, 45, 55),
	},
}

ArenaConfig.BlockBreakTweenTime = 0.18
ArenaConfig.BlockShrinkScale = 0.6

ArenaConfig.MaxSpawnPoints = 8

return ArenaConfig
