# Auditoria completa do lobby

Aberta em 2026-09-04, sessao 008, a pedido do Rick. O objetivo e fechar a fundacao do
lobby antes de comecar o sistema de rounds.

**Estado: Checkpoint A executado em 2026-09-05.** A ponte MCP voltou as 03:20, depois que o
painel Assistant foi aberto na janela do Studio. As medicoes abaixo sao desta sessao, no
place aberto, e nao de sessao anterior.

---

## 1. Metodologia

Cada criterio recebe um peso e um dos tres resultados:

| Resultado | Quando | Vale |
| --- | --- | --- |
| Aprovado | tem medicao registrada nesta auditoria, no place aberto | peso cheio |
| Parcial | tem medicao, mas cobre so parte do criterio | metade do peso |
| Reprovado | falhou, ou nunca foi medido | zero |

Duas regras que mudam o numero:

1. **Decoracao adiantada nao substitui teste obrigatorio.**
2. **Medicao de sessao anterior vale como Parcial, nao Aprovado.**

Uma terceira regra saiu desta sessao, e custou caro para aprender:

3. **Sonda nao e medida.** Quatro achados desta sessao foram falso positivo da propria
   ferramenta de medicao. Toda medida por raio precisa ser conferida contra o que a peca
   atingida realmente e. Ver a secao 7.

---

## 2. Preparacao

| Item | Resultado | Evidencia |
| --- | --- | --- |
| Arquivo canonico confirmado | ok | `CrumbleArena.rbxl`, 320.251 bytes, 2026-09-05 03:18 |
| Studio em modo Edit | ok | `get_studio_state` |
| `Workspace.CrumbleArena.Lobby` | ok | 6 pastas, 1.769 BaseParts |
| Backups existem | ok | 4 arquivos de place em `backups` |
| Place salvo antes de comecar | ok | log do Studio: `saveDataModelToLocalFile succeeded in 79 ms` |
| Capturas iniciais | parcial | 4 capturas, antes da janela do Studio ficar oculta |

### O bloqueio anterior, resolvido

A ponte nao subia porque **nao existe plugin de MCP**. A pasta de plugins do Studio so tem
o `RojoManagedPlugin.rbxm`. O servidor MCP vive dentro do painel Assistant, entao ele so
liga quando o painel e aberto na janela. O toggle persiste entre aberturas, ao contrario do
que o SkillLab tinha registrado. O que nao persiste e o painel aberto.

### Limitacao que apareceu no meio do trabalho

As capturas passaram a dar timeout enquanto `execute_luau` continuava respondendo. Causa: a
janela do Studio ficou oculta, o log registra `Pushing throttle render state` e o
`ViewportSize` volta `1, 1`. Sem renderizacao nao ha captura. As capturas comparativas do
Checkpoint A ficaram pendentes por isso.

---

## 3. Percentual 1, fundacao estrutural

O lobby e solido? Peso total 100. **Resultado: 82,5 de 100.**

| Criterio | Peso | Resultado | Evidencia |
| --- | --- | --- | --- |
| Integridade do place | 10 | aprovado | arvore percorrida, 1.769 BaseParts, place salvo antes de comecar |
| Organizacao do Explorer | 10 | aprovado | 0 pecas sem ancoragem, 0 com nome generico. `AssetStaging` removido |
| Seguranca de assets | 15 | parcial | sessao 007: 0 script nos dois pacotes auditados. Nao varri o place inteiro nesta sessao |
| Colisoes e barreiras | 15 | parcial | varredura de peca fantasma feita, 1 achado em 922 com colisao, corrigido. Teste de queda nao refeito |
| **Circulacao** | 15 | **aprovado** | 8 rotas andadas com `JumpPower = 0`. Ver secao 4 |
| **Escala e capacidade para oito** | 20 | **aprovado** | 9 de 9 criterios, com 8 rigs R15 reais. Primeira medicao desde a sessao 001 |
| Spawn e camera | 10 | aprovado | spawn reposicionado e assentado, 6 de 6 linhas de visao livres, personagem nasce em `(-4.99, 3.70, -17.36)` |
| Performance medida | 5 | parcial | 60 FPS medido na sessao 007, nunca em celular |

Os dois criterios que mudaram de Reprovado para Aprovado sao os de peso 20 e 15. O de peso
20 nunca tinha tido nem tentativa desde a sessao 001.

### Capacidade para oito, detalhe

