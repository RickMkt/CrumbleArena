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
| `01-BuildLobbyUI.luau` | `ReplicatedStorage.CrumbleArena.UI`, `StarterGui.CrumbleUI`, `SoundService.LobbyMusic` e `SoundService.SFX` | escrito, **nao testado** |

O `UIController` nao esta neste script de proposito. A fonte dele e
`src/client/Controllers/UIController.client.luau`, que e versionada e passa no lint.
Para reinstalar, copiar aquele arquivo para `StarterPlayer.StarterPlayerScripts` como
`LocalScript` chamado `UIController`.

## O que ainda nao tem script

Estes foram construidos a mao e continuam so no place. Se o place se perder de novo,
eles se perdem junto:

- cerca da borda da ilha, 193 pecas, e as 36 barreiras invisiveis de 26 studs
- tenda e NPC lojista da area Cosmetics
- iluminacao, ceu e nuvens
- toda a geometria do lobby, que e o caso mais antigo e mais caro, ver D-P01

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
