# Memoria do projeto

Fonte canonica das regras permanentes do Crumble Arena. O que esta aqui vale entre
sessoes e nao se muda em silencio. Decisao nova revoga decisao antiga por escrito, em
`DECISIONS.md`, e depois se reflete aqui.

Consolidado em 2026-09-04, na sessao 004, a partir de `CRUMBLE-ARENA-MASTER-PLAN.md`,
`TECHNICAL-ARCHITECTURE.md`, `LOBBY-SPEC.md`, `LOBBY-BUILD-PARAMS.md`,
`ASSET-INVENTORY.md`, `DECISIONS.md` e `SESSION-LOG.md`.

---

## 1. Visao

Ate 8 jogadores em uma arena de blocos destrutiveis. Voce quebra o chao sob os pes dos
outros. Quem cair, sai. Quem sobrar, ganha o round.

Frase mental: o chao e a arma.

Crumble Arena e o primeiro titulo do estudio, cujo nome ainda e `TBD` e nao deve ser
inventado. Alem de ser um jogo, ele existe para provar a base de producao que os proximos
jogos vao reaproveitar. Reaproveitamento e componente e sistema, nunca conteudo.

### Pilares

| Pilar | O que significa na pratica |
| --- | --- |
| P1, o chao e a arma | a decisao boa e escolher qual bloco quebrar, nao mirar melhor |
| P2, leitura imediata | cinco segundos para entender a cena. Nunca informacao so por cor |
| P3, partida curta | perder custa pouco tempo, arriscar e barato |
| P4, funciona no celular | projetado para dedo e tela pequena, nao adaptado depois |

Funcionalidade que nao reforca nenhum pilar fica de fora e vira ideia recusada em
`DECISIONS.md`.

---

## 2. Direcao visual

Low poly, cartoon, colorido, limpo, legivel, original e coerente. Formas grandes com boa
silhueta. Mundo de brinquedo construido por pecas.

Vocabulario de material: grama, terra, pedra, gelo, madeira. Fragmentos flutuantes,
rachaduras, blocos soltos na borda.

Studs classicos do Roblox aplicados de forma seletiva: superficies de grama, plataformas,
fragmentos flutuantes, pecas da praca, elementos de Coming Soon. Nunca em tudo.

### Proibido de forma explicita

- realismo, branco estourado, bloom alto, luz chapada, sombra preta
- verde neon, gelo sem detalhe, ceu vazio
- lobby inteiro em material `Plastic`
- aparencia de mapa montado com modelos aleatorios de pacotes diferentes
- copiar LEGO, Minecraft ou Fall Guys
- nome, asset, textura, mapa, interface, som ou marca de terceiro

### Teste de coerencia

Se um objeto do lobby nao caberia visualmente dentro de uma partida, ele esta errado.

### Paleta aprovada

Registrada com valores exatos em `LOBBY-BUILD-PARAMS.md`, secao Paleta. Resumo: grama
verde media, terra ocre, pedra em dois tons de cinza, gelo ciano com transparencia 0.15,
madeira em dois marrons, roxo premium para monetizacao, amarelo de destaque, vermelho
apenas em alvo e alerta.

---

## 3. Regras de seguranca

### Do repositorio

- modificar apenas `Desktop\CrumbleArena`
- `PromoteMe`, `SkillLab` e `backups\` sao somente leitura
- nao apagar arquivo anterior, nao fazer `git reset`
- commit, push e publicacao dependem de autorizacao explicita por escrito
- `legacy/` nao entra no build, nao e formatado e nao e linted. Existe para ser lido

### De asset

Nenhum asset entra sem origem, criador, Asset ID e licenca registrados em
`ASSET-INVENTORY.md`. Todo asset importado passa por inspecao de descendentes antes do
uso, procurando `Script`, `LocalScript`, `ModuleScript`, `RemoteEvent`, `RemoteFunction`,
`BindableEvent`, `BindableFunction`, `Tool`, `ClickDetector`, `ProximityPrompt`, `Sound`,
`SurfaceGui`, `BillboardGui` e `Decal`. Qualquer ocorrencia e removida antes do uso.

Asset sem licenca verificada e marcado `UNVERIFIED` e nao entra no jogo.

Prioridade de origem, nesta ordem:

1. inventario da conta do usuario, pacotes KayKit ja auditados
2. pacotes Kenney do acervo SkillLab, todos CC0 com licenca arquivada
3. geometria autoral com `Part`
4. Creator Store publico, ultimo recurso, so com criador verificado e licenca declarada

A busca por termos genericos no Creator Store ja foi feita e reprovada, ver D-012 e a
secao 8 de `ASSET-INVENTORY.md`. Nao repetir sem motivo novo.

### De codigo

Servidor autoritativo. Cliente pede, servidor decide, sem excecao. Cliente nunca cria
remote. Todo remote tem validador de formato e rate limit. Detalhe em
`TECHNICAL-ARCHITECTURE.md`.

---

## 4. Organizacao tecnica

### No Studio

```text
Workspace
  CrumbleArena
    Lobby
      Island            Base, Cliffs, Paths, Borders, FloatingFragments
      CentralPlaza      Floor, Decorations, Spawn
      Areas             uma pasta por area
      Props             Rocks, Vegetation, Furniture, Ice
      Safety            InvisibleBarriers, FallZone
      ImportedAssets    biblioteca de referencia estacionada em Y = -600, sem colisao

