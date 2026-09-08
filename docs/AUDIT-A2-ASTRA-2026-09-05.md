# Auditoria do lobby A2, 2026-09-05

Estado: auditado parcialmente em Play e visualmente em Edit. A2 nao aprovado como concluido. Nenhuma correcao permanente aplicada ao Place nesta auditoria.

## Identidade e preservacao

- Diretorio inicial da tarefa: `C:\Users\ricka\Documents\Codex\2026-09-04\voc-est-trabalhando-localmente-no-projeto`.
- Repositorio inspecionado explicitamente: `C:\Users\ricka\Desktop\CrumbleArena`, branch `feat/lobby-art-pass`. Nao e ClientStep nem PromoteMe.
- Studio conectado: `676b8fff-c020-4287-bd6e-ddde07649468`, `CrumbleArena.rbxl`, PlaceId 0, inicialmente em Edit. Hierarquia `Workspace.CrumbleArena.Lobby` confirmada.
- Arquivo canonico: 453.585 bytes, ultima gravacao observada em 05/09/2026 20:25:27, horario local.
- SHA-256: `0C339D030BFD186A11D3B1D37941788051C900755C1E609AA2CF7BB4899E2AB0`.
- O timestamp prova a existencia do save, mas nao que todas as alteracoes atuais em memoria estejam nele. Nao foi aberto outro Place para comparar.
- Backup nao alterado. `src/*` sem alteracoes no Git. Sem commit, push, publicacao ou salvamento automatico.

## Diagnostico principal

A circulacao basica funciona nas rotas amostradas. O problema dominante continua sendo arquitetura e composicao: pisos planos, areas pouco integradas, textos encobertos e vegetacao com escalas e linguagens concorrentes. Acrescentar textura nao resolve esses pontos.

### 1. A investigacao do tronco atingiu a arvore errada

Confirmado por captura e isolamento temporario, depois revertido:

- O objeto alaranjado em primeiro plano e `Vegetation.Trees.RefugeTree_02`, em aproximadamente `(-94, 7.02, -18)`.
- E uma MeshPart de arvore inteira, MeshId `107298216323952`, TextureID `132589463588498`, Color aproximadamente `163,162,165`.
- Ao ocultar apenas essa MeshPart, a arvore redonda e o tronco laranja desapareceram. A arvore grande com cilindro marrom permaneceu. A transparencia original 0 foi restaurada.
- A substituicao anterior ocorreu em `Vegetation.Scatter.Trees.SummerLowPolyTree`, outra familia de arvore. Ha quatro `TrunkSolid`, tres em Scatter e um em Grove.
- Os troncos de malha anteriores continuam presentes, com Transparency 1. Os cilindros substitutos estao visiveis; os tres maiores medem aproximadamente 12 a 14 studs por eixo e produzem troncos muito grossos.

A explicacao anterior de cor assada nos vertices nao foi demonstrada. O teste confirma erro de identidade do objeto investigado; nao estabelece sozinho o mecanismo de cor de todas as malhas. Correcao recomendada: recuperar a silhueta dos quatro troncos substituidos e tratar a familia RefugeTree separadamente, com uma solucao de textura ou asset que preserve copa e tronco.

### 2. Sobreposicao de pisos na chegada

`PlazaDisc` e um cilindro horizontal de diametro 58, centrado em Z=4, topo Y=1. Alcanca Z=33 no eixo central. `MainSouth` ocupa Z=23..29 e tem o mesmo topo Y=1; `SpawnPad` ocupa Z=29..47, tambem com topo Y=1. Portanto, ha area de piso coincidente entre disco e caminho. Linhas na captura sao compativeis com z-fighting. Nao foi feita uma varredura exaustiva de todas as faces do lobby.

Correcao recomendada: recortar/recompor a juncao face a face, mantendo a largura caminhavel, em vez de adicionar outra placa por cima.

### 3. A arquitetura A2 continua incompleta

- Caminhos, mercado, SocialArea, ala de informacao e Outlook seguem com topo Y=1. O pedestal do monumento tem degraus, mas as alas nao ganharam os niveis e transicoes pedidos.
- A ilha ganhou recortes e massa inferior. A leitura geral ainda e uma plataforma larga, com recortes pequenos e repetitivos na borda.
- O mercado possui cobertura e balcoes, mas o piso frontal e muito grande para sua ocupacao. Lojista e estrutura encobrem os cards.
- SocialArea conserva seis lugares e uma fogueira legivel, mas continua uma placa retangular colocada sobre a grama.
- O avatar do leaderboard cobre parte do titulo e das linhas do ranking. EventBoard continua isolado.
- Outlook possui dois postes quebrados e guarda-corpos, mas pouco conteudo arquitetonico. As ilhas distantes e a arena ainda tem silhuetas simples.
- O monumento e legivel no Spawn; a praca branca domina sua base. Fragmentos sobem em uma sequencia estreita. A linguagem modular tem pouca presenca nas superficies construidas.
- Ha variedade de vegetacao, mas as arvores grandes com cilindros competem com as redondas menores. A variedade ainda nao forma uma composicao coerente.

## Medidas atuais do lobby

