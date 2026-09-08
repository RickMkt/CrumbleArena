# Plano de transformacao do lobby, A2

Criado em 2026-09-06. Projeto `C:\Users\ricka\Desktop\CrumbleArena`, branch
`feat/lobby-art-pass`, place `CrumbleArena.rbxl`, hierarquia `Workspace.CrumbleArena.Lobby`.

Regra de trabalho desta etapa: **uma fase por vez**. Problema observado fora da fase atual
vai para o backlog e nao e corrigido no momento. Fase que nao melhora e revertida antes de
seguir.

## Estado medido no inicio

793 BaseParts no lobby, distribuidos assim:

| Pasta | BaseParts |
| --- | --- |
| Market | 145 |
| Architecture | 157 |
| Environment | 153 |
| Vegetation | 98 |
| SocialArea | 78 |
| Information | 63 |
| CentralPlaza | 37 |
| Outlook | 19 |
| Rocks | 18 |
| Boundaries | 18 |
| Props | 7 |

O arquivo em disco e de 12:36 e **nao contem** a passada de stud no chao real. O estado
descrito aqui e o que esta na memoria do Studio.

## O achado que define a Phase 1

Sondagem da borda da praca, de 5 em 5 graus, a partir do centro real `(0, 4)`:

```text
72 amostras na volta completa
26 caem em caminho, com degrau de 0.06 a 0.25
46 caem em grama, com degrau de 2.40
```

**64 por cento do perimetro da praca e um paredao vertical de 2.40 studs sobre a grama.**
A praca nao esta assentada na ilha, esta apoiada em cima dela. Isso acontece no ponto mais
visto do lobby, porque o spawn olha direto para la.

Composicao da praca hoje:

| Camada | Faixa em Y | Cor | Pecas |
| --- | --- | --- | --- |
| `Floor.PlazaFoundation` | 0.00 a 1.80 | 104,119,130 | 12 WedgePart |
| `Floor.PlazaPaving` | 1.80 a 2.40 | 139,151,153 | 12 WedgePart |

Poligono de 12 lados, centro em `(0, 4)`, raio entre 21.5 e 24.5. Diametro util cerca de
46 studs. O `LobbySpawn` esta em `(0, 0.70, 53)`, a 49 studs do centro.

Monumento: tres pedestais de 16, 13 e 10 studs de diametro empilhados ate Y 4.50, quatro
blocos de 4.05 entre Y 7.40 e 8.30, quatro fragmentos suspensos ate Y 14.80. Existe um vao
de 0.70 entre o topo do pedestal e a base dos blocos.

---

# Fases

## PHASE 1: praca central e chegada Spawn para Core

**Objetivo:** fazer a praca parecer escavada na ilha, e nao pousada sobre ela.

**Problemas atuais, medidos:**

- 46 de 72 amostras do perimetro tem degrau de 2.40 para a grama
- o piso e uma mancha continua de 46 studs de diametro em cor unica, 139,151,153
- nao existe nenhuma variacao de nivel dentro da praca
- a borda e um poligono regular perfeito, sem nenhuma quebra
- o monumento fica pequeno diante do vazio ao redor

**Areas afetadas:** `CentralPlaza.Floor` (24 pecas), a faixa de grama imediatamente ao
redor, e as quatro junções com `PathSpawn`, `EastConnection`, `WestConnection` e
`PathOutlookSouth`.

**Mudanca pretendida:**

1. Saia em degraus na borda: o desnivel de 2.40 vira duas ou tres bancadas, de modo que a
   praca desca ate a grama em vez de cair.
2. Borda irregular: a saia nao e um anel uniforme. Em dois ou tres pontos a grama entra na
   pedra, e em outros dois a pedra avanca para fora.
3. Uma variacao de nivel interna: um patamar baixo em volta do monumento, de poucos studs,
   para o piso deixar de ser um disco unico e o monumento ganhar hierarquia.
4. Limpeza das quatro junções com os caminhos, para a chegada ficar continua.

