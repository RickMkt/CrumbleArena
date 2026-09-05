# Log de sessoes

Uma entrada por sessao. Registra o que foi feito, o que foi validado com evidencia e o que
ficou aberto.

---

## Sessao 001, 2026-09-03: fundacao

**Objetivo:** inspecionar o ambiente, separar o projeto novo do Promote Me, criar a fonte
de verdade e preparar a fase 1. Nao construir gameplay.

### Estado encontrado

Diretorio de trabalho da sessao: `C:\Users\ricka\Desktop\PromoteMe`, repositorio de outro
jogo, branch `master`, sem remote, 5 arquivos modificados e 32 nao rastreados, ultimo
commit `81d6587` de 2026-08-31. Nada foi tocado nele.

`C:\Users\ricka\Desktop\CrumbleArena` ja existia, com o MVP Snowball Classic: 32 arquivos
`.lua`, sem Git, ultima alteracao em 2026-05-08.

Studio: uma instancia conectada via MCP, `Place1`, modo Edit, `PlaceId` 0, `GameId` 0,
Workspace com Camera, Baseplate, Terrain e SpawnLocation, zero `LuaSourceContainer`,
`ReplicatedStorage`, `ServerScriptService`, `ServerStorage`, `StarterGui` e `SoundService`
vazios. Place novo, nunca salvo.

Toolchain presente: Rojo 7.7.0, StyLua 2.5.2, Selene 0.31.0, Lune 0.10.5, todos em
`~/.cargo/bin`. Rokit, Aftman, Wally e Blender ausentes.

### O que foi feito

1. Snapshot de seguranca do MVP anterior, com inventario SHA-256 dos 32 arquivos antes de
   qualquer alteracao.
2. MVP movido para `legacy/mvp-2026-05/` e reconferido: 32 de 32 hashes identicos.
3. `git init` no Crumble Arena. Nenhum commit, nenhum remote.
4. Estrutura de pastas, toolchain e documentacao criadas.
5. Auditoria do acervo SkillLab procurando script e executavel escondido. Nenhuma
   ocorrencia em 541 MB.
6. Inventario preliminar de assets relevantes.

### Validacoes executadas

| Comando | Resultado |
| --- | --- |
| `rojo build -o build.rbxl` | sucesso, place de 2.6 KB gerado |
| `stylua --check src tests` | sem divergencia |
| `selene src` | 0 erros, 0 avisos |
| `selene --config tests/selene.toml tests` | 0 erros, 0 avisos |
| `lune run tests/GameConfig.spec.luau` | 9 verificacoes, todas passaram |

O build foi conferido: `ReplicatedStorage.Shared`, `ServerScriptService.Server` e
`StarterPlayer.StarterPlayerScripts.Client` estao presentes no place gerado.

### O que nao foi feito, de proposito

- nada foi criado, alterado ou removido no Roblox Studio, ver decisao D-003
- nenhum commit, ver decisao D-002
- nenhum asset foi importado nem copiado para o repositorio
- nenhum service, controller ou sistema de gameplay foi escrito

### Riscos concretos

**R-001, o Gelo nao tem asset.** Block Bits cobre Terra, Grama e Pedra de forma direta, mas
nao tem bloco de gelo. `glass` e `snow` sao aproximacoes fracas. Impacto: um dos quatro
materiais do lancamento precisara ser autoral, ou o material muda. Decidir ate a fase 2.

**R-002, o toolchain nao e reproduzivel por Rokit nesta maquina.** O `rokit.toml` existe e
fixa as versoes, mas o Rokit nao esta instalado e as ferramentas vieram de `cargo install`.
Em outra maquina, `rokit install` pode trazer binario diferente do validado aqui. Impacto:
baixo agora, cresce quando houver segunda maquina ou CI.

**R-003, contagem de partes da arena ainda e desconhecida.** O jogo inteiro depende de
manter uma arena de blocos rodando em celular, e nenhum numero foi medido. Impacto: alto.
Mitigacao: a medicao e criterio de aceite da fase 4, e o orcamento de partes ja e criterio
de aceite da fase 1.

**R-004, `legacy/` pode virar confusao.** Ele tem arquivos `.lua` com nomes parecidos com
os do projeto novo, o que pode gerar edicao no lugar errado. Mitigacao: `legacy/` nao esta
no `default.project.json`, nao e formatado e nao e linted. Se virar problema real, vira zip.

**R-005, `PlaceId` 0.** O Crumble Arena ainda nao tem place proprio. Enquanto isso for
verdade, qualquer trabalho no Studio corre risco de ser perdido ou salvo no lugar errado.
Resolver como primeira tarefa da fase 1, ver D-P02.

### Proxima tarefa

Fase 1, primeiro passo: criar e salvar o place do Crumble Arena, conectar o Rojo e
confirmar que a arvore sincroniza. So depois disso comeca a geometria.

---

