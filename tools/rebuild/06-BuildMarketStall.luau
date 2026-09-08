--!strict
-- Cabana do mercado, em estilo lego.
--
-- Reconstroi por inteiro `workspace.CrumbleArena.Lobby.Market`, menos o rig do
-- lojista, que e preservado aqui e reposicionado por `07-PoseShopkeeper.luau`.
--
-- Contexto: a versao anterior era um pavilhao de 35 x 14 studs com telhado
-- chapado, balcao fora do eixo e o lojista espremido atras de uma prateleira
-- lateral. Lia como galpao, nao como loja. Aqui a cabana vira banca de feira:
-- quatro postes, toldo listrado com stud, balcao atravessado na frente e o
-- lojista atras dele, no centro.
--
-- Como rodar: Command Bar do Studio, modo Edit. Rodar de novo e seguro, porque
-- a primeira coisa que ele faz e apagar a estrutura antiga. O backup do estado
-- anterior fica em ServerStorage.MarketRollback_20260906.
--
-- Medidas que custaram tentativa, registradas para nao se perderem:
--   O toldo comecou com 18.6 graus e a barra da frente em Y 9.09, e escondia a
--   cabeca do lojista, que termina em 8.78. A inclinacao caiu para 13.75 e a
--   barra subiu para 10.97, com os bandos parando em 9.64.
--   As placas de gamepass ficavam de perfil quando miravam o balcao com
--   CFrame.lookAt, porque estao quase na mesma linha de Z que ele. Agora elas
--   recebem direcao fixa, aberta cerca de 33 graus para dentro.
--   O anel da marca de atendimento saiu em raios de sol na primeira tentativa.
--   Ver o comentario da secao 8.

local L = workspace.CrumbleArena.Lobby
local M = L.Market

-- ============================================================
-- medidas
-- ============================================================
local CX = -46.5 -- eixo de simetria da cabana
local CHAO = 3.2 -- topo da laje do terraco
local LADRILHO = 3.20 -- o patio se apoia direto na laje do terraco, sem ladrilho
local DECK = 3.6 -- topo do assoalho da loja
local MEIA = 11.7 -- meia largura entre postes
local Z_FUNDO, Z_FRENTE = -44.0, -35.0
local XE, XD = CX - MEIA, CX + MEIA

local ANG = 13.75 -- inclinacao do toldo, em graus
local Z_MEIO, Y_MEIO = -39.1, 12.4 -- centro do plano do toldo
local LARG = 3.3428 -- sete faixas fecham exatamente os 23.4 de vao

local C = {
	poste = Color3.fromRGB(96, 66, 46),
	madeira = Color3.fromRGB(150, 108, 71),
	madeira2 = Color3.fromRGB(134, 95, 62),
	deckA = Color3.fromRGB(168, 123, 80),
	deckB = Color3.fromRGB(152, 110, 72),
	creme = Color3.fromRGB(240, 228, 199),
	teal = Color3.fromRGB(42, 130, 143),
	tealEsc = Color3.fromRGB(30, 100, 112),
	ambar = Color3.fromRGB(246, 196, 70),
	balcao = Color3.fromRGB(176, 134, 88),
	pedra = Color3.fromRGB(150, 154, 160),
	piso = Color3.fromRGB(196, 180, 148),
	tinta = Color3.fromRGB(38, 44, 62),
}

-- ============================================================
-- limpeza, preservando o rig e as SurfaceGui das placas
-- ============================================================
local lojista = M:FindFirstChild("Shopkeeper")
local guardadas = {}
for _, nome in ipairs({ "MarketSign", "Gamepass_VIP", "Gamepass_Coins" }) do
	local p = M:FindFirstChild(nome, true)
	if p and p:IsA("BasePart") then
		p.Parent = nil
		guardadas[nome] = p
	end
end
for _, c in ipairs(M:GetChildren()) do
	if c ~= lojista then
		c:Destroy()
	end
end

local criadas = 0

