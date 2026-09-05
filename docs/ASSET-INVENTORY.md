# Inventario de assets

Estado: inventario preliminar. Nenhum asset foi importado para o Roblox. Nenhum arquivo
foi copiado para este repositorio.

Este documento cobre apenas os assets relevantes para o Crumble Arena. O acervo completo,
com 77 pacotes catalogados e 21 ingeridos, vive no SkillLab, em
`Desktop\PromoteMe\skilllab\toolbox\`, e continua sendo a fonte de verdade. O SkillLab nao
foi movido, alterado nem duplicado nesta sessao.

## 1. Auditoria de seguranca executada

Comando executado sobre os 541 MB extraidos do acervo, procurando script ou executavel
escondido dentro dos pacotes:

```bash
find . -type f \( -iname '*.lua' -o -iname '*.luau' -o -iname '*.rbxm' \
  -o -iname '*.rbxmx' -o -iname '*.rbxl' -o -iname '*.exe' -o -iname '*.dll' \
  -o -iname '*.bat' -o -iname '*.ps1' -o -iname '*.sh' -o -iname '*.js' \)
```

Resultado: nenhuma ocorrencia. Os pacotes sao arquivos de arte pura, distribuidos como
`gltf`, `glb`, `fbx`, `obj`, `png`, `svg` e `ogg`. Nao existe modelo do Creator Store no
acervo, entao nao existe o risco classico de script ativo dentro de modelo inserido.

Isso nao dispensa a auditoria por modelo no momento da importacao. Dispensa apenas a
suspeita sobre a origem do arquivo.

## 2. Licenca

Os 21 pacotes ingeridos sao CC0, com `licenca_status = Verificada` no registro e prova
arquivada em `skilllab/toolbox/licenses/<asset_key>/`. Uso comercial permitido, credito
nao obrigatorio.

Verificacao independente feita nesta sessao, lendo o arquivo de licenca de dentro do
proprio pacote e nao apenas a planilha:

```text
skilllab/toolbox/raw/3d/block-bits/extracted/KayKit_BlockBits_1.0_FREE/License.txt
  KayKit : Block Bits (1.0)
  Created/distributed by Kay Lousberg
  License: (Creative Commons Zero, CC0)