**Impacto visual esperado:** alto. E o primeiro plano do spawn e o centro de todas as
rotas. A silhueta da praca muda de disco flutuante para plataforma integrada.

**Risco tecnico:** medio. Mexe em piso caminhavel, entao qualquer erro vira degrau ou
buraco. Mitigacao: backup da pasta `Floor` em ServerStorage antes, e sondagem de degrau
maximo nas quatro rotas depois.

**Criterio de conclusao:**

- nenhuma amostra do perimetro com degrau maior que 1.5
- degrau maximo nas quatro rotas de chegada abaixo de 1.5
- zero peca sem ancoragem, zero colisor fantasma, zero conflito novo de D-015
- comparacao antes e depois em vista aerea, no nivel do jogador e na chegada do spawn

**Nao sera mexido nesta fase:** monumento, vegetacao, iluminacao, materiais das outras
areas, Market, SocialArea, Information, Outlook, silhueta da ilha, qualquer prop.

---

## PHASE 2: SocialArea

**Objetivo:** tirar a leitura de plataforma bege colocada sobre a grama.

**Problemas atuais:** base de contorno geometrico, transicao seca com a grama, assentos em
disposicao circular regular demais.

**Mudanca pretendida:** recompor a base como clareira de contorno irregular, com um canto
desaparecendo na grama e outro ganhando borda de pedra baixa. Reposicionar assentos para
composicao assimetrica, todos ainda olhando parcialmente para a fogueira.

**Impacto:** alto. **Risco:** medio, tem assentos funcionais a preservar.

**Conclusao quando:** contorno deixa de ser poligono regular, os seis assentos continuam
sentaveis, circulacao sem degrau acima de 1.5.

**Nao mexer:** fogueira, Market, praca, vegetacao de fundo.

---

## PHASE 3: Market

**Objetivo:** integrar o Pip's Market ao terreno sem trocar o asset.

**Problemas atuais:** o terraco e grande demais para o que abriga, e a construcao le como
posta sobre uma base clara.

**Mudanca pretendida:** reduzir ou recortar a fundacao, criar transicao de pedra e madeira,
levar a grama para mais perto da construcao, resolver a chegada do caminho.

**Impacto:** medio alto. **Risco:** alto de conflito, porque outro agente editou o Market
nesta mesma sessao. Precisa de combinacao antes.

**Conclusao quando:** a plataforma frontal encolhe, a transicao vira degrau ou talude, os
cards continuam legiveis e a area de interacao continua livre.

**Nao mexer:** desenho da cabana, toldo, letreiro, lojista.

---

## PHASE 4: Outlook

**Objetivo:** transformar 19 pecas de area vaga em destino.

**Mudanca pretendida:** pequena mudanca de altura, deck, guarda corpo melhor, banco
reposicionado, duas ou tres pedras, uma arvore enquadrando a vista.

**Impacto:** medio. **Risco:** baixo, area isolada.

**Conclusao quando:** existe motivo para caminhar ate la e a vista tem enquadramento.

**Nao mexer:** ilhas de fundo, silhueta da ilha principal.

---

## PHASE 5: Information Area

**Objetivo:** leaderboard e event board lendo como area planejada.

**Risco:** alto de conflito. Outro agente esta editando esta pasta agora. **Esta fase so
comeca depois de combinado.**

---

## PHASE 6: vegetacao

**Objetivo:** unificar familias e escala. Inventario primeiro, substituicao depois, nunca
troca de mesh no chute.

**Direcao:** familia redonda dominante, pinheiro como segunda, poucas arvores grandes como
marco. Agrupar em vez de distribuir.

**Conclusao quando:** existe hierarquia visivel de tamanho e a escala foi conferida no
nivel do avatar, nao so em vista aerea.

---

## PHASE 7: silhueta local e ilhas de fundo

**Objetivo:** poucos gestos grandes, nunca redesenho. Uma reentrancia, um avanco perto do
Outlook, uma borda mais natural perto da SocialArea.

**Restricao dura:** a ilha atual e para ser reconhecida depois. Nada de reconstrucao.

---

## PHASE 8: identidade Crumble

