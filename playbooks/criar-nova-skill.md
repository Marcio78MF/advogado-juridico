# Playbook: Criar nova skill

## Pré-condições (todas obrigatórias — `MF-AGENTS.md` §5)

1. A demanda se repetiu (não é caso único).
2. Nenhuma das skills existentes cobre, nem por extensão pequena
   (verificar `README.md` e `MF-AGENTS.md` §3).
3. Alinhada ao roadmap (`MF-PRODUCT.md`) ou priorizada explicitamente.

## Passos

1. Definir o bounded context da skill (`MF-ARCHITECTURE.md` §9). Se não
   couber em nenhum, isso é uma discussão de arquitetura (RFC), não uma skill.
2. Criar `skills/<nome-kebab-case>/SKILL.md` seguindo o padrão das skills
   existentes: propósito, gatilhos de ativação, intake (perguntas uma a uma),
   formato de saída.
3. Se a skill produz conteúdo jurídico: incluir o aviso de rascunho para
   revisão humana (invariante — `MF-ARCHITECTURE.md` §3).
4. Conhecimento de domínio extenso vai em `references/`, não no `SKILL.md`.
5. Registrar a skill no roteamento: atualizar
   `skills/orquestrador-juridico/references/mapa-habilidades.md` e, se
   necessário, o hook `hooks/detectar-demanda-juridica.sh`.
6. Atualizar a tabela do `README.md` e `MF-AGENTS.md` §3.
7. Testar com um cenário de intake ponta a ponta (dado fictício).
8. Rodar `bash scripts/validate.sh`.
9. Bump MINOR em `plugin.json` + entrada no `CHANGELOG.md`.

## Pronto quando

CI verde, cenário de teste roteado corretamente pelo orquestrador, e toda a
documentação dos passos 5–6 atualizada no mesmo PR.
