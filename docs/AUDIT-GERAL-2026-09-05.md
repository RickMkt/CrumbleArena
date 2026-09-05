# Auditoria geral do projeto

Feita em 2026-09-05 a pedido do Rick. Diferente da `LOBBY-COMPLETE-AUDIT.md`, que mede se o
lobby esta bom, esta aqui pergunta outra coisa: **o que esta escrito nos documentos e
verdade?**

A premissa nao e desconfianca gratuita. So nesta sessao apareceram tres casos de documento
errado: o `LOBBY-BUILD-PARAMS` estava errado sobre a posicao do spawn e sobre a altura das
lajes, e o acervo SkillLab estava errado sobre o toggle do MCP. Documento nao e evidencia.

## Metodo

Cada afirmacao numerica dos documentos foi conferida contra o place aberto, por script. O
Studio estava em modo Play durante a auditoria, entao as leituras estruturais usaram o
datamodel `Server`, que e copia fiel da geometria de Edit, e as de interface usaram o
`Client`.

Total: **58 conferencias automaticas** mais a inspecao do repositorio.

---

## 1. O que confere

### Geometria do lobby, 27 de 27

Todas as camadas da ilha batem no topo e na altura: `GrassCell` topo 0 altura 6, `DirtCell`
topo -6 altura 18, `StoneUpper` topo -24 altura 26, `StoneMid` topo -50 altura 30,
`StoneLower` topo -80 altura 30, `StoneTip` topo -110 altura 30. Base solida ate `Y = -161`,
contra `-162` documentado, dentro da tolerancia.

Os cinco aneis da praca batem exatamente: raios 42, 34, 24, 15 e 11.

Os 8 caminhos existem com a contagem certa de segmentos: 9 em seis deles, 5 no `PathTraining`
e no `PathParkour`.

### Adereços e seguranca

| Afirmacao do documento | Real | Veredito |
| --- | --- | --- |
| 44 blocos soltos de borda, sem colisao | 44 `RimChunk`, 0 com colisao, raio 130 a 150 | confere |
| 28 rochas na face do penhasco | 28 | confere |
| 12 fragmentos flutuantes proximos | 12 grupos | confere |
| 10 fragmentos distantes | 10 grupos | confere |
| todos os fragmentos sem colisao | 0 com colisao | confere |
| 36 segmentos de barreira, raio 124 | 36, raio 124.0 | confere |
| `FallenPartsDestroyHeight = -240` | -240 | confere |
| 48 postes de cerca, raio 120.5 | 48 postes, raio 120.2 | confere |
| 4 assentos na area social | 4 | confere |

### Musica

`LobbyMusic` existe em `SoundService` com `rbxassetid://9038305339`, volume 0.16, em loop,
e com os atributos de procedencia preenchidos: nome `Skip in Your Step (b)`, criador
`APMOfficial`. A rastreabilidade de asset esta correta.

### D-014, conteudo adiado

`ServerStorage.DeferredLobbyAreas` guarda `Training` com 58 partes e `Parkour` com 37. A
decisao foi executada de verdade, nada foi apagado.

### Repositorio

| Verificacao | Resultado |
| --- | --- |
| `stylua --check src` | 0 divergencias |
| `selene src` | 0 erros, 0 avisos |
| `selene tests` | 0 erros, 0 avisos |
| `rojo build` | compila |
| `lune run tests/GameConfig.spec.luau` | 9 de 9 passam |
| Place salvo | 2026-09-05 13:23, 321.199 bytes |

O place salvo as 13:23 e posterior as seis correcoes da auditoria do lobby, entao elas
estao em disco. Aquela pendencia esta fechada.

---

## 2. Divergencias entre documento e place

Estas sao as que importam.

### 2.1 A tabela de iluminacao esta errada em 18 de 20 propriedades

O `LOBBY-BUILD-PARAMS.md` tem uma secao de iluminacao da sessao 002. O
`tools/rebuild/04-ApplyEnvironment.luau` tem outros valores. **O place segue o script, nao o
documento.**

