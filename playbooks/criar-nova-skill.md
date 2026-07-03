# Playbook: Criar nova skill

## Pré-condições (todas obrigatórias)

1. A demanda se repetiu (não é caso único).
2. Nenhuma das skills existentes cobre, nem por extensão pequena
   (verificar a tabela do `README.md`).
3. Priorizada explicitamente pelo mantenedor.

## Passos

1. Definir a que grupo funcional a skill pertence (intake, produção
   documental, inteligência jurídica, operação processual, comercial,
   contratos). Se não couber em nenhum, isso é discussão de arquitetura
   (RFC), não uma skill.
2. Criar `skills/<nome-kebab-case>/SKILL.md` seguindo o padrão das skills
   existentes: propósito, gatilhos de ativação, intake (perguntas uma a uma),
   formato de saída.
3. Se a skill produz conteúdo jurídico: incluir o aviso de rascunho para
   revisão humana (invariante do plugin).
4. Conhecimento de domínio extenso vai em `references/`, não no `SKILL.md`.
5. Registrar a skill no roteamento: atualizar
   `skills/orquestrador-juridico/references/mapa-habilidades.md` e, se
   necessário, o hook `hooks/detectar-demanda-juridica.sh`.
6. Atualizar a tabela do `README.md`.
7. Testar com um cenário de intake ponta a ponta (dado fictício).
8. Rodar `bash scripts/validate.sh`.
9. Bump MINOR em `plugin.json` + entrada no `CHANGELOG.md`.

## Pronto quando

CI verde, cenário de teste roteado corretamente pelo orquestrador, e toda a
documentação dos passos 5–6 atualizada no mesmo PR.