## Sessao 002, 2026-09-03: greybox e composicao do lobby

**Objetivo:** construir a primeira estrutura fisica e navegavel do lobby dentro do Studio,
sem sistemas.

### Estado encontrado

Mesma instancia do Studio da sessao 001: `Place1`, `PlaceId` 0, `GameId` 0, modo Edit,
`RunService:IsRunning()` falso. Workspace com Camera, Baseplate, Terrain e SpawnLocation.
Zero `LuaSourceContainer` no Place inteiro. Nao e o SkillLab nem o Promote Me.

Lighting original registrado antes de qualquer alteracao: `Ambient` e `OutdoorAmbient`
`0.275`, `Brightness 3`, `ClockTime 14.5`, `Bloom 1 / 24 / 2`, `Atmosphere Density 0.3`,
`SunRays 0.01`.

### O que foi construido

Ilha flutuante de 264 studs, praca central de 84, 8 caminhos curvos, 9 areas, 1291 pecas.
Numeros exatos em `LOBBY-BUILD-PARAMS.md`.

### Assets

Tres pacotes KayKit do inventario do usuario, inseridos em quarentena e auditados: zero
scripts, zero remotes, zero GUIs. 8 malhas em uso. Oito modelos do Creator Store publico
foram avaliados e recusados por origem. Detalhes em `ASSET-INVENTORY.md`.

### Defeitos encontrados no teste e corrigidos

Estes nao apareceram na inspecao visual. Todos vieram de teste automatizado.

1. **Buracos na borda.** 10 pontos sem chao entre raio 108 e a barreira em 124. Causa: o
   criterio de recorte usava o centro da celula. Corrigido em D-011. Reconferido: 0
   buracos em 1903 amostras.
2. **Banco invisivel na entrada da area social.** Um `Seat` a 88 de Z sentava quem passasse
   pelo caminho. Movido, e os outros tres afastados. Distancia minima atual de um `Seat`
   ate uma placa de caminho: 21.6 studs.
3. **Poste de placa na linha de chegada do Treino.** Placa refeita mais estreita em
   `(-64, 62)`, com postes a 30.6 e 12.7 studs do eixo do caminho.
4. **Bloco decorativo de 4.8 studs em cima do corredor do Treino.** Reposicionado, junto de
   mais 11 pecas que violavam a folga de 15 studs.
5. **Degrau de 2.5 studs nas lajes.** Acima do que o personagem sobe sem pular. Resolvido
   com anel de degraus de no maximo 1.5 stud em toda laje elevada.
6. **Parkour cruzando o proprio caminho de acesso.** Percurso refeito como volta fechada
   fora dos corredores, a 18 studs de folga.
7. **Mural desmontado por uma rotina automatica** que tratou cada peca como item solto.
   Reconstruido inteiro em `(-78, -8)`.

### Validacoes executadas

| Teste | Resultado |
| --- | --- |
| Pecas nao ancoradas | 0 |
| Nomes genericos | 0 |
| Scripts no Place inteiro | 0 |
| Remotes, Tools, ClickDetectors, ProximityPrompts | 0 |
| Buracos de chao ate o raio 123 | 0 em 1903 amostras |
| Obstrucao acima do spawn | 0 em 25 raios |
| Orientacao do spawn | alinhamento 0.998 com o painel de evento |
| Rotas de pathfinding | 10 de 12 alvos |
| Caminhada fisica ate cada area | 9 de 9 |
| Degraus acima de 2 studs nos 8 corredores | 0 |
| Volta completa de parkour | 13 de 13 saltos, retorna ao inicio |
| Tentativa de sair da ilha, com pulo, em 8 direcoes | 0 fugas |
| Quadros por segundo em Play | 60, com 16.7 ms de heartbeat |

Duas rotas de pathfinding falham na area social, mas a caminhada fisica ate o deck e ate a
fogueira funciona. E limitacao da navmesh sobre o anel de degraus, nao bloqueio real.

### Riscos

**R-006, o place continua sem arquivo.** `PlaceId` 0 e nenhum `Save As` foi feito, porque
o sandbox do Studio nao expoe salvar por script. Se o Studio fechar sem salvar, as 1291
pecas se perdem. Mitigacao parcial: `LOBBY-BUILD-PARAMS.md`. Acao: `File > Save As`.

**R-007, sem teste em dispositivo movel real.** O que foi verificado foi geometria, largura
de caminho, degraus, altura livre e desempenho em Studio. Toque, area do polegar e leitura
em tela pequena continuam sem teste.

**R-001 confirmado.** Nenhum pacote tem bloco de gelo. Os blocos de gelo do treino e os
cristais do cenario sao `Part` autorais em ciano com transparencia 0.15.

### Proxima tarefa

`File > Save As` do place, com nome e caminho definidos, e registro do caminho em
`DECISIONS.md`, fechando D-P02.

## Sessao 003, 2026-09-04, incidente de persistencia

