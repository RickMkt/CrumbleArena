# Parametros de construcao do lobby

Estado: construido no Studio na sessao 002, em 2026-09-03. Este documento registra os
numeros exatos usados, para que o lobby possa ser refeito do zero se o place se perder.

Enquanto a decisao D-P01 nao for tomada, a verdade do lobby e o proprio place. Este
arquivo e a rede de seguranca, nao um gerador.

## Sistema de coordenadas

Origem no centro da praca. A superficie do gramado fica em `Y = 0`. O eixo `-Z` aponta
para o painel de evento, que e para onde o jogador nasce olhando.

## Ilha

Grade de celulas de 24 studs. Uma celula entra na camada quando a celula **encosta** no
disco do raio, nao quando o centro dela cai dentro. Foi essa troca que fechou os buracos
de borda encontrados no teste.

| Camada | Pasta | Raio | Topo Y | Altura |
| --- | --- | --- | --- | --- |
| GrassCell | Island.Base | 126 | 0 | 6 |
| DirtCell | Island.Base | 120 | -6 | 18 |
| StoneUpper | Island.Cliffs | 104 | -24 | 26 |
| StoneMid | Island.Cliffs | 80 | -50 | 30 |
| StoneLower | Island.Cliffs | 54 | -80 | 30 |
| StoneTip | Island.Cliffs | 28 | -110 | 30 |
| StonePoint | Island.Cliffs | bloco unico | -140 | 22 |

Largura util da ilha: 264 studs. Base solida da superficie ate `Y = -162`.

Blocos soltos de borda: 44, entre raio 133 e 146, sem colisao. Rochas na face do penhasco:
28. Fragmentos flutuantes: 12 proximos e 10 distantes, todos sem colisao.

## Praca central

Discos concentricos, todos com topo entre `Y = 0.5` e `Y = 0.9`.

| Anel | Raio |
| --- | --- |
| PlazaRingOuter | 42 |
| PlazaRingThird | 34 |
| PlazaRingSecond | 24 |
| PlazaRingInner | 15 |
| PlazaMedallion | 11 |

O centro usa a composicao `CentralPlaza.CrumbleCore`, integrada a fonte existente. O
emblema tem 7 fissuras assimetricas, 5 lajes deslocadas com studs e um bloco de 4
fragmentos suspenso sobre a agua. As fissuras e lajes nao tem colisao. A fonte permanece
em `CentralPlaza.CentralFountain` e carrega o atributo `IntegratedConcept = CrumbleCore`.
Diametro util da praca: 84 studs.

`LobbySpawn` e um `SpawnLocation` de 12 x 0.2 x 12 em `(0, 0.90, -18)`, invisivel, ancorado,
com colisao, `Neutral = true`, `Duration = 0`. A orientacao identidade faz o personagem
nascer olhando para `-Z`, que e a direcao do `EventBoard`.

Ele ja esteve em `(0, 1.45, 0)` com 20 x 1 x 20, como este documento dizia ate 2026-09-05.
Depois alguem pos a `CentralFountain` no centro da praca e empurrou o spawn para `z = +18`,
sem atualizar o documento. Isso deixou a fonte entre o jogador e o `EventBoard`, escondendo
o board inteiro. Na sessao 008 o spawn foi para `z = -18`, o espelho exato do que estava:
mesma distancia do centro, lado oposto, com a fonte agora as costas do jogador.

O tamanho continua 12 x 12 de proposito. O piso da praca e feito de aneis concentricos, e a
faixa plana mais larga entre dois aneis tem cerca de 10 studs, entao uma plataforma maior
ficaria com borda flutuante. Com 12 x 12 e oito jogadores nascendo juntos, a menor distancia
entre dois personagens fica em 4,00 studs, que e exatamente o limiar de conforto.

## Caminhos

8 caminhos, cada um uma bezier quadratica da borda da praca ate a area, com 9 segmentos.
Largura entre 16 e 20 studs, meio fio sem colisao dos dois lados. Conferido na sessao 008:
os 8 caminhos tem **0 meio fio com colisao**, entao o meio fio nao bloqueia ninguem.

Os segmentos nasceram com comprimento menor que o passo entre eles, e giram cerca de 4 graus
por segmento nas curvas. Como sao caixas retangulares, a emenda virava uma cunha: fechada na
borda interna da curva, 0,10 no centro e ate 0,66 na borda externa, que fica dentro da faixa
que o jogador pisa. Na sessao 008 as 192 pecas de caminho, placa e meio fio, foram alongadas
0,8 no proprio eixo, mantendo o centro. Todas as frestas foram a zero.

As placas agora se sobrepoem um pouco na emenda, e isso e proposital. Em curva, com caixas
retangulares, ou sobra fresta do lado de fora ou sobra sobreposicao do lado de dentro, nao
existe terceira opcao. Como cada placa esta numa altura diferente, as faces de cima nunca
sao coplanares e nao ha z-fighting. Ver `tools/fixes/01-ClosePathSeams.luau`, que guarda o
comprimento original de cada peca em atributo e traz a reversao escrita.

