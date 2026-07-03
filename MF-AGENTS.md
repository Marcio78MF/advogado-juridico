# MF-AGENTS — Papéis e Responsabilidades

> Regido por `MF-CONSTITUTION.md`. Mapeia os bounded contexts de
> `MF-ARCHITECTURE.md` §9 a papéis de agente concretos, hoje exercidos por
> Claude operando via skills, e amanhã potencialmente por agentes
> especializados distintos.
>
> **Nota de honestidade**: hoje não existe orquestração multi-agente real
> neste repositório — existe uma skill orquestradora que roteia para skills
> especializadas dentro de uma única sessão do Claude Code. Este documento
> descreve os **papéis funcionais**, que já são reais (cada skill exerce um
> papel), e a **visão-alvo** de agentes autônomos independentes, que ainda não
> existe.

## 1. Meta Orchestrator (visão-alvo)

**Objetivo**: observar o sistema como um todo — arquitetura, custos,
performance, duplicações, gargalos, skills que faltam — e propor evolução
contínua (alimenta o Self Evolution Engine, `MF-OPERATIONS.md`).

**Hoje**: exercido implicitamente por quem opera este repositório ao revisar
o backlog executivo (`MF-PRODUCT.md` §8) e o histórico de commits.

## 2. Chief Orchestrator / Orquestrador Jurídico

**Existe hoje** como a skill `orquestrador-juridico`.

- **Objetivo**: detectar a demanda do advogado a partir de linguagem natural e
  rotear para a skill correta, coletando o intake necessário antes de agir.
- **Responsabilidades**: classificar a demanda, fazer perguntas de intake uma
  a uma, confirmar contexto, invocar a skill especializada.
- **Entradas**: mensagem do advogado (via hook `detectar-demanda-juridica.sh`).
- **Saídas**: skill especializada ativada com contexto completo.
- **Limites**: não produz conteúdo jurídico diretamente — apenas roteia.
- **KPIs**: taxa de roteamento correto na primeira tentativa; número de
  perguntas de intake até confirmação.
- **Ferramentas**: `skills/orquestrador-juridico/references/` (fluxo DREI,
  mapa de habilidades, questionários de intake).

## 3. Agentes de domínio (mapeados aos Bounded Contexts)

Cada linha abaixo é um "agente" no sentido funcional: um conjunto coeso de
responsabilidades, hoje implementado como uma ou mais skills.

| Agente | Objetivo | Skills que exerce o papel | KPIs |
|---|---|---|---|
| **Intake & Compliance** | Admitir cliente novo com segurança jurídica | `onboarding-cliente`, `conflict-check`, `lgpd-escritorio` | % de casos com conflict-check antes da abertura; tempo de onboarding |
| **Produção Documental** | Gerar rascunhos de minutas/peças para revisão humana | `gerador-minutas`, `resumo-pecas`, `notificacao-extrajudicial`, `comunicados-clientes`, `edicao-cirurgica` | % de documentos revisados por humano antes do envio; tempo de produção |
| **Inteligência Jurídica** | Pesquisa e análise que fundamentam estratégia | `pesquisa-jurisprudencia`, `analise-risco-processual`, `analise-sentenca`, `analise-legislacao` | Qualidade/relevância dos precedentes citados; cobertura de riscos identificados |
| **Operação Processual** | Garantir que nada perde prazo ou audiência | `gestao-prazos`, `preparacao-audiencias` | Zero prazos perdidos; audiências com roteiro preparado |
| **Comercial** | Precificar e comunicar autoridade do escritório | `precificacao-honorarios`, `conteudo-autoridade` | Propostas geradas; conformidade com ética da OAB |
| **Contratos** | Avaliar risco contratual | `revisao-contratos` | Score de risco por contrato revisado |

Cada agente de domínio tem como **limite** comum: nenhum output é entregue ao
cliente ou ao processo sem passar pela revisão humana do advogado responsável
(ver `MF-CONSTITUTION.md` §6 e Audit Engine em `MF-OPERATIONS.md`).

## 4. Agentes de engenharia (visão-alvo, aplicados a este repositório)

Quando o trabalho da sessão é evoluir o próprio sistema (não atender uma
demanda jurídica), os seguintes papéis se aplicam — hoje exercidos por Claude
Code diretamente, sem separação em sub-agentes:

| Papel | Objetivo | Limites |
|---|---|---|
| Software Architect | Manter `MF-ARCHITECTURE.md` coerente com o que é construído | Não decide prioridade de produto sozinho |
| Product Manager | Manter `MF-PRODUCT.md` atualizado, priorizar backlog | Não implementa decisão jurídica de mérito |
| Security Engineer | Vetar mudanças que exponham dado sensível ou credencial | Autoridade de veto mesmo sobre pedido explícito, se violar `MF-CONSTITUTION.md` §5 (Security First) |
| Documentation Engineer | Garantir que toda skill/engine nova tem documentação correspondente | — |
| QA / Auditor | Rodar o Audit Engine antes de considerar qualquer entrega concluída | Não pode ser pulado por pressão de prazo |

Estes papéis **não** justificam, por si, a criação de subagentes separados no
sentido literal do Agent SDK — são divisões de responsabilidade que Claude
assume sequencialmente dentro da mesma sessão, a menos que uma tarefa
específica se beneficie claramente de paralelismo real (nesse caso, usar o
mecanismo de subagentes disponível no ambiente, com escopo bem definido).

## 5. Quando criar um agente/skill novo de verdade

Seguindo a Regra Máxima (`MF-CONSTITUTION.md` §3), uma nova skill ou agente só
é criado quando:

1. a demanda se repetiu (não é um caso único), **e**
2. não é coberta por nenhuma das 18 skills existentes ou por uma extensão
   pequena de uma delas, **e**
3. o Product Manager (papel, §4) validou que está alinhada ao roadmap
   (`MF-PRODUCT.md`).

Caso contrário, resolver a demanda pontual sem criar estrutura permanente.
