# Colaboracao: Henrique + segundo desenvolvedor

Estado: procedimento preparado, NAO implantado. Nao houve publicacao, convite, sync,
commit ou push nesta tarefa. Aprovar e preencher IDs/usuarios antes de executar.

## Responsabilidades e contexto

Cloud/Team Create: mapa, assets, ambiente e testes no mesmo Place privado.
GitHub + Rojo: codigo, configs, docs, ferramentas e revisao. Cada humano usa conta
propria; nao compartilhar credenciais, tokens ou sessoes de IA.
RBXL continua checkpoint. Git nao carrega RBXL/backups/assets ignorados.

Fontes reaproveitadas, sem duplicacao:
- VISION: CRUMBLE-ARENA-MASTER-PLAN.md + PROJECT-MEMORY.md.
- LOBBY-DIRECTION: AGENTS.md + decisoesD-025 + PLANO-A2-LOBBY.md (historico).
- ROADMAP.md: fases existentes, com atualizacao de transicao.
- ASSET-INVENTORY.md + ASSET-PACKS-2026-09-07.md: procedencia.
- KNOWN-ISSUES.md: indice de riscos; auditorias completas preservadas.
- HANDOFF.md e handoffs/TEMPLATE.md: ownership por tarefa.
Um agente novo le AGENTS, CURRENT-STATE e seu HANDOFF. Chat nao e fonte oficial.

## Exclusividade de Studio

**ONLY ONE AI STUDIO WRITER AT A TIME.**

Registro oficial ao vivo: uma unica issue privada GitHub "Studio Writer", URL a
preencher apos configurar remote. Ate la, nenhum turno automatico; os dois humanos
devem confirmar explicitamente o grant na mesma conversa de coordenacao.

Henrique e coordenador inicial. Somente ele publica grants; cada grant contem
ID unico, UniverseId/PlaceId, OWNER, agente, scope, inicio UTC, expiracao e ACK de ambos.
A issue serve de registro humano, NAO mutex atomico. Clones podem estar desatualizados.
Agentes nao podem adquirir grant so editando HANDOFF/CURRENT-STATE.

Transferencia:
1. Writer anterior para MCP, Command Bar, helpers e DESCONECTA o Rojo/plugin.
2. Registra trabalho, evidencia, checkpoint/versao e declara RELEASED.
3. Outro humano confirma que nao ha escritor residual; coordenador publica novo grant.
4. Sucessor confere registro online e ACK; mede fingerprint duas vezes em Edit.
5. So entao escreve. Expiracao/desconexao exige nova confirmacao, nao tomada automatica.

Geometria mudar sem sua acao: parar, preservar evidencias e avisar; nao reconciliar
silenciosamente. Fingerprint estavel nao prova exclusividade. Colaborador "inativo"
tambem pode ter agente/servico rodando. Humanos podem usar Team Create juntos,
mas nao editam o scope bloqueado durante o bloco da IA.

Rojo e qualquer deploy de codigo no DataModel CONTAM como writer. O segundo pode
editar/testar codigo offline, fazer QA read-only, Blender, docs ou UI isolada.
Branches Git diferentes NAO isolam o Place cloud. Desconectar sync antes de trocar branch.

## Checklist: publicar PRIVADO, somente apos autorizacao de Henrique

1. Revisar estado em memoria no Edit. Aprovar o passe visual atual e o checkpoint.
2. Preservar o RBXL de disco anterior em backup novo, sem sobrescrever backup existente.
   Depois salvar/exportar o estado aprovado do Studio em arquivo local datado.
   Registrar timestamp, bytes, SHA256, BaseParts e origem. Confirmar que o backup
   e do estado aprovado, nao apenas uma copia velha do disco.
3. Guardar backup em armazenamento privado acessivel aos dois, com acesso restrito;
   nao depender do .gitignore como backup. Registrar localizacao, sem credenciais.
4. Confirmar dono desejado: conta de Henrique ou grupo existente aprovado.
   Nao criar/transferir grupo automaticamente.
5. No Place correto, usar File > Publish to Roblox para criar a experiencia,
   revisar nome e Creator antes de confirmar. Nao sobrescrever outra experiencia.
   Esta confirmacao exige autorizacao explicita, independente de preparar docs.
6. Novas experiencias sao privadas por padrao; conferir no Creator Dashboard
   que o acesso/audiencia permanece Private. NAO selecionar Public nem Limited
   como substituto de Private. Registrar UniverseId e PlaceId inicial.
7. No Studio da experiencia cloud, abrir Collaborate/Manage Collaborators.
   Se a interface pedir ativacao de colaboracao/Team Create, ativa-la.
   Verificar requisitos de conta/idade mostrados pelo Roblox; nao contorna-los.
8. Para experiencia de usuario, adicionar a conta Roblox correta do amigo (amizade
   necessaria para Edit) e selecionar Edit. Play sozinho nao permite construir.
   Salvar permissoes. Nao dar ownership nem acessos administrativos desnecessarios.
   Em grupo, usar papel minimo por experiencia, nao editar todas as experiencias.