-- Stud so renderiza com Material.Plastic. Quem recebe stud e quem cumpre o
-- criterio da D-016: bloco, topo apontando para cima e menor lado horizontal
-- de 3 studs ou mais. Abaixo disso o stud vira sujeira na tela.
local function peca(nome, pai, tam, cf, cor, opc)
	opc = opc or {}
	local p = Instance.new("Part")
	p.Name = nome
	p.Size = tam
	p.CFrame = cf
	p.Color = cor
	p.Anchored = true
	p.CanCollide = opc.semColisao ~= true
	p.Material = opc.material or Enum.Material.Plastic
	p.Transparency = opc.transparencia or 0
	p.Shape = opc.shape or Enum.PartType.Block
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if
		not opc.semStuds
		and p.Shape == Enum.PartType.Block
		and math.min(tam.X, tam.Z) >= 3
		and cf.UpVector.Y > 0.85
	then
		p.TopSurface = Enum.SurfaceType.Studs
	end
	p.Parent = pai
	criadas += 1
	return p
end

local function pasta(nome)
	local f = Instance.new("Folder")
	f.Name = nome
	f.Parent = M
	return f
end

-- ============================================================
-- 1. assoalho
-- ============================================================
local piso = pasta("Deck")
for i = 1, 3 do
	peca(
		"DeckPlank_" .. i,
		piso,
		Vector3.new(23.4, 0.4, 3.4),
		CFrame.new(CX, DECK - 0.2, -42.7 + (i - 1) * 3.4),
		i % 2 == 1 and C.deckA or C.deckB
	)
end
peca("DeckStep", piso, Vector3.new(23.4, 0.16, 1.2), CFrame.new(CX, 3.52, -33.6), C.deckB)

-- ============================================================
-- 2. estrutura
-- ============================================================
local estrutura = pasta("Frame")
local postes = {
	{ XE, Z_FUNDO, 10.25 },
	{ XD, Z_FUNDO, 10.25 },
	{ XE, Z_FRENTE, 7.85 },
	{ XD, Z_FRENTE, 7.85 },
}
for i, d in ipairs(postes) do
	local x, z, h = d[1], d[2], d[3]
	peca("StoneFoot_" .. i, estrutura, Vector3.new(2.4, 0.9, 2.4), CFrame.new(x, CHAO + 0.45, z), C.pedra)
	peca("TimberPost_" .. i, estrutura, Vector3.new(1.6, h, 1.6), CFrame.new(x, CHAO + 0.9 + h / 2, z), C.poste)
	peca("PostCap_" .. i, estrutura, Vector3.new(1.9, 0.4, 1.9), CFrame.new(x, CHAO + 0.9 + h + 0.2, z), C.madeira2)
end

-- parede do fundo em fiadas, para ler como tabua e nao como laje unica
for i = 1, 4 do
	peca(
		"BackCourse_" .. i,
		estrutura,
		Vector3.new(23.4, 1.6, 0.8),
		CFrame.new(CX, DECK + 0.8 + (i - 1) * 1.6, Z_FUNDO),
		i % 2 == 1 and C.madeira or C.madeira2
	)
end
for i, x in ipairs({ XE, XD }) do
	peca("SideRail_" .. i, estrutura, Vector3.new(0.7, 2.4, 7.6), CFrame.new(x, DECK + 1.2, -40.2), C.madeira)
	peca("SideCap_" .. i, estrutura, Vector3.new(1.1, 0.35, 8.0), CFrame.new(x, DECK + 2.575, -40.2), C.madeira2)
end
peca("BackBeam", estrutura, Vector3.new(24.6, 0.9, 0.9), CFrame.new(CX, 13.0, Z_FUNDO), C.poste)
peca("FrontBeam", estrutura, Vector3.new(24.6, 0.9, 0.9), CFrame.new(CX, 10.6, -34.2), C.poste)

