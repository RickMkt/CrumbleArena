# Pacotes de asset trazidos pelo Rick, 2026-09-07

## Curadoria visual posterior, Astra

`Workspace.CrumbleArena.AssetStaging.CuratedLobbyAssets` guarda12 candidatos visuais:
Orze55_BarrilA,57_Caixote,54_Banco,56_Lanterna e21_LeaderboardB;
HapyLowPoly05_3WoodLog,08_GrassPart,09_GroundRock,10_Rock,04_Tree e03_Fence;
Arbuzowski30_Sign_01. Sao clones de exposicao, sanitizados, sem colisao, e nao sao
conteudo ativo nem aprovacao de producao. O catalogo original foi preservado inteiro.
Cada clone indica origem, uso recomendado e `ProductionApproved=false`.
Reconstrutor: `tools/rebuild/25-CurateLobbyAssets.luau`, aplicar apenas uma vez.

## Selecao visual posterior do Rick

As12 capturas do usuario foram convertidas em `AssetStaging.UserSelectedAssets`:
24 modelos expostos e a cachoeira Hapy referenciada como item25. O conjunto inclui
picareta, caixote, duas familias de pedra, Arvore B, poste/lanternas, duas bandeiras,
moeda, arbusto e arvores Hapy, borda modular, cerca, pinheiro, lenha, terreno baixo,
tufo e pedras de chao. Isto registra preferencia visual, nao licenca ou aprovacao de
producao. O catalogo integral e a shortlist Astra continuam intactos.
Reconstrutor: `tools/rebuild/26-UserSelectedLobbyAssets.luau`, aplicar uma vez.

Nota para o Codex. O Rick entregou dois arquivos e um link do Drive. Este documento diz o
que tem dentro deles, o que e seguro, o que serve para o Crumble Arena e onde as coisas
foram parar. Leia antes de usar qualquer coisa daqui.

Os dois arquivos foram lidos **de fora do Studio**, com `lune` e a biblioteca
`@lune/roblox`, porque sao binarios com os chunks comprimidos em LZ4: nem o `strings` nem o
Luau de dentro do Studio conseguem le-los. O script de inventario esta no scratchpad da
sessao e pode ser refeito com `lune run inventario.luau <caminho>`.

---

## 1. Orze_Asset_Pack.rbxm

```text
caminho   C:\Users\ricka\Downloads\Orze_Asset_Pack.rbxm
tamanho   2.282.394 bytes
data      2026-09-07 12:52
raiz      AssetPack [Folder], 1538 descendentes
```

### Composicao

| Classe | Quantidade |
| --- | --- |
| MeshPart | 1187 |
| Model | 192 |
| Part | 91 |
| PointLight | 22 |
| Attachment | 17 |
| Beam | 10 |
| ParticleEmitter | 6 |
| WeldConstraint | 5 |
| SurfaceAppearance | 4 |
| Script | 2 |

Total: 1539 instancias, em **75 entradas de topo**.

### Auditoria de risco

| Item | Resultado |
| --- | --- |
| `RemoteEvent` / `RemoteFunction` / `BindableEvent` | **0** |
| `Sound` | **0** |
| `Decal` / `Texture` | **0** |
| `HttpService`, `require` de id externo, `getfenv` | **nenhum** |
| `Script` | **2**, ambos lidos por inteiro |

Os dois scripts sao animacao decorativa e nada mais:

```lua
-- script 1, em AssetPack.Model.Model.Part
while true do
    script.Parent.CFrame = script.Parent.CFrame * CFrame.fromEulerAnglesXYZ(-0.01,0,0)
    wait(0.01)
end

-- script 2, em AssetPack.Model.Model.Part
while true do
    wait()
    for i = 1, 50 do script.Parent.CFrame = script.Parent.CFrame * CFrame.new(0,-0.05,0) wait() end
    for i = 1, 50 do script.Parent.CFrame = script.Parent.CFrame * CFrame.new(0,0.05,0) wait() end
end
end
```

Um gira uma peca, o outro faz sobe e desce. Sao inofensivos, mas **entram desabilitados**:
`while true do` com `wait()` em dois scripts por peca duplicada vira custo de runtime a toa,
e o lobby tem a regra de zero script ativo no mundo.

