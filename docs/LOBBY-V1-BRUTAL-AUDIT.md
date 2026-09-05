# Auditoria brutal do Lobby V1

Data: 2026-09-05  
Place auditado: `C:\Users\ricka\Desktop\CrumbleArena\CrumbleArena.rbxl`  
Branch: `feat/lobby-art-pass`  
Estado ao encerrar: Roblox Studio em **Edit**, sem sondas temporárias  
Escopo: arquitetura, circulação, leitura visual, identidade, segurança, acessibilidade e custo do lobby atual. Nenhuma reconstrução V2 foi executada.

## Veredito

O lobby é tecnicamente mais sólido do que sua aparência sugere: está ancorado, suporta oito avatares, tem caminhos largos, barreira funcional, respawn funcional e uma hierarquia de instâncias razoavelmente legível. Porém, ainda não parece um lobby profissional de **Crumble Arena**. Parece um conjunto de módulos de simulador low-poly distribuídos igualmente ao redor de uma praça radial.

O problema central não é falta de decoração. É arquitetura sem prioridade: oito raios atribuem peso semelhante a mapa, loja, gamepasses, leaderboard, comunidade, parkour, treino e área social. A fonte ocupa o foco; o `CrumbleCore`, que deveria contar “o chão é a arma”, fica atrás do jogador no primeiro spawn e parcialmente escondido no nível dos olhos. Placas grandes e funções ainda indisponíveis competem por atenção antes de o jogador entender onde está e o que deve fazer.

O V1 deve ser tratado como uma fundação técnica reaproveitável, não como um layout final que precisa apenas de mais props.

## Portão de segurança e capacidade

- Diretório canônico confirmado: `C:\Users\ricka\Desktop\CrumbleArena`.
- Place aberto: `CrumbleArena.rbxl`, `PlaceId = 0`, raiz `Workspace.CrumbleArena`.
- Não é ClientStep, PromoteMe nem SkillLab.
- Arquivo canônico observado com 333.256 bytes, salvo em 2026-09-05 15:50:10.
- Backup novo, byte a byte igual ao canônico no início da auditoria: `backups\CrumbleArena-before-v2-audit-2026-09-05T1605.rbxl`.
- SHA-256 dos dois arquivos no checkpoint: `712E72694E1695B240616134482AADD3595183F48D76D0656C3777558FF2316D`.
- A auditoria começou em Edit, usou Play somente para testes descartáveis e terminou em Edit.
- Nenhuma alteração foi feita no backup, em `src/client`, `src/server`, `src/shared`, sistemas, publicação ou histórico Git.

## Método e limites

Foram usados inventário programático do DataModel, inspeção de propriedades, capturas em quatro quadrantes, verificações físicas com `GetPartsInPart`, um avatar real em Play, oito rigs R15 estáticos e oito rigs R15 em movimento simultâneo. Toda sonda temporária foi removida.

Limites que não foram escondidos:

- não havia emulador de aparelho móvel nesta integração; mobile foi avaliado por dimensões reais da GUI, escala calculada e leitura do controlador;
- o Studio recusou programaticamente `SavedQualityLevel` por falta da capacidade interna `RobloxScript`; a qualidade permaneceu `Automatic`, portanto não há resultado simulado de Low/High;
- as capturas são evidência visual pontual, não substituem teste com múltiplos jogadores humanos;
- contagens do lobby ativo excluem `ImportedAssets`, que é biblioteca/quarentena estacionada em `Y = -600`.

## Notas por categoria

Escala: 0 = inadequado; 10 = pronto para produção.

