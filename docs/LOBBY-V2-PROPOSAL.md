# Proposta de Lobby V2 — Crumble Refuge

Data: 2026-09-05  
Status: proposta, não construída  
Recomendação oficial: **intervenção recomendada**

## Frase-conceito

**Uma doca de preparação construída sobre o último fragmento estável de um mundo que já começou a desmoronar.**

Essa frase deve responder todas as decisões: o jogador chega a um refúgio funcional, vê o chão quebrado como ameaça e identidade, escolhe o próximo mapa e encontra outras pessoas antes de ser lançado à arena.

## Objetivos

1. Fazer o primeiro frame dizer “Crumble Arena” sem depender do nome na GUI.
2. Trocar oito destinos equivalentes por três eixos com prioridades claras.
3. Transformar o CrumbleCore em centro narrativo e de navegação.
4. Concentrar funções comerciais em uma área compacta.
5. Tornar a espera social e ligada ao loop de partida.
6. Fazer o limite físico coincidir com o limite visual.
7. Reduzir custo de peças, sombras, toque e consulta sem empobrecer a cena.
8. Preservar o que já é tecnicamente seguro e visualmente específico.

## Opções de intervenção

### 1. Conservadora

Mantém a ilha e a praça radial. Gira o spawn para o centro, desobstrui Cosmetics, remove o quadro FutureFeatures, reduz placas e props, desativa flags físicas desnecessárias e suaviza o uso de studs.

- Retrabalho: baixo.
- Risco: baixo.
- Ganho: corrige bugs e ruído, mas mantém o principal problema arquitetônico.
- Quando escolher: se o lobby precisar ser fechado imediatamente sem janela para recomposição.

### 2. Recomendada — Crumble Refuge

Recompõe a ilha como um refúgio assimétrico com uma espinha principal, duas alas e um centro quebrado. Reutiliza CrumbleCore, fonte, MapVote, campfire, NPC e parte da vegetação/rochas. Consolida Gamepasses em Cosmetics, reduz Leaderboard e transforma Training/Parkour em uma única promessa ambiental na borda.

- Retrabalho: médio.
- Risco: controlável por marcos reversíveis.
- Ganho: resolve arquitetura, fluxo, identidade, segurança visual e custo ao mesmo tempo.
- Quando escolher: opção oficial; melhor razão entre impacto, risco e reaproveitamento.

### 3. Radical

Reconstrói silhueta, topologia, todos os pavilhões e linguagem de props. Mantém somente Core, campfire, NPC e assets aprovados como matéria-prima.

- Retrabalho: alto.
- Risco: alto para cronograma e integração futura.
- Ganho: teto visual maior, mas desnecessário antes de os sistemas principais existirem.
- Quando escolher: somente se houver nova direção de arte, referências fechadas e tempo de produção dedicado.

## Planta recomendada

Orientação proposta: spawn ao sul; progressão visual para o norte.

```text
                       NORTE / saída para a partida

                  [ MAP VOTE + PORTAL/LAUNCH ]
                             32 x 18
                                │
                       passarela quebrada
                           18–20 studs
                                │
         [ SOCIAL ] ───── [ CRUMBLE CORE ] ───── [ STATS ]
        fogo + 6/8        praça 58 x 46       leaderboard
        assentos            + fonte baixa       28 x 16
             │                   │                    │
     [ COSMETICS + PIP ]         │           [ EVENTO COMPACTO ]
      passes integrados          │              lateral
             └────────── praça de chegada ───────────┘
                                │
                       [ SPAWN / 18 x 18 ]
                                SUL

        Borda oeste: portão ambiental “em construção” para expansão.
        Borda leste: vista limpa para fragmentos distantes do mundo.
```

O desenho não exige um círculo perfeito. A silhueta pode medir aproximadamente 230 x 190 studs, com a área útil inteira dentro da barreira. Pequenas extensões visuais fora do limite devem ser claramente rocha/cliff não caminhável, nunca grama plana convidativa.

## Hierarquia de leitura

### Primeiro plano — 0 a 5 segundos

- O personagem nasce voltado para o CrumbleCore.
- Uma fissura principal no piso sai do spawn e aponta ao centro.
- A fonte fica baixa e parcialmente abraça o Core; não o esconde.
- O MapVote aparece enquadrado atrás do Core como próximo objetivo.

### Segundo plano — 5 a 15 segundos

- SocialArea acesa à esquerda, com fogo, silhuetas de assento e NPC/loja próximos.
- Leaderboard compacto à direita, visível mas não dominante.
- Uma placa pequena de evento/comunidade fica lateral à chegada.

