# Scripts de reconstrucao

Rede de seguranca para o que foi construido a mao dentro do Studio. Nao rode nada daqui
sem motivo: se a coisa ja existe no place e funciona, deixe como esta.

## Quando usar

- o place se perdeu e o backup mais novo nao tem alguma parte
- voce quer recriar um pedaco do zero, sem herdar ajuste manual antigo
- voce vai trabalhar em outra maquina e precisa do mesmo ponto de partida

## Como rodar

Abrir o Studio no place canonico, modo Edit, colar o conteudo do arquivo no Command Bar
e executar. Todos os scripts sao seguros para rodar de novo: cada um apaga o que ele
mesmo criou antes de recriar.

| Arquivo | O que reconstroi | Estado |
| --- | --- | --- |
| `01-BuildLobbyUI.luau` | `ReplicatedStorage.CrumbleArena.UI`, `StarterGui.CrumbleUI`, `SoundService` | escrito, **nao testado** |
| `02-BuildIslandFence.luau` | cerca de 48 postes no raio 120.5, e a barreira invisivel de 26 studs | escrito, **nao testado** |
| `03-BuildCosmeticsTent.luau` | tenda de lona da area Cosmetics e o NPC lojista PIP | escrito, **nao testado** |
| `04-ApplyEnvironment.luau` | iluminacao, ceu, nuvens e a musica do lobby | escrito, **nao testado** |

Os quatro imprimem o que fizeram e conferem o proprio resultado. O `02` conta furos na
barreira e postes flutuando, o `03` avisa se faltar peca na area, e o `04` imprime o
estado anterior da iluminacao antes de mudar, para dar como reverter.

O `UIController` nao esta neste script de proposito. A fonte dele e
`src/client/Controllers/UIController.client.luau`, que e versionada e passa no lint.
Para reinstalar, copiar aquele arquivo para `StarterPlayer.StarterPlayerScripts` como
`LocalScript` chamado `UIController`.

## O que ainda nao tem script

Estes foram construidos a mao e continuam so no place. Se o place se perder de novo,
eles se perdem junto:

- toda a geometria do lobby, que e o caso mais antigo e mais caro, ver D-P01
- a decoracao espalhada a mao ao longo das sessoes, arvore por arvore

A cerca, a tenda, o NPC e a iluminacao sairam desta lista quando os scripts `02`, `03` e
`04` foram escritos.

## Por que isto existe

Em 2026-09-04 o Studio fechou as 17:52 sem gravar o place. O ultimo save era das 16:40,
e umas quatro horas de trabalho ficaram so na memoria. O arquivo de recuperacao
automatica das 17:34 salvou quase tudo, mas por sorte, nao por processo.

A licao nao foi salvar mais vezes. Foi que trabalho caro precisa nascer de codigo
versionado. Ver D-018 em `docs/DECISIONS.md`.

## Onde a recuperacao automatica fica

```text
C:\Users\ricka\AppData\Local\Roblox\RobloxStudio\AutoSaves\
```

Nao e `Local\Roblox\AutoSaves`. O Roblox descarta esses arquivos na proxima abertura do
Studio, entao a primeira coisa a fazer numa recuperacao e copiar para `backups\`.
