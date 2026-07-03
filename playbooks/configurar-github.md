# Playbook: Configurações do GitHub (interface)

Itens da Foundation que exigem a interface do GitHub (não há API disponível
nas sessões atuais para criá-los). Executar uma vez, na ordem que preferir:

## Labels (Settings → Labels)

Criar: `bug` (vermelho), `proposta` (azul), `dependencias` (cinza),
`skill` (verde), `blueprint` (roxo), `seguranca` (laranja),
`prioridade-alta` (vermelho escuro).

## Discussions

Settings → General → Features → habilitar **Discussions**. Categorias
sugeridas: "Ideias" (novas skills/automações), "Decisões em discussão"
(RFCs), "Dúvidas de uso".

## Projects

Criar um Project "MF-AOS Roadmap" com colunas por trimestre (T1–T8),
importando os itens do backlog de `MF-PRODUCT.md` §8 como issues.

## Milestones

Uma milestone por trimestre do roadmap (`T2 — Memória`, `T3 — Auditoria`,
etc.), com as issues correspondentes.

## Wiki

Manter **desabilitada** — a documentação vive no repositório
(ADR-0001); wiki paralela criaria fonte dupla de verdade.

## Branch protection (Settings → Branches → `main`)

- Exigir PR com revisão (CODEOWNERS).
- Exigir CI verde (checks: Validar estrutura do plugin, ShellCheck,
  Varredura de segredos).
- Bloquear force-push.

## Pronto quando

Todos os itens acima conferidos e `CURRENT_STATE.md` atualizado removendo a
pendência correspondente.
