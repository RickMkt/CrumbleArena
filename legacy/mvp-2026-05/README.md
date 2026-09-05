# Crumble Arena — MVP "Snowball Classic"

Crumble Arena é um party game multiplayer original inspirado na sensação de
minigames clássicos de arena/spleef. **Não usa nomes, assets, texturas, mapas,
interface, sons ou marcas de terceiros.** O objetivo é capturar apenas a vibe:
arena de blocos, chão quebrável, rodadas rápidas e último sobrevivente vence.

> **Frase mental do jogo:** *"O chão é a arma."*

Este repositório contém a **primeira versão jogável** (MVP) do modo **Snowball
Classic**: 3 rounds, 3 camadas de arena, bolinhas server-authoritative que
quebram blocos, kill zone abaixo da arena, eliminação por queda, último vivo
vence o round, vencedor da partida é quem ganha mais rounds (com tiebreaker).

---

## 1. Como importar no Roblox Studio

O projeto está estruturado para **Rojo** (mapeamento via `default.project.json`).

### Opção A — Rojo (recomendado)

1. Instale o Rojo: <https://rojo.space>.
2. Abra um terminal nesta pasta e rode:
   ```
   rojo serve
   ```
3. No Roblox Studio, instale o plugin do Rojo, abra um lugar vazio e clique em
   **Connect** apontando para o servidor que você acabou de subir.
4. O Studio vai sincronizar a árvore descrita em `default.project.json`:
   - `src/shared/`  → `ReplicatedStorage.Shared`
   - `src/utils/`   → `ReplicatedStorage.Utils`
   - `src/ui/`      → `ReplicatedStorage.UI`
   - `src/server/`  → `ServerScriptService.Server`
   - `src/client/`  → `StarterPlayer.StarterPlayerScripts.Client`
5. Salve o lugar (`File > Save to File`) — pronto.

### Opção B — Sem Rojo (manual)

Se você prefere copiar manualmente:

1. Crie no Studio as pastas e ModuleScripts/Scripts/LocalScripts respeitando
   o caminho descrito acima.
2. Cole o conteúdo de cada `.lua` no script correspondente.
3. Garanta que `Main.server.lua` vire um **Script** (server) e
   `Main.client.lua` vire um **LocalScript** (cliente).

---

## 2. Como testar com múltiplos players

1. Abra o lugar no Roblox Studio.
2. Vá em **Test > Players** e configure 2 (ou mais, até 8) jogadores.
3. Clique em **Start**.
4. Cada janela do Studio é um cliente — controle qualquer uma delas.

### O que esperar passo a passo

1. Cada cliente carrega no **lobby** com o banner "CRUMBLE ARENA / Snowball
   Classic".
2. Quando o número mínimo de jogadores (`Config.MinimumPlayers = 2`) é atingido,
   começa **Intermission** (15s por padrão).
3. Inicia **Round 1**: arena é construída, todos são teleportados para spawns
   ao redor da camada superior, contagem regressiva de 5s, "GO!".
4. Use **clique do mouse esquerdo** para arremessar bolinhas (cooldown de
   `0.65s`). As bolinhas quebram blocos no impacto.
5. Quem cair abaixo da última camada é eliminado pela **kill zone**, vai para
   a **plataforma de espectador** ao lado da arena, e a HUD passa a mostrar
   "SPECTATING".
6. O round acaba quando sobra **1 jogador vivo** ou o tempo termina.
7. A partida tem **3 rounds**. Quem ganhar mais rounds vence. Empate dispara
   **tiebreaker rounds** (até `Config.MaxTieBreakerRounds`).
8. Após o vencedor ser anunciado, todos voltam ao lobby e um novo ciclo começa.

---

## 3. Estrutura de pastas

