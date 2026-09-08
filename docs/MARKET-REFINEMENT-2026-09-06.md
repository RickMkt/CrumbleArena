# Market refinement, 2026-09-06

Pedido: melhorar Market, personalizar dummy e expandir studs pelo lobby.

## Preservacao

Save anterior confirmado: CrumbleArena.rbxl, 620348 bytes, 11:21:56 -03.
Rollback completo em ServerStorage.MarketRefinementRollback_1121.LobbyBeforeRefinement.
Nenhum backup anterior alterado. Novas mudancas aguardam Ctrl + S.

## Alteracoes

Removidos da cena ativa os dois totens de gamepasses e ServicePad neon. Placas
originais reaproveitadas em molduras compactas. Toldo elevado, madeira e teal
harmonizados, sinalizacao legivel, estoque agrupado. NPC recebeu roupa autoral
de explorador/comerciante, com chapeu, oculos, bolsa e detalhes no casaco.

Studs nativos ampliados nas Parts em bloco, sem novas pecas fisicas de studs.
2473 faces alteradas em 467 Parts; total de 476 pecas com Surface Studs.
Textos, personagens, luzes e malhas nao foram cobertos indiscriminadamente.
Nao declarar 'tudo texturizado': 178 MeshParts e faces inclinadas permanecem pendentes.

## Creator Store

Busca real stylized low poly rock: 5 resultados, nenhum importado.
Inventario hair hat accessory e stud: 0 resultados.
Creator Store studs texture: 5 resultados, nenhum importado por falta de
procedencia/licenca suficiente para esta etapa: 18878366001, 14905298664,
7447638611, 16280131717, 3142967182. NPC usa apenas rig existente e geometria autoral.

## Evidencia

1010 BaseParts, contra 1063 anteriores. Zero nao ancoradas, scripts, Remotes e
PackageLinks no lobby. Oito rigs clonados em Play, WalkSpeed 18, salto desativado,
concluiram oito percursos: Spawn/Core, Market, SocialArea, informacao e Outlook.
Todos Passed=true; duracoes entre 2.18 e 7.99 segundos. Probes removidas; Studio Edit.
Isso valida esses percursos, nao equivale a auditoria integral de toda colisao.

Output: Infinite yield possible on Players.KittyPatife.PlayerGui:WaitForChild("CrumbleUI"),
UIController linha 18. Fora do escopo visual; nao corrigido.

Capturas inline reais: Market_Before_Refinement, Market_Refined_Verified,
Pip_Explorer_Close, Market_Final_NativeStuds. Sem arquivos PNG locais retornados.

Git: feat/lobby-art-pass, mudancas anteriores preservadas, src/ intocado.
Scripts 09/10 registrados, nao certificados como rebuild integral em copia descartavel.
Sem commit, push, publicacao ou salvamento automatizado.
