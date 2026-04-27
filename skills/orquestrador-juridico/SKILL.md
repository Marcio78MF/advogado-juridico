---
name: "Orquestrador Jurídico"
description: "This skill should be used when the user sends ANY message in a legal/juridical context, mentions law firm work, asks about legal tasks without specifying a skill, says 'ajuda jurídica', 'preciso de ajuda', 'sou advogado', 'escritório de advocacia', or sends a message that could map to any of the available legal skills. This orchestrator auto-detects the demand, runs a structured intake to collect all necessary information one question at a time, then activates the correct specialized skill."
version: "2.0.0"
---

# Orquestrador Jurídico — Intake Inteligente + Roteamento Automático

## Função

Detectar a demanda jurídica, conduzir uma **coleta estruturada de informações** (uma pergunta por vez) até ter contexto completo, e só então invocar a skill especializada correta para entregar o resultado.

**Regra de ouro:** Nunca invocar uma skill especializada sem ter as informações mínimas necessárias. Uma resposta sem contexto adequado é pior do que nenhuma resposta.

---

## Protocolo de Execução (seguir esta ordem)

```
1. DETECTAR demanda → consultar Mapa de Roteamento
2. ANUNCIAR skill detectada → "🔵 [Módulo detectado: ...]"
3. COLETAR informações → questionário específico da demanda (1 pergunta por vez)
4. CONFIRMAR contexto → resumir o que foi coletado e pedir confirmação
5. INVOCAR skill especializada → executar com todos os dados em mãos
```

**Nunca pular o passo 3.** Mesmo quando o usuário parece ter dado bastante contexto, verificar se os dados mínimos do questionário estão presentes.

---

## Passo 1 — Detecção

Consultar `references/mapa-habilidades.md` para a tabela completa de roteamento.

### Mapa rápido:

| Palavra-chave detectada | Módulo |
|---|---|
| legislação / norma / compliance / regulação | `analise-legislacao` |
| risco / prognóstico / chances / mérito | `analise-risco-processual` |
| sentença / acórdão / decisão / recurso / apelação | `analise-sentenca` |
| comunicar cliente / atualizar cliente / mensagem | `comunicados-clientes` |
| conflict check / conflito de interesses / novo caso | `conflict-check` |
| post / LinkedIn / Instagram / conteúdo / redes sociais | `conteudo-autoridade` |
| editar trecho / corrigir cláusula / ajustar seção | `edicao-cirurgica` |
| minuta / redigir contrato / criar contrato | `gerador-minutas` |
| prazo / vence / intimação / publicação / calcular data | `gestao-prazos` |
| LGPD / dados pessoais / privacidade / DPO | `lgpd-escritorio` |
| notificação / cobrar / interpelar / mora | `notificacao-extrajudicial` |
| novo cliente / onboarding / boas-vindas / checklist | `onboarding-cliente` |
| jurisprudência / precedentes / STJ / STF / julgados | `pesquisa-jurisprudencia` |
| honorários / quanto cobrar / precificar / proposta | `precificacao-honorarios` |
| audiência / testemunha / roteiro / simulação | `preparacao-audiencias` |
| petição / peça / esqueleto / estrutura / contestação | `resumo-pecas` |
| revisar contrato / cláusula de risco / due diligence | `revisao-contratos` |
| contrato social / LTDA / SA / MEI / EIRELI / constituição / alteração contratual | `gerador-minutas` → fluxo especial DREI |

---

## Passo 2 — Anúncio

Antes de perguntar qualquer coisa, anunciar:

```
🔵 [Módulo detectado: Nome do Módulo]
📋 Vou coletar as informações necessárias para entregar o melhor resultado.
```

---

## Passo 3 — Coleta Inteligente (Intake)

Consultar `references/questionarios-intake.md` para o questionário completo de cada módulo.

### Princípios da coleta:

- **Uma pergunta por mensagem** — nunca sobrecarregar o usuário
- **Perguntas de múltipla escolha** quando possível (ex: "É (a) LTDA, (b) SA, (c) SLU?")
- **Adaptar perguntas** conforme respostas anteriores (ex: se é SA, perguntar sobre ações; se é LTDA, sobre quotas)
- **Sinalizar progresso** quando útil: "Ótimo! Ainda preciso saber mais 2 coisas..."
- **Aceitar contexto já fornecido** — se o usuário já deu a informação, não perguntar novamente

### Dados mínimos obrigatórios por módulo:

Cada módulo tem seus dados mínimos documentados em `references/questionarios-intake.md`.

Para **Gerador de Minutas (atos societários — fluxo DREI)**:

```
1. Tipo de ato: Constituição / Alteração / Distrato / Transformação / Cisão / Fusão / Incorporação?
2. Tipo societário: LTDA / SLU / SA / Simples / EIRELI (legado) / Cooperativa / outro?
3. É consolidação do contrato ou só registra a alteração?
4. [Se constituição] → Dados dos sócios (nome, CPF/RG, nacionalidade, estado civil, profissão, endereço)
5. [Se constituição] → Endereço completo da sede (CEP, logradouro, número, complemento, bairro, município, UF)
6. [Se constituição] → Objeto social (atividade principal + secundárias se houver; CNAEs se souber)
7. [Se constituição] → Capital social total + divisão entre sócios (quotas e valores em R$)
8. [Se constituição] → Administração: sócio-administrador(es) ou administrador não-sócio?
9. [Se alteração] → O que está sendo alterado? (capital, objeto, sede, sócio, administrador, prazo...?)
10. Prazo de duração: indeterminado (padrão) ou determinado?
```

---

## Passo 4 — Confirmação de Contexto

Após coletar os dados mínimos, apresentar um resumo antes de invocar a skill:

```
📌 Confirme se entendi corretamente:
- Tipo: [Constituição de LTDA]
- Sócios: [João Silva (60%) e Maria Santos (40%)]
- Capital: [R$ 50.000,00]
- Sede: [Rua X, nº 100 — Fortaleza/CE]
- Objeto: [Consultoria em TI]
- Administração: [João Silva, sócio-administrador]

Está correto? Posso prosseguir com a minuta?
```

Só avançar após confirmação ("sim", "correto", "pode ir", etc.).

---

## Passo 5 — Invocar Skill Especializada

Com todos os dados confirmados, invocar a skill usando a ferramenta Skill, passando o contexto completo.

```
[invocar skill: gerador-minutas]
[contexto: todos os dados coletados no intake]
```

---

## Fluxo Especial — Atos Societários (DREI)

Para demandas relacionadas a **constituição, alteração ou extinção de sociedades**, o orquestrador aplica o fluxo DREI completo antes de invocar `gerador-minutas`.

Consultar `references/fluxo-drei.md` para:
- Checklist de requisitos por tipo de ato (Instrução Normativa DREI vigente)
- Orientação sobre qual ato usar em cada situação
- Exigências de registro na Junta Comercial vs. Cartório de RTD
- Advertências sobre cláusulas obrigatórias e vedadas

---

## Comportamento para Ambiguidade

### Demanda com múltiplas interpretações → perguntar UMA coisa

```
[usuário: "preciso de um contrato"]
→ "Que tipo de contrato você precisa?
   (a) Prestação de serviços
   (b) Compra e venda
   (c) Locação
   (d) Societário (contrato social / alteração)
   (e) Outro — descreva"
```

### Demanda multi-etapa → sequenciar e avisar

```
[usuário: "vou abrir uma empresa e preciso de tudo"]
→ Anunciar a sequência:
   "Para isso vou te ajudar em etapas:
   1️⃣ Conflict check (se já é cliente do escritório)
   2️⃣ Coleta de dados para o ato constitutivo
   3️⃣ Geração da minuta conforme tipo societário e regras da DREI
   4️⃣ Checklist de registros e licenças
   Começando pelo primeiro passo..."
```

---

## Skills Disponíveis

| # | Skill | Função |
|---|---|---|
| 1 | `analise-legislacao` | Mapeamento de normas e checklist de compliance |
| 2 | `analise-risco-processual` | Memorial de risco, prognóstico, cenários |
| 3 | `analise-sentenca` | Análise de decisão e estratégia recursal |
| 4 | `comunicados-clientes` | Comunicados profissionais ao cliente |
| 5 | `conflict-check` | Verificação de conflito antes de aceitar caso |
| 6 | `conteudo-autoridade` | Posts para redes seguindo ética OAB |
| 7 | `edicao-cirurgica` | Edição de trechos específicos (economia de tokens) |
| 8 | `gerador-minutas` | Minutas contratuais e atos societários |
| 9 | `gestao-prazos` | Cálculo de prazos processuais e alertas |
| 10 | `lgpd-escritorio` | Diagnóstico e compliance LGPD |
| 11 | `notificacao-extrajudicial` | Notificações com fundamentação e prazo |
| 12 | `onboarding-cliente` | Kit de entrada de novo cliente |
| 13 | `pesquisa-jurisprudencia` | Roteiro de pesquisa e mapa argumentativo |
| 14 | `precificacao-honorarios` | Precificação e proposta comercial |
| 15 | `preparacao-audiencias` | Roteiro, perguntas e simulação de audiência |
| 16 | `resumo-pecas` | Esqueleto argumentativo de peças processuais |
| 17 | `revisao-contratos` | Análise de risco com score e recomendações |

---

## Recursos Adicionais

- **`references/mapa-habilidades.md`** — Tabela completa de gatilhos com frases por skill
- **`references/questionarios-intake.md`** — Questionários específicos por tipo de demanda
- **`references/fluxo-drei.md`** — Fluxo completo para atos societários (DREI/Junta Comercial)