| Categoria | Nota | Diagnóstico curto |
| --- | ---: | --- |
| Arquitetura | 5,0 | Esqueleto claro, mas roda radial rígida e sem prioridade. |
| Circulação | 6,5 | Sete rotas passam; a rota oficial de Cosmetics bloqueia no balcão. |
| Escala | 6,0 | Caminhos bons; praça, placas e pavilhões superdimensionados. |
| Segurança física | 8,5 | Barreira e respawn funcionam; limite visual não coincide com o físico. |
| Acessibilidade | 5,5 | Larguras boas, mas navegação por controle e fechamento mobile frágeis. |
| Identidade Crumble Arena | 4,5 | O CrumbleCore existe, mas não governa a experiência. |
| Originalidade | 4,0 | Vocabulário de floating-island simulator e módulos de catálogo. |
| Direção de arte | 5,5 | Coerência cromática básica, pouca hierarquia e contraste semântico. |
| Iluminação | 6,5 | Limpa e legível; plana, homogênea e pouco memorável. |
| Materiais | 5,0 | Dez materiais, mas studs em 45,1% das peças criam ruído. |
| Decoração | 5,5 | Quantidade suficiente; repetição mecânica e distribuição por preenchimento. |
| Organização espacial | 5,0 | Quadrantes equilibrados em contagem, não em experiência. |
| Espera entre partidas | 4,0 | Campfire ajuda; mapa/treino/parkour não entregam atividade real. |
| Experiência social | 5,0 | Quatro cadeiras funcionais, insuficientes para oito jogadores. |
| Mobile | 5,0 | Botões principais aceitáveis; closes pequenos e painel no limite da largura. |
| Performance | 5,5 | Tudo ancorado, mas 1.785 partes e flags físicas excessivas. |
| Manutenibilidade | 6,0 | Hierarquia nomeada; alto volume e repetição aumentam custo de ajuste. |
| Expansão futura | 5,5 | Há espaço radial, mas ele já foi prometido a funções incompletas. |

**Nota geral ponderada: 5,5/10.**

### Percentuais de conclusão

- Fundação técnica: **72%**.
- Qualidade visual: **52%**.
- Prontidão jogável do lobby: **44%**.

Esses percentuais não são uma média estética. Segurança e capacidade elevam a fundação; rota bloqueada, áudio mudo, recursos de fachada e identidade insuficiente reduzem a prontidão.

## Arquitetura e fluxo

### O que funciona

- O anel central e os oito caminhos tornam destinos fisicamente legíveis de cima.
- Placas oficiais têm entre 15,1 e 20,6 studs de largura; um corredor de 16 studs deixa cerca de 8 studs livres para dois R15 lado a lado.
- Os degraus máximos entre segmentos são baixos: 0,045 a 0,664 stud.
- Oito rigs em movimento simultâneo percorreram 21,9 a 34,1 studs; a menor distância entre pares foi 22,66 studs, sem pares abaixo de 4 studs.
- O teste estático com oito rigs passou em dez posições de spawn, praça, caminhos e áreas, sem interpenetração.

### O que não funciona

- O desenho é uma roda perfeita: oito atrações independentes, oito acessos, quase a mesma importância visual.
- A praça central tem cerca de 84 studs de diâmetro útil e fica vazia no nível humano. Ela distribui pessoas, mas não cria encontro.
- A entrada força a leitura do grande EventBoard. O jogador nasce em `(0, 0,9, -18)`, orientado para `-Z`; a fonte e o CrumbleCore ficam atrás dele.
- Funções primárias e secundárias não têm hierarquia. Map Vote compete com Gamepasses e placas de “Coming Soon”.
- A ilha usa uma cerca/barreira circular sobre uma silhueta de células quadrada e irregular. O limite físico corta terreno que parece caminhável.
- Há rotas completas para Training e Parkour, embora esses recursos estejam adiados e guardados em `ServerStorage`.

### Tempos reais, sem pulo, a WalkSpeed 18

| Destino | Tempo | Resultado |
| --- | ---: | --- |
| EventBoard | 3,131 s | Passou |
| Gamepasses | 5,466 s | Passou |
| MapVote | 6,732 s | Passou |
| Leaderboard | 6,732 s | Passou |
| Training | 6,949 s | Passou |
| Parkour | 7,151 s | Passou |
| SocialArea | 9,183 s | Passou |
| Cosmetics | 8,800 s | **Falhou** no segmento 8 |

Um reteste direto do segmento 7 para o 8 também falhou. O avatar parou em aproximadamente `(-63,79, 6,10, -43,23)`, a 2,29 studs do centro final, contra o balcão/poste do quiosque. Isso é bloqueio físico confirmado, não inferência visual.

## Primeiros 30 segundos

O primeiro frame comunica, nesta ordem: HUD de intermission, EventBoard roxo, promessa de comunidade, “SOON” e uma ilha de simulador. Não comunica “Crumble Arena”.

Problemas concretos:

1. o HUD superior cobre parte da mensagem física do EventBoard;
2. o jogador começa de costas para o CrumbleCore;
3. a fonte esconde o emblema/rachaduras no nível dos olhos;
4. a direção “o chão é a arma” aparece como objeto decorativo isolado, não como regra do mundo;
5. três chamadas comerciais/informativas estão entre as maiores massas do horizonte;
6. a única atividade social real está a 9,18 s, no lado oposto, e não é visível como convite imediato.

