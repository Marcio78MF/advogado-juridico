# Checklist de Análise de FII — Critérios de Aprovação

Rodar com **dados atuais verificados** (mínimo 2 fontes: Status Invest, Investidor10, Funds Explorer, relatório gerencial no site da gestora ou Fundos.NET/B3). Dado de memória é proibido.

**Regra de decisão:** falha em **2 ou mais critérios → REPROVADO**. Falha em 1 → APROVADO COM RESSALVA (peso menor).

## Os 7 critérios

### 1. P/VP (Preço / Valor Patrimonial)
- **Tijolo e FOF:** entrar até 1,05. Acima de 1,10 → falha.
- **Papel high grade:** aceitável até 1,10 se a carteira de CRIs justificar.
- **Desconto profundo (< 0,70) não é aprovação automática** — investigar se é assimetria real (JSRE11) ou value trap (dívida + venda forçada de ativos, padrão RECT11).

### 2. Dividend Yield 12 meses vs pares
- Comparar **sempre dentro do segmento** (papel rende nominal mais alto que tijolo por construção).
- DY muito acima dos pares → investigar evento não-recorrente, queima de reserva ou crédito distressed. Se confirmado e recorrente, falha.
- DY muito abaixo dos pares sem contrapartida de qualidade → falha.

### 3. Vacância (só tijolo)
- Física < 10% → saudável. 10-15% → ressalva, exigir tendência de queda no relatório.
- \> 15% → falha.
- Checar também **vacância financeira** e saídas de inquilino anunciadas.

### 4. Liquidez média diária
- \> R$ 1 milhão/dia → aprovado. R$ 200 mil-1 mi → ressalva.
- < R$ 200 mil/dia → falha (risco de aprisionamento).

### 5. Base de cotistas
- \> 50 (mínimo legal para isenção de IR) — abaixo disso, falha automática.
- Ideal > 10.000 para liquidez estrutural.

### 6. Histórico de distribuição
- 2-3 anos de pagamentos consistentes, sem suspensões.
- Picos isolados por venda de ativo não contam como recorrência.
- Fundo em liquidação/incorporação (padrão XPIN11) → falha por quebra de continuidade.

### 7. Qualidade específica do segmento
- **Papel:** % high grade vs high yield, indexadores (IPCA/CDI), taxa média, duration, inadimplência da carteira de CRIs.
- **Logística/Lajes:** WALE (prazo médio dos contratos), % contratos atípicos, concentração de inquilinos.
- **Shopping:** NOI/m², Same Store Sales, sazonalidade coberta por reserva.
- **FOF:** desconto da cota de mercado vs patrimonial, qualidade da carteira subjacente, taxa em dobro (do FOF + dos fundos investidos).

## Red flags que reprovam sozinhas (independente dos critérios)

- Distribuição suspensa sem plano claro de retomada
- Alavancagem com dívida indexada a IPCA pressionando FFO e forçando venda de imóveis abaixo do laudo
- Gestora sob investigação ou troca abrupta sem explicação
- Fundo flertando com < 50 cotistas

## Formato do veredito

```
[TICKER] — [APROVADO / APROVADO COM RESSALVA / REPROVADO]
P/VP: x,xx (fonte, data) | DY 12m: x,x% | Vacância: x,x% | Liquidez: R$ x,x mi/dia
Critérios violados: [lista ou "nenhum"]
Ressalvas: [se houver]
Fontes: [links]
```