```

Nenhum asset relevante ficou marcado `UNVERIFIED`.

## 3. Assets relevantes, por categoria

Aprovado quer dizer: licenca verificada e utilidade confirmada para o Crumble Arena. Nao
quer dizer importado.

### Blocks

| Pacote | Criador | O que serve | Status |
| --- | --- | --- | --- |
| Block Bits | Kay Lousberg | `dirt`, `dirt_with_grass`, `grass`, `stone`, `stone_dark`, `gravel`, `snow`, `glass`, `water` e variantes com neve, 40 modelos | Aprovado |

Este e o achado mais importante do inventario. Block Bits cobre diretamente 3 dos 4
materiais previstos: Terra, Grama e Pedra. Nao existe um bloco de gelo explicito, e
`glass` e `snow` sao aproximacoes. O Gelo provavelmente sera autoral, ver risco no
SESSION-LOG.

### Terrain e Lobby

| Pacote | Criador | O que serve | Status |
| --- | --- | --- | --- |
| Prototype Bits | Kay Lousberg | `Primitive_Floor`, `Primitive_Wall`, `Primitive_Slope`, `Primitive_Stairs`, `Pillar`, 72 modelos de greybox | Aprovado, uso na fase 1 |
| Platformer Pack | Kay Lousberg | `platform_*` em 1x1x1 ate 6x6x4, 4 cores, alem de terreno | Aprovado |
| City Builder Bits | Kay Lousberg | volumes de cenario para os espacos reservados | Condicional, so se couber na direcao visual |

Prototype Bits e o pacote da fase 1. Ele existe justamente para greybox e evita modelar
qualquer coisa antes da escala estar decidida.

### Vegetation

| Pacote | Criador | O que serve | Status |
| --- | --- | --- | --- |
| Forest Nature Pack | Kay Lousberg | `Bush_*`, `Grass_*`, `Rock_*`, 105 modelos, com variantes single sided | Aprovado, uso na fase 2 |

As variantes `Singlesided` importam para mobile, porque cortam metade dos triangulos em
folhagem.

### Tools

| Pacote | Criador | O que serve | Status |
| --- | --- | --- | --- |
| RPG Tools | Kay Lousberg | `pickaxe` e `shovel`, mais 47 outras ferramentas | Aprovado, uso na fase 5 |

Segundo achado importante: as duas ferramentas de contato previstas existem prontas e no
mesmo estilo dos blocos. A bola de neve nao existe e e trivial de fazer.

### Characters e Animations

| Pacote | Criador | O que serve | Status |
| --- | --- | --- | --- |
| Adventurers | Kay Lousberg | 39 modelos de personagem | Condicional, depende de decidir se o jogo usa avatar Roblox ou personagem proprio |
| Character Animations | Kay Lousberg | 16 animacoes | Condicional, mesma dependencia |

Nao usar antes de decidir a questao do avatar. Personagem proprio em jogo Roblox custa
caro em identidade e em compatibilidade com o que o jogador ja possui.

### UI

| Pacote | Criador | O que serve | Status |
| --- | --- | --- | --- |
| UI Pack | Kenney | 870 elementos de interface | Aprovado, com ressalva |
| Input Prompts | Kenney | 3056 icones de tecla, botao e gesto, cobrindo teclado, gamepad e toque | Aprovado |

Ressalva: nunca misturar dois temas de UI no mesmo jogo. Escolher um tema do UI Pack e
descartar os outros antes de comecar a fase 3.

Input Prompts resolve o requisito de suporte a mouse, teclado, toque e gamepad no nivel
visual, sem desenhar icone nenhum.

### VFX

| Pacote | Criador | O que serve | Status |
| --- | --- | --- | --- |
| Particle Pack | Kenney | 193 texturas de particula | Aprovado |
| Smoke Particles | Kenney | 79 texturas de fumaca e poeira | Aprovado, uso na quebra de bloco |

### Audio

| Pacote | Criador | Arquivos | O que serve | Status |
| --- | --- | --- | --- | --- |
| Impact Sounds | Kenney | 130 ogg | quebra e impacto de bloco | Aprovado |
| Interface Sounds | Kenney | 100 ogg | interface | Aprovado |
| UI Audio | Kenney | 52 ogg | interface | Aprovado |
| Music Jingles | Kenney | 86 ogg | vitoria, derrota, contagem | Aprovado |

### Texture

| Pacote | Criador | O que serve | Status |
| --- | --- | --- | --- |
| Skyboxes | Kenney | 8 ceus | Aprovado, uso na fase 2 |

## 4. Fora do escopo

Restaurant Bits, Dungeon Remastered e Board Game Bits estao ingeridos e sao CC0, mas nao
tem relacao com o Crumble Arena. Nao inventariar, nao importar.

## 5. Regras de uso

1. Nao copiar pacote inteiro para este repositorio. Importar apenas o subconjunto que a
   fase atual precisa.
2. Toda importacao registra origem, licenca e data neste documento.
3. Textura de gameplay em 256, 512 ou 1024. Nunca 4K.
4. Maximo de 20.000 triangulos por mesh, e bem abaixo disso em objeto repetido, que e o
   caso de todo bloco da arena.
5. Nao pre-carregar catalogo inteiro de audio ou textura.
6. Asset sem licenca verificada e marcado `UNVERIFIED` e nao entra no jogo.

## 6. O que ainda falta

- decidir avatar do jogador, o que libera ou descarta Adventurers e Character Animations
- resolver o bloco de Gelo, que nenhum pacote cobre bem
- escolher um unico tema do Kenney UI Pack
- definir o pipeline de importacao: `glb` direto pelo importador 3D do Studio, ou passagem
  por Blender para ajustar pivo e escala

## 7. Assets ja no Roblox, usados no lobby

Os cinco pacotes abaixo ja estavam no inventario da conta do usuario quando a sessao 002
comecou, subidos por `KittyPatife`, que e a propria conta. Todos correspondem a pacotes
KayKit CC0 com licenca verificada no registro do SkillLab. Foram inseridos em quarentena
em `Workspace.CrumbleArena.Lobby.ImportedAssets` e auditados antes de qualquer uso.

| Nome no inventario | Asset ID | Pacote de origem | Licenca | Scripts encontrados | Status |
| --- | --- | --- | --- | --- | --- |
| block-bits | 99205119436068 | KayKit Block Bits 1.0 FREE | CC0 verificada | nenhum | usado |
| forest-nature-pack | 111025409160294 | KayKit Forest Nature Pack | CC0 verificada | nenhum | usado |
| prototype-bits | 78867862192359 | KayKit Prototype Bits | CC0 verificada | nenhum | usado |
| platformer-pack | 140612564742843 | KayKit Platformer Pack | CC0 verificada | nenhum | nao inserido |
| board-game-bits | 97315101901186 | KayKit Board Game Bits | CC0 verificada | nenhum | fora de escopo |

Auditoria executada sobre os tres pacotes inseridos: `LuaSourceContainer`, `RemoteEvent`,
`RemoteFunction`, `BindableEvent`, `BindableFunction`, `Tool`, `ClickDetector`,
`ProximityPrompt`, `Sound`, `SurfaceGui`, `BillboardGui` e `Decal`. Resultado: nenhuma
ocorrencia em nenhum dos tres. Nenhum script foi executado, porque nao havia nenhum.

### Malhas disponiveis na biblioteca

16 no total, das quais 8 estao em uso no lobby.

| Malha | MeshId | Tamanho original | Uso no lobby | Quantidade |
| --- | --- | --- | --- | --- |
| block_dirt_grass | 131933135394775 | 5.4 x 5.1 x 5.4 | fileira de terra do treino e blocos soltos | 8 |
| block_stone | 79212874966350 | 5.1 x 5.1 x 5.1 | fileira de pedra do treino e blocos soltos | 8 |
| forest_tree_1 | 107298216323952 | 8.0 x 10.4 x 8.1 | arvores do gramado e da area social | 12 |
| forest_bush_1 | 120362304717138 | 0.7 x 0.6 x 0.6 | arbustos | 24 |
| forest_grass_1 | 91291478360434 | 0.8 x 1.4 x 0.4 | tufos de grama | 34 |
| forest_rock_1 | 117365476866296 | 1.4 x 1.4 x 1.5 | rochas do cenario | 34 |
| proto_box | 71764690630135 | 1.1 x 1.3 x 1.2 | caixas | 3 |
| proto_barrel | 117416911463463 | 2.5 x 2.5 x 2.5 | barris | 3 |

Nao usadas por enquanto: `forest_tree_bare`, `proto_cube`, `proto_doorway`, `proto_floor`,
`proto_pillar`, `proto_slope`, `proto_stairs`, `proto_wall`.

`forest_tree_bare` foi testada e descartada: a textura alaranjada dela briga com a paleta
do lobby. Trocada por `forest_tree_1`.

## 8. Assets recusados na busca do Creator Store

A busca por termos genericos foi feita e os resultados foram descartados por origem.

| Termo buscado | Escopo | Resultados | Decisao |
| --- | --- | --- | --- |
| low poly rock | inventario e Creator Store | 8, todos do inventario | usado `forest_rock_1` |
| low poly tree | Creator Store, so gratuitos | 8 de 8 criadores nao verificados | todos recusados |
| bits | inventario | 3 pacotes KayKit | aprovados |
| kaykit | inventario | 0 | sem acao |
| (vazio, tipo Model) | inventario | 20, sendo 5 pacotes nomeados | os 5 aprovados |

Motivo da recusa dos 8 resultados de "low poly tree": nenhum declara licenca, nenhum vem
de criador verificado, e um deles traz na descricao uma disputa de autoria explicita. A
regra do projeto diz para nao confiar num modelo so porque ele aparece na Creator Store, e
para recriar a forma com `Part` quando a origem for duvidosa. Foi o que se fez.

## 9. Conferencia dos meshes direto no arquivo do place, 2026-09-04

Tabela extraida do proprio `CrumbleArena.rbxl` com Lune, lendo `MeshContent` de cada
`MeshPart`. Isto nao e o registro do que foi inserido, e a leitura do que esta la dentro.
136 `MeshPart` no place, 16 Asset IDs distintos, todos dos tres pacotes KayKit do
inventario do usuario. Nenhum mesh de origem desconhecida.

| Asset ID | Usos | Pacote | Onde aparece |
| --- | --- | --- | --- |
| `117365476866296` | 33 | forest-nature-pack | Props.Rocks |
| `91291478360434` | 32 | forest-nature-pack | Props.Vegetation, tufos de grama |
| `120362304717138` | 25 | forest-nature-pack | Props.Vegetation, arbustos |
| `107298216323952` | 13 | forest-nature-pack | Props.Vegetation e SocialArea, arvores |
| `131933135394775` | 9 | block-bits | Training.Row_Dirt, Props.Rocks, blocos soltos |
| `79212874966350` | 8 | block-bits | Training.Row_Stone, Props.Rocks |
| `117416911463463` | 4 | prototype-bits | Props.Furniture, barris |
| `71764690630135` | 4 | prototype-bits | Props.Furniture, caixas |
| `108472452276348` | 1 | forest-nature-pack | so na biblioteca, arvore seca recusada |
| `137832735496930` | 1 | prototype-bits | so na biblioteca |
| `100038592997306` | 1 | prototype-bits | so na biblioteca |
| `107963103431674` | 1 | prototype-bits | so na biblioteca |
| `72909959660459` | 1 | prototype-bits | so na biblioteca |
| `71063822030726` | 1 | prototype-bits | so na biblioteca |
| `115282646926607` | 1 | prototype-bits | so na biblioteca |
| `103830004998329` | 1 | prototype-bits | so na biblioteca |

Oito IDs estao em uso no lobby e oito ficam apenas em `ImportedAssets`, a biblioteca de
referencia estacionada em Y = -600 com `CanCollide` desligado. Confirma a regra 17: uma
biblioteca pequena, reutilizada com rotacao, escala e cor variadas, em vez de dezenas de
modelos diferentes.

Confirmado tambem na mesma leitura: 0 `Script`, 0 `LocalScript`, 0 `ModuleScript`,
0 `RemoteEvent`, 0 `RemoteFunction` em todo o place. Nenhum mesh de gelo existe em nenhum
pacote, o que mantem o risco R-001 aberto.

## 10. Assets inseridos pelo Rick, sessoes 004 e 005

O Rick inseriu estes modelos direto no Studio. Eles foram auditados, sanitizados e
integrados. Nenhum script sobreviveu a integracao.

| Objeto | Onde vive hoje | Descendentes | Situacao |
| --- | --- | --- | --- |
| Fonte low poly | `CentralPlaza.CentralFountain` | 88 | usada no centro da praca |
| Fogueira | `Areas.SocialArea.CreatorStore_Campfire_User` | 23 | usada, com `Fire` e `PointLight` nativos |
| Placar de tempo jogado | `Areas.Leaderboard.PlaytimeLeaderboardDisplay` | 369 | usado, com rig de avatar do primeiro lugar |
| Placar de dinheiro | recusado | - | trazia Cash, DataStore e peca que dava dinheiro ao toque |

Malhas por objeto, lidas do proprio place:

- Fonte: `1173507765` x12, `5003626535` x8, `6525035869`, `6525035974`, `6525036056`
- Fogueira: `1513214717` x7, `1543660454` x5, `1543161754` x4, `1543157440` x2
- Placar: 28 ids distintos, entre eles a familia `3255184662` a `3255189295` e a serie
  `12994951501` a `12994951566`

O placar de dinheiro foi recusado por trazer sistema de economia que nao pertence a este
projeto e contraria o limite de escopo do plano mestre, que proibe DataStore e moeda ate a
fase 6. O placar de tempo jogado foi escolhido no lugar dele porque e o que suporta exibir
o avatar do primeiro colocado, que era o ponto que o Rick achou interessante. Os scripts
dele foram removidos, entao o painel esta preparado visualmente e nao tem ranking real por
tras.

### Registro de auditoria dentro do place

`Workspace.CrumbleArena.Lobby.ImportedAssets.AssetAuditRecords` guarda um marcador por
decisao de asset. Cada marcador e uma Folder vazia cujo conteudo esta no nome e nos
atributos `Situacao`, `RestauradoEm` e `Observacao`.

| Marcador | Situacao |
| --- | --- |
| `Approved_PlatformerPack` | aprovado |
| `Approved_StylizedRockPack` | aprovado |
| `Approved_ShinyTrophy` | aprovado |
| `Approved_BoardGameBits` | aprovado |
| `Approved_CardboardTarget` | aprovado |
| `CreatorStoreCampfire_CP3` | importado e sanitizado |
| `UserCampfire_CP4` | importado e sanitizado |
| `UserFountain_CP4` | importado e sanitizado |
| `UserPlaytimeLeaderboard_CP4` | importado e sanitizado |
| `RejectedCashLeaderboard_CP4` | recusado |
| `RejectedSearchResults.Rejected_RealisticGrass` | recusado na busca |
| `RejectedSearchResults.Rejected_GiverV` | recusado na busca |
| `RejectedSearchResults.Rejected_BrainrotsFlags` | recusado na busca |

**Estas pastas sao registro, nao lixo.** Elas sao vazias de proposito. Uma limpeza
automatica de pastas vazias na sessao 005 apagou as 14 e elas tiveram que ser recriadas.
A pasta pai carrega o atributo `Proposito` avisando disso.

### Nota sobre os pacotes do inventario

Os cinco pacotes KayKit que aparecem no inventario da conta sao **amostras**, nao os
pacotes completos. Medido na sessao 004: `forest-nature-pack` tem 5 malhas, nao 105.
`platformer-pack` tem 8, `block-bits` 3, `prototype-bits` 10 e `board-game-bits` 1. A
biblioteca util no Roblox e de 25 malhas distintas, e nao das centenas que os pacotes
originais contem no acervo SkillLab. Subir o resto exige importacao manual pelo Studio,
porque nao existe caminho por codigo, conforme ja registrado no SkillLab.
