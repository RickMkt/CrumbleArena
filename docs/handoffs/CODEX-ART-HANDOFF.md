# Handoff de arte do Codex

Estado: Checkpoint visual aplicado no Studio, aguardando save manual e Play test final.

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

Play test, Output limpo de jogo, teste da borda e reconstrucoes descartaveis ainda nao
foram concluidos. Nao devem ser apresentados como testados.

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