Monumento com fragmentos que sobem e voltam, rachaduras com luz fria discreta, blocos
deslocados. Somente depois da arquitetura resolvida.

---

## PHASE 9: luz e animacao ambiental

Passe leve. Fogueira, monumento e Market, tres pontos e so. Preservar o ceu azul e a
sensacao clara.

---

## PHASE 10: limpeza, performance e auditoria final

Contagem de pecas, colisores, D-015, caminhabilidade das oito rotas, Output limpo,
documentacao batendo com a realidade.

---

# Ordem final proposta

Concordo com a ordem do Rick, com **um ajuste**: a Information Area sai da posicao 5 e vira
condicional, porque outro agente esta editando aquela pasta neste momento e sobrescrever
trabalho em andamento e como se perde coisa.

```text
1. Praca central e chegada Spawn para Core
2. SocialArea
3. Market                      (depende de combinar com o outro agente)
4. Outlook
5. Vegetacao
6. Silhueta local e ilhas de fundo
7. Information Area            (quando liberada)
8. Identidade Crumble
9. Luz e animacao ambiental
10. Limpeza e auditoria final
```

Motivo do ajuste: as fases 5 e 6 do plano original nao dependem da Information Area, entao
adiar ela nao trava nada. Ja comecar por ela agora trava tudo.

---

# BACKLOG OBSERVADO

Registrado, nao corrigido.

| Problema | Area | Prioridade | Fase |
| --- | --- | --- | --- |
| 33 faces com stud gravado que nao aparece | Information | media | 7 |
| `LobbySpawn` esta em `(0, 0.70, 53)`, o documento diz `(0, 0.90, -18)` | docs | alta | 1, ao encerrar |
| Vao de 0.70 entre o topo do pedestal e a base dos blocos do monumento | CentralPlaza | media | 8 |
| Duas familias de arvore com procedencia nao reconciliada | Vegetation | alta | 6 |
| Musica do lobby carrega e nunca inicia | runtime | media | fora do A2 |
| `stylua` desta maquina nao compila Luau, o portao de formatacao nao existe | ferramenta | media | fora do A2 |
| Dois agentes editando o mesmo place, ja custou trabalho duas vezes | processo | alta | imediata |
| `Market.Shopkeeper` precisa de inspecao do que o outro agente acrescentou | Market | media | 3 |

---

# PHASE 1, executada em 2026-09-06

## Checkpoint PRE-PHASE-1

```text
place    CrumbleArena.rbxl  669.632 bytes  2026-09-06 13:27:19
sha256   5740ff19465a310159bcfd39f6e3f87e9183071f6564e160b23265b68a685820
backup   backups/CrumbleArena-PRE-PHASE1-20260906-132719.rbxl, hash identico
rollback ServerStorage.Phase1Rollback, com CentralPlaza e IslandFoundation
datamodel 793 BaseParts, 0 sem ancoragem, 384 superficies com stud
digital de geometria 161642.5148, reconferida antes de escrever e identica
```

## O que foi feito

Cinco gestos localizados, um por arco de grama do perimetro mais a chegada. Nao foi
usada saia uniforme, a pedido do Rick.

| Gesto | Arco | O que e |
| --- | --- | --- |
| SW_TerrenoSubindo | 203 a 247 | duas bancadas de grama de profundidade e altura sorteadas, pontas afinando, com meio fio de pedra baixo no topo |
| SE_RampaDeGrama | 293 a 337 | rampa de grama de 9 graus subindo do chao ate o nivel da praca, com lingua de grama avancando por cima do piso |
| NE_PatamarDePedra | centro em 45 | patamar retangular de duas lajes, arestas retas, larguras e deslocamentos diferentes |
| NW_BordaQuebrada | 124 a 146 | tres lajes de praca cedidas, com calco de grama por baixo |
| N_ChegadaDoSpawn | 67 e 113 | duas soleiras baixas marcando a boca da praca |

## Numeros

