# Estado atual

Atualizado em 2026-09-04, sessao 007, depois do incidente de perda e da recuperacao.
Este arquivo diz onde o trabalho parou. Ele e reescrito a cada marco, nao acumula
historico. O historico fica em `SESSION-LOG.md`.

---

## Atencao ao abrir o Studio

O place canonico foi **substituido pelo arquivo de recuperacao automatica das 17:34**.
Ao abrir, conferir se a interface, a cerca e o NPC estao la, e **salvar com `Ctrl + S`
imediatamente**. Enquanto nao houver esse save, o place canonico e um arquivo de
recuperacao, nao um save de verdade.

Existe um `CrumbleArena.rbxl.lock` orfao, de 11:49, deixado pelo Studio que fechou. Ele
pode gerar aviso de arquivo em uso na abertura. Nao foi apagado porque apagar arquivo
depende de autorizacao. Se atrapalhar, pode apagar sem risco.

## Place

| Item | Valor |
| --- | --- |
| Caminho canonico | `C:\Users\ricka\Desktop\CrumbleArena\CrumbleArena.rbxl` |
| Conteudo atual | recuperacao automatica de 2026-09-04 17:34, 320 KB |
| Ultimo save manual de verdade | 2026-09-04 16:40, preservado em `backups\` |
| `PlaceId` | 0, nunca publicado |

### Backups

| Arquivo | Quando | O que tem |
| --- | --- | --- |
| `CrumbleArena-SAVEDFILE-2026-09-03T2106.rbxl` | 2026-09-03 21:06 | baseplate vazio, historico |
| `CrumbleArena-AUTORECOVERY-2026-09-04T0131.rbxl` | 2026-09-04 01:31 | lobby da sessao 002 |
| `CrumbleArena-SAVEDFILE-2026-09-04T1640.rbxl` | 2026-09-04 16:40 | lobby ate o Marco 4, sem interface |
| `CrumbleArena-AUTORECOVERY-2026-09-04T1734.rbxl` | 2026-09-04 17:34 | **com interface, cerca, NPC e musica** |

Todos conferidos por SHA-256 contra a origem.

## O que deve estar no place recuperado

Confirmado por varredura de marcadores no binario, comparando com o save de 16:40:

| Marcador | Recuperacao 17:34 | Save 16:40 |
| --- | --- | --- |
| `CrumbleUI` | 3 | 1 |
| `UIController` | 1 | 0 |
| `UIConfig` e `MockData` | 2 e 2 | 0 e 0 |
| `LobbyMusic` | 1 | 0 |
| `FencePost` | 1 | 0 |
| `ShopPrompt` e `TentCloth` | 1 e 1 | 0 e 0 |

A varredura tem falso negativo, porque o formato comprime parte das strings. Marcador
que aparece prova presenca, marcador que nao aparece nao prova ausencia. **A conferencia
de verdade so acontece abrindo o Studio.**

## Etapa em andamento

Fase 1 do roadmap, polimento do lobby.

| Marco | Escopo | Estado |
| --- | --- | --- |
| 1 a 4 | lobby, studs, degraus, praca, cores | concluidos e salvos |
| 5 | primeira GUI funcional e preview do HUD | construido e testado, **so no arquivo de recuperacao** |
| 6 | cerca da borda, barreira, tenda com NPC, musica, iluminacao | construido, **testado em parte**, so no arquivo de recuperacao |
| 7 | decoracao com assets do Creator Store | interrompido no meio |

## O que foi feito na sessao 007, antes da perda

1. Cerca completa na borda da ilha, 48 postes e 193 pecas no raio 120.5, com todos os
   postes assentados no chao.
2. Barreiras invisiveis elevadas de 18 para 26 studs. Continuidade conferida: 0 falhas em
   720 direcoes por 5 alturas. Teste de fuga com pulo em 6 direcoes: 0 fugas.
3. 16 objetos afastados para nao cruzar a cerca, incluindo a arvore grande da area social.
4. Tenda de Cosmetics rebaixada, toldo de 19.6 para 13.4, balcao mais raso, laterais e
   fundo de lona, 37 pecas novas.
5. NPC lojista `PIP`, 23 pecas autorais, com `BillboardGui` e `ProximityPrompt` ligado ao
   painel de Cosmetics.
6. Musica do lobby definida: `Skip in Your Step (b)`, APM Music, `rbxassetid://9038305339`,
   125.2 s conferidos em Play, instrumental sem voz.
7. Iluminacao e ceu ajustados, nuvens mais densas.
8. Dois pacotes do Creator Store auditados em quarentena, ambos limpos, sem script.

## Pendencias

- **conferir o place recuperado e salvar com `Ctrl + S`**
- terminar a decoracao com os pacotes ja auditados, que ficou pela metade
- o `ProximityPrompt` do NPC nao pode ser testado por tecla na sessao remota, porque o
  input simulado nao chega. A ligacao foi conferida por leitura do codigo ativo. Falta
  testar a mao
- teste em celular real, R-007
- D-P01 e D-P03 a D-P08 em aberto

## Bloqueios reais

O Studio esta fechado. Nada pode ser feito no place ate ele reabrir.

## Proxima tarefa

Abrir o Studio no place canonico, conferir interface, cerca e NPC, salvar com `Ctrl + S`,
e so entao continuar a decoracao.
