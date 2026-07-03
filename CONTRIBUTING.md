# Guia de Contribuição

## Antes de tudo

Leia `MF-CONSTITUTION.md`. Toda contribuição — humana ou por agente de IA —
segue os princípios de lá. Em particular: nunca commitar dado real de cliente
(`SECURITY.md`) e nunca criar skill que duplica uma existente
(`MF-AGENTS.md` §5).

## Fluxo de trabalho

1. Crie uma branch a partir de `main` (nunca commit direto em `main`).
2. Faça a mudança e rode `bash scripts/validate.sh`.
3. Abra um PR preenchendo o template — o checklist do Audit Engine é
   obrigatório, não decorativo.
4. CI verde (validação estrutural + ShellCheck + varredura de segredos) é
   pré-requisito de merge.

## Conventional Commits

Mensagens em português, no formato:

```
<tipo>[escopo opcional]: <descrição no imperativo, focada no porquê>
```

| Tipo | Uso | Efeito no SemVer |
|---|---|---|
| `feat` | Skill nova ou capacidade nova | MINOR |
| `fix` | Correção de comportamento | PATCH |
| `docs` | Blueprint, README, playbooks | — |
| `chore` / `ci` | Infraestrutura, CI, tooling | — |
| `refactor` | Reorganização sem mudança de comportamento | — |
| `feat!` / `BREAKING CHANGE` | Mudança que quebra o orquestrador ou remove skill | MAJOR |

## Versionamento (SemVer)

A versão vive em `.claude-plugin/plugin.json` e segue a política de
`MF-ARCHITECTURE.md` §13. O processo de release está em `RELEASE.md`.

## Estrutura de uma skill

```
skills/<nome-da-skill>/
├── SKILL.md          # obrigatório — instruções da skill
└── references/       # opcional — conhecimento de domínio
```

Toda skill que produz conteúdo jurídico deve preservar o aviso de rascunho
para revisão humana — invariante de produto (`MF-ARCHITECTURE.md` §3).

## Decisões de arquitetura

Mudanças estruturais exigem um ADR em `docs/adr/` (template incluso).
Propostas maiores, ainda em discussão, começam como RFC em `docs/rfc/`.
