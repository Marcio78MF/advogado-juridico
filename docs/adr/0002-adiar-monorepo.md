# ADR-0002: Adiar monorepo, TurboRepo, Docker e CodeQL até existir código de aplicação

- **Status**: aceito
- **Data**: 2026-07-03
- **Decisores**: Claude Code (papel de CTO, conforme autonomia de MF-CONSTITUTION.md §4)

## Contexto

A Fase 2 (Foundation) solicitada listava, entre outros itens: arquitetura
monorepo, pnpm workspace, TurboRepo, diretórios `apps/`, `packages/`,
`libs/`, `infra/`, Docker, Compose e CodeQL.

O estado real do repositório hoje: um plugin Claude Code composto de
Markdown (skills) e um hook shell. **Não existe nenhuma linha de
JavaScript/TypeScript, nenhum serviço, nenhum build.**

`MF-CONSTITUTION.md` §6 proíbe explicitamente superengenharia: construir
infraestrutura antes de a funcionalidade que a usa existir.

## Decisão

1. **Monorepo (pnpm/TurboRepo), `apps/`, `packages/`, `libs/`, `infra/`,
   Docker e Compose**: adiados. Serão introduzidos no mesmo PR que trouxer o
   primeiro código de aplicação real — previsivelmente o Command Center
   (roadmap T6, `MF-PRODUCT.md`) ou o Memory Engine persistente (T2), o que
   vier primeiro.
2. **CodeQL**: adiado pelo mesmo motivo, e também porque CodeQL não analisa
   shell script — não há linguagem suportada no repositório hoje. A varredura
   de segurança ativa é gitleaks (segredos) + ShellCheck (hook e scripts).
3. Tudo o mais da Foundation (CI, Dependabot, templates, governança, ADRs,
   RFCs, playbooks, bibliotecas de prompt/memória, devcontainer) **foi
   implementado agora**, porque valida e governa o que já existe.

## Alternativas consideradas

- Criar o monorepo vazio agora "para estar pronto": descartado — diretórios
  vazios com tooling parado apodrecem (versões de pnpm/Turbo desatualizadas
  antes do primeiro uso) e violam a Constituição.

## Consequências

- O repositório permanece simples e 100% coberto pelo CI atual.
- A introdução do monorepo é uma tarefa consciente e rastreável no backlog
  (`MF-PRODUCT.md` §8), não um legado pré-instalado.
- Este ADR deve ser marcado como "substituído" quando essa migração ocorrer.