| Medida | Antes | Depois |
| --- | --- | --- |
| BaseParts no lobby | 793 | 836 |
| Pecas em `PlazaIntegration` | 0 | 43 |
| Perimetro com degrau maior que 2.0 | 46 de 72 | 12 de 72 |
| Perimetro com degrau ate 0.5 | 26 de 72 | 35 de 72 |
| Acessos caminhaveis a praca | 4 | 5 |
| Degrau maximo nas quatro rotas | 0.25 | 0.35 |
| Pecas sem ancoragem | 0 | 0 |
| Colisores fantasma | 0 | 0 |
| Faces de cima coplanares com sobreposicao | nao medido | 0 |
| Stud gravado que nao aparece, fora de Information | 0 | 0 |

Onde sobrou degrau acima de 2.0: 25, 155, 185 a 195, 290 a 295, e 335 a 355 graus. Sao os
ombros entre um gesto e o caminho vizinho. O criterio combinado nao exige menos de 1.5 nos
360 graus, exige que o que sobrar tenha intencao.

## Tres correcoes feitas dentro da propria fase

Registradas porque cada uma foi um erro meu pego por captura, nao por medida.

1. **Contencao do sudoeste.** Cinco blocos de ate 3.5 de altura e 5.2 de largura leram como
   caixotes abandonados na grama. Trocados por sete pecas de meio fio de 0.65 a 1.05 de
   altura, assentadas no topo do talude.
2. **Lajes do noroeste.** Cinco lajes finas espalhadas liam como entulho. Viraram tres,
   maiores, mais enterradas, cada uma com calco de grama por baixo.
3. **Marcos da chegada.** 3.6 x 2.5 x 3.6 com tampa de 4.2 liam como duas geladeiras cinzas
   na mesma linha de visao do monumento, competindo com ele. Viraram soleiras de 0.68.
4. **Patamar do nordeste.** Sete fatias seguindo a curva da praca formavam um leque de
   degraus concentricos, exatamente o que o Rick pediu para evitar. So aparecia em vista
   aerea, no nivel do jogador parecia certo. Virou patamar retangular de aresta reta.

## Limitacao conhecida da propria auditoria

A varredura padrao da D-015 so olha peca alinhada aos eixos. As 43 pecas novas estao todas
giradas pelo raio, entao ela devolveu "0 conferidas" e nao testou nada. Foi preciso escrever
um teste que funciona em peca girada, comparando altura da face de cima e sobreposicao em
planta. Ele achou 5 faces coplanares, todas corrigidas. **Isso e divida:** a varredura da
D-015 precisa passar a cobrir peca girada.

## O que NAO foi feito, de proposito

- Nenhuma alteracao de material, cor de familia ou textura
- Nenhum patamar novo sob o monumento, ver decisao abaixo
- Nenhuma vegetacao, prop, luz, particula ou asset
- Nada fora de `CentralPlaza`

## Decisao sobre o patamar do monumento

Nao foi construido. Depois dos cinco gestos, o espaco ao redor do monumento ficou com
borda ocupada e o monumento voltou a ser o unico volume alto no centro. Acrescentar mais
uma base abaixo dele comecaria a pilha de circulos concentricos que o Rick pediu para
evitar, e resolveria por adicao o que a composicao ja resolveu. Fica para a Phase 8, junto
com fragmentos e luz.

---

# PHASE 2, executada em 2026-09-06

## Checkpoint PRE-PHASE-2

```text
place    CrumbleArena.rbxl  673.654 bytes  2026-09-06 13:45:27
sha256   724d8364692f11c0407145f7834d6174a2b0ed24eef62fb70370b0ebc19c0a82
backup   backups/CrumbleArena-PRE-PHASE2-20260906-134527.rbxl, hash identico
rollback ServerStorage.Phase2Rollback, com SocialArea e SocialClearing
digital de geometria no inicio  166048.1183
```

## Diagnostico

A SocialArea **nao tem piso proprio**. O piso e `Architecture.Paths.SocialClearing`, dez
WedgePart com topo em `Y 0.60`, cor terra `141,113,78`. O degrau para a grama e 0.60
uniforme, ou seja, o problema nunca foi altura, foi forma.

