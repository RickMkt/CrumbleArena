# Assets do Crumble Arena

Esta pasta nao guarda arte bruta. Ela guarda a politica e, mais adiante, os arquivos ja
preparados para o Roblox.

## De onde vem o asset

O acervo bruto e o SkillLab, em `Desktop\PromoteMe\skilllab\toolbox\`. Ele e somente
leitura para este projeto. Nao mover, nao alterar, nao duplicar.

Estado do acervo em 2026-09-03: 77 pacotes catalogados, 21 baixados e extraidos, todos com
licenca verificada. A lista do que interessa ao Crumble Arena esta em
`docs/ASSET-INVENTORY.md`.

## Caminho de um asset ate o jogo

```text
SkillLab raw  ->  subconjunto escolhido  ->  ajuste de escala e pivo  ->  assets/roblox/
   somente leitura      so o que a fase usa       fora do Git             versionado
```

Cada etapa exige a anterior completa. Nada pula fila.

## Antes de importar qualquer modelo

1. Confirmar que o pacote esta aprovado em `docs/ASSET-INVENTORY.md`.
2. Confirmar que a licenca esta arquivada em `skilllab/toolbox/licenses/<asset_key>/`.
3. Inspecionar o modelo antes de inserir. Se vier de fonte que permite script, auditar
   todos os descendentes.
4. Nunca executar script encontrado dentro de asset.
5. Registrar a importacao no inventario, com data e finalidade.

## O que nunca fazer

1. Usar arquivo sem licenca arquivada.
2. Usar modelo gratuito de origem desconhecida.
3. Importar pacote inteiro quando a fase precisa de cinco pecas.
4. Subir textura 4K para uso em gameplay mobile.
5. Passar de 20.000 triangulos por mesh, e chegar perto disso em objeto repetido.
6. Tratar a palavra free como se fosse licenca.
7. Misturar dois temas de interface no mesmo jogo.
8. Copiar mapa, personagem, interface, nome ou som de outro jogo.

## Git

`assets/raw/` e `assets/normalized/` estao no `.gitignore`. O que se versiona e a decisao,
o registro de origem e o arquivo final ja preparado, nunca o pacote bruto.