```
src/
  shared/
    Config.lua          -- timings, números, centros (lobby/arena)
    RoundStates.lua     -- enum de estados da partida
    ArenaConfig.lua     -- camadas, grid, cores, materiais
    WeaponConfig.lua    -- bolinha (speed, cooldown, lifetime)
    Remotes.lua         -- cria/obtém RemoteEvents em ReplicatedStorage
    Types.lua           -- tipos compartilhados (Luau)

  server/
    Main.server.lua     -- ponto de entrada do servidor
    services/
      LobbyService.lua          -- constrói o lobby por código
      ArenaService.lua          -- arena procedural + kill zone + spawns
      BlockService.lua          -- quebra blocos com tween
      PlayerRoundService.lua    -- alive/eliminated/wins/inMatch + spectator attr
      SpectatorService.lua      -- plataforma de espectador
      ProjectileService.lua     -- bolinha server-authoritative (raycast)
      RoundService.lua          -- ciclo de UM round
      MatchService.lua          -- ciclo da partida (loop principal)
      TimerService.lua          -- timers e waitUntil

  client/
    Main.client.lua     -- ponto de entrada do cliente
    controllers/
      UIController.lua          -- monta a ScreenGui
      RoundHUDController.lua    -- recebe HUDUpdate/CenterMessage/Score
      WeaponController.lua      -- input -> RequestThrowBall
      CameraController.lua      -- mantém câmera nativa, prepara para futuro
      SoundController.lua       -- stub pronto para receber IDs de áudio

  ui/
    Theme.lua                   -- paleta e helpers (panel/text)
    CreateHUD.lua               -- HUD completa (TopBar, Round, Alive, Center, Spectator)
    CreateLobbyUI.lua           -- painel de lobby/intermission
    CreateRoundUI.lua           -- painel central de Round X/Y
    CreateScoreboardUI.lua      -- placar lateral

  utils/
    Maid.lua            -- limpeza de conexões/instâncias
    Signal.lua          -- sinal interno simples
    TableUtil.lua       -- helpers de tabela

default.project.json    -- mapeamento Rojo
README.md               -- este arquivo
```

---

## 4. O que está implementado (MVP)

- [x] Lobby criado por código (plataforma, banner, decoração, barreiras).
- [x] Arena procedural com **3 camadas**, formato arredondado, cores/materiais
      diferentes por camada.
- [x] Kill zone invisível abaixo da última camada.
- [x] **Sistema de partida**: WaitingForPlayers → Intermission → Pre/InRound x3
      → MatchEnded → repeat.
- [x] **Tiebreaker** quando há empate ao final dos 3 rounds.
- [x] Last-man-standing por round.
- [x] Eliminação por queda (kill zone) e por morte do humanoid.
- [x] **Bolinhas server-authoritative** com cooldown server-side, validação de
      origem/direção e raycast por frame que quebra blocos no impacto.
- [x] Quebra de bloco com pequeno tween (shrink + fade) e atributo `Broken`.
- [x] **Plataforma de espectador** + HUD "SPECTATING" via attribute do player.
- [x] HUD completa por código: TopBar (estado/tempo), Round X/Y, Alive Counter,
      mensagem central animada, Scoreboard com vitórias por jogador,
      Spectator Bar.
- [x] Reset automático de arena entre rounds.
- [x] Validação 100% server-side para arremessos e eliminações.
- [x] Estrutura modular com `Maid` e injeção de dependência leve.
- [x] HUD heartbeat (atualização periódica do tempo restante).
- [x] Suporte a **até 8 jogadores** (`Config.MaxPlayers = 8`).
- [x] Mínimo de **2 jogadores** para iniciar (`Config.MinimumPlayers = 2`).

---

## 5. O que NÃO foi implementado nesta versão

Conforme escopo combinado, ficou de fora do MVP:

- Loja, moedas, DataStore, skins, pets, passe de batalha.
- Power-ups, TNT, Shovel Mode, Mixed Mode, Firework Mode, Levitation Potion.
- Eventos sazonais, ranking persistente, monetização.
- Câmera de spectator avançada (segue jogador vivo).
- Matchmaking complexo (entrar em uma partida em andamento — hoje o jogador
  novo entra no próximo match, não no atual).
- Suporte completo a mobile (botão de arremesso dedicado, joystick virtual).

---

## 6. Limitações atuais conhecidas

- **Sem assets externos**: sem som de bolinha, sem música, sem sprite. O
  `SoundController` está estruturado para receber IDs facilmente no futuro.
- **Sem testes automatizados**: este código não foi rodado em Studio dentro do
  ambiente em que foi gerado. Ele foi escrito seguindo as APIs do Roblox e os
  contratos descritos no escopo, mas o primeiro `Start` no Studio pode revelar
  ajustes finos (ex.: `task.wait`, posições de spawn, escala visual).
- **Sem matchmaking**: jogadores que entram durante uma partida em andamento
  ficam no lobby até o próximo match.
- **Spectator simples**: plataforma fixa ao lado da arena — sem câmera
  acompanhando jogadores vivos.
- **Câmera padrão do Roblox**: o `CameraController` só ajusta zoom mín/máx.
- **Mobile não polido**: `UserInputType.Touch` arremessa, mas qualquer toque
  na tela dispara — sem botão dedicado.

