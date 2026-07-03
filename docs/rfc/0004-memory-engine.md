# RFC-0004: Memory Engine — desenho do esquema de dados (Onda 2)

- **Status**: em discussão — **aguardando revisão do Dr. Márcio antes de
  qualquer implementação**
- **Data**: 2026-07-03
- **Autor**: Claude Code
- **Origem**: pedido direto do Dr. Márcio; achado B5 do red team (Memory
  Engine sem uma única decisão de design) e Future Review §1 da revisão
  constitucional

## Problema

Todas as ondas 2–5 da visão dependem de memória persistente, e até esta RFC
não existia nenhuma decisão sobre entidades, storage, sigilo ou interface de
consulta. Este documento fecha essa lacuna **em desenho** — nada aqui está
implementado.

## Decisão de arquitetura proposta (resumo executivo)

**Local-first, cifrado, consultável por MCP.** Um banco SQLite cifrado
(SQLCipher ou equivalente), vivendo na máquina do escritório em diretório
**fora de qualquer repositório Git**, acessado pelas skills através de um
servidor MCP próprio (`mf-memoria`) que expõe operações nomeadas (consultar
cliente, registrar prazo, cruzar conflito). Por quê:

- **Sigilo**: o dado nunca sai da máquina do escritório por padrão; backup é
  cópia cifrada para mídia/nuvem controlada pelo escritório. Responde ao
  achado B2 (canal do runtime): a skill consulta o mínimo necessário e só o
  resultado da consulta entra na sessão.
