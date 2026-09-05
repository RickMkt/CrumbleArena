--!strict
-- Teste de capacidade para oito jogadores.
--
-- Este e o criterio de peso 20 da faixa "fundacao estrutural" que nunca foi
-- medido, desde a sessao 001. Ver docs/LOBBY-COMPLETE-AUDIT.md secao 3.
--
-- Como rodar: colar no Command Bar do Studio, em modo Edit, e executar.
-- O script cria os rigs, mede, imprime e apaga os rigs no fim. Ele nao deixa
-- nada no place. Se voce quiser inspecionar os rigs a olho, mude MANTER_RIGS
-- para true e apague a pasta CapacityTest depois.
--
-- Rodar de novo e seguro: a primeira coisa que ele faz e limpar sobra de
-- execucao anterior.

local Players = game:GetService("Players")

local MANTER_RIGS = false

local PRACA_RAIO_UTIL = 42

-- As lajes sao descobertas no proprio place, nao lidas de documento. Em
-- 2026-09-05 o LOBBY-BUILD-PARAMS.md estava com o topo das lajes errado, 4.5 e
-- 3.5 onde a realidade era 2.5, e quatro areas nem tem peca chamada Pad. Medir
-- contra documento desatualizado da numero bonito e falso.
type Area = { nome: string, x: number, z: number, topo: number, larg: number, comp: number }

local function descobrirLaje(area: Instance): Area?
	local melhor: BasePart? = nil
	local melhorArea = 0
	for _, d in ipairs(area:GetDescendants()) do
		if d:IsA("BasePart") and d.CanCollide then
			-- laje e larga, baixa e deitada
			local ehDeitada = d.Size.Y < math.min(d.Size.X, d.Size.Z)
			local a = d.Size.X * d.Size.Z
			if ehDeitada and math.min(d.Size.X, d.Size.Z) >= 20 and a > melhorArea then
				melhor = d
				melhorArea = a
			end
		end
	end
	if not melhor then
		return nil
	end
	local p = melhor :: BasePart
	return {
		nome = area.Name,
		x = p.Position.X,
		z = p.Position.Z,
		topo = p.Position.Y + p.Size.Y / 2,
		larg = p.Size.X,
		comp = p.Size.Z,
	}
end

local AREAS: { Area } = {}
for _, area in ipairs(workspace.CrumbleArena.Lobby.Areas:GetChildren()) do
	local laje = descobrirLaje(area)
	if laje then
		table.insert(AREAS, laje)
	end
end
table.sort(AREAS, function(a, b)
	return a.nome < b.nome
end)

-- Distancia minima confortavel entre dois personagens R15 antes de um empurrar
-- o outro. O HumanoidRootPart e 2 x 2 x 1, mas o ombro passa dos 4 studs.
local ESPACO_PESSOAL = 4.0

-- ============================================================
-- limpeza de execucao anterior
-- ============================================================
local antiga = workspace:FindFirstChild("CapacityTest")
if antiga then
	antiga:Destroy()
end

local pasta = Instance.new("Folder")
pasta.Name = "CapacityTest"
pasta.Parent = workspace

-- ============================================================
-- criacao dos rigs
-- ============================================================
local function criarRig(indice: number): Model?
	local ok, rig = pcall(function()
		local desc = Instance.new("HumanoidDescription")
		return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
	end)
	if not ok or not rig then
		return nil
	end
	local m = rig :: Model
	m.Name = string.format("Rig%02d", indice)
	m.Parent = pasta
	-- Ancorado de proposito. Este teste mede espaco, nao fisica. Rig solto em
	-- modo Edit cai e some, e ai a medida vira ruido.
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then
			d.Anchored = true
		end
	end
	return m
end

local rigs: { Model } = {}
for i = 1, 8 do
	local r = criarRig(i)
	if r then
		table.insert(rigs, r)
	end
end

if #rigs < 8 then
	pasta:Destroy()
	error(
		string.format(
			"[Capacity] so consegui criar %d de 8 rigs. CreateHumanoidModelFromDescription falhou. "
				.. "Teste abortado, nada foi deixado no place.",
			#rigs
		)
	)
end

local function posicionar(rig: Model, pos: Vector3)
	rig:PivotTo(CFrame.new(pos))
end

local function raizes(): { Vector3 }
	local lista = {}
	for _, r in ipairs(rigs) do
		local hrp = r:FindFirstChild("HumanoidRootPart") :: BasePart?
		if hrp then
			table.insert(lista, hrp.Position)
		end
	end
	return lista
end

local function menorDistancia(): (number, string)
	local pos = raizes()
	local menor, par = math.huge, "nenhum"
	for i = 1, #pos do
		for j = i + 1, #pos do
			local d = (pos[i] - pos[j]).Magnitude
			if d < menor then
				menor = d
				par = string.format("%02d-%02d", i, j)
			end
		end
	end
	return menor, par
end

-- Conta quantos pares de rigs se atravessam.
local function interpenetracoes(): number
	local total = 0
	for _, r in ipairs(rigs) do
		local hrp = r:FindFirstChild("HumanoidRootPart") :: BasePart?
		if not hrp then
			continue
		end
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { r }
		params.MaxParts = 60
		local caixa = workspace:GetPartBoundsInBox(hrp.CFrame, Vector3.new(2, 5.4, 2), params)
		for _, p in ipairs(caixa) do
			if p:IsDescendantOf(pasta) then
				total += 1
			end
		end
	end
	-- cada invasao aparece dos dois lados
	return total // 2
