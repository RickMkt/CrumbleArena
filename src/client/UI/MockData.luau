--!strict
-- Dados falsos, so para a interface ter o que desenhar.
-- Nenhum destes numeros vem de DataStore, compra ou partida real.
--
-- Copia versionada. A instancia viva fica em ReplicatedStorage.CrumbleArena.UI.MockData
-- dentro do place. Ver D-017 em docs/DECISIONS.md.

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
