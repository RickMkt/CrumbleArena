--!strict
-- PlayerRoundService.lua
-- Mantém o estado por jogador na partida (alive / eliminated / wins / inMatch)
-- e dispara sinais usados pelo RoundService.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Config = require(Shared.Config)
local Signal = require(Utils.Signal)
local TableUtil = require(Utils.TableUtil)

local services = script.Parent
local ArenaService = require(services.ArenaService)

local PlayerRoundService = {}

type PlayerData = {
	player: Player,
	alive: boolean,
	eliminated: boolean,
	roundWins: number,
	inMatch: boolean,
	lastEliminationDebounce: number,
}

local data: { [number]: PlayerData } = {}

PlayerRoundService.PlayerEliminated = Signal.new()
PlayerRoundService.PlayerJoinedMatch = Signal.new()
PlayerRoundService.PlayerLeftMatch = Signal.new()
PlayerRoundService.AliveCountChanged = Signal.new()

local function ensureEntry(player: Player): PlayerData
	local entry = data[player.UserId]
	if entry then
		return entry
	end
	entry = {
		player = player,
		alive = false,
		eliminated = true,
		roundWins = 0,
		inMatch = false,
		lastEliminationDebounce = 0,
	}
	data[player.UserId] = entry
	return entry
end

function PlayerRoundService.init()
	Players.PlayerAdded:Connect(function(player)
		player:SetAttribute("Spectating", false)
		ensureEntry(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		local entry = data[player.UserId]
		if entry and entry.alive then
			entry.alive = false
			entry.eliminated = true
			PlayerRoundService.PlayerEliminated:Fire(player, "left")
			PlayerRoundService.AliveCountChanged:Fire(PlayerRoundService.getAliveCount())
		end
		data[player.UserId] = nil
		PlayerRoundService.PlayerLeftMatch:Fire(player)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		player:SetAttribute("Spectating", false)
		ensureEntry(player)
	end
end

function PlayerRoundService.getEntry(player: Player): PlayerData
	return ensureEntry(player)
end

function PlayerRoundService.getAllEntries(): { PlayerData }
	return TableUtil.values(data)
end

function PlayerRoundService.getAliveEntries(): { PlayerData }
	return TableUtil.filter(TableUtil.values(data), function(entry)
		return entry.alive == true
	end)
end

function PlayerRoundService.getAliveCount(): number
	return #PlayerRoundService.getAliveEntries()
end

function PlayerRoundService.getInMatchEntries(): { PlayerData }
	return TableUtil.filter(TableUtil.values(data), function(entry)
		return entry.inMatch == true
	end)
end

function PlayerRoundService.isAlive(player: Player): boolean
	local entry = data[player.UserId]
	return entry ~= nil and entry.alive
end

function PlayerRoundService.getRoundWins(player: Player): number
	local entry = data[player.UserId]
	return entry and entry.roundWins or 0
end

-- Inicia uma nova partida: zera vitórias e marca quem está participando agora.
function PlayerRoundService.beginMatch(participants: { Player })
	for _, entry in pairs(data) do
		entry.inMatch = false
		entry.alive = false
		entry.eliminated = true
		entry.roundWins = 0
		entry.player:SetAttribute("Spectating", true)
	end
	for _, player in ipairs(participants) do
		local entry = ensureEntry(player)
		entry.inMatch = true
		player:SetAttribute("Spectating", false)
		PlayerRoundService.PlayerJoinedMatch:Fire(player)
	end
end

function PlayerRoundService.endMatch()
	for _, entry in pairs(data) do
		entry.inMatch = false
		entry.alive = false
		entry.eliminated = true
		entry.player:SetAttribute("Spectating", false)
	end
end

-- Reset usado entre rounds: revive todos que ainda estão na partida.
function PlayerRoundService.beginRound()
	for _, entry in pairs(data) do
		if entry.inMatch then
			entry.alive = true
			entry.eliminated = false
			entry.lastEliminationDebounce = 0
			entry.player:SetAttribute("Spectating", false)
		else
			entry.alive = false
			entry.eliminated = true
			entry.player:SetAttribute("Spectating", true)
		end
	end
	PlayerRoundService.AliveCountChanged:Fire(PlayerRoundService.getAliveCount())
end

function PlayerRoundService.endRound()
	for _, entry in pairs(data) do
		if entry.inMatch then
			entry.alive = false
		end
	end
end

-- Marca jogador como eliminado. Usa debounce para evitar dupla-eliminação por
-- múltiplos eventos (ex.: kill zone + queda + sair do jogo).
function PlayerRoundService.eliminate(player: Player, reason: string?)
	local entry = data[player.UserId]
	if not entry or not entry.inMatch or not entry.alive then
		return false
	end
	local now = os.clock()
	if now - entry.lastEliminationDebounce < 0.25 then
		return false
	end
	entry.lastEliminationDebounce = now
	entry.alive = false
	entry.eliminated = true
	player:SetAttribute("Spectating", true)
	PlayerRoundService.PlayerEliminated:Fire(player, reason or "fell")
	PlayerRoundService.AliveCountChanged:Fire(PlayerRoundService.getAliveCount())
	return true
end

function PlayerRoundService.awardRoundWin(player: Player)
	local entry = ensureEntry(player)
	entry.roundWins += 1
end

function PlayerRoundService.teleportToArenaSpawns(): number
	local spawns = ArenaService.getSpawnPoints()
	if #spawns == 0 then
		warn("[PlayerRoundService] No arena spawns available.")
		return 0
	end
	local entries = PlayerRoundService.getInMatchEntries()
	local shuffled = TableUtil.shuffle(spawns)
	local placed = 0
	for index, entry in ipairs(entries) do
		local cf = shuffled[((index - 1) % #shuffled) + 1]
		local player = entry.player
		local character = player.Character
		local hum = character and character:FindFirstChildOfClass("Humanoid") :: Humanoid?
		if not character or (hum and hum.Health <= 0) then
			-- LoadCharacter é blocking e retorna após o character estar pronto
			pcall(function()
				player:LoadCharacter()
			end)
			character = player.Character
		end
		if character then
			character:PivotTo(cf)
			placed += 1
		end
	end
	return placed
end

function PlayerRoundService.cleanup()
	-- chamado entre matches
	for _, entry in pairs(data) do
		entry.alive = false
		entry.eliminated = true
		entry.inMatch = false
	end
end

-- Espera RespawnToLobbyDelay e retorna jogadores ao lobby (delegado ao caller).
function PlayerRoundService.getRespawnDelay(): number
	return Config.RespawnToLobbyDelay
end

return PlayerRoundService
