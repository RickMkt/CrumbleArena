--!strict
-- Reconstroi a cerca da borda da ilha e reforca as barreiras invisiveis.
--
-- Como rodar: colar no Command Bar do Studio, em modo Edit, e executar.
-- Rodar de novo e seguro, o script apaga a cerca anterior antes de recriar.
--
-- Ver D-018 em docs/DECISIONS.md.

local lobby = workspace:WaitForChild("CrumbleArena"):WaitForChild("Lobby")
local borders = lobby.Island.Borders

-- A cerca fica logo dentro da barreira invisivel, que esta no raio 124.
local RAIO = 120.5
local N = 48
local ALTURA_BARREIRA = 26

local WOOD_DARK = Color3.fromRGB(104, 70, 42)
local WOOD_MID = Color3.fromRGB(138, 94, 56)
local WOOD_LIGHT = Color3.fromRGB(166, 118, 70)

-- ------------------------------------------------------------
-- limpeza do que este script criou antes
-- ------------------------------------------------------------
local anterior = borders:FindFirstChild("RimFence")
if anterior then
	anterior:Destroy()
end
local cerca = Instance.new("Folder")
cerca.Name = "RimFence"
cerca.Parent = borders

-- ------------------------------------------------------------
-- utilidades
-- ------------------------------------------------------------
local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Include
rp.FilterDescendantsInstances = { lobby.Island.Base }

local function chao(x: number, z: number): number?
	local h = workspace:Raycast(Vector3.new(x, 90, z), Vector3.new(0, -160, 0), rp)
	return h and h.Position.Y or nil
end

local function peca(nome: string, tam: Vector3, cf: CFrame, cor: Color3, studs: boolean?): Part
	local p = Instance.new("Part")
	p.Name = nome
	p.Anchored = true
	p.CanCollide = true
	p.Size = tam
	p.CFrame = cf
	p.Color = cor
	p.Material = studs and Enum.Material.Plastic or Enum.Material.SmoothPlastic
	p.TopSurface = studs and Enum.SurfaceType.Studs or Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = cerca
	return p
end

-- Uma peca so pode entrar se nao invadir nada que ja existe. Grama e penhasco
-- ficam de fora da conta porque a cerca encosta neles de proposito.
local function invade(d: BasePart): string?
	for _, o in ipairs(lobby:GetDescendants()) do
		if
			o:IsA("BasePart")
			and o ~= d
			and o.Transparency < 0.9
			and not o:IsDescendantOf(cerca)
			and not o:IsDescendantOf(lobby.Island.Base)
			and not o:IsDescendantOf(lobby.Island.Cliffs)
			and not o:IsDescendantOf(lobby.Safety)
		then
			local ox = d.Size.X / 2 + o.Size.X / 2 - math.abs(d.Position.X - o.Position.X)
			local oy = d.Size.Y / 2 + o.Size.Y / 2 - math.abs(d.Position.Y - o.Position.Y)
			local oz = d.Size.Z / 2 + o.Size.Z / 2 - math.abs(d.Position.Z - o.Position.Z)
			if ox > 0.4 and oy > 0.4 and oz > 0.4 then
				return o.Name
			end
		end
	end
	return nil
end

-- ------------------------------------------------------------
-- postes
-- ------------------------------------------------------------
local passo = 2 * math.pi / N
local pontos: { [number]: Vector3 } = {}
local semChao, semLugar = {}, {}

