# Retomada Phase 1: linguagem rejeitada, fase incompleta

## Estado herdado e proveniencia

Projeto Desktop/CrumbleArena, branch feat/lobby-art-pass, Place CrumbleArena.rbxl,
Studio Edit, Workspace.CrumbleArena.Lobby. Nenhum outro projeto alterado.
Disco ja havia sido salvo apos PRE-PHASE-1: 673654 bytes, 13:45:27 local,
SHA256 724d8364692f11c0407145f7834d6174a2b0ed24eef62fb70370b0ebc19c0a82.
Igual ao backup PRE-PHASE2. PRE-PHASE1 permanece com 669632 bytes e hash
5740ff19465a310159bcfd39f6e3f87e9183071f6564e160b23265b68a685820.
Nao salvei, publiquei, fiz commit ou push. src/ sem diff.

Usuario confirmou outros agentes pausados. Fingerprint geometrica DJB2 4348b166
repetida em leituras separadas antes dos writes. Estabilidade observada, nao lock
exclusivo imposto pelo servidor. Algoritmo diferente da digital antiga 161642.5148;
nao comparar os dois numeros. Assinatura usa caminhos, classe, Size e CFrame ordenados.

## Delta

| Familia | PRE-P1 registrado | Takeover medido | Depois medido |
| --- | ---: | ---: | ---: |
| CentralPlaza | 37 | 79 | 70 |
| SocialArea | 78 | 94 | 94 |
| Demais familias | 678 | 678 | 678 |
| Total | 793 | 851 | 842 |

Sequencia documentada: 793 +43 Phase1 -7 remocoes do usuario +16 SocialArea +6
refinement =851. Usuario esclareceu que removeu as sete pecas antigas por sobreposicao
com o chao central. Nao foram restauradas. SocialArea ja possui Phase2; foi preservada,
nao auditada/aprovada como parte desta fase. Contagens iguais nas demais familias nao
provam igualdade de todas as propriedades com o binario antigo.

## Alteracoes do Claude encontradas

PlazaIntegration: SW_TerrenoSubindo 23, SE_RampaDeGrama 5, NE_PatamarDePedra 4,
NW_BordaQuebrada 6, N_ChegadaDoSpawn 4. Total42.
Tres rampas SE e quatro N_LinguaDePedra presentes. SE_Rampa unica anterior ausente.
Rampas: topos altos 2.3599999 e pes aproximadamente0.0, angulos 10.447/7.996/9.371.
Linguas: topo2.3500001, espessura0.9, comprimentos8/4.1/5.9/3.3.
CanCollide, CanTouch, CanQuery e CastShadow true nas nove pecas preservadas.
Material Plastic. Rampas RGB80,145,87; ombros72,132,79; linguas139,151,153 ou128,140,143.

## Residuos e limites

Busca nominal por talud/teste/probe no lobby sem resultados antes dos testes.
22 BaseParts invisiveis enumeradas: spawn, FallZone, 17 barreiras, dois HRPs e LightAnchor.
Nenhuma foi removida. Nao encontrado conjunto de oito taludes CHANGE03 por nome.
Isso nao prova ausencia de residuos renomeados ou objetos sem Parent; auditoria completa
de instancias abandonadas fora do lobby nao foi executada.

## Veredito: LANGUAGE REJECTED

SE_Rampa: extremos medidos coerentes com descricao, mas emendas, quinas e faces
laterais expostas leem como tres placas inclinadas. Artificial no nivel do jogador e
retangular na aerea. Nao aprovada como terreno; retirada reversivel.
N_LinguaDePedra: rebaixamento0.05 confirmado em relacao ao piso2.40. Nao equivale a
prova global de zero z-fighting. Caminho descendente deixa pontas salientes; quatro
retangulos parecem remendos sobre estrada. Retirada reversivel.
Nao foi feita alegacao de 0 faces coincidentes em toda a cena.

## Alteracoes Astra, uma por vez

