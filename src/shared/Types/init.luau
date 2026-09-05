--!strict
--[[
	Contratos de tipo compartilhados entre servidor e cliente.

	Este modulo declara apenas o formato dos dados. Ele nao contem numeros de
	balanceamento e nao depende de nenhuma API do Roblox, o que permite carrega-lo
	no Lune para teste.
]]

-- Materiais de bloco previstos para a arena. A ordem nao tem significado.
export type BlockKind = "Dirt" | "Grass" | "Stone" | "Ice"

-- Ferramentas previstas. Pickaxe e Shovel agem por contato, Snowball age a distancia.
export type ToolKind = "Pickaxe" | "Shovel" | "Snowball"

-- Definicao de um material de bloco.
-- durability e integridade inteira, damageStages define quantos estagios visuais
-- de rachadura existem antes da destruicao. Os valores ainda nao foram decididos,
-- ver secao de decisoes pendentes em docs/DECISIONS.md.
export type BlockDefinition = {
	kind: BlockKind,
	durability: number,
	damageStages: number,
	-- Ferramenta que remove o bloco em menos golpes. nil significa sem afinidade.
	preferredTool: ToolKind?,
}

-- Posicao de um bloco na grade da arena. Coordenadas inteiras, nunca em studs.
-- A conversao para studs e responsabilidade exclusiva do servidor.
export type GridPosition = {
	x: number,
	y: number,
	z: number,
}

-- Estados do ciclo de partida. A maquina de estados vive no servidor.
export type RoundState =
	"Intermission"
	| "Preparing"
	| "Active"
	| "Resolving"
	| "Results"

-- Papel do jogador dentro de um round em andamento.
export type PlayerRole = "Alive" | "Eliminated" | "Spectating"

return {}
