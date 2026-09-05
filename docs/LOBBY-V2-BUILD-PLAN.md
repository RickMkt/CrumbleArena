# Plano de construção do Lobby V2

Data: 2026-09-05  
Status: aguardando aprovação explícita  
Opção planejada: **Recomendada — Crumble Refuge**

## Regras de execução

- Modificar somente `C:\Users\ricka\Desktop\CrumbleArena\CrumbleArena.rbxl` no Roblox Studio.
- Nunca alterar arquivos dentro de `backups`.
- Não publicar, fazer commit, push, merge ou iniciar GUI/sistemas complexos.
- Não automatizar `Ctrl + S`; parar nos checkpoints e pedir salvamento manual.
- Antes de cada marco destrutivo, arquivar o conjunto original em um contêiner claramente nomeado e fora do Workspace ativo, sem apagar até aprovação visual.
- Não usar Creator Store por preenchimento. Todo asset deve ser pesquisado, inspecionado, ter scripts removidos e procedência registrada antes de entrar no lobby ativo.
- Nenhuma estrutura de chão ou parede pode ocupar o mesmo volume de outra. Contato de borda é permitido; coplanaridade e interpenetração não.
- Cada marco termina com inspeção no nível do jogador, captura e critério de aceitação objetivo.

## Checkpoints manuais de salvamento

### Checkpoint A — estrutura e fluxo

Após os marcos 1 a 4: ilha, circulação, spawn, centro e distribuição funcional. Parar e solicitar `Ctrl + S`.

### Checkpoint B — arte e conteúdo

Após os marcos 5 a 8: materiais, identidade, áreas reaproveitadas, decoração e placas. Parar e solicitar `Ctrl + S`.

### Checkpoint C — validação final

Após os marcos 9 a 11: segurança, otimização, iluminação, Play test e correções. Voltar a Edit, capturar e solicitar o salvamento final com `Ctrl + S`.

## Marco 0 — congelar baseline

**Objetivo:** tornar a reconstrução auditável e reversível.

- Confirmar arquivo, branch, Studio/Edit e timestamp.
- Capturar spawn, quatro quadrantes, aéreo e principais defeitos.
- Registrar contagens V1 desta auditoria.
- Criar backup novo somente se o canônico tiver mudado desde `before-v2-audit`.

Risco: quase nulo.  
Reversão: nenhuma alteração de Place.  
Aceite: baseline completo e backup verificado por hash.

## Marco 1 — arquivar o layout V1, sem apagar

**Objetivo:** liberar uma cópia de trabalho mantendo recuperação instantânea.

- Criar `ServerStorage.LobbyV1Archive` ou contêiner equivalente.
- Mover cópias dos oito caminhos, pavilhões, praça e props que serão recompostos.
- Preservar referências por atributos `OriginalPath`, `OriginalCFrame` e motivo.
- Manter no Workspace apenas o necessário para comparar e reconstruir por zonas.

Afeta: `Lobby.Island.Paths`, `Lobby.Areas`, partes de `CentralPlaza`, `Props`.  
Risco: referência de runtime apontar para instância movida.  
Reversão: retornar grupos ao pai e CFrame originais.  
Aceite: busca de scripts confirma que nenhum caminho de runtime foi quebrado; V1 pode ser restaurado sem rebuild externo.

## Marco 2 — silhueta e limite

**Objetivo:** fazer a área caminhável coincidir com a ilha e sua segurança.

- Recompor a ilha para aproximadamente 230 x 190 studs.
- Eliminar cantos planos de grama além do limite circular atual.
- Criar borda recortada com cliffs não caminháveis e três a cinco rupturas fortes.
- Reposicionar a barreira invisível para acompanhar a nova borda.
- Preservar `FallZone` e confirmar respawn.

Afeta: `Island.Base`, `Borders`, `Cliffs`, `Safety`.  
Risco: lacuna de colisão ou canto acessível fora da barreira.  
Reversão: reativar ilha e barreira arquivadas.  
Aceite: avatar não encontra parede invisível sobre grama plana; 16 sondas ao redor da borda não escapam nem ficam presas.

## Marco 3 — circulação e spawn

**Objetivo:** substituir a roda por uma hierarquia de três eixos.

- Spawn ao sul, 18 x 18 studs, voltado para o Core.
- Eixo principal de 18–20 studs: spawn → Core → MapVote.
- Alas de 16–18 studs para Social/Cosmetics e Stats/Event.
- Garantir faixa central contínua de 12 studs sem props.
- Remover os caminhos completos de Training e Parkour do Workspace ativo.

