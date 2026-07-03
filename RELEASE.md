# Processo de Release

## Quando lançar

- **PATCH**: acumulou correções de conteúdo em skills existentes.
- **MINOR**: skill nova pronta e auditada (`MF-OPERATIONS.md` §3).
- **MAJOR**: mudança de comportamento do orquestrador/hook ou remoção de skill.

## Passos

1. Garantir `main` verde no CI.
2. Atualizar a versão em `.claude-plugin/plugin.json`.
3. Mover as entradas de `[Não lançado]` no `CHANGELOG.md` para a nova versão,
   com data.
4. Atualizar `CURRENT_STATE.md` se o estado implementado mudou.
5. Commit `chore(release): vX.Y.Z` e tag anotada `vX.Y.Z` em `main`
   (via PR — nunca push direto).
6. Criar o Release no GitHub apontando para a tag, com o trecho do changelog.

## O que não fazer

- Release com CI vermelho.
- Release que descreve visão-alvo como funcionalidade entregue.
- Tag sem entrada correspondente no `CHANGELOG.md`.
