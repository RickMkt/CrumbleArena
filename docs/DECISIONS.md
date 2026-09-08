## D-024, 2026-09-07: colaboracao com writer unico e cloud privado

Direcao aprovada pelo pedido: Team Create para mapa; GitHub/Rojo para codigo e docs;
RBXL como checkpoint. Implantacao depende de aprovacao, IDs e gate Rojo.
ONLY ONE AI STUDIO WRITER AT A TIME inclui Rojo, plugins e MCP em todos os hosts.
Registro local nao e lock: grant humano ao vivo e ACK de ambos, conforme COLLABORATION.
Nenhuma publicacao, commit ou push autorizado por esta decisao. D-013 permanece
valida para o Place local ate aceite da migracao; D-017 so muda apos gate tecnico.

## D-025, 2026-09-07: direcao atual de refinamento do lobby

Nao reconstruir macroestrutura. Studs sutis, decoracao intencional, sem portais ou
map vote fisico (futuro via GUI). Preservar Market, antigo Pip's, atual CRUMBLE SUPPLY,
com linguagem de ferramentas/pa/picareta. Community discreta, nao mercado adicional.
Leaderboard: MOST WINS e MOST KOs paineis; MOST DONATES unico avatar.
Preview nao autoriza sistema de doacoes. Cobertura simples, sem Hall gigante.
Propostas V2/roadmap de remontagem integral nao autorizam redesign.
A implementacao31 existe, mas aceitacao visual final continua do Henrique.

# Decisoes

Registro de decisao. Cada entrada diz o contexto, a escolha, o motivo e a consequencia.
Decisao registrada nao se muda em silencio: cria-se uma nova entrada que revoga a antiga.

---

## D-001, 2026-09-03: o repositorio do Crumble Arena fica em `Desktop\CrumbleArena`

**Contexto:** ja existia `Desktop\CrumbleArena` com um MVP anterior chamado Snowball
Classic, 32 arquivos `.lua`, sem repositorio Git, parado desde 2026-05-08. A estrutura nova
colidia com `README.md`, `default.project.json` e `src/`.

**Decisao:** o projeto novo ocupa `Desktop\CrumbleArena`. O MVP anterior foi preservado
inteiro em `legacy/mvp-2026-05/`, dentro do mesmo repositorio. Autorizada pelo Rick na
sessao 001.

**Motivo:** o caminho oficial precisa ser o nome do jogo. O codigo anterior tem valor de
referencia, ele ja resolveu round, espectador e projetil server authoritative para este
mesmo conceito, entao apagar seria perda real.

**Consequencia:** `legacy/` nunca entra no build, nao esta mapeado no
`default.project.json` e nao e formatado nem linted. Ele existe para ser lido.

**Evidencia:** os 32 arquivos foram inventariados com SHA-256 antes do movimento e
reconferidos depois. Os 32 hashes bateram. Um snapshot `.tar.gz` de 25 KB foi gerado antes
de qualquer alteracao.

---

## D-002, 2026-09-03: repositorio Git proprio, separado do Promote Me

**Contexto:** o Promote Me e outro jogo, com repositorio proprio em `Desktop\PromoteMe`,
com 5 arquivos modificados e 32 nao rastreados no momento desta sessao.

**Decisao:** `git init` no Crumble Arena, sem commit, sem remote e sem push. Autorizada
pelo Rick na sessao 001.

**Motivo:** separacao total entre os dois jogos. Nenhum arquivo do Promote Me foi lido para
escrita, modificado, movido ou removido nesta sessao.

**Consequencia:** o Crumble Arena tem historico proprio desde o primeiro commit, que ainda
nao foi feito. O primeiro commit depende de autorizacao explicita.

---

## D-003, 2026-09-03: o Studio nao foi tocado nesta sessao

**Contexto:** havia uma unica instancia do Studio conectada via MCP, chamada `Place1`, em
modo Edit, com `PlaceId` 0, Workspace contendo apenas Camera, Baseplate, Terrain e
SpawnLocation, e zero scripts.