Afeta: `LobbySpawn`, `Island.Paths`, pontos de chegada das áreas.  
Risco: rota longa ou câmera inicial obstruída.  
Reversão: restaurar spawn e caminhos do arquivo V1.  
Aceite: Core visível no primeiro frame; todos os destinos ativos alcançáveis sem pulo; nenhuma obstrução em varredura física da faixa central.

## Marco 4 — centro e massas arquitetônicas

**Objetivo:** tornar o Core o centro narrativo e reduzir a praça vazia.

- Reconstruir a praça como conjunto assimétrico de slabs em cerca de 58 x 46 studs.
- Manter `CrumbleCore`, elevar sua leitura e espalhar duas ou três fissuras para o piso.
- Baixar/reorientar a fonte e abrir sua face para o spawn.
- Posicionar MapVote ao norte, Social a oeste e Stats a leste.
- Validar escala com oito rigs antes de detalhar.

Afeta: `CentralPlaza`, bases de `Areas.MapVote`, `SocialArea`, `Leaderboard`.  
Risco: perder área de circulação ao compactar.  
Reversão: restaurar praça e CFrames originais.  
Aceite: oito rigs cabem com separação mínima de 4 studs; Core não é ocultado por fonte, avatar ou HUD.

**Parada obrigatória:** solicitar Checkpoint A com `Ctrl + S`.

## Marco 5 — consolidar funções

**Objetivo:** manter conteúdo útil sem oito pavilhões concorrentes.

- Recriar Cosmetics como mercado compacto e liberar a rota até o balcão.
- Manter PIP/Shopkeeper; inspecionar acessórios, scripts e colisões do NPC.
- Incorporar Gamepasses ao mercado; arquivar o pavilhão separado.
- Reduzir Leaderboard para footprint alvo de 28 x 16.
- Reduzir/mover EventBoard para lateral da chegada.
- Remover `FutureFeatures` do Workspace ativo.
- Substituir Training/Parkour por um único portão ambiental de expansão.

Afeta: `Areas.Cosmetics`, `Gamepasses`, `Leaderboard`, `EventBoard`, `FutureFeatures`, `TrainingPoint`, `ParkourPoint`.  
Risco: incompatibilidade futura com scripts ou legibilidade insuficiente.  
Reversão: reativar o pavilhão/área individual arquivada.  
Aceite: busca de referências limpa; nenhuma função indisponível domina o horizonte; Cosmetics acessível por centro e lateral.

## Marco 6 — experiência social

**Objetivo:** criar atividade de espera próxima e funcional.

- Mover campfire para a ala oeste, a até 4 s do Core.
- Preservar quatro cadeiras funcionais.
- Adicionar dois a quatro assentos simples e espaços para jogadores em pé.
- Manter corredor atrás dos assentos e linha de visão para timer/MapVote.
- Usar a Creator Store somente se a geometria nativa não atender; auditar qualquer cadeira importada.

Afeta: `SocialArea`, `Props.Furniture`.  
Risco: assentos capturarem o jogador durante passagem.  
Reversão: CFrames e modelos anteriores preservados.  
Aceite: seis a oito jogadores ocupam a área; rota principal permanece livre; cada Seat testado em Play.

## Marco 7 — materiais, studs e identidade

**Objetivo:** unificar a cena sem aparência de textura aplicada em massa.

- Reduzir studs para 18–25% das BaseParts ativas.
- Manter studs em grama selecionada, duas faixas-guia e slabs hero.
- Usar Slate/Concrete nas placas quebradas, WoodPlanks na arquitetura reparada e Smooth em faces verticais/props.
- Propagar fissuras do Core por piso, borda e suportes de placa.
- Aplicar paleta verde dessaturado, pedra azul-cinza, madeira neutra, ciano do Core e âmbar social.

Afeta: `Island`, `CentralPlaza`, superfícies principais de `Areas` e `Props`.  
Risco: perder a referência Roblox clássica ou criar ruído de materiais.  
Reversão: propriedades anteriores armazenadas por conjunto.  
Aceite: leitura coerente em visão aérea e humana; studs contam como acento; nenhuma superfície sobreposta ou flicker.

## Marco 8 — decoração, placas e skyline

**Objetivo:** humanizar por composição, não por densidade.

- Agrupar vegetação e rochas; preservar cones de visão.
- Reduzir repetições de cells, lamp edges, postes e fragmentos.
- Criar três a cinco fragmentos distantes de pedra/crumble, não cubos de grama.
- Baixar placas abaixo das copas e enquadrar textos com margens consistentes.
- Usar um ícone, um título e um estado por placa; não empilhar promessas.
- Auditar Creator Store com `search_asset`; rejeitar modelos com origem duvidosa ou scripts.