### O que tem dentro, por familia

Os `Model` de topo vieram todos com o nome literal `Model`, sem excecao. A classificacao
abaixo foi feita pelo nome das malhas dentro de cada um, que esse sim e descritivo.

| Familia | Onde aparece | Serve para o Crumble Arena? |
| --- | --- | --- |
| Arvore, tronco, palmeira | `Tree`, `trunk`, `1palm`, `Palm22` | **sim**, Phase 6 de vegetacao |
| Cogumelo | `mushroom`, 12 malhas | sim, pontual |
| Flor | `2flowers`, aparece em 11 modelos | sim, com moderacao |
| Abelha | `2Bees`, 7 entradas | provavelmente nao, tema nao bate |
| Barril, caixote | `1Barrel`, `Crate2` | **sim**, Market e SocialArea |
| Lanterna | `Lantern`, 10 malhas | **sim**, Phase 9 |
| Banco | `bench`, 10 malhas | **sim**, SocialArea |
| Bau | `CoolChest`, 4 entradas ate 66 malhas | sim, Market |
| Picareta | `Pickaxe`, 4 variacoes | **sim**, e ferramenta de quebrar, bate com o tema |
| Fonte, poco | `1fountain` (96 malhas, 8 Beams), `well` | talvez, a fonte ja foi aposentada uma vez |
| Placar | `Leaderboards2`, `1leaderboard`, `1Lb`, `top3`, `one`/`two`/`three`, `numbersign` | **sim**, Information Area |
| Portal | `portalaa`, `portal test` | **nao**, a D-008 diz que o lobby nao tem portal |
| Montanha | `mountain`, 5 entradas de 2 malhas | **sim**, ilhas de fundo, Phase 7 |
| Pedestal | `Stands`, 6 malhas e 6 parts | sim, Information |
| Ovo, capsula | `1Egg`, `1CapsuleEgg`, `egg` | nao, e linguagem de simulator |
| Moeda, icone | `Currency` (107 malhas num modelo), `Icons` | talvez, so se virar economia |
| Doce, chocolate | `Candy`, `1chocolate` | nao |

**Destaques por peso:** o modelo 69 tem 118 malhas e 44 parts, o 4 tem 107 malhas so de
`Currency`, o 10 e a fonte com 96 malhas, 8 Beams, 2 ParticleEmitter e 1 PointLight. Sao
caros. Nao levar para o lobby ativo sem olhar contagem de peca.

---

## 2. Cryptic_Games_UI_Pack.rbxl

```text
caminho   C:\Users\ricka\Downloads\Cryptic_Games_UI_Pack.rbxl
tamanho   70.891 bytes
data      2026-09-07 12:51
autor     PraefetusLore, declarado no proprio pacote
versao    Update 1.1 / 05.04.2024
licenca   "completely free", declarado pelo autor no script READ
credito   os 120 icones sao do RHos Icon Pack, creditado pelo autor
```

**Isto e um place, nao um modelo, e nao tem uma unica malha.** Sao 424 instancias, todas de
interface, dentro de `StarterGui`. Nao entra em plataforma nenhuma do mapa: e biblioteca de
UI.

| Classe | Quantidade |
| --- | --- |
| UIAspectRatioConstraint | 132 |
| ImageLabel | 126 |
| Frame | 31 |
| UIStroke | 27 |
| UICorner | 24 |
| UIListLayout | 22 |
| UIGradient | 18 |
| TextButton | 12 |
| Script | 4 |

### Auditoria de risco

Os 4 scripts sao **somente comentario**, zero linha executavel. Sao o README do autor e os
tutoriais de cada secao. Risco nulo. Ainda assim nao precisam ir para o place: o conteudo
util deles esta transcrito aqui.

### Conteudo

| Tela | O que tem |
| --- | --- |
| `Buttons` | 3 conjuntos de estilo. S1 com 6 botoes, S2 e S3 com 3 cada, nas variantes Simulator, Shortcut e Realistic |
| `UI` | 2 conjuntos, cada um com `SimulatorFrame`, `Simulator2Frame` e `RealisticFrame` |
| `Other` | `ImageButton`, `TextBox`, `ViewportFrame`, `ScrollingFrame` e tres layouts prontos, dois `UIListLayout` e um `UIGridLayout` |
| `Images` | **120 ImageLabel**, o conjunto de icones |