| Propriedade | Documento | Script 04 e place |
| --- | --- | --- |
| Brightness | 2.9 | 2.4 |
| ClockTime | 13.6 | 14.6 |
| GeographicLatitude | 24 | 14 |
| ExposureCompensation | -0.05 | 0.05 |
| ShadowSoftness | 0.35 | 0.24 |
| EnvironmentDiffuseScale | 0.55 | 0.68 |
| EnvironmentSpecularScale | 0.25 | 0.22 |
| Ambient | 84, 88, 98 | 102, 106, 118 |
| OutdoorAmbient | 142, 148, 158 | 158, 164, 176 |
| Bloom | 0.35 / 18 / 1.7 | 0.2 / 28 / 2.0 |
| Atmosphere Density / Haze / Glare | 0.11 / 0.5 / 0 | 0.22 / 1.4 / 0.1 |
| Atmosphere Color | 222, 232, 244 | 226, 232, 224 |
| Atmosphere Decay | 170, 198, 228 | 122, 168, 214 |
| ColorCorrection Contrast | 0.09 | 0.15 |

So `SunRays Intensity` e `ColorCorrection Saturation` sobreviveram. Quem tentar reverter a
iluminacao pelo documento vai produzir uma cena que nunca existiu.

### 2.2 O emblema do bloco rachado nao existe

O documento diz, na secao da praca central: "Emblema do bloco rachado no centro, com 6
fissuras rentes ao piso".

No place: `PlazaMedallion` e uma unica `Part` sem nenhum filho. Nao ha **nenhuma** peca com
nome de fissura, emblema ou rachadura no lobby inteiro. Os unicos tres decais da praca sao
a textura da agua da fonte.

O centro da praca hoje e a `CentralFountain`, com 32 partes. A fonte substituiu o emblema e
o documento nunca foi atualizado.

Isto pesa mais do que parece. O bloco rachado e o simbolo do pilar P1, "o chao e a arma".
O documento afirma que o centro do lobby carrega esse simbolo, e o que esta la e uma fonte
generica, que poderia estar em qualquer jogo.

### 2.3 A altura da barreira esta errada

Documento: "36 segmentos de barreira invisivel em anel, raio 124, **altura 18**".
Real: altura **26**, que e o valor do `tools/rebuild/02-BuildIslandFence.luau`.

Existe tambem uma peca `FallZone` de altura 4 em `Safety`, que nao consta em documento
nenhum.

### 2.4 A secao de Parkour descreve algo que nao esta no lobby

O documento descreve "volta fechada de 13 plataformas em circulo, centro (78, 60), raio 15",
com vao maximo de 7.2 e subida maxima de 2.4.

No place, `Areas.ParkourPoint` nao tem **nenhuma** peca de plataforma. So tem `PadSlab`,
`PadTrim`, `ParkourStartArch`, `SignBoard`, `SignCap`, `SignPost` e `StepStone`. A volta de
plataformas esta em `ServerStorage.DeferredLobbyAreas.Parkour`, por causa da D-014.

A decisao foi certa e foi executada. O que falta e a secao do documento dizer isso. Do jeito
que esta, ela descreve o lobby atual e nao e verdade.

### 2.5 Os marcadores de auditoria de asset: 14 contra 11

O `SESSION-LOG.md` e o `ASSET-INVENTORY.md` afirmam, os dois, que uma limpeza automatica
apagou **14** marcadores em `ImportedAssets.AssetAuditRecords` e que eles foram recriados.

No place existem **11**, e um deles, `RejectedSearchResults`, esta sem o atributo `Situacao`
que os outros dez tem.

Faltam tres, ou o numero 14 nunca esteve certo. Como fui eu quem apagou e eu quem afirmou
ter recriado, este item e responsabilidade minha e nao da para fechar sem saber quais eram
os originais. Ver a secao 5.

---

## 3. Defeitos funcionais encontrados

### 3.1 A musica nunca toca

Medido no Play que estava rodando: `LobbyMusic.Playing = false` e `IsPlaying = false`,
enquanto o atributo `MusicRow.Toggle.On` vale `true` e o interruptor aparece verde na tela.

Causa: em `UIController.client.luau` o unico lugar que chama `som.Playing` esta **dentro do
handler de clique** do interruptor. Nada inicia a musica quando o jogador entra.

Efeito para o jogador: ele entra, a interface diz que a musica esta ligada, e o lobby esta
mudo. Para ouvir, precisa abrir Ajustes, desligar e religar.

Custo do conserto: uma linha.

### 3.2 O interruptor de SFX promete o que nao existe

`SoundService.SFX` e um `SoundGroup` com **0 filhos**. Nao existe nenhum som de interface no
projeto. Confirmei que os 5 `Sound` que aparecem na varredura sao do `BrickCutterGui` do
proprio Studio, nao do jogo.

O painel de Ajustes mostra `SOUND EFFECTS` ligado. Ele controla o volume de um grupo vazio.

