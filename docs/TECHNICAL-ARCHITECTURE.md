# Arquitetura tecnica

Estado: arquitetura decidida, implementacao nao iniciada. Nenhum servico listado aqui
existe em codigo hoje. Este documento define o contrato que a implementacao tera que
respeitar, nao descreve algo pronto.

## 1. Regra de autoridade

O cliente pede, o servidor decide. Sem excecao.

O servidor e a unica autoridade sobre: estado do round, quem esta vivo, quais blocos
existem, quanto dano cada bloco tem, quem quebrou o que, quem foi eliminado e quem venceu.

O cliente e responsavel por: interface, camera, animacao, particula, som, previsao visual
de curta duracao e envio de intencao.

Nunca confiar em: posicao enviada pelo cliente, resultado de colisao enviado pelo cliente,
identificador de bloco sem revalidacao, dano calculado no cliente, tempo medido no cliente.

### O que isso significa para a quebra de bloco

O cliente envia a intencao "quebrei em direcao a este bloco com esta ferramenta". O
servidor valida, nesta ordem, e recusa em silencio no primeiro erro:

1. formato e tipo dos argumentos
2. o remetente e um jogador vivo no round ativo
3. o estado da partida permite acao
4. a ferramenta esta realmente equipada segundo o servidor
5. o bloco existe na grade do servidor
6. a distancia real entre o personagem e o bloco cabe no alcance da ferramenta
7. o cooldown daquela ferramenta para aquele jogador ja passou
8. o jogador nao passou do limite de acoes por janela de tempo

Somente depois disso o servidor aplica dano e replica o resultado.

## 2. Rede

Todos os RemoteEvents e RemoteFunctions ficam declarados em um unico lugar, criado pelo
servidor no boot e apenas lido pelo cliente. Cliente nunca cria remote.

Cada remote tem, obrigatoriamente:

- um validador de formato dos argumentos, que roda antes de qualquer logica
- um rate limit por jogador, com janela e teto explicitos
- um comportamento de recusa definido, que por padrao e ignorar sem responder

Regra de granularidade: replicar mudanca de estado agregada por frame de rede, nao um
evento por bloco quebrado. Uma rajada de bola de neve nao pode virar uma rajada de
pacotes.

Nunca enviar ao cliente informacao que ele nao precisa para desenhar a tela. Se um dado
so serve para decidir, ele fica no servidor.

## 3. Representacao da arena

A arena e uma grade logica de coordenadas inteiras. A posicao em studs e derivada, nunca
armazenada como verdade.

Motivos:

- reconstrucao deterministica entre rounds, a partir de uma semente
- comparacao barata para validar alcance e vizinhanca
- possibilidade de trocar o tamanho do bloco sem reescrever regra

O tipo `GridPosition` ja esta declarado em `src/shared/Types`. A conversao de grade para
mundo e responsabilidade exclusiva do servidor.

### Reconstrucao deterministica

Dada a mesma semente e a mesma definicao de arena, o layout gerado precisa ser identico.
Isso permite testar a geracao no Lune, sem Studio, e permite que servidor e cliente
concordem sobre o layout inicial sem transmitir bloco por bloco.

## 4. Tags e atributos

`CollectionService` para pertencimento: marcar o que um sistema deve enxergar, por exemplo
blocos destrutiveis, pontos de spawn do lobby, zonas de eliminacao.

`Attributes` para configuracao de instancia: valores que variam por objeto, por exemplo o
material do bloco e o estagio de dano atual.

Nao usar tag como se fosse enum de estado que muda toda hora. Tag entra e sai pouco,
atributo muda com frequencia.

## 5. Desempenho, considerado desde o inicio

O risco central do jogo e contagem de partes. Uma arena de blocos gera muita parte, e
celular e o alvo prioritario.

Restricoes assumidas agora:

- orcamento de partes da arena precisa ser medido antes da fase 4 terminar, nao depois
- bloco destruido nao vira debris fisico persistente por padrao
- efeito de quebra e visual e de vida curta, nao simulacao
- `StreamingEnabled` sera avaliado na fase 4, quando existir arena real para medir
- textura de gameplay em 256, 512 ou 1024, nunca 4K
- audio nao e pre-carregado em catalogo inteiro, so o que a cena usa

Nenhum destes numeros foi medido ainda. Eles sao teto de projeto, e a medicao real e
criterio de aceite da fase 4.

## 6. Entrada

Suporte a mouse e teclado, toque e gamepad. A acao e vinculada de forma abstrata, e cada
dispositivo mapeia para a mesma acao, em vez de cada sistema ler o dispositivo direto.

A interface de toque nao pode cobrir a area onde o jogador precisa olhar para decidir onde
pisar. Isso e requisito de leitura, nao preferencia estetica.

## 7. Organizacao de codigo

```text
src/shared/Config/    numeros de balanceamento, um lugar so
src/shared/Types/     contratos de tipo, sem logica
src/shared/Util/      funcoes puras reaproveitaveis
src/server/Services/  autoridade de longa duracao, uma responsabilidade cada
src/server/Systems/   logica de simulacao chamada pelos services
src/client/Controllers/ intencao e leitura de entrada
src/client/UI/        composicao de tela
src/client/Effects/   particula, som e camera
```

Modulos em `src/shared/Config` e `src/shared/Types` nao usam `game`, `workspace`,
`Instance`, `task` nem qualquer API do Roblox, e nao usam `require`. E isso que permite
carrega-los no Lune. Quebrar essa regra quebra os testes.

## 8. O que fica reservado sem ser construido

Ponto arquitetural reservado significa: a decisao de onde aquilo vai entrar esta tomada, e
nenhuma linha foi escrita.

- persistencia de jogador: entra por um unico service de dados, e nenhum outro sistema le
  ou escreve DataStore direto
- monetizacao: entra por um unico ponto de checagem de posse, e nenhum sistema de gameplay
  consulta a loja direto
- analytics: entra por um unico emissor de evento, e nenhum sistema chama o servico direto

Reservar esses tres pontos custa quase nada agora e evita retrabalho real depois. Qualquer
coisa alem disso nao se reserva, se decide na hora.
