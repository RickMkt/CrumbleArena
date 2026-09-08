# Update arquitetonico A2, Astra, 2026-09-06

Estado: implementado no Studio, circulacao amostrada testada em Play, retornado a Edit.
Ultimos ajustes aguardam Ctrl + S manual. A2 nao aprovado automaticamente e B nao iniciado.

## Preservacao e arquivo

Projeto: `C:\Users\ricka\Desktop\CrumbleArena`, branch `feat/lobby-art-pass`.
Place: `CrumbleArena.rbxl`, PlaceId 0, raiz `Workspace.CrumbleArena.Lobby`.
Studio conectado ao encerrar: `191adce8-22f1-43ce-8eab-5bdf8132ffe9`.
Nenhum acesso a outro projeto, commit, push, publicacao ou salvamento automatico.

| Estado em disco | Bytes | Horario local | SHA-256 |
| --- | ---: | --- | --- |
| Antes do update | 453585 | 2026-09-05 20:25:27 | `0C339D030BFD186A11D3B1D37941788051C900755C1E609AA2CF7BB4899E2AB0` |
| Save encontrado ao retomar | 582873 | 2026-09-06 02:05:50 | `F74A584C36341139568B651C135EAD4853401D3F79A04479A8E86E1C899437C5` |
| Ultima conferencia em disco | 582873 | 2026-09-06 02:05:50 | mesmo hash do save encontrado |

O ultimo arquivo em disco ainda nao representa os ajustes finais desta retomada.
Nao foi inventado um tamanho final antes do salvamento humano.

Backups novos, sem sobrescrever anteriores, hashes reconferidos:

- `backups/CrumbleArena-before-astra-update-20260905-232838.rbxl`: hash anterior ao update.
- `backups/resume-20260906-041037/CrumbleArena-saved.rbxl`: hash do save das 02:05:50.
- Rollback integral em memoria: `ServerStorage.AstraUpdateRollback.LobbyBeforeUpdate`.
  Preserva o lobby anterior com 891 BaseParts, inclusive conteudo retirado do mundo ativo.

## Arquitetura implementada

1. Ilha reconstruida com contorno assimetrico de 17 vertices, promontorio norte,
   avancos laterais, recuos maiores e camadas inferiores deslocadas. Sem fileiras de
   pequenos dentes de borda. Terra, pedra e quatro grandes massas inferiores visiveis.
2. Praca octogonal com topo Y=2.4. Disco anterior removido do lobby ativo. A rampa do
   Spawn encontra a praca em Z=26, sem outra placa cobrindo o piso coincidente anterior.
3. Entrada alargada de 18 para 24 studs ao aproximar da praca. Corrige seis falhas de
   trajetorias diagonais encontradas no primeiro teste da nova geometria.
4. Mercado em Y=3.2, com rampa, estrutura de madeira, cobertura de tecido, parede de
   fundo, balcao, prateleira e suprimentos. PIP lateral. Cards livres do corpo do NPC.
   Corrigido tambem o deslocamento mundial do NameTag que o deixava atras da placa.
5. Area social irregular em Y=0.6, fogueira preservada, quatro cadeiras e dois bancos.
   Os bancos receberam assento e apoios corrigidos. Acesso aberto pelo lado da praca.
6. Ala de informacao em Y=1.8: composicao em L, parede baixa compartilhada, cobertura
   parcial e avatar deslocado para o lado do ranking. Textos ainda sao placeholders.
7. Outlook em Y=3.4, madeira ate Y=3.55, acesso por rampas, guarda-corpos, banco funcional
   e apoios. Sem arco, portal, cronometro ou votacao fisica.
8. Monumento recomposto com quatro blocos principais fraturados, quatro fragmentos
   menores, base escalonada e fenda ambar discreta. Sem cascata de particulas.
9. Dois pequenos terracos naturais, vegetacao por agrupamentos, arvores com troncos de
   malha restaurados e sem os quatro cilindros gigantes `TrunkSolid`.
10. Horizonte com tres remanescentes, arena quebrada, estratos, pontas inferiores e
    vegetacao localizada. Nao e outra arena jogavel nem sistema de teleporte.