Instrucao do autor, transcrita: a aparencia de cada botao vive num `Frame` dentro dele. O
arredondamento sai do `UICorner`, a cor do `Frame`, a forca do degrade do `UIGradient` e o
contorno preto do `UIStroke`. Tudo escalado para celular.

### Como isso se cruza com o que ja existe

A interface do lobby ja existe e e versionada, ver D-017: `src/client/UI/UIConfig.luau`,
`MockData.luau` e `Controllers/UIController.client.luau`. **Nao troque a interface atual por
esta.** O que este pacote resolve e outra coisa: e um banco de estilo de botao, de painel e
de icone para consultar quando a Phase de GUI chegar. Os 120 icones sao o item mais util,
porque hoje a interface nao tem nenhum.

---

## 3. Link do Google Drive

```text
https://drive.google.com/drive/folders/1ps9O_W_B3eo07NwqOI8KNFO9b-GVQ95g
```

**Nao foi aberto.** Pasta do Drive exige sessao autenticada e eu nao tenho. Se o conteudo
importar, o Rick precisa baixar e apontar o caminho local, que ai o mesmo processo de
inventario e auditoria se aplica.

---

## 4. Onde as coisas ficam no place

`ServerStorage.CrumbleArenaLibraries` ja e o lugar certo e ja tem estrutura, com o atributo
`Purpose = Approved audited asset libraries; not active map content`:

```text
CrumbleArenaLibraries
  ImportedAssets      pacotes ja auditados: block-bits, forest-nature-pack, prototype-bits
  Quarantine          260 pecas, 28 candidatos com o Asset ID no proprio nome
  A2AssetPreview      68 pecas, 23 modelos rotulados, com PreviewFloor
  RetiredBuilds       5 construcoes aposentadas
```

O problema que o Rick apontou e real: **isso tudo vive no ServerStorage, entao da para ver
no Explorer mas nao da para olhar no viewport**. Nao da para comparar escala lado a lado nem
andar entre os modelos. Por isso o catalogo esta sendo levado para o mundo.

---

## 5. Aviso sobre peso do ServerStorage

Enquanto inventariava, contei o ServerStorage inteiro: **8.381 BaseParts em 18 pastas de
rollback**. As maiores:

| Pasta | Pecas |
| --- | --- |
| LegoPlatingV3 | 1317 |
| AstraMarketPrecisionRollback | 1072 |
| MarketRefinementRollback_1121 | 1063 |
| AstraSocialReferenceRollback | 1038 |
| AstraUpdateRollback | 891 |
| AstraPhase1Takeover | 862 |
| AstraSocialRefinement_20260906 | 855 |

`LegoPlatingV3` e minha e e lixo confirmado: e a camada de placas que o Rick mandou
abandonar em 2026-09-06, substituida pela D-023. Pode apagar. As outras sao do Codex e nao
sao minhas para mexer, mas vale uma limpeza combinada: rollback de rollback nao serve para
nada e isso ja custa tamanho de arquivo.

---

## 6. O catalogo montado no mapa

`workspace.CrumbleArena.AssetStaging`, plataforma de 156 x 104 centrada em `(200, 0, 0)`,
a leste da ilha. **299 BaseParts.** Nao e conteudo do lobby, e prateleira de consulta.

```text
AssetStaging
  Platform    laje e meio fio
  Pads        25 pedestais de 13 studs, cada um com etiqueta flutuante
  OrzePack    os modelos, um por pedestal
  NoteBoard   quadro de recado, virado para a ilha
```

Quatro fileiras tematicas, com marco de pedra e etiqueta em cada ponta: `VEGETACAO`,
`MOBILIARIO`, `ESTRUTURA`, `PLACAR`. Cada pedestal carrega os atributos `OrzeIndex`,
`Categoria`, `TamanhoOriginal`, `EscalaAplicada` e `Malhas`.

### Como isso entrou, ja que o Studio nao importa arquivo local

