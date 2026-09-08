# Phase 1 — Stage 4A e canto SE, 2026-09-06

## Resultado e limite

PHASE 1 APROVAVEL? **NAO**, ainda incompleta. Somente mapeamento e SE executados neste turno, conforme a ultima ordem do anexo. Spawn, East, West e Outlook nao foram modificados. Nenhum salvamento, commit, push ou publicacao.

SE: linguagem aprovada internamente como **recuo + um unico patamar**, nao como solucao para toda a praca. Nota subjetiva da praca inteira: 6/10 antes, aproximadamente 6.3/10 agora. O canto melhorou; a massa cinza ainda domina a vista aerea. Nao e candidata a checkpoint final.

## Estado confirmado

- Projeto canonico CrumbleArena, branch feat/lobby-art-pass, Studio Edit ao inicio e ao fim.
- Disco: 673654 bytes, 2026-09-06 13:45:27 local; SHA-256 `724d8364692f11c0407145f7834d6174a2b0ed24eef62fb70370b0ebc19c0a82`, inalterado. Este e o estado salvo posterior ao PRE-PHASE-1, ja esclarecido na retomada anterior.
- Memoria inicial: 842 BaseParts, 0 nao ancoradas, DJB2 `e8607660`, repetido antes da escrita.
- Memoria final: 844 BaseParts, 0 nao ancoradas, DJB2 `12143bd7`, repetido depois do Play.
- Outros agentes pausados conforme confirmacao do usuario; nenhuma mudanca espontanea observada. Fingerprint estavel nao e bloqueio exclusivo de escrita.
- `src/*` sem mudancas no Git; worktree ja possuia alteracoes de documentos e ferramentas, preservadas.

## Stage 4A: mapa real

A borda principal encontrada tem **8 lados**, triangulados em 12 WedgeParts por camada; nao 12 lados externos. Centro XZ (0,4).

Vertices XZ: (-22,-8), (-12,-18), (12,-18), (22,-8), (22,16), (12,26), (-12,26), (-22,16).

| Componente | Antes deste passe |
|---|---|
| PlazaFoundation | 12 WedgeParts, Y 0 a 1.8, espessura 1.8 |
| PlazaPaving | 12 WedgeParts, Y 1.8 a 2.4, espessura 0.6 |
| Grama | topo Y 0 |
| Raio dos lados axiais | 22 |
| Distancia dos lados diagonais ao centro | aproximadamente 24.04 |
| Raio dos vertices | aproximadamente 25.06 |
| Integracao herdada ativa | SW 23 pecas, NE 4, NW 6; 33 no total |
| Conexoes nos eixos | Spawn (0,26), East (22,4), West (-22,4), Outlook (0,-18) |

Os pontos acima sao encontros geometricos nos eixos, nao novas medidas de largura dos caminhos. As rotas East/West testadas anteriormente passam em Z=8.

Classificacao de trabalho do perimetro, nao certificacao completa:

| Categoria | Regiao / leitura |
|---|---|
| A: conexao principal | Quatro encontros dos caminhos; caminhaveis nos testes anteriores, composicao ainda pendente |
| B: borda arquitetonica | Trechos de contencao NE/NW podem permanecer elevados; nao precisam virar rampas |
| C: paredao acidental | SE antes: 2.4 studs expostos; alvo substituido neste passe |
| D: reconstruir/reavaliar | SW com 23 fragmentos e encontros de caminhos; nao alterados neste escopo |

Nao houve tentativa de converter todo o perimetro em acesso caminhavel.

## Unica intervencao

Escolha D. Substituidas `PlazaFoundation.Face2_2` e `PlazaPaving.Face2_2` do canto SE. As duas originais foram movidas, nao destruidas, para `ServerStorage.AstraPhase1Takeover.Stage4_SE_OriginalCorner`.

Novo Model: `Workspace.CrumbleArena.Lobby.CentralPlaza.Floor.SE_RecessedLanding`.

| Nome | Size local | Position | Topo mundial |
|---|---|---|---|
| LandingFoundation | 0.6,10,10 | 17,0.3,-13 | 0.6 |
| LandingPaving | 0.6,10,10 | 17,0.9,-13 | 1.2 |
| RecessedFoundation | 0.6,6,6 | 15,1.5,-11 | 1.8 |
| RecessedPaving | 0.6,6,6 | 15,2.1,-11 | 2.4 |

