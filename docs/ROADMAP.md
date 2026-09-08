# Atualizacao de transicao, 2026-09-07

O detalhamento abaixo e o plano historico. D-008 e D-025 revogam referencias a
portal e remontagem integral obrigatoria do lobby. Nao usar esses criterios antigos
para iniciar redesign. Current-state e o estado recente; fases nao foram revalidadas aqui.

Proximo marco proposto, sem features: baseline revisada, checkpoint aprovado,
experiencia privada/IDs, dois colaboradores confirmados, writer ao vivo e gate Rojo.
Aceite: os dois abrem o mesmo Place, entendem handoff, nao ha dupla sincronizacao,
backup recuperavel e codigo/GUI sem duplicacao. Entao retomar fases de gameplay.
Publicacao privada de colaboracao nao equivale ao lancamento da fase7.

# Roadmap

Uma fase so termina quando o criterio de aceite dela e demonstrado com evidencia. Nao
existe fase parcialmente concluida: ou o criterio foi atendido, ou a fase continua aberta.

Vocabulario obrigatorio nos relatorios: **implementado**, **testado**, **parcialmente
testado**, **planejado**. Nunca apresentar planejado como concluido.

---

## Fase 0, fundacao

**Estado: concluida em 2026-09-03.**

- auditoria do ambiente
- criacao da fonte de verdade em `docs/`
- estrutura do repositorio
- configuracao do toolchain
- inventario de assets
- definicao dos criterios de aceite

**Criterio de aceite, atendido:** `rojo build` gera place valido, `stylua --check` passa,
`selene` passa em `src` e em `tests`, o teste puro do Lune passa, e o MVP anterior esta
preservado com hash conferido.

---

## Fase 1, greybox do lobby

**Estado: parcialmente concluida em 2026-09-03.** Feito: ilha, praca, spawn, caminhos,
limites, volumes de todas as areas, parkour, area social, iluminacao, circulacao testada e
composicao visual com assets aprovados. Falta: salvar o place, resolvendo D-P02, e o teste
em celular real.

- criar e salvar o place do Crumble Arena, resolvendo D-P02
- decidir o tamanho da celula da grade a partir de medicao, resolvendo D-P03
- spawn, limites e barreira de borda
- plataforma central e praca de espera
- volume do portal de entrada
- volume da area de treino
- volumes reservados de loja, missoes, recompensas e placar
- teste de camera
- teste em celular

**Criterio de aceite:** travessia do spawn ate o portal entre 4 e 8 segundos medidos, 8
personagens cabem na praca sem sobreposicao, nenhum ponto exige pulo, ninguem cai por
acidente, contagem de partes registrada, e um video ou sequencia de capturas do percurso.

---

## Fase 2, kit visual modular

Depende de D-P01 e D-P03 resolvidas.

- chao, borda, parede, rocha, vegetacao, gelo, bloco rachado, portal, placa
- decoracao
- iluminacao estilizada

**Criterio de aceite:** o lobby inteiro remontado com pecas do kit, sem peca unica; teste
de coerencia visual, ou seja, cada peca do lobby caberia dentro de uma partida; contagem
de partes e de triangulos dentro do orcamento da fase 1.

---

## Fase 3, lobby funcional

- intermissao e contagem regressiva
- estado dos jogadores presentes
- entrada em partida
- area de treino com blocos que realmente quebram
- interface basica
- feedback sonoro e visual

**Criterio de aceite:** dois clientes veem a mesma contagem, entram na partida e a
intermissao reinicia sozinha; quebrar bloco no treino nao afeta o estado do lobby de
ninguem mais.

---

## Fase 4, prototipo da arena

- grade de blocos e multiplas camadas
- resistencia por material, resolvendo D-P04
- destruicao e reconstrucao deterministica
- area de eliminacao
- spawns seguros

**Criterio de aceite:** mesma semente gera arena identica, verificado por teste puro no
Lune; queda abaixo da arena elimina; arena reconstroi entre rounds sem sobra de bloco;
orcamento de partes medido em celular com a arena cheia.

---

## Fase 5, ferramentas

- picareta, pa e bola de neve
- validacao no servidor, incluindo alcance e cooldown, resolvendo D-P05
- recargas
- feedback de impacto
- controles mobile

**Criterio de aceite:** cliente adulterado nao consegue quebrar bloco fora de alcance, nem
mais rapido que o cooldown, nem sem a ferramenta equipada. Isso e testado tentando burlar,
nao apenas jogando certo.

---

## Fase 6, sistema de rounds

- intermissao, preparacao, partida ativa, eliminacao, espectador, vitoria, resultado e
  reinicio, resolvendo D-P06

**Criterio de aceite:** partida completa de ponta a ponta com 2 e com 4 clientes, incluindo
o caso do ultimo jogador sair no meio do round e o caso de dois jogadores caindo no mesmo
instante.

---

## Fase 7, polimento e publicacao

- interface definitiva, audio, VFX, tutorial
- segunda arena
- testes multiplayer, desempenho
- monetizacao inicial, analytics
- publicacao controlada

**Criterio de aceite:** definido no inicio da fase 7, nao agora. Definir criterio de
publicacao com um ano de antecedencia produz criterio inutil.
