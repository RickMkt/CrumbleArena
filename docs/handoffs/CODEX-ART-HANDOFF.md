# Handoff de arte do Codex

Estado: art pass V1 salvo; auditoria brutal do V1 concluida em 2026-09-05. Proposta V2
documentada e ainda nao construida.

## Escopo respeitado

O Codex trabalhou somente no Place, nos valores visuais e na documentacao de arte. Nao
alterou `src/client`, `src/server`, `src/shared`, logica de musica, SFX, GUI de runtime,
controllers, services ou testes automatizados. Esses itens pertencem ao Claude no
worktree `C:\Users\ricka\Desktop\CrumbleArena-claude`.

## Instancias adicionadas

- `Workspace.CrumbleArena.Lobby.CentralPlaza.CrumbleCore`
  - `CoreAnchor`, PrimaryPart transparente e sem colisao
  - `Cracks`, com 7 fissuras e realces internos
  - `BrokenSlabs`, com 5 lajes decorativas
  - `FloatingCoreBlock`, com 4 fragmentos, `InnerRift` e `CoreGlow`
- `Workspace.CrumbleArena.Lobby.ImportedAssets.platformer-pack`
  - Asset ID `140612564742843`
  - Criador `KittyPatife`
  - Pacote `KayKit Platformer Pack`
  - Licenca CC0 verificada no inventario do projeto
  - 8 MeshParts, todos estacionados em `Y = -600`

Nenhuma instancia usada pelo codigo foi removida ou renomeada.

## Instancias modificadas

- `CentralPlaza.CentralFountain`: cores de pedra, agua e arbustos ajustadas. Atributos
  `IntegratedConcept = CrumbleCore` e `RuntimeRole = DecorativeFountain`.
- `CentralPlaza.Floor.PlazaMedallion`: material Slate, cor `92,98,114`, atributo
  `VisualRole = CrumbleCoreFoundation`.
- `Areas.TrainingPoint.Sign.SignBoard.Display.Status`: `COMING SOON`, atributo
  `ContentState = Planned`.
- `Areas.ParkourPoint.Sign.SignBoard.Display.Status`: `COMING SOON`, atributo
  `ContentState = Planned`.
- `Props.Vegetation.Tree_20`: movida para `(104.5, Y original, -40.5)` para liberar a
  leitura de Gamepasses; CFrame anterior em `CodexOriginalCFrame`.
- 238 Parts em `Areas` e `Props`: `TopSurface` corrigido de `Studs` para `Smooth` quando o
  material era `SmoothPlastic` e o relevo nao renderizava.

## Tags e Attributes relevantes

Nao foram criadas tags. Attributes novos:

- `CrumbleCore.Concept = TheGroundIsTheWeapon`
- `CrumbleCore.RuntimeRole = Decorative`
- `CrumbleCore.ArtPass = Codex-2026-09-05`
- `CrumbleCore.SafeForRuntimeAnchor = false`
- atributos de procedencia no `platformer-pack`
- atributos `CodexOriginal*` preservam os valores anteriores nos objetos alterados

O Claude nao deve usar o `CoreAnchor` como dependencia de runtime sem uma decisao nova. O
modelo inteiro e decorativo.

## Creator Store

Buscas executadas com `search_asset` dentro do Studio:

| Busca | Resultados | Uso |
| --- | --- | --- |
| `platformer-pack`, inventario | 1 | inserido, auditado, biblioteca |
| `forest-nature-pack`, inventario | 1 | ja existia |
| `stylized low poly rock`, Creator Store | 10 | todos recusados |
| `low poly flags`, Creator Store | 10 | todos recusados |

Os assets publicos nao tinham evidencia suficiente de origem; dois mencionavam
`DependencyInjector`. Nenhum deles foi inserido.

## Iluminacao final aprovada por captura