**Decisao:** nao criar, alterar ou remover nada no Studio.

**Motivo:** `PlaceId` 0 e nome `Place1` indicam um place novo, nunca salvo e nunca
publicado. Ele nao e o place do Crumble Arena, porque o place do Crumble Arena ainda nao
existe. A condicao "o Place correto estiver identificado" nao foi atendida, e a regra da
sessao manda parar antes de modificar o Studio quando isso acontece.

**Consequencia:** a fase 1 comeca criando e salvando um place proprio do Crumble Arena. Ver
decisao pendente D-P02.

---

## D-004, 2026-09-03: `rokit.toml` em vez de `aftman.toml`

**Contexto:** a estrutura proposta pedia `aftman.toml`. O Aftman esta descontinuado em
favor do Rokit, e o Promote Me, na mesma maquina, ja usa `rokit.toml`.

**Decisao:** usar `rokit.toml`.

**Motivo:** adotar um gerenciador descontinuado no primeiro dia de um projeto que quer
virar base de estudio seria criar divida sem beneficio.

**Consequencia:** nesta maquina o Rokit nao esta instalado. As ferramentas vieram de
`cargo install` e as versoes no `rokit.toml` refletem exatamente o que foi executado e
validado nesta sessao. Ver risco R-002 em SESSION-LOG.md.

---

## D-005, 2026-09-03: `MIN_PLAYERS_TO_START` igual a 2

**Contexto:** o conceito define ate 8 jogadores, sem definir o minimo.

**Decisao:** 2.

**Motivo:** escolha conservadora. 2 e o menor numero que produz competicao real, e permite
testar o ciclo completo de round com duas janelas do Studio.

**Consequencia:** trivial de aumentar depois. E o unico numero de balanceamento decidido
ate agora, todos os outros continuam em aberto.

---

## D-006, 2026-09-03: teste puro sinaliza falha com `error`, nao com `process.exit`

**Contexto:** o Selene 0.31 nao aceita definir globais dentro do `selene.toml`, e o global
`process` do Lune quebrava o lint dos testes.

**Decisao:** o teste chama `error()` ao falhar, que ja faz o Lune sair com codigo 1. Os
testes tem um `tests/selene.toml` proprio com `std = "luau"`.

**Motivo:** evita manter um arquivo de biblioteca padrao customizado so para um global.

**Consequencia:** o lint dos testes roda com `selene --config tests/selene.toml tests`, um
comando separado do `selene src`. Os dois estao no README.

---

---

## D-007, 2026-09-03: o lobby foi construido no place em branco `Place1`

**Contexto:** o Studio tinha uma unica instancia conectada, `Place1`, com `PlaceId` 0,
`GameId` 0, modo Edit, contendo apenas Camera, Baseplate, Terrain e SpawnLocation, e zero
scripts. Nao era o SkillLab nem o Promote Me.

**Decisao:** construir o lobby ali, e remover o Baseplate e o SpawnLocation padrao.

**Motivo:** o place estava vazio, entao nao havia trabalho a perder, e a condicao "nao
representa risco para o SkillLab ou o Promote Me" foi atendida. A alternativa, parar e nao
construir nada, contrariava o pedido explicito da sessao.

**Consequencia:** o place continua sem arquivo. O `Save As` depende do usuario, porque o
sandbox do Studio nao expoe salvar por script. Enquanto isso, a rede de seguranca e
`docs/LOBBY-BUILD-PARAMS.md`. Ver risco R-006 em SESSION-LOG.md.

---

## D-008, 2026-09-03: sem portal de entrada em partida

**Contexto:** o MVP anterior e a maioria dos jogos do genero usam um portal para entrar na
partida.

**Decisao:** o lobby nao tem portal. Os jogadores esperam no lobby e o sistema os leva ao
mapa quando a partida comecar. Definida pelo Rick.

