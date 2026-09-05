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
