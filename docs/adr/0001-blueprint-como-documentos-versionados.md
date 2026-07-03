# ADR-0001: Blueprint como documentos versionados, não prompt monolítico

- **Status**: aceito
- **Data**: 2026-07-03
- **Decisores**: Dr. Márcio (aprovação), Claude Code (proposta)

## Contexto

O MF-AOS nasceu de um "prompt mestre" extenso descrevendo papéis, missão,
engines e regras. Prompts monolíticos degradam: são difíceis de manter, não
têm diff revisável e misturam visão futura com estado atual.

## Decisão

O blueprint vive em seis documentos versionados no repositório
(`MF-CONSTITUTION.md`, `MF-PRODUCT.md`, `MF-ARCHITECTURE.md`, `MF-AGENTS.md`,
`MF-OPERATIONS.md`, `CLAUDE.md`), carregados como contexto permanente de cada
sessão via `CLAUDE.md`. Cada documento distingue explicitamente **Estado
Atual** de **Visão-Alvo**.

## Alternativas consideradas

- Prompt único de várias páginas: descartado pela manutenção e pelo risco de
  o modelo tratar visão como realidade.
- Wiki externa: descartada — documentação fora do repositório não entra no
  contexto da sessão nem no fluxo de revisão por PR.

## Consequências

- Toda mudança de arquitetura/roadmap/papéis exige atualizar o documento
  correspondente na mesma sessão (Documentation First).
- Documentação desatualizada é tratada como tarefa incompleta.
