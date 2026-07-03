# MF-PRODUCT — Visão, Roadmap e Priorização

> Regido pelos princípios de `MF-CONSTITUTION.md`. Detalhes técnicos de como
> cada item é construído estão em `MF-ARCHITECTURE.md`; papéis responsáveis
> estão em `MF-AGENTS.md`.

## 1. Visão do produto

Um sistema operacional de IA para escritórios de advocacia que reduz o tempo
entre "o advogado tem uma demanda" e "a demanda está resolvida com qualidade
e revisão humana adequada" — cobrindo desde a admissão de um cliente novo até
a produção de peças, gestão de prazos, comunicação e, no horizonte de 24
meses, a operação comercial e financeira do escritório.

Hoje o produto é um **plugin Claude Code** (`advogado-juridico`): um
orquestrador que detecta a demanda do advogado em linguagem natural e aciona
uma de 18 skills especializadas. Essa é a fundação sobre a qual o MF-AOS será
construído — não um sistema paralelo.

## 2. Missão

Dar ao Dr. Márcio (e, no futuro, a outros escritórios) uma alavanca de
produtividade jurídica que preserva o julgamento profissional como etapa
final e obrigatória de qualquer entrega.

## 3. Objetivos

**Curto prazo (0–3 meses)**
- Consolidar o orquestrador e as 18 skills como base estável e testada.
- Criar a Constituição e o Blueprint (este conjunto de documentos).
- Definir o mapeamento formal de skills → agentes (`MF-AGENTS.md`).

**Médio prazo (3–12 meses)**
- Implementar Memory Engine mínimo viável (estado do escritório persistido
  fora da sessão: clientes, casos, prazos).
- Implementar Audit Engine mínimo viável (checklist de revisão pós-tarefa).
- Integrar ao menos um canal externo real (Google Drive ou Google Calendar)
  para reduzir trabalho manual de organização documental e agenda.

**Longo prazo (12–24 meses)**
- Command Center: painel único cobrindo jurídico, CRM, financeiro e
  automações.
- Suporte a múltiplos usuários dentro do mesmo escritório (staff, estagiários).
- Arquitetura pronta para multi-tenant, caso a expansão a outros escritórios
  seja decidida.

## 4. Roadmap de 24 meses

| Trimestre | Foco | Entregáveis principais |
|---|---|---|
| T1 (0–3m) | Fundação | Blueprint (`MF-*.md`, `CLAUDE.md`), hardening do orquestrador e das 18 skills, testes manuais de regressão por skill |
| T2 (3–6m) | Memória | Memory Engine v1 (registro estruturado de clientes/casos/prazos fora da sessão), Legal Engine v1 (fluxo de novo cliente automatizado) |
| T3 (6–9m) | Auditoria | Audit Engine v1 (checklist automático pós-entrega: código, segurança, qualidade jurídica, LGPD), Petition Engine v1 (fluxo assistido de nova ação) |
| T4 (9–12m) | Integrações | Google Workspace (Drive, Calendar, Gmail) conectados às skills relevantes (`gestao-prazos`, `onboarding-cliente`, `comunicados-clientes`) |
| T5 (12–15m) | Operação | Business Engine v1: CRM básico de clientes e honorários dentro do próprio sistema |
| T6 (15–18m) | Comando | Command Center v1: painel executivo com visão de casos, prazos e pendências |
| T7 (18–21m) | Escala | Revisão de arquitetura para multi-tenant (se decisão de negócio confirmar expansão) |
| T8 (21–24m) | Consolidação | Auditoria completa de segurança, performance e custos; definição da v2 do roadmap |

Este roadmap é revisado a cada trimestre fechado; a versão vigente é sempre
a deste arquivo, não uma cópia externa.

## 5. Estratégia de custos

- Priorizar o que já está disponível (Claude Code, Google Workspace que o
  escritório já usa) antes de adotar ferramentas pagas novas.
