--!strict
-- Lojista do mercado: posicao, pose de aceno, rosto, bone e avental.
--
-- Roda depois de `06-BuildMarketStall.luau`. Depende de um backup do rig em
-- pose neutra em `ServerStorage.MarketRollback_20260906.MarketBeforeLegoRebuild`,
-- porque a pose sempre parte do neutro, nunca da pose anterior.
--
-- Tres fatos deste rig que mudam como se trabalha nele:
--
-- 1. As 16 pecas estao ancoradas e as juntas sao AnimationConstraint com
--    BallSocketConstraint, nao Motor6D. Constraint nao arrasta peca ancorada,
--    entao a pose escrita aqui e permanente e aparece em Edit e em Play, sem
--    depender de animacao com Asset ID. Nao ha Animate no rig.
-- 2. Girar em torno de `HumanoidRootPart.LookVector` com angulo POSITIVO leva
--    o braco direito para dentro do corpo. O aceno usa angulo negativo. Isso
--    foi medido de 30 em 30 graus, nao deduzido: no neutro a mao esta em X
--    local 1.50, e com +30, +60 e +90 ela vai para 0.58, -0.09 e -0.34.
-- 3. O ponto do ombro precisa ser lido UMA vez, no neutro. Recalcular o ombro
--    como "topo do braco" depois de cada giro quebra a pose: passados 90 graus
--    o topo local do braco ja aponta para baixo, o pivo vira o punho e o braco
--    se solta do corpo. Foi assim que a primeira pose ficou desmontada.

local SS = game:GetService("ServerStorage")
local L = workspace.CrumbleArena.Lobby
local M = L.Market
local S = M.Shopkeeper

local rollback = SS:FindFirstChild("MarketRollback_20260906")
local backup = rollback and rollback:FindFirstChild("MarketBeforeLegoRebuild")
local origem = backup and backup:FindFirstChild("Shopkeeper")
assert(origem, "sem backup do rig em pose neutra, abortando para nao empilhar pose sobre pose")

local DECK = 3.6
local DESTINO = Vector3.new(-46.5, DECK, -38.7) -- x, pe no assoalho, z atras do balcao

-- ============================================================
-- 1. posicao
-- ============================================================
-- Move o rig inteiro como corpo rigido, a partir do neutro do backup, e depois
-- gira 9 graus para o lojista nao ficar perfeitamente de frente.
local hrpOrig = origem.HumanoidRootPart.CFrame
local peMaisBaixo = math.huge
for _, d in ipairs(origem:GetDescendants()) do
	if d:IsA("BasePart") then
		peMaisBaixo = math.min(peMaisBaixo, d.Position.Y - d.Size.Y / 2)
	end
end
local alvo = CFrame.new(DESTINO.X, hrpOrig.Position.Y + (DESTINO.Y - peMaisBaixo), DESTINO.Z)
	* (hrpOrig - hrpOrig.Position)
	* CFrame.Angles(0, math.rad(-9), 0)

for _, d in ipairs(origem:GetDescendants()) do
	if d:IsA("BasePart") then
		local atual = S:FindFirstChild(d.Name)
		if atual and atual:IsA("BasePart") then
			atual.CFrame = alvo * hrpOrig:ToObjectSpace(d.CFrame)
		end
	end
end

-- ============================================================
-- 2. pose de aceno
-- ============================================================
local hrp = S.HumanoidRootPart.CFrame
local cadeia = { "RightUpperArm", "RightLowerArm", "RightHand" }
local ua = S.RightUpperArm
local ombro = ua.Position + Vector3.new(0, ua.Size.Y / 2, 0)
local cotovelo = ua.Position - Vector3.new(0, ua.Size.Y / 2, 0)

local function girar(nomes, ponto, graus)
	local pivo = CFrame.new(ponto)
	local T = pivo * CFrame.fromAxisAngle(hrp.LookVector, math.rad(graus)) * pivo:Inverse()
	for _, n in ipairs(nomes) do
		S[n].CFrame = T * S[n].CFrame
	end
	return T
end

local T1 = girar(cadeia, ombro, -74) -- braco abre ate quase a horizontal
local cotoveloDepois = (T1 * CFrame.new(cotovelo)).Position
girar({ "RightLowerArm", "RightHand" }, cotoveloDepois, -82) -- antebraco sobe

