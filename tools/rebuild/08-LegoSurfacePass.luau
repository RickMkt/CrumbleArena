--!strict
-- Textura lego no chao real do lobby.
--
-- Substitui `08-LegoPlating.luau`, que ficou obsoleto. Ver D-023, que revoga a
-- D-021 escrita algumas horas antes no mesmo dia.
--
-- ============================================================
-- O erro que este arquivo corrige
-- ============================================================
-- A D-016 dizia "stud vai na TopSurface". Isso vale enquanto o mundo e feito de
-- `Part` sem rotacao. O lobby reconstruido pelo Astra e feito de `WedgePart`
-- girados, e neles a face que aponta para o ceu NAO e a TopSurface.
--
-- Medido em `IslandGrass.Face1_1`:
--     Size        = (2.00, 23.31, 30.36)
--     RightVector = (0, -1, 0)
--
-- O eixo X local da peca aponta para baixo no mundo. Logo a face virada para
-- cima e a `LeftSurface`. Na peca vizinha, `Face1_2`, o `RightVector` vale
-- (0, 1, 0) e a face de cima e a `RightSurface`. Elas alternam.
--
-- Como eu so escrevia em `TopSurface`, a propriedade gravava e nada aparecia na
-- tela. Dai eu concluir, errado, que WedgePart nao aceita stud, e construir uma
-- camada de 1.317 placas por cima do terreno. Aquilo funcionava, mas a placa
-- tinha 0.3 de espessura e virava uma prateleira em toda borda: de longe a ilha
-- lia como tapete recortado. O Rick apontou isso olhando, antes de qualquer
-- medicao minha.
--
-- A regra correta nao e um nome de propriedade. E: **a face cuja normal aponta
-- para cima**, seja ela qual for.
--
-- ============================================================
-- Resultado
-- ============================================================
-- 384 superficies com stud, zero peca nova, zero camada, e o contorno poligonal
-- do terreno preservado inteiro. O lobby caiu de 1.887 para 793 BaseParts.
--
-- Como rodar: Command Bar do Studio, modo Edit. Rodar de novo e seguro: ele
-- limpa as seis faces antes de decidir qual recebe stud.

local L = workspace.CrumbleArena.Lobby
local lojista = L.Market:FindFirstChild("Shopkeeper")

-- As seis faces, cada uma com a direcao da propria normal em coordenadas do
-- mundo, e com os dois lados perpendiculares a ela.
local FACES = {
	{ nome = "RightSurface", dir = function(cf: CFrame) return cf.RightVector end, a = "Y", b = "Z" },
	{ nome = "LeftSurface", dir = function(cf: CFrame) return -cf.RightVector end, a = "Y", b = "Z" },
	{ nome = "TopSurface", dir = function(cf: CFrame) return cf.UpVector end, a = "X", b = "Z" },
	{ nome = "BottomSurface", dir = function(cf: CFrame) return -cf.UpVector end, a = "X", b = "Z" },
	{ nome = "BackSurface", dir = function(cf: CFrame) return -cf.LookVector end, a = "X", b = "Y" },
	{ nome = "FrontSurface", dir = function(cf: CFrame) return cf.LookVector end, a = "X", b = "Y" },
}

-- Limite da D-016, mantido: stud tem tamanho fixo, e numa peca estreita ele
-- vira sujeira. O que muda e como se mede a largura. Nao sao mais `Size.X` e
-- `Size.Z`, e sim os dois lados perpendiculares ao eixo que aponta para cima.
local LADO_MINIMO = 3

-- Pastas que este script nao toca. `Information` esta aqui porque em 2026-09-06
-- outro agente trabalhava nela ao mesmo tempo, e sobrescrever propriedade de
-- quem esta editando e como se perde trabalho. Reveja esta lista.
local function forcaDeFora(d: BasePart): boolean
	return (lojista ~= nil and d:IsDescendantOf(lojista))
		or d:IsDescendantOf(L.Boundaries)
		or d:IsDescendantOf(L.Information)
end

local conta = { studs = 0, limpas = 0, estreitas = 0, semFaceAcima = 0, puladas = 0 }
local porFace: { [string]: number } = {}

for _, d in ipairs(L:GetDescendants()) do
	-- MeshPart fica de fora: SurfaceType nao tem efeito nelas, ver D-016
	if d:IsA("BasePart") and not d:IsA("MeshPart") then
		local pula = forcaDeFora(d)
			or d.Transparency > 0.05
			or d.Material == Enum.Material.Neon
			or d.Material == Enum.Material.ForceField
			or d:GetAttribute("KeepSurface") ~= nil
		if pula then
			conta.puladas += 1
		else
			-- Limpa as seis antes de decidir. Stud gravado em face que nao
			-- aparece e a armadilha que gerou este arquivo, e a auditoria
			-- precisa poder contar zero delas.
			for _, f in ipairs(FACES) do
				if d[f.nome] == Enum.SurfaceType.Studs then
					conta.limpas += 1
				end
				d[f.nome] = Enum.SurfaceType.Smooth
			end
			-- stud so renderiza com Plastic, ver D-016
			d.Material = Enum.Material.Plastic

			local melhor, melhorY = nil, -2
			for _, f in ipairs(FACES) do
				local y = f.dir(d.CFrame).Y
				if y > melhorY then
					melhorY, melhor = y, f
				end
			end
			if melhorY <= 0.9 or melhor == nil then
				conta.semFaceAcima += 1
			elseif math.min(d.Size[melhor.a], d.Size[melhor.b]) < LADO_MINIMO then
				conta.estreitas += 1
			else
				d[melhor.nome] = Enum.SurfaceType.Studs
				conta.studs += 1
				porFace[melhor.nome] = (porFace[melhor.nome] or 0) + 1
			end
		end
	end
end

-- ============================================================
-- conferencia, o script checa o proprio resultado
-- ============================================================
local inuteis = 0
for _, d in ipairs(L:GetDescendants()) do
	if d:IsA("BasePart") and not d:IsA("MeshPart") and not forcaDeFora(d) then
		for _, f in ipairs(FACES) do
			if d[f.nome] == Enum.SurfaceType.Studs and f.dir(d.CFrame).Y <= 0.9 then
				inuteis += 1
			end
		end
	end
end

local detalhe = {}
for k, v in pairs(porFace) do
	table.insert(detalhe, string.format("%s=%d", k, v))
end
table.sort(detalhe)
print(
	string.format(
		"[LegoSurfacePass] %d com stud (%s) | %d faces limpas | %d estreitas | %d sem face para cima | %d puladas",
		conta.studs,
		table.concat(detalhe, " "),
		conta.limpas,
		conta.estreitas,
		conta.semFaceAcima,
		conta.puladas
	)
)
assert(inuteis == 0, string.format("%d faces ficaram com stud gravado sem apontar para cima", inuteis))
return conta