Para um jogador solo, a espera oferece uma fogueira bonita, quatro assentos e leitura de placas. Para um grupo de oito, a geometria comporta o grupo, mas a atividade social comporta apenas quatro sentados e a praça separa mais do que reúne.

## Auditoria por quadrante

| Quadrante | Pontos fortes | Problemas |
| --- | --- | --- |
| NE — Gamepasses/MapVote | MapVote tem relação direta com o loop; caminhos largos. | Dois pavilhões grandes competem; Gamepasses anuncia produtos indisponíveis; rochas/gelo parecem catálogo. |
| NW — Cosmetics/Event | NPC e banca acrescentam vida; EventBoard é legível. | A banca está visualmente soterrada por árvores, toldo e pequenos props; rota bloqueada; EventBoard domina o spawn. |
| SE — MapVote/Parkour | Boa abertura de circulação. | Placa de Parkour domina em primeira pessoa apesar de o recurso estar adiado; espaço prometido sem entrega. |
| SW — Social/Training/Leaderboard | Fogueira e cadeiras são o trecho mais humano; leaderboard pode sustentar meta social. | Rochas e árvores bloqueiam vistas; Training indisponível ocupa uma área inteira; leaderboard é pesado e genérico. |

Cada quadrante foi registrado nas vistas aérea, jogador, direção ao centro e direção do centro. Algumas vistas externas mostram deliberadamente como cerca, rocha, placa ou árvore interrompem a leitura — não são tratadas como ângulos promocionais.

Densidade por posição central das peças:

| Região | BaseParts | Colidíveis |
| --- | ---: | ---: |
| NE | 355 | 202 |
| SE | 428 | 224 |
| SW | 453 | 217 |
| NW | 422 | 206 |
| Centro | 127 | 62 |

Os números são relativamente equilibrados, mas SW/NW são mais densos. O equilíbrio matemático não produz equilíbrio perceptivo: tamanho de placas, árvores no cone de visão e funções inativas pesam mais do que a contagem bruta.

## Bugs e defeitos confirmados

| ID | Severidade | Local | Defeito | Evidência |
| --- | --- | --- | --- | --- |
| V1-01 | Alta | `Areas.Cosmetics` / `PathCosmetics` | O centro da rota oficial termina contra o balcão/postes. | Duas travessias sem pulo falharam no segmento 8; captura `V1_Play_Cosmetics_PathBlocked`. |
| V1-02 | Alta | `SoundService.LobbyMusic` / `UIController` | A música inicia com `On = true`, mas `Playing = false`; só toca após clicar no toggle. | Medição em Play e leitura do trecho de áudio do controlador. |
| V1-03 | Média | Borda da ilha | Terreno visual existe além da barreira invisível circular. | 175 peças visíveis têm centro além do raio 124; 53 têm colisão. Avatar foi detido em raio 122,747 ao tentar alcançar raio 145. |
| V1-04 | Média | Spawn/EventBoard | HUD superior sobrepõe a comunicação física e o spawn olha para conteúdo secundário. | `V1_Play_FirstView` e `V1_Play_FirstPerson_Spawn`. |
| V1-05 | Média | Gamepad GUI | Não há vizinhança de seleção configurada. | 26 GuiButtons selecionáveis, 0 links `NextSelection*`, `GuiService.SelectedObject = nil`. |
| V1-06 | Média | Mobile GUI | Painel Cosmetics é ligeiramente maior que viewport estreito calculado; closes ficam pequenos. | Em 390x844, escala mínima 0,62; painel ≈396,8 px; closes ≈22,3 px. Inferência matemática, sem emulador. |
| V1-07 | Baixa | SFX | O toggle promete efeitos, mas `SoundGroup SFX` tem 0 filhos. | Inspeção do DataModel. |
| V1-08 | Baixa | `CentralFountain` | Três meshes usam `PreciseConvexDecomposition` apesar de `CanCollide = false`. | Inspeção de CollisionFidelity. |

### O que foi investigado e não é bug confirmado

- A varredura bruta encontrou 1.432 pares sobrepostos, 844 com colisão dos dois lados. A maioria é montagem intencional: camadas internas da ilha, anéis concêntricos e encaixes de degrau.
- 132 candidatos coplanares foram filtrados. Testes físicos exatos em `PlazaTile_04/05` e nos kerbs/planks da SocialArea não encontraram interseção 3D. Há costuras visíveis, mas nenhum z-fighting estático confirmado.
- A queda foi testada: `FallZone.Touched = true`, o personagem desceu a cerca de `Y = -250,38` e renasceu corretamente.
- As quatro cadeiras da fogueira são acessíveis e sentaram o avatar automaticamente em aproximadamente 0,8 s cada.
- Não há peça desancorada no lobby ativo.
- Não há colisor invisível inesperado; Spawn, FountainCollision, CollisionBox do NPC e 36 barreiras têm finalidade identificável.

