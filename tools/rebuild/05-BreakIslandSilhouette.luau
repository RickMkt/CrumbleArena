--!strict
-- Quebra a silhueta da massa da ilha.
--
-- O problema: `Environment.IslandMass` e uma pilha de caixas retangulares.
-- Soil em Y -18, Stone em Y -30 recuado 9 studs por lado, DeepKeystone em
-- Y -40. O recuo perfeito e igual em toda a volta, entao de longe a ilha le
-- como bolo de casamento, e nao como pedra arrancada do chao.
--
-- A correcao adiciona lascas irregulares nas bordas de cada camada. Elas ficam
-- meio enterradas na laje, giradas em torno de dois eixos, com tamanho e recuo
-- sorteados. O sorteio usa semente fixa, entao rodar de novo produz exatamente
-- a mesma ilha.
--
-- Como rodar: colar no Command Bar do Studio, em modo Edit, e executar.
-- Rodar de novo e seguro: a primeira coisa que ele faz e apagar a propria pasta.
--
-- Nada aqui tem colisao. Tudo fica abaixo de Y = -12, que e o teto da camada
-- Cliffs, entao nenhuma lasca alcanca a superficie jogavel.

local SEMENTE = 20260905

local L = workspace.CrumbleArena.Lobby
local massa = L.Environment.IslandMass

-- ============================================================
-- limpeza da execucao anterior
-- ============================================================
local antiga = L.Environment:FindFirstChild("IslandSilhouette")
if antiga then
	antiga:Destroy()
end

local pasta = Instance.new("Folder")
pasta.Name = "IslandSilhouette"
pasta.Parent = L.Environment
pasta:SetAttribute("Proposito", "lascas de borda que quebram o degrau reto da massa da ilha")
pasta:SetAttribute("CriadoEm", "2026-09-05, Checkpoint A2")
pasta:SetAttribute("Semente", SEMENTE)

local rng = Random.new(SEMENTE)

-- ============================================================
-- quais lajes recebem lasca
-- ============================================================
type Camada = { peca: BasePart, lascasPorLado: number, escala: number }

local camadas: { Camada } = {}
for _, p in ipairs(massa:GetChildren()) do
	if p:IsA("BasePart") then
		if p.Name:match("^Soil_") then
			table.insert(camadas, { peca = p, lascasPorLado = 4, escala = 1.0 })
		elseif p.Name:match("^Stone_") then
			table.insert(camadas, { peca = p, lascasPorLado = 3, escala = 1.15 })
		elseif p.Name == "DeepKeystone" then
			table.insert(camadas, { peca = p, lascasPorLado = 3, escala = 1.3 })
		end
	end
end

-- ============================================================
-- geracao
-- ============================================================
local criadas = 0

local function lasca(base: BasePart, lado: Vector3, escala: number)
	-- meia medida da laje na direcao do lado
	local meia = Vector3.new(base.Size.X, base.Size.Y, base.Size.Z) / 2
	local alcance = math.abs(lado.X) > 0 and meia.X or meia.Z

	-- posicao ao longo da aresta, evitando os cantos exatos
	local t = rng:NextNumber(-0.82, 0.82)
	local aoLongo = math.abs(lado.X) > 0 and Vector3.new(0, 0, meia.Z * t) or Vector3.new(meia.X * t, 0, 0)

	local w = rng:NextNumber(7, 15) * escala
	local h = rng:NextNumber(6, 13) * escala
	local d = rng:NextNumber(6, 12) * escala

	-- enterra parte da lasca na laje, para nao parecer peca colada
	local afundo = rng:NextNumber(0.28, 0.52)
	local centro = base.Position
		+ aoLongo
		+ lado * (alcance + w / 2 - w * afundo)
		+ Vector3.new(0, rng:NextNumber(-base.Size.Y * 0.3, base.Size.Y * 0.28), 0)

	-- A rotacao vem antes do teto de proposito. Uma caixa girada e mais alta do
	-- que `h / 2`, entao limitar pela altura sem rotacao deixa passar. Na
	-- primeira execucao 24 das 152 estouraram o limite com topo em -8.75, e na
	-- segunda, ja com teto ingenuo, ainda sobraram 12 com topo em -10.88.
	local giro =
		CFrame.Angles(
			math.rad(rng:NextNumber(-16, 16)),
			math.rad(rng:NextNumber(-40, 40)),
			math.rad(rng:NextNumber(-16, 16))
		)

	-- meia altura real da caixa girada, projetada no eixo Y
	local meiaAlturaReal = math.abs(giro.UpVector.Y) * h / 2
		+ math.abs(giro.RightVector.Y) * w / 2
		+ math.abs(giro.LookVector.Y) * d / 2

	-- Teto duro. A camada Cliffs comeca em Y -12, e lasca que passa disso
	-- aparece junto da superficie jogavel.
	local TETO = -12.5
	if centro.Y + meiaAlturaReal > TETO then
		centro = Vector3.new(centro.X, TETO - meiaAlturaReal, centro.Z)
	end

	local p = Instance.new("Part")
	p.Name = string.format("Shard_%s_%02d", base.Name, criadas + 1)
	p.Size = Vector3.new(w, h, d)
	p.CFrame = CFrame.new(centro) * giro
	p.Anchored = true
	p.CanCollide = false -- decoracao, fica abaixo da superficie jogavel
	p.CanQuery = true
	p.CastShadow = true
	p.Material = base.Material
	-- leve variacao de tom, para a borda nao ficar chapada
	local v = rng:NextNumber(-0.045, 0.035)
	p.Color = Color3.new(
		math.clamp(base.Color.R + v, 0, 1),
		math.clamp(base.Color.G + v, 0, 1),
		math.clamp(base.Color.B + v, 0, 1)
	)
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = pasta
	criadas += 1
	return p
end

local lados = {
	Vector3.new(1, 0, 0),
	Vector3.new(-1, 0, 0),
	Vector3.new(0, 0, 1),
	Vector3.new(0, 0, -1),
}

for _, c in ipairs(camadas) do
	for _, lado in ipairs(lados) do
		for _ = 1, c.lascasPorLado do
			lasca(c.peca, lado, c.escala)
		end
	end
end

-- ============================================================
-- conferencia, o script checa o proprio resultado
-- ============================================================
local comColisao, semAncora, acimaDoLimite = 0, 0, 0
local topoMaisAlto = -math.huge
for _, p in ipairs(pasta:GetChildren()) do
	if p:IsA("BasePart") then
		if p.CanCollide then
			comColisao += 1
		end
		if not p.Anchored then
			semAncora += 1
		end
		local topo = p.Position.Y + p.Size.Y / 2
		topoMaisAlto = math.max(topoMaisAlto, topo)
		-- Cliffs comeca em Y -12. Nenhuma lasca pode passar disso.
		if topo > -12 then
			acimaDoLimite += 1
		end
	end
end

print(string.format("[IslandSilhouette] %d lascas criadas em %d camadas", criadas, #camadas))
print(string.format("[IslandSilhouette] com colisao: %d (esperado 0)", comColisao))
print(string.format("[IslandSilhouette] sem ancoragem: %d (esperado 0)", semAncora))
print(
	string.format(
		"[IslandSilhouette] topo mais alto: %.2f, limite -12. Acima do limite: %d",
		topoMaisAlto,
		acimaDoLimite
	)
)

return {
	criadas = criadas,
	camadas = #camadas,
	comColisao = comColisao,
	semAncora = semAncora,
	acimaDoLimite = acimaDoLimite,
	topoMaisAlto = topoMaisAlto,
	semente = SEMENTE,
}
