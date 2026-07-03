# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/);
versionamento conforme [SemVer](https://semver.org/lang/pt-BR/) — política em
`MF-ARCHITECTURE.md` §13.

## [Não lançado]

### Corrigido
- **Roteamento (hook)**: o padrão `RE |REsp` casava com o meio de palavras
  comuns ("sobre", "sempre"), roteando praticamente qualquer frase para
  `analise-sentenca`; substituído por padrões ancorados (achado A3 da
  revisão constitucional).
- **Hook**: classes de caracteres acentuados (`[aã]`, `[õo]`) falhavam sob
  locale C (matching byte a byte); convertidas para alternações. Cobertos
  também o imperativo "analise" e "esqueleto da petição".
- **Hook**: saída trocada do campo JSON não documentado
  `additionalSystemPrompt` para stdout simples, o contrato real do evento
  `UserPromptSubmit` (achado A4).

### Adicionado
- Teste de regressão do roteamento (`scripts/test-roteamento.sh`, 22 casos)
  integrado ao CI; varredura de padrão CNJ de número de processo em
  `scripts/validate.sh`.
- `MF-VISION-2030.md`: estrela-guia de longo prazo — problema em 5 anos,
  diferenciação, cinco ondas de capacidade, princípios invioláveis e
  métricas de missão.
- Blueprint MF-AOS: `MF-CONSTITUTION.md`, `MF-PRODUCT.md`,
  `MF-ARCHITECTURE.md`, `MF-AGENTS.md`, `MF-OPERATIONS.md`, `CLAUDE.md`.
- Fundação de engenharia: CI (validação estrutural, ShellCheck, gitleaks),
  Dependabot, templates de issue/PR, CODEOWNERS, `SECURITY.md`,
  `CONTRIBUTING.md`, `RELEASE.md`, ADRs, RFCs, playbooks, biblioteca de
  prompts, memória institucional, `CURRENT_STATE.md`, devcontainer e
  configuração de editor.

## [1.0.0] — 2026-06

### Adicionado
- Plugin `advogado-juridico` v1.0.0: hook de detecção automática de demanda
  (`UserPromptSubmit`), skill orquestradora e 17 skills jurídicas
  especializadas (ver tabela no `README.md`).
- Base de conhecimento de atos societários (IN DREI nº 81/2020).