-- maos francesas, para a viga da frente nao parecer apoiada no ar
for i, x in ipairs({ XE, XD }) do
	local sinal = i == 1 and 1 or -1
	peca(
		"Brace_" .. i,
		estrutura,
		Vector3.new(0.55, 2.6, 0.55),
		CFrame.new(x + sinal * 0.85, 9.35, -34.55) * CFrame.Angles(0, 0, math.rad(sinal * 42)),
		C.madeira2,
		{ semStuds = true, semColisao = true }
	)
end

-- lanternas. Brilho fraco de proposito, ver secao 9 do PROJECT-MEMORY: luz
-- ambar forte lava a cena inteira de bege.
for i, x in ipairs({ CX - 7.2, CX + 7.2 }) do
	peca("LanternHook_" .. i, estrutura, Vector3.new(0.18, 0.9, 0.18), CFrame.new(x, 9.85, -34.2), C.poste, {
		semStuds = true,
		semColisao = true,
	})
	peca("LanternCase_" .. i, estrutura, Vector3.new(0.8, 1.0, 0.8), CFrame.new(x, 8.9, -34.2), C.poste, {
		semStuds = true,
		semColisao = true,
	})
	local vidro = peca(
		"LanternGlow_" .. i,
		estrutura,
		Vector3.new(0.52, 0.66, 0.52),
		CFrame.new(x, 8.9, -34.2),
		Color3.fromRGB(255, 214, 130),
		{ material = Enum.Material.Neon, semStuds = true, semColisao = true }
	)
	local luz = Instance.new("PointLight")
	luz.Brightness, luz.Range = 0.45, 12
	luz.Color = Color3.fromRGB(255, 218, 160)
	luz.Shadows = false
	luz.Parent = vidro
end

local anc = peca("LightAnchor", estrutura, Vector3.new(0.4, 0.4, 0.4), CFrame.new(CX, 9.4, -40.0), C.ambar, {
	transparencia = 1,
	semColisao = true,
	semStuds = true,
})
anc.CanQuery = false
local luzInterna = Instance.new("PointLight")
luzInterna.Brightness, luzInterna.Range = 0.7, 22
luzInterna.Color = Color3.fromRGB(255, 226, 178)
luzInterna.Shadows = false
luzInterna.Parent = anc

-- ============================================================
-- 3. toldo listrado
-- ============================================================
local toldo = pasta("Awning")
local giro = CFrame.Angles(math.rad(ANG), 0, 0)
for i = 1, 7 do
	peca(
		"AwningStripe_" .. i,
		toldo,
		Vector3.new(LARG, 0.5, 12.0),
		CFrame.new(CX + (i - 4) * LARG, Y_MEIO, Z_MEIO) * giro,
		i % 2 == 1 and C.creme or C.teal
	)
end
local zF = Z_MEIO + 6.0 * math.cos(math.rad(ANG))
local yF = Y_MEIO - 6.0 * math.sin(math.rad(ANG))
peca("AwningEdge", toldo, Vector3.new(23.6, 0.62, 0.7), CFrame.new(CX, yF, zF) * giro, C.tealEsc, { semStuds = true })
-- bandos de altura alternada, para a barra do toldo ter recorte
for i = 1, 7 do
	local h = i % 2 == 1 and 1.15 or 0.75
	peca(
		"AwningTab_" .. i,
		toldo,
		Vector3.new(LARG - 0.1, h, 0.45),
		CFrame.new(CX + (i - 4) * LARG, yF - 0.18 - h / 2, zF + 0.16),
		i % 2 == 1 and C.creme or C.teal,
		{ semStuds = true, semColisao = true }
	)
end

