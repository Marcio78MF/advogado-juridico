# CLAUDE.md — Instruções para trabalhar neste repositório

Este é o repositório **público** do plugin Claude Code `advogado-juridico`:
orquestrador + 18 skills jurídicas + hook de roteamento. O blueprint
estratégico do MF-AOS (visão, roadmap, memória institucional do escritório)
vive em repositório **privado** separado — ver
`docs/adr/0004-separacao-repositorios.md`. Não reintroduzir aqui documentos
de negócio, memória operacional ou instruções específicas de um escritório.

## Regras inegociáveis

- **Nunca commitar dado real de cliente**: nome, número de processo,
  conteúdo de peça real ou credencial (`SECURITY.md`). O CI varre padrões
  CNJ/CPF/CNPJ e segredos, mas a regra vale antes do CI.
- **Toda skill que produz conteúdo jurídico** (minuta, petição, notificação,
  comunicado) preserva o aviso de rascunho para revisão humana — invariante
  do produto.
- **Nenhuma citação sem fonte verificada**: dispositivo, súmula ou
  precedente não verificado é marcado `[CONFERIR NA FONTE]`.

## Como trabalhar

- Skill nova: seguir `playbooks/criar-nova-skill.md` (pré-condições
  incluídas — não duplicar skill existente; ver tabela do `README.md`).
- Mudança no hook (`hooks/detectar-demanda-juridica.sh`): rodar
  `bash scripts/test-roteamento.sh` — nenhuma mudança de roteamento entra
  sem os 22+ casos verdes.
- Antes de todo PR: `bash scripts/validate.sh`.
- Skills seguem o padrão: `SKILL.md` (mecânica) + `references/`
  (conhecimento de domínio em Markdown puro).

## Convenções

- Branch designada para a tarefa; nunca push direto em `main`.
- Commits em português, Conventional Commits, descrevendo o porquê
  (`CONTRIBUTING.md`); decisões citam o artefato (`Ref: ADR-XXXX`).
- Nunca `--no-verify`, `--force` ou reescrita de histórico publicado sem
  pedido explícito do proprietário.
- SemVer em `.claude-plugin/plugin.json`; release via `RELEASE.md`.