As modificacoes substituiram grupos anteriores; os originais continuam no rollback.
`RefugeTree_02` foi identificado por isolamento na auditoria anterior, nao por palpite
de cor. A familia foi retirada do mundo ativo. Nao se afirma causa de vertex color.

## Medidas, somente lobby ativo

| Medida | Antes | Agora |
| --- | ---: | ---: |
| BaseParts | 891 | 663 |
| Nao ancoradas | 0 | 0 |
| Com colisao | 129 | 213 |
| Sem colisao com CanTouch | 536 | 1, FallZone intencional |
| Sem colisao com CanQuery | 580 | 1 |
| CastShadow | 818 | 543 |
| TopSurface Studs | 14 | 37 |
| Seats | 6 | 7 |
| Luzes locais | 2 | 2 |
| ParticleEmitters | 46 | 0 |
| LuaSourceContainers | 1 | 0 |
| Remotes / PackageLinks / Bindables | 0 / 0 / 1 | 0 / 0 / 0 |

Reducao de 228 BaseParts, aproximadamente 25.6%. O aumento de colisores vem sobretudo
dos pisos e rampas triangulados; contagem de pecas nao equivale a benchmark mobile.
Zero duplicatas exatas de classe, Size e CFrame no teste final. Isso nao e uma prova
exaustiva de ausencia de intersecao entre todas as faces. A emenda antiga da chegada
foi reconstruida; nao apareceu flicker nas capturas inspecionadas.

Iluminacao lida no Edit: Brightness 2.2, ClockTime 14.2, Ambient 112/119/128,
OutdoorAmbient 148/158/170, Exposure 0.03, Diffuse 0.7 e Specular 0.2.
Estes valores nao constituem aprovacao de acabamento B.

## Testes e limites

Oito rigs clonados do mesmo avatar R15, scripts retirados, WalkSpeed 18, JumpPower e
JumpHeight zero e estado Jumping desativado. Oito percursos simultaneos, tolerancia
horizontal de 1.8 studs, timeout de 8 segundos por trecho:

| Percurso | Resultado | Segundos |
| --- | --- | ---: |
| Spawn para Core | passou | 1.63 |
| Spawn para mercado | passou | 5.37 |
| Spawn para SocialArea | passou | 3.87 |
| Spawn para leaderboard | passou | 4.77 |
| Spawn para EventBoard | passou | 4.65 |
| Spawn para Outlook | passou | 7.70 |
| Travessia sul da praca | passou | 4.30 |
| Travessia norte da praca | passou | 5.40 |

Sete novos rigs caminharam da frente de cada assento ate ele, sem pulo e sem Seat:Sit.
Os sete sentaram automaticamente, com SeatPart correspondente. Banco leste corrigido.
Sao seis lugares sociais mais um no mirante, nao sete jogadores no mesmo banco.

Os 17 segmentos da nova barreira contiveram rigs na verificacao desta reconstrucao,
incluindo sudeste. Geometria da barreira nao mudou depois desse teste. A distancia
externa assinada terminou em aproximadamente -1.21 stud, do lado interno. Nao se trata
de teste de todos os vertices, alturas de salto ou formas de avatar.

As adicoes finais ao mercado e horizonte nao tem colisao e nao alteraram rotas nem
barreira. Rigs e sondas retirados. Studio em Edit ao encerrar. Output vazio na ultima
sessao de Play e na conferencia final.

Nao medidos: FPS em celular real, memoria de texturas, triangulos de todas as malhas,
oito formatos diferentes de avatar, stress de jogadores reais ou todas as direcoes de
aproximacao dos assentos. Nao executar rebuild antigo sobre o Place atual.

## UI e audio, investigacao separada

O Infinite yield de CrumbleUI da auditoria anterior nao reapareceu no Play desta
retomada. StarterGui.CrumbleUI existe, Enabled=true, Archivable=true, ResetOnSpawn=false;
PlayerGui.CrumbleUI estava presente no cliente. O controlador vivo aguarda a copia com
WaitForChild. Causa exata da inicializacao anterior permanece nao estabelecida.