-- ============================================================
-- 4. balcao
-- ============================================================
local balcao = pasta("Counter")
peca("CounterBody", balcao, Vector3.new(19.4, 2.0, 2.4), CFrame.new(CX, DECK + 1.0, -37.1), C.madeira2)
peca("CounterTop", balcao, Vector3.new(20.4, 0.5, 3.2), CFrame.new(CX, DECK + 2.25, -37.1), C.balcao)
peca("CounterLip", balcao, Vector3.new(20.8, 0.28, 3.6), CFrame.new(CX, DECK + 2.64, -37.1), C.madeira, {
	semStuds = true,
})
peca("CounterKick", balcao, Vector3.new(19.8, 0.35, 2.7), CFrame.new(CX, DECK + 0.175, -37.1), C.poste)
for i = 1, 7 do
	peca(
		"CounterStripe_" .. i,
		balcao,
		Vector3.new(2.2, 1.5, 0.2),
		CFrame.new(CX + (i - 4) * 2.77, DECK + 1.0, -35.75),
		i % 2 == 1 and C.teal or C.creme,
		{ semStuds = true, semColisao = true }
	)
end

-- ============================================================
-- 5. letreiro
-- ============================================================
local letreiro = pasta("Signage")
local yL = 13.55
peca("SignBacking", letreiro, Vector3.new(15.0, 3.6, 0.6), CFrame.new(CX, yL, -36.2), C.poste, { semStuds = true })
peca("SignTrimTop", letreiro, Vector3.new(15.8, 0.45, 0.9), CFrame.new(CX, yL + 1.95, -36.2), C.ambar, {
	semStuds = true,
})
peca("SignTrimBottom", letreiro, Vector3.new(15.8, 0.45, 0.9), CFrame.new(CX, yL - 1.95, -36.2), C.ambar, {
	semStuds = true,
})
for i, x in ipairs({ CX - 6.6, CX + 6.6 }) do
	peca("SignBracket_" .. i, letreiro, Vector3.new(0.7, 1.4, 1.4), CFrame.new(x, yL - 2.2, -36.2), C.madeira2, {
		semStuds = true,
	})
end
local sign = guardadas.MarketSign
if sign then
	sign.Size = Vector3.new(13.6, 2.6, 0.35)
	sign.CFrame = CFrame.new(CX, yL, -35.75) * CFrame.Angles(0, math.pi, 0)
	sign.Color, sign.Material = C.tinta, Enum.Material.SmoothPlastic
	sign.Anchored, sign.CanCollide = true, false
	sign.Parent = letreiro
	local display = sign:FindFirstChild("Display")
	local lbl = display and display:FindFirstChild("Label")
	if lbl then
		lbl.Text = "MARKET"
		lbl.TextColor3 = C.ambar
	end
end

-- ============================================================
-- 6. placas de gamepass
-- ============================================================
local vitrine = pasta("PassBoards")
local lados = {
	{ nome = "Gamepass_VIP", p = Vector3.new(-63.0, 8.2, -33.0), dir = Vector3.new(0.55, 0, 0.84), cor = C.teal },
	{ nome = "Gamepass_Coins", p = Vector3.new(-30.0, 8.2, -33.0), dir = Vector3.new(-0.55, 0, 0.84), cor = C.creme },
}
for i, d in ipairs(lados) do
	local base = CFrame.lookAt(d.p, d.p + d.dir)
	local grupo = Instance.new("Folder")
	grupo.Name = d.nome .. "_Stand"
	grupo.Parent = vitrine

	local pe = peca("BoardFoot_" .. i, grupo, Vector3.new(5.2, 0.8, 3.2), base * CFrame.new(0, -4.6, 0), C.piso)
	pe.CFrame = CFrame.new(pe.Position.X, LADRILHO + 0.2, pe.Position.Z) * (pe.CFrame - pe.CFrame.Position)
	for j, dx in ipairs({ -3.2, 3.2 }) do
		peca(
			"BoardPost_" .. i .. "_" .. j,
			grupo,
			Vector3.new(0.9, 4.6, 0.9),
			base * CFrame.new(dx, -1.9, 0),
			C.poste,
			{ semStuds = true }
		)
	end
	peca("BoardBacking_" .. i, grupo, Vector3.new(9.2, 5.0, 0.6), base, C.poste, { semStuds = true })
	peca("BoardTrim_" .. i, grupo, Vector3.new(9.9, 0.5, 0.95), base * CFrame.new(0, 2.75, 0), C.ambar, {
		semStuds = true,
	})
	peca(
		"BoardRoof_" .. i,
		grupo,
		Vector3.new(9.9, 0.45, 2.0),
		base * CFrame.new(0, 3.35, -0.55) * CFrame.Angles(math.rad(16), 0, 0),
		d.cor,
		{ semStuds = true }
	)

	local placa = guardadas[d.nome]
	if placa then
		placa.Size = Vector3.new(8.2, 4.1, 0.3)
		placa.CFrame = base * CFrame.new(0, 0, -0.45)
		placa.Color, placa.Material = C.tinta, Enum.Material.SmoothPlastic
		placa.Anchored, placa.CanCollide = true, false
		placa.Parent = grupo
	end