-- ============================================================
-- 3. colisao
-- ============================================================
-- Peca de corpo R15 nasce com CanCollide true e CanQuery false. Esse par e o
-- colisor fantasma descrito no PROJECT-MEMORY: barra o jogador e some para a
-- sonda de auditoria. O lojista e enfeite, entao perde a colisao.
for _, d in ipairs(S:GetDescendants()) do
	if d:IsA("BasePart") then
		d.Anchored = true
		d.CanCollide = false
	end
end

-- ============================================================
-- 4. rosto, bone e avental
-- ============================================================
local cabeca = S.Head
local rostoAntigo = cabeca:FindFirstChild("face")
if rostoAntigo then
	rostoAntigo:Destroy()
end
local rosto = Instance.new("Decal")
rosto.Name = "face"
rosto.Texture = "rbxasset://textures/face.png" -- rbxasset, nao precisa de Asset ID
rosto.Face = Enum.NormalId.Front
rosto.Parent = cabeca

local vestAntigo = S:FindFirstChild("Outfit")
if vestAntigo then
	vestAntigo:Destroy()
end
local vest = Instance.new("Folder")
vest.Name = "Outfit"
vest.Parent = S

local function acessorio(nome, tam, cf, cor)
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame, p.Color = nome, tam, cf, cor
	p.Anchored, p.CanCollide, p.CanQuery = true, false, false
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.Parent = vest
	return p
end

local topo = cabeca.Position.Y + cabeca.Size.Y / 2
local cx, cz = cabeca.Position.X, cabeca.Position.Z
acessorio("CapCrown", Vector3.new(1.34, 0.52, 1.34), CFrame.new(cx, topo + 0.20, cz), Color3.fromRGB(42, 130, 143))
acessorio("CapBand", Vector3.new(1.40, 0.16, 1.40), CFrame.new(cx, topo + 0.02, cz), Color3.fromRGB(246, 196, 70))
acessorio("CapBrim", Vector3.new(1.34, 0.16, 0.62), CFrame.new(cx, topo + 0.02, cz + 0.90), Color3.fromRGB(42, 130, 143))

local torso = S.UpperTorso
acessorio(
	"Apron",
	Vector3.new(1.72, 1.42, 0.18),
	CFrame.new(torso.Position.X, torso.Position.Y - 0.10, torso.Position.Z + torso.Size.Z / 2 + 0.10),
	Color3.fromRGB(240, 228, 199)
)
acessorio(
	"ApronBand",
	Vector3.new(1.78, 0.26, 0.22),
	CFrame.new(torso.Position.X, torso.Position.Y + 0.48, torso.Position.Z + torso.Size.Z / 2 + 0.10),
	Color3.fromRGB(42, 130, 143)
)

-- ============================================================
-- 5. placa de nome e prompt
-- ============================================================
local tag = cabeca:FindFirstChild("NameTag")
if tag then
	tag.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
	tag.Size = UDim2.fromScale(7.5, 2.2)
	tag.MaxDistance = 90
	for _, t in ipairs(tag:GetDescendants()) do
		if t:IsA("TextLabel") then
			if t.Text == "PIP" then
				t.TextColor3 = Color3.fromRGB(255, 236, 190)
			else
				t.Text = "MARKET"
				t.TextColor3 = Color3.fromRGB(246, 196, 70)
			end
		end
	end
end
local prompt = cabeca:FindFirstChild("ShopPrompt")
if prompt then
	prompt.ActionText = "Browse"
	prompt.ObjectText = "PIP, Market"
	prompt.MaxActivationDistance = 16
	prompt.RequiresLineOfSight = false
	prompt.UIOffset = Vector2.new(0, -20)
end

-- ============================================================
-- 6. conferencia, o script checa o proprio resultado
-- ============================================================
local pe = math.huge
for _, d in ipairs(S:GetDescendants()) do
	if d:IsA("BasePart") then
		pe = math.min(pe, d.Position.Y - d.Size.Y / 2)
	end
end
local mao = hrp:PointToObjectSpace(S.RightHand.Position)
print(
	string.format(
		"[Shopkeeper] pe em Y %.2f (deck %.2f) | mao local X %.2f, mundo Y %.2f | cabeca ate %.2f, bandos do toldo em 9.64",
		pe,
		DECK,
		mao.X,
		S.RightHand.Position.Y,
		S.Head.Position.Y + S.Head.Size.Y / 2
	)
)
assert(math.abs(pe - DECK) < 0.02, "o lojista nao ficou apoiado no assoalho")
assert(mao.X > 1.5, "o braco girou para dentro do corpo, o sinal do angulo esta invertido")
return { pe = pe, maoLocalX = mao.X }