LobbyMusic continuou IsLoaded=true e IsPlaying=false, volume 0.16. O codigo versionado
liga a reproducao no callback do toggle, sem inicializacao equivalente. Nao corrigido
neste passe visual. Nao foram mascarados warnings nem alterados scripts de GUI/runtime.
O timeout antigo de CorePackages nao e atribuido a geometria sem evidencia.

## Assets e procedencia

Nenhuma nova importacao externa neste update. Reutilizacao de instancias existentes:
caixas/barril KayKit, arbustos/tufos/rochas KayKit, fogueira e avatar herdados, duas
familias herdadas de arvores e rochas FracturedSkies. Amostras de blocos no balcao sao
geometria autoral, nao produtos funcionais. Licencas e ressalvas na secao 13 do inventario.

Removidos do mundo ativo: familia RefugeTree alaranjada, TrunkSolid, antiga arquitetura
de pisos/aneis, arco do Outlook, decoracao redundante, emissores de flores e cascata,
Market.Shopkeeper.Animate e seu BindableFunction PlayEmote. Nao classificados como malware.

Buscas reais nesta retomada: stylized low poly rock, 5 resultados publicos; prototype-bits,
1 do inventario; SummerLowPolyTree, 5 publicos; LowPolyPineTree, 5 publicos. Nenhum resultado
publico importado. Os de rocha tinham descricao vazia; os de arvore nao provaram origem
e licenca das malhas herdadas. Nao foram declarados maliciosos nem auditados por dentro.

Ressalva importante: a inspecao tecnica nao fecha licenca. A passagem reutilizou e
ampliou familias de arvores herdadas antes de reconciliar completamente sua procedencia.
Isto e uma pendencia de processo desta passagem. Nao rotular essas familias como CC0 ou
plenamente aprovadas. Proximo passo: comprovar a origem/licenca ou substituir por acervo
verificado, sem publicar enquanto essa verificacao estiver pendente.

## Capturas e comparacao

Capturas reais via screen_capture, exibidas na conversa. A ferramenta nao devolveu
arquivos PNG locais; nao ha links de arquivo inventados. Comparacoes por camera:

- Audit_Current_Front / Astra_A2_Front_Compare: camera 175,150,210, alvo 0,0,0.
- Audit_Rear / Astra_A2_Rear_Compare: camera -145,115,-170, alvo 0,0,0.
- Audit_Social / Astra_A2_Social_Final: camera -28,8,31, alvo -52,4,17.
- Astra_A2_Aerial_Final: enquadramento mais proximo da ilha reconstruida.
- Astra_Final_Spawn: chegada em 0,6,53; Astra_A2_Core_Player: nivel do personagem.
- Astra_A2_Market_Final e Astra_A2_Market_LabelCheck: mercado e revisao de leitura.
- Astra_A2_Information_Final: ranking com avatar lateral.
- Astra_A2_Outlook_Final: deck, banco e skyline.
- Astra_A2_Edge_Final: recuo sudeste e camadas inferiores.

## Avaliacao critica e proximo portao

Ha mudanca estrutural real: niveis conectados, terreno menor, limites alinhados, areas
recompostas e menos ruido. A arquitetura continua legivel sem os pequenos props.
Ainda nao considero demonstrado o patamar de lobby final de destaque pedido pelo usuario:
o monumento e os remanescentes distantes continuam simples, e ha gramado aberto que pode
receber melhor composicao de relevo. Os placeholders de informacao nao sao produto pronto.
O resultado merece uma revisao visual, nao um selo automatico de A2 concluido.

Parar para salvar este estado recuperavel antes de outro passe. Resolver procedencia das
arvores e receber a revisao do usuario. Nao iniciar B por inferencia.
ActiveBasePartCount atualizado para 663; CheckpointA2Complete=false;
VisualCheckpoint=A2-Astra-ReviewPending; ReadyForUserReview=true; salvamento manual pendente.

Git: preservadas as alteracoes anteriores em ASSET-INVENTORY, AUDIT-GERAL e handoff,
alem de tools/rebuild/05-BreakIslandSilhouette.luau. Esta passagem atualiza documentos.
src/* continua sem alteracoes no Git. Nenhum script antigo de rebuild foi validado aqui.