Sessao aberta para o Checkpoint 1 de polimento. O Checkpoint nao comecou. A auditoria
inicial encontrou um problema anterior mais grave e a sessao virou recuperacao.

### O que foi apurado

Roblox Studio nao estava em execucao. Por isso a integracao MCP listou zero instancias e
as chamadas de `screen_capture` da tentativa anterior ficaram penduradas ate o timeout.
Nao era falha da ferramenta, era ausencia de Studio.

O arquivo `CrumbleArena.rbxl` existe, mas em `C:\Users\ricka\Documents\`, nao dentro do
projeto. Por isso a busca anterior, feita so na pasta do projeto, concluiu que nao existia.

O `Save As` aconteceu em 2026-09-03 as 21:06, dois minutos depois de o Studio abrir, ou
seja **antes** de o lobby ser construido. Prova no log do Studio:
`2026-09-04T00:06:23Z Salvo em 'C:/Users/ricka/Documents/CrumbleArena.rbxl'`. Foi o unico
save manual do dia. Depois disso o lobby foi construido e nunca foi salvo a mao.

Contagem de instancias lida do cabecalho binario dos arquivos:

| Arquivo | Tamanho | Instancias | Conteudo |
| --- | --- | --- | --- |
| `Documents\CrumbleArena.rbxl` | 59.7 KB | 79 | baseplate vazio |
| `Place1.rbxl` (template em branco) | 58.4 KB | 87 | baseplate vazio |
| `CrumbleArena_AutoRecovery_0.rbxl` | 159.6 KB | 1631 | **o lobby** |

Varredura de nomes nos bytes confirma: o arquivo salvo tem `Baseplate` e zero nomes do
lobby. O de recuperacao automatica tem `CrumbleArena`, `Lobby`, `CentralPlaza`,
`EventBoard`, `Parkour`, `MapVote`, `Training`, `Cosmetics`, `Gamepasses`,
`FloatingFragments`, `MeshPart` e `SurfaceGui`.

### Acao tomada

Nada foi apagado, movido ou sobrescrito. Foram feitas apenas copias:

```text
CrumbleArena/backups/
  CrumbleArena-AUTORECOVERY-2026-09-04T0131.rbxl   159.6 KB   SHA-256 56D11E5B...
  CrumbleArena-SAVEDFILE-2026-09-03T2106.rbxl       59.7 KB   SHA-256 A160F166...
