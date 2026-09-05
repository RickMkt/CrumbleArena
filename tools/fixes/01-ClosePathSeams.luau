--!strict
-- Fecha as frestas entre as placas dos caminhos.
--
-- O problema: as placas giram ao longo da curva, cerca de 4 graus por segmento.
-- Como sao caixas retangulares, a emenda vira uma cunha que abre para o lado de
-- fora da curva. Medido em 2026-09-05: 0.00 na borda interna, 0.10 no centro e
-- ate 0.66 na borda externa, que fica dentro da faixa que o jogador pisa. O meio
-- fio nao cobre, ele comeca exatamente na borda da placa e vai para fora.
--
-- A correcao alonga cada peca no eixo do caminho, mantendo o centro. As placas
-- passam a se sobrepor um pouco na emenda. Isso e de proposito: em curva, com
-- caixas retangulares, ou sobra fresta do lado de fora ou sobra sobreposicao do
-- lado de dentro, nao existe terceira opcao. Como as placas ficam em alturas
-- diferentes, as faces de cima nunca sao coplanares e nao ha z-fighting.
--
-- Como rodar: colar no Command Bar do Studio, em modo Edit, e executar.
-- Rodar de novo e seguro, o script ignora peca que ja tem o atributo.
--
-- Para reverter: ver a funcao reverter() no fim do arquivo.

local FOLGA = 0.8 -- fecha fresta de ate 0.8. A pior medida era 0.66

local paths = workspace.CrumbleArena.Lobby.Island.Paths

-- ============================================================
-- medicao, antes e depois
-- ============================================================
-- Mede varrendo AO LONGO do caminho e contando quanto do trecho cai na grama.
-- Amostrar em cima da linha da emenda sempre da aberto e nao mede nada.
local function larguraFresta(a: BasePart, b: BasePart, fracLateral: number): number
	local meio = (a.Position + b.Position) / 2
	local lateral = (a.CFrame.RightVector + b.CFrame.RightVector).Unit
	local avanco = b.Position - a.Position
	avanco = Vector3.new(avanco.X, 0, avanco.Z).Unit
	local base = meio + lateral * (fracLateral * math.min(a.Size.X, b.Size.X))
	local aberto = 0
	for t = -1.4, 1.4, 0.02 do
		local q = base + avanco * t
		local h = workspace:Raycast(Vector3.new(q.X, meio.Y + 12, q.Z), Vector3.new(0, -30, 0))
		if (not h) or h.Instance.Name:match("Cell") then
			aberto += 0.02
		end
	end
	return aberto
end

local function placasDe(cam: Instance): { BasePart }
	local lista = {}
	for _, d in ipairs(cam:GetDescendants()) do
		if d:IsA("BasePart") and d.CanCollide then
			table.insert(lista, d)
		end
	end
	table.sort(lista, function(x, y)
		return x.Position.Magnitude < y.Position.Magnitude
	end)
	return lista
end

local function piorFresta(cam: Instance): number
	local placas = placasDe(cam)
	local pior = 0
	for i = 1, #placas - 1 do
		for _, f in ipairs({ -0.46, 0, 0.46 }) do
			pior = math.max(pior, larguraFresta(placas[i], placas[i + 1], f))
		end
	end
	return pior
end

-- ============================================================
-- aplicacao
-- ============================================================
local antes: { [string]: number } = {}
for _, cam in ipairs(paths:GetChildren()) do
	antes[cam.Name] = piorFresta(cam)
end

local mexidas = 0
for _, cam in ipairs(paths:GetChildren()) do
	for _, d in ipairs(cam:GetDescendants()) do
		-- placa e meio fio, os dois. O meio fio tem o mesmo comprimento da
		-- placa, entao repete a mesma fresta.
		if d:IsA("BasePart") and not d:GetAttribute("ComprimentoOriginal") then
			d:SetAttribute("ComprimentoOriginal", d.Size.Z)
			d.Size = Vector3.new(d.Size.X, d.Size.Y, d.Size.Z + FOLGA)
			mexidas += 1
		end
	end
end

-- ============================================================
-- relatorio, o script confere o proprio resultado
-- ============================================================
print(string.format("[ClosePathSeams] pecas alongadas em %.1f: %d", FOLGA, mexidas))
print("[ClosePathSeams] ------------------------------------------------")
local aindaAberto = 0
for _, cam in ipairs(paths:GetChildren()) do
	local depois = piorFresta(cam)
	if depois > 0.05 then
		aindaAberto += 1
	end
	print(string.format("[ClosePathSeams] %-18s antes %.2f  depois %.2f", cam.Name, antes[cam.Name], depois))
end
print("[ClosePathSeams] ------------------------------------------------")
print(string.format("[ClosePathSeams] caminhos ainda com fresta: %d", aindaAberto))

-- ============================================================
-- reversao
-- ============================================================
-- Cole isto no Command Bar para desfazer:
--
-- for _, cam in ipairs(workspace.CrumbleArena.Lobby.Island.Paths:GetChildren()) do
-- 	for _, d in ipairs(cam:GetDescendants()) do
-- 		local orig = d:GetAttribute("ComprimentoOriginal")
-- 		if d:IsA("BasePart") and orig then
-- 			d.Size = Vector3.new(d.Size.X, d.Size.Y, orig)
-- 			d:SetAttribute("ComprimentoOriginal", nil)
-- 		end
-- 	end
-- end

return {
	pecasAlongadas = mexidas,
	folga = FOLGA,
	caminhosAindaComFresta = aindaAberto,
}
