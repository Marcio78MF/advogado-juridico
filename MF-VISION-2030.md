# MF-VISION-2030 — A Estrela-Guia do MF-AOS

> Este não é um documento técnico. É o documento que toda decisão futura —
> técnica, de produto ou de negócio — deve confrontar com uma única pergunta:
> **"isso aproxima ou afasta o MF-AOS desta visão?"**
>
> Hierarquia: este documento responde ao **porquê de longo prazo**. Os
> princípios operacionais estão em `MF-CONSTITUTION.md` (que prevalece em
> conflito de conduta); o roadmap executável de 24 meses está em
> `MF-PRODUCT.md`. Nada aqui é promessa de prazo — é direção.

## 1. A estrela-guia em uma frase

Em 2030, o MF-AOS não é um software que o escritório usa — é a forma como o
escritório **pensa, lembra e decide**, com o Dr. Márcio (e cada advogado que
o sistema vier a servir) sempre como a autoridade final e insubstituível.

## 2. Que problema o sistema resolve em 5 anos

O problema central da advocacia de pequeno e médio porte não é falta de
ferramenta — é que **o conhecimento operacional do escritório evapora**:

- Cada petição excelente é escrita uma vez e esquecida como método.
- Cada negociação bem-sucedida vive só na memória de quem negociou.
- Cada erro (prazo apertado, tese que não colou, cliente mal precificado) é
  reaprendido do zero.
- O advogado passa a maior parte do tempo em trabalho que não exige o seu
  julgamento — e o tempo que exige julgamento chega sem contexto preparado.

Em 2030, o MF-AOS resolve isso: **nenhum aprendizado do escritório se perde**.
Todo padrão vira skill, todo processo vira playbook, toda decisão vira
precedente interno consultável. O advogado chega em cada decisão com o
contexto completo já montado — e gasta seu tempo apenas naquilo que só um
advogado pode fazer.

## 3. O que o torna diferente de qualquer outro software jurídico

Software jurídico tradicional automatiza **tarefas** (peticionamento, prazos,
CRM). O MF-AOS captura **o modo de decidir do escritório**:

1. **Ele aprende com o advogado, não apenas com dados.** O MF Evolution
   Engine (`MF-OPERATIONS.md` §9) observa como o Dr. Márcio trabalha e
   transforma repetição em capacidade. Nenhum concorrente entrega isso porque
   nenhum concorrente vive dentro do fluxo de trabalho real.
2. **O conhecimento é um ativo versionado, auditável e portável.** Skills,
   playbooks, ADRs e memória institucional vivem em Git — o know-how do
   escritório não fica refém de um fornecedor nem de uma sessão de IA.
3. **O humano no circuito é invariante de arquitetura, não feature.**
   Concorrentes tratam revisão humana como fricção a eliminar; o MF-AOS a
   trata como a razão de existir do sistema (ver §5).
4. **Ele é dono do próprio ciclo de evolução.** O sistema se audita, se
   documenta e propõe as próprias melhorias — a distância entre "percebemos
   um padrão" e "temos uma capacidade nova" tende a zero.

## 4. Capacidades a adquirir ao longo do tempo

Cinco ondas. Cada onda só começa quando a anterior gera valor real em uso —
nunca por ansiedade de roadmap (`MF-CONSTITUTION.md` §6).

### Onda 1 — Assistir (hoje)
O sistema executa bem demandas roteadas: minutas, análises, prazos,
comunicados. **Estado: implementado** (plugin + 18 skills).

### Onda 2 — Lembrar
Memory Engine persistente: clientes, casos, prazos e documentos sobrevivem
entre sessões; o advogado nunca repete contexto. Digital Twin do escritório
como consequência natural.

### Onda 3 — Observar (o "sistema nervoso")
- **MF Intelligence Engine**: camada passiva que só observa — quais skills
  são usadas, quanto tempo cada demanda leva, o que se repete, o que nunca é
  usado, onde o tempo se perde — e produz relatórios periódicos. É a
  maturação instrumentada do Evolution Engine v0.
- **Cost Intelligence**: horas economizadas, custo por demanda, ROI do
  sistema, respondendo mensalmente "quanto o MF-AOS devolveu ao escritório?"

