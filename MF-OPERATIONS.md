# MF-OPERATIONS — Loops, Governança e Automação

> Regido por `MF-CONSTITUTION.md`. Papéis responsáveis em `MF-AGENTS.md`,
> arquitetura de suporte em `MF-ARCHITECTURE.md`.
>
> Este documento descreve os **engines operacionais** do MF-AOS: os loops que
> fazem o sistema aprender, se auditar e operar o escritório. Cada engine tem
> uma versão mínima viável (o que fazer hoje, dentro de uma sessão do Claude
> Code, sem infraestrutura nova) e uma visão-alvo (o que ela vira quando
> automatizada).

## 1. Self Evolution Engine

Ao final de qualquer tarefa não-trivial nesta sessão, antes de considerá-la
concluída, passar pelo seguinte loop:

1. O que foi aprendido nesta tarefa que não estava documentado antes?
2. Isso se repetiu o suficiente para virar automação, skill ou playbook?
   (ver critério em `MF-AGENTS.md` §5)
3. Algum documento (`MF-*.md`, `CLAUDE.md`, `README.md`) ficou desatualizado
   por causa desta mudança? Atualizar antes de encerrar.
4. Existe uma tarefa igual já resolvida antes que deveria ter sido reutilizada
   em vez de refeita? Se sim, isso é sinal de que falta uma skill/playbook —
   registrar no backlog (`MF-PRODUCT.md` §8).

Este loop é leve por design: para a maioria das tarefas, é uma checagem de
30 segundos, não um processo formal.

## 2. Memory Engine

**Objetivo**: nenhuma informação relevante do escritório deve existir apenas
na cabeça de quem executou uma tarefa ou apenas dentro de uma sessão que será
descartada.

**Hoje (mínimo viável)**: a "memória" do sistema é o próprio repositório —
`MF-PRODUCT.md` (backlog, roadmap), histórico de commits (decisões tomadas) e
as `references/` de cada skill (conhecimento de domínio, ex.:
`skills/orquestrador-juridico/references/mapa-habilidades.md`). Toda decisão
de arquitetura ou produto relevante é registrada em um desses lugares antes
do fim da sessão.

**Visão-alvo**: um armazenamento estruturado (ver Modelo de Dados em
`MF-ARCHITECTURE.md` §4) que persiste clientes, casos e prazos entre sessões,
consultável pelas skills sem que o advogado precise repetir contexto.

**Regra permanente**: dado real de cliente nunca é escrito neste repositório
Git, em nenhuma fase (`MF-CONSTITUTION.md` §5, Security First).

## 3. Audit Engine

Nenhuma tarefa é considerada concluída sem passar pela auditoria
correspondente ao tipo de entrega:

| Tipo de entrega | Auditoria mínima obrigatória |
|---|---|
| Código/automação neste repositório | Executa/valida a mudança; revisão de segurança (não expõe dado/credencial); documentação atualizada |
| Skill nova ou alterada | Testada com um cenário de intake real (ainda que fictício); consistente com o bounded context em `MF-ARCHITECTURE.md` §9 |
| Peça, minuta, notificação ou comunicado jurídico | Aviso explícito de que é rascunho para revisão humana; checklist de conformidade da skill de origem seguido |
| Documento estratégico (`MF-*.md`) | Consistente com os demais documentos da hierarquia (`MF-CONSTITUTION.md` §7); sem contradição de Estado Atual vs. Visão-Alvo |

O Audit Engine não é um processo separado a ser "rodado depois" — é parte da
definição de pronto de qualquer tarefa.

## 4. Business Engine (visão-alvo)

Operação comercial e administrativa do escritório, construída
incrementalmente sobre o Memory Engine à medida que o roadmap avança
(`MF-PRODUCT.md`, T5): CRM de clientes, controle de honorários, agenda,
marketing e conteúdo de autoridade (`conteudo-autoridade`), métricas do
escritório. Não implementar antes de T5 sem justificativa de priorização
explícita (ver Matriz de Prioridades, `MF-PRODUCT.md` §6).

## 5. Legal Engine — fluxo de novo cliente

Sequência-alvo, hoje parcialmente coberta pela skill `onboarding-cliente` em
conjunto com `conflict-check`:

