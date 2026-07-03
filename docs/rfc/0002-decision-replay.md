# RFC-0002: Decision Replay — reconstruir a história de qualquer decisão

- **Status**: aceita (2026-07-03 — adotada na prática pelos ADR-0003/0004,
  que estreiam o campo "Origem"; convenção registrada em `CONTRIBUTING.md`)
- **Data**: 2026-07-03
- **Autor**: Claude Code, a partir de proposta do consultor externo

## Problema

Daqui a cinco anos, "como chegamos nesta arquitetura?" precisa ter resposta
reconstituível: decisão → alternativas rejeitadas → discussão → commit. Os
ingredientes já existem (ADRs, RFCs, decision-log, mensagens de commit
descritivas, histórico Git), mas não há convenção de *ligação* entre eles —
a trilha existe, o replay não.

## Proposta

Não criar ferramenta nova; criar convenção de encadeamento e cumpri-la:

1. Todo ADR cita a RFC ou discussão que o originou (quando houver) e os
   ADRs que substitui.
2. Todo commit que materializa uma decisão cita o ADR/RFC no corpo da
   mensagem (`Ref: ADR-0002`).
3. Toda entrada do `memory/decision-log.md` referencia o artefato mais
   próximo (ADR, RFC, playbook ou commit).
4. O template de ADR ganha o campo "Origem" para fechar a cadeia.

Com isso, `git log --grep "ADR-0002"` + o próprio ADR reconstroem qualquer
decisão. Custo: disciplina, não código.

## Teste da estrela-guia

Aproxima — sustenta o princípio "o sistema nunca finge ser o que não é"
(`MF-VISION-2030.md` §5.4) estendido ao passado: também não esquece por que
é o que é. Onda-independente: é higiene, aplicável já.

## Impacto

- Bounded contexts: nenhum (meta-processo).
- Risco/segurança: nenhum novo.
- Custo: zero.

## Questões em aberto

- Adotar já como convenção obrigatória em `CONTRIBUTING.md`? (Proposta: sim,
  na próxima atualização de governança — é barato e o custo de adotar tarde
  é história perdida.)