O `.rbxm` e binario com chunks em LZ4, e nao existe ferramenta MCP de importar arquivo.
A ponte tem tres pecas:

1. `lune` com `@lune/roblox` le o binario **fora** do Studio e cospe uma tabela de
   instancias, com CFrame, tamanho, cor, material e o Uri da malha.
2. Os dados vao para o Studio em lotes pela Command Bar.
3. `ServerStorage.OrzeBuilder` recria a hierarquia, reposiciona no pedestal e reduz a
   escala do que nao cabe.

Tres coisas que so aparecem quando se tenta:

- **A malha nao esta em `MeshId`.** O pacote e de formato moderno e guarda em `MeshContent`,
  um objeto `Content` com Uri. A primeira extracao saiu com todos os MeshPart vazios.
- **Atribuir `MeshPart.MeshId` pela Command Bar nao funciona**, devolve vazio. O que
  funciona e `InsertService:CreateMeshPartAsync`. Testado: 10 de 10 na primeira prova,
  337 de 337 no total, zero falha.
- **O indice de pai precisa ser a posicao no array emitido, nao na varredura.** Classes que
  o exportador nao emite, como `Attachment` e `SurfaceAppearance`, abriam buraco na
  numeracao e o Studio recusava com `Attempt to set X as its own parent`. O exportador
  agora sobe ate o primeiro ancestral emitido.

### Escala

Nenhum modelo foi aumentado, so reduzido para caber no pedestal de 11 studs. O fator esta
em `EscalaAplicada` e o tamanho de verdade em `TamanhoOriginal`. Os extremos:

| Modelo | Escala | Tamanho real |
| --- | --- | --- |
| 65_Pedestais | 0.046 | 237 x 111 x 195 |
| 66_Montanha | 0.144 | 76 x 33 x 76 |
| 73_BauB | 0.477 | 23 x 13 x 20 |
| 17_ArvoreA | 0.509 | 15 x 26 x 17 |

Nove modelos entraram em escala 1.000: tronco, cogumelo, picareta, banco, flores B, barril
A e B, e caixote. Esses ja nascem no tamanho certo para o lobby.

**Aviso sobre a entrada 65, rotulada `Pedestais`:** o rotulo esta errado. Sao seis cubos
brancos de 41 studs mais seis aneis Neon gigantes, coisa de arquibancada ou arco iris, e a
237 studs de largura ela virou miniatura de 0.046. Vale renomear ou descartar.

### A fonte nao foi trazida

A entrada 10 tem 96 malhas, **8 Beam, 2 ParticleEmitter e 1 PointLight**. O exportador
carrega geometria e mais nada, entao ela chegaria como casca parada, sem agua e sem brilho,
o que enganaria quem olhasse o catalogo. O pedestal ficou vazio, marcado em cor diferente,
com o motivo no atributo `Motivo` e a instrucao em `ComoTrazer`.

### Verificacao

| Item | Resultado |
| --- | --- |
| BaseParts em AssetStaging | 299 |
| Pedestais preenchidos | 24 de 25 |
| Pecas sem ancoragem | 0 |
| Modelos com colisao ligada | 0, sao vitrine |
| MeshPart com malha vazia | 0 |
| Falhas de carga de malha | 0 |
| Interseccao com o lobby | 0 |

A unica peca do lobby que passa de `x = 110` e a `FallZone`, que fica em `Y = -210`. Quem
cair da plataforma e destruido em `FallenPartsDestroyHeight = -240` e renasce normalmente.

---

## 7. Segunda leva, cinco pacotes

Arquivos entregues pelo Rick no mesmo dia, depois do Orze e do Cryptic:

| Arquivo | Formato | Instancias | Malhas distintas | Risco |
| --- | --- | --- | --- | --- |
| `Arbuzowski_Assets.rbxl` | place | 39 | 30 | nenhum script, remote ou som |
| `skullyassetpack.rbxl` | place | 88 | 43 | nenhum script, remote ou som |
| `hapy-s-assets-A0xWGpGPRyIjXX5g (4).rbxl` | place | 244 | 26 | nenhum script, remote ou som |
| `DeHapy-LowPolyPack.zip` | zip com um place | 40 | 19 | nenhum script, remote ou som |
| `Hapy_UI_v1 (1).rbxl` | place, so interface | 209 | 0 | nenhum script, remote ou som |