### Terceiro plano — 15 a 30 segundos

- Bordas rachadas, vigas de reparo, cabos e fragmentos distantes contam que o refúgio é provisório.
- Um único portão fechado sinaliza Training/Parkour futuros sem oferecer duas rotas mortas.
- MapVote é a ação mais clara enquanto a partida não começa.

## Circulação

### Eixo principal

Spawn → CrumbleCore → MapVote/lançamento.

- Largura alvo: 18 a 20 studs.
- Distância spawn–Core: 28 a 34 studs.
- Distância Core–MapVote: 34 a 42 studs.
- Tempo alvo a WalkSpeed 18: 3 a 5 s até o centro; 6 a 8 s até MapVote.
- Sem prop, poste, balcão ou desnível dentro de uma faixa central contínua de 12 studs.

### Ala social/comercial

Core → campfire → Cosmetics/PIP.

- Caminho de 16 a 18 studs.
- O campfire deve estar a no máximo 4 s do centro.
- Seis a oito lugares: quatro cadeiras existentes mais dois bancos/low walls; pelo menos dois espaços livres para avatares em pé.
- Passes vivem como prateleira/cartaz dentro da loja, não como pavilhão independente.

### Ala de status

Core → Leaderboard compacto → EventBoard lateral.

- Leaderboard não maior que 28 x 16 studs de footprint.
- Avatar de primeiro lugar é opcional e só permanece se for atualizado com dados reais, seguro e barato.
- Evento usa uma face legível e conteúdo curto; não deve ficar alinhado ao eixo do spawn.

## Arquitetura e silhueta

- Centro: placas grandes quebradas com juntas radiais assimétricas, não cinco anéis perfeitos.
- Edificações: linguagem de “refúgio reparado” — madeira de suporte, pedra reaproveitada, placas aparafusadas e pequenas vigas.
- Bordas: cliffs recortados e rachaduras que apontam ao vazio. A barreira invisível acompanha a borda real.
- Horizonte: três a cinco fragmentos distantes grandes e identificáveis, sem cubos de grama aleatórios.
- Alturas: sinais abaixo da linha das copas; uma única massa vertical principal por ala.
- Vegetação: grupos intencionais, com espaços de respiro e vistas preservadas. Nenhuma árvore no cone spawn–Core–MapVote.

## Identidade Crumble

O CrumbleCore não é apenas uma escultura. Sua gramática deve reaparecer em:

- uma fissura guia no eixo principal;
- duas ou três placas de piso deslocadas junto às alas;
- recortes da borda e pequenos vazios entre slabs;
- formato dos suportes de placa;
- luz ciano/verde muito controlada nas profundidades das rachaduras;
- fragmentos de pedra em vez de blocos de grama flutuantes;
- mensagens curtas relacionadas a estabilidade, rodada e mapa.

Evitar lava genérica, excesso de neon, perigo vermelho em toda parte e rachadura aplicada como decal aleatório.

## Materiais e studs

Studs deixam de ser textura universal e passam a ser assinatura seletiva.

| Superfície | Tratamento |
| --- | --- |
| Grama caminhável | Studs em áreas amplas, com cor menos neon. |
| Eixo principal | Faixas alternadas: pedra lisa + duas linhas de studs como guia. |
| Praça quebrada | Predominantemente Slate/Concrete; studs em 20–30% das slabs. |
| Madeira | Wood/WoodPlanks sem studs. |
| Faces verticais | Smooth, salvo detalhe deliberado de construção. |
| Props pequenos | Smooth para reduzir ruído. |
| CrumbleCore | Slate/Concrete, emissivo apenas dentro das fissuras. |

Meta: reduzir TopSurface Studs de 45,1% para aproximadamente 18–25% das BaseParts ativas.

## Cor e iluminação

Paleta proposta:

- grama: verde médio levemente dessaturado;
- pedra: cinza-azulado quente, com três valores claros;
- madeira: castanho médio, sem laranja dominante;
- identidade: ciano frio nas fissuras e amarelo quente no campfire/lâmpadas;
- placas: carvão/azul-marinho, branco quente e uma cor funcional por área.

Luz:

- manter atmosfera clara e legível;
- deslocar o sol para produzir sombra lateral que revele volumes e rachaduras;
- reduzir uniformidade do verde com contraste de valor, não bloom;
- usar iluminação local somente no Core, campfire e pontos de navegação;
- preservar leitura em qualidade baixa mesmo sem sombras avançadas: silhueta e cor devem bastar.

