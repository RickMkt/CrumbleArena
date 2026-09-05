--!strict
--[[
	Teste puro rodado pelo Lune. Nao abre o Studio.

	Verifica invariantes do GameConfig que, se quebradas, produzem bug silencioso:
	limites de jogador incoerentes e listas de dominio duplicadas ou vazias.
]]

local GameConfig = require("../src/shared/Config/GameConfig")

local failures = 0

local function check(label: string, condition: boolean)
	if condition then
		print("  ok   " .. label)
	else
		print("  FAIL " .. label)
		failures += 1
	end
end

local function hasNoDuplicates(list: { string }): boolean
	local seen: { [string]: boolean } = {}
	for _, value in ipairs(list) do
		if seen[value] then
			return false
		end
		seen[value] = true
	end
	return true
end

print("GameConfig")
check("MIN_PLAYERS_TO_START e no minimo 2", GameConfig.MIN_PLAYERS_TO_START >= 2)
check(
	"MIN_PLAYERS_TO_START nao passa de MAX_PLAYERS_PER_SERVER",
	GameConfig.MIN_PLAYERS_TO_START <= GameConfig.MAX_PLAYERS_PER_SERVER
)
check("MAX_PLAYERS_PER_SERVER e 8", GameConfig.MAX_PLAYERS_PER_SERVER == 8)
check("BLOCK_KINDS tem 4 materiais", #GameConfig.BLOCK_KINDS == 4)
check("BLOCK_KINDS sem duplicata", hasNoDuplicates(GameConfig.BLOCK_KINDS))
check("TOOL_KINDS tem 3 ferramentas", #GameConfig.TOOL_KINDS == 3)
check("TOOL_KINDS sem duplicata", hasNoDuplicates(GameConfig.TOOL_KINDS))
check("ROUND_STATES sem duplicata", hasNoDuplicates(GameConfig.ROUND_STATES))
check("ROUND_STATES comeca em Intermission", GameConfig.ROUND_STATES[1] == "Intermission")

print("")
if failures > 0 then
	-- error() faz o Lune sair com codigo 1, que e o que a automacao le.
	error(failures .. " verificacao(oes) falharam", 0)
end
print("todas as verificacoes passaram")
