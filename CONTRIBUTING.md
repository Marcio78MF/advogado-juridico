# Guia de Contribuição

## Antes de tudo

Duas regras inegociáveis: nunca commitar dado real de cliente
(`SECURITY.md`) e nunca criar skill que duplica uma existente (verifique a
tabela do `README.md` antes; ver `playbooks/criar-nova-skill.md`).

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

A versão vive em `.claude-plugin/plugin.json`; a tabela de tipos acima
define o bump. O processo de release está em `RELEASE.md`.

## Estrutura de uma skill

```
skills/<nome-da-skill>/
├── SKILL.md          # obrigatório — instruções da skill
└── references/       # opcional — conhecimento de domínio
```

Toda skill que produz conteúdo jurídico deve preservar o aviso de rascunho
para revisão humana — invariante de produto deste plugin, sem exceção. O
mesmo vale para citações: dispositivo, súmula ou precedente sem verificação
em fonte deve ser marcado `[CONFERIR NA FONTE]`.

## Decisões de arquitetura

Mudanças estruturais exigem um ADR em `docs/adr/` (template incluso).
Propostas maiores, ainda em discussão, começam como RFC em `docs/rfc/`.

**Decision Replay** (RFC-0002): todo ADR preenche o campo "Origem" e todo
commit que materializa uma decisão cita o artefato no corpo da mensagem
(`Ref: ADR-0003`). Desde a separação (ADR-0004), decisões novas do MF-AOS
são registradas no repositório privado; aqui entram apenas ADRs
estritamente do plugin.