| Propriedade | Valor |
| --- | --- |
| Brightness / ClockTime / Latitude | `2.2 / 14.2 / 18` |
| Exposure / ShadowSoftness | `-0.02 / 0.32` |
| Ambient / OutdoorAmbient | `92,98,112 / 146,156,172` |
| Diffuse / Specular | `0.62 / 0.18` |
| Bloom | `0.12 / 20 / 1.9` |
| SunRays | `0.018 / 0.85` |
| Atmosphere | `0.16 / 0.03 / 0.8 / 0.02` |
| Atmosphere Color / Decay | `220,232,238 / 132,172,210` |
| ColorCorrection | `0.08 saturacao / 0.10 contraste` |
| Clouds | `0.42 cover / 0.62 density` |
| SunAngularSize | `9` |

`tools/rebuild/04-ApplyEnvironment.luau` e `LOBBY-BUILD-PARAMS.md` foram sincronizados com
esses valores.

## Validacao disponivel neste checkpoint

- 1.809 BaseParts no lobby, incluindo 8 da biblioteca estacionada
- 0 pecas nao ancoradas
- 0 scripts no lobby
- 0 remotes no lobby
- 0 studs sem efeito em SmoothPlastic
- 0 colisores invisiveis inesperados
- `CrumbleCore`: 37 descendentes, 33 BaseParts, 0 colisao
- 5 capturas iniciais e 10 capturas de comparacao/inspecao

Este bloco descrevia o checkpoint anterior. Em 2026-09-05, a auditoria V1 posterior
concluiu Play test, teste da borda e testes descartaveis de capacidade. Os resultados
confirmados estao na secao "Auditoria V1 posterior" abaixo.

## Capturas produzidas

- `Initial_Overview_South`, `Initial_Overview_North`
- `Initial_Overview_East`, `Initial_Overview_West`
- `Initial_Spawn_View`
- `CrumbleCore_Top`, `CrumbleCore_Ground`, `CrumbleCore_ThreeQuarter`
- `Lighting_After_Overview`, `Lighting_After_Spawn`, `Lighting_After_Ground`
- `After_Training`, `After_Parkour`, `After_Gamepasses`

## Integracao pendente com codigo

- Claude: corrigir inicializacao da musica e implementar/decidir SFX conforme a auditoria.
- Claude: nenhuma mudanca de caminho de instancia foi exigida pelo art pass.
- Produto: teste em celular real continua fora do alcance desta sessao.

## Auditoria V1 posterior — 2026-09-05

Documentos criados:

- `docs/LOBBY-V1-BRUTAL-AUDIT.md`
- `docs/LOBBY-V2-PROPOSAL.md`
- `docs/LOBBY-V2-BUILD-PLAN.md`

Estado de seguranca confirmado:

- Place canonico: `C:\Users\ricka\Desktop\CrumbleArena\CrumbleArena.rbxl`
- 333.256 bytes, timestamp observado `2026-09-05 15:50:10`
- backup novo: `backups\CrumbleArena-before-v2-audit-2026-09-05T1605.rbxl`
- SHA-256 de canônico e backup no inicio da auditoria:
  `712E72694E1695B240616134482AADD3595183F48D76D0656C3777558FF2316D`
- Studio encerrado em Edit; `AuditMovingRigs` e `CapacityTest` removidos
- nenhuma mudanca V2 foi aplicada ao Place

Resultados confirmados no Play:

- sete rotas oficiais passaram sem pulo a WalkSpeed 18
- a rota de Cosmetics falhou duas vezes no segmento 8, bloqueada pelo balcao/postes
- oito rigs em movimento simultaneo percorreram 21,9 a 34,1 studs; menor distancia
  entre pares 22,66 studs e zero pares abaixo de 4 studs
- as quatro cadeiras da SocialArea sao acessiveis e funcionais
- a barreira conteve o avatar; o FallZone registrou toque e o respawn funcionou
- `LobbyMusic` continuou em `Playing = false` com o toggle inicial ligado
- nao houve erro de jogo no Output; a unica mensagem posterior foi produzida pela
  propria sonda ao Studio negar a alteracao de `SavedQualityLevel`

