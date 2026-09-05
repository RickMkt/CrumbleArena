# Estado atual

Atualizado em 2026-09-05, Checkpoint visual do art pass do Codex.

## Onde o trabalho parou

O lobby recebeu o primeiro bloco do art pass no Place canonico, em modo Edit. As
alteracoes estao na memoria do Studio e aguardam `Ctrl + S` manual antes do Play test e
do teste dos scripts de reconstrucao em ambiente descartavel.

O trabalho do Claude continua separado em `C:\Users\ricka\Desktop\CrumbleArena-claude`,
branch `feat/lobby-runtime`. Este checkout esta em `feat/lobby-art-pass`. Nenhum arquivo
de `src/` foi alterado pelo Codex.

## Alteracoes visuais aplicadas

1. `CentralPlaza.CrumbleCore` criado com 7 fissuras assimetricas, 5 lajes deslocadas e um
   bloco de 4 fragmentos suspenso. Todas as 33 pecas sao ancoradas e sem colisao.
2. A fonte foi preservada e integrada ao conceito. Pedra, agua e vegetacao receberam
   cores mais coerentes; o modelo carrega `IntegratedConcept = CrumbleCore`.
3. `PlazaMedallion` virou a fundacao de pedra do simbolo central.
4. Training e Parkour agora dizem `COMING SOON` nas placas fisicas.
5. `Props.Vegetation.Tree_20` saiu da linha de visao dos dois cards de Gamepasses. O CFrame
   anterior esta preservado no atributo `CodexOriginalCFrame`.
6. Os 238 `TopSurface = Studs` sem efeito em pecas `SmoothPlastic` foram removidos. Os
   studs visiveis em pecas `Plastic` foram preservados.
7. Iluminacao, atmosfera, nuvens, bloom e cor foram refinados sem trocar o skybox.

## Creator Store

`search_asset` foi usado de verdade. O `platformer-pack`, Asset ID `140612564742843`, da
conta `KittyPatife`, foi inserido em quarentena e auditado: 8 MeshParts e 0 conteudo
proibido. Ficou apenas como biblioteca em `ImportedAssets` a `Y = -600`, sem colisao. Os
20 resultados publicos de rochas e bandeiras foram recusados por origem fraca.

## Valores finais de iluminacao deste checkpoint

`Brightness 2.2`, `ClockTime 14.2`, latitude `18`, exposicao `-0.02`, ambient
`92,98,112`, outdoor `146,156,172`, sombras `0.32`, diffuse `0.62`, specular `0.18`,
bloom `0.12 / 20 / 1.9`, atmosfera `0.16 / 0.03 / 0.8 / 0.02`, color correction
`saturacao 0.08 / contraste 0.10`, nuvens `0.42 / 0.62`.

## Validacao antes do save

| Verificacao | Resultado |
| --- | --- |
| Studio | `CrumbleArena.rbxl`, modo Edit |
| BaseParts no lobby | 1.809, incluindo 8 da biblioteca em Y = -600 |
| Pecas nao ancoradas | 0 |
| Scripts no lobby | 0 |
| Remotes no lobby | 0 |
| Studs sem efeito em SmoothPlastic | 0 |
| Colisores invisiveis inesperados | 0 |
| CrumbleCore | 37 descendentes, 33 BaseParts, 0 colisao |
| Capturas iniciais | 5 angulos principais |
| Capturas comparativas | centro, iluminacao e areas futuras |

O Output contem apenas um erro de `AssistantCommand` gerado por uma tentativa de ler a
propriedade protegida `Lighting.Technology`. Nao veio de script do jogo e nao alterou o
Place.

## Proximos passos depois do save

1. Testar os quatro scripts de `tools/rebuild` em uma copia descartavel, nunca no Place
   canonico.
2. Fazer Play test de circulacao, borda, cadeiras, fonte e Output.
3. Voltar a Edit e produzir as capturas finais.
4. Finalizar `docs/handoffs/CODEX-ART-HANDOFF.md` e pedir o salvamento final.
