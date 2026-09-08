# CRUMBLE ARENA

Instrucao persistente principal para agentes. Leia, nesta ordem:
1. `docs/CURRENT-STATE.md`
2. `docs/HANDOFF.md` e o handoff atribuido
3. `docs/COLLABORATION.md`
4. `docs/PROJECT-MEMORY.md`; depois as fontes especificas da tarefa.

Sem handoff atribuido, nao executar features. Instrucoes explicitas do usuario prevalecem;
para conflitos historicos, consultar DECISIONS e o registro mais recente em SESSION-LOG.

## Jogo e direcao

Roblox competitive arena game: ate 8 jogadores quebram arenas em camadas para fazer
oponentes cair. O chao e a arma. Picareta, pa, bola de neve, blocos destrutiveis,
rounds, intermissao, cosmeticos, leaderboards e lobby social compoem o vocabulario.
Nao confundir vocabulario planejado com gameplay implementado.

Visual: Roblox nativo polido, low-poly, claro, colorido, studs sutis, formas de
brinquedo sem LEGO literal, silhuetas legiveis e composicao artesanal.
Evitar AI slop, simulator generico, arcos aleatorios, ruinas sem funcao, decoracao
procedural repetitiva, simetria excessiva, portais, map vote fisico, particulas
excessivas, fantasia generica, monetizacao gigante, clutter e Toolbox aleatoria.

A macroestrutura da ilha esta aprovada como base. Preservar CentralPlaza/Crumble Core,
Market (antigo Pip's Market, letreiro atual CRUMBLE SUPPLY), SocialArea/fogueira,
Information/leaderboards, Outlook e caminhos de chegada. Community e uma intencao;
nao presumir que exista uma pasta Community ativa. Refinar integracao, composicao,
identidade e acabamento, nao reconstruir a ilha nem simplesmente adicionar objetos.
MOST WINS e MOST KOs sao paineis; somente MOST DONATES mostra avatar. Sem transacoes reais.

## Fontes de verdade

Ate a migracao aprovada: Place local de Henrique em
`C:\Users\ricka\Desktop\CrumbleArena\CrumbleArena.rbxl`.
Branch de referencia: `feat/lobby-art-pass`. Outros clones usam sua propria raiz,
nao tentam acessar o caminho Windows de Henrique.
Depois do aceite registrado: experiencia PRIVADA no Team Create e fonte do mapa.
GitHub e fonte de scripts, configs, docs e ferramentas; RBXL e checkpoint, nao merge diario.
Migracao Rojo ainda nao validada: NAO conectar automaticamente ao Place compartilhado.

## ONLY ONE AI STUDIO WRITER AT A TIME

Vale para todos os agentes, computadores, MCPs, Command Bar, plugins e Rojo.
Um branch, clone ou worktree separado NAO isola o DataModel cloud.
Consultar o registro ao vivo definido em COLLABORATION e obter confirmacao dos dois
humanos. Um HANDOFF local ou `STUDIO WRITE: allowed` sozinho NAO concede o turno.
Estado ausente, desatualizado, expirado ou conflitante = NAO ESCREVER.
Nenhum agente se autoconcede exclusividade. Humanos podem colaborar, mas congelam o
scope durante uma operacao da IA. Mudanca inexplicada na geometria = parar e avisar.

## Antes / durante / depois de Studio

Antes: confirmar projeto, UniverseId/PlaceId (ou arquivo local), hierarquia, Edit,
writer, scope, rollback e BEFORE visual. Medir fingerprint, aguardar/reconferir;
estabilidade ajuda a detectar mudancas, nao prova ausencia de outro writer.
Durante: uma mudanca verificavel por bloco, somente scope; problemas externos vao ao backlog.
Depois: AFTER, delta BaseParts, scripts/imports, colisao/CanTouch/CanQuery pertinentes,
Output e avaliacao visual. Relatar o que nao foi testado. Concluir antes de trocar de area.
Nao salvar Place local nem publicar sem aprovacao. Team Create tem persistencia automatica:
nao prometer que uma alteracao cloud ficara apenas em memoria.

## Assets

Registrar nome, origem/criador/licenca, AssetId, MeshId, TextureId, SurfaceAppearance,
scripts/remotes/packages, animacoes, emitters, colisao, escala e part count.
Inventario: docs/ASSET-INVENTORY.md e docs/ASSET-PACKS-2026-09-07.md.
Selecao visual nao equivale a licenca aprovada. Rejeitar ou isolar codigo desnecessario,
nao executar scripts desconhecidos. Identificar instancia correta por isolamento
temporario reversivel antes de diagnosticar malha. Nunca investigar familia errada.

## Git, seguranca e validacao

Uma branch por tarefa/pessoa, scope e arquivos exclusivos. Fetch/pull somente com
working tree protegido; PR e review antes de merge. Nao fazer force push compartilhado.
Nao fazer commit, push, publicacao, compra ou exclusao definitiva sem autorizacao.
Nao tocar PromoteMe, ClientStep, SkillLab, outro clone/worktree ou backups existentes.
Preservar alteracoes alheias. Editar arquivos com apply_patch; nao resetar trabalho.

Servidor autoritativo: cliente pede, servidor valida. Nao inventar gameplay pronto.
Comandos existentes: `stylua --check src tests`, `selene src`,
`selene --config tests/selene.toml tests`, `lune run tests/GameConfig.spec.luau`.
`rojo build` gera apenas arvore mapeada, NAO o lobby completo.
Nao reexecutar tools/rebuild em lote: scripts sao historicos e podem aposentar objetos.
Documentar em portugues, identificadores em ingles, sem travessao longo.
