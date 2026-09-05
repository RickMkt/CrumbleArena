--!strict
-- RoundService.lua
-- Controla o ciclo de UM round: configurar arena, conectar KillZone, esperar
-- último sobrevivente (ou timeout) e devolver o vencedor para o MatchService.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Config = require(Shared.Config)
local Maid = require(Utils.Maid)

local services = script.Parent
local ArenaService = require(services.ArenaService)
local PlayerRoundService = require(services.PlayerRoundService)
local SpectatorService = require(services.SpectatorService)

local RoundService = {}

type RoundResult = {
	winner: Player?,
	reason: string, -- "lastStanding" | "timeout" | "noPlayers"
}

local function watchCharacter(maid, player: Player, character: Model)
	local humanoid = character:WaitForChild("Humanoid", 5) :: Humanoid?
	if not humanoid then
		return
	end
	maid:GiveTask(humanoid.Died:Connect(function()
		if PlayerRoundService.isAlive(player) then
			PlayerRoundService.eliminate(player, "died")
		end
	end))
end

local function setupKillZone(maid)
	local killZone = ArenaService.getKillZone()
	if not killZone then
		warn("[RoundService] KillZone not found")
		return
	end
	maid:GiveTask(killZone.Touched:Connect(function(part)
		local character = part:FindFirstAncestorOfClass("Model")
		if not character then
			return
		end
		local player = Players:GetPlayerFromCharacter(character)
		if not player then
			return
		end
		if PlayerRoundService.isAlive(player) then
			PlayerRoundService.eliminate(player, "killzone")
		end
	end))
end

function RoundService.runRound(roundIndex: number): RoundResult
	local maid = Maid.new()

	-- nota: o MatchService já criou a arena, fez beginRound e teleportou os
	-- jogadores antes do PreRound. Aqui apenas conectamos os sistemas de
	-- eliminação para o tempo do round.

	setupKillZone(maid)

	local entries = PlayerRoundService.getInMatchEntries()
	for _, entry in ipairs(entries) do
		local player = entry.player
		if player.Character then
			watchCharacter(maid, player, player.Character)
		end
		maid:GiveTask(player.CharacterAdded:Connect(function(char)
			watchCharacter(maid, player, char)
		end))
	end

	-- handle: jogador eliminado deve ir para spectator (com character vivo)
	local elimConn = PlayerRoundService.PlayerEliminated:Connect(function(player)
		task.delay(0.3, function()
			if not player.Parent then
				return
			end
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
			if not char or (hum and hum.Health <= 0) then
				pcall(function()
					player:LoadCharacter()
				end)
			end
			if player.Character then
				SpectatorService.sendToSpectator(player)
			end
		end)
	end)
	maid:GiveTask(elimConn)

	-- aguarda último vivo OU timeout
	local startedAt = os.clock()
	local timeLimit = Config.RoundTime
	while os.clock() - startedAt < timeLimit do
		local aliveCount = PlayerRoundService.getAliveCount()
		if aliveCount <= 1 then
			break
		end
		task.wait(0.2)
	end

	local aliveEntries = PlayerRoundService.getAliveEntries()
	local result: RoundResult
	if #aliveEntries == 1 then
		local winner = aliveEntries[1].player
		PlayerRoundService.awardRoundWin(winner)
		result = { winner = winner, reason = "lastStanding" }
	elseif #aliveEntries == 0 then
		result = { winner = nil, reason = "noPlayers" }
	else
		-- timeout com vários vivos: empate, ninguém ganha
		result = { winner = nil, reason = "timeout" }
	end

	PlayerRoundService.endRound()
	maid:DoCleaning()

	return result
end

return RoundService
