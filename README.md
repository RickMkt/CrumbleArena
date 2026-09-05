# Crumble Arena

Party game competitivo para Roblox. Ate 8 jogadores quebram o chao de uma arena de blocos
para derrubar os adversarios nas camadas de baixo. O ultimo jogador de pe vence o round.

> Frase mental do jogo: o chao e a arma.

**Estudio:** `StudioName: TBD`. O nome definitivo ainda nao foi escolhido. Crumble Arena e
o primeiro titulo e serve para criar e validar a base de producao que os proximos jogos
vao reaproveitar.

## Estado atual

Fase 1 em andamento. Nao existe gameplay implementado. Existe a estrutura do repositorio,
os contratos compartilhados, a documentacao de direcao e o **lobby construido no Studio**,
com 1291 pecas, navegavel e testado. O place ainda nao foi salvo em arquivo. Ver
[docs/ROADMAP.md](docs/ROADMAP.md) para o que vem depois e
[docs/SESSION-LOG.md](docs/SESSION-LOG.md) para o que foi feito quando.

## Comandos

Build de verificacao, gera um place local e nao e versionado:

```bash
rojo build -o build.rbxl
```

Sincronizar com o Studio:

```bash
rojo serve
```

Formatar:

```bash
stylua src tests
```

Lint do codigo de jogo, biblioteca padrao do Roblox:

```bash
selene src
```

Lint dos testes, biblioteca padrao do Luau porque eles rodam no Lune:

```bash
selene --config tests/selene.toml tests
```

Testes puros, sem abrir o Studio:

```bash
lune run tests/GameConfig.spec.luau
```

## Estrutura

```text
src/client/     interface, camera, feedback. Pede, nunca decide.
src/server/     autoridade. Decide rounds, eliminacoes e destruicao.
src/shared/     contratos de tipo e numeros de balanceamento.
tests/          testes puros rodados no Lune.
assets/         politica e apontamentos de asset. O acervo bruto vive fora daqui.
docs/           fonte de verdade do projeto.
legacy/         MVP anterior de 2026-05, preservado como referencia. Nao e build.
```

## Documentacao

| Arquivo | Para que serve |
| --- | --- |
| [docs/CRUMBLE-ARENA-MASTER-PLAN.md](docs/CRUMBLE-ARENA-MASTER-PLAN.md) | visao, conceito e limites de escopo |
| [docs/TECHNICAL-ARCHITECTURE.md](docs/TECHNICAL-ARCHITECTURE.md) | autoridade, rede, dados e desempenho |
| [docs/LOBBY-SPEC.md](docs/LOBBY-SPEC.md) | especificacao do lobby, primeira entrega |
| [docs/ROADMAP.md](docs/ROADMAP.md) | fases 0 a 7 com criterio de aceite |
| [docs/LOBBY-BUILD-PARAMS.md](docs/LOBBY-BUILD-PARAMS.md) | numeros exatos do lobby construido |
| [docs/ASSET-INVENTORY.md](docs/ASSET-INVENTORY.md) | assets aprovados, origem e licenca |
| [docs/DECISIONS.md](docs/DECISIONS.md) | decisoes tomadas e decisoes ainda em aberto |
| [docs/SESSION-LOG.md](docs/SESSION-LOG.md) | historico por sessao |

## Originalidade

O jogo nao usa nome, asset, textura, mapa, interface, som ou marca de terceiro. A
referencia e a sensacao de arena de blocos destrutiveis, nao um jogo especifico. Todo
asset externo entra pelo processo descrito em [assets/README.md](assets/README.md) e so
depois de licenca verificada.