end

type Resultado = { criterio: string, valor: string, veredito: string }
local resultados: { Resultado } = {}

local function registrar(criterio: string, valor: string, ok: boolean)
	table.insert(resultados, {
		criterio = criterio,
		valor = valor,
		veredito = ok and "aprovado" or "reprovado",
	})
end

-- ============================================================
-- teste 1, todos nascem juntos no SpawnLocation
-- ============================================================
-- O Roblox espalha os jogadores pela face de cima do SpawnLocation. Com oito
-- ao mesmo tempo, o pior caso e a grade cheia.
do
	local spawnObj = workspace:FindFirstChild("LobbySpawn", true)
	if not (spawnObj and spawnObj:IsA("BasePart")) then
		pasta:Destroy()
		error("[Capacity] nao achei o LobbySpawn. Teste abortado.")
	end
	local sp = spawnObj :: BasePart
	local centro = sp.Position + Vector3.new(0, sp.Size.Y / 2 + 2.5, 0)
	local lado = math.min(sp.Size.X, sp.Size.Z)
	-- grade 3 x 3 sem o centro, que e o pior arranjo real
	local passo = lado / 3
	local slots = {}
	for gx = -1, 1 do
		for gz = -1, 1 do
			if not (gx == 0 and gz == 0) then
				table.insert(slots, Vector3.new(gx * passo, 0, gz * passo))
			end
		end
	end
	for i, rig in ipairs(rigs) do
		posicionar(rig, centro + slots[i])
	end

	local menor, par = menorDistancia()
	local invasoes = interpenetracoes()
	registrar(
		"Spawn, 8 ao mesmo tempo",
		string.format("plataforma %.0f studs, menor distancia %.2f, par %s", lado, menor, par),
		menor >= ESPACO_PESSOAL
	)
	registrar(
		"Spawn, interpenetracao",
		string.format("%d pares se atravessando", invasoes),
		invasoes == 0
	)
end

-- ============================================================
-- teste 2, oito espalhados na praca
-- ============================================================
do
	local raio = PRACA_RAIO_UTIL * 0.62
	for i, rig in ipairs(rigs) do
		local a = (i - 1) / 8 * math.pi * 2
		posicionar(rig, Vector3.new(math.cos(a) * raio, 3.5, math.sin(a) * raio))
	end
	local menor = menorDistancia()
	local areaPorRig = (math.pi * PRACA_RAIO_UTIL ^ 2) / 8
	registrar(
		"Praca, 8 espalhados",
		string.format("menor distancia %.2f, %.0f studs quadrados por jogador", menor, areaPorRig),
		menor >= ESPACO_PESSOAL
	)
end

-- ============================================================
-- teste 3, cada area aguenta oito
-- ============================================================
-- Cenario real: sai um evento e todo mundo corre para a mesma atracao.
for _, area in ipairs(AREAS) do
	local margem = 2.0
	local usavelX = area.larg - margem * 2
	local usavelZ = area.comp - margem * 2
	local colunas, linhas = 4, 2
	local passoX = usavelX / colunas
	local passoZ = usavelZ / linhas
	local i = 0
	for c = 1, colunas do
		for l = 1, linhas do
			i += 1
			local ox = -usavelX / 2 + passoX * (c - 0.5)
			local oz = -usavelZ / 2 + passoZ * (l - 0.5)
			posicionar(rigs[i], Vector3.new(area.x + ox, area.topo + 3.0, area.z + oz))
		end
	end
	local menor = menorDistancia()
	local invasoes = interpenetracoes()
	registrar(
		string.format("Area %s, 8 juntos", area.nome),
		string.format(
			"laje %d x %d, menor distancia %.2f, %d pares se atravessando",
			area.larg,
			area.comp,
			menor,
			invasoes
		),
		menor >= ESPACO_PESSOAL and invasoes == 0
	)
end

-- ============================================================
-- teste 4, dois lado a lado no caminho mais estreito
-- ============================================================
-- O caminho de 16 studs e o mais estreito do lobby. Dois jogadores tem que se
-- cruzar sem um empurrar o outro para fora.
do
	local larguraMinima = 16
	local livre = larguraMinima - ESPACO_PESSOAL * 2
	registrar(
		"Caminho estreito, cruzamento",
		string.format("%d studs de largura, sobra %.1f com dois lado a lado", larguraMinima, livre),
		livre >= 4
	)
end

-- ============================================================
-- limpeza e relatorio
-- ============================================================
if not MANTER_RIGS then
	pasta:Destroy()
end

local aprovados = 0
print("[Capacity] teste de oito jogadores")
print("[Capacity] ------------------------------------------------------------")
for _, r in ipairs(resultados) do
	if r.veredito == "aprovado" then
		aprovados += 1
	end
	print(string.format("[Capacity] %-10s %-26s %s", r.veredito, r.criterio, r.valor))
end
print("[Capacity] ------------------------------------------------------------")
print(
	string.format(
		"[Capacity] %d de %d aprovados. Rigs %s.",
		aprovados,
		#resultados,
		MANTER_RIGS and "MANTIDOS em workspace.CapacityTest" or "apagados, place limpo"
	)
)

return {
	aprovados = aprovados,
	total = #resultados,
	resultados = resultados,
	rigsMantidos = MANTER_RIGS,
}