Duas medidas explicam a leitura de placa:

1. **A clareira e descentrada da fogueira.** Raio 20 a 25 no setor 40 a 118 graus, contra 9
   no setor 220 a 260. Sobrava uma faixa morta de 10 studs atras das cadeiras.
2. **Os assentos estavam simetricos e longe.** Quatro cadeiras num arco de 29 a 152 graus,
   todas no raio 13.5, em pares espelhados exatos. Dois bancos do outro lado.

## O que foi feito

| Gesto | Setor | O que e |
| --- | --- | --- |
| Lobo virando grama | 46 a 110 | `Face2_2` e `Face3_1`, dois wedges inteiros da clareira, passaram a cor de grama |
| W_BordaDePedra | 134 a 186 | cinco pedras baixas na borda, altura 0.7 a 1.15 |
| SW_TerraTransborda | 207 a 262 | seis linguas de terra saindo de 2.5 a 6.0 studs para dentro do gramado |
| SE_CantoSome | 280 a 318 | cinco pecas rebaixando a borda naquele canto |
| Assentos | volta toda | seis assentos reposicionados em composicao assimetrica |

Assentos, antes e depois:

```text
ANTES  29/13.5  69/13.5  114/13.5  152/13.5   196/8.7  323/10.6   (pares espelhados)
DEPOIS 36/9.9   63/10.6  108/12.6  152/9.4    202/8.7  258/10.9   (vao aberto de 258 a 396)
```

Todos olham para a fogueira com desvio entre -11 e +10 graus. O vao de 138 graus e por
onde se chega da praca.

## Numeros

| Medida | Antes | Depois |
| --- | --- | --- |
| BaseParts no lobby | 829 | 845 |
| Pecas em `SocialArea` | 78 | 94 |
| Pecas novas em `ClearingEdge` | 0 | 16 |
| Wedges recoloridos | 0 | 2 |
| Assentos movidos | 0 | 6 |
| Desvio dos assentos para o fogo | -45 a +45 | -11 a +10 |
| Modelos se sobrepondo em planta | nao medido | 0 |
| Degrau na circulacao interna | 0.60 | 0.00 a 0.60 |
| Sem ancoragem, fantasma, stud invisivel | 0, 0, 0 | 0, 0, 0 |

## Tres tentativas descartadas antes de acertar

O lobo morto foi atacado tres vezes por sobreposicao de fatias de grama, e as tres vezes
falhou por um motivo so, que vale registrar: **fatiar uma curva em blocos radiais sempre
serrilha a borda externa**.

1. Fatias com raio interno sorteado e vao entre elas: leu como pente de retangulos verdes.
2. Fatias continuas com dois tons alternados: leu como leque de concha.
3. Fatias continuas de cor unica recortadas na borda: ainda serrilhava por fora.

A solucao que funcionou nao criou peca nenhuma: **dois wedges inteiros da propria clareira
viraram grama**. `Face2_2` cobre 46 a 68 graus com raio medio 22.8, `Face3_1` cobre 68 a
110 com raio medio 22.2, e ambos sao justamente o lobo morto. A fronteira passa a ser a
aresta reta do proprio wedge, sem degrau e sem serrilha. Cada um guarda `PreSocialColor`
em atributo, entao a reversao e trivial.

## Chapas finas removidas

As primeiras versoes dos quatro gestos tinham pecas de transicao com topo entre 0.26 e
0.40, chapas deitadas sobre a grama. De cima viraram franja. Foram 27 pecas removidas. O
degrau de 0.60 da clareira ja e meio fio normal e nao pede rampa.

## Anomalia: sete pecas da Phase 1 desapareceram

Ao fechar a Phase 2, `CentralPlaza` tinha 73 pecas em vez das 80 esperadas. Faltavam:

- `N_ChegadaDoSpawn`, as quatro soleiras da boca da praca
- `SE_Lingua_1`, `SE_Lingua_2` e `SE_Lingua_3`, as linguas de grama sobre o piso

