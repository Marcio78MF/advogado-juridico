# advogado-juridico — Plugin Claude Code para Escritórios de Advocacia

Suite completa de IA jurídica para Claude Code: orquestrador inteligente que detecta automaticamente a demanda do advogado e ativa a skill especializada correta — com coleta estruturada de informações antes de gerar qualquer documento.

## Instalação

```bash
claude plugin install github:misaelholanda/advogado-juridico
```

Ou manualmente:

```bash
git clone https://github.com/misaelholanda/advogado-juridico ~/.claude/plugins/advogado-juridico
```

Depois, adicione ao `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "advogado-juridico@local": true
  }
}
```

## Como funciona

O **Orquestrador Jurídico** detecta automaticamente a demanda a partir da mensagem do advogado e:

1. 🔵 **Anuncia** qual módulo foi ativado
2. 📋 **Faz perguntas** uma por vez para coletar todas as informações necessárias
3. ✅ **Confirma** o contexto antes de gerar o documento
4. ⚡ **Invoca** a skill especializada com todos os dados em mãos

### Exemplo

```
Advogado: "preciso de um contrato social de LTDA"

🔵 [Módulo detectado: Gerador de Minutas — Atos Societários]

→ Pergunta 1: "É (a) constituição, (b) alteração, (c) distrato ou (d) outro?"
→ Pergunta 2: "Qual o tipo societário? (a) LTDA (b) SLU (c) SA (d) Sociedade Simples?"
→ Pergunta 3: "Quantos sócios?"
→ ... coleta dados completos ...
→ Gera minuta conforme regras da DREI + orienta sobre registro na Junta Comercial
```

## Skills Disponíveis (18 no total)

| # | Skill | Função |
|---|---|---|
| 0 | **orquestrador-juridico** | Detecta demanda e roteia para a skill correta |
| 1 | analise-legislacao | Mapeamento de normas e checklist de compliance |
| 2 | analise-risco-processual | Memorial de risco, prognóstico e cenários |
| 3 | analise-sentenca | Análise de decisão judicial e estratégia recursal |
| 4 | comunicados-clientes | Comunicados profissionais sobre andamento processual |
| 5 | conflict-check | Verificação de conflito antes de aceitar novo caso |
| 6 | conteudo-autoridade | Posts para redes sociais seguindo ética da OAB |
| 7 | edicao-cirurgica | Edição de trechos específicos (economia de tokens) |
| 8 | gerador-minutas | Minutas contratuais e atos societários (DREI) |
| 9 | gestao-prazos | Cálculo de prazos processuais e alertas |
| 10 | lgpd-escritorio | Diagnóstico e compliance LGPD |
| 11 | notificacao-extrajudicial | Notificações com fundamentação e prazo |
| 12 | onboarding-cliente | Kit completo de entrada de novo cliente |
| 13 | pesquisa-jurisprudencia | Roteiro de pesquisa e mapa de jurisprudência |
| 14 | precificacao-honorarios | Precificação e proposta comercial de honorários |
| 15 | preparacao-audiencias | Roteiro, perguntas e simulação de audiência |
| 16 | resumo-pecas | Esqueleto argumentativo de peças processuais |
| 17 | revisao-contratos | Análise de risco contratual com score |

## Atos Societários (DREI)

O plugin inclui base de conhecimento completa com as regras da **IN DREI nº 81/2020** (e atualizações até IN 01/2024) para:

- **Empresário Individual (EI)** — Anexo II
- **Sociedade Limitada / SLU** — Anexo IV
- **Sociedade Anônima / SAF** — Anexo V

Cobre: documentos obrigatórios, cláusulas obrigatórias, quóruns, prazos, vedações, checklists e modelos de qualificação.

## Hook de Detecção Automática

O plugin instala um hook `UserPromptSubmit` que analisa cada mensagem e injeta o contexto da skill correta antes de Claude processar — sem necessidade de comandos manuais.

## Estrutura

```
advogado-juridico/
├── .claude-plugin/
│   └── plugin.json
├── hooks/
│   └── detectar-demanda-juridica.sh
└── skills/
    ├── orquestrador-juridico/
    │   ├── SKILL.md
    │   └── references/
    │       ├── fluxo-drei.md
    │       ├── mapa-habilidades.md
    │       └── questionarios-intake.md
    └── [17 skills especializadas]/
```

## Aviso Legal

Este plugin é uma ferramenta de apoio ao trabalho do advogado. **Não substitui** o julgamento profissional, a revisão humana dos documentos gerados, nem o parecer jurídico formal. Toda peça gerada deve ser revisada pelo advogado responsável antes de uso.

## Autor

Misael Holanda — mhcontabil@gmail.com