Os cinco passaram na mesma auditoria do Orze: **zero `Script`, zero `LocalScript`, zero
`ModuleScript`, zero `RemoteEvent`, zero `RemoteFunction`, zero `Sound`.** Nada roda sozinho
depois de entrar no place.

O `.zip` do DeHapy carrega um unico `DeHapy-LowPolyPack.rbxl` dentro. Foi extraido para o
scratchpad da sessao, nao para o projeto.

### 7.1 Onde cada um ficou

Quatro zonas novas em `workspace.CrumbleArena.AssetStaging`, na mesma faixa `x = 200` da
zona do Orze, avancando em Z para nao encostar em nada:

| Zona | Centro | Colunas | Modelos |
| --- | --- | --- | --- |
| `Zona_Arbuzowski` | `(200, -1, 124)` | 6 | 30 |
| `Zona_Skully` | `(200, -1, 228)` | 7 | 13 |
| `Zona_HapyAssets` | `(200, -1, 302)` | 6 | 11 |
| `Zona_HapyLowPoly` | `(200, -1, 376)` | 4 | 8 |

Cada zona tem a mesma estrutura da do Orze: `Platform`, `Pads`, `Models`, um `MarcoDoPacote`
com `BillboardGui` em `AlwaysOnTop` para achar a zona de longe, e etiqueta flutuante por
pedestal com o nome original do asset.

### 7.2 O que veio, por pacote

**Arbuzowski, medieval e rustico.** Tendas, carrocas, rodas de carroca, tochas, lanterna,
bandeiras, cercas, tumulos, pocos, caixote, barco, placa, alcapao e sete montes de pedra.
E o pacote mais util para o lobby: cerca, placa, lanterna e caixote conversam direto com o
Market e com a cerca da ilha.

**Skully, cartoon colorido.** Tres cogumelos, gema, fonte, moeda, poste de luz, lampada,
dois pedacos de terreno e tres familias de arvore, palmeira, normal e pinheiro. As arvores
sao candidatas fortes para substituir as que o Rick reclamou.

**Hapy Assets, natureza com efeito.** Cachoeira, pedras, topo de rocha, luz e cinco tipos de
grama. E o unico dos cinco com `Beam` e `ParticleEmitter`.

**Hapy Low Poly, base de terreno.** Borda, cerca, arvore, tres toras, grama, pedaco de chao
e duas pedras. Peso baixo, serve de material de preenchimento.

### 7.3 A regra "sem quebrar os assets" mudou o exportador

O exportador da primeira leva carregava geometria e mais nada. Isso teria trazido a
cachoeira do Hapy como casca parada, exatamente o problema que fez a fonte do Orze ficar de
fora. O pedido do Rick, *sem quebrar completamente os assets*, obrigou a escrever uma
segunda versao.

`exportar2.luau` e `ServerStorage.PackBuilder2` agora carregam, alem de geometria:

- `Beam`, `ParticleEmitter`, `Attachment`, `Weld`, `WeldConstraint`
- `Decal`, `Texture`, `SurfaceAppearance`, `Highlight`
- `PointLight`, `SpotLight`, `SurfaceLight`, `Sparkles`, `Smoke`, `Fire`

Tres coisas precisaram de cuidado:

1. **`ColorSequence` e `NumberSequence` nao atravessam texto.** O exportador quebra em array
   de keypoints e o builder remonta do outro lado. A tentativa ingenua de tratar `Color`
   como `Color3` estourou com `attempt to get an unknown field 'R'`, porque em `Beam` e
   `ParticleEmitter` `Color` e `ColorSequence`.
2. **`Attachment0`, `Attachment1`, `p0`, `p1` sao referencias.** Sao resolvidas numa segunda
   passada, depois que todas as instancias existem. Sem isso o Beam nasce sem pontas e nao
   desenha nada.
