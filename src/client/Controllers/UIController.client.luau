--!strict
-- Controlador da interface do lobby.
-- Faz so o que a fase atual permite: abrir e fechar painel, hover, toque, Escape,
-- ligar e desligar audio, o modal de Coming Soon e o preview do HUD.
-- Nao existe DataStore, compra, votacao real nem sistema de round por tras disto.
--
-- Copia versionada. A instancia viva fica em
-- StarterPlayer.StarterPlayerScripts.UIController dentro do place.
-- Ver D-017 em docs/DECISIONS.md.

local ContextActionService = game:GetService("ContextActionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("CrumbleUI")
local escalaGlobal = gui:WaitForChild("GlobalScale") :: UIScale
local paineis = gui:WaitForChild("Panels")
local scrim = gui:WaitForChild("Scrim") :: TextButton
local barraLateral = gui:WaitForChild("SideButtons")
local hud = gui:WaitForChild("TopHud")

local RAPIDO = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ABRIR = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local painelAberto: Frame? = nil

-- ---------- escala por tamanho de tela ----------
-- O layout foi desenhado para 1080 de altura. Abaixo disso tudo encolhe junto,
-- e em tela estreita o minimo sobe para o dedo continuar acertando o botao.
local function ajustarEscala()
	local cam = workspace.CurrentCamera
	local v = cam and cam.ViewportSize or Vector2.new(1920, 1080)
	-- Enquanto a janela inicializa, ou quando ela fica oculta, o ViewportSize vem
	-- degenerado, tipo 1 por 1. Usar esse valor jogaria a interface para o layout de
	-- telefone sem motivo. Nesse caso nao mexe em nada e espera o proximo evento.
	if v.X < 50 or v.Y < 50 then
		return
	end
	local porAltura = v.Y / 1080
	local porLargura = v.X / 1600
	local e = math.min(porAltura, porLargura)
	-- O joystick do Roblox ocupa o canto inferior esquerdo e o botao de pulo o direito.
	-- Em toque a barra vai para o rodape centralizado, que e a unica faixa livre.
	local ehEstreito = v.X < 700 or UserInputService.TouchEnabled
	e = math.clamp(e, ehEstreito and 0.62 or 0.7, 1.15)
	escalaGlobal.Scale = e

	-- Em tela estreita a barra vira horizontal no rodape. Vertical no canto ocupava
	-- mais de metade da altura util e cobria o cenario.
	local layout = barraLateral:FindFirstChildOfClass("UIListLayout")
	if ehEstreito then
		barraLateral.AnchorPoint = Vector2.new(0.5, 1)
		barraLateral.Position = UDim2.new(0.5, 0, 1, -10)
		barraLateral.Size = UDim2.fromOffset(math.min(380, v.X / math.max(e, 0.01) - 40), 84)
		if layout then
			layout.FillDirection = Enum.FillDirection.Horizontal
			layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		end
	else
		barraLateral.AnchorPoint = Vector2.new(0, 0.5)
		barraLateral.Position = UDim2.new(0, 18, 0.5, 20)
		barraLateral.Size = UDim2.fromOffset(84, 380)
		if layout then
			layout.FillDirection = Enum.FillDirection.Vertical
			layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			layout.VerticalAlignment = Enum.VerticalAlignment.Center
		end
	end
	-- o painel aberto tambem sobe, para nao ficar debaixo da barra do rodape
	if painelAberto then
		painelAberto.Position = ehEstreito and UDim2.new(0.5, 0, 0.5, -40) or UDim2.fromScale(0.5, 0.5)
	end
end

-- ---------- abrir e fechar ----------
local function fechar()
	if not painelAberto then return end
	local p = painelAberto
	painelAberto = nil
	scrim.Visible = false
	local t = TweenService:Create(p, RAPIDO, { Size = UDim2.fromOffset(p.Size.X.Offset * 0.92, p.Size.Y.Offset * 0.92) })
	local tamanhoOriginal = p:GetAttribute("BaseSize")
	t.Completed:Once(function()
		p.Visible = false
		if typeof(tamanhoOriginal) == "Vector2" then
			p.Size = UDim2.fromOffset(tamanhoOriginal.X, tamanhoOriginal.Y)
		end
	end)
	t:Play()
end

local function abrir(id: string)
	local alvo = paineis:FindFirstChild("Panel_" .. id)
	if not alvo or not alvo:IsA("Frame") then return end
	if painelAberto == alvo then
		fechar()
		return
	end
	if painelAberto then
		painelAberto.Visible = false
		local anterior = painelAberto:GetAttribute("BaseSize")
		if typeof(anterior) == "Vector2" then
			painelAberto.Size = UDim2.fromOffset(anterior.X, anterior.Y)
		end
	end
	painelAberto = alvo
	scrim.Visible = true
	local base = alvo:GetAttribute("BaseSize")
	if typeof(base) ~= "Vector2" then
		base = Vector2.new(alvo.Size.X.Offset, alvo.Size.Y.Offset)
		alvo:SetAttribute("BaseSize", base)
	end
	alvo.Size = UDim2.fromOffset(base.X * 0.9, base.Y * 0.9)
	alvo.Visible = true
	TweenService:Create(alvo, ABRIR, { Size = UDim2.fromOffset(base.X, base.Y) }):Play()
end

-- guarda o tamanho base de cada painel antes de qualquer animacao
for _, p in ipairs(paineis:GetChildren()) do
	if p:IsA("Frame") then
		p:SetAttribute("BaseSize", Vector2.new(p.Size.X.Offset, p.Size.Y.Offset))
	end
end

-- ---------- hover e toque ----------
local function darVida(botao: TextButton)
	local slot = botao.Parent
	if not slot or not slot:IsA("GuiObject") then return end
	local base = botao.Position
	local function subir()
		TweenService:Create(botao, RAPIDO, { Position = base + UDim2.fromOffset(0, -2) }):Play()
	end
	local function voltar()
		TweenService:Create(botao, RAPIDO, { Position = base }):Play()
	end
	botao.MouseEnter:Connect(subir)
	botao.MouseLeave:Connect(voltar)
	botao.MouseButton1Down:Connect(function()
		TweenService:Create(botao, RAPIDO, { Position = base + UDim2.fromOffset(0, 4) }):Play()
	end)
	botao.MouseButton1Up:Connect(voltar)
end

for _, slot in ipairs(barraLateral:GetChildren()) do
	local botao = slot:FindFirstChild("Button")
	if botao and botao:IsA("TextButton") then
		darVida(botao)
		botao.Activated:Connect(function()
			local id = botao:GetAttribute("PanelId")
			if typeof(id) == "string" then
				abrir(id)
			end
		end)
	end
end

for _, p in ipairs(paineis:GetChildren()) do
	for _, d in ipairs(p:GetDescendants()) do
		if d:IsA("TextButton") then
			darVida(d)
			if d.Name == "Close" or d.Name == "GotIt" then
				d.Activated:Connect(fechar)
			end
		end
	end
end
scrim.Activated:Connect(fechar)

-- ---------- Escape fecha o painel antes de abrir o menu do Roblox ----------
ContextActionService:BindActionAtPriority("CrumbleClosePanel", function(_, estado)
	if estado == Enum.UserInputState.Begin and painelAberto then
		fechar()
		return Enum.ContextActionResult.Sink
	end
	return Enum.ContextActionResult.Pass
end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Escape)

-- ---------- audio ----------
local function acharSom(nome: string): Sound?
	local d = SoundService:FindFirstChild(nome, true)
	return (d and d:IsA("Sound")) and d or nil
end

local function ligarChave(linha: Frame, aoMudar: (boolean) -> ())
	local trilho = linha:FindFirstChild("Toggle") :: TextButton?
	if not trilho then return end
	local knob = trilho:FindFirstChild("Knob") :: Frame?
	trilho.Activated:Connect(function()
		local ligado = not (trilho:GetAttribute("On") == true)
		trilho:SetAttribute("On", ligado)
		TweenService:Create(trilho, RAPIDO, {
			BackgroundColor3 = ligado and Color3.fromRGB(88, 198, 98) or Color3.fromRGB(34, 38, 58),
		}):Play()
		if knob then
			TweenService:Create(knob, RAPIDO, { Position = UDim2.fromScale(ligado and 0.72 or 0.28, 0.5) }):Play()
		end
		aoMudar(ligado)
	end)
end

local settings = paineis:FindFirstChild("Panel_Settings")
if settings then
	local conteudo = settings:FindFirstChild("Body") and settings.Body:FindFirstChild("Content")
	if conteudo then
		local musica = conteudo:FindFirstChild("MusicRow")
		if musica then
			ligarChave(musica, function(ligado)
				local som = acharSom("LobbyMusic")
				if som then
					som.Playing = ligado
				end
			end)
		end
		local sfx = conteudo:FindFirstChild("SfxRow")
		if sfx then
			ligarChave(sfx, function(ligado)
				local grupo = SoundService:FindFirstChild("SFX")
				if grupo and grupo:IsA("SoundGroup") then
					grupo.Volume = ligado and 1 or 0
				end
			end)
		end
	end
end

-- ---------- preview do HUD ----------
local chip = hud:WaitForChild("StatusChip")
local textoStatus = chip:WaitForChild("StatusText") :: TextLabel
local pip = chip:WaitForChild("Pip") :: Frame
local caixaTempo = hud:WaitForChild("TimerBox")
local textoTempo = caixaTempo:WaitForChild("TimerText") :: TextLabel
local vivos = gui:WaitForChild("AliveChip") :: Frame
local faixaSpec = gui:WaitForChild("SpectatingBanner") :: Frame
local faixaOut = gui:WaitForChild("EliminatedBanner") :: Frame

local ESTADOS: { [string]: { rotulo: string, cor: Color3, tempo: string, vivos: boolean, spec: boolean, out: boolean } } = {
	Intermission = { rotulo = "INTERMISSION", cor = Color3.fromRGB(88, 198, 226), tempo = "0:45", vivos = false, spec = false, out = false },
	MapVote = { rotulo = "MAP VOTE", cor = Color3.fromRGB(250, 196, 60), tempo = "0:20", vivos = false, spec = false, out = false },
	Starting = { rotulo = "ROUND STARTS IN", cor = Color3.fromRGB(88, 198, 98), tempo = "0:05", vivos = true, spec = false, out = false },
	Spectating = { rotulo = "ROUND IN PROGRESS", cor = Color3.fromRGB(152, 98, 222), tempo = "1:12", vivos = true, spec = true, out = false },
	Eliminated = { rotulo = "ROUND IN PROGRESS", cor = Color3.fromRGB(230, 88, 80), tempo = "1:12", vivos = true, spec = false, out = true },
}

local function aplicarEstado(nome: string)
	local e = ESTADOS[nome]
	if not e then return end
	textoStatus.Text = e.rotulo
	pip.BackgroundColor3 = e.cor
	textoTempo.Text = e.tempo
	textoTempo.TextColor3 = e.cor
	vivos.Visible = e.vivos
	faixaSpec.Visible = e.spec
	faixaOut.Visible = e.out
end

if settings then
	for _, d in ipairs(settings:GetDescendants()) do
		if d:IsA("TextButton") then
			local estado = d:GetAttribute("HudState")
			if typeof(estado) == "string" then
				d.Activated:Connect(function()
					aplicarEstado(estado)
				end)
			end
		end
	end
end
aplicarEstado("Intermission")

-- ---------- modal de Coming Soon ----------
local comingSoon = paineis:FindFirstChild("Panel_ComingSoon")
ProximityPromptService.PromptTriggered:Connect(function(prompt)
	if prompt:GetAttribute("Modal") ~= "ComingSoon" then return end
	if comingSoon then
		local area = prompt:GetAttribute("Area")
		local rotulo = comingSoon:FindFirstChild("Body") and comingSoon.Body:FindFirstChild("Area")
		if rotulo and rotulo:IsA("TextLabel") and typeof(area) == "string" then
			rotulo.Text = string.upper(area)
		end
	end
	abrir("ComingSoon")
end)

-- ---------- responsividade ----------
ajustarEscala()
-- o primeiro quadro costuma trazer viewport invalido, entao tenta de novo por alguns
-- ciclos ate o valor estabilizar
task.spawn(function()
	for _ = 1, 20 do
		task.wait(0.1)
		local cam = workspace.CurrentCamera
		if cam and cam.ViewportSize.X >= 50 and cam.ViewportSize.Y >= 50 then
			ajustarEscala()
			break
		end
	end
end)
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(ajustarEscala)
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if workspace.CurrentCamera then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(ajustarEscala)
		ajustarEscala()
	end
end)