**Motivo:** o portal ensina a coisa errada. Ele sugere que entrar e uma acao do jogador,
quando na verdade e o servidor que decide o momento.

**Consequencia:** a area de espera precisa se sustentar sozinha, o que e o motivo do
parkour e da area social existirem ja nesta fase.

---

## D-009, 2026-09-03: o cronometro da partida nao vai no painel fisico

**Contexto:** o painel fisico e o lugar obvio para uma contagem regressiva.

**Decisao:** o painel fisico e so comunidade, evento, temporada, codigo e cosmetico. A
contagem sera GUI de tela. Definida pelo Rick.

**Motivo:** informacao com prazo precisa estar sempre visivel, e um painel fisico so e
legivel de um lado da ilha.

**Consequencia:** o painel de evento tem espaco reservado para um botao `CLAIM` que hoje e
so um `Frame`, sem nenhuma logica por tras.

---

## D-010, 2026-09-03: a ilha e uma grade de blocos de 24 studs, nao uma malha suave

**Contexto:** a primeira tentativa montou cada camada com tres caixas cruzadas, e a
silhueta saiu em estrela de doze pontas em vez de octogono.

**Decisao:** cada camada da ilha e uma grade de celulas de 24 studs recortada num disco.

**Motivo:** a silhueta em degraus e exatamente a linguagem de um mundo que se despedaca, e
cada celula continua editavel sozinha.

**Consequencia:** 439 pecas so na ilha. Em compensacao, mudar o formato da ilha e mudar um
raio, e nao remodelar nada.

---

## D-011, 2026-09-03: o criterio de celula passou a ser interseccao, nao centro

**Contexto:** o teste de chao encontrou 10 pontos sem piso entre o raio 108 e a barreira
em 124. A causa era o criterio "centro da celula dentro do raio", que deixa um vao de ate
12 studs na borda.

**Decisao:** uma celula entra na camada quando a area dela encosta no disco do raio.

**Motivo:** e a unica forma de garantir que todo ponto alcancavel tenha chao.

**Consequencia:** ilha de 264 studs de largura, e 0 buracos em 1903 amostras.

---

## D-012, 2026-09-03: assets so entram vindos do inventario do usuario

**Contexto:** a busca no Creator Store por termos genericos como "low poly tree" devolveu
modelos de criadores sem verificacao, sem licenca declarada e com descricoes do tipo
"feito por z4cked, quem disser que e dono esta mentindo".

**Decisao:** nenhum modelo do Creator Store publico foi inserido. Foram usados apenas os
tres pacotes KayKit ja no inventario do usuario, que constam no registro do SkillLab como
CC0 com licenca verificada.

**Motivo:** origem rastreavel e licenca arquivada valem mais que variedade visual.

**Consequencia:** a biblioteca do lobby tem 16 malhas. O que faltou foi recriado com
`Part`, o que na pratica manteve o estilo mais coerente do que juntar pacotes diferentes.

## D-013, 2026-09-04: o place canonico e `CrumbleArena/CrumbleArena.rbxl`

**Contexto:** a sessao 002 terminou sem salvar. O unico `Save As` do dia tinha acontecido
antes da construcao e gravou um baseplate vazio em `Documents\CrumbleArena.rbxl`. O lobby
sobreviveu apenas no arquivo de recuperacao automatica do Studio.

**Decisao:** o place canonico passa a ser `C:\Users\ricka\Desktop\CrumbleArena\CrumbleArena.rbxl`,
dentro do repositorio, ignorado pelo Git via `*.rbxl`. O conteudo veio, byte a byte, de
`CrumbleArena_AutoRecovery_0.rbxl`, SHA-256 `56D11E5B29375B26...`.

**Descartado:** manter o place em `Documents`. Ficava longe do projeto, fora de qualquer
convencao e foi exatamente o que fez a busca da sessao seguinte concluir que o arquivo nao
existia. O arquivo antigo em `Documents\CrumbleArena.rbxl` esta obsoleto, contem um
baseplate vazio e nao deve ser aberto.