| Caminho | Destino x, z | Altura final | Largura | Curvatura |
| --- | --- | --- | --- | --- |
| PathEventBoard | 0, -74 | +4 | 20 | 0 |
| PathCosmetics | -74, -46 | +3 | 17 | 12 |
| PathGamepasses | 74, -46 | +3 | 17 | -12 |
| PathLeaderboard | -86, 18 | +2 | 17 | -14 |
| PathMapVote | 86, 18 | +2 | 17 | 14 |
| PathTraining | -50, 80 | -1 | 17 | 10 |
| PathParkour | 52, 80 | +1 | 16 | -10 |
| PathSocial | 0, 94 | +2 | 16 | 16 |

## Areas

| Area | Centro x, z | Topo da laje | Laje |
| --- | --- | --- | --- |
| EventBoard | 0, -84 | 2.5 | 46 x 30 |
| Cosmetics | -80, -50 | 2.5 | 46 x 38 |
| Gamepasses | 80, -50 | 2.5 | 44 x 36 |
| Leaderboard | -92, 20 | 2.5 | 42 x 36 |
| MapVote | 92, 20 | 2.5 | 46 x 40 |
| Training | -56, 82 | 0.7 | 44 x 38 |
| SocialArea | 0, 100 | 2.5 | 36 x 26 |

Conferido peca por peca na sessao 008. Centros e tamanhos batiam; o **topo** nao batia. Este
documento dizia 4.5 no `EventBoard` e 3.5 no `Cosmetics` e no `Gamepasses`, e a realidade e
2.5 em todas. As lajes estao todas na mesma altura.

Cuidado com o nome `Pad`. Ele nem sempre e a peca pisavel:

- `SocialArea` nao tem `Pad`, o piso chama `Deck`, e o `DeckTrim` tem topo em 0.40, abaixo
- `EventBoard`, `Cosmetics`, `Gamepasses`, `Leaderboard` e `MapVote` tem `PadTrim` maior que
  o proprio `Pad`
- `TrainingPoint` tem uma **pasta** chamada `Pad`, nao uma peca
- o `StepRing` de varias areas tem 6.25 de espessura e e degrau, nao piso

Quem for medir area util por script precisa achar o piso por raio ou filtrar por espessura,
nunca por nome.
| Parkour StartPad | 58, 84 | 2.5 | 16 x 16 |
| FutureFeatures | -78, -8 | mural, sem laje | 25 de largura |

Toda laje com topo acima de 1.5 tem um anel de degraus com no maximo 1.5 stud por passo.
Isso e o que garante o criterio de nenhum ponto exigir pulo.

## Parkour

O percurso abaixo esta adiado em `ServerStorage.DeferredLobbyAreas.Parkour`, conforme
D-014. Ele nao faz parte do lobby ativo. No lugar existe o ponto compacto
`Areas.ParkourPoint`, com placa `PARKOUR / COMING SOON`, tres blocos de leitura visual e
um arco sem colisao.

Conteudo preservado, para referencia de restauracao: volta fechada de 13 plataformas em
circulo, centro `(78, 60)`, raio 15.

- alturas de 4 a 14, seguindo `4 + 10 * sin(pi * i / 13)`
- vao maximo entre plataformas: 7.2 studs
- subida maxima: 2.4 studs
- distancia minima de qualquer corredor: 18 studs
- friso ambar por baixo de cada plataforma, o unico amarelo do lobby fora da interface
- degrau de entrada ligando a plataforma de partida a primeira pedra

## Seguranca

- 36 segmentos de barreira invisivel em anel, raio 124, altura 26
- `Safety.FallZone`, altura 4, como volume de seguranca complementar
- `workspace.FallenPartsDestroyHeight = -240`, que e o respawn, sem nenhum script
- 4 `Seat` na area social, todos a pelo menos 21 studs de qualquer placa de caminho

## Iluminacao

| Propriedade | Valor |
| --- | --- |
| Brightness | 2.2 |
| ClockTime | 14.2 |
| GeographicLatitude | 18 |
| Ambient | 92, 98, 112 |
| OutdoorAmbient | 146, 156, 172 |
| ExposureCompensation | -0.02 |
| GlobalShadows | true |
| ShadowSoftness | 0.32 |
| EnvironmentDiffuseScale | 0.62 |
| EnvironmentSpecularScale | 0.18 |
| Bloom Intensity / Size / Threshold | 0.12 / 20 / 1.9 |
| SunRays Intensity / Spread | 0.018 / 0.85 |
| Atmosphere Density / Offset / Haze / Glare | 0.16 / 0.03 / 0.8 / 0.02 |
| Atmosphere Color | 220, 232, 238 |
| Atmosphere Decay | 132, 172, 210 |
| ColorCorrection Saturation / Contrast | 0.08 / 0.10 |
| ColorCorrection TintColor | 255, 250, 244 |
| Cloud Cover / Density / Color | 0.42 / 0.62 / 255, 253, 248 |
| Sky SunAngularSize | 9 |

