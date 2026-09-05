# CLAUDE.md

Instrucoes curtas para quem abre este projeto. As fontes canonicas estao em `docs/`.
Este arquivo nao repete conteudo, ele aponta.

## Leia antes de editar qualquer coisa

| Arquivo | Quando |
| --- | --- |
| `docs/PROJECT-MEMORY.md` | sempre. Regras permanentes do projeto |
| `docs/CURRENT-STATE.md` | sempre. Onde o trabalho parou |
| `docs/DECISIONS.md` | antes de decidir qualquer coisa que ja possa ter sido decidida |
| `docs/SESSION-LOG.md` | para saber o que foi validado com evidencia |
| `docs/LOBBY-BUILD-PARAMS.md` | antes de mexer em geometria do lobby |
| `docs/ASSET-INVENTORY.md` | antes de inserir qualquer asset |

Se dois documentos divergirem, vale a decisao mais recente registrada em
`SESSION-LOG.md` ou `DECISIONS.md`, e a divergencia precisa ser registrada.

## Caminhos

- Projeto: `C:\Users\ricka\Desktop\CrumbleArena`
- Place canonico: `CrumbleArena\CrumbleArena.rbxl`, ver D-013
- Backups: `backups\`, somente leitura
- Acervo de consulta: `C:\Users\ricka\Desktop\PromoteMe\skilllab`, somente leitura

Nao abrir `C:\Users\ricka\Documents\CrumbleArena.rbxl`. E um baseplate vazio obsoleto.

## Proibido sem autorizacao explicita

Commit, push, publicar o place, comprar asset, apagar arquivo, `git reset`, alterar
PromoteMe ou SkillLab, alterar arquivos em `backups\`.

## Idioma

Codigo e identificadores em ingles. Documentacao e relatorio em portugues. Sem travessao
longo em nenhum documento.

## Salvamento

A integracao MCP nao salva o place. Ao fim de cada marco: voltar ao modo Edit, atualizar
`CURRENT-STATE.md` e `SESSION-LOG.md`, parar e pedir `Ctrl + S` ao usuario. So continuar
depois da confirmacao. Isso existe porque o trabalho da sessao 002 quase se perdeu, ver
sessao 003 no `SESSION-LOG.md`.

## Comandos

```bash
rojo build -o build.rbxl
stylua src tests
selene src
selene --config tests/selene.toml tests
lune run tests/GameConfig.spec.luau
```