for i = 0, N - 1 do
	local a = i * passo
	local colocado = false
	-- se o raio padrao estiver ocupado, tenta alguns raios proximos antes de desistir
	for _, dr in ipairs({ 0, -4, 4, -8, 8, -12 }) do
		local r = RAIO + dr
		local x, z = math.cos(a) * r, math.sin(a) * r
		local y = chao(x, z)
		if y then
			local giro = CFrame.Angles(0, -a, 0)
			local p = peca(string.format("FencePost_%02d", i), Vector3.new(1.5, 7.4, 1.5), CFrame.new(x, y + 3.2, z) * giro, WOOD_DARK, true)
			if invade(p) then
				p:Destroy()
			else
				peca(string.format("FencePostCap_%02d", i), Vector3.new(2.1, 0.6, 2.1), CFrame.new(x, y + 7.2, z) * giro, WOOD_LIGHT)
				pontos[i] = Vector3.new(x, y, z)
				colocado = true
				break
			end
		elseif dr == 0 then
			semChao[#semChao + 1] = string.format("%.0f graus", math.deg(a))
		end
	end
	if not colocado then
		semLugar[#semLugar + 1] = string.format("poste %d", i)
	end
end

-- ------------------------------------------------------------
-- travessas, so entre postes que existem dos dois lados
-- ------------------------------------------------------------
local travessas = 0
for i = 0, N - 1 do
	local p = pontos[i]
	local q = pontos[(i + 1) % N]
	if p and q then
		local meio = (p + q) * 0.5
		local comp = (Vector3.new(q.X, 0, q.Z) - Vector3.new(p.X, 0, p.Z)).Magnitude
		local dir = (Vector3.new(q.X, 0, q.Z) - Vector3.new(p.X, 0, p.Z)).Unit
		local base = Vector3.new(meio.X, 0, meio.Z)
		local olhar = CFrame.lookAt(base, base + dir)
		for _, nivel in ipairs({ { n = "Top", y = 5.6, h = 1.0 }, { n = "Mid", y = 3.0, h = 0.9 } }) do
			local cf = CFrame.new(meio.X, meio.Y + nivel.y, meio.Z) * (olhar - olhar.Position)
			local t = peca(string.format("FenceRail%s_%02d", nivel.n, i), Vector3.new(0.55, nivel.h, comp + 0.6), cf, WOOD_MID)
			if invade(t) then
				t:Destroy()
			else
				travessas += 1
			end
		end
	end
end

-- ------------------------------------------------------------
-- barreira invisivel
-- ------------------------------------------------------------
-- Cobre qualquer escalada ate cerca de 19.6, que e o topo da cerca mais um pulo.
local barreiras = 0
for _, d in ipairs(lobby.Safety.InvisibleBarriers:GetChildren()) do
	if d:IsA("BasePart") then
		local base = d.Position.Y - d.Size.Y / 2
		d.Size = Vector3.new(d.Size.X, ALTURA_BARREIRA, d.Size.Z)
		d.CFrame = CFrame.new(d.Position.X, base + ALTURA_BARREIRA / 2, d.Position.Z) * (d.CFrame - d.CFrame.Position)
		d.Transparency = 1
		d.CanCollide = true
		barreiras += 1
	end
end

-- ------------------------------------------------------------
-- conferencia
-- ------------------------------------------------------------
local rpBarreira = RaycastParams.new()
rpBarreira.FilterType = Enum.RaycastFilterType.Include
rpBarreira.FilterDescendantsInstances = { lobby.Safety.InvisibleBarriers }

local furos = 0
for _, alt in ipairs({ 1, 4, 8, 12, 16, 20 }) do
	for i = 0, 359 do
		local a = math.rad(i)
		if not workspace:Raycast(Vector3.new(0, alt, 0), Vector3.new(math.cos(a), 0, math.sin(a)) * 220, rpBarreira) then
			furos += 1
		end
	end
end

local flutuando = 0
for _, c in ipairs(cerca:GetChildren()) do
	if c:IsA("BasePart") and c.Name:match("^FencePost_%d+$") then
		local y = chao(c.Position.X, c.Position.Z)
		if y and (c.Position.Y - c.Size.Y / 2) - y > 0.8 then
			flutuando += 1
		end
	end
end

local conflitos = 0
for _, c in ipairs(cerca:GetChildren()) do
	if c:IsA("BasePart") and invade(c) then
		conflitos += 1
	end
end

local postes = 0
for _ in pairs(pontos) do
	postes += 1
end

print(string.format(
	"[BuildIslandFence] %d postes, %d travessas, %d pecas. Barreira: %d segmentos de %d studs, %d furos em 2160 raios. Postes flutuando: %d. Conflitos: %d.",
	postes,
	travessas,
	#cerca:GetChildren(),
	barreiras,
	ALTURA_BARREIRA,
	furos,
	flutuando,
	conflitos
))

return {
	postes = postes,
	travessas = travessas,
	pecas = #cerca:GetChildren(),
	barreiras = barreiras,
	furosNaBarreira = furos,
	postesFlutuando = flutuando,
	conflitos = conflitos,
	pontosSemChao = semChao,
	postesSemLugar = semLugar,
}