**Consequencia:** existe um caminho unico e previsivel. Toda sessao futura abre esse
arquivo e salva nele com `Ctrl + S` ao fim de cada bloco de construcao.

---

## D-014, 2026-09-04: Training e Parkour saem do lobby ativo, preservados inteiros

**Contexto:** as duas areas ocupavam 54 x 52 e 60 x 58 studs, somando 132 pecas, sem ter
nenhuma mecanica por tras. Elas consumiam mais espaco do que qualquer area funcional do
lobby e empurravam tudo para longe do centro, o que contraria o objetivo de um lobby
compacto.

**Decisao:** mover as duas Folders inteiras para `ServerStorage.DeferredLobbyAreas` e
substitui-las no lobby ativo por dois pontos compactos de 17 studs, cada um com laje
octogonal, placa dizendo o nome e `COMING SOON`, um objeto representativo e um
`ProximityPrompt`. Os caminhos de acesso foram encurtados de 9 para 5 segmentos.

**Descartado:** apagar as areas, que jogaria fora trabalho testado da sessao 002. Tambem
descartado deixa-las como estavam ate existir mecanica, porque o lobby precisa ficar
apresentavel antes disso.

**Consequencia:** a restauracao e mover a Folder de volta para
`Workspace.CrumbleArena.Lobby.Areas`. Nenhum `CFrame` foi alterado, entao tudo volta ao
lugar exato. Cada Folder carrega nove atributos de restauracao, incluindo `OriginalParent`,
`OriginalCenter` e `RestoreInstruction`. Os dois `ProximityPrompt` ficam sem codigo ate o
Marco 3, marcados com os atributos `Modal = "ComingSoon"` e `Area`.

---

## D-015, 2026-09-04: estrutura nao se sobrepoe, encosta

**Contexto:** o Rick apontou que pecas de estrutura sobrepostas ficam bugadas na tela, e
pediu alinhamento em vez de sobreposicao. O efeito e z-fighting: duas faces no mesmo plano
disputam qual aparece, e o resultado pisca conforme a camera se move.

**Decisao:** duas pecas de estrutura nunca compartilham uma face visivel. Face de baixo de
uma encostando na face de cima da outra e encaixe correto e continua permitido, porque as
faces sao opostas e nao disputam nada. O que e proibido e duas faces do mesmo sentido no
mesmo plano.

**Como se verifica:** varredura de pares de `Part` alinhados aos eixos que se
interpenetram nos tres eixos e tem alguma face `Y+`, `X+`, `X-`, `Z+` ou `Z-` a menos de
0.02 stud de distancia. A face `Y-` fica de fora porque a base da ilha nao e visivel.
Quando aparece conflito, a peca de menor volume recua 0.03 stud na direcao da face.

**Consequencia:** a varredura entrou no fim de cada bloco de construcao. Na sessao 005 ela
conferiu 694 pecas estruturais e devolveu 0 conflitos. A biblioteca estacionada em
Y = -600 e o rig do avatar ficam fora da conta, porque nao sao vistos em jogo.

---

## D-016, 2026-09-04: studs por criterio, nao em tudo

**Contexto:** o Rick pediu textura de lego em tudo que fosse possivel, e trouxe referencia
de gramado com relevo de studs. O `PROJECT-MEMORY` dizia para usar studs de forma seletiva.

**Decisao:** vale o pedido do Rick, com um criterio tecnico que evita o resultado virar
ruido. Recebe studs a peca que atende a tudo: e `Part` em formato bloco, o topo aponta para
cima, o menor lado horizontal tem 3 studs ou mais, e ela nao e transparente nem emissiva.

**Motivo do criterio:** stud tem tamanho fixo. Numa peca de 1 stud ele vira sujeira, e em
vidro, chama ou tapete ele nao faz sentido. O limite de 3 studs foi o que separou superficie
de detalhe sem precisar listar excecao caso a caso.