```
Novo cliente
  → Conflict check (conflict-check)                [obrigatório, bloqueante]
  → Intake estruturado (onboarding-cliente)
  → Estrutura documental do caso (pasta/organização)
  → Cronologia inicial do caso
  → Checklist de compliance (lgpd-escritorio, quando aplicável)
  → Estratégia inicial + tarefas de acompanhamento
```

Nenhuma etapa é pulada. Conflict check é sempre a primeira, mesmo sob pressão
de tempo.

## 6. Petition Engine — fluxo de nova ação

Sequência-alvo, cobrindo as skills de inteligência jurídica e produção
documental:

```
Nova ação
  → Leitura dos documentos do caso
  → Extração de fatos e provas
  → Cronologia dos eventos
  → Pesquisa de jurisprudência (pesquisa-jurisprudencia / JUS_RATIO)
  → Análise de risco (analise-risco-processual)
  → Estratégia sugerida
  → Minuta produzida (gerador-minutas / resumo-pecas)
  → Autorrevisão da minuta
  → Auditoria (Audit Engine, §3 acima)
  → Checklist final
  → Entrega ao advogado responsável para revisão e assinatura
```

A saída deste engine é sempre um **rascunho revisado internamente**, nunca
uma peça pronta para protocolo sem olhos humanos.

## 7. Command Center (visão-alvo)

Painel único de visão do escritório — jurídico, CRM, financeiro, automações.
Decisão em aberto (backlog, `MF-PRODUCT.md` §8): se será um painel textual
dentro do próprio fluxo do Claude Code ou uma interface web dedicada. Essa
decisão de arquitetura de deploy exige confirmação explícita do Dr. Márcio
antes de ser implementada (`MF-ARCHITECTURE.md` §6).

## 8. Digital Twin (visão-alvo)

Representação contínua do estado do escritório — estrutura, clientes,
casos, prazos, rotinas — que as skills e agentes consultam antes de agir, em
vez de pedir o mesmo contexto repetidamente ao advogado. É, na prática, o
Memory Engine (§2) totalmente amadurecido e consultável por todos os agentes
de domínio (`MF-AGENTS.md` §3). Não é um componente separado a ser construído
do zero.

## 9. MF Evolution Engine — aprendizado com o modo de trabalho

Diferente do Self Evolution Engine (§1), que observa **o sistema**, o MF
Evolution Engine observa **o modo de trabalhar do escritório**: que tipos de
demanda o Dr. Márcio atende, com que frequência, e com quais ferramentas.
O objetivo é transformar know-how operacional em ativo — skills, playbooks e
automações — em vez de deixá-lo preso a prompts avulsos ou à memória de quem
executa.

**Hoje (v0, implementado)**: registro anônimo e agregado em
`memory/registro-de-trabalho.md`. Ao fim de cada sessão de trabalho jurídico
relevante, registrar tipo de demanda + skill usada (nunca cliente, processo
ou conteúdo — `SECURITY.md`). Regra de promoção: **três ocorrências do mesmo
padrão sem skill dedicada** disparam uma proposta formal (template de issue
"Propor skill ou melhoria"), avaliada pelo critério de `MF-AGENTS.md` §5.

**Visão-alvo**: quando o Memory Engine persistente existir (roadmap T2), esse
registro passa a ser alimentado automaticamente pelo orquestrador a cada
demanda roteada, e o Meta Orchestrator passa a propor skills, botões e
automações proativamente — fechando o ciclo: o sistema aprende com o
advogado, não apenas com o código.

**Taxonomia — para não virar quatro módulos onde há um só ciclo**: o Self
Evolution Engine (§1) é o *loop por tarefa*; o MF Evolution Engine (este §)
é a *detecção de padrões no trabalho do advogado*; o MF Intelligence Engine
(`MF-VISION-2030.md`, onda 3) é a *instrumentação automática* que um dia
substituirá o registro manual deste §; e o Meta Orchestrator
(`MF-AGENTS.md` §1) é o *consumidor* dos três — quem lê os sinais e decide o
que propor. São estágios e papéis de um mesmo ciclo de aprendizado, não
quatro sistemas a construir separadamente.

## 10. Governança — quando parar e perguntar

Reforçando `MF-CONSTITUTION.md` §4: interromper o trabalho autônomo apenas
diante de decisão jurídica de mérito, decisão estratégica sem precedente,
impacto financeiro relevante, alteração em produção/dado real, ou ação
irreversível. Fora isso, o ciclo é: planejar → executar → auditar (§3) →
atualizar documentação (§1) → seguir para o próximo item do backlog.
