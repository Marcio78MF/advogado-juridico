# RFC-0001: MF DNA — princípios decisórios do escritório como camada explícita

- **Status**: rascunho
- **Data**: 2026-07-03
- **Autor**: Claude Code, a partir de proposta do consultor externo

## Problema

O sistema aprende *o que* o escritório faz (Evolution Engine), mas não *como
o escritório pensa*: preferências decisórias estáveis (fundamentação robusta
antes de criatividade; precedente antes de tese nova; linguagem simples com
o cliente; evitar retrabalho) hoje só existem implicitamente nas escolhas do
Dr. Márcio. Sem captura explícita, cada skill redescobre — ou contraria —
esse estilo.

## Proposta

Uma camada `memory/dna.md` (nome provisório): lista curta e curada de
princípios decisórios do escritório, cada um com origem ("observado em N
decisões") e exemplos anonimizados. Diferente de playbook (procedimento) e
de prompt (instrução pontual): DNA é *critério de escolha*. Toda decisão
importante passa a perguntar "isso revela uma característica estável do modo
de decidir?" — se sim, após recorrência confirmada, vira entrada no DNA.
Skills passam a citar o DNA como contexto de estilo decisório.

## Teste da estrela-guia

Aproxima — é infraestrutura direta do "modelo de decisão do advogado"
(`MF-VISION-2030.md`, onda 5), começável hoje com custo quase zero porque é
curadoria manual, não instrumentação.

## Impacto

- Bounded contexts: transversal (estilo, não domínio).
- Skills afetadas: todas as de produção de conteúdo, como contexto.
- Risco/segurança: princípios são do escritório, não de casos — versionável
  em Git, desde que exemplos sejam anonimizados com a regra de correlação
  (revisão constitucional, achado A5).
- Custo: zero infraestrutura.

## Questões em aberto

- Quem valida uma entrada nova no DNA? (Proposta: só o Dr. Márcio — DNA é a
  identidade do escritório, não uma inferência do sistema.)
- Quantas entradas antes de virar ruído? (Proposta: máximo ~20; DNA inchado
  não é DNA.)