## Conteúdo por área

### CrumbleCore + fonte

Manter ambos. Baixar a fonte, abrir uma face para o spawn e permitir que o bloco rachado ultrapasse a silhueta da água. O Core deve ser a primeira massa específica vista pelo jogador.

### MapVote

Manter como destino primário. Reorganizar os três cards em uma estrutura mais baixa; quando houver sistema, usar imagens reais dos mapas e feedback de voto. Antes disso, não fingir interatividade.

### SocialArea

Mover para perto do centro e reduzir o deck. Manter a fogueira e as quatro cadeiras funcionais; completar capacidade com assentos simples do próprio kit visual. Garantir circulação atrás das cadeiras e visão do timer/MapVote.

### Cosmetics, PIP e Gamepasses

Manter NPC e conceito de mercado. Recriar o balcão com entrada lateral clara e uma faixa livre de 12 studs. Integrar passes em uma parede/prateleira interna. Remover o pavilhão independente de Gamepasses enquanto seus produtos estiverem indisponíveis.

### Leaderboard

Reconstruir em escala menor e modular. Mostrar dados reais ou estado vazio honesto; não dez jogadores fictícios permanentes. Preservar a ideia da skin do líder somente se o custo e a atualização forem validados.

### EventBoard

Reduzir e mover para uma lateral do spawn. Uma chamada, um benefício, um estado. O timer do HUD nunca deve cobrir sua mensagem.

### Training e Parkour

Continuam em `ServerStorage`. Remover da ilha os dois pavilhões e seus caminhos completos. Usar um único portão de obra/fragmento distante para sugerir expansão futura.

### FutureFeatures

Remover. Settings já está na GUI; Daily Reward, Quests e Codes não precisam ocupar arquitetura antes de existirem.

## Segurança e acessibilidade

- A faixa caminhável deve terminar visualmente antes da barreira.
- O anel de segurança acompanha a nova silhueta; `FallZone` e respawn permanecem.
- Caminhos principais ≥18 studs; secundários ≥16 studs.
- Nenhum caminho termina em balcão, parede, árvore, rocha ou assento.
- Cor não deve ser o único indicador de área/estado; usar ícone, texto curto e forma.
- Guias de foco do gamepad e tamanhos mobile são trabalho de GUI separado; o V2 não deve criar novas dependências de HUD.
- Placas físicas devem ser avaliadas no nível dos olhos, não apenas em captura aérea.

## Orçamento técnico alvo

| Métrica | V1 | Meta V2 recomendada |
| --- | ---: | ---: |
| BaseParts ativas | 1.785 | 1.150–1.350 |
| Descendentes ativos | 2.448 | ≤1.900 |
| Studs em BaseParts | 45,1% | 18–25% |
| Não colidíveis com CanTouch | 624 | <120 |
| Não colidíveis com CanQuery | 487 | <160 |
| Peças com CastShadow | 1.694 | <900, priorizando massas grandes |
| Caminhos radiais completos | 8 | 3 eixos legíveis |
| Assentos sociais | 4 | 6–8 |
| Placas “Coming Soon” grandes | 5+ mensagens | 1 marcador compacto |

As metas são guardrails, não licença para remover detalhe útil. A validação visual decide junto com a medição.

## Comparação V1 / V2

| Critério | V1 | V2 recomendada |
| --- | --- | --- |
| Primeiro foco | EventBoard | CrumbleCore + MapVote |
| Organização | 8 raios equivalentes | 1 eixo principal + 2 alas |
| Centro | Fonte em praça circular vazia | Core legível em praça quebrada compacta |
| Social | Longe, 4 cadeiras | Perto do centro, 6–8 lugares |
| Comércio | Cosmetics e Gamepasses separados | Um mercado compacto com PIP |
| Futuro | 2 áreas + quadro de promessas | 1 portão ambiental discreto |
| Limite | Barreira sobre terreno aparentemente caminhável | Borda visual e física coincidentes |
| Studs | Quase metade das peças | Assinatura em 18–25% |
| Performance | 1.785 partes, muitas flags ativas | 1.150–1.350, flags intencionais |
| Identidade | Core isolado | Rachadura como linguagem do mundo |

## Decisão recomendada

Aprovar a opção **Recomendada — Crumble Refuge**. Ela preserva o esqueleto útil e os melhores assets, mas não tenta resolver arquitetura com mais decoração. A construção só deve começar após aprovação explícita, seguindo `docs/LOBBY-V2-BUILD-PLAN.md` e checkpoints de salvamento manual.