```

Ambas verificadas por SHA-256 contra a origem, identicas. A copia foi feita porque o
Roblox sobrescreve e descarta arquivos de recuperacao automatica na proxima abertura do
Studio, e o lobby so existia la.

### R-006 se concretizou

O risco previsto na sessao 002 aconteceu. A mitigacao registrada estava incompleta: o
alerta dizia `File > Save As`, e o `Save As` foi feito, mas antes da construcao. O que
faltava era `Ctrl + S` depois de construir. Correcao de processo: **salvar a mao ao fim de
cada bloco de construcao**, nunca confiar na recuperacao automatica.

### Estado ao fim da sessao

Nenhuma alteracao no lobby. Nenhum asset inserido. Nenhum commit, push ou publicacao.
Studio permanece fechado. Checkpoint 1 nao iniciado, bloqueado por dependencia de acao
humana para reabrir o place correto.

### Recuperacao concluida

Autorizado pelo usuario a agir sozinho. O Studio foi aberto pela linha de comando com o
arquivo de recuperacao, conferido, fechado de forma limpa e reaberto no caminho canonico.

Auditoria do arquivo recuperado, feita fora do Studio com Lune 0.10.5 lendo o binario:

| Metrica | Sessao 002 relatou | Arquivo recuperado | Confere |
| --- | --- | --- | --- |
| Instancias no place | 1631 esperado | 1631 | sim |
| Descendentes do Lobby | 1551 | 1553 | diferenca de 2 |
| BaseParts | 1291 | 1292 | diferenca de 1 |
| MeshParts | 131 | 136 | diferenca de 5 |
| SurfaceGui | 19 | 19 | sim |
| Scripts | 0 | 0 | sim |
| Remotes | 0 | 0 | sim |
| Pecas nao ancoradas | 0 | 0 | sim |

As nove areas estao todas presentes, com contagem identica a relatada: EventBoard 16,
Cosmetics 37, Gamepasses 15, Leaderboard 11, MapVote 21, Training 58, Parkour 37,
SocialArea 26, FutureFeatures 5. Island 834, CentralPlaza 28, Props 150, Safety 37,
ImportedAssets 16. `SpawnLocation` em (0, 1.5, 0). Iluminacao com `Brightness` 2.9,
`GeographicLatitude` 24, `ExposureCompensation` -0.05, `ShadowSoftness` 0.35 e os seis
efeitos, incluindo o `ColorCorrectionEffect` chamado `LobbyGrade`.

As pequenas diferencas de contagem sao esperadas: a recuperacao automatica das 01:31 e
posterior ao relatorio das 23:50, e as contagens da sessao 002 foram tiradas de subarvores
diferentes. Nada esta faltando.

### Bloqueio remanescente

O Studio esta aberto em `CrumbleArena\CrumbleArena.rbxl`, carregado e respondendo, mas a
integracao MCP nao conecta. Causa identificada: a flag `FFlagEnableStudioMCPAuth` esta
ligada, entao a conexao exige autorizacao dentro da janela do Studio. O hub local esta
saudavel, escutando em `127.0.0.1:13469`. Falta um clique humano, que nenhuma ferramenta
desta sessao alcanca. O Checkpoint 1 comeca assim que a conexao for autorizada.

Observacao lateral: o `rojo serve` nao esta rodando, entao o plugin do Rojo enche o log com
falhas de conexao na porta 34872. Inofensivo, mas explica o ruido.

---

## Sessao 004, 2026-09-04: memoria permanente e Marco 1 do polimento

**Objetivo:** reconstruir o contexto a partir das fontes de verdade, consolidar a memoria
do projeto em arquivos e executar o Marco 1 do polimento do lobby. Nao decorar ainda.

### Estado encontrado

Studio aberto em `CrumbleArena\CrumbleArena.rbxl`, modo Edit, MCP respondendo. A
autorizacao que faltava na sessao 003 ja tinha sido dada. `Workspace.CrumbleArena.Lobby`
presente, 1308 pecas, 145 `MeshPart`, 0 script, 0 remote, 0 peca nao ancorada.
`ServerStorage` e `StarterGui` vazios. Nenhum `CLAUDE.md` nem `AGENTS.md` existia.

### Memoria permanente criada

`CLAUDE.md` e `AGENTS.md` na raiz, curtos, apontando para as fontes canonicas.
`docs/PROJECT-MEMORY.md` com visao, pilares, direcao visual, regras de seguranca,
organizacao tecnica, padroes de UI e de documentacao, e restricoes. `docs/CURRENT-STATE.md`
com o estado do place, o marco em andamento e as pendencias. Nenhum documento anterior foi
apagado ou reescrito.

Nenhuma divergencia foi encontrada entre os documentos existentes.

### Decisao de escopo

Training e Parkour ocupavam 54 x 52 e 60 x 58 studs sem ter mecanica por tras. Foram
preservados inteiros em `ServerStorage.DeferredLobbyAreas` e substituidos no lobby ativo
por dois pontos compactos de 17 studs, com laje octogonal, placa, objeto representativo e
`ProximityPrompt`. Registrada como D-014.

### O que foi feito

1. Cinco capturas de referencia antes de qualquer alteracao.
2. `Training` e `Parkour` movidos para `ServerStorage.DeferredLobbyAreas`, cada um com
   nove atributos de restauracao gravados antes do movimento. Nenhum `CFrame` alterado,
   entao a restauracao e mover a Folder de volta.
3. `PathTraining` e `PathParkour` encurtados, segmentos 6 a 9 removidos, 24 pecas.
4. `Areas.TrainingPoint` e `Areas.ParkourPoint` construidos, 28 pecas no total. O Training
   ganhou quatro blocos quebraveis clonados da biblioteca ja auditada, o Parkour ganhou
   tres pedras flutuantes com o friso ambar que ja era a assinatura da area.
5. Onze pares de z-fighting corrigidos.
6. Dois textos que transbordavam a caixa corrigidos.
7. Uma obstrucao de corredor corrigida.
8. Tres defeitos de composicao corrigidos por inspecao visual, todos encontrados em
   captura e nao em teste automatico: os blocos do Training cobriam a placa, as pedras do
   Parkour ficavam na frente da placa e depois se sobrepunham entre si.

### Validacoes executadas

Todas com o Studio em Play, personagem R15 de 5.8517 studs, exceto onde indicado.

| Teste | Resultado |
| --- | --- |
| Scripts, ModuleScripts e remotes no place | 0 e 0 |
| Pecas nao ancoradas no jogo | 0. As 9 encontradas sao do `CoreGui` do Studio |
| Nomes genericos | 0 |
| Pares de z-fighting, antes e depois | 11 e 0 |
| Props flutuando, 150 conferidos | 0 |
| Props sem chao abaixo | 0 |
| Textos que transbordam a caixa, 51 conferidos | 2 antes, 0 depois |
| Obstrucoes de corredor, 64 segmentos | 1 antes, 0 depois |
| Degrau maximo na chegada do TrainingPoint | 0.50 stud |
| Degrau maximo na chegada do ParkourPoint | 0.25 stud |
| Degrau entre pedras do Parkour | 1.30 e 1.40, abaixo do limite de 1.5 |
| Orientacao do spawn | alinhamento 1.000 com o painel de evento |
| Linhas de visao do spawn para 9 alvos | 6 livres. As 3 restantes sao ocultadas pela propria estrutura da area, o que significa que a area e visivel |
| Caminhada fisica, 5 trajetos encadeados | 5 de 5, sem travar e sem cair |
| Travessia spawn ate area | 4.7 s, dentro da faixa de 4 a 8 s do criterio de aceite |
| Menor altura do personagem em todo o percurso | 2.7, ou seja nunca atravessou o chao |
| Tentativa de sair da ilha, com pulo, em 4 direcoes | 0 fugas |
| `ProximityPrompt` alcancaveis a pe | 2 de 2, distancia real 6.2 contra alcance 14 |
| Heartbeat e fisica em Play | 60.0 e 60.0 |

Observacao sobre desempenho: a primeira medicao deu 14.9 quadros por segundo em
`RenderStepped`. O numero e artefato de medicao, nao do lobby. A janela do Studio fica sem
foco enquanto a chamada MCP roda, e o Studio limita a renderizacao nesse estado.
`Heartbeat` e `GetRealPhysicsFPS` deram 60.0 na mesma sessao de Play, e o resultado bate
com os 60 medidos na sessao 002.

### Contagem final

1312 pecas no place, sendo 149 `MeshPart`. A diferenca de 4 contra as 1308 do inicio fecha
exatamente: 24 removidas dos caminhos e 28 criadas nos dois pontos. Descendentes do lobby
caem de 1553 para 1439, e os 132 que sairam estao inteiros em `ServerStorage`.

### O que nao foi feito, de proposito

- nenhuma decoracao, textura ou mudanca de iluminacao, que sao Marco 2
- nenhuma GUI, que e Marco 3. Os dois `ProximityPrompt` ficaram criados e marcados com os
  atributos `Modal` e `Area`, sem nenhum codigo por tras
- nenhum asset novo inserido. Os blocos do TrainingPoint sao clones da biblioteca ja
  auditada, nao importacao nova
- nenhum commit, push ou publicacao

### Bloqueio

O trabalho do Marco 1 esta apenas na memoria do Studio. A integracao nao salva o place.
Aguardando `Ctrl + S` do usuario antes de comecar o Marco 2.

---

## Sessao 005, 2026-09-04: bugs de ambiente, studs em escala e jogabilidade

**Objetivo:** continuar do ponto em que o Codex parou, corrigir bug de ambiente, aplicar
textura de studs em escala e deixar o lobby jogavel de verdade.

### Estado encontrado

Trabalho anterior do Codex ja salvo em disco. 1722 pecas, 286 `MeshPart`, 0 script,
0 remote, 0 peca nao ancorada. Fonte do usuario no centro da praca, fogueira da Creator
Store sanitizada na area social, placar de tempo jogado com rig de avatar integrado, e
`ServerStorage.CP4Rollback` guardando o que foi substituido. O `CrumbleCore` da sessao 004
tinha saido do lobby e estava nesse rollback.

### O bug que mais importava

**Nenhuma das seis lajes de area tinha degrau.** Todas apresentavam parede lisa de 2.5
studs sobre a grama, acima do que o R15 sobe sem pular. Quem nao viesse exatamente pelo
caminho batia e parava.

Isso foi encontrado por teste, nao por inspecao visual. Um circuito de nove trajetos
encadeados travou em cinco. A sondagem no ponto de travamento devolveu, em quatro dos
cinco casos, a lateral de um `Pad` de area.

Correcao: um `StepRing` por laje, com topo na metade da altura, deixando dois passos de
1.25 a 1.27 studs cada.

| Area | Topo da laje | Topo do degrau | Passo |
| --- | --- | --- | --- |
| EventBoard | 2.50 | 1.25 | 1.25 |
| Cosmetics | 2.50 | 1.25 | 1.25 |
| Gamepasses | 2.50 | 1.25 | 1.25 |
| Leaderboard | 2.55 | 1.27 | 1.27 |
| MapVote | 2.55 | 1.27 | 1.27 |
| SocialArea | 2.55 | 1.27 | 1.27 |

### Segundo bug, ja conhecido e reincidente

Uma cadeira da fogueira estava **2.2 studs dentro do corredor** de entrada da area social.
Quem passava sentava sem querer, e o `Seat` segurava o personagem mesmo depois de ele ser
movido para longe. E o mesmo defeito que a sessao 002 ja tinha corrigido uma vez com os
bancos de tronco. As quatro cadeiras foram para o arco norte, viradas para o fogo. Folga
minima ate o corredor passou de -2.2 para 10.3 studs.

### O que foi feito

1. Studs aplicados em 575 superficies novas, chegando a 1109 no place. Criterio: `Part` em
   bloco, topo virado para cima, lado maior ou igual a 3 studs, opaca, nao emissiva, fora
   da biblioteca estacionada. Caminho, laje, penhasco, grama, borda e fragmento entraram.
   Chama, vidro, placa, tapete e detalhe fino ficaram de fora.
2. 54 nomes genericos vindos dos imports corrigidos: `MeshPart` x12, `Part` x14,
   `VisualPart_01` a `_15`, tres `Meshes/IceysAssetPack_*` e um `USPSA/IPSC/RSPSA Target`.
3. Cores do chao reescalonadas. Os caminhos estavam em 190 a 205, quase branco, e e isso
   que lavava a cena inteira. Passaram para 160 e 176 alternados, com meio fio em 94.
4. Praca reformulada: gradiente do escuro na borda ao claro no centro, anel de 28 ladrilhos
   com studs e quatro marcos de pedestal com fragmento suspenso.
5. Prateleira da Cosmetics recuada 4 studs. Ela estava dentro dos tres pedestais de
   display que ja existiam, sobreposicao criada por mim na sessao 004.
6. 7 pecas de decoracao elevadas para nao ficarem enterradas pelos degraus novos.

### Marcos de praca, tres tentativas

A primeira versao usou bandeira triangular montada com tres pecas horizontais. Saiu
desconectada do mastro. A segunda usou pano vertical de 0.22 de espessura, que some quando
visto de lado, defeito classico de pano em low poly. A terceira trocou bandeira por
pedestal de pedra com fragmento de cristal suspenso, que le de qualquer angulo e repete o
vocabulario do mundo que se despedaca em vez de decoracao generica de feira.

Os quatro marcos foram para os maiores vaos entre caminhos, medidos a partir do angulo de
saida real de cada corredor: 299, 241, 350 e 190 graus. Antes disso, nas diagonais de 45 em
45, os quatro invadiam corredor.

### Validacoes executadas

| Teste | Antes | Depois |
| --- | --- | --- |
| Circuito de 9 trajetos encadeados | 4 de 9 | 9 de 9 nas rotas entre areas |
| Subida em laje pela lateral, 6 areas | 0 de 6 | 4 de 6, as 2 restantes param em movel solido |
| Faces visiveis coincidentes, 694 estruturais | 0 | 0 |
| Props flutuando, 240 conferidos | 1 falso positivo | 1 falso positivo |
| Nomes genericos | 60 | 0 |
| Pecas nao ancoradas no jogo | 0 | 0 |
| Scripts e remotes | 0 e 0 | 0 e 0 |
| Folga da cadeira ate o corredor | -2.2 studs | 10.3 studs |
| Heartbeat e fisica em Play | 60.0 | 60.0 |

O unico props flutuando e `TargetPlate_10`, a placa de cima do alvo de treino, presa no
poste. O detector nao enxerga suporte lateral.

### Erro cometido nesta sessao

Uma limpeza automatica de pastas vazias apagou os 14 marcadores de
`ImportedAssets.AssetAuditRecords`, criados pelo Codex. Eram Folders vazias cujo conteudo
estava no nome, por exemplo `Approved_ShinyTrophy` e `RejectedCashLeaderboard_CP4`. Foram
recriados com os mesmos nomes e ganharam os atributos `Situacao`, `RestauradoEm` e
`Observacao`. A pasta pai recebeu o atributo `Proposito` avisando para nao apagar por estar
vazia. Nenhum outro dado foi perdido, e as pastas `AccessSteps` vazias que sumiram junto
eram lixo real, ja substituidas pelo `StepRing`.

### O que nao foi feito, de proposito

- nenhuma GUI, que continua sendo o proximo marco
- nenhum asset novo importado. Os assets da sessao foram os que o Rick inseriu
- nenhuma alteracao em `ServerStorage.CP4Rollback` nem em `DeferredLobbyAreas`
- nenhum commit, push ou publicacao

### Bloqueio

O trabalho esta apenas na memoria do Studio. Aguardando `Ctrl + S`.

---

## Sessao 006, 2026-09-04: primeira interface funcional

**Objetivo:** construir a GUI do lobby seguindo a referencia visual que o Rick trouxe,
contorno preto grosso, canto arredondado e cor saturada.

### Estado encontrado

Sessao 005 salva em disco as 16:40, arquivo de 266 KB. Lobby com 1570 pecas, 1109
superficies com studs, 0 script, 0 remote.

### O que foi construido

Interface inteira com componente nativo, sem uma imagem sequer. 551 descendentes.

Quatro botoes laterais com icone desenhado em `Frame`, nao em imagem: losango com brilho
para cosmeticos, etiqueta com furo para passes, tres colunas de podio para ranking e tres
controles deslizantes para ajustes. Cada botao tem sombra deslocada, contorno de 3, canto
de 14, gradiente vertical e brilho de topo.

Cinco paineis: Cosmetics com grade de 6 itens e faixa de raridade, Gamepasses com 3 passes,
Leaderboard com 5 linhas e podio ouro, prata e bronze, Settings com dois interruptores e o
preview do HUD, e o modal de Coming Soon.

HUD de preview com chip de status, cronometro, contador de vivos e as faixas SPECTATING e
ELIMINATED. Nao existe sistema de round, entao os cinco estados sao acionados por botao
dentro de Settings.

`UIController` com 312 linhas. `UIConfig` e `MockData` em `ReplicatedStorage`.
`SoundService.LobbyMusic` e `SoundService.SFX` criados, o primeiro sem faixa.

### Validacoes executadas

Tudo por clique e tecla reais, com `user_mouse_input` e `user_keyboard_input`, nao por
chamada de funcao.

| Teste | Resultado |
| --- | --- |
| Clique no botao lateral abre o painel | Leaderboard abriu em 600x400 |
| Clique no X fecha e restaura o tamanho | fechou, scrim sumiu, tamanho voltou a 600x400 |
| Clique em GOT IT fecha o modal | fechou |
| Clique em SPEC muda o HUD | status virou ROUND IN PROGRESS, timer 1:12, faixa e contador apareceram |
| Tecla E no `ProximityPrompt` do Training | modal abriu com TRAINING, COMING SOON e o texto do briefing |
| Texto que nao cabe na caixa | 0 em toda a interface |
| Console em Play | sem erro |
| `stylua --check src` e `selene src` | 0 divergencias, 0 erros, 0 avisos |

Responsividade, medida no simulador de dispositivo do Studio:

| Tela | Escala | Barra | Resultado |
| --- | --- | --- | --- |
| iPhone 7, 666x374 | 0.62 | rodape horizontal | 0 botao cortado, 0 alvo menor que 44px |
| iPhone 16, 733x370 | 0.70 | lateral vertical | barra de y=40 a y=295 em 370 de altura |

### Tres defeitos encontrados por teste, nao por leitura

1. **Joystick do Roblox sobre o botao SETUP.** So apareceu na captura do iPhone 16. A barra
   vertical na lateral esquerda disputa espaco com o joystick. Correcao: em qualquer
   dispositivo de toque a barra vai para o rodape centralizado, que e a unica faixa livre
   entre o joystick a esquerda e o botao de pulo a direita.
2. **Barra vertical no rodape em tela estreita.** A primeira versao mudava a ancora mas
   nao a direcao, e a barra ocupava 62 por cento da altura util. Passou a ser horizontal.
3. **`ViewportSize` degenerado.** Enquanto a janela do Studio fica oculta durante a chamada
   MCP, `ViewportSize` vem 1 por 1, e o controller jogava a interface para o layout de
   telefone sem motivo. Correcao: ignorar viewport menor que 50 e tentar de novo por ate
   dois segundos.

### Limitacao de metodo encontrada

`ProximityPrompt:InputHoldBegin()` chamado por script nao dispara `Triggered` nem
`ProximityPromptService.PromptTriggered`. O teste so passou com tecla real. Isso vale para
qualquer teste futuro de prompt.

### O que nao foi feito, de proposito

- nenhum DataStore, `MarketplaceService`, compra, votacao real, moeda, round ou teleporte
- nenhuma faixa de musica escolhida. A instancia existe e o botao ja liga nela
- nenhum efeito sonoro de interface
- nenhum commit, push ou publicacao

### Bloqueio

Interface apenas na memoria do Studio. Aguardando `Ctrl + S`.

---

## Sessao 007, 2026-09-04: borda da ilha, NPC, musica, e o segundo incidente de persistencia

**Objetivo:** cercar a borda da ilha, criar a tendinha de Cosmetics com NPC, colocar
musica, melhorar iluminacao e ceu, e decorar com assets do Creator Store.

### Estado encontrado

Place salvo as 16:40 com o lobby ate o Marco 4. A interface da sessao 006 estava apenas
na memoria do Studio, nunca salva. O Rick avisou que estava por acesso remoto.

### O que foi construido

1. **Cerca da borda.** 48 postes no raio 120.5, 193 pecas, anel fechado. As cercas
   antigas cobriam so 12 angulos e foram removidas. Todos os postes assentados por
   raycast, 0 flutuando.
2. **Barreira invisivel** elevada de 18 para 26 studs. Continuidade conferida com 720
   raios horizontais em 5 alturas: 0 falhas. Fuga com pulo em 6 direcoes: 0 fugas, o
   personagem para no raio 123 mesmo subindo na cerca.
3. **16 objetos afastados** para nao cruzarem a cerca, entre eles 9 arvores e a arvore
   grande da area social, que foi de raio 116 para 98 e saiu de cima do deck.
4. **Tenda de Cosmetics** rebaixada. Toldo de 19.6 para 13.4, balcao mais raso para caber
   o NPC atras, dois postes de fundo, laterais e fundo de lona listrada, babado no toldo.
5. **NPC lojista `PIP`**, 23 pecas autorais em estilo low poly, com `BillboardGui` e
   `ProximityPrompt` que abre o painel de Cosmetics. O controller ganhou o ramo
   `Modal = "OpenPanel"`.
6. **Musica.** `Skip in Your Step (b)`, `rbxassetid://9038305339`, APM Music, album
   Upbeat Acoustic, 125 s. Conferido em Play: carrega, toca e tem 125.2 s, batendo com os
   125 declarados. APM e biblioteca de producao licenciada e parceira oficial do Roblox,
   com metadado estruturado, mesmo padrao que o SkillLab ja classificou como Nivel A.
