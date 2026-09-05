--!strict
-- Types.lua
-- Tipos compartilhados entre módulos.

export type RoundState =
	"WaitingForPlayers"
	| "Intermission"
	| "PreRound"
	| "InRound"
	| "RoundEnded"
	| "MatchEnded"

export type PlayerRoundData = {
	player: Player,
	alive: boolean,
	eliminated: boolean,
	roundWins: number,
	inMatch: boolean,
}

export type HUDPayload = {
	state: RoundState,
	timeLeft: number,
	aliveCount: number,
	totalPlayers: number,
	roundNumber: number,
	roundsPerMatch: number,
	modeName: string,
}

export type ScoreEntry = {
	userId: number,
	displayName: string,
	wins: number,
}

export type CenterMessagePayload = {
	text: string,
	duration: number?,
	style: string?,
}

export type ThrowRequest = {
	direction: Vector3,
	origin: Vector3?,
}

return {}