end

-- ============================================================
-- 7. mercadoria
-- ============================================================
local goods = pasta("DisplayGoods")
peca("BackShelf", goods, Vector3.new(19.0, 0.4, 1.6), CFrame.new(CX, 7.0, -43.2), C.madeira, { semStuds = true })
-- 6.26 e nao 6.30: em 6.30 o topo do suporte ficava coplanar com o topo da
-- fiada BackCourse_2, que e exatamente o caso que a D-015 proibe.
for i, dx in ipairs({ -8.4, 0, 8.4 }) do
	peca("ShelfBracket_" .. i, goods, Vector3.new(0.5, 1.0, 1.2), CFrame.new(CX + dx, 6.26, -43.3), C.madeira2, {
		semStuds = true,
	})
end

local cores = {
	C.teal,
	C.ambar,
	Color3.fromRGB(146, 96, 214),
	Color3.fromRGB(226, 92, 84),
	C.creme,
	Color3.fromRGB(118, 172, 96),
}
for i = 1, 9 do
	local h = (i % 3 == 0) and 1.5 or 1.1
	peca(
		"ShelfBox_" .. i,
		goods,
		Vector3.new(1.1, h, 1.1),
		CFrame.new(CX - 8.0 + (i - 1) * 2.0, 7.2 + h / 2, -43.2) * CFrame.Angles(0, math.rad((i * 41) % 30 - 15), 0),
		cores[(i - 1) % #cores + 1],
		{ semStuds = true, semColisao = true }
	)
end

local caixotes = {
	{ Vector3.new(-55.0, DECK + 0.9, -41.6), 1.8, C.madeira },
	{ Vector3.new(-55.0, DECK + 2.5, -41.6), 1.4, C.madeira2 },
	{ Vector3.new(-53.0, DECK + 0.8, -42.2), 1.6, C.madeira2 },
	{ Vector3.new(-39.5, DECK + 0.9, -41.8), 1.8, C.madeira },
	{ Vector3.new(-37.6, DECK + 0.7, -41.4), 1.4, C.madeira2 },
}
for i, d in ipairs(caixotes) do
	local s = d[2]
	local r = CFrame.Angles(0, math.rad((i * 37) % 25 - 12), 0)
	peca("Crate_" .. i, goods, Vector3.new(s, s, s), CFrame.new(d[1]) * r, d[3], { semStuds = true })
	peca(
		"CrateBand_" .. i,
		goods,
		Vector3.new(s + 0.08, s * 0.22, s + 0.08),
		CFrame.new(d[1] + Vector3.new(0, s * 0.12, 0)) * r,
		C.poste,
		{ semStuds = true, semColisao = true }
	)
end

local amostras = { C.teal, C.ambar, Color3.fromRGB(146, 96, 214), Color3.fromRGB(226, 92, 84) }
peca("SamplePlinth", goods, Vector3.new(4.0, 0.3, 2.0), CFrame.new(CX + 7.4, DECK + 2.65, -37.1), C.pedra, {
	semStuds = true,
})
for i = 1, 4 do
	peca(
		"SkinSample_" .. i,
		goods,
		Vector3.new(0.8, 0.8, 0.8),
		CFrame.new(CX + 6.1 + (i - 1) * 0.9, DECK + 3.2, -37.1) * CFrame.Angles(0, math.rad(i * 22), 0),
		amostras[i],
		{ semStuds = true, semColisao = true }
	)
end
peca(
	"SkinSampleTop",
	goods,
	Vector3.new(0.8, 0.8, 0.8),
	CFrame.new(CX + 7.0, DECK + 4.0, -37.1) * CFrame.Angles(0, math.rad(35), 0),
	amostras[3],
	{ semStuds = true, semColisao = true }
)

-- ============================================================
-- 8. marca de atendimento
-- ============================================================
-- CFrame.Angles(0, -a, 0) alinha o lado maior do bloco com o raio do circulo,
-- e o anel sai em raios de sol. Para o bloco seguir a tangente o angulo e
-- -(a + 90 graus). Isso ja custou uma passada inteira.
local marca = pasta("ServicePad")
local ZP, RAIO = -30.2, 5.4
peca(
	"PadFill",
	marca,
	Vector3.new(0.2, RAIO * 2, RAIO * 2),
	CFrame.new(CX, LADRILHO + 0.06, ZP) * CFrame.Angles(0, 0, math.rad(90)),
	C.ambar,
	{
		shape = Enum.PartType.Cylinder,
		material = Enum.Material.Neon,
		transparencia = 0.9,
		semColisao = true,
		semStuds = true,
	}
)
for i = 1, 54 do
	local a = (i - 1) / 54 * math.pi * 2
	peca(
		string.format("PadSegment_%02d", i),
		marca,
		Vector3.new(0.72, 0.16, 0.62),
		CFrame.new(CX + math.cos(a) * RAIO, LADRILHO + 0.09, ZP + math.sin(a) * RAIO)
			* CFrame.Angles(0, -(a + math.pi / 2), 0),
		C.ambar,
		{ material = Enum.Material.Neon, transparencia = 0.2, semColisao = true, semStuds = true }
	)
end

-- ============================================================
-- 9. patio
-- ============================================================
-- O bau em si vem do Creator Store e e colocado por 07-PoseShopkeeper.luau,
-- que tambem cuida do redimensionamento. Aqui fica so o estrado dele.
--
-- Tudo aqui se apoia em LADRILHO, que hoje vale 3.20, o topo da propria laje
-- do terraco. Houve uma versao com ladrilho de 0.24 por cima, que subia esse
-- valor para 3.44. Ela foi removida em 2026-09-06, ver D-023.
local props = pasta("SideProps")
peca("ChestPallet", props, Vector3.new(5.4, 0.4, 4.6), CFrame.new(-58.5, LADRILHO + 0.2, -27.0), C.madeira)
for i, d in ipairs({
	{ -62.2, -29.4, 2.0 },
	{ -62.6, -26.2, 1.5 },
	{ -34.0, -27.5, 2.0 },
	{ -32.2, -29.8, 1.5 },
}) do
	local s = d[3]
	local r = CFrame.Angles(0, math.rad(i * 29 % 40 - 20), 0)
	peca(
		"YardCrate_" .. i,
		props,
		Vector3.new(s, s, s),
		CFrame.new(d[1], LADRILHO + s / 2, d[2]) * r,
		i % 2 == 1 and C.madeira or C.madeira2,
		{ semStuds = true }
	)
	peca(
		"YardCrateBand_" .. i,
		props,
		Vector3.new(s + 0.08, s * 0.2, s + 0.08),
		CFrame.new(d[1], LADRILHO + s / 2 + s * 0.14, d[2]) * r,
		C.poste,
		{ semStuds = true, semColisao = true }
	)
end

M:SetAttribute("LayoutVersion", "LegoStall-2026-09-06")
M:SetAttribute("ClearApproachDepth", 18.5)
M:SetAttribute("StableInteractionAnchor", "Shopkeeper prompt")
M:SetAttribute("IntegratedFeature", "Gamepasses")

print(string.format("[MarketStall] %d pecas. Barra do toldo em Y %.2f, bandos ate %.2f", criadas, yF, yF - 1.33))
return { criadas = criadas, barraToldo = yF }