Medidas principais do lobby ativo, excluindo a biblioteca em `ImportedAssets`:

- 2.448 descendentes e 1.785 BaseParts
- 0 pecas nao ancoradas, 0 scripts e 0 remotes no lobby
- 51 MeshIds unicos e 12 referencias unicas de textura/superficie
- 805 BaseParts com `TopSurface = Studs` (45,1%)
- 624 pecas nao colidiveis ainda com `CanTouch` e 487 com `CanQuery`
- 1.694 pecas com `CastShadow`

Limitacoes confirmadas:

- nao houve emulador de aparelho; mobile foi analisado por codigo e dimensoes
- o Studio bloqueou a mudanca automatica de qualidade grafica por falta da capacidade
  interna `RobloxScript`; `SavedQualityLevel` permaneceu `Automatic`
- a V2 nao deve ser construida antes de aprovacao explicita do usuario

## Crumble Refuge V2 — checkpoint de greybox, 2026-09-05

Estado: **Marco 5 concluido no Studio e aguardando save manual com Ctrl + S**. O nome
publico continua `Crumble Arena`; `Crumble Refuge` e somente o conceito arquitetonico.
Decoracao final, materiais finais, iluminacao definitiva e mudancas em `src/*` nao foram
iniciados.

### Preservacao antes da construcao

- commit exclusivamente documental:
  `5511a0c23c36fa59d0c316069591b24a4ace5b88`
- backup V1 externo:
  `C:\Users\ricka\Desktop\CrumbleArena-V1-preserved-2026-09-05T1635.rbxl`
- SHA-256 do canônico V1 e do backup externo:
  `712E72694E1695B240616134482AADD3595183F48D76D0656C3777558FF2316D`
- o V1 completo nao foi duplicado dentro de Workspace ou ServerStorage

### Removido do layout ativo

- `Areas.FutureFeatures`: 5 BaseParts
- `Areas.Gamepasses`: 14 BaseParts; os dois cards foram integrados ao mercado
- `Areas.TrainingPoint`: 27 BaseParts
- `Areas.ParkourPoint`: 13 BaseParts
- `Island.Paths.PathTraining`: 15 BaseParts
- `Island.Paths.PathParkour`: 15 BaseParts
- `Island.FloatingFragments`: 60 BaseParts
- `Props.CP3_LandscapeDetails`, `Decor`, `Ice`, `Rocks`, `Vegetation` e `Furniture`:
  311 BaseParts no total
- ilha V1 celular: Base 254, Borders 220 e Cliffs 185 BaseParts
- seis caminhos radiais restantes: 162 BaseParts
- piso/anéis/marcadores da praca V1: 61 BaseParts
- barreira circular V1: 36 BaseParts

Training e Parkour continuam preservados em:

- `ServerStorage.DeferredLobbyAreas.Training`
- `ServerStorage.DeferredLobbyAreas.Parkour`

### Biblioteca organizada

`Workspace.CrumbleArena.Lobby.ImportedAssets` saiu de Workspace e esta em:

- `ServerStorage.CrumbleArenaLibraries.ImportedAssets`

O pacote aprovado esta em:

- `ServerStorage.CrumbleArenaLibraries.platformer-pack`

Asset ID `140612564742843`, criador `KittyPatife`, pacote `KayKit Platformer Pack`,
licenca `CC0 verified in project inventory`, 8 MeshParts e 0 scripts. Os Attributes de
procedencia foram preservados. Nenhuma referencia em `src/*` depende desses caminhos.

### Estrutura V2 criada

- `Lobby.LayoutVersion = CrumbleRefuge-V2-Greybox`
- `Lobby.LastCompletedMarco = 5`
- `Lobby.GreyboxComplete = true`
- `Lobby.GreyboxApproved = false`
- `Lobby.ReadyForUserReview = true`
- manifesto leve: `Workspace.CrumbleArena.Lobby.CrumbleRefugeManifest`

Ilha:

- cinco massas de grama encaixadas face a face, volume aproximado 230 x 190 studs
- cinco massas consolidadas de cliff
- vinte segmentos visiveis de borda
- vinte segmentos de barreira invisivel alinhados com a mesma silhueta
- zero intersecoes fisicas confirmadas entre estruturas novas colidiveis

Praca e fluxo:

- praca 58 x 46 studs, formada por tres slabs encaixadas
- fluxo principal: `Spawn -> CrumbleCore -> MapVote`
- spawn em `(0, 1.1, 38)`, olhando para o Core, a 34 studs do centro do Core
- caminhos estaveis: `PathSpawn`, `PathMapVote`, `PathSocial`, `PathCosmetics`,
  `PathLeaderboard` e `PathEventBoard`
- larguras livres registradas: 16 studs no eixo principal e 14 nas alas
- Cosmetics usa ligacao propria em L e nao atravessa a area de assentos

Areas:

- Core em `(x=0, z=4)`, escala greybox 1.35; `CoreAnchor` continua sem contrato runtime
- bloco flutuante centralizado em `Y=10.8`, abaixo do HUD
- fonte reduzida a escala 0.42, com 7 BaseParts, lateral em `(x=-21.5, z=-3)`
- MapVote compacto ao norte, com `MapVoteInteraction` transparente para contrato futuro
- mercado oeste com PIP preservado e cards `Gamepass_VIP`/`Gamepass_Coins` integrados
- SocialArea oeste com fogueira, quatro cadeiras preservadas e dois bancos novos
- Leaderboard leste compacto com avatar do primeiro lugar preservado e display-only
- EventBoard lateral e secundario
- `Areas.FutureExpansion`: um unico marcador discreto `COMING SOON`

### Validacao do Marco 5

- 250 BaseParts ativas no lobby, todas ancoradas
- 70 BaseParts colidiveis, 121 com CanQuery, 30 com CanTouch e 224 com CastShadow
- 24 tops com Studs, ou 9,6%; greybox ainda nao recebeu o passe final de materiais
- 0 scripts no lobby
- 6 Seats funcionais, todos testados em 0,20 a 0,25 s
- rotas sem pulo, WalkSpeed 18:
  - Core 1,07 s
  - SocialArea 3,13 s
  - MapVote 4,00 s
  - Leaderboard 4,57 s
  - Cosmetics 5,72 s
  - EventBoard 5,80 s
- oito direcoes de borda contidas pela barreira alinhada
- `FallZone` agora e volume 320 x 40 x 320, centro Y -210, inteiramente acima de
  `FallenPartsDestroyHeight = -240`; toque e respawn confirmados
- oito rigs R15 em movimento: aproximadamente 12,9 studs cada, distancia minima 13,46
  studs e zero pares abaixo de 4 studs
- Output final vazio
- Studio encerrado em Edit e sem rigs/sondas temporarias

### Capturas do greybox

- `V2_Greybox_Aerial`
- `V2_Greybox_Play_FirstFrame`
- `V2_Greybox_Spawn_ToCore_Adjusted`
- `V2_Greybox_Core_ToMapVote`
- `V2_Greybox_WestWing`
- `V2_Greybox_EastWing`
- `V2_Greybox_SocialArea`
- `V2_Greybox_Border`
- `V2_Greybox_8Rigs_PlazaMoving`

Nao iniciar o passe visual enquanto `GreyboxApproved` continuar `false`.

## Lobby V2 - Checkpoint visual A, 2026-09-05

O Marco 5 foi salvo e aprovado pelo Rick. Antes da primeira alteracao visual foi criado o
backup:

- `backups/CrumbleArena-greybox-approved-before-checkpoint-A-2026-09-05T192822.rbxl`
- 249.299 bytes
- SHA-256 `0C101A438435F7BD0CAF70178CC5E8560FFB1A7282118E81879122B00F3A3849`

### Correcao obrigatoria: Map Vote