7. **Iluminacao e ceu.** `ClockTime` 14.6, nuvens com cobertura 0.55 e densidade 0.78,
   atmosfera mais quente.
8. **Dois pacotes auditados** em quarentena, `Berry Bush Pack 1` e `Low-Poly Rocks`, os
   dois com 0 script e 0 decal. A distribuicao pela ilha nao chegou a ser feita.

### Defeito encontrado por teste

O `ProximityPrompt` do NPC nao disparava. Causa: a peca pai estava com `CanQuery = false`.
Os prompts que funcionavam tinham `true`. Corrigido, e a varredura confirmou que os tres
prompts do lobby estao com o pai consultavel.

### Limitacoes da sessao remota

Com o Rick por acesso remoto, o Studio suspendeu a renderizacao e o foco de janela:

- `screen_capture` passou a dar timeout e nao voltou
- `ViewportSize` vinha `1 x 1`, o que fez a interface cair no layout de telefone sem
  motivo. Corrigido no controller, que agora ignora viewport abaixo de 50 e tenta de novo
- **input simulado parou de chegar.** O teste com tecla no prompt do Training, que tinha
  passado na sessao 006 na mesma posicao, tambem falhou. Isso foi usado como controle e
  prova que a falha era do ambiente, nao do NPC

Por isso a ligacao do NPC com o painel esta conferida por leitura do codigo ativo no
cliente, e nao por teste de tecla. Falta testar a mao.