- **Executabilidade**: resolve a objeção central do red team ("skills em
  Markdown não têm mecanismo nativo de consulta") — MCP é o mecanismo nativo
  que o runtime já suporta.
- **Simplicidade**: SQLite é um arquivo; sem servidor, sem custo recorrente,
  sem dependência de rede. Escala além do horizonte de um escritório.
- **Portabilidade** (achado B13): SQL padrão + export para JSON/CSV a
  qualquer momento; o acervo não fica refém de runtime nem de fornecedor.

## 1–3. Entidades, campos e relacionamentos

```
cliente 1───N caso 1───N prazo
   │            │ 1───N documento 1───1 desfecho_documento (opcional)
   │            │ 1───N caso_tese N───1 tese
   │            │ 1───1 conflict_check (obrigatória na abertura)
   │            │ 1───N parte_relacionada
   │            └ 1───1 desfecho_caso (opcional, ao encerrar)
   └ (qualquer mutação) ──► evento  (log append-only, alimenta os engines)
```

### `cliente`
| Campo | Tipo | Notas |
|---|---|---|
| id | uuid pk | |
| tipo | enum(PF, PJ) | |
| nome_razao | texto | dado pessoal — cifrado em repouso |
| documento_fiscal | texto | CPF/CNPJ — cifrado; usado no conflict check |
| contatos | json | e-mail, telefone; cifrado |
| data_onboarding | date | |
| status | enum(prospecto, ativo, encerrado) | prospecto: existe antes do conflict check aprovar |
| sinal_satisfacao | int nulo | RFC-0003; captura leve (ex.: NPS anual) |
| criado_em / atualizado_em | timestamp | trilha de auditoria |

### `caso`
| Campo | Tipo | Notas |
|---|---|---|
| id | uuid pk | |
| cliente_id | fk cliente | |
| area | enum(trabalhista, previdenciário, família, consumidor, empresarial, bancário, tributário, outra) | vocabulário controlado — é o eixo do Business Brain |
| tipo_acao | texto | vocabulário livre no v1; promover a enum quando estabilizar |
| numero_cnj | texto nulo | cifrado; existe só aqui, nunca em Git |
| status | enum(pré-judicial, ativo, suspenso, encerrado) | |
| estrategia_resumo | texto | rascunho da estratégia inicial (Legal Engine) |
| aberto_em / encerrado_em | date | duração por fase alimenta Cost Intelligence |

### `parte_relacionada` — a entidade que torna o conflict check executável (B1)
| Campo | Tipo | Notas |
|---|---|---|
| id | uuid pk | |
| caso_id | fk caso | |
| nome | texto | cifrado |
| documento_fiscal | texto nulo | cifrado; chave primária de cruzamento |
| papel | enum(adverso, corréu, testemunha, terceiro_interessado, grupo_econômico) | |

O conflict check deixa de pedir que o advogado "cole a carteira": a skill
`conflict-check` consulta `mf-memoria.cruzar_conflito(nome, doc_fiscal)`, que
varre clientes ativos/últimos 5 anos **e** partes relacionadas, devolvendo
só o veredito e as colisões — não a carteira.

### `conflict_check`
| Campo | Tipo | Notas |
|---|---|---|
| id | uuid pk; caso_id fk | 1:1 com caso — **a abertura de caso sem esta linha é rejeitada pelo engine** (mecanismo, não prosa) |
| resultado | enum(liberado, conflito, liberado_com_ressalva) | |
| colisoes | json | ids das colisões encontradas |
| aprovado_por | texto | sempre um humano |
| verificado_em | timestamp | |

### `prazo`
| Campo | Tipo | Notas |
|---|---|---|
| id | uuid pk; caso_id fk | |
| tipo | texto (contestação, recurso, embargos, manifestação, …) | |
| termo_inicial / data_limite | date | no v1, calculado com conferência humana; o motor determinístico (backlog B9) passa a preencher `calculo_verificado=true` |
| fonte | enum(intimação, publicação, acordo, lei) | |
| status | enum(aberto, cumprido, perdido, prejudicado) | `perdido` existe no esquema porque fingir que não acontece impede o sistema de aprender (RFC-0003) |
| calculo_verificado | bool | true só quando conferido por humano ou motor determinístico |

### `documento`
| Campo | Tipo | Notas |
|---|---|---|
| id | uuid pk; caso_id fk | |
| tipo | enum(petição_inicial, contestação, recurso, minuta_contrato, notificação, comunicado, parecer, outro) | |
| titulo | texto | |
| caminho_arquivo | texto | referência ao arquivo no storage do escritório (Drive/disco); o conteúdo da peça NÃO vive no banco |
| skill_origem | texto nulo | qual skill gerou o rascunho — liga produção ao aprendizado |
| revisado_por_humano | bool | invariante do produto; `false` bloqueia marcação de "entregue" |
| citacoes_verificadas | bool | invariante "nenhuma citação sem fonte" (B19) |
| versao | int | |

### `desfecho_caso` / `desfecho_documento` (RFC-0003 — capturados desde o v1)
| Campo | Tipo | Notas |
|---|---|---|
| caso_id / documento_id | fk | |
| resultado | enum(êxito_total, êxito_parcial, improcedente, acordo, desistência) / enum(acolhido, parcial, rejeitado, não_apreciado) | |
| fundamentos_centrais | json | teses/argumentos que o juízo enfrentou |
| duracao_dias | int | |
| licoes | texto | campo livre, curado pelo advogado |

### `tese` e `caso_tese`
| Campo | Tipo | Notas |
|---|---|---|
| tese.id, nome, area, descricao | | vocabulário curado — nasce pequeno |
| tese.precedentes_chave | json | referências públicas (súmula, tema, REsp) — isto não é dado sigiloso |
| caso_tese: caso_id, tese_id, papel(principal, subsidiária), funcionou(bool nulo) | | preenchido pelo desfecho — é a aresta central do futuro Knowledge Graph |

### `evento` (log append-only)
| Campo | Tipo | Notas |
|---|---|---|
| id, ocorrido_em | | |
| tipo | ver §8 | |
| entidade, entidade_id | | |
| skill_ou_engine | texto | quem causou |
| payload | json | detalhes mínimos |

### `registro_de_trabalho` (migra do Git para cá — B10)
O registro suspenso em `memory/registro-de-trabalho.md` renasce aqui como
tabela privada (`ocorrido_em`, `tipo_demanda`, `skill_usada`, `duracao_min`),
alimentada por evento — sem risco de inferência adversarial, porque nunca
sai da máquina.

## 4. O que PODE viver no Git (capacidade, nunca instância)

- O **esquema**: DDL/migrations numeradas, este RFC, o código do servidor
  `mf-memoria` quando existir.
- Vocabulários neutros: lista de áreas, tipos de ação, enums.
- `memory/dna.md` (RFC-0001): princípios decisórios, com exemplos
  anonimizados e aprovados um a um pelo Dr. Márcio.
- Padrões agregados **promovidos manualmente**: "demandas de revisão
  contratual se repetem → proposta de skill" — a conclusão, nunca a série
  temporal que a gerou.

## 5. O que NUNCA vive no Git

Qualquer linha das tabelas acima: nomes, CPF/CNPJ, números CNJ, contatos,
estratégias de caso, prazos, desfechos, colisões de conflito, registro de
trabalho com timestamps. Também os backups (cifrados, fora de repositório) e
os dumps de desenvolvimento. O CI já quebra em padrões CNJ/CPF/CNPJ como
segunda linha de defesa.

## 6. Estratégia de anonimização (para qualquer dado que suba de camada)

Regra geral aprendida no achado A5/B10: **anonimizar é impedir correlação,
não só remover nomes.**

1. Só agregados saem do banco para documentos versionados (contagens por
   área/trimestre), nunca eventos individuais.
2. Granularidade temporal mínima de trimestre em qualquer material
   versionado ou compartilhado.
3. N mínimo: nenhum agregado com menos de 5 casos na célula.
4. Promoção manual: um humano aprova todo texto que atravessa a fronteira
   privado → versionado.
5. Consultas do runtime (sessões LLM) recebem o mínimo necessário: o
   servidor MCP responde perguntas, não despeja tabelas.

## 7. Estratégia de versionamento

- **Esquema**: migrations SQL numeradas e imutáveis (`0001_inicial.sql`, …)
  versionadas em Git; o banco guarda a versão aplicada; upgrade = aplicar
  pendentes, sempre com backup automático antes.
- **Dados**: sem histórico completo no v1 (custo > benefício); trilha mínima
  `criado_em`/`atualizado_em` + log de `evento` para reconstruir a linha do
  tempo. Exclusão é soft-delete (`excluido_em`), com expurgo definitivo
  agendado (LGPD — direito de eliminação e fim de retenção).
- **Backup**: cópia cifrada diária local + semanal externa; restauração
  testada trimestralmente (playbook a criar na implementação).

## 8. Eventos gerados

Formaliza e estende `MF-ARCHITECTURE.md` §10:

`ClienteOnboardado`, `ConflitoVerificado`, `CasoAberto`, `PrazoCalculado`,
`PrazoVerificado`, `PrazoProximoDoVencimento`, `PrazoCumprido`,
`PrazoPerdido`, `DocumentoGerado`, `DocumentoRevisadoPorHumano`,
`CitacoesVerificadas`, `DesfechoRegistrado`, `TeseAssociada`,
`CasoEncerrado`, `DemandaRoteada` (do orquestrador — substitui o registro
manual de trabalho), `AuditoriaConcluida`.

Cada evento é uma linha em `evento` e, futuramente, um gatilho de automação
(ex.: `PrazoProximoDoVencimento` → alerta no Calendar).

## 9. Como alimenta o Evolution Engine

O loop manual de `MF-OPERATIONS.md` §9 vira consulta:

- `DemandaRoteada` alimenta `registro_de_trabalho` automaticamente — o
  advogado não anota nada.
- A regra das 3 repetições vira query periódica: tipos de demanda com ≥3
  ocorrências e `skill_usada = nenhuma` → o Meta Orchestrator abre a
  proposta de skill com os dados agregados.
- Skills nunca usadas em N meses (evento ausente) → candidatas a revisão ou
  aposentadoria — o outro lado do aprendizado, que o registro manual nunca
  capturaria.

## 10. Como serve de base para os engines das Ondas 3–5

| Engine | O que consome deste esquema | Observação honesta |
|---|---|---|
| **Intelligence Engine** (onda 3) | `evento` + `registro_de_trabalho`: frequência, duração, skills ociosas, gargalos | é relatório sobre o log — nenhuma tabela nova |
| **Cost Intelligence** (onda 3) | `duracao_min` por demanda × horas economizadas; casos por área | exige apenas disciplina de desfecho |
| **Knowledge Graph** (onda 4) | os relacionamentos já normalizados: cliente↔caso↔tese↔precedente↔documento↔skill_origem | o grafo **emerge** do relacional — não é um banco novo, é uma vista |
| **Prediction Engine** (onda 4) | `caso` + `caso_tese` + `desfecho_*`: "casos semelhantes e o que funcionou" | com n pequeno (B17), isso é **recuperação de casos semelhantes**, não inferência estatística — e é exatamente o que a visão promete ("apresenta os casos internos semelhantes") |
| **AI Quality Engine** (onda 4) | `revisado_por_humano`, `citacoes_verificadas`, retrabalho por documento | as invariantes viram métricas |
| **Business Brain** (onda 5) | agregados por `area`, ticket, duração, desfecho | "12 bancários, 1 previdenciário, 0 tributário" é um `GROUP BY area` |

## Questões abertas para a revisão do Dr. Márcio

1. **Storage**: SQLite cifrado local atende, ou o escritório prefere algo
   consultável de mais de uma máquina desde o início (implica servidor ou
   sincronização — mais custo e superfície)?
2. **Vocabulário de áreas**: a lista de `area` proposta cobre a atuação real
   do escritório?
3. **Captura de desfecho**: o senhor valida o custo de preencher desfecho ao
   encerrar caso/peça (2–3 campos)? Sem isso, as ondas 3–5 ficam sem
   matéria-prima.
4. **Retenção**: quantos anos de dados de caso encerrado manter antes do
   expurgo (obrigações legais de guarda × minimização LGPD)?
5. **Gate de implementação**: aprovada esta RFC, a implementação começa pelo
   servidor `mf-memoria` + migrations + skill `conflict-check` consultando o
   banco — o primeiro código de aplicação do MF-AOS, que arrasta o tooling
   do ADR-0002.

## Teste da estrela-guia

Onda 2 ("Lembrar"), com a Onda 1 comprovada em uso. É o pré-requisito
declarado de tudo que vem depois — e a resposta estrutural aos achados
CRÍTICOS B1 (conflict check executável), B5 (design inexistente) e B10
(registro privado).
