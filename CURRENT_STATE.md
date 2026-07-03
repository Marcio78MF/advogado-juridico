# CURRENT_STATE — Estado Real do Sistema

> Fonte única de verdade sobre **o que existe de fato** no MF-AOS, mantida
> pelo papel de Meta Orchestrator (`MF-AGENTS.md` §1). Atualizar sempre que o
> estado implementado mudar — descrever visão-alvo como implementada é
> violação de `MF-CONSTITUTION.md` §6.

**Última atualização**: 2026-07-03

## Implementado e funcional

| Componente | Estado |
|---|---|
| Plugin `advogado-juridico` v1.0.1 | Funcional (instalação local); roteamento corrigido e coberto por 22 testes de regressão |
| Hook `UserPromptSubmit` de detecção de demanda | Funcional |
| Skill orquestradora + 17 skills especializadas | Funcionais (ver `README.md`) |
| Blueprint MF-AOS (7 documentos, incl. `MF-VISION-2030.md`) | Publicado |
| CI: validação estrutural, ShellCheck, gitleaks | Configurado (valida a partir do próximo push) |
| Governança: templates, CODEOWNERS, SECURITY, CONTRIBUTING, ADRs, RFCs | Publicado |
| Playbooks, biblioteca de prompts, memória institucional | Estrutura criada, conteúdo inicial |

## Não implementado (visão-alvo)

| Componente | Situação | Referência |
|---|---|---|
| Memory Engine persistente (clientes/casos/prazos) | **RFC-0004 APROVADA** (ADR-0003/0004); plano técnico do `mf-memoria` v1 aguardando aprovação; nada implementado | `docs/design/mf-memoria-v1.md` |
| Audit Engine automatizado | Hoje é checklist manual (PR template) | `MF-OPERATIONS.md` §3 |
| Meta-Orquestrador como agente autônomo | Hoje é papel exercido manualmente | `MF-AGENTS.md` §1 |
| MF Evolution Engine (aprendizado com o modo de trabalho) | v0 manual implementado (`memory/registro-de-trabalho.md`); automação no backlog | `MF-OPERATIONS.md` §9 |
| Integrações Google Workspace / WhatsApp | Roadmap T4+ | `MF-ARCHITECTURE.md` §8 |
| Business Engine (CRM, honorários) | Roadmap T5 | `MF-OPERATIONS.md` §4 |
| Command Center / Mission Control | Roadmap T6; formato ainda não decidido | `MF-OPERATIONS.md` §7 |
| Monorepo (pnpm/TurboRepo), Docker | Adiado deliberadamente | `docs/adr/0002-adiar-monorepo.md` |
| Engines de longo prazo: Intelligence, Cost Intelligence, Knowledge Graph, Prediction, AI Quality, Business Brain | Visão (ondas 3–5) | `MF-VISION-2030.md` §4 |

## Pendências que dependem do Dr. Márcio

- **Executar a separação de repositórios** (DECIDIDA — ADR-0004): criar o
  repositório privado do MF-AOS e migrar os documentos de negócio (Fase F0
  do plano `docs/design/mf-memoria-v1.md`); a criação do repo é ato do Dr.
  Márcio ou de sessão com acesso autorizado a ele.
- Escolha de licença do plugin público (destravada pelo ADR-0004; requer
  verificação de autoria junto a Misael Holanda).
- **Aprovar o plano técnico do `mf-memoria` v1**
  (`docs/design/mf-memoria-v1.md`) — gate final antes do primeiro código.
- Ativar Discussions/Wiki/Projects/labels no GitHub (configuração de
  interface, sem API disponível nesta sessão) — passo a passo em
  `playbooks/configurar-github.md`.
- Formato do Command Center (painel no fluxo do Claude Code vs. web).
