--!strict
-- Reconstroi a tenda da area Cosmetics e o NPC lojista PIP.
--
-- Como rodar: colar no Command Bar do Studio, em modo Edit, e executar.
-- Rodar de novo e seguro, o script apaga a lona e o NPC antes de recriar.
--
-- Depende do que a area Cosmetics ja tem: Base.Pad, Counter, CounterTop,
-- KioskPost_L, KioskPost_R, AwningStripe_0 a 5 e CosmeticsSign. Se algum sumir,
-- o script avisa e segue com o resto.
--
-- Ver D-018 em docs/DECISIONS.md.

local lobby = workspace:WaitForChild("CrumbleArena"):WaitForChild("Lobby")
local cos = lobby.Areas:FindFirstChild("Cosmetics")
assert(cos, "Areas.Cosmetics nao existe. Este script nao reconstroi a area inteira.")

local LAJE = 2.5
local faltando = {}

local function achar(nome: string): BasePart?
	local d = cos:FindFirstChild(nome, true)
	if not d or not d:IsA("BasePart") then
		faltando[#faltando + 1] = nome
		return nil
	end
	return d
end

local VERM = Color3.fromRGB(198, 82, 74)
local CREME = Color3.fromRGB(238, 226, 198)
local WOOD_DARK = Color3.fromRGB(104, 70, 42)
local PELE = Color3.fromRGB(238, 196, 154)
local CAMISA = Color3.fromRGB(88, 198, 226)
local CAMISA_D = Color3.fromRGB(44, 140, 178)
local AVENTAL = Color3.fromRGB(238, 226, 198)
local CINTO = Color3.fromRGB(104, 70, 42)
local INK = Color3.fromRGB(20, 22, 34)
local CABELO = Color3.fromRGB(122, 74, 42)

-- ============================================================
-- 1. tenda
-- ============================================================
-- O toldo estava a 17 studs acima da laje, o que lia como pavilhao. Desce para
-- 13.4 e ganha fundo e laterais de lona, virando tendinha fechada de tres lados.
local anteriorLona = cos:FindFirstChild("TentCloth")
if anteriorLona then
	anteriorLona:Destroy()
end
local lona = Instance.new("Folder")
lona.Name = "TentCloth"
lona.Parent = cos

local function pecaLona(nome: string, tam: Vector3, cf: CFrame, cor: Color3, colide: boolean?): Part
	local p = Instance.new("Part")
	p.Name = nome
	p.Anchored = true
	p.CanCollide = colide == true
	p.CanQuery = colide == true
	p.Size = tam
	p.CFrame = cf
	p.Color = cor
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = lona
	return p
end

-- balcao mais raso, para caber o NPC atras
local balcao = achar("Counter")
local tampo = achar("CounterTop")
if balcao and tampo then
	balcao.Size = Vector3.new(30, 3.6, 5.2)
	balcao.CFrame = CFrame.new(-80, LAJE + 1.8, -44)
	tampo.Size = Vector3.new(31.4, 0.7, 6.6)
	tampo.CFrame = CFrame.new(-80, LAJE + 3.95, -44)
end

-- toldo e postes descem
for i = 0, 5 do
	local a = cos:FindFirstChild("AwningStripe_" .. i)
	if a and a:IsA("BasePart") then
		a.CFrame = CFrame.new(a.Position.X, 13.4, a.Position.Z)
	end
end
for _, n in ipairs({ "KioskPost_L", "KioskPost_R" }) do
	local p = achar(n)
	if p then
		p.Size = Vector3.new(1.8, 11.4, 1.8)
		p.CFrame = CFrame.new(p.Position.X, LAJE + 5.7, p.Position.Z)
	end
end
local placa = achar("CosmeticsSign")
if placa then
	placa.CFrame = CFrame.new(-80, 17.4, -47.4)
end

-- dois postes de fundo, para o toldo ter quatro apoios
for _, x in ipairs({ -94, -66 }) do
	pecaLona("BackPost_" .. (x < -80 and "L" or "R"), Vector3.new(1.8, 11.4, 1.8), CFrame.new(x, LAJE + 5.7, -52.5), WOOD_DARK, true)
	pecaLona("Beam_" .. (x < -80 and "L" or "R"), Vector3.new(1.2, 1.0, 8.5), CFrame.new(x, 12.6, -49.2), WOOD_DARK)
end
pecaLona("BeamBack", Vector3.new(29.6, 1.0, 1.2), CFrame.new(-80, 12.6, -52.5), WOOD_DARK)

-- lona listrada nas laterais
for lado, x in ipairs({ -94.3, -65.7 }) do
	for i = 0, 4 do
		pecaLona(string.format("SideCloth_%d_%d", lado, i), Vector3.new(0.35, 7.0, 1.9), CFrame.new(x, LAJE + 4.2, -47.8 - i * 1.9), (i % 2 == 0) and VERM or CREME)
	end
end
-- fundo, com vao para o NPC entrar
for i = 0, 7 do
	pecaLona("BackCloth_" .. i, Vector3.new(3.7, 6.4, 0.35), CFrame.new(-93 + i * 3.7, LAJE + 3.9, -52.3), (i % 2 == 0) and CREME or VERM)
end
-- babado do toldo
for i = 0, 13 do
	pecaLona("Valance_" .. i, Vector3.new(2.1, 1.5, 0.4), CFrame.new(-95.4 + i * 2.1, 12.2, -40.6), (i % 2 == 0) and VERM or CREME)
end

-- ============================================================
-- 2. NPC lojista
-- ============================================================
local anteriorNpc = cos:FindFirstChild("Shopkeeper")
if anteriorNpc then
	anteriorNpc:Destroy()
end
local npc = Instance.new("Model")
npc.Name = "Shopkeeper"
npc.Parent = cos

local X, Z = -80, -47.6
local corpo = CFrame.Angles(0, math.rad(4), 0)

local function pecaNpc(nome: string, tam: Vector3, cf: CFrame, cor: Color3, colide: boolean?): Part
	local p = Instance.new("Part")
	p.Name = nome
	p.Anchored = true
	p.CanCollide = colide == true
	-- CanQuery fica falso nas pecas de enfeite, mas a cabeca precisa ser true,
	-- senao o ProximityPrompt nunca aparece. Isso ja custou uma sessao.
	p.CanQuery = false
	p.Size = tam
	p.CFrame = cf
	p.Color = cor
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = npc
	return p
end

for _, s in ipairs({ -1, 1 }) do
	local lado = s > 0 and "R" or "L"
	pecaNpc("Leg_" .. lado, Vector3.new(0.95, 1.4, 0.95), CFrame.new(X + s * 0.62, LAJE + 0.7, Z) * corpo, CAMISA_D)
	pecaNpc("Shoe_" .. lado, Vector3.new(1.15, 0.45, 1.45), CFrame.new(X + s * 0.62, LAJE + 0.22, Z + 0.2) * corpo, CINTO)
end

pecaNpc("Torso", Vector3.new(3.0, 2.2, 1.6), CFrame.new(X, LAJE + 2.5, Z) * corpo, CAMISA)
pecaNpc("Apron", Vector3.new(2.5, 1.9, 0.32), CFrame.new(X, LAJE + 2.35, Z + 0.86) * corpo, AVENTAL)
pecaNpc("ApronStrap_L", Vector3.new(0.34, 1.2, 0.3), CFrame.new(X - 0.85, LAJE + 3.3, Z + 0.8) * corpo, AVENTAL)
pecaNpc("ApronStrap_R", Vector3.new(0.34, 1.2, 0.3), CFrame.new(X + 0.85, LAJE + 3.3, Z + 0.8) * corpo, AVENTAL)
pecaNpc("Belt", Vector3.new(3.1, 0.42, 1.7), CFrame.new(X, LAJE + 1.6, Z) * corpo, CINTO)

-- braco direito levantado, acenando
pecaNpc("Arm_L", Vector3.new(0.85, 2.1, 0.85), CFrame.new(X - 1.9, LAJE + 2.5, Z + 0.1) * corpo * CFrame.Angles(0, 0, math.rad(-8)), CAMISA)
pecaNpc("Hand_L", Vector3.new(0.9, 0.7, 0.9), CFrame.new(X - 2.1, LAJE + 1.35, Z + 0.15) * corpo, PELE)
pecaNpc("Arm_R", Vector3.new(0.85, 2.1, 0.85), CFrame.new(X + 2.05, LAJE + 3.1, Z + 0.1) * corpo * CFrame.Angles(0, 0, math.rad(34)), CAMISA)
pecaNpc("Hand_R", Vector3.new(0.9, 0.8, 0.9), CFrame.new(X + 2.75, LAJE + 4.15, Z + 0.15) * corpo, PELE)

pecaNpc("Neck", Vector3.new(1.0, 0.35, 1.0), CFrame.new(X, LAJE + 3.75, Z) * corpo, PELE)
local cabeca = pecaNpc("Head", Vector3.new(2.3, 1.7, 2.0), CFrame.new(X, LAJE + 4.75, Z) * corpo, PELE)
cabeca.CanQuery = true
pecaNpc("Hair", Vector3.new(2.4, 0.55, 2.1), CFrame.new(X, LAJE + 5.5, Z - 0.05) * corpo, CABELO)
pecaNpc("HairBack", Vector3.new(2.4, 0.9, 0.5), CFrame.new(X, LAJE + 5.0, Z - 0.82) * corpo, CABELO)
for _, s in ipairs({ -1, 1 }) do
	pecaNpc("Eye_" .. (s > 0 and "R" or "L"), Vector3.new(0.3, 0.36, 0.16), CFrame.new(X + s * 0.5, LAJE + 4.85, Z + 1.0) * corpo, INK)
end
pecaNpc("Smile", Vector3.new(0.85, 0.16, 0.14), CFrame.new(X, LAJE + 4.32, Z + 1.0) * corpo, INK)
pecaNpc("CapCrown", Vector3.new(2.35, 0.7, 2.05), CFrame.new(X, LAJE + 5.9, Z) * corpo, CAMISA_D)
pecaNpc("CapBrim", Vector3.new(2.35, 0.24, 1.1), CFrame.new(X, LAJE + 5.6, Z + 1.4) * corpo, CAMISA)

npc.PrimaryPart = cabeca

-- caixa unica de colisao, para o jogador nao enroscar nas pecas soltas
local colisao = pecaNpc("CollisionBox", Vector3.new(3.2, 5.8, 2.2), CFrame.new(X, LAJE + 2.9, Z), PELE, true)
colisao.Transparency = 1
colisao.CanQuery = true

-- ------------------------------------------------------------
-- placa de nome
-- ------------------------------------------------------------
local bb = Instance.new("BillboardGui")
bb.Name = "NameTag"
bb.Adornee = cabeca
bb.Size = UDim2.fromOffset(150, 46)
bb.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
bb.AlwaysOnTop = false
bb.MaxDistance = 60
bb.Parent = cabeca

local fundo = Instance.new("Frame")
fundo.Size = UDim2.fromScale(1, 1)
fundo.BackgroundColor3 = Color3.fromRGB(30, 36, 62)
fundo.BorderSizePixel = 0
fundo.Parent = bb
local canto = Instance.new("UICorner")
canto.CornerRadius = UDim.new(0, 10)
canto.Parent = fundo
local traco = Instance.new("UIStroke")
traco.Thickness = 3
traco.Color = Color3.fromRGB(16, 18, 30)
traco.Parent = fundo

local nome = Instance.new("TextLabel")
nome.BackgroundTransparency = 1
nome.Size = UDim2.new(1, 0, 0.58, 0)
nome.Position = UDim2.fromScale(0, 0.06)
nome.Font = Enum.Font.FredokaOne
nome.Text = "PIP"
nome.TextColor3 = Color3.fromRGB(248, 244, 232)
nome.TextScaled = true
nome.Parent = fundo

local papel = Instance.new("TextLabel")
papel.BackgroundTransparency = 1
papel.Size = UDim2.new(1, 0, 0.32, 0)
papel.Position = UDim2.fromScale(0, 0.6)
papel.Font = Enum.Font.FredokaOne
papel.Text = "COSMETICS"
papel.TextColor3 = CAMISA
papel.TextScaled = true
papel.Parent = fundo

-- ------------------------------------------------------------
-- prompt que abre a loja
-- ------------------------------------------------------------
-- O UIController escuta ProximityPromptService.PromptTriggered e usa estes dois
-- atributos. Sem eles o prompt aparece e nao faz nada.
local prompt = Instance.new("ProximityPrompt")
prompt.Name = "ShopPrompt"
prompt.ActionText = "Browse"
prompt.ObjectText = "PIP"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.MaxActivationDistance = 14
prompt.RequiresLineOfSight = false
prompt.HoldDuration = 0
prompt:SetAttribute("Modal", "OpenPanel")
prompt:SetAttribute("Panel", "Cosmetics")
prompt.Parent = cabeca

-- ============================================================
-- conferencia
-- ============================================================
local _, tam = npc:GetBoundingBox()
local alerta = (#faltando > 0) and ("FALTANDO na area: " .. table.concat(faltando, ", ")) or "area completa"

print(string.format(
	"[BuildCosmeticsTent] tenda com %d pecas de lona, NPC com %d pecas, altura %.2f. Cabeca CanQuery=%s. %s",
	#lona:GetChildren(),
	#npc:GetChildren(),
	tam.Y,
	tostring(cabeca.CanQuery),
	alerta
))

return {
	pecasDeLona = #lona:GetChildren(),
	pecasDoNpc = #npc:GetChildren(),
	alturaDoNpc = tam.Y,
	cabecaConsultavel = cabeca.CanQuery,
	faltandoNaArea = faltando,
}