**Descartado:** aplicar em `MeshPart`, porque `SurfaceType` nao tem efeito nelas, e nos
cilindros dos aneis da praca, porque a face circular nao recebe stud. A praca ficou lisa de
proposito e ganhou um anel separado de 28 ladrilhos em bloco, esses sim com studs.

**Detalhe que custou tempo:** stud so aparece com `Material.Plastic`. Com `SmoothPlastic`
a propriedade fica gravada e nao renderiza nada.

**Consequencia:** 1109 superficies com studs no place. Caminho, laje, penhasco, gramado,
borda, fragmento e ladrilho entraram. Chama, vidro, placa, tapete e detalhe fino ficaram
de fora.

---

## D-017, 2026-09-04: a interface vive no place e tem copia versionada

**Contexto:** o lobby foi construido a mao no Studio e a decisao D-P01, sobre como o mapa e
reconstruido, continua aberta. A interface e codigo, nao geometria, entao merecia estar no
Git desde o comeco. Mas o `default.project.json` mapeia `src/client` para
`StarterPlayer.StarterPlayerScripts.Client`, e a interface precisa de instancias que o Rojo
nao gera sozinho, alem de exigir o plugin do Rojo conectado, que depende de acao humana.

**Decisao:** a instancia viva da interface fica no place. O codigo Luau tem copia
versionada em `src/client/`, com cabecalho apontando para o caminho no place:

```text
src/client/UI/UIConfig.luau                    ReplicatedStorage.CrumbleArena.UI.UIConfig
src/client/UI/MockData.luau                    ReplicatedStorage.CrumbleArena.UI.MockData
src/client/Controllers/UIController.client.luau StarterPlayer.StarterPlayerScripts.UIController
```

**Descartado:** manter so no place, que deixaria 312 linhas de codigo fora do Git.
Descartado tambem passar a depender do `rojo serve` agora, que trocaria um problema de
versionamento por um bloqueio de sessao.

**Consequencia:** existe divida. As duas copias precisam ser sincronizadas a mao, e nada
alerta se divergirem. O lint cobre a copia versionada, e foi ele que apontou seis avisos
que depois foram corrigidos nos dois lados. A divida se paga quando D-P01 for resolvida e
o Rojo virar o caminho oficial.

**Evidencia:** `stylua --check src` sem divergencia e `selene src` com 0 erros e 0 avisos,
depois de corrigir os seis avisos nas duas copias.

---

## D-018, 2026-09-04: trabalho caro nasce de script versionado

**Contexto:** o Studio fechou as 17:52 sem gravar o place, e quatro horas de trabalho
ficaram de fora do arquivo. A interface da sessao 006, com 551 descendentes, existia
apenas como instancia criada a mao dentro do place. O arquivo de recuperacao automatica
das 17:34 devolveu quase tudo, mas isso foi sorte, nao processo.

**O que ja tinha funcionado:** o codigo da interface sobreviveu intacto porque a D-017
mandou versionar em `src/client/`. As 392 linhas estavam em disco, com lint limpo, sem
depender do place.

**Decisao:** o que for caro de refazer nasce de script versionado em `tools/rebuild/`, e
nao de instancia solta no place. Vale para interface, para kit modular e para qualquer
geometria repetitiva gerada por laco. O primeiro e `01-BuildLobbyUI.luau`.

**Descartado:** salvar com mais frequencia. Isso trata o sintoma. O save manual continua
sendo pedido ao fim de cada marco, mas nao e mais a unica rede.

**Descartado tambem:** transformar todo o lobby em script agora. As 1570 pecas foram
construidas e ajustadas a mao ao longo de cinco sessoes, e reescrever isso como codigo
seria um projeto proprio. Continua sendo a decisao pendente D-P01.

**Consequencia:** existe divida conhecida. A cerca, a tenda, o NPC, a iluminacao e o
lobby inteiro continuam so no place, e `tools/rebuild/README.md` lista isso de forma
explicita para ninguem se enganar. O script de interface esta escrito e **nao foi testado**,
porque o Studio fechou antes.