9. Ambos abrem pelo Creator Dashboard > Shared With Me / Edit in Studio (ou grupo).
   Conferir mesmo UniverseId/PlaceId e lista Live Collaborators. Nao abrir dois RBXLs.
10. Testar juntos leitura, selecao e uma alteracao descartavel acordada, com um
    writer por vez; reverter o teste. Conferir Output e carregamento de assets.
    Edit e permissao ampla, nao isolamento por pasta; scope depende do processo.
11. Conferir acesso privado e permissoes novamente. Registrar evidencias, IDs,
    checkpoint e aceite dos dois em CURRENT-STATE/HANDOFF.
12. Apenas depois declarar cloud fonte canonica. Place local vira checkpoint.
    Nunca enviar RBXL antigo por cima do cloud para "atualizar" sem reconciliacao.

Team Create persiste alteracoes automaticamente. "Nao publicar" nao impede sync
ou autosave de edicoes cloud. Checkpoint/versao antes de cada bloco e rollback
por scope sao obrigatorios; restaurar Place inteiro pode apagar trabalho do colega.
Ver historico de versoes no Creator Dashboard/Studio antes de restaurar, com ambos parados.
Requisitos de idade podem impedir entrada mesmo com Edit; consultar a documentacao oficial.
Nao solicitar ao agente documentos de identidade nem credenciais.

## GitHub e branches

Auditoria local: remote inexistente; master existe mas nao contem necessariamente o
art pass atual. Henrique deve revisar dirty tree, comparar runtime e escolher baseline.
Nao renomear master para main nem promover feat/lobby-art-pass automaticamente.

Apos aprovacao: configurar repositorio privado/remote, convidar amigo com acesso de
escrita necessario (nao Admin), proteger branch estavel com PR + review quando o
plano GitHub permitir. Se indisponivel, adotar regra humana equivalente.

Exemplo de fluxo FUTURO, substituir placeholders; nao executar contra dirty tree:
```sh
git clone <URL_PRIVADA_APROVADA>
cd CrumbleArena
git status --short
git fetch origin
git switch <BRANCH_ESTAVEL_APROVADA>
git pull --ff-only origin <BRANCH_ESTAVEL_APROVADA>
git switch -c feat/<tarefa-unica>
# trabalhar, testar e revisar somente scope
git diff --check
git diff
git add <arquivos-da-tarefa>
git commit -m "<mudanca especifica>"
git push -u origin feat/<tarefa-unica>
# abrir PR; outro desenvolvedor revisa; merge somente aprovado
```
Uma branch por tarefa/pessoa; nao compartilhar feature branch. Exemplos:
feat/community-corner, feat/leaderboard-qa, feat/gameplay-round-contract, fix/ui-safe-area.
Nada de git add ., force push compartilhado, commits misturados ou descarte de trabalho.
Conflito no mesmo sistema: parar e combinar owner, nao resolver cegamente.
Depois do merge, atualizar branch estavel com ff-only. Commits/push dependem de
autorizacao da tarefa; este guia nao e autorizacao permanente para agentes.

## Rojo: gate de migracao obrigatorio

Toolchain existente em rokit.toml: Rojo7.7.0, StyLua2.5.2, Selene0.31.0, Lune0.10.5.
default.project.json mapeia:
- src/shared -> ReplicatedStorage.Shared
- src/server -> ServerScriptService.Server
- src/client -> StarterPlayer.StarterPlayerScripts.Client
Nao mapeia Workspace nem StarterGui. Build nao reproduz mapa/GUI completa.

O UIController versionado documenta instancia direta em StarterPlayerScripts;
o mapping cria Client/Controllers/UIController. Ha risco de dois controllers.
D-017 mantem GUI no Place com copia em codigo; a migracao para fonte Git e proposta,
nao realidade pronta. Nao apagar nem conectar sync para "resolver" automaticamente.

Gate antes de conectar ao Team Create:
1. Inventariar caminhos, Source e dependencias dos scripts reais no Place e no Git.
2. Reconciliar trabalho runtime com Henrique; decidir paths e ownership explicitos.
3. Testar projeto Rojo numa copia de teste autorizada, nunca substituir Place pelo build.
4. Revisar diff inicial do plugin; rejeitar delecoes/duplicacoes inesperadas.
   Avaliar ignoreUnknownInstances onde necessario, sem tratar isso como garantia universal.
5. Rodar testes, comparar UI e garantir unico controller ativo.
6. Aprovar migracao em PR, checkpoint cloud e sync pelo unico writer designado.
7. A partir do aceite, scripts mapeados sao editados em Git, nao simultaneamente
   no Script Editor. Codigo do Place nao coberto precisa de migracao/handoff proprio.

## Fontes oficiais consultadas em 2026-09-07

- [Roblox: publicar experiencia privada](https://create.roblox.com/docs/production/publishing/publish-games-and-places)
- [Roblox: permissoes, colaboradores e requisitos de idade](https://create.roblox.com/docs/projects/collaboration)
- [Rojo: formato e ignoreUnknownInstances](https://rojo.space/docs/v7/project-format/)
- [Rojo: limites de sincronizacao](https://rojo.space/docs/v7/sync-details/)

Rotulos da interface podem mudar; parar se a tela nao corresponder ao procedimento.