Afeta: `Props`, sinais físicos, horizonte.  
Risco: cenário voltar a parecer catálogo.  
Reversão: grupos de decoração isolados por pasta e origem.  
Aceite: nenhuma árvore/rocha cruza rotas ou títulos; cada quadrante tem um foco e uma área de respiro.

**Parada obrigatória:** solicitar Checkpoint B com `Ctrl + S`.

## Marco 9 — iluminação e leitura em qualidade variável

**Objetivo:** obter volume e foco sem depender de efeitos caros.

- Ajustar direção do sol para sombra lateral.
- Manter atmosfera e bloom discretos.
- Iluminação local somente no Core, campfire e wayfinding necessário.
- Reduzir saturação do verde e separar planos por valor.
- Testar manualmente qualidade baixa, automática e alta; a integração não pode alterar `SavedQualityLevel`.

Afeta: `Lighting`, `Terrain.Clouds`, luzes locais e cores de massas.  
Risco: cena escura em mobile/qualidade baixa.  
Reversão: snapshot integral das propriedades atuais.  
Aceite: rotas, bordas e Core legíveis nos três níveis sem bloom excessivo.

## Marco 10 — segurança e otimização

**Objetivo:** remover custo invisível sem quebrar interação.

- Desativar `CanTouch`/`CanQuery` em decoração não interativa.
- Desativar `CastShadow` em peças pequenas/invisíveis.
- Simplificar colisões; evitar PreciseConvexDecomposition em meshes não colidíveis.
- Recontar BaseParts, flags, partículas, luzes, meshes e texturas.
- Rodar verificação de overlaps com filtro por dono e confirmação física exata.

Afeta: propriedades físicas e de render do lobby inteiro.  
Risco: uma interação depender implicitamente de touch/query.  
Reversão: lista de propriedades anteriores por UniqueId/path.  
Aceite: metas de orçamento atendidas ou exceções justificadas; zero colisor invisível inesperado; zero peça desancorada; zero script não aprovado.

## Marco 11 — validação final em Play

**Objetivo:** provar que V2 é lobby jogável, não apenas composição aérea.

- Testar primeiro frame e primeira pessoa.
- Cronometrar spawn → Core, MapVote, Social, Cosmetics, Leaderboard e EventBoard sem pulo.
- Executar oito rigs estáticos e oito em movimento simultâneo.
- Sentar em todos os Seats.
- Testar 16 pontos da borda, queda, FallZone e respawn.
- Verificar Output, música, SFX e prompts sem alterar GUI/sistemas além do escopo aprovado.
- Capturar aérea, spawn, quatro quadrantes, áreas e comparações V1/V2.
- Destruir sondas, voltar a Edit e confirmar ausência de objetos temporários.

Risco: achar defeito tardio.  
Reversão: corrigir somente o marco responsável ou restaurá-lo do arquivo V1.  
Aceite: nenhuma rota bloqueada; nenhum escape/stuck; Output sem erro do jogo; música coerente com toggle; texto legível; Studio em Edit.

**Parada obrigatória:** solicitar Checkpoint C e salvamento final com `Ctrl + S`.

## Matriz mínima de evidências

| Marco | Capturas obrigatórias | Medições obrigatórias |
| --- | --- | --- |
| 0 | spawn, aérea, 4 quadrantes | baseline V1 e hashes |
| 2 | bordas N/S/L/O | sondas de barreira/queda |
| 3 | primeira pessoa + eixos | larguras, tempos e bloqueios |
| 4 | Core de 3 ângulos + 8 rigs | capacidade e distância |
| 5 | cada função | footprints e referências |
| 6 | 8 jogadores na área | Seats, circulação e tempo |
| 7 | close de materiais | studs, materiais, overlaps |
| 8 | 4 quadrantes | contagem de props e linhas de visão |
| 9 | low/auto/high manual | propriedades de Lighting |
| 10 | nenhuma promocional | inventário técnico final |
| 11 | série final V2 | rotas, segurança, Output e modo Edit |

## Critério de “pronto para aprovação”

O V2 só deve ser apresentado como concluído se:

- o CrumbleCore for o foco inequívoco do spawn;
- MapVote for o destino primário e estiver acessível;
- Cosmetics não bloquear o caminho;
- a borda física coincidir com a leitura visual;
- oito jogadores passarem nos testes estático e dinâmico;
- não houver estruturas coplanares/interpenetradas com flicker;
- conteúdo adiado não ocupar pavilhões completos;
- custos invisíveis forem reduzidos e medidos;
- capturas no nível do jogador sustentarem a qualidade, não apenas a aérea;
- o Studio terminar em Edit, sem sondas, e o usuário confirmar o salvamento manual.

