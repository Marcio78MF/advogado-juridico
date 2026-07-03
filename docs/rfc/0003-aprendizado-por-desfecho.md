# RFC-0003: Aprendizado por desfecho — correlacionar ações e resultados

- **Status**: rascunho
- **Data**: 2026-07-03
- **Autor**: Claude Code, a partir de proposta do consultor externo

## Problema

O Evolution Engine aprende com a *execução* (o que se repete), mas não com o
*desfecho* (o que funcionou): petição acolhida ou rejeitada, acordo célere
ou arrastado, recurso provido ou improvido, cliente satisfeito ou não. Sem o
desfecho, o sistema cataloga padrões sem saber quais valem a pena — organiza
conhecimento, mas não evolui a prática com base em evidência.

## Proposta

Estender o modelo de dados do Memory Engine (`MF-ARCHITECTURE.md` §4) com a
dimensão de desfecho: em Caso, o resultado e a duração por fase; em
Documento, o desfecho processual da peça (acolhida/parcial/rejeitada) e os
argumentos/precedentes centrais; em Cliente, sinal de satisfação. Com massa
suficiente, o sistema responde: "quais estratégias tiveram maior êxito em
ações de consignado?", "que fundamentação gera menos emendas?", "que fluxo
de atendimento satisfaz mais?".

Pré-requisitos duros, na ordem: Memory Engine operante (onda 2) →
instrumentação (onda 3) → só então correlação (esta RFC, onda 4, alimentando
Prediction Engine e Business Brain). Registrar desfecho é trabalho humano no
início — o custo de captura precisa caber na rotina do escritório, ou os
dados nascerão enviesados pelos casos em que alguém lembrou de anotar.

## Teste da estrela-guia

Aproxima — é a ponte entre "lembrar" e "antecipar" (`MF-VISION-2030.md`,
ondas 2→4) e muda a natureza do ativo: de memória do que fizemos para
evidência do que funciona. Gate: não iniciar antes de a onda 2 provar valor.

## Impacto

- Bounded contexts: Inteligência Jurídica (consumidor), Operação Processual
  (fonte de desfechos), Comercial (satisfação).
- Risco/segurança: desfechos vivem no Memory Engine, fora do Git, sob sigilo
  e LGPD; correlação estatística nunca exposta de forma que identifique caso
  (achado A5 da revisão constitucional se aplica em dobro).
- Risco metodológico: amostras pequenas geram "evidência" espúria — exigir
  N mínimo antes de qualquer recomendação baseada em desfecho.
- Custo: campos a mais no modelo de dados; o caro é a disciplina de captura.

## Questões em aberto

- Qual o N mínimo por tipo de ação antes de o sistema poder afirmar "essa
  estratégia funciona melhor"?
- Como capturar satisfação do cliente sem fricção (NPS? sinal implícito)?