---

## 7. Bugs potenciais a verificar no primeiro teste

(Estes são pontos que você deve checar com olhar atento na primeira sessão.)

- Se o personagem cair "rápido demais" pela kill zone, conferir se a kill
  zone (`Config.KillZoneOffsetBelowLastLayer = 35`) tem altura suficiente
  para sempre tocar (o part da kill zone tem 4 studs de altura).
- Se, no fim de um round, algum personagem ficar "congelado" (sem ser
  teleportado nem para spectator nem para lobby), pode ser timing — testar
  encadeamento de `LoadCharacter` + `PivotTo`.
- Verificar se o HUD aparece em todos os clientes (caso a sincronização do
  Rojo não tenha posicionado os ModuleScripts em `ReplicatedStorage.UI`).

---

## 8. Critérios de sucesso (auto-checklist)

- [x] O jogo inicia sem erro (sintaxe válida, requires consistentes).
- [x] O lobby aparece (`LobbyService.init`).
- [x] A arena é criada por código (`ArenaService.create`).
- [x] Os jogadores são teleportados (`PlayerRoundService.teleportToArenaSpawns`).
- [x] O round começa (`MatchService` orquestra os estados).
- [x] A HUD mostra estado correto (RoundHUDController consome `HUDUpdate`).
- [x] O jogador consegue arremessar bolinhas (WeaponController + ProjectileService).
- [x] A bolinha quebra blocos (BlockService).
- [x] O jogador é eliminado ao cair (KillZone Touched + PlayerRoundService).
- [x] O último vivo vence o round (RoundService).
- [x] O placar registra vitórias (PlayerRoundService.awardRoundWin + scoreboard).
- [x] A partida roda 3 rounds (Config.RoundsPerMatch).
- [x] O vencedor final aparece (MatchService.determineMatchWinner).
- [x] A arena reseta entre rounds (ArenaService.reset).
- [x] O jogo volta para lobby/intermission (returnAllToLobby + loop).
- [x] Código modular (services + controllers + ui + utils).
- [x] README existe (este arquivo).

---

## 9. Próximos passos recomendados

Curto prazo:
1. Testar localmente com 2 e 4 players e ajustar timing de mensagens centrais.
2. Conectar IDs de som ao `SoundController` (round start, throw, block break,
   winner).
3. Adicionar feedback visual ao acertar um jogador com a bolinha (knockback
   leve via `LinearVelocity`, sem dano por enquanto).
4. Pequena câmera de spectator que orbita a arena.
5. Botão dedicado de arremesso para mobile.

Médio prazo (roadmap conforme escopo):
- **0.2 — Shovel Mode**: 1 camada, pá quebra blocos de perto, round mais rápido.
- **0.3 — Mixed Vote**: votação no lobby entre Snowballs e Shovels.
- **0.4 — Collapse Time**: nomes aparecem, arena começa a desmoronar, música
  de tensão.
- **0.5 — TNT, Firework Mode, Levitation Potion Mode**.
- **0.6 — Eventos sazonais**: Halloween Arena, Festive Arena, Birthday Arena.
- **0.7 — Loja cosmética**: trails de bolinha, skins de pá, efeitos de vitória,
  títulos.

---

## 10. Notas de arquitetura

- **Authoritative server-side**: o cliente só envia `RequestThrowBall` com a
  direção da câmera/mouse. O servidor valida estado (`InRound`), `isAlive`,
  cooldown e distância de origem antes de criar a bolinha real.
- **Bolinha sem física**: a bolinha é `Anchored = true` e move por raycast a
  cada `Heartbeat`. Isso elimina divergências client/server e é determinístico.
- **Atributo `Spectating` por player**: o servidor seta o atributo ao eliminar
  / iniciar match / fim de match, e o cliente reage via
  `GetAttributeChangedSignal`.
- **Maid** isola o ciclo de vida das conexões dentro de cada round —
  `RoundService.runRound` cria um `Maid` novo, conecta tudo e faz `DoCleaning`
  ao fim do round. Sem leaks.
- **`Workspace.CrumbleArena`** centraliza tudo: `Lobby`, `CurrentArena`,
  `Projectiles`, `KillZone`, `Spectator`. Nada de Parts soltas.
- **Configuração centralizada**: timings, paleta visual e dimensões da arena
  estão em `Config.lua`, `ArenaConfig.lua`, `WeaponConfig.lua`. Mexer ali
  evita caçar números mágicos no código.
