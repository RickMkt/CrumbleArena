--!strict
-- MatchService.lua
-- Loop principal: WaitingForPlayers → Intermission → 3 Rounds → MatchEnded → repeat.
-- Mantém estado autoritativo, faz broadcast de HUDUpdate/RoundStateChanged/etc.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Utils = ReplicatedStorage:WaitForChild("Utils")
local Config = require(Shared.Config)
local RoundStates = require(Shared.RoundStates)
local Remotes = require(Shared.Remotes)
local TableUtil = require(Utils.TableUtil)

local services = script.Parent
local ArenaService = require(services.ArenaService)
local PlayerRoundService = require(services.PlayerRoundService)
local LobbyService = require(services.LobbyService)
local SpectatorService = require(services.SpectatorService)
local RoundService = require(services.RoundService)
local ProjectileService = require(services.ProjectileService)

local MatchService = {}

local currentState: string = RoundStates.WaitingForPlayers
local currentRound: number = 0
local stateEndsAt: number = 0
local hudHeartbeat: RBXScriptConnection? = nil
local lastHudBroadcast: number = 0
local initialized = false

local function broadcastHUD()
	local inMatchCount = #PlayerRoundService.getInMatchEntries()
	local totalPlayers = inMatchCount > 0 and inMatchCount or #Players:GetPlayers()
	local payload = {
		state = currentState,
		timeLeft = math.max(0, math.floor(stateEndsAt - os.clock() + 0.5)),
		aliveCount = PlayerRoundService.getAliveCount(),
		totalPlayers = totalPlayers,
		roundNumber = currentRound,
		roundsPerMatch = Config.RoundsPerMatch,
		modeName = Config.ModeName,
	}
	Remotes.get("HUDUpdate"):FireAllClients(payload)
end

local function broadcastScores(matchWinner: Player?)
	local entries = PlayerRoundService.getAllEntries()
	local scores = {}
	for _, entry in ipairs(entries) do
		if entry.inMatch or entry.roundWins > 0 then
			table.insert(scores, {
				userId = entry.player.UserId,
				displayName = entry.player.DisplayName,
				wins = entry.roundWins,
			})
		end
	end
	table.sort(scores, function(a, b)
		return a.wins > b.wins
	end)
	Remotes.get("MatchScoreUpdate"):FireAllClients({
		scores = scores,
		currentRound = currentRound,
		roundsPerMatch = Config.RoundsPerMatch,
		matchWinner = matchWinner and matchWinner.UserId or nil,
		matchWinnerName = matchWinner and matchWinner.DisplayName or nil,
	})
end

local function setState(newState: string, durationSeconds: number?)
	currentState = newState
	stateEndsAt = os.clock() + (durationSeconds or 0)
	Remotes.get("RoundStateChanged"):FireAllClients({
		state = newState,
		roundNumber = currentRound,
		roundsPerMatch = Config.RoundsPerMatch,
		modeName = Config.ModeName,
	})
	broadcastHUD()
end

local function sendCenterMessage(text: string, duration: number?, style: string?)
	Remotes.get("CenterMessage"):FireAllClients({
		text = text,
		duration = duration or 2.5,
		style = style,
	})
end

local function getEligibleParticipants(): { Player }
	-- Todos os jogadores conectados entram no match.
	return Players:GetPlayers()
end

local function returnAllToLobby()
	for _, player in ipairs(Players:GetPlayers()) do
		LobbyService.teleport(player)
	end
end

local function waitForState(durationSeconds: number)
	local startedAt = os.clock()
	while os.clock() - startedAt < durationSeconds do
		task.wait(0.25)
	end
end

local function waitForEnoughPlayers()
	while #Players:GetPlayers() < Config.MinimumPlayers do
		task.wait(0.5)
	end
end

local function determineMatchWinner(): (Player?, boolean)
	-- Retorna (winner, tied)
	local entries = PlayerRoundService.getInMatchEntries()
	if #entries == 0 then
		return nil, false
	end
	local maxWins = -1
	for _, e in ipairs(entries) do
		if e.roundWins > maxWins then
			maxWins = e.roundWins
		end
	end
	local leaders = TableUtil.filter(entries, function(e)
		return e.roundWins == maxWins
	end)
	if #leaders == 1 then
		return leaders[1].player, false
	end
	return nil, true
end