Map Vote e exclusivamente uma GUI de tela. Nenhum objeto fisico e necessario para votar.
A GUI futura deve:

- aparecer somente durante o estado de votacao entre partidas;
- apresentar tres mapas, imagens, votos, contagem regressiva, selecao e resultado;
- funcionar com mouse, toque e gamepad.

Essa logica nao foi implementada neste passe. A pasta fisica anterior foi retirada do
lobby ativo e arquivada recuperavelmente em
`ServerStorage.DeferredLobbyAreas.MapVotePhysical`. Nao existe nome `MapVote` ativo sob o
lobby. O caminho `PathMapVote` foi convertido em `Architecture.Paths.PathOutlook`.
Cronometro, estado da partida, jogadores vivos, Spectating, Eliminated, configuracoes,
loja completa, confirmacao de compra e feedback de interacao tambem permanecem reservados
para GUI/HUD.

### Crumble Outlook

O eixo norte agora termina no `Crumble Outlook`, um mirante ambiental. Ele possui deck,
guarda-corpos laterais e uma moldura quebrada intencionalmente incompleta. Nao e portal e
nao inicia partida. A vista enquadra quatro ilhas fragmentadas e uma arena distante; todos
esses elementos de horizonte sao nao colidiveis e nao acessiveis.

### Arquitetura e silhueta

- a topologia caminhavel do greybox foi preservada;
- tres camadas inferiores de terra/pedra e oito fraturas deram massa visual a ilha;
- seis reparos de borda em madeira/metal reforcam a leitura de refugio reconstruido;
- as 57 pecas colidiveis ativas terminaram com zero intersecoes AABB acima de 0,03 stud;
- os caminhos principais continuam face a face, sem placas sobrepostas ou z-fighting.

### Alas consolidadas

- `Market`: acesso central aberto, PIP deslocado para a lateral, dois balcoes secundarios,
  nova moldura, prateleiras, valance de tecido, caixas e barris;
- `SocialArea`: fogueira preservada, quatro cadeiras e dois bancos funcionais, com
  suprimentos discretos ao redor;
- `Information`: leaderboard compacto e EventBoard secundario, ambos com molduras e
  circulacao livre;
- `ComingSoon`: permanece um unico marcador discreto, sem Training ou Parkour completos.

### Assets e Explorer

Busca real feita com `search_asset` no inventario e Creator Store. Quatro modelos do
inventario foram inseridos com `insert_asset` em quarentena, inspecionados e recusados por
linguagem moderna; tinham 1 MeshPart cada e zero scripts, remotes ou packages. Nenhum
resultado publico sem licenca verificavel foi usado. O passe ativo reutiliza os packs
KayKit CC0 ja aprovados e os modelos sanitizados do usuario. Registro completo em
`docs/ASSET-INVENTORY.md`.

Top-level funcional do lobby apos o Checkpoint A:

- `Architecture`, `Boundaries`, `CentralPlaza`, `ComingSoon`, `Environment`,
  `Information`, `Market`, `Outlook`, `Props`, `Rocks`, `SocialArea`, `Vegetation`;
- `CrumbleRefugeManifest` permanece como registro leve do greybox.

O passe ficou com 408 BaseParts ativas, abaixo da meta de 1.200. Todas estao ancoradas;
ha zero scripts, zero remotes e zero packages no lobby. A quarentena terminou vazia.

### Capturas do Checkpoint A

- `CheckpointA_Before_GreyboxApproved`
- `CheckpointA_Before_West`
- `CheckpointA_Architecture_Inspection`
- `CheckpointA_Aerial_Review`
- `CheckpointA_Spawn_Review`
- `CheckpointA_Outlook_Review`
- `CheckpointA_West_Review`
- `CheckpointA_East_Review`

Checkpoint A construido em memoria no Studio. O passe de materiais, studs, CrumbleCore,
vegetacao fina, skyline final e iluminacao pertence ao Checkpoint B. Nao prosseguir ate o
Rick confirmar `Ctrl + S` deste checkpoint.