### O incidente

O Studio fechou as 17:52 com o dialogo de salvar aberto e um save em andamento que nao
completou. O place canonico ficou parado nas 16:40. Cerca de quatro horas de trabalho,
incluindo a interface inteira da sessao 006, ficaram fora do arquivo.

Primeira busca por recuperacao automatica olhou em `Local\Roblox\AutoSaves`, que **nao
existe**. O caminho certo e:

```text
C:\Users\ricka\AppData\Local\Roblox\RobloxStudio\AutoSaves\
```

La estava `CrumbleArena_AutoRecovery_1.rbxl`, de 17:34, com 320.247 bytes contra 265.854
do save de 16:40.

### Recuperacao

1. Copiado para `backups\CrumbleArena-AUTORECOVERY-2026-09-04T1734.rbxl`, conferido por
   SHA-256 contra a origem. Isso veio primeiro porque o Roblox descarta esses arquivos na
   proxima abertura do Studio.
2. Varredura de marcadores no binario confirmou presenca de `UIController`, `UIConfig`,
   `MockData`, `LobbyMusic`, `FencePost`, `ShopPrompt` e `TentCloth`, todos ausentes no
   save de 16:40.
3. O save de 16:40 foi preservado em `backups\CrumbleArena-SAVEDFILE-2026-09-04T1640.rbxl`.
4. So depois disso a recuperacao foi copiada para o caminho canonico, com SHA-256
   conferido nos dois sentidos.