## Inventário técnico e custos

### Lobby ativo, excluindo ImportedAssets

- 2.448 descendentes.
- 1.785 BaseParts: 1.549 `Part`, 227 `MeshPart`, 4 `WedgePart`, 4 `Seat` e 1 `SpawnLocation`.
- 911 peças com `CanCollide`, 1.516 com `CanTouch`, 1.398 com `CanQuery`, 1.694 com `CastShadow`.
- Entre as não colidíveis, 624 ainda têm `CanTouch` e 487 ainda têm `CanQuery`.
- 39 peças transparentes ainda têm `CanTouch`; 16 invisíveis ainda projetam sombra.
- 51 MeshIds únicos e 12 referências únicas de textura/superfície no lobby ativo.
- 805 tops com `Studs` e 980 `Smooth`: studs em 45,1% de todas as BaseParts.
- Materiais dominantes: Plastic 772, SmoothPlastic 685, WoodPlanks 97, Slate 80, Grass 68, Neon 32, Ground 23, Glass 15, Wood 8 e Ice 5.
- 7 luzes locais, 5 emitters, 8 beams e 1 `Fire`.

### Maiores centros de custo

| Conjunto | BaseParts | Descendentes | Observação |
| --- | ---: | ---: | --- |
| Island/Base | 254 | — | Camadas/células repetidas. |
| Island/Borders | 220 | — | 211 peças colidíveis. |
| Island/Paths | 192 | — | 64 colidíveis; oito caminhos completos. |
| Island/Cliffs | 185 | — | 185 colidíveis. |
| Props/Decor | 176 | — | 48 colidíveis; repetição visual. |
| Leaderboard | 63 | 375 | Aproximadamente 15,3% dos descendentes ativos do lobby. |
| Cosmetics | 148 | 178 | Inclui banca, NPC, acessórios e obstrução da rota. |
| SocialArea | 90 | 105 | Única área com interação social comprovada. |

O custo não vem de um mesh monstruoso isolado. Vem de milhares de pequenos elementos com sombra, toque e consulta ativados, além da repetição de células e bordas. Nomes recorrentes como `GrassCell` (109), `DirtCell` (101), `StoneUpper` (77), `LampEdge` (64), `FencePost` (48) e `RimChunk` (44) reforçam a aparência procedimental.

## Direção visual, genérico e identidade

### Genérico

- ilha gramada flutuante com cubos de grama/terra suspensos;
- árvores low-poly esféricas e rochas espalhadas;
- praça radial com fonte no centro;
- placas gigantes `LEADERBOARD`, `GAMEPASSES`, `COMING SOON` e `CHOOSE A MAP`;
- blocos de gelo/neon como acentos sem função de narrativa;
- oito módulos alinhados como catálogo em vez de um lugar vivido.

### Específico e recuperável

- o `CrumbleCore` e suas rachaduras;
- placas quebradas e fragmentos de borda;
- o campfire com cadeiras funcionais;
- o Shopkeeper/PIP, que é uma presença social própria;
- a ideia de votar em mapas antes da arena;
- studs como referência Roblox, desde que usados como acento e não como textura universal.

### Falha de coerência

O símbolo central não se propaga. As fissuras deveriam orientar trilhas, juntas, bordas, placas e enquadramentos. Hoje, cada área tem seu próprio miniestilo. O resultado é legível, mas sem uma frase visual comum.

## Iluminação e materiais

O ambiente atual está tecnicamente limpo: `Brightness 2.2`, `ClockTime 14.2`, sombras globais, atmosfera leve, bloom baixo, sun rays discretos e correção de cor controlada. O problema é artístico: sol de meio de tarde muito uniforme, verdes saturados, horizonte vazio e pouca separação de planos. Grandes objetos coloridos ganham destaque por saturação, não por função.

Studs em 45,1% das peças deixam de ser seletivos. No chão gramado e em algumas placas quebradas eles comunicam Roblox clássico; nos caminhos, praça e superfícies secundárias repetidas, viram ruído e competem com texto, fissuras e silhuetas.

## Áreas: decisão recomendada