**Fato operacional que custou tempo:** a recuperacao automatica do Studio fica em
`AppData\Local\Roblox\RobloxStudio\AutoSaves`, e nao em `AppData\Local\Roblox\AutoSaves`.
A primeira busca olhou no lugar errado e quase concluiu que nao havia recuperacao.

## D-019, 2026-09-05: caminhabilidade se mede andando, nao com sonda

**Contexto:** a circulacao do lobby foi medida de tres jeitos na sessao 008. Raio de cima
para baixo acusou 6 rotas com problema, e estava errado: o raio acertava toldo, balcao e a
propria fonte. `PathfindingService` com agente sem pulo acusou 3 emendas sem rota no
`PathSocial`, e tambem estava errado: o personagem andou aquele trecho inteiro, do spawn ao
deck, em 6,8 segundos, com `JumpPower = 0`.

**Decisao:** o criterio de circulacao e um Humanoid R15 andando com o pulo anulado, em modo
Play. Sonda por raio serve para achar suspeita, nunca para dar veredito. `PathfindingService`
so vale como criterio quando o que se quer medir e NPC, porque jogador nao usa navmesh.

**Como se verifica:** `hum.UseJumpPower = true`, `hum.JumpPower = 0`, e uma sequencia de
`MoveTo` pelos centros das placas do caminho, conferindo a distancia ao alvo a cada 0,1 s.
Rota so conta como aprovada se o personagem chegar a menos de 4 studs do ultimo alvo.

**Consequencia:** quatro afirmacoes minhas na mesma sessao foram falso positivo da propria
ferramenta de medicao. Toda medida por raio agora precisa dizer **em que peca bateu**, e o
relatorio precisa conferir se aquela peca e piso mesmo.

---

## D-020, 2026-09-05: placa de caminho em curva se sobrepoe, e isso nao fere a D-015

**Contexto:** as placas dos caminhos giram cerca de 4 graus por segmento nas curvas. Como
sao caixas retangulares, a emenda virava cunha: fechada na borda interna, 0,10 no centro e
ate 0,66 na borda externa, dentro da faixa que o jogador pisa. O meio fio nao cobre, ele
comeca exatamente na borda da placa e vai para fora.

**Decisao:** as 192 pecas de caminho, placa e meio fio, foram alongadas 0,8 no proprio eixo,
mantendo o centro. Elas passam a se sobrepor um pouco na emenda.

**Por que nao fere a D-015:** a D-015 proibe duas faces do mesmo sentido no mesmo plano, que
e o que causa z-fighting. Placas vizinhas estao em alturas diferentes, entao as faces de
cima nunca sao coplanares. As faces que se encontram na emenda tem sentidos opostos, e depois
do alongamento ficam enterradas. Em curva, com caixa retangular, ou sobra fresta do lado de
fora ou sobra sobreposicao do lado de dentro, nao existe terceira opcao.

**Como se verifica:** varrer **ao longo** do caminho atravessando a emenda, de 0,02 em 0,02,
e medir o comprimento do trecho que cai na grama. Amostrar em cima da linha da emenda sempre
da aberto e nao mede nada. Depois da correcao: 0,00 nos 8 caminhos.

**Consequencia:** ninguem deve "consertar" essa sobreposicao numa proxima varredura de
D-015. `tools/fixes/01-ClosePathSeams.luau` guarda o comprimento original de cada peca em
atributo e traz a reversao escrita no arquivo.

---

## D-021, 2026-09-06: stud vem de camada de placas, porque o terreno e wedge

**REVOGADA no mesmo dia pela D-023.** A premissa estava errada: WedgePart aceita stud,
so que na face que aponta para cima, que nestas pecas nao e a `TopSurface`. Fica
registrada porque o erro e instrutivo, nao porque a decisao vale.