Nada foi apagado. Os quatro estados do place estao em `backups\`.

### O que salvou o dia, e o que foi sorte

O codigo da interface sobreviveu porque a D-017 mandou versionar em `src/client/`. As 392
linhas estavam intactas em disco, com `stylua` e `selene` limpos, independentes do place.

A arvore de instancias da interface sobreviveu **por sorte**, pela recuperacao automatica.
Isso virou a D-018.

### Validacoes executadas

| Teste | Resultado |
| --- | --- |
| Continuidade da barreira, 720 raios em 5 alturas | 0 falhas |
| Fuga com pulo, 6 direcoes | 0 fugas, para no raio 123 |
| Conflito da cerca com props, borda e areas | 0 apos as correcoes |
| Postes da cerca flutuando | 0 |
| Musica carrega e toca | sim, 125.2 s |
| Pacotes do Creator Store, itens proibidos | 0 nos dois |
| SHA-256 das copias de backup | identicos nos dois arquivos |
| `stylua --check src` e `selene src` | 0 divergencias, 0 erros, 0 avisos |

### Nao testado

- interface, cerca, NPC e musica dentro do place recuperado. So a abertura do Studio
  confirma
- `ProximityPrompt` do NPC por tecla
- qualquer coisa visual, porque a captura de tela parou de responder

### Bloqueio

Studio fechado. O place canonico e hoje um arquivo de recuperacao, nao um save. Precisa
ser aberto, conferido e salvo com `Ctrl + S`.