| Área/elemento | Decisão | Motivo |
| --- | --- | --- |
| CrumbleCore | Manter e elevar | É o único símbolo diretamente ligado ao jogo. |
| Fonte | Manter, baixar e integrar | Boa qualidade; hoje encobre o Core. |
| MapVote | Manter e transformar em foco funcional | Liga a espera à partida. |
| Campfire/SocialArea | Manter, aproximar e ampliar | Único espaço realmente humano e funcional. |
| Shopkeeper/PIP | Manter | Dá personalidade; precisa de footprint novo. |
| Cosmetics | Mover e simplificar | Banca congestionada e rota bloqueada. |
| Leaderboard | Reduzir/reconstruir | Pode gerar meta social, mas está pesado e genérico. |
| EventBoard | Mover e reduzir | Informação secundária não deve dominar o primeiro frame. |
| Gamepasses | Integrar à loja | Pavilhão independente é grande demais e está inativo. |
| Training/Parkour | Adiar fisicamente | Conteúdo está em ServerStorage; duas áreas completas prometem o que não existe. |
| FutureFeatures | Remover | Duplica HUD e anuncia quatro funções indisponíveis. |
| Oito caminhos radiais | Substituir por três eixos | Hierarquia e navegação precisam de intenção. |
| Cubos flutuantes de grama | Reduzir/substituir | Remetem a template e não ao colapso do piso. |
| Cerca/barreira | Manter, realinhar | Segurança funciona; o limite deve coincidir com a borda visível. |

## Dez maiores problemas, em ordem

1. A arquitetura radial concede a mesma importância a tudo.
2. O primeiro frame vende EventBoard, não Crumble Arena.
3. A rota de Cosmetics é fisicamente bloqueada.
4. O CrumbleCore fica escondido e isolado da linguagem do resto do lobby.
5. Áreas grandes anunciam sistemas ainda indisponíveis.
6. A borda visual e a barreira invisível discordam.
7. 1.785 peças e flags físicas/sombras excessivas custam mais do que a cena aparenta.
8. Studs em quase metade das peças produzem ruído, não identidade seletiva.
9. A espera oferece pouca atividade para oito jogadores apesar da boa capacidade geométrica.
10. A GUI não tem navegação explícita por gamepad e fica no limite em mobile estreito.

## Evidências produzidas

### Baseline

- `V1_Audit_Initial_Spawn`
- `V1_Audit_Initial_North`
- `V1_Audit_Initial_South`
- `V1_Audit_Initial_East`
- `V1_Audit_Initial_West`

### Quadrante NE

- `V1_Q_NE_Aerial`
- `V1_Q_NE_Player`
- `V1_Q_NE_ToCenter`
- `V1_Q_NE_FromCenter`

### Quadrante NW

- `V1_Q_NW_Aerial`
- `V1_Q_NW_Player`
- `V1_Q_NW_ToCenter`
- `V1_Q_NW_FromCenter`

### Quadrante SE

- `V1_Q_SE_Aerial`
- `V1_Q_SE_Player`
- `V1_Q_SE_ToCenter`
- `V1_Q_SE_FromCenter`

### Quadrante SW

- `V1_Q_SW_Aerial`
- `V1_Q_SW_Player`
- `V1_Q_SW_ToCenter`
- `V1_Q_SW_FromCenter`

### Defeitos e Play

- `V1_Defect_SocialPathDeckSeam`
- `V1_Defect_PlazaTileSeams`
- `V1_Defect_CosmeticsClutter`
- `V1_Defect_BarrierBeyondFence`
- `V1_Play_Cosmetics_PathBlocked`
- `V1_Play_FirstView`
- `V1_Play_FirstPerson_Spawn`

### Capacidade

- `V1_Audit_8Rigs_SocialCapacity`
- `V1_Audit_8Rigs_Plaza`
- `V1_Audit_8Rigs_Distributed`
- `V1_Play_8Rigs_Moving`

### Encerramento

- `V1_Audit_Final_Edit`

As duas capturas de seams documentam candidatos visuais; como os testes físicos exatos não confirmaram interseção 3D ou flicker, elas não foram promovidas a bugs.

## Conclusão

Não é necessário demolir tudo, e também não é honesto chamar o V1 de quase pronto. A estrutura técnica, o Core, a fonte, o campfire, o NPC e partes do conteúdo podem ser reutilizados. O layout, a hierarquia e a silhueta da ilha precisam de recomposição consciente. A proposta oficial está em `docs/LOBBY-V2-PROPOSAL.md`; nenhuma parte dela foi construída sem aprovação.