Snapshot do lobby851 em ServerStorage.AstraPhase1Takeover.LobbyBeforeCorrections.
FIX01: quatro linguas movidas para RejectedStoneTongues. Capturas antes/depois.
FIX02: tres rampas movidas para RejectedGrassRamps. Capturas antes/depois.
FIX03: dois ombros do mesmo conjunto, expostos apos FIX02, movidos para RejectedGrassRamps.
Capturas antes/depois. Nenhuma peca destruida ou nova geometria criada. Apenas Parent
mudou; Size, CFrame, material, cor e flags originais preservados. Retorno possivel:
linguas para PlazaIntegration.N_ChegadaDoSpawn; rampas/ombros para SE_RampaDeGrama.
Logs das chamadas registram valores exatos de todas as nove pecas.

## East / West / Outlook / composicao adicional

Sem alteracoes: linguagem rejeitada impediu Stage4. Nenhuma intervencao adicional
Stage5 executada. Nao repliquei placas, nao criei aneis ou decoracao. SocialArea,
vegetacao, monumento, paleta e demais areas intactos nesta retomada.
Vista aerea continua mostrando grande poligono cinza. Remover remendos limpa a cena,
mas nao resolve a integracao arquitetonica. A quinta entrada SE foi retirada;
o desnivel original reapareceu fora das quatro rotas principais.

## Validacao parcial

Quatro rigs em Play com pulo desativado completaram Spawn, East, West e Outlook
ate a praca. Probes removidas, retorno Edit. Nao repetidos oito rigs/Seats/barreira.
Eixo Spawn entrez35e20: passo0.1, maior delta consecutivo0.008184, zero misses.
Perimetro72:35 ate0.5,16 de0.5a1.5,21 acima1.5,zero misses. Metodo proprio:
angulos de5graus, limite do Floor localizado com passo0.1, amostras0.2para dentro e
1stud para fora. Nao comparar diretamente com metodo antigo sem seus parametros.
842BaseParts, zero nao ancoradas. Zero pares de caixas com CFrame/Size/classe identicos
no scan em Play; isso NAO e auditoria de intersecoes ou de faces coplanares.
CanTouch true em118 pecas no scan Play; nao alterado indiscriminadamente.
Edit: zero CanCollide=true/CanQuery=false, zero scripts no lobby.
Play:28 pecas dos dois rigs decorativos com esse par de flags. Nao corrigidas:
fenomeno de runtime fora da praca. Packages zero no scan Play.
Output: Infinite yield possible aguardando CrumbleUI, UIController linha18.
Fingerprint final Edit e8607660. Disco manteve hash724d8364..., nenhum save.

## Capturas

Seis takeover realizadas: AERIAL, SPAWN_CORE, SE_RAMP, STONE_TONGUES, EDGE_PROFILE,
PLAYER_HEIGHT, todas com prefixo ASTRA_TAKEOVER_. FIX01/02/03 BEFORE e AFTER feitas.
ASTRA_PHASE1_REJECTION_AERIAL apos correcoes. Imagens reais inline na conversa.
Nao foram produzidas as11 FINAL porque a Phase1 nao foi concluida/aprovada.
Nao ha comparacao visual direta certificada com PRE-PHASE1: backup nao foi aberto
nem substituido no Studio; nenhuma captura antiga foi inventada.

## Avaliacao final

PRE-PHASE1:6.5/10 e nota herdada, nao nota visual independente.
Claude:7/10 e autoavaliacao herdada; minha leitura do takeover da praca:6/10,
com forma central dominante e remendos visiveis.
Astra:6/10 para a praca apos limpeza. Chegada mais limpa, SE ainda sem integracao.
Nao houve salto de qualidade suficiente para chamar de refinamento concluido.
PHASE1 APROVAVEL? NAO. Nao e candidata a checkpoint.
O trabalho encerra no Stage3 com linguagem rejeitada, e nao com Phase1 concluida.