Rodado por `tools/audit/A1-CapacityEightPlayers.luau`, com 8 rigs R15 criados por
`CreateHumanoidModelFromDescription`. As lajes sao descobertas no place, nao lidas de
documento, porque o documento estava errado. Os rigs sao apagados no fim.

| Situacao | Medida | Veredito |
| --- | --- | --- |
| Spawn, 8 ao mesmo tempo | plataforma 12 studs, menor distancia 4,00 | aprovado no limite |
| Spawn, interpenetracao | 0 pares se atravessando | aprovado |
| Praca, 8 espalhados | menor distancia 19,93, 693 studs quadrados por jogador | aprovado |
| Area Cosmetics | laje 51 x 43, menor distancia 11,75 | aprovado |
| Area EventBoard | laje 51 x 35, menor distancia 11,75 | aprovado |
| Area Gamepasses | laje 49 x 41, menor distancia 11,25 | aprovado |
| Area Leaderboard | laje 47 x 41, menor distancia 10,75 | aprovado |
| Area MapVote | laje 51 x 45, menor distancia 11,75 | aprovado |
| Area SocialArea | laje 41 x 31, menor distancia 9,25 | aprovado |

O 4,00 do spawn e exatamente o limiar. Nao alarguei a plataforma de proposito: o piso da
praca e feito de aneis concentricos de raio 11, 15, 24, 34 e 42, e a faixa plana mais larga
entre dois aneis tem cerca de 10 studs. Nao existe ponto plano de 16 x 16 na praca, e
alargar criaria borda flutuante, que e o bug que o projeto vem eliminando.

---

## 4. Circulacao, medida andando

O criterio foi medido de tres jeitos. Os dois primeiros deram numero errado, e ficam
registrados porque a licao importa mais que o resultado.

| Metodo | Resultado | Vale? |
| --- | --- | --- |
| Raio de cima para baixo, em linha reta | 6 de 8 rotas com problema | nao, o raio acertava toldo, balcao e a propria fonte |
| `PathfindingService`, agente sem pulo | 3 emendas sem rota no `PathSocial` | nao, e artefato de navmesh |
| **Personagem R15 andando com `JumpPower = 0`** | **7 de 8 rotas completas** | **sim** |

O `PathfindingService` foi descartado como criterio depois que o personagem andou o
`PathSocial` inteiro, do spawn ao deck, em 6,8 segundos, sem poder pular, exatamente no
trecho que a malha de navegacao dizia nao ter rota. Jogador nao usa navmesh, ele anda.

| Rota | Resultado | Tempo |
| --- | --- | --- |
| PathEventBoard | completa, 9 de 9 placas | 2,8 s |
| PathGamepasses | completa, 9 de 9 | 4,2 s |
| PathLeaderboard | completa, 9 de 9 | 5,0 s |
| PathMapVote | completa, 9 de 9 | 5,0 s |
| PathTraining | completa, 5 de 5 | 4,5 s |
| PathParkour | completa, 5 de 5 | 4,5 s |
| PathSocial | completa, ate o deck | 6,8 s |
| PathCosmetics | para na placa 8 de 9 | 9,0 s |

O `PathCosmetics` para porque a nona placa fica **embaixo do balcao da loja**. `Counter`,
`CounterTop`, `KioskPost_R`, `TitlesPlaque` e a `CollisionBox` do lojista estao todos sobre
o segmento final. Funcionalmente o balcao e o destino, entao a rota nao esta quebrada, mas
gerou o defeito 5 da secao 7.

---

## 5. Percentual 2, experiencia do lobby

E bom estar nele? Peso total 100. **Resultado: 30 de 100.**

| Criterio | Peso | Resultado | Evidencia |
| --- | --- | --- | --- |
| Clareza das atracoes | 15 | parcial | 6 de 6 linhas de visao do spawn livres. Leitura em cinco segundos nao avaliada, capturas bloqueadas |
| Hierarquia visual e ponto focal | 15 | a medir | depende de captura |
| Coerencia artistica | 10 | a medir | depende de captura |
| Iluminacao | 10 | parcial | vista em 3 capturas desta sessao, nunca avaliada com criterio |
| GUI funcional | 20 | parcial | `CrumbleUI` carrega em Play com 551 descendentes, `UIController` ativo, visibilidades padrao corretas. Nenhum painel aberto por clique nesta sessao |
| Audio | 15 | **reprovado** | musica escolhida e conferida, **nenhum SFX de interface existe** |
| Interacoes | 15 | parcial | 3 prompts encontrados e medidos, alcance do `ShopPrompt` corrigido. **Nunca disparado por tecla** |

