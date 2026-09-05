--!strict
--[[
	Numeros de partida do Crumble Arena, em um lugar so.

	Regra: este arquivo contem apenas valores ja decididos. Valor ainda em aberto
	nao entra aqui com numero inventado, ele fica na lista de decisoes pendentes
	em docs/DECISIONS.md ate ser decidido.

	Modulo puro. Sem require, sem API do Roblox, carregavel no Lune.
]]

local GameConfig = {
	-- Decidido na sessao 001. Limite de jogadores por servidor.
	MAX_PLAYERS_PER_SERVER = 8,

	-- Minimo de jogadores para iniciar uma partida.
	-- Escolha conservadora: 2 e o menor numero que permite competicao real.
	MIN_PLAYERS_TO_START = 2,

	-- Materiais de bloco previstos. A ordem e a de apresentacao na documentacao.
	BLOCK_KINDS = { "Dirt", "Grass", "Stone", "Ice" },

	-- Ferramentas previstas.
	TOOL_KINDS = { "Pickaxe", "Shovel", "Snowball" },

	-- Estados do ciclo de partida, na ordem em que ocorrem.
	ROUND_STATES = { "Intermission", "Preparing", "Active", "Resolving", "Results" },
}

return GameConfig