ServerStorage
  DeferredLobbyAreas    areas preservadas fora do lobby ativo

SoundService
  LobbyMusic
  SFX

StarterGui
  CrumbleUI

StarterPlayer
  StarterPlayerScripts
    UIController

ReplicatedStorage
  CrumbleArena
    UI
      UIConfig
      MockData
```

Nenhum objeto importante com nome generico. Toda peca ancorada.

### No repositorio

```text
src/shared/Config/       numeros de balanceamento, um lugar so
src/shared/Types/        contratos de tipo, sem logica
src/shared/Util/         funcoes puras
src/server/Services/     autoridade de longa duracao
src/server/Systems/      simulacao chamada pelos services
src/client/Controllers/  intencao e entrada
src/client/UI/           composicao de tela
src/client/Effects/      particula, som, camera
```

`Config` e `Types` nao usam `game`, `workspace`, `Instance`, `task` nem `require`. E isso
que permite carrega-los no Lune. Quebrar essa regra quebra os testes.

---

## 5. Padroes de UI

Construida com componentes nativos, nunca uma imagem unica ocupando a tela inteira:
`ScreenGui`, `Frame`, `TextLabel`, `TextButton`, `ImageLabel`, `UIStroke`, `UICorner`,
`UIGradient`, `UIPadding`, `UIListLayout`, `UIScale` e constraints.

Direcao: contorno grosso, canto arredondado, sombra em camadas, azul marinho escuro,
verde, ciano, amarelo, roxo premium, vermelho apenas em alerta. Forma tatil, rachadura
discreta, texto grande.

Evitar: glassmorphism, neon, interface futurista, painel preto generico, fonte fina, botao
de template, excesso de gradiente.

Layout nunca so em `Offset`. Testar em 1920x1080, 1366x768, 1280x720, proporcao de iPhone
15 e tela mobile pequena, verificando safe area, texto cortado, botao pequeno, painel fora
da tela, sobreposicao com os controles do Roblox e leitura no toque.

Um unico tema do Kenney UI Pack, escolhido antes da fase 3, e os outros descartados.
Nunca misturar dois temas de UI no mesmo jogo.

---

## 6. Padroes de documentacao

- documentacao e relatorio em portugues, codigo e identificador em ingles
- sem travessao longo em nenhum documento
- escrita humana e objetiva, sem texto generico com cara de IA
- vocabulario obrigatorio de estado: implementado, testado, parcialmente testado,
  planejado. Nunca apresentar planejado como concluido
- evidencia antes de afirmar que algo foi testado
- `DECISIONS.md` registra contexto, escolha, motivo e consequencia
- `SESSION-LOG.md` registra uma entrada por sessao
- `CURRENT-STATE.md` e atualizado ao fim de cada marco

---

## 7. Restricoes do projeto

### De escopo

Nao implementar, ate a fase 6: DataStore, loja real, gamepass real, `MarketplaceService`,
produto, missao, analytics, votacao real, sistema de moedas, round system, matchmaking e
teleporte.

Nao criar modulo vazio para aparentar arquitetura. Nao criar codigo complexo antes de
existir necessidade real. Comentario apenas para decisao nao obvia.

Nao construir a segunda arena antes da primeira estar divertida.

### De desempenho

Prioridade de compatibilidade: computador e celular. Textura de gameplay em 256, 512 ou
1024, nunca 4K. Maximo de 20.000 triangulos por mesh, e bem abaixo disso em objeto
repetido. Audio nao e pre-carregado em catalogo inteiro. Bloco destruido nao vira debris
fisico persistente.

O orcamento de partes ainda nao foi medido em celular real. E criterio de aceite da fase
4 e continua sendo o risco central do projeto, R-003.

### De processo

- mudanca pequena e verificavel, nunca um bloco grande sem checagem
- nenhuma acao destrutiva
- nao pedir autorizacao para ajuste pequeno e reversivel
- pedir autorizacao para compra, publicacao, exclusao definitiva, mudanca de escopo e
  decisao de produto
- salvar a mao com `Ctrl + S` ao fim de cada bloco de construcao. Nunca confiar na
  recuperacao automatica do Studio. Ver sessao 003 no `SESSION-LOG.md`

---

## 8. Decisoes aprovadas que mais afetam o dia a dia

| Id | Decisao |
| --- | --- |
| D-008 | o lobby nao tem portal de entrada em partida. O servidor decide o momento |
| D-009 | o cronometro nao vai no painel fisico. Painel e so comunidade e evento |
| D-010 | a ilha e grade de blocos de 24 studs, nao malha suave |
| D-011 | uma celula entra na camada quando encosta no disco do raio, nao pelo centro |
| D-012 | asset so entra vindo do inventario do usuario ou do acervo auditado |
| D-013 | o place canonico e `CrumbleArena\CrumbleArena.rbxl` |

Decisoes ainda em aberto, que nao devem virar improviso: D-P01 reconstrucao do lobby,
D-P03 celula do kit modular, D-P04 resistencia de material, D-P05 numeros de ferramenta,
D-P06 duracao de round, D-P07 modelo de camera, D-P08 nome do estudio.

Risco aberto de arte: R-001, nenhum pacote tem bloco de gelo. O gelo do lobby e autoral,
`Part` em ciano com transparencia 0.15.

---

## 9. Fatos operacionais da ponte MCP

Coisas que ja custaram tempo e nao sao obvias. Comprovadas nesta maquina.

| Fato | Detalhe |
| --- | --- |
| Nao existe salvamento por codigo | `game:Save()` nao existe no sandbox. `Ctrl + S` e humano |
| O `studio_id` muda a cada abertura do Studio | listar as instancias antes de qualquer chamada |
| `TextScaled = true` nao persistiu por `execute_luau` | a propriedade voltava a `false` na leitura seguinte. Usar `TextSize` explicito, que e deterministico e persiste |
| `RenderStepped` mede errado durante chamada MCP | a janela do Studio perde o foco e a renderizacao e limitada. Deu 14.9 contra 60.0 reais. Medir desempenho por `Heartbeat` e `workspace:GetRealPhysicsFPS()` |
| Raycast que comeca dentro de uma peca nao a detecta | um raio saindo da base de um prop atravessa a grama e acerta a face de baixo, 6 studs abaixo. Isso gera falso positivo de peca enterrada. Comecar o raio acima da superficie, ou filtrar por `Include` contra as pecas de chao |
| `NormalId.Front` e a face `-Z` | e a mesma direcao de `CFrame.LookVector`. Uma placa montada com `CFrame.lookAt(pos, pos + direcaoDeLeitura)` fica correta com `Face = Front` |

---

## 10. Persistencia do place, regra dura

O Studio ja perdeu trabalho duas vezes neste projeto, nas sessoes 003 e 007. As duas vezes
a recuperacao automatica salvou. Nenhuma das duas foi processo, as duas foram sorte.

### Onde fica a recuperacao automatica

```text
C:\Users\ricka\AppData\Local\Roblox\RobloxStudio\AutoSaves\
```

**Nao e** `AppData\Local\Roblox\AutoSaves`. Esse caminho nao existe, e procurar nele leva
a concluir que nao ha recuperacao quando ha.

### Ordem obrigatoria numa recuperacao

1. Copiar o arquivo de recuperacao para `backups\` **antes de abrir o Studio**. O Roblox
   descarta esses arquivos na proxima abertura.
2. Conferir a copia por SHA-256 contra a origem.
3. Comparar marcadores no binario contra o ultimo save bom, para saber o que a recuperacao
   tem a mais. Marcador que aparece prova presenca. Marcador que nao aparece nao prova
   ausencia, porque o formato comprime parte das strings.
4. Preservar o save antigo em `backups\` antes de sobrescrever o caminho canonico.
5. So entao restaurar.

### O que reduz o dano de verdade

Codigo versionado em `src/`, e script de reconstrucao em `tools/rebuild/`. Ver D-017 e
D-018. Salvar com mais frequencia trata sintoma, nao causa.
