--!strict
-- Aplica iluminacao, ceu, nuvens e a musica do lobby.
--
-- Como rodar: colar no Command Bar do Studio, em modo Edit, e executar.
-- Rodar de novo e seguro, o script sobrescreve os proprios valores.
--
-- Antes de mudar qualquer coisa ele imprime o estado anterior, para dar como
-- reverter. Ver D-018 em docs/DECISIONS.md.

local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- ============================================================
-- estado anterior, para poder voltar
-- ============================================================
local antes = {}
for _, k in ipairs({
	"Brightness", "ClockTime", "ExposureCompensation", "ShadowSoftness",
	"EnvironmentDiffuseScale", "EnvironmentSpecularScale", "GeographicLatitude",
}) do
	antes[k] = (Lighting :: any)[k]
end
antes.Ambient = tostring(Lighting.Ambient)
antes.OutdoorAmbient = tostring(Lighting.OutdoorAmbient)

-- ============================================================
-- iluminacao
-- ============================================================
-- Tarde ensolarada e quente. Os numeros vieram de tentativa e erro em captura:
-- Brightness 2.9 lavava a cena, e ExposureCompensation negativo deixava tudo cinza.
Lighting.ClockTime = 14.6
Lighting.GeographicLatitude = 14
Lighting.Brightness = 2.4
Lighting.ExposureCompensation = 0.05
Lighting.Ambient = Color3.fromRGB(102, 106, 118)
Lighting.OutdoorAmbient = Color3.fromRGB(158, 164, 176)
Lighting.EnvironmentDiffuseScale = 0.68
Lighting.EnvironmentSpecularScale = 0.22
Lighting.GlobalShadows = true
Lighting.ShadowSoftness = 0.24

local function pegar(classe: string, nome: string): any
	local e = Lighting:FindFirstChildOfClass(classe)
	if not e then
		e = Instance.new(classe)
		e.Parent = Lighting
	end
	e.Name = nome
	return e
end

local sky = pegar("Sky", "LobbySky")
sky.CelestialBodiesShown = true
sky.SunAngularSize = 12
sky.MoonAngularSize = 8
sky.StarCount = 0

local atm = pegar("Atmosphere", "LobbyAtmosphere")
atm.Density = 0.22
atm.Offset = 0.05
atm.Color = Color3.fromRGB(226, 232, 224)
atm.Decay = Color3.fromRGB(122, 168, 214)
atm.Glare = 0.1
atm.Haze = 1.4

local bloom = pegar("BloomEffect", "LobbyBloom")
-- bloom minimo e regra do projeto, nao gosto pessoal
bloom.Intensity = 0.2
bloom.Size = 28
bloom.Threshold = 2.0

local sun = pegar("SunRaysEffect", "LobbySunRays")
sun.Intensity = 0.03
sun.Spread = 1.0

local cc = pegar("ColorCorrectionEffect", "LobbyGrade")
cc.Brightness = 0.0
cc.Contrast = 0.15
cc.Saturation = 0.16
cc.TintColor = Color3.fromRGB(255, 252, 246)

-- DepthOfField nao pode ficar ligado durante a jogabilidade
local dof = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
if dof then
	dof.Enabled = false
end

-- ============================================================
-- nuvens
-- ============================================================
-- Ceu vazio e proibido pela direcao visual. Nuvem grossa e bem definida le como
-- forma, e nao como nevoa, o que combina com low poly.
local nuvens = workspace.Terrain:FindFirstChildOfClass("Clouds")
if not nuvens then
	nuvens = Instance.new("Clouds")
	nuvens.Parent = workspace.Terrain
end
nuvens.Name = "LobbyClouds"
nuvens.Cover = 0.55
nuvens.Density = 0.78
nuvens.Color = Color3.fromRGB(255, 254, 250)
nuvens.Enabled = true

-- ============================================================
-- musica
-- ============================================================
-- APM Music e biblioteca de producao licenciada e parceira oficial do Roblox,
-- com metadado estruturado. Ver ASSET-INVENTORY.md.
local grupo = SoundService:FindFirstChild("SFX")
if not grupo then
	grupo = Instance.new("SoundGroup")
	grupo.Name = "SFX"
	grupo.Parent = SoundService
end
;(grupo :: SoundGroup).Volume = 1

local musica = SoundService:FindFirstChild("LobbyMusic")
if not musica then
	musica = Instance.new("Sound")
	musica.Name = "LobbyMusic"
	musica.Parent = SoundService
end
local m = musica :: Sound
m.SoundId = "rbxassetid://9038305339"
m.Looped = true
m.Volume = 0.16
m.Playing = false
m:SetAttribute("Nome", "Skip in Your Step (b)")
m:SetAttribute("AssetId", 9038305339)
m:SetAttribute("Criador", "APMOfficial")
m:SetAttribute("Biblioteca", "APM Music, Ded Good, album Upbeat Acoustic")
m:SetAttribute("Duracao", "125 s")
m:SetAttribute("Genero", "Contemporary Folk, instrumental sem voz")

-- ============================================================
-- relatorio
-- ============================================================
local linhas = {}
for k, v in pairs(antes) do
	table.insert(linhas, string.format("%s: %s", k, tostring(v)))
end
table.sort(linhas)

print("[ApplyEnvironment] estado anterior, para reverter se precisar:")
for _, l in ipairs(linhas) do
	print("   " .. l)
end
print(string.format(
	"[ApplyEnvironment] aplicado. ClockTime %.1f, Brightness %.1f, nuvens %.2f/%.2f, musica %s",
	Lighting.ClockTime,
	Lighting.Brightness,
	nuvens.Cover,
	nuvens.Density,
	m.SoundId
))

return {
	anterior = antes,
	clockTime = Lighting.ClockTime,
	brightness = Lighting.Brightness,
	nuvens = { cover = nuvens.Cover, density = nuvens.Density },
	musica = m.SoundId,
	depthOfFieldDesligado = dof ~= nil and not dof.Enabled or "nao existe",
}
