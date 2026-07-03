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

## Projects e Milestones

Planejamento de produto vive no repositório privado do MF-AOS (ADR-0004);
aqui, usar issues/milestones apenas para manutenção do plugin.

## Wiki

Manter **desabilitada** — a documentação vive no repositório
(ADR-0001); wiki paralela criaria fonte dupla de verdade.

## Branch protection (Settings → Branches → `main`)

- Exigir PR com revisão (CODEOWNERS).
- Exigir CI verde (checks: Validar estrutura do plugin, ShellCheck,
  Varredura de segredos).
- Bloquear force-push.

## Pronto quando

Todos os itens acima conferidos.
