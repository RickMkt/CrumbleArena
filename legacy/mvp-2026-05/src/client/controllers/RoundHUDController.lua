--!strict
-- RoundHUDController.lua
-- Conecta os Remotes de estado/HUD/mensagem central/placar e atualiza a UI.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared.Config)
local Remotes = require(Shared.Remotes)
local RoundStates = require(Shared.RoundStates)

local RoundHUDController = {}

local STATE_LABELS: { [string]: string } = {
	[RoundStates.WaitingForPlayers] = "Waiting for players",
	[RoundStates.Intermission] = "Intermission",
	[RoundStates.PreRound] = "Get ready",
	[RoundStates.InRound] = "Round in progress",
	[RoundStates.RoundEnded] = "Round ended",
	[RoundStates.MatchEnded] = "Match ended",
}

local function formatTime(seconds: number): string
	seconds = math.max(0, math.floor(seconds))
	local m = math.floor(seconds / 60)
	local s = seconds % 60
	return string.format("%d:%02d", m, s)
end

local function applyHUDUpdate(hud, payload)
	if not hud or typeof(payload) ~= "table" then
		return
	end
	local stateLabel = STATE_LABELS[payload.state] or payload.state or ""
	hud.TopBar.StateLabel.Text = stateLabel
	hud.TopBar.TimeLabel.Text = formatTime(payload.timeLeft or 0)

	local roundNumber = payload.roundNumber or 0
	local roundsPerMatch = payload.roundsPerMatch or Config.RoundsPerMatch
	if roundNumber > 0 then
		hud.RoundInfo.RoundLabel.Text = string.format("ROUND %d/%d", roundNumber, roundsPerMatch)
	else
		hud.RoundInfo.RoundLabel.Text = "LOBBY"
	end
	hud.RoundInfo.ModeLabel.Text = payload.modeName or Config.ModeName

	local alive = payload.aliveCount or 0
	local total = payload.totalPlayers or 0
	hud.AliveCounter.Value.Text = string.format("%d/%d", alive, total)

	-- mostra LobbyPanel quando estamos em lobby/intermission
	local inLobby = payload.state == RoundStates.WaitingForPlayers
		or payload.state == RoundStates.Intermission
	hud.LobbyPanel.Frame.Visible = inLobby
	if inLobby then
		hud.LobbyPanel.Title.Text = (payload.state == RoundStates.WaitingForPlayers)
			and "WAITING FOR PLAYERS"
			or "MATCH STARTING"
		hud.LobbyPanel.Subtitle.Text = (payload.state == RoundStates.WaitingForPlayers)
			and string.format("Need %d to start.", Config.MinimumPlayers)
			or "Get ready..."
	end

	-- nota: a SpectatorBar é controlada via attribute "Spectating" do servidor
end

local function applyCenterMessage(hud, payload)
	if not hud or typeof(payload) ~= "table" then
		return
	end
	local label = hud.CenterMessage.Text
	local subtitle = hud.CenterMessage.Subtitle
	label.Text = payload.text or ""
	label.TextTransparency = 1
	label.TextSize = 56
	if payload.style == "winner" then
		label.TextColor3 = Color3.fromRGB(255, 210, 90)
	else
		label.TextColor3 = Color3.fromRGB(245, 247, 255)
	end
	subtitle.Text = ""

	local fadeIn = TweenService:Create(label, TweenInfo.new(0.2), { TextTransparency = 0 })
	fadeIn:Play()
	local duration = payload.duration or 2.5
	task.delay(duration, function()
		if label and label.Parent then
			local fadeOut = TweenService:Create(label, TweenInfo.new(0.4), { TextTransparency = 1 })
			fadeOut:Play()
		end
	end)
end

local function applyScoreboard(hud, payload)
	if not hud or typeof(payload) ~= "table" then
		return
	end
	local rows = hud.Scoreboard.Rows
	for i, row in ipairs(rows) do
		row.Container.Visible = false
	end
	if typeof(payload.scores) ~= "table" then
		return
	end
	for index, entry in ipairs(payload.scores) do
		if index > #rows then
			break
		end
		local row = rows[index]
		row.Container.Visible = true
		row.Name.Text = entry.displayName or "?"
		row.Wins.Text = tostring(entry.wins or 0)
	end
end

local function applySpectator(hud, isSpectator: boolean)
	if not hud then
		return
	end
	hud.SpectatorBar.Frame.Visible = isSpectator
end

function RoundHUDController.init(hud)
	local hudUpdate = Remotes.get("HUDUpdate")
	local centerMsg = Remotes.get("CenterMessage")
	local scoreUpdate = Remotes.get("MatchScoreUpdate")
	local stateChanged = Remotes.get("RoundStateChanged")

	hudUpdate.OnClientEvent:Connect(function(payload)
		applyHUDUpdate(hud, payload)
	end)

	centerMsg.OnClientEvent:Connect(function(payload)
		applyCenterMessage(hud, payload)
	end)

	scoreUpdate.OnClientEvent:Connect(function(payload)
		applyScoreboard(hud, payload)
	end)

	stateChanged.OnClientEvent:Connect(function(payload)
		-- placeholder caso queira animar transições no futuro
	end)

	-- spectator é controlado pelo servidor via attribute "Spectating"
	local localPlayer = Players.LocalPlayer
	local function refreshSpectator()
		applySpectator(hud, localPlayer:GetAttribute("Spectating") == true)
	end
	refreshSpectator()
	localPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshSpectator)
end

return RoundHUDController
