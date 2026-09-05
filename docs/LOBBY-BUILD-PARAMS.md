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

Emblema do bloco rachado no centro, com 6 fissuras rentes ao piso. Diametro util da praca:
84 studs.

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

Volta fechada de 13 plataformas em circulo, centro `(78, 60)`, raio 15.

- alturas de 4 a 14, seguindo `4 + 10 * sin(pi * i / 13)`
- vao maximo entre plataformas: 7.2 studs
- subida maxima: 2.4 studs
- distancia minima de qualquer corredor: 18 studs
- friso ambar por baixo de cada plataforma, o unico amarelo do lobby fora da interface
- degrau de entrada ligando a plataforma de partida a primeira pedra

## Seguranca

- 36 segmentos de barreira invisivel em anel, raio 124, altura 18
- `workspace.FallenPartsDestroyHeight = -240`, que e o respawn, sem nenhum script
- 4 `Seat` na area social, todos a pelo menos 21 studs de qualquer placa de caminho

## Iluminacao

| Propriedade | Valor |
| --- | --- |
| Brightness | 2.9 |
| ClockTime | 13.6 |
| GeographicLatitude | 24 |
| Ambient | 84, 88, 98 |
| OutdoorAmbient | 142, 148, 158 |
| ExposureCompensation | -0.05 |
| GlobalShadows | true |
| ShadowSoftness | 0.35 |
| EnvironmentDiffuseScale | 0.55 |
| EnvironmentSpecularScale | 0.25 |
| Bloom Intensity / Size / Threshold | 0.35 / 18 / 1.7 |
| SunRays Intensity | 0.02 |
| Atmosphere Density / Haze / Glare | 0.11 / 0.5 / 0 |
| Atmosphere Color | 222, 232, 244 |
| Atmosphere Decay | 170, 198, 228 |
| ColorCorrection Saturation / Contrast | 0.16 / 0.09 |

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
