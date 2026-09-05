--!strict
-- RoundStates.lua
-- Estados possíveis do fluxo de partida.

local RoundStates = {
	WaitingForPlayers = "WaitingForPlayers",
	Intermission = "Intermission",
	PreRound = "PreRound",
	InRound = "InRound",
	RoundEnded = "RoundEnded",
	MatchEnded = "MatchEnded",
}

return RoundStates
