# Crumble Arena, plano mestre

Documento de direcao. Se outro documento contradisser este, este vale.

## 1. Contexto de negocio

`StudioName: TBD`. O estudio produzira varios jogos Roblox. O nome definitivo ainda nao
foi escolhido e nao deve ser inventado. Cada jogo tera nome, identidade visual, comunidade,
loja e monetizacao proprios. O que se compartilha entre jogos e infraestrutura tecnica,
nunca conteudo.

Crumble Arena e o primeiro titulo. Alem de ser um jogo, ele tem a funcao de criar e provar
a base de producao: estrutura de repositorio, toolchain, pipeline de assets, padroes de
codigo, criterios de aceite e ritmo de sessao.

Consequencia pratica: quando houver escolha entre uma solucao especifica do Crumble Arena
e uma solucao reaproveitavel de custo parecido, escolhe-se a reaproveitavel. Quando a
solucao reaproveitavel custa muito mais, escolhe-se a especifica e registra-se a divida.

## 2. O jogo em uma frase

Ate 8 jogadores em uma arena de blocos destrutiveis. Voce quebra o chao sob os pes dos
outros. Quem cair, sai. Quem sobrar, ganha o round.

## 3. Pilares

Toda funcionalidade proposta precisa reforcar pelo menos um destes pilares.

**P1. O chao e a arma.** A decisao interessante nunca e mirar melhor, e escolher qual bloco
quebrar e quando. O terreno e recurso finito, e gastar terreno tem custo para quem gasta.

**P2. Leitura imediata.** Um jogador que nunca viu o jogo entende em cinco segundos o que
esta acontecendo, quem esta vivo e onde e perigoso pisar. Silhueta grande, cor legivel,
sem informacao essencial transmitida so por cor.

**P3. Partida curta e repetivel.** O ciclo termina rapido e recomeca sem atrito. Perder
custa pouco tempo, entao arriscar e barato.

**P4. Funciona no celular.** Controle, camera, interface e desempenho sao projetados para
tela pequena e dedo, nao adaptados depois.

## 4. Conceito registrado

Estado: conceito aprovado, implementacao nao iniciada.

- Ate 8 jogadores por servidor, minimo de 2 para iniciar
- Partida dividida em rounds
- Arena com multiplas camadas verticais
- Blocos destrutiveis com resistencia por material
- Eliminacao ao cair abaixo da arena
- Jogador eliminado vira espectador ate o fim do round
- Ultimo jogador vivo vence o round
- Arena reconstruida entre rounds, de forma deterministica
- Controles simples, faceis de aprender, com teto de habilidade
- Prioridade de compatibilidade: computador e celular
- Visual low poly colorido e legivel
- Feedback visual e sonoro forte em cada quebra e cada eliminacao

### Materiais de bloco

Quatro no lancamento: Terra, Grama, Pedra, Gelo. Cada material tem resistencia propria e
estagios visuais de dano. Os numeros de resistencia e a quantidade de estagios ainda nao
foram decididos, ver decisoes pendentes em DECISIONS.md.

### Ferramentas

Tres no lancamento:

| Ferramenta | Alvo | Papel |
| --- | --- | --- |
| Picareta | Pedra e Gelo | quebra por contato o material duro |
| Pa | Terra e Grama | quebra por contato o material mole |
| Bola de neve | qualquer bloco, a distancia | quebra fraco e aplica pequeno impulso no jogador |

A bola de neve e a unica ferramenta que interage com o corpo do adversario, e o impulso e
pequeno de proposito: ela reposiciona, nao mata. Quem mata e a queda.

## 5. Limites de escopo

O que este projeto explicitamente nao faz agora:

- nao implementa DataStore, loja, gamepass, produto, missao ou analytics na fase 0 a 6
- nao cria modulo vazio para aparentar arquitetura
- nao constroi a segunda arena antes da primeira estar divertida
- nao copia mapa, personagem, interface, nome, som ou asset de Minecraft, Tumble,
  Happy Wars ou qualquer outro jogo
- nao usa Happy Wars como nome de projeto, produto ou pasta. O jogo inspirado naquela
  memoria sera propriedade intelectual propria e separada, em outro repositorio

Antes de aceitar qualquer funcionalidade nova, responda: ela reforca um pilar, cabe na
fase atual, gera decisao interessante para o jogador, funciona no celular e pode ser
testada? Se a maioria for nao, fica de fora e vai para DECISIONS.md como ideia recusada.

## 6. Decisao de producao: comecar pelo lobby

O lobby e a primeira entrega e nao e sala de espera descartavel. Ele estabelece a
identidade visual, o kit modular de construcao, o sistema de spawn, a estrutura de
interface, a iluminacao e a organizacao de assets. O que for construido ali vira base
reaproveitavel para os proximos jogos do estudio.

Reaproveitamento significa componente e sistema, nao mapa. Outro jogo usa o mesmo kit
modular e o mesmo fluxo de intermissao, e monta um mapa diferente. Ver LOBBY-SPEC.md.

## 7. Direcao visual

Low poly, cartoon, colorido, limpo, legivel, original e coerente. Formas grandes com boa
silhueta.

O que evitar de forma explicita: realismo, iluminacao branca estourada, excesso de bloom,
e a aparencia de mapa montado com modelos aleatorios de pacotes diferentes.

O teste de coerencia e simples: o lobby precisa parecer o mesmo universo da arena. Se um
objeto do lobby nao caberia visualmente dentro de uma partida, ele esta errado.