Esta e a faixa mais fraca, e o motivo e honesto: quase tudo nela depende de olhar, e as
capturas cairam na metade do trabalho.

---

## 6. Percentual 3, prontidao para producao

Pode ir para jogador real? Peso total 100. **Resultado: 32,5 de 100.**

| Criterio | Peso | Resultado | Evidencia |
| --- | --- | --- | --- |
| **Teste em celular real** | 25 | **reprovado** | R-007 desde a sessao 002. So simulador do Studio |
| Responsividade validada | 15 | parcial | iPhone 7 e iPhone 16 no simulador, 0 alvo abaixo de 44 px |
| Output sem erros | 15 | parcial | 0 erros e 0 avisos em Play. Mas o historico voltou com 0 linhas no total, o que nao permite afirmar que o console foi exercitado |
| Documentacao atualizada | 10 | aprovado | este documento, `SESSION-LOG`, `CURRENT-STATE` e `LOBBY-BUILD-PARAMS` atualizados nesta sessao |
| Place salvo e versionado | 15 | parcial | salvo as 03:18. As correcoes desta sessao ainda pedem `Ctrl + S` |
| Regressao completa | 20 | a medir | so no fim |

---

## 7. Correcoes realizadas

Todas reversiveis, com o estado anterior guardado em atributo na propria peca.

| # | Defeito | Medida | Correcao |
| --- | --- | --- | --- |
| 1 | A fonte central escondia o `EventBoard` inteiro do spawn | fonte cobre 44,3 graus e sobe a 24; o topo do board esta a 15,1. A silhueta cruza o plano do board em `Y = 52,4`, e o board acaba em `Y = 34,5` | spawn movido de `z = +18` para `z = -18`, o espelho exato: mesma distancia do centro, lado oposto |
| 2 | `LobbySpawn` flutuava e criava degrau | folga 0,25 acima do piso, degrau de 1,25 para a praca | assentado, folga 0,10 e degrau 0,30 |
| 3 | `FountainCollision` colidia mas era invisivel a raycast | unico caso em 922 pecas com colisao no workspace | `CanQuery = true` |
| 4 | `AssetStaging` com dois modelos visiveis enfiados na laje de Cosmetics | 46 pecas visiveis, 10 se atravessando entre si, 82 contatos com a geometria do lobby | movidos para `ServerStorage.DeferredContent`, precedente D-014 |
| 5 | Quem sobe o `PathCosmetics` para a 17,9 studs do lojista, fora do alcance de 14 | medido andando, em Play | `ShopPrompt.MaxActivationDistance` de 14 para 20 |
| 6 | Fresta em cunha entre as placas dos caminhos | 0,00 na borda interna, 0,10 no centro, ate 0,66 na borda externa, dentro da faixa pisavel | 192 pecas alongadas 0,8 no eixo do caminho. Todas as frestas foram a 0,00 |

A correcao 6 esta versionada em `tools/fixes/01-ClosePathSeams.luau`, com a reversao escrita
no proprio arquivo. Ela **nao** resolveu as tres emendas sem rota do `PathSocial`, o que foi
justamente a evidencia de que aquilo era navmesh e nao geometria.

### Quatro falsos positivos, e o que causou cada um

| O que eu afirmei | O que era |
| --- | --- |
| Buraco de 4,5 studs no `PathEventBoard` | a varredura de 0,5 em 0,5 caiu exatamente nas frestas de 0,08 em `-62`, `-66` e `-70` |
| Degrau de 7,20 no `PathCosmetics` | o raio atravessou o balcao e o toldo, 10 studs acima do piso |
| `EventBoard` e `SocialArea` inalcancaveis | o destino que eu escolhi caia dentro do `BoardBeamBottom` e do `Deck` |
| 49% das emendas abertas para a grama | amostrei em cima da linha da emenda, onde sempre da aberto |

---

## 8. Pendencias e bloqueios

| Item | Tipo | Quem resolve |
| --- | --- | --- |
| `Ctrl + S` das correcoes desta sessao | bloqueio | Rick |
| Janela do Studio visivel para capturar | bloqueio | Rick |
| Teste em celular real | pendencia | Rick, no aparelho |
| SFX de interface | pendencia | eu |
| Prompt do NPC por tecla | pendencia | eu, em Play com input |
| Checkpoint B e C | pendencia | eu |

---

## 9. Proxima etapa

Checkpoint B: GUI aberta por clique, responsividade, audio e Output. O item de audio e o
unico Reprovado que eu resolvo sozinho, e vale 15 pontos, entao ele vem primeiro.
