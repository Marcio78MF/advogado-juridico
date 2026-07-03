#!/usr/bin/env bash
# Teste de regressão do roteamento do hook detectar-demanda-juridica.sh.
# Toda mudança no hook DEVE passar aqui (MF-ARCHITECTURE.md §12).
# Nasceu do achado A3 da revisão constitucional de 2026-07: o padrão "RE "
# roteava qualquer frase contendo "sobre" para analise-sentenca.
set -euo pipefail

cd "$(dirname "$0")/.."
OK=0
FALHA=0

testar() {
  local frase="$1" esperado="$2" obtido
  obtido=$(echo "{\"prompt\": \"$frase\"}" | bash hooks/detectar-demanda-juridica.sh \
    | grep -o 'skill: [a-z-]*' | sed 's/skill: //' || true)
  obtido="${obtido:-orquestrador-juridico}"
  if [ "$obtido" = "$esperado" ]; then
    OK=$((OK + 1))
  else
    FALHA=$((FALHA + 1))
    echo "FALHA: [$frase] esperado=$esperado obtido=$obtido" >&2
  fi
}

# Falsos positivos históricos (achado A3 — "sobre" continha "re ")
testar "me ajude a pensar sobre o roadmap" "orquestrador-juridico"
testar "quero informações sobre honorários" "orquestrador-juridico"
testar "faça um post sobre direito do consumidor" "conteudo-autoridade"

# Uma frase representativa por skill detectável
testar "posso aceitar esse caso do novo cliente?" "conflict-check"
testar "analise essa sentença do juiz" "analise-sentenca"
testar "analisar o acórdão do TJ" "analise-sentenca"
testar "o STJ julgou o REsp 1234567 ontem" "analise-sentenca"
testar "quais as chances de ganhar essa ação?" "analise-risco-processual"
testar "calcular prazo para contestar" "gestao-prazos"
testar "gerar minuta de contrato de locação" "gerador-minutas"
testar "revisar esse contrato de prestação de serviços" "revisao-contratos"
testar "qual a jurisprudência do STJ sobre juros abusivos" "pesquisa-jurisprudencia"
testar "redigir notificação extrajudicial de cobrança" "notificacao-extrajudicial"
testar "preparar audiência de instrução de amanhã" "preparacao-audiencias"
testar "esqueleto da petição inicial" "resumo-pecas"
# "novo cliente" roteia para conflict-check MESMO em pedido de onboarding:
# precedência deliberada — conflito é verificado antes de qualquer entrada
# de cliente (MF-OPERATIONS.md §5, etapa bloqueante).
testar "kit de entrada de novo cliente" "conflict-check"
testar "corrige só essa cláusula do contrato" "edicao-cirurgica"
testar "comunicar o cliente sobre o andamento" "comunicados-clientes"
testar "diagnóstico LGPD do escritório" "lgpd-escritorio"
testar "quanto cobrar por uma ação trabalhista?" "precificacao-honorarios"
testar "kit de boas-vindas para o cliente que entrou" "onboarding-cliente"
testar "quais leis se aplicam a fintech de crédito" "analise-legislacao"

echo "Roteamento: $OK OK, $FALHA falha(s)."
[ "$FALHA" -eq 0 ]
