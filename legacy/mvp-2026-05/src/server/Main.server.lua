--!strict
-- Main.server.lua
-- Ponto de entrada do servidor Crumble Arena.
-- Carrega os shared remotes e inicializa todos os services na ordem correta.

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)

local services = script.Parent:WaitForChild("services")
local LobbyService = require(services.LobbyService)
local ArenaService = require(services.ArenaService)
local PlayerRoundService = require(services.PlayerRoundService)
local SpectatorService = require(services.SpectatorService)
local ProjectileService = require(services.ProjectileService)
local MatchService = require(services.MatchService)

-- garante que o nível de queda do mundo não destrói o personagem antes da kill zone
Workspace.FallenPartsDestroyHeight = -500

-- inicializa remotes (cria a pasta CrumbleArenaRemotes em ReplicatedStorage)
Remotes.init()

-- ordem de inicialização importa: lobby/arena criam containers no Workspace
LobbyService.init()
ArenaService.destroy() -- garante estado limpo no boot
SpectatorService.init()
PlayerRoundService.init()
ProjectileService.init({
	getRoundState = function()
		return MatchService.getRoundState()
	end,
})
MatchService.init()

-- inicia o loop de partidas
MatchService.start()

print("[CrumbleArena] Server initialized.")