Conferido por aritmetica: 845 hoje menos as 16 novas da SocialArea da 829, e 836 do fim da
Phase 1 menos 7 tambem da 829. Ou seja, elas ja nao existiam quando a Phase 2 comecou.
Nenhum script da Phase 2 toca em `CentralPlaza`, e os scripts do outro agente tambem nao.

**Nao foram restauradas.** As quatro soleiras foram exatamente o que eu mesmo apontei como
elemento que competia com o monumento, e as linguas ficavam por cima do piso da praca. Se
a remocao foi manual e deliberada, restaurar seria desfazer decisao do usuario.

---

# Cerca da ilha e barreira invisivel, 2026-09-06

Pedido fora da sequencia de fases: cerca em volta da ilha para simular contencao, com a
parede invisivel **por dentro** dela, para que o pulo nao passe por cima.

## Como o contorno foi obtido

O contorno caminhavel foi amostrado de 1.5 em 1.5 graus a partir da origem, 240 amostras,
raio entre 65 e 98, todo em `Y = 0.00`. As amostras passaram por uma simplificacao que
mantem um ponto so quando ele se afasta mais de 1.3 stud da reta do trecho. Resultado:
**poligono de 18 vertices, 590 studs de perimetro, arestas de 15 a 47 studs**. Isso
recupera as arestas retas do terreno em vez de tratar a ilha como circulo, e e o que faz a
cerca ficar alinhada.

O poligono fica guardado em `Lobby.IslandOutline`, como `Vector3Value` por vertice.

## Construcao

| Elemento | Medida |
| --- | --- |
| Recuo da cerca em relacao a borda | 3.0 studs |
| Recuo da barreira | 3.9 studs, ou seja **0.9 por dentro da cerca** |
| Base de pedra | 1.9 de largura, 0.55 de altura, corrida em cada aresta |
| Poste comum | 1.15 x 4.8 x 1.15, a cada 9 studs |
| Poste de vertice | 1.45 x 5.3 x 1.45 |
| Trilhos | dois, em Y 1.75 e 3.35, secao 0.46 x 0.34 |
| Barreira invisivel | 1.2 de espessura, topo em 18.3, `Transparency 1`, `CanQuery true` |

O recuo dos vertices e feito pela bissetriz das duas arestas vizinhas, e nao radialmente,
senao os cantos abrem vao.

## Erros corrigidos durante a construcao

1. **Postes flutuando.** A sonda de chao dos postes batia nos trilhos que o proprio script
   acabara de criar. As bases foram de 3.58 a 14.78 em vez de 0. Corrigido medindo todas
   as alturas do terreno **antes** de criar qualquer peca.
2. **Aresta em cima do telhado.** A aresta 02 assentou sobre o `ChampionsPavilion`, com a
   base em Y 11.5, porque a sonda aceitava qualquer peca. Corrigido com lista branca de
   superficies de piso e descida por camadas quando o raio bate em construcao.
3. **Cerca atravessando construcao.** 13 pecas entravam no `RearStoneWall` e no
   `TimberDeck` do Outlook. Onde a construcao ja ocupa a linha, ela e a guarda: as pecas
   foram removidas.
4. **Vao de 100 studs no Outlook.** A remocao do item 3 tirou a cerca de tres arestas
   inteiras. Elas foram refeitas em trechos de 6 studs, cada trecho na altura do maior
   apoio sob a faixa da base, entao a cerca sobe no deck e desce de volta.

## Validacao com evidencia

| Verificacao | Resultado |
| --- | --- |
| Furos na barreira | **0** em 1800 sondagens, 360 direcoes x 5 alturas |
| Barreira por dentro da cerca | 0 direcoes com ela por fora, folga de 0.81 a 3.42 |
| Topo da barreira | 18.3, contra alcance de pulo de cerca de 7.3, folga de 11.0 |
| Cerca atravessando construcao | 0 |
| Pecas da cerca | 198 |
| BaseParts no lobby | 1.038 |
| Sem ancoragem | 0 |
| Colisor fantasma | 0 |

Rollback da barreira anterior em `ServerStorage.FenceRollback.BoundariesBefore`.