### Onda 4 — Antecipar
- **Knowledge Graph**: o acervo deixa de ser busca (RAG) e vira grafo —
  cliente → processo → tese → precedente → peça → skill originada. A pergunta
  "onde já usamos essa tese e o que aconteceu?" tem resposta em segundos.
- **Prediction Engine**: ao abrir um caso novo, o sistema apresenta os casos
  internos semelhantes, a estratégia que funcionou, os precedentes usados e
  os riscos observados — antes de ser perguntado.
- **AI Quality Engine**: toda saída de IA passa por validação em camadas
  (jurídica, técnica, de linguagem, estratégica, de segurança, de
  consistência) antes de chegar ao advogado — o Audit Engine
  (`MF-OPERATIONS.md` §3) automatizado e expandido.

### Onda 5 — Aconselhar
- **Business Brain**: o sistema passa a enxergar o escritório como um sócio
  enxergaria — concentração de carteira, áreas subatendidas, ticket médio por
  área, oportunidades de posicionamento — e traz recomendações de negócio
  fundamentadas.
- **Modelo de decisão do advogado**: o sistema aprende como o Dr. Márcio
  estrutura recursos, negocia, precifica e prioriza — e chega às reuniões
  com "acredito que o senhor escolheria a estratégia B, pelos precedentes
  usados em casos semelhantes". **Prever a decisão para preparar melhor o
  decisor — nunca para decidir por ele.**

**Restrição transversal às ondas 3–5**: tudo que observa o trabalho real
opera sobre o Memory Engine (fora deste repositório Git), sob sigilo
profissional e LGPD. O que é versionado aqui é sempre capacidade e padrão
anonimizado, nunca dado de cliente (`SECURITY.md`).

## 5. Princípios que nunca poderão ser violados

Herdados de `MF-CONSTITUTION.md` e elevados a compromissos de década:

1. **A decisão jurídica é sempre humana.** O sistema informa, prepara,
   antecipa e rascunha — não decide, não assina, não protocola por conta
   própria.
2. **Sigilo profissional acima de qualquer funcionalidade.** Nenhuma
   capacidade justifica expor dado de cliente — nem para treinar modelos,
   nem para "melhorar o produto", nem entre escritórios se houver
   multi-tenant.
3. **O conhecimento do escritório pertence ao escritório.** Exportável,
   legível, versionado — nunca aprisionado.
4. **O sistema nunca finge ser o que ainda não é.** Estado real e visão-alvo
   são sempre distinguíveis (`CURRENT_STATE.md`).
5. **Crescer por necessidade real, nunca por fascínio tecnológico.** Cada
   onda só nasce quando a anterior provou valor em uso.

## 6. Métricas que indicarão que a missão está sendo cumprida

| Dimensão | Métrica | Sinal de sucesso em 2030 |
|---|---|---|
| Tempo | Horas/semana devolvidas ao advogado | O tempo do Dr. Márcio concentra-se em julgamento e relacionamento, não em produção mecânica |
| Risco | Prazos perdidos; conflitos não detectados | Zero, estruturalmente — não por esforço heroico |
| Aprendizado | % de padrões recorrentes promovidos a skill/playbook | Nenhum trabalho relevante é feito "do zero" pela terceira vez |
| Antecipação | % de sugestões proativas aceitas pelo advogado | O sistema erra pouco ao prever o que será útil — e é corrigido quando erra |
| Qualidade | Retrabalho sobre saídas de IA após revisão humana | Tendendo a ajustes finos, não a refação |
| Negócio | ROI mensurado (Cost Intelligence); receita por área | O sistema paga a si mesmo e orienta o crescimento da banca |
| Confiança | O advogado consulta o sistema antes de decidir? | O MF-AOS é a primeira consulta natural — como hoje se consulta a memória |

## 7. Como usar este documento

- **Toda proposta de funcionalidade** (RFC, issue, ideia em conversa) deve
  responder: *a qual onda pertence, e a onda anterior já provou valor?*
- **Toda decisão de arquitetura** (ADR) deve citar este documento quando
  afetar uma capacidade de longo prazo.
- **Revisão anual**: uma vez por ano, o Dr. Márcio e o Meta Orchestrator
  releem este documento inteiro e o atualizam — visão que não é revisitada
  vira dogma, e dogma envelhece mal.