3. **Escala precisa alcancar o efeito.** Quando um modelo e reduzido para caber no pedestal,
   o builder escala junto a largura dos Beams, o tamanho e a velocidade das particulas, a
   aceleracao e o alcance das luzes. Senao a cachoeira encolhe e o jato de agua continua do
   tamanho original.

Prova de que funcionou: a `01_Waterfall` chegou com **8 `Beam`, todos com as duas pontas
ligadas, e 7 `ParticleEmitter`**, em escala 0.37.

### 7.4 Uma malha nao carregou

`Zona_Arbuzowski / 16_RockPile_01` aponta para `rbxassetid://982730283`, que
`InsertService:CreateMeshPartAsync` recusa. Provavel moderacao do asset. Foi a unica falha
em quatro pacotes de mundo.

O pedestal ficou com um marcador vermelho chamado `MALHA_NAO_CARREGOU_16_RockPile_01`, para
o Codex nao achar que e um bloco de decoracao. **Cuidado ao ler o codigo do builder:** ele
renomeia a instancia para `FALHOU` e logo em seguida sobrescreve o nome com o do asset. O
registro confiavel e o atributo `MalhasQueFalharam` na zona, nao o nome da peca.

### 7.5 Escala

Mesma regra da primeira leva: nenhum modelo foi aumentado, so reduzido para caber no
pedestal. O fator fica em `EscalaAplicada`. Os mais reduzidos:

| Modelo | Zona | Escala |
| --- | --- | --- |
| `09_LargeTerrain` e `10_SmallTerrain` | Skully | 0.12 |
| `02_Rock` | HapyAssets | 0.16 |
| `11_PalmTrees` | Skully | 0.22 |
| `13_PineTrees` | Skully | 0.23 |
| `07_Tent_02` e `14_Tent_03` | Arbuzowski | 0.25 |
| `04_Tent_01` | Arbuzowski | 0.32 |
| `06_Grass` | HapyLowPoly | 0.35 |
| `01_Waterfall` | HapyAssets | 0.37 |

Trinta e cinco dos 62 modelos entraram em escala 1.000, ou seja, ja nascem no tamanho certo
para o lobby.

### 7.6 O pacote de interface nao foi para o mapa

`Hapy_UI_v1 (1).rbxl` nao tem uma unica malha. Sao 209 instancias de `ScreenGui`, 64
`ImageLabel`, 40 `ImageButton`, 36 `TextLabel`, 34 `UIStroke` e 10
`UIAspectRatioConstraint`, distribuidas em dois `ScreenGui`, `Main` com 150 descendentes e
`Hud` com 46.

Nao existe forma honesta de por interface em cima de um pedestal. E a **D-017** proibe
substituir a interface atual do lobby, que vive no place com copia versionada em
`src/client/`.

**O pacote ficou fora do place.** Continua em `C:\Users\ricka\Downloads\Hapy_UI_v1 (1).rbxl`.
Se o Codex quiser usar, o caminho e abrir esse arquivo em outra janela do Studio, copiar
somente os elementos que interessam e colar dentro da interface existente, nunca por cima
dela. Decisao pendente do Rick.

### 7.7 Verificacao

Medido no place, com o Studio em modo Edit:

```text
Zona_Arbuzowski     66 pecas, 30 de 30 pedestais cheios
Zona_Skully         68 pecas, 13 de 13 pedestais cheios
Zona_HapyAssets     48 pecas, 11 de 11 pedestais cheios
Zona_HapyLowPoly    34 pecas,  8 de  8 pedestais cheios

AssetStaging       726 BaseParts, 15 efeitos (Beam, ParticleEmitter, Light)
pecas sem ancoragem   0
MeshPart com malha vazia   0
malhas que nao carregaram  1  (16_RockPile_01)
interseccao com o lobby    0
Lobby                   1129 BaseParts, intacto
```

### 7.8 O que continua pendente

- A fonte do Orze ficou de fora na primeira leva porque o exportador v1 nao carregava
  `Beam` nem `ParticleEmitter`. O `PackBuilder2` ja da conta dela. Falta o Rick dizer se
  quer que ela entre.
- `Hapy_UI_v1` espera decisao, ver 7.6.
- A pasta do Google Drive continua sem abrir, precisa de sessao autenticada.