**Contexto:** o Rick pediu o mapa inteiro em textura de lego. A D-016 ja mandava aplicar
stud por criterio, mas ela foi escrita quando o lobby era feito de `Part`. O lobby
reconstruido pelo Astra tem 303 `WedgePart` em 663 pecas, e a ilha, a praca, os caminhos e
os terracos sao todos wedge. `WedgePart` nao renderiza stud em nenhuma face, entao trocar
o material sozinho deixava o mundo liso e o pedido nao era atendido.

**Decisao:** o stud do chao vem de uma camada separada de placas de 8 studs, em
`Architecture.LegoPlating`, assentada sobre o chao que e mesmo plano. O terreno wedge
continua embaixo, so trocando de material.

**Como se decide onde entra placa:** sonda no centro da celula mais os quatro cantos a 3.6
studs. A placa so entra se o centro bate em peca de chao e pelo menos tres cantos batem na
mesma altura, com tolerancia de 0.05. Rampa, degrau e borda reprovam sozinhos, sem precisar
de lista de excecao, entao a silhueta continua sendo a do terreno.

**Descartado:** trocar o terreno wedge por blocos. Seria refazer a ilha inteira do Astra
para ganhar textura, e o custo nao paga. Descartado tambem passo de 12 studs: com quatro
cantos obrigatorios so 37 de 138 celulas passavam, porque toda emenda de caminho reprovava
a celula inteira.

**Consequencia:** 218 placas e 34 ladrilhos, e o chao sobe 0.3 onde ha placa e 0.24 no
terraco do mercado. Isso cria degrau de 0.24 nas emendas, medido e bem abaixo do limite de
1.5 da D-016. A camada some inteira apagando a pasta, e cada peca de material trocado
guarda `PreLegoMaterial` e `PreLegoTopSurface` em atributo.

**Evidencia:** 312 superficies com stud, degrau maximo de 0.24 na rampa `MarketRise` e
dentro do terraco. Ver `tools/rebuild/08-LegoPlating.luau`.

---

## D-022, 2026-09-06: a pose do lojista e escrita peca a peca, sem animacao

**Contexto:** o rig do lojista usa `AnimationConstraint` com `BallSocketConstraint`, nao
`Motor6D`, e as 16 pecas estao ancoradas. Nao existe `Animate` no rig, e a regra da sessao
proibe inventar Asset ID, entao nao ha animacao de catalogo para chamar.

**Decisao:** a pose e gravada nos `CFrame` das pecas. Constraint nao arrasta peca ancorada,
entao a pose vale em Edit e em Play, sem script e sem Asset ID.

**Como se faz sem quebrar:** o ombro e lido uma unica vez, no neutro, e o cotovelo e
transportado pelo primeiro giro. Recalcular o ombro como "topo do braco" depois de girar
quebra a pose, porque passados 90 graus o topo local do braco ja aponta para baixo e o pivo
vira o punho. O sinal do giro em torno de `LookVector` foi medido, nao deduzido: positivo
leva o braco para dentro do corpo.

**Consequencia:** o lojista acena parado. Quando existir sistema de animacao no jogo, esta
pose vira o estado de repouso e nao atrapalha. Ver `tools/rebuild/07-PoseShopkeeper.luau`,
que confere o proprio resultado com dois `assert`.

---

## D-023, 2026-09-06: stud vai na face que aponta para cima, nao na `TopSurface`

**Revoga a D-021**, escrita alguma horas antes no mesmo dia, e corrige a D-016.

**Contexto:** a D-016 dizia que stud vai em `TopSurface`. Isso vale enquanto o mundo e
feito de `Part` sem rotacao, que era o caso quando ela foi escrita. O lobby reconstruido
pelo Astra e feito de `WedgePart` girados. Medido em `IslandGrass.Face1_1`:

```text
Size        = (2.00, 23.31, 30.36)
RightVector = (0, -1, 0)
```

O eixo X local da peca aponta para baixo no mundo, entao a face virada para o ceu e a
`LeftSurface`. Na peca vizinha `Face1_2` o `RightVector` vale `(0, 1, 0)` e a face de cima
e a `RightSurface`. Elas alternam ao longo da ilha inteira.

