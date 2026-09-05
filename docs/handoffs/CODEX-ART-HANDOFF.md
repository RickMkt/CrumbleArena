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