Este ja era o Reprovado de 15 pontos da auditoria do lobby. A novidade e que ele esta
visivel na tela como uma promessa falsa.

### 3.3 238 pecas carregam uma propriedade que nao faz nada

1.032 pecas do lobby tem `TopSurface = Studs`. Destas, **238 usam `SmoothPlastic`**, e o
proprio `PROJECT-MEMORY.md` registra que stud so renderiza com `Material.Plastic`.

Onde estao: 43 na `Cosmetics/Shopfront` e cerca de 200 espalhadas nas lanternas, 10 em cada
uma de vinte lanternas.

Nao e bug visual, e sujeira: a propriedade esta setada e nao produz efeito. Ou as pecas
deviam ser `Plastic` e alguem esqueceu, ou o `TopSurface` devia ser `Smooth` e ficou lixo.

### 3.4 Dois itens equipados ao mesmo tempo no mock

No painel de Cosmetics, `DUST TRAIL` e `LEAF BURST` aparecem os dois como `EQUIPPED`. Se
forem do mesmo slot, o dado falso esta ensinando uma regra errada que vai ser copiada quando
o sistema real for escrito.

---

## 4. O que nunca foi verificado

| Item | Situacao |
| --- | --- |
| Teste em celular real | nunca feito, R-007 desde a sessao 002 |
| Oito jogadores humanos ao mesmo tempo | so com rigs ancorados, nunca com gente |
| `ProximityPrompt` disparado por tecla | nunca |
| Os 4 scripts de `tools/rebuild` | escritos, **nunca executados** |
| `tools/audit/A1` e `tools/fixes/01` | executados uma vez, nesta sessao |
| Regressao completa | nunca |

O item dos scripts de rebuild merece atencao. Eles existem para ser a rede de seguranca se o
place se perder, e nenhum deles jamais rodou. Uma rede de seguranca nao testada e uma
suposicao, nao uma rede.

---

## 5. Erros meus, acumulados

Registro porque a auditoria perde valor se eu auditar todo mundo menos a mim.

| Erro | Onde |
| --- | --- |
| Apaguei os 14 marcadores do Codex, recriei 11 | sessao 005, descoberto agora |
| Afirmei buraco de 4,5 studs que era fresta de 0,08 | sessao 008 |
| Afirmei degrau de 7,20 que era o raio atravessando um toldo | sessao 008 |
| Afirmei duas atracoes inalcancaveis com destino dentro de geometria | sessao 008 |
| Afirmei 49% de emendas abertas amostrando em cima da emenda | sessao 008 |
| Chamei os `PlazaMarker` de defeito flutuante | sessao 008 |
| Afirmei que os blocos de borda nao existiam, o nome e `RimChunk` | esta auditoria |
| Supus bug de inicializacao nos interruptores, o script inicializa certo | esta auditoria |

Padrao: **erro de sonda, nao erro de leitura**. Toda vez que uma medicao automatica deu
resultado ruim, a causa foi a ferramenta e nao o lobby. A regra que saiu disso esta na D-019.

---

## 6. Placar

| Area | Situacao |
| --- | --- |
| Geometria do lobby | solida, 27 de 27 conferem |
| Adereços e seguranca | solidos, 9 de 9 conferem |
| Codigo versionado | limpo, compila, 9 testes passam |
| Rastreabilidade de asset | boa, com um furo nos marcadores |
| Documentacao | **4 secoes desatualizadas ou falsas** |
| Audio | **existe no place e nao funciona em jogo** |
| Rede de seguranca | **escrita e nao testada** |

O projeto esta melhor construido do que documentado. A geometria e o codigo aguentam
inspecao; os documentos e o audio, nao.

---

## 7. Ordem sugerida

1. **Musica que nao toca**, uma linha, defeito visivel para qualquer jogador
2. **Corrigir a tabela de iluminacao** no `LOBBY-BUILD-PARAMS`, que hoje reverteria a cena
   para um estado que nunca existiu
3. **Decidir o emblema do bloco rachado**: construir, ou tirar do documento. E o simbolo do
   pilar P1, entao a escolha e de produto, nao minha
4. **Marcar a secao de Parkour** como conteudo adiado pela D-014
5. **Corrigir altura da barreira e contagem dos marcadores** nos documentos
6. **SFX de interface**, que vale 15 pontos na auditoria do lobby
7. **Rodar os 4 scripts de rebuild** num place descartavel, para a rede de seguranca deixar
   de ser suposicao