Todas WedgePart, Orientation (0,-90,90), Plastic. Fundacao RGB 104,119,130; piso RGB 139,151,153. Anchored/CanCollide/CanQuery/CastShadow true, CanTouch false. Studs nativos na RightSurface dos pisos; demais faces lisas.

O piso superior recua 2.828 studs perpendicularmente a diagonal. O patamar ocupa o contorno original, com topo Y=1.2. Nao amplia a ilha nem sobrepoe placas ao caminho. Sao 4 pecas substituindo 2: delta liquido +2. Implementacao registrada em `tools/rebuild/13-SE-RecessedLanding.luau`, ja executada; nao executar novamente.

## Validacao

- Raycasts locais: grama aproximadamente 0, patamar 1.2000002, praca 2.3999996.
- Play: dois clones do avatar, um para cada sentido grama/praca. JumpPower=0, JumpHeight=0 e estado Jumping desativado. Ambos alcancaram os dois alvos, tolerancia horizontal de 1 stud; velocidade 12. Subida e descida passaram. Clones removidos; retorno confirmado a Edit.
- Bounds: candidatos de contato encontrados, como esperado na triangulacao. Amostragem de volume interior 9x9x9 por peca nova contra candidatos do Floor encontrou 0 pontos internos compartilhados. E amostragem, nao prova matematica global.
- Interfaces internas entre camadas sao contatos intencionais. Nenhuma sobreposicao exposta/z-fighting foi observada nas vistas locais examinadas. Nao alego zero z-fighting no lobby inteiro.
- Console retornou vazio nesta consulta. O Infinite Yield de CrumbleUI do historico permanece backlog, nao foi corrigido nem considerado definitivamente resolvido.
- Comparacao por multiconjunto de caminhos e geometria/cor contra snapshot takeover: 0 diferencas fora de CentralPlaza. Uma primeira sonda por FindFirstChild gerou falsos positivos devido a nomes duplicados e pontos em nomes de meshes; foi descartada e substituida pela comparacao que preserva multiplicidade.

## Delta reconciliado

| Familia | PRE-PHASE-1 | Antes deste passe | Depois | Delta total |
|---|---:|---:|---:|---:|
| CentralPlaza | 37 | 70 | 72 | +35 |
| SocialArea herdada | 78 | 94 | 94 | +16 |
| Demais familias | 678 | 678 | 678 | 0 |
| Total | 793 | 842 | 844 | +51 |

Os 9 elementos rejeitados continuam fora da cena. A pasta vazia SE_RampaDeGrama ainda existe, mas nao contem a rampa ativa. Snapshot completo de 851 pecas, 4 linguas e 5 pecas SE rejeitadas preservados. As 2 originais deste passe somam-se ao rollback.

## Evidencia visual real

Capturas retornadas pelo Studio na conversa; os identificadores abaixo nao sao caminhos PNG exportados:

- ASTRA_P1_STAGE4_FIX01_BEFORE e AFTER: mesma camera (44,9,-30), alvo (23,1,-19).
- ASTRA_SE_FINAL_PROFILE: camera (25,5,-6), alvo (16,1.6,-13).
- ASTRA_SE_FINAL_45: (30,5,-25), alvo (16,1.5,-13).
- ASTRA_SE_FINAL_INSIDE: (8,6,-5), alvo (18,1,-15).
- ASTRA_SE_FINAL_PLAYER: (25,5,-21), alvo (15,2,-11).
- ASTRA_SE_FINAL_AERIAL: (35,48,-37), alvo (15,1,-12).

O canto le como parte da fundacao: recuo continuo, um patamar, sem tres planos verdes ou linguas. A mudanca aerea e modesta e localizada. Os oito criterios locais SE passam com a ressalva de que ausencia de conflito geometrico e restrita ao escopo inspecionado.

## Falta

Recompor Spawn, depois East/West/Outlook individualmente; reavaliar a massa aerea; somente entao decidir a intervencao estrutural adicional e repetir validacao completa. Nao foram produzidas falsas capturas finais dessas conexoes. Nenhuma Phase 2 iniciada. Nao salvar sem aprovacao visual.
