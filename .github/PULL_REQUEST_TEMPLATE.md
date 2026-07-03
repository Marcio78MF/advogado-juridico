## O que muda

<!-- Descreva o quê e, principalmente, o porquê. -->

## Tipo de mudança

- [ ] Skill nova (`feat`, bump MINOR)
- [ ] Ajuste em skill existente (`fix`/`docs`, bump PATCH)
- [ ] Mudança no orquestrador ou hook (`feat!`/`fix`, avaliar bump MAJOR)
- [ ] Documentação / blueprint (`docs`)
- [ ] Infraestrutura / CI (`chore`, `ci`)

## Checklist (Audit Engine — MF-OPERATIONS.md §3)

- [ ] `scripts/validate.sh` passa
- [ ] Nenhum dado real de cliente, número de processo ou credencial no diff
- [ ] Skill de conteúdo jurídico preserva o aviso de rascunho para revisão humana
- [ ] Documentação correspondente atualizada (`MF-*.md`, `README.md`, `CURRENT_STATE.md`)
- [ ] Versão em `plugin.json` ajustada se o comportamento do plugin mudou