- Qualquer custo recorrente novo (SaaS, API paga, infraestrutura) é uma
  decisão financeira relevante — ver limites de autonomia em
  `MF-CONSTITUTION.md` §4.
- Preferir soluções que escalam em uso (pay-as-you-grow) a compromissos fixos
  enquanto o produto atende um único escritório.

## 6. Matriz de prioridades

| Critério | Peso |
|---|---|
| Reduz risco jurídico ou de prazo (perda de prazo, conflito de interesse) | Alto |
| Reduz tempo de tarefa repetitiva do advogado | Alto |
| Aumenta receita (honorários, novos clientes) | Médio-alto |
| Melhora experiência do cliente final | Médio |
| Melhora arquitetura/base para itens futuros | Médio |
| Estético ou "seria legal ter", sem uso recorrente identificado | Baixo — não priorizar |

Qualquer item de backlog é classificado por esses critérios antes de entrar
em um trimestre do roadmap.

## 7. Matriz de riscos

| Risco | Impacto | Mitigação |
|---|---|---|
| Peça/documento gerado por IA sem revisão humana chega ao cliente ou ao processo | Alto | Aviso legal obrigatório + checklist de revisão em toda skill de produção de documento (ver Audit Engine, `MF-OPERATIONS.md`) |
| Vazamento de dado sensível de cliente (sigilo profissional, LGPD) | Alto | Skill `lgpd-escritorio`, princípio Security First, nunca versionar dado real de cliente neste repositório |
| Conflito de interesse não detectado ao aceitar novo caso | Alto | Skill `conflict-check` obrigatória no fluxo de novo cliente (Legal Engine) |
| Perda de prazo processual | Alto | Skill `gestao-prazos` +, quando existir, integração com Google Calendar |
| Dependência excessiva de uma única sessão de IA sem persistência | Médio | Memory Engine (T2 do roadmap) |
| Expansão prematura para "produto multi-escritório" sem validar com um só escritório | Médio | Regra Máxima em `MF-CONSTITUTION.md` — não superengenheirar antes do uso real |

## 8. Backlog executivo (vivo)

> Backlog de alto nível. Detalhamento técnico de cada item vive em issues do
> GitHub quando aplicável.

- [x] Publicar `MF-CONSTITUTION.md`, `MF-ARCHITECTURE.md`, `MF-PRODUCT.md`,
      `MF-AGENTS.md`, `MF-OPERATIONS.md`, `CLAUDE.md` (este blueprint).
- [x] Mapear as 18 skills existentes aos papéis de agente (`MF-AGENTS.md`).
- [x] Fundação de engenharia: CI, Dependabot, templates, CODEOWNERS,
      SECURITY, CONTRIBUTING, CHANGELOG, RELEASE, ADRs, RFCs, playbooks,
      prompts, memória institucional, `CURRENT_STATE.md`, devcontainer.
- [x] MF Evolution Engine v0 (registro manual de padrões de trabalho —
      `MF-OPERATIONS.md` §9).
- [ ] Configurações de interface do GitHub: labels, milestones, Projects,
      Discussions, branch protection (`playbooks/configurar-github.md` —
      depende do Dr. Márcio).
- [ ] Decidir a licença do repositório (decisão jurídica — Dr. Márcio).
- [ ] Introduzir monorepo/tooling junto com o primeiro código de aplicação
      (ADR-0002).
- [ ] Desenhar o esquema mínimo de dados do Memory Engine (clientes, casos,
      prazos) — ver `MF-ARCHITECTURE.md` §Modelo de Dados.
- [ ] Especificar o checklist do Audit Engine por tipo de entrega (peça,
      código, comunicado).
- [ ] Avaliar qual integração do Google Workspace traz mais retorno imediato
      (Calendar para prazos vs. Drive para documentos).
- [ ] Definir formato do Command Center (painel textual dentro do fluxo do
      Claude Code vs. interface web dedicada) — decisão de arquitetura a ser
      tomada com o Dr. Márcio antes de implementar (ver `MF-ARCHITECTURE.md`
      §Arquitetura de Deploy).
