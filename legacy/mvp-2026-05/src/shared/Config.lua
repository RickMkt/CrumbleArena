--!strict
-- Config.lua
-- Configurações globais centrais do Crumble Arena.

local Config = {}

Config.GameName = "Crumble Arena"
Config.ModeName = "Snowball Classic"

Config.MinimumPlayers = 2
Config.MaxPlayers = 8

Config.IntermissionTime = 15
Config.PreRoundCountdown = 5
Config.RoundTime = 180
Config.PostRoundTime = 6
Config.PostMatchTime = 10
Config.RespawnToLobbyDelay = 3

Config.RoundsPerMatch = 3
Config.EnableTieBreaker = true
Config.MaxTieBreakerRounds = 3

Config.ArenaCenter = Vector3.new(0, 80, 0)
Config.LobbyCenter = Vector3.new(0, 10, 180)

Config.KillZoneOffsetBelowLastLayer = 35

Config.CollapseTimeStart = 45
Config.EnableCollapseTime = false

Config.SpectatorPlatformOffset = Vector3.new(80, 30, 0)

return Config
