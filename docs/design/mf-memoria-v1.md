# Plano técnico — `mf-memoria` v1 (Memory Engine, Onda 2)

- **Status**: proposto — aguardando aprovação do Dr. Márcio antes de codar
- **Origem**: RFC-0004 (aceita), ADR-0003, ADR-0004; condicionantes da
  aprovação de 2026-07-03
- **Escopo**: primeira versão do servidor MCP de memória do escritório.
  Nada além do listado aqui entra no v1.

## 1. Stack e justificativa

| Escolha | Justificativa |
|---|---|
| **TypeScript + Node.js (LTS)** | SDK MCP oficial maduro (`@modelcontextprotocol/sdk`), tipos fortes para o modelo de domínio, ecossistema de teste sólido |
| **`better-sqlite3-multiple-ciphers`** | SQLite com cifragem compatível com SQLCipher, API síncrona simples, um único arquivo de banco |
| **`zod`** | Validação de entrada de cada ferramenta MCP na fronteira — nenhum dado entra no domínio sem passar pelo schema |
| **`vitest`** | Testes unitários e de integração, rápido, TS nativo |
| **Transporte stdio** | O runtime já sabe iniciar servidores MCP locais por comando; zero rede exposta |

Sem framework de ORM: o esquema é pequeno, migrations são SQL puro e a
camada de domínio é onde vivem as invariantes — ORM esconderia exatamente o
que queremos explícito.

**Localização do código**: repositório privado novo (ADR-0004), estrutura
`packages/mf-memoria/` preparada para workspace pnpm — TurboRepo e demais
tooling só entram quando houver um segundo pacote (coerente com ADR-0002).

## 2. Layout de dados em disco (fora de qualquer Git)

```
~/.mf-aos/
├── memoria.db          # SQLite cifrado (SQLCipher)
├── chave.key           # chave de cifragem, permissão 0600, criada no init
├── backups/            # cópias cifradas datadas (retenção: 7 diárias + 8 semanais)
└── logs/mf-memoria.log # log rotacionado, sem dado pessoal
```

Camada dupla: cifragem do banco + recomendação obrigatória de cifragem de
disco (BitLocker/FileVault) registrada no playbook de instalação. A chave
nunca aparece em variável de ambiente de sessão, log ou Git; perda da chave
= perda do banco → o playbook de backup inclui cópia da chave em mídia
separada guardada pelo escritório.

## 3. Módulos

```
packages/mf-memoria/
├── src/
│   ├── servidor.ts        # entrypoint MCP (stdio), registro das ferramentas
│   ├── db/
│   │   ├── conexao.ts     # abertura do banco cifrado, PRAGMAs, chave
│   │   └── migrador.ts    # aplica migrations pendentes; backup antes
│   ├── dominio/
│   │   ├── tipos.ts       # entidades e enums (áreas: as 12 aprovadas)
│   │   ├── clientes.ts    # criação/consulta; normalização de nome p/ conflito
│   │   ├── conflitos.ts   # cruzar_conflito + registro do check
│   │   ├── casos.ts       # abrir_caso (GATE: exige conflict_check aprovado),
│   │   │                  #   encerrar_caso (GATE: exige desfecho)
│   │   ├── prazos.ts      # registrar/listar/atualizar; flag calculo_verificado
│   │   ├── documentos.ts  # registrar/marcar revisado/citações verificadas
│   │   ├── desfechos.ts   # desfecho de caso/documento (RFC-0003)
│   │   ├── teses.ts       # teses e associação caso↔tese
│   │   └── retencao.ts    # candidatos a expurgo (política: 5 anos)
│   ├── eventos/log.ts     # append-only; toda mutação de domínio emite evento
│   ├── evolucao/padroes.ts # consultas do Evolution Engine (regra das 3x, skills ociosas)
│   └── seguranca/
│       ├── redacao.ts     # redator de logs: IDs sim, nomes/CPF/CNJ nunca
│       └── minimo.ts      # formatadores de resposta (veredito/agregado, não dump)
├── migrations/0001_inicial.sql
├── test/                  # espelha src/ + integracao/
└── package.json
```

## 4. Ferramentas MCP (17 comandos do v1)

Toda ferramenta valida entrada com zod, roda em transação, emite evento e
responde o **mínimo necessário**. Nenhuma executa ato jurídico externo —
princípio constitucional nº 11 embutido na superfície da API.

**Clientes e conflito**
| Ferramenta | Entrada → Saída |
|---|---|
| `criar_cliente` | dados do cliente → id (status inicial: `prospecto`) |
| `buscar_cliente` | nome parcial ou doc fiscal → ficha resumida |
| `cruzar_conflito` | nome + doc fiscal (opcional) das partes → veredito (`liberado`/`colisão`) + colisões resumidas — **nunca a carteira** |
| `registrar_conflict_check` | resultado + `aprovado_por` (humano) → id |

**Casos e partes**
| `abrir_caso` | cliente, área (enum das 12), tipo, nº CNJ opcional → id. **Rejeita com erro se não houver conflict_check aprovado** |
| `registrar_parte` | caso + nome/doc/papel → id (alimenta conflitos futuros) |
| `encerrar_caso` | caso + desfecho (resultado, fundamentos, lições) → ok. **Rejeita sem desfecho** |
| `consultar_caso` | id ou filtros → resumo do caso com prazos abertos |
| `casos_semelhantes` | área + tipo + tese opcional → até 5 casos com desfecho (recuperação estruturada, não estatística) |

**Prazos e documentos**
| `registrar_prazo` | caso, tipo, termo inicial, data limite, fonte → id (`calculo_verificado=false` até conferência) |
| `confirmar_prazo` | prazo + quem conferiu → `calculo_verificado=true` |
| `listar_prazos` | janela em dias / status → lista ordenada por urgência |
| `registrar_documento` | caso, tipo, título, caminho, skill de origem → id |
| `marcar_documento` | flags `revisado_por_humano` / `citacoes_verificadas` + desfecho opcional → ok |