local function runMatch()
	-- garante que não inicia se houver poucos jogadores
	if #Players:GetPlayers() < Config.MinimumPlayers then
		setState(RoundStates.WaitingForPlayers, 0)
		sendCenterMessage("WAITING FOR PLAYERS", 2)
		waitForEnoughPlayers()
	end

	-- intermission
	setState(RoundStates.Intermission, Config.IntermissionTime)
	sendCenterMessage("MATCH STARTING SOON", 2.5)
	local intermissionStart = os.clock()
	while os.clock() - intermissionStart < Config.IntermissionTime do
		if #Players:GetPlayers() < Config.MinimumPlayers then
			-- joga gente saiu, aborta
			setState(RoundStates.WaitingForPlayers, 0)
			sendCenterMessage("NOT ENOUGH PLAYERS", 2)
			return
		end
		task.wait(0.25)
	end

	local participants = getEligibleParticipants()
	if #participants < Config.MinimumPlayers then
		setState(RoundStates.WaitingForPlayers, 0)
		return
	end

	PlayerRoundService.beginMatch(participants)
	broadcastScores()

	local function runSingleRound(roundIndex: number, label: string)
		currentRound = roundIndex

		-- PreRound
		setState(RoundStates.PreRound, Config.PreRoundCountdown)
		sendCenterMessage(label, 2)
		ArenaService.reset()
		PlayerRoundService.beginRound()
		PlayerRoundService.teleportToArenaSpawns()

		local preStart = os.clock()
		while os.clock() - preStart < Config.PreRoundCountdown do
			task.wait(0.2)
		end
		sendCenterMessage("GO!", 1.2)

		-- InRound
		setState(RoundStates.InRound, Config.RoundTime)
		broadcastScores()
		local result = RoundService.runRound(roundIndex)

		-- limpa projéteis no fim do round
		ProjectileService.clearAll()

		-- RoundEnded
		setState(RoundStates.RoundEnded, Config.PostRoundTime)
		if result.winner then
			sendCenterMessage(string.upper(result.winner.DisplayName) .. " WINS THE ROUND", 3.5, "winner")
		elseif result.reason == "noPlayers" then
			sendCenterMessage("NO SURVIVORS", 3)
		else
			sendCenterMessage("TIME'S UP", 3)
		end
		broadcastScores()

		-- envia eliminados de volta ao lobby visualmente (só estética: em PostRound)
		for _, entry in ipairs(PlayerRoundService.getInMatchEntries()) do
			if entry.eliminated then
				SpectatorService.sendToSpectator(entry.player)
			end
		end

		local postStart = os.clock()
		while os.clock() - postStart < Config.PostRoundTime do
			task.wait(0.25)
		end

		ArenaService.destroy()
	end

	for roundIndex = 1, Config.RoundsPerMatch do
		runSingleRound(roundIndex, "ROUND " .. roundIndex .. "/" .. Config.RoundsPerMatch)
	end

	-- desempate
	local winner, tied = determineMatchWinner()
	local tieBreakers = 0
	while tied and Config.EnableTieBreaker and tieBreakers < Config.MaxTieBreakerRounds do
		tieBreakers += 1
		runSingleRound(Config.RoundsPerMatch + tieBreakers, "TIEBREAKER " .. tieBreakers)
		winner, tied = determineMatchWinner()
	end

	-- MatchEnded
	setState(RoundStates.MatchEnded, Config.PostMatchTime)
	if winner then
		sendCenterMessage("MATCH WINNER: " .. string.upper(winner.DisplayName), 5, "winner")
		broadcastScores(winner)
	else
		sendCenterMessage("MATCH DRAW", 5)
		broadcastScores()
	end

	local matchEndedStart = os.clock()
	while os.clock() - matchEndedStart < Config.PostMatchTime do
		task.wait(0.25)
	end

	PlayerRoundService.endMatch()
	ArenaService.destroy()
	returnAllToLobby()
end

local function runForever()
	while true do
		local ok, err = pcall(runMatch)
		if not ok then
			warn("[MatchService] runMatch error:", err)
			task.wait(2)
		end
	end
end

function MatchService.getRoundState(): string
	return currentState
end

function MatchService.init()
	if initialized then
		return
	end
	initialized = true

	-- HUD heartbeat para refrescar tempo restante a cada segundo
	if hudHeartbeat then
		hudHeartbeat:Disconnect()
	end
	hudHeartbeat = RunService.Heartbeat:Connect(function()
		local now = os.clock()
		if now - lastHudBroadcast >= 1 then
			lastHudBroadcast = now
			broadcastHUD()
		end
	end)

	Players.PlayerAdded:Connect(function(player)
		-- envia snapshot ao entrar
		task.wait(0.5)
		broadcastHUD()
		broadcastScores()
		Remotes.get("RoundStateChanged"):FireClient(player, {
			state = currentState,
			roundNumber = currentRound,
			roundsPerMatch = Config.RoundsPerMatch,
			modeName = Config.ModeName,
		})
	end)
end

function MatchService.start()
	task.spawn(runForever)
end

return MatchService
