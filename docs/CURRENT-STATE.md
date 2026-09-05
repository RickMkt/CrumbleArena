# Estado atual

Atualizado em 2026-09-05, fim do Checkpoint A da auditoria do lobby, sessao 008.

## Onde o trabalho parou

O Checkpoint A foi executado inteiro, com a ponte MCP funcionando. O lobby tem agora a
primeira medicao real de capacidade para oito jogadores desde a sessao 001, e a primeira
medicao de circulacao feita **andando** em vez de por sonda.

O que falta e quase todo visual, e esta bloqueado pela janela do Studio estar oculta.

## Percentuais da auditoria

| Faixa | Resultado | Antes |
| --- | --- | --- |
| Fundacao estrutural | 82,5 de 100 | nao calculado |
| Experiencia do lobby | 30 de 100 | nao calculado |
| Prontidao para producao | 32,5 de 100 | nao calculado |

Detalhe e evidencia em `LOBBY-COMPLETE-AUDIT.md`.

## O place

`CrumbleArena.rbxl`, salvo as 03:18 de 2026-09-05. Ele deixou de ser um arquivo de
recuperacao automatica, o que era a pendencia mais grave desde a sessao 007.

**As seis correcoes desta sessao ainda nao estao salvas.** Elas pedem `Ctrl + S`.

## Correcoes aplicadas nesta sessao

Todas guardam o estado anterior em atributo na propria peca, entao da para reverter sem
consultar log.

1. `LobbySpawn` de `(0, 1.45, 18)` para `(0, 0.90, -18)`, e de 12 x 1 x 12 para 12 x 0.2 x 12
2. `FountainCollision.CanQuery` para verdadeiro
3. `AssetStaging` para `ServerStorage.DeferredContent`
4. `ShopPrompt.MaxActivationDistance` de 14 para 20
5. 192 placas e meios fios de caminho alongados 0,8
6. o proprio spawn assentado no piso, sem flutuar

## O que ainda esta Reprovado

| Item | Peso | Quem resolve |
| --- | --- | --- |
| Teste em celular real | 25 | Rick, no aparelho |
| SFX de interface | 15 | eu, e e o proximo da fila |

O de capacidade para oito, que valia 20 e nunca tinha sido tentado, saiu desta lista.

## Bloqueios

| Bloqueio | Efeito |
| --- | --- |
| `Ctrl + S` pendente | as seis correcoes se perdem se o Studio fechar |
| Janela do Studio oculta | `screen_capture` da timeout, entao nada visual pode ser avaliado |

O segundo tem contorno: `execute_luau` continua respondendo com a janela oculta, entao todo
trabalho de medicao e correcao por script segue possivel. So o olhar esta bloqueado.

## Proxima etapa

Checkpoint B: audio primeiro, porque e o unico Reprovado que eu resolvo sozinho e vale 15
pontos. Depois GUI por clique, responsividade e Output.

## Rede de seguranca

| Script | Reconstroi |
| --- | --- |
| `tools/rebuild/01-BuildLobbyUI.luau` | GUI inteira, 5 paineis, HUD |
| `tools/rebuild/02-BuildIslandFence.luau` | cerca de 48 postes e barreira de 26 studs |
| `tools/rebuild/03-BuildCosmeticsTent.luau` | tenda de lona e o NPC |
| `tools/rebuild/04-ApplyEnvironment.luau` | iluminacao, ceu, nuvens e musica |
| `tools/audit/A1-CapacityEightPlayers.luau` | mede capacidade para oito |
| `tools/fixes/01-ClosePathSeams.luau` | fecha as frestas dos caminhos, com reversao |

Continua sem script: a geometria do lobby, ver D-P01, e a decoracao espalhada a mao.