**Evolução e operação**
| `registrar_demanda` | tipo de demanda + skill usada + duração → ok (substitui o registro manual suspenso) |
| `relatorio_evolucao` | — → padrões ≥3x sem skill, skills ociosas, agregados por área (células com N≥5) |
| `estado_memoria` | — → versão do schema, contagens, data do último backup (sem dado pessoal) |

Fora do v1 (explícito): exportação completa (`exportar_dados` — v1.1, logo
após, para cumprir portabilidade), embeddings/busca semântica, multi-usuário,
sincronização, expurgo automático (v1 apenas **lista** candidatos; expurgar é
decisão humana).

## 5. Migrations

- `migrations/0001_inicial.sql`: todas as tabelas da RFC-0004 §1–3 (com o
  vocabulário de 12 áreas), índices de conflito (nome normalizado, doc
  fiscal) e a tabela `schema_migrations`.
- Regras do migrador: arquivos imutáveis e numerados; aplica pendentes em
  transação; **backup automático antes de qualquer migration**; recusa
  banco com versão à frente do código.

## 6. Testes (escritos junto com cada módulo, não depois)

| Camada | O que cobre |
|---|---|
| Unidade (domínio) | **As invariantes como testes nomeados**: `abrir_caso` sem conflict check → erro; `encerrar_caso` sem desfecho → erro; `cruzar_conflito` casa por doc fiscal e por nome normalizado (acentos/caixa); prazo não confirmado nunca aparece como verificado |
| Migrations | Banco novo → 0001 aplica limpa; reexecução é no-op; migration falha → rollback e banco intacto |
| Segurança | Abrir o arquivo do banco **sem chave falha**; log gerado durante suite completa não contém nome/CPF/CNJ (varredura regex sobre o log); resposta de `cruzar_conflito` não contém clientes não colididos |
| Integração MCP | Sobe o servidor por stdio, executa o fluxo completo: criar cliente → cruzar conflito → registrar check → abrir caso → prazo → documento → desfecho → relatório |

CI do repositório privado: suite completa + varredura CNJ/CPF/CNPJ herdada
+ ShellCheck + gitleaks (mesma fundação deste repositório).

## 7. Critérios de aceite (mapeados 1:1 às condições da aprovação)

| Condição do Dr. Márcio | Critério verificável |
|---|---|
| Nenhum dado real no Git | Dados em `~/.mf-aos/` (fora do repo); `.gitignore` bloqueia `*.db`/`*.key`; CI com varredura CNJ/CPF/CNPJ; **teste de fumaça**: rodar a suite não cria nenhum arquivo dentro do repo |
| Não expor dado sensível no runtime | Testes de mínimo necessário (§6, Segurança) passam; toda resposta passa por `seguranca/minimo.ts` |
| Testes desde o início | Nenhum módulo entra sem teste correspondente; invariantes têm teste nomeado; integração ponta a ponta verde |
| Migrations | Critérios do §5 cobertos por teste |
| Cifragem | Teste "abrir sem chave falha"; chave 0600; playbook de backup da chave escrito |
| Logs mínimos e seguros | Teste de varredura do log; log só carrega IDs, operação e duração |
| Conflict-check obrigatório | `abrir_caso` rejeita sem check aprovado — teste de invariante + impossível contornar pela API (não existe ferramenta de escrita direta em `caso`) |
| Preparar o decisor, nunca decidir | Nenhuma ferramenta dispara ato externo; campos de aprovação (`aprovado_por`, `confirmar_prazo`) exigem humano nomeado; `relatorio_evolucao` **propõe**, quem abre proposta é o fluxo humano |

## 8. Fases de implementação

| Fase | Entrega | Pronto quando |
|---|---|---|
| **F0 — Separação** | Repositório privado criado (ato do Dr. Márcio), fundação de CI migrada, plano de migração dos documentos privados (ADR-0004) executado | CI verde no repo privado; este repo público sem `MF-PRODUCT`/`MF-VISION`/`memory/` |
| **F1 — Núcleo** | conexão cifrada, migrador, `0001_inicial.sql`, log seguro, `estado_memoria` | testes de migrations + cifragem verdes |
| **F2 — Conflito e casos** | clientes, `cruzar_conflito`, `registrar_conflict_check`, `abrir_caso` (gate), partes | invariante do gate testada; skill `conflict-check` atualizada para consultar o servidor |
| **F3 — Operação** | prazos, documentos, desfechos, `encerrar_caso` (gate), teses | fluxo de integração ponta a ponta verde |
| **F4 — Evolução** | eventos completos, `registrar_demanda`, `relatorio_evolucao`, retenção (lista de expurgo), playbooks de instalação/backup/restauração | critérios de aceite do §7 todos verificados; `CURRENT_STATE` do repo privado atualizado |

Cada fase termina com o loop pós-tarefa do `CLAUDE.md` (validação, Audit
Engine, documentação). F0 é bloqueante: **nenhum código do `mf-memoria`
nasce neste repositório público.**

## 9. Riscos do plano

| Risco | Mitigação |
|---|---|
| Perda da chave de cifragem | Playbook de backup da chave em mídia separada (F4); verificação no `estado_memoria` |
| Disciplina de desfecho decair | Gate no `encerrar_caso` torna o desfecho inevitável, não opcional |
| Escopo crescer durante a implementação | A lista do §4 é fechada; ideia nova → issue, não código |
| Dependência nativa (`better-sqlite3`) quebrar em atualização de Node | Versão de Node fixada (`.nvmrc`) e CI testando a instalação limpa |
