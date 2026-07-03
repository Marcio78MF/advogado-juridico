# MF-ARCHITECTURE — Arquitetura Técnica

> Regido por `MF-CONSTITUTION.md`. O quê e quando construir está em
> `MF-PRODUCT.md`. Quem executa cada parte está em `MF-AGENTS.md`.
>
> Convenção deste documento: cada seção distingue **Estado Atual** (o que
> realmente existe no repositório) de **Visão-Alvo** (para onde a arquitetura
> caminha). Nunca descrever a Visão-Alvo como se já estivesse implementada.

## 1. Arquitetura geral

**Estado Atual**: plugin Claude Code single-tenant, rodando localmente no
ambiente do advogado. Composto por:

```
advogado-juridico/
├── .claude-plugin/plugin.json   # manifesto do plugin
├── hooks/detectar-demanda-juridica.sh   # hook UserPromptSubmit
└── skills/
    ├── orquestrador-juridico/   # detecta demanda e roteia
    └── <17 skills especializadas>/
```

O hook `UserPromptSubmit` analisa a mensagem do advogado e injeta contexto
antes do processamento; a skill `orquestrador-juridico` decide qual skill
especializada assumir, faz intake estruturado (uma pergunta por vez) e só
então invoca a skill final.

**Visão-Alvo**: as mesmas capacidades, organizadas em camadas explícitas para
suportar memória persistente, auditoria e, eventualmente, múltiplos usuários:

```
┌─────────────────────────────────────────────┐
│ Command Center (painel / interface)          │
├─────────────────────────────────────────────┤
│ Agent Orchestrator + Meta Orchestrator       │  (MF-AGENTS.md)
├─────────────────────────────────────────────┤
│ Engines: Legal | Petition | Business |       │  (MF-OPERATIONS.md)
│ Memory | Audit | Self-Evolution              │
├─────────────────────────────────────────────┤
│ Skills (18 hoje, extensíveis)                │  skills/
├─────────────────────────────────────────────┤
│ Dados: clientes, casos, prazos, documentos   │  (Modelo de Dados, §8)
├─────────────────────────────────────────────┤
│ Integrações: Google Workspace, WhatsApp, ... │  (§9)
└─────────────────────────────────────────────┘
```

Cada camada nova só é construída quando um item do roadmap (`MF-PRODUCT.md`)
a exigir — não antecipadamente.

## 2. Arquitetura de IA

**Estado Atual**: o Claude Code, operando como agente único por sessão, com
roteamento por skill via o orquestrador. Não há memória entre sessões além do
que está versionado no repositório.

**Visão-Alvo**: múltiplos agentes especializados (`MF-AGENTS.md`) que
compartilham:
- uma base de conhecimento comum (Memory Engine, `MF-OPERATIONS.md`),
- um conjunto de skills reutilizáveis (as 18 atuais + novas),
- um processo de auditoria comum antes de qualquer entrega ser considerada
  concluída (Audit Engine).

RAG (busca em jurisprudência, base de conhecimento do escritório) entra como
capacidade quando o volume de conteúdo próprio do escritório justificar —
hoje, pesquisa de jurisprudência é coberta pela skill `pesquisa-jurisprudencia`
e pelo conector JUS_RATIO disponível na sessão.

## 3. Arquitetura jurídica

Modelo conceitual do domínio jurídico que toda skill deve respeitar:

- **Cliente** → pode ter um ou mais **Casos/Processos**.
- Todo **Caso** novo passa obrigatoriamente por **Conflict Check** antes de
  qualquer outra ação (skill `conflict-check`).
- Todo **Caso** tem uma linha do tempo (**Cronologia**), documentos associados
  e prazos (**Prazos Processuais**, skill `gestao-prazos`).
- Toda peça ou minuta gerada (skills `gerador-minutas`, `resumo-pecas`,
  `notificacao-extrajudicial`) é um **rascunho para revisão humana**, nunca um
  produto final — isso é uma invariante de arquitetura, não apenas uma
  política.
- Compliance transversal: LGPD (`lgpd-escritorio`) e ética profissional
  (`conteudo-autoridade` já embute regras da OAB) se aplicam a qualquer skill
  que produza conteúdo externo.

## 4. Arquitetura de dados

**Estado Atual**: sem persistência própria; o estado vive na sessão do Claude
Code e nos arquivos que o advogado mantém fora do plugin (Drive, planilhas,
etc.).

**Visão-Alvo — Modelo de dados mínimo (Memory Engine v1)**:

| Entidade | Campos-chave | Observações |
|---|---|---|
| Cliente | id, nome/razão social, contato, data de onboarding | Origem: skill `onboarding-cliente` |
| Caso | id, cliente_id, área do direito, status, resultado do conflict check | Origem: `conflict-check` + `onboarding-cliente` |
| Prazo | id, caso_id, tipo, data limite, status | Origem: `gestao-prazos` |
| Documento | id, caso_id, tipo (minuta/petição/notificação), versão, revisado_por_humano (bool) | Cobre auditoria de revisão |
| Decisão/Sentença | id, caso_id, resumo, estratégia recursal | Origem: `analise-sentenca` |

Este modelo é deliberadamente mínimo: cresce apenas quando uma automação real
(Legal Engine, Petition Engine, Business Engine) precisar de um campo que não
existe. Dado real de cliente **nunca** é versionado neste repositório Git —
apenas o esquema/modelo, nunca instâncias reais.

## 5. Arquitetura de segurança

- Sigilo profissional advocatício é a restrição de mais alta prioridade do
  sistema — acima de conveniência ou velocidade.