**O erro que isso causou:** como eu so escrevia em `TopSurface`, a propriedade gravava e
nada aparecia. Concluir dai que `WedgePart` nao aceita stud foi um salto sem teste, e a
partir dele construi uma camada de 1.317 placas por cima do terreno. A camada funcionava,
mas tinha 0.3 de espessura e virava prateleira em toda borda: de longe a ilha lia como
tapete recortado. Quem apontou foi o Rick, olhando, antes de qualquer medicao minha.

**Decisao:** a regra deixa de ser um nome de propriedade. Recebe stud a face cuja normal
aponta para cima com `Y > 0.9`, seja ela `Top`, `Left`, `Right`, `Bottom`, `Front` ou
`Back`. O limite de 3 studs da D-016 continua valendo, mas medido nos dois lados
perpendiculares a essa face, e nao em `Size.X` e `Size.Z`.

**Consequencia:** 384 superficies com stud, nenhuma peca nova, nenhuma camada, e o
contorno poligonal do terreno preservado inteiro. O lobby caiu de 1.887 para 793
BaseParts. `tools/rebuild/08-LegoPlating.luau` foi apagado e substituido por
`08-LegoSurfacePass.luau`. O ladrilho do terraco do mercado, que era o ultimo tapete que
restava, tambem saiu, e o patio desceu 0.24 para se apoiar na laje de verdade.

**Como a auditoria confere:** contar faces com `Studs` cuja normal NAO aponta para cima.
O esperado e zero. Essa contagem e o que teria denunciado o erro original no mesmo dia.

**Nao verificado:** as 33 faces nessa condicao dentro de `Information` nao foram
corrigidas. Sao superficies padrao do Roblox e outro agente estava editando aquela pasta
no momento.

---

# Decisoes pendentes

Nenhuma destas tem resposta ainda. Elas estao aqui para nao virarem improviso.

## D-P01: como o lobby e reconstruido, codigo ou modelo versionado

**Bloqueia:** fase 2.
**Opcoes:** mapa inteiro gerado por codigo, como no Promote Me. Ou kit modular montado no
Studio e versionado como modelo. Ou hibrido, com layout por codigo e pecas por modelo.
**Por que importa:** define se o lobby pode ser regenerado, como o merge funciona e quanto
trabalho manual cada iteracao custa.

## D-P02: qual place do Roblox e o Crumble Arena

**Estado:** RESOLVIDA na sessao 003, ver D-013. Caminho canonico
`CrumbleArena\CrumbleArena.rbxl`, verificado com 1631 instancias e 1292 pecas. Continua
aberta apenas a decisao de publicar ou nao, que e outra questao e pertence a fase 7.

## D-P03: tamanho da celula da grade, em studs

**Estado:** resolvida na pratica para o terreno, 24 studs, ver D-010. Continua em aberto
para o kit modular de arte da fase 2, que pode querer submultiplos de 24, por exemplo 12
ou 8, para pecas menores.

## D-P04: resistencia e estagios de dano de cada material

**Bloqueia:** fase 4.
**Por que importa:** e o balanceamento central do jogo. Nenhum numero foi inventado, e
`BlockDefinition` em `src/shared/Types` define apenas o formato.

## D-P05: alcance, cooldown e recarga de cada ferramenta

**Bloqueia:** fase 5.
**Por que importa:** define o teto de habilidade e a taxa de destruicao da arena.

## D-P06: duracao de intermissao, preparacao e round

**Bloqueia:** fase 6.

## D-P07: o modelo de camera

**Bloqueia:** fase 1 parcialmente, fase 5 totalmente.
**Por que importa:** quebrar bloco no chao com camera em terceira pessoa padrao pode ser
desconfortavel. Precisa de teste com o corpo, nao de decisao no papel.

## D-P08: nome do estudio

**Bloqueia:** publicacao.
**Estado:** `StudioName: TBD`. Nao inventar.
