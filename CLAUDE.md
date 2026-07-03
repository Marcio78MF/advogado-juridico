# CLAUDE.md — Instruções Operacionais do Claude Code neste Repositório

Este repositório é o **MF Autonomous Operating System (MF-AOS)**: hoje,
concretamente, o plugin Claude Code `advogado-juridico` (orquestrador + 18
skills jurídicas para o escritório Márcio França Advocacia). O blueprint
completo de visão, arquitetura e operação vive em seis documentos que devem
ser tratados como contexto permanente desta sessão:

0. `MF-VISION-2030.md` — a estrela-guia de longo prazo. Toda proposta de
   funcionalidade nova deve responder "isso aproxima ou afasta o MF-AOS
   desta visão?" e a qual onda de capacidade pertence (§4 e §7 de lá).
1. `MF-CONSTITUTION.md` — princípios imutáveis e regras de autonomia. Leia
   primeiro; em caso de dúvida sobre "devo fazer isso ou perguntar", a
   resposta está lá (§4).
2. `MF-PRODUCT.md` — visão, roadmap de 24 meses, matriz de prioridades e
   backlog executivo. Consulte antes de propor algo fora do roadmap atual.
3. `MF-ARCHITECTURE.md` — arquitetura técnica, modelo de domínio, dados,
   segurança. Consulte antes de qualquer mudança estrutural.
4. `MF-AGENTS.md` — mapeamento entre bounded contexts, papéis e as skills
   existentes em `skills/`. Consulte antes de criar uma skill nova, para
   confirmar que não duplica uma existente.
5. `MF-OPERATIONS.md` — os loops de auditoria, memória e evolução contínua
   que definem quando uma tarefa está realmente concluída.

Não é necessário repetir o conteúdo desses documentos nas respostas ao Dr.
Márcio — apenas segui-los. Se uma tarefa contradizer algo escrito neles,
sinalizar a contradição em vez de simplesmente ignorá-la.

## Estado real do sistema

O que existe de fato, hoje, neste repositório:

```
.claude-plugin/plugin.json     — manifesto do plugin (v1.0.0)
hooks/detectar-demanda-juridica.sh   — hook UserPromptSubmit
skills/orquestrador-juridico/  — roteador de demanda
skills/<17 outras>/            — skills especializadas (ver README.md)
.github/                       — CI, Dependabot, templates, CODEOWNERS
docs/adr/, docs/rfc/           — decisões e propostas de arquitetura
playbooks/, prompts/, memory/  — procedimentos, prompts e memória institucional
scripts/validate.sh            — validação estrutural (rodar antes de todo PR)
CURRENT_STATE.md               — fonte única de verdade do estado implementado
```

A fonte de verdade detalhada sobre o que existe vs. visão-alvo é
`CURRENT_STATE.md` — consultar antes de reportar progresso ao Dr. Márcio, e
atualizar sempre que o estado implementado mudar.

## Loop pós-tarefa obrigatório

Ao fim de qualquer tarefa não-trivial: rodar `bash scripts/validate.sh`;
aplicar o Audit Engine (`MF-OPERATIONS.md` §3); atualizar `CURRENT_STATE.md`
e o documento `MF-*.md` afetado; e, se a tarefa foi trabalho jurídico,
acrescentar uma linha anônima em `memory/registro-de-trabalho.md`
(MF Evolution Engine, `MF-OPERATIONS.md` §9).

## Como trabalhar nesta base

- **Antes de criar uma skill nova**: verificar `MF-AGENTS.md` §3 (mapa de
  bounded contexts) e o `README.md` (tabela das 18 skills). Só criar se a
  demanda não é coberta por extensão de uma skill existente
  (`MF-AGENTS.md` §5).
- **Skills seguem o padrão existente**: cada skill tem `SKILL.md` e, quando
  necessário, `references/` com conhecimento de domínio (ver
  `skills/orquestrador-juridico/references/` como exemplo).
- **Nunca commitar dado real de cliente**: nome de cliente real, número de
  processo real, conteúdo de peça real ou credencial. O repositório versiona
  capacidade (skills, docs, automação), não dado de caso.
- **Toda skill que produz conteúdo jurídico** (minuta, petição, notificação,
  comunicado) deve preservar o aviso de que é rascunho para revisão humana —
  isso é uma invariante do produto (`MF-ARCHITECTURE.md` §3), não apenas
  texto do `README.md`.
- **Ao terminar uma tarefa não-trivial**, rodar mentalmente o loop do Self
  Evolution Engine (`MF-OPERATIONS.md` §1) antes de reportar como concluída.
- **Auditoria antes de "pronto"**: aplicar a tabela de `MF-OPERATIONS.md` §3
  conforme o tipo de entrega.

## Convenções de commit e branch

- Desenvolver na branch designada para a tarefa em curso; nunca fazer push
  direto para `main` sem instrução explícita.
- Mensagens de commit em português, descrevendo o "porquê", seguindo o
  padrão já usado no histórico (`feat: ...`, etc.).
- Nunca usar `--no-verify`, `--force` ou reescrever histórico publicado sem
  pedido explícito do Dr. Márcio.

## Quando parar e perguntar

Ver `MF-CONSTITUTION.md` §4. Resumo: decisão jurídica de mérito, decisão
estratégica sem precedente nos documentos de produto/arquitetura, impacto
financeiro relevante, mudança em produção/dado real, ou ação irreversível.
Fora isso, seguir o roadmap e o backlog de `MF-PRODUCT.md` de forma autônoma.

## Manutenção deste blueprint

Os documentos `MF-*.md` e este `CLAUDE.md` não são estáticos. Ao final de
qualquer tarefa que mude arquitetura, roadmap, papéis ou processo de
operação, atualizar o documento correspondente na mesma sessão — documentação
desatualizada é tratada como tarefa incompleta (`MF-CONSTITUTION.md` §5,
Documentation First).