- LGPD: minimização de dados, finalidade explícita, e skill `lgpd-escritorio`
  como referência de compliance para qualquer novo fluxo que toque dado
  pessoal.
- Nenhuma credencial, dado de cliente real, ou conteúdo de processo sigiloso
  é commitado neste repositório. O repositório versiona **capacidade**
  (skills, arquitetura, playbooks), não **dado**.
- Toda integração externa futura (Google Workspace, WhatsApp) usa
  autenticação por conta própria do escritório, nunca credenciais
  compartilhadas ou hardcoded.

## 6. Arquitetura de deploy

**Estado Atual**: instalação local do plugin via `claude plugin install` ou
clone manual (ver `README.md`). Não há serviço hospedado.

**Visão-Alvo**: enquanto o produto atender um único escritório, deploy
local/plugin continua sendo suficiente e preferível (menor custo, menor
superfície de risco). Uma migração para serviço hospedado multi-tenant só é
justificada pela decisão de negócio de atender outros escritórios (T7 do
roadmap) — e é, por definição, uma decisão que interrompe o trabalho
autônomo para confirmação do Dr. Márcio (`MF-CONSTITUTION.md` §4).

## 7. Arquitetura de observabilidade

**Visão-Alvo mínima**: todo Engine (`MF-OPERATIONS.md`) que produz uma ação
relevante (petição gerada, prazo calculado, cliente onboardado) registra um
evento com: o quê, quando, qual skill/agente, e se passou pela revisão
humana. Isso alimenta tanto o Audit Engine quanto o Command Center, sem exigir
infraestrutura de monitoramento externa enquanto o volume for baixo.

## 8. Arquitetura de integrações

| Integração | Uso pretendido | Skill/Engine relacionado |
|---|---|---|
| Google Calendar | Prazos processuais e audiências | `gestao-prazos`, `preparacao-audiencias` |
| Google Drive | Pasta estruturada por cliente/caso | `onboarding-cliente`, Legal Engine |
| Gmail | Comunicados e notificações | `comunicados-clientes`, `notificacao-extrajudicial` |
| WhatsApp | Comunicação com cliente (futuro) | Business Engine |
| JUS_RATIO (já disponível na sessão) | Pesquisa de jurisprudência | `pesquisa-jurisprudencia` |
| GitHub | Versionamento do próprio sistema (skills, docs, automações) | Self Evolution Engine |

Nenhuma integração é adotada "porque existe" — cada uma entra no roadmap
apenas quando resolve um item da matriz de prioridades (`MF-PRODUCT.md`).

## 9. Modelo de domínio (DDD) e Bounded Contexts

| Bounded Context | Responsabilidade | Skills hoje |
|---|---|---|
| **Intake & Compliance** | Admissão de cliente, conflito, LGPD | `onboarding-cliente`, `conflict-check`, `lgpd-escritorio` |
| **Produção Documental** | Minutas, petições, notificações, comunicados | `gerador-minutas`, `resumo-pecas`, `notificacao-extrajudicial`, `comunicados-clientes`, `edicao-cirurgica` |
| **Inteligência Jurídica** | Pesquisa, análise de risco, análise de sentença, legislação | `pesquisa-jurisprudencia`, `analise-risco-processual`, `analise-sentenca`, `analise-legislacao` |
| **Operação Processual** | Prazos, audiências | `gestao-prazos`, `preparacao-audiencias` |
| **Comercial** | Precificação, honorários, conteúdo de autoridade | `precificacao-honorarios`, `conteudo-autoridade` |
| **Contratos** | Revisão contratual | `revisao-contratos` |
| **Orquestração** | Roteamento de demanda | `orquestrador-juridico` |

Esses contextos são a base para a futura divisão entre agentes especializados
em `MF-AGENTS.md` — cada agente de domínio jurídico corresponde a um bounded
context, não a uma skill isolada.

## 10. Eventos do sistema (visão-alvo)

`ClienteOnboardado`, `ConflitoVerificado`, `CasoAberto`, `PrazoCalculado`,
`PrazoProximoDoVencimento`, `DocumentoGerado`, `DocumentoRevisadoPorHumano`,
`AuditoriaConcluida`. Cada evento é o gatilho natural para automações futuras
(ex.: `PrazoProximoDoVencimento` → notificação automática).

## 11. Estratégia de escalabilidade

Escalar primeiro em **abrangência de skills** (mais demandas jurídicas
cobertas) antes de escalar em **infraestrutura** (mais usuários/tenants). A
arquitetura de dados (§4) e o modelo de domínio (§9) já são desenhados para
suportar múltiplos casos e clientes por escritório; suportar múltiplos
escritórios é uma extensão (namespace por tenant), não uma reescrita — mas só
é construída quando decidida (ver §6).

## 12. Estratégia de testes

- Cada skill nova ou alterada é validada com pelo menos um cenário real de
  intake ponta a ponta antes de ser considerada pronta.
- Mudança no hook de detecção (`detectar-demanda-juridica.sh`) é testada
  contra frases de exemplo das 18 demandas existentes, para garantir que o
  roteamento não regride.
- Novas automações (Engines) são testadas com dado fictício, nunca dado real
  de cliente.

## 13. Estratégia de versionamento e releases

- SemVer no `plugin.json` (`MAJOR.MINOR.PATCH`): `MAJOR` para mudança de
  comportamento do orquestrador ou remoção de skill; `MINOR` para skill nova;
  `PATCH` para ajuste de conteúdo/correção dentro de uma skill existente.
- Todo release relevante é registrado no histórico de commits com mensagem
  descritiva; um `CHANGELOG.md` formal só é introduzido quando o número de
  releases justificar (evitar processo antes de haver necessidade real).