Valores originais do template, para reverter: `Brightness 3`, `ClockTime 14.5`,
`Ambient e OutdoorAmbient 70, 70, 70`, `Bloom 1 / 24 / 2`, `Atmosphere Density 0.3`,
`SunRays 0.01`, sem `ColorCorrectionEffect`.

## Paleta

| Uso | RGB |
| --- | --- |
| Grama | 108 a 118, 188 a 196, 88 a 96 |
| Terra | 140 a 150, 96 a 104, 60 a 66 |
| Pedra clara | 152, 154, 158 |
| Pedra escura | 101, 104, 113 |
| Piso da praca | 184, 184, 188 ate 136, 139, 147 |
| Caminho | 150, 143, 128 |
| Madeira | 152, 106, 62 e 112, 76, 46 |
| Gelo | 126, 206, 236, transparencia 0.15 |
| Roxo premium | 146, 96, 214 e 88, 54, 148 |
| Amarelo de destaque | 246, 196, 70 |
| Vermelho, so em alvo | 226, 92, 84 |

## Cabana do mercado, a partir de 2026-09-06

Reconstruida por `tools/rebuild/06-BuildMarketStall.luau`. O arquivo e a fonte, esta secao
e o resumo. 198 BaseParts, incluindo o rig do lojista.

Sistema local: eixo de simetria em `x = -46.5`, laje do terraco com topo em `Y = 3.2`,
ladrilho lego com topo em `3.44`, assoalho da loja com topo em `3.6`. A frente aponta para
`+Z`, que e o lado de onde o jogador chega.

| Elemento | Medida |
| --- | --- |
| Vao entre postes | 23.4 de largura, `x -58.2` a `-34.8` |
| Profundidade | 9.0, dos postes do fundo em `z -44` aos da frente em `z -35` |
| Poste do fundo | 1.6 x 10.25 x 1.6 sobre pe de pedra de 2.4 x 0.9 |
| Poste da frente | 1.6 x 7.85 x 1.6 |
| Toldo | 7 faixas de 3.3428 x 0.5 x 12.0, inclinacao 13.75 graus, plano centrado em `z -39.1`, `Y 12.4` |
| Barra do toldo | `Y 10.97`, bandos alternando 1.15 e 0.75, descendo ate `9.64` |
| Balcao | corpo 19.4 x 2.0 x 2.4 em `z -37.1`, tampo com topo em `Y 6.10` |
| Parede do fundo | 4 fiadas de 23.4 x 1.6 x 0.8 |
| Letreiro | fundo de 15.0 x 3.6 em `Y 13.55`, `z -36.2` |
| Marca de atendimento | anel de 54 segmentos, raio 5.4, centro `(-46.5, 3.53, -30.2)` |
| Totens de gamepass | `(-63, 8.2, -33)` e `(-30, 8.2, -33)`, abertos 33 graus para dentro |
| Lojista | pe em `Y 3.6`, cabeca ate `8.78`, mao do aceno em `7.80` |

A altura do toldo nao e livre. A cabeca do lojista com bone termina em `8.78`, entao a
barra do toldo precisa ficar acima disso ou ele desaparece de quem olha de frente. Com
18.6 graus a barra caia para `9.09` e os bandos ate `7.6`, e o lojista sumia.

O balcao nao encosta nos postes da frente de proposito: ele termina em `z -35.9` e o poste
comeca em `-35.8`, com 0.1 de folga. Sem essa folga as duas faces ficam coplanares.

O suporte da prateleira do fundo fica em `Y 6.26`, e nao em `6.30`. Em `6.30` o topo dele
coincide com o topo da fiada `BackCourse_2`, que e o caso proibido pela D-015.

### Piso do terraco

O terraco vai de `x -68` a `-24` e de `z -46` a `-19`, com os cantos cortados. A laje e de
`WedgePart` e recebe a cor `198, 184, 156`. O stud vai na propria laje, na face que aponta
para cima, que nestas pecas e a `LeftSurface` ou a `RightSurface` e nao a `TopSurface`.
Ver D-023.

Houve entre as duas coisas uma versao com 34 ladrilhos de 4 studs por cima, com topo em
`3.44`. Ela foi removida: era um tapete de 0.24 de espessura e criava degrau na borda. O
patio do mercado desceu 0.24 junto com ela, e hoje se apoia na laje, em `3.20`.

A unica subida ate o terraco e a rampa `MarketRise`, em `x -36` a `-24`, `z -20` a `2`. As
outras bordas sao degrau de cerca de 2.9 por desenho. Medido na rampa: degrau maximo 0.24.