| Item | Medida |
| --- | ---: |
| BaseParts | 891 |
| Nao ancoradas | 0 |
| Com colisao | 129 |
| Decoracao sem colisao com CanTouch | 536 |
| Decoracao sem colisao com CanQuery | 580 |
| CastShadow | 818 |
| TopSurface Studs | 14 |
| Assentos | 6 |
| Luzes locais | 2 |
| ParticleEmitters | 46 |
| Emissores ativos | 1, cascata, Rate 12 |
| Remotes no lobby | 0 |
| PackageLinks no lobby | 0 |
| LuaSourceContainers no lobby | 1 |

Os 45 emissores das flores estao desativados. Nao representam 45 efeitos ativos. O script encontrado e `Market.Shopkeeper.Animate`, LocalScript habilitado, acompanhado de `PlayEmote` BindableFunction. O conteudo observado corresponde a controle de animacoes de personagem; sua origem exata nao foi comprovada. Nao foi classificado como malicioso nem removido. Sua presenca diverge da meta de zero scripts no lobby/importados e precisa ser resolvida conscientemente.

891 excede a preferencia de 750 para A2 em 141 pecas, mas esta abaixo de 1.200. Isso nao prova mau desempenho. Nao foram medidos FPS confiaveis, triangulos, memoria de texturas ou aparelho mobile real.

## Play: resultados e limites

Oito rigs R15 clonados do avatar foram executados simultaneamente com WalkSpeed 18, JumpPower 0, JumpHeight 0 e estado Jumping desativado. Os scripts foram retirados dos clones temporarios. Cada segmento teve tolerancia horizontal de 2 studs e timeout de 8 segundos.

As oito rotas passaram: chegada lateral ao Core, SocialArea, mercado, leaderboard, EventBoard, Outlook e duas travessias da praca. Isso valida as linhas percorridas, nao cada metro quadrado da ilha, todos os formatos de avatar ou capacidade social em torno dos balcoes. Nao foi medida distancia minima entre os oito rigs durante o movimento.

Os seis Seats aceitaram um Humanoid via `Seat:Sit`, com Occupant confirmado. Isso testa a funcao de sentar, nao a aproximacao automatica de cada cadeira por todas as direcoes.

A barreira conteve rigs em sete pontos: norte, sul, centro oeste/leste, noroeste/nordeste e sudoeste. No sudeste o rig parou antes de alcancar a barreira; teste inconclusivo, sem causa exata isolada. As extensoes visuais de borda ultrapassam a barreira antiga em pontos como oeste X=-119, enquanto a barreira permanece em X=-115.75. A leitura de terreno aparentemente acessivel e o limite fisico divergem nesses pontos.

O Output apresentou timeout em CorePackages/GraphQL e erros derivados em CoreGui, alem de `Infinite yield possible` em `PlayerGui:WaitForChild("CrumbleUI")`, no UIController linha 18. Nao se atribui o timeout interno ao lobby sem reproducao controlada. A espera por CrumbleUI e uma falha observada nesta inicializacao. LobbyMusic estava carregada, volume 0.16 e IsPlaying false. Nao foi corrigido runtime.

Os oito rigs foram removidos. Play encerrado e Studio devolvido ao Edit. O teste temporario de transparencia foi revertido.

## Documentacao e procedencia

`ActiveBasePartCount` ainda declara 408, enquanto a contagem real e 891. `CheckpointA2Complete=false` e `VisualCheckpoint=A2-InProgress` estao coerentes com trabalho inacabado. CURRENT-STATE ainda descreve uma versao muito anterior, com 1.809 pecas.

O inventario documental termina no Checkpoint A e nao documenta plenamente as familias novas em Scatter/Grove. Isso e uma lacuna de rastreabilidade, nao prova de asset inseguro. Antes de ampliar a decoracao, reconciliar modelos ativos, IDs, origem, licenca e inspecao registrada.

Git anterior a esta auditoria: tres documentos modificados (`ASSET-INVENTORY`, `AUDIT-GERAL-2026-09-05`, `handoffs/CODEX-ART-HANDOFF`) e `tools/rebuild/05-BreakIslandSilhouette.luau` nao rastreado. Alteracoes preservadas. Esta auditoria adiciona somente este relatorio.

## Capturas da sessao

Produzidas pela integracao e exibidas na conversa, sem afirmar que existem PNGs locais: `Audit_Current_Front`, `Audit_Tree_Close`, `Audit_Spawn`, `Audit_Market`, `Audit_Social`, `Audit_Info`, `Audit_Outlook`, `Audit_Rear`, `Audit_Tree_Identity_Isolation`.

## Ordem recomendada para a correcao posterior

1. Reparar a substituicao de troncos e resolver a familia RefugeTree identificada.
2. Eliminar pisos coincidentes na praca e validar novamente a chegada.
3. Recuperar leitura de mercado e ranking, preservando circulacao.
4. Executar a arquitetura A2 pendente: niveis acessiveis, bases integradas, SocialArea, Outlook e silhueta com rupturas maiores.
5. Reorganizar vegetacao por grupos e revisar flags de decoracao, procedencia e documentacao.
6. Repetir os testes afetados e concluir o ponto sudeste da barreira. So depois avaliar aprovacao do A2 e acabamento B.
