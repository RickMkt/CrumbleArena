# Especificacao do lobby

Estado: especificacao escrita, nada construido. Nenhuma geometria existe no Studio.

O lobby e a primeira entrega do Crumble Arena e a primeira prova da identidade visual.
Ele tambem e o lugar onde nasce o kit modular que os proximos jogos do estudio vao usar.

## 1. Funcao do lobby

Em ordem de importancia:

1. dizer em cinco segundos que jogo e este
2. segurar o jogador sem tedio durante a intermissao
3. deixar claro quando a proxima partida comeca e como entrar
4. permitir testar a mecanica de quebrar bloco antes de arriscar um round
5. reservar espaco visual para loja, missoes, recompensas e placar, sem construi-los

Se uma decisao de layout atrapalhar o item 1 ou o item 3, ela esta errada.

## 2. Direcao espacial

Ilha ou conjunto de ilhas flutuantes low poly. O material da ilha e o mesmo vocabulario da
arena: terra, grama, pedra, gelo e blocos rachados. Quem olha o lobby entende, sem ler
nada, que o chao deste jogo quebra.

A ilha flutuante tambem resolve um problema pratico: a borda do mapa e visivelmente um
abismo, e cair e um conceito que o jogador ja aprende no lobby, de graca e sem punicao.

### Zonas

| Zona | Funcao | Construir na fase |
| --- | --- | --- |
| Spawn central | ponto de chegada, orientacao inicial | 1 |
| Praca de espera | onde os jogadores ficam durante a intermissao | 1 |
| Portal de entrada | plataforma que leva a partida | 1 |
| Area de treino | 2 ou 3 blocos quebraveis sem consequencia | 1 greybox, 3 funcional |
| Mirante | ponto que enquadra a arena ao longe | 2 |
| Espaco de placar | superficie reservada, sem dado real | 1 como volume, 3 como tela |
| Espaco de loja | volume reservado e visualmente plausivel | 1 como volume |
| Espaco de missoes | volume reservado | 1 como volume |
| Espaco de recompensas | volume reservado | 1 como volume |

Volume reservado quer dizer: existe uma forma no espaco, ela ocupa area, ela ajuda a
composicao e ela nao tem sistema por tras. Nao vira funcionalidade so porque foi
desenhada.

## 3. Requisitos de leitura e seguranca

- do spawn, o jogador precisa enxergar o portal de entrada sem girar a camera
- a contagem para a proxima partida precisa ser legivel em tela de celular, e nao pode
  depender apenas de cor para indicar urgencia
- a borda do lobby tem barreira invisivel ou geometria que impede queda acidental. Cair do
  lobby por engano e frustracao pura, e nao ensina nada
- a area de treino e a unica parte do lobby onde o chao quebra
- cenario visualmente interessante mesmo com um unico jogador presente

## 4. Escala e circulacao

A escala precisa ser definida por medicao, nao por gosto. O criterio da fase 1 e:

- a travessia do spawn ate o portal leva entre 4 e 8 segundos de caminhada
- nenhum ponto do lobby exige pulo para ser alcancado
- a praca de espera comporta 8 personagens sem que eles se encostem

Se o lobby ficar grande demais, a intermissao vira caminhada. Se ficar pequeno demais, 8
jogadores viram um amontoado ilegivel.

## 5. Kit modular

O lobby nao e montado com pecas unicas. Ele e montado com um kit, e o kit e o entregavel
reaproveitavel.

Familias previstas na fase 2:

- chao, em pelo menos dois tamanhos de tile
- borda e quina de ilha
- parede baixa e barreira
- rocha, em tres volumes
- vegetacao, em duas ou tres silhuetas
- gelo, com variante rachada
- bloco rachado, os estagios de dano visual
- portal
- placa

Regra do kit: toda peca encaixa em grade. O tamanho da celula sera decidido na fase 1, a
partir da escala medida, e registrado em DECISIONS.md antes de qualquer modelagem.

## 6. Iluminacao

Estilizada, nao realista. Ceu colorido, sombra presente mas suave, contraste suficiente
para separar silhueta do fundo.

Proibido de forma explicita: branco estourado e bloom alto. Se o jogador precisa apertar
os olhos para achar a borda da plataforma, a iluminacao falhou.

## 7. Criterio de aceite do lobby

O lobby da fase 1 esta pronto quando:

- um jogador nasce, caminha ate o portal e volta, sem cair e sem travar
- a travessia medida cai na faixa de 4 a 8 segundos
- 8 personagens cabem na praca de espera sem sobreposicao
- a cena roda em celular dentro do orcamento de partes definido na fase 1
- a camera padrao enquadra o portal a partir do spawn
- o lobby pode ser reconstruido do zero a partir do repositorio, sem depender de um
  arquivo de place editado a mao que ninguem sabe reproduzir

O ultimo item e o mais facil de perder de vista e o mais caro de recuperar depois. Como
ele sera garantido, mapa gerado por codigo, modelo versionado ou mistura dos dois, e a
decisao pendente D-P01 em DECISIONS.md e precisa ser resolvida antes da fase 2.
