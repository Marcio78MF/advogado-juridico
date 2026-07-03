#!/bin/bash
# Hook: Detecção Automática de Demanda Jurídica
# Evento: UserPromptSubmit
# Função: Analisa a mensagem do usuário e injeta instrução de roteamento
#         para a skill jurídica correta, ANTES de Claude processar.

# Ler o prompt do usuário via stdin (formato JSON do hook)
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('prompt',''))" 2>/dev/null || echo "")

# Se não conseguiu ler o prompt, sair sem fazer nada
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Converter para minúsculas para matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Função de detecção de skill
detect_skill() {
  local p="$1"

  # Conflict check (verificar ANTES de aceitar — alta prioridade)
  if echo "$p" | grep -qiE "conflict.?check|conflito de interesse|posso aceitar|devo aceitar|novo cliente|aceitar esse caso|impedimento|recusar caso"; then
    echo "conflict-check"
    return
  fi

  # Análise de sentença/recurso
  if echo "$p" | grep -qiE "analis(a|ar|e) (o |a |esse |essa |este |esta )?(sentença|acórdão|decisão|despacho)|cab(e|em) recurso|pont(o|os) recorrív|viabilidade recursal|estratégia recursal|apelação|embargo(s)? de declaração|recurso (extraordinário|especial)|\bresp\.? [0-9]|\bre [0-9]|recorrer da"; then
    echo "analise-sentenca"
    return
  fi

  # Análise de risco processual
  if echo "$p" | grep -qiE "chance(s)? de (ganhar|vencer|perder)|prognóstico|memorial de risco|vale a pena (entrar|ajuizar|processar)|análise de mérito|viabilidade (da ação|processual)|cenário(s)? (de vitória|de acordo|processu)|custo.?benefício (do|de) process"; then
    echo "analise-risco-processual"
    return
  fi

  # Gestão de prazos
  if echo "$p" | grep -qiE "calc(ular|ula) prazo|prazo (processual|de recurso|para contestar|para recorrer)|quando vence|data.?final|intimaç(a|ã)o (saiu|publicada|de hoje)|publicaç(a|ã)o (saiu|de hoje)|DJe|PJe (publicou|saiu)|prazo em dobro|alerta de prazo"; then
    echo "gestao-prazos"
    return
  fi

  # Gerador de minutas
  if echo "$p" | grep -qiE "(ger(a|ar)|redigir|criar|faz(er)?|elaborar) (minuta|contrato|modelo de contrato|esboço de contrato|NDA|termo de)|minuta (de|para|contratual)|novo contrato"; then
    echo "gerador-minutas"
    return
  fi

  # Revisão de contratos (análise de risco em contrato JÁ existente)
  if echo "$p" | grep -qiE "revis(a|ar) (esse|este|o|contrato)|anali(sa|sar) (o|esse|este) contrato|cláusulas de risco|due diligence contratual|score de risco|contrato est(á|a) (bom|ok|adequado)|o que (pedir|mudar|ajustar) no contrato|risco(s)? (do|no|desse|nesse) contrato"; then
    echo "revisao-contratos"
    return
  fi

  # Pesquisa de jurisprudência
  if echo "$p" | grep -qiE "jurisprudência|precedente(s)?|julgado(s)?|STJ (entende|decidiu|julgou)|STF (entende|decidiu)|súmula(s)?|IRDR|tema repetitivo|strings de busca|mapeamento jurisprudencial|como os tribunais|tendência judicial"; then
    echo "pesquisa-jurisprudencia"
    return
  fi

  # Notificação extrajudicial
  if echo "$p" | grep -qiE "notificaç(a|ã)o extrajudicial|redigir notificaç(a|ã)o|notificar (o |o devedor|inadimplente|infrator)|interpelaç(a|ã)o|constituiç(a|ã)o em mora|cobrar (extrajudicial|por escrito|formalmente)|cessaç(a|ã)o de uso|notificaç(a|ã)o de (rescisão|distrato|marca|PI)"; then
    echo "notificacao-extrajudicial"
    return
  fi

  # Preparação de audiências
  if echo "$p" | grep -qiE "prepara(r|ção) (de |para )?(audiência|julgamento|sessão)|roteiro (de|para) audiência|perguntas (para|às) testemunha|simulaç(a|ã)o de audiência|checklist (de|para) audiência|sustentaç(a|ã)o oral|audiência (de amanhã|marcada|de instrução|de conciliação)"; then
    echo "preparacao-audiencias"
    return
  fi

  # Resumo / esqueleto de peças
  if echo "$p" | grep -qiE "estrutura (de|da|para) (petição|peça|contestação|recurso|agravo|apelação)|esqueleto (da|de|para) (peç|petiç|contestaç|recurso)|rascunho (da|de) (petição|peça)|tópicos (da|para) (petição|contestação)|linha argumentativa|ordem dos argumentos|(mont(a|ar)|organ(iza|izar)) (os pedidos|a petição|a peça)"; then
    echo "resumo-pecas"
    return
  fi

  # Edição cirúrgica
  if echo "$p" | grep -qiE "ediç(a|ã)o cirúrgica|corrige (só|apenas|somente) (essa|esse|o) (cláusula|trecho|parágrafo|bloco|seção)|ajusta (só|apenas) (essa|o|a) (cláusula|seção|parte)|altera (só|apenas)|não reescreve (tudo|o contrato)|só o trecho"; then
    echo "edicao-cirurgica"
    return
  fi

  # Comunicados para clientes
  if echo "$p" | grep -qiE "comunicar (o |ao )?cliente|informar (o |ao )?cliente|mensagem (para|ao) cliente|WhatsApp (para|ao) cliente|e-?mail (para|ao) cliente|atualiza(ç(a|ã)o|r) (processual|do processo)|(relatório|report) mensal|traduz (esse|para o cliente|para leigo)"; then
    echo "comunicados-clientes"
    return
  fi

  # LGPD
  if echo "$p" | grep -qiE "LGPD|proteç(a|ã)o de dados|dados pessoais (do escritório|dos clientes)|diagnóstico (de |LGPD)|política de privacidade|DPO|encarregado de dados|RIPD|tratamento de dados|transferência internacional de dados"; then
    echo "lgpd-escritorio"
    return
  fi

  # Precificação / honorários
  if echo "$p" | grep -qiE "quanto cobrar|precificar|honorários (advocatícios|de êxito|mensais)|proposta comercial|tabela (de honorários|OAB)|contrato de honorários|retainer|modelo de cobrança|faixa de honorários"; then
    echo "precificacao-honorarios"
    return
  fi

  # Onboarding de cliente
  if echo "$p" | grep -qiE "onboarding|kit (de boas-vindas|de entrada|inicial)|carta de boas-vindas|checklist (documental|de documentos)|orientaç(õ|o)es (iniciais|ao cliente)|cronograma inicial (do caso|do cliente)|entrada (de |do )?(novo |)cliente"; then
    echo "onboarding-cliente"
    return
  fi

  # Legislação e compliance
  if echo "$p" | grep -qiE "legislaç(a|ã)o (aplicável|vigente)|normas (aplicáveis|regulatórias)|mapeamento (normativo|regulatório)|checklist (de compliance|regulatório)|(ANVISA|Bacen|CVM|ANATEL|ANPD|ANS) (exige|determina|regulamenta)|compliance (para|do setor|setorial)|quais leis (se aplicam|regulam)"; then
    echo "analise-legislacao"
    return
  fi

  # Conteúdo para redes sociais
  if echo "$p" | grep -qiE "(cria(r)?|faz(er)?|elabora(r)?) (um |o )?(post|conteúdo|publicaç(a|ã)o|carrossel) (para|sobre|jurídico)|LinkedIn (jurídico|do escritório)|marketing jurídico|post (sobre|para) (direito|advocacia|jurídico)|posicionamento (digital|nas redes)"; then
    echo "conteudo-autoridade"
    return
  fi

  # Não detectado — usar orquestrador para decidir
  echo "orquestrador-juridico"
}

SKILL=$(detect_skill "$PROMPT_LOWER")

# Só injetar instrução se detectou skill específica (não genérica)
if [ "$SKILL" != "orquestrador-juridico" ]; then
  # Para UserPromptSubmit, stdout simples é anexado ao contexto da conversa.
  # (O campo JSON "additionalSystemPrompt" usado anteriormente não é parte do
  # contrato de hooks — funcionava por acidente, com o JSON bruto virando
  # contexto. Ver docs/reviews/2026-07-revisao-constitucional.md, achado A4.)
  echo "[DETECÇÃO AUTOMÁTICA] A demanda detectada pertence à skill: ${SKILL}. Invoque esta skill imediatamente usando a ferramenta Skill antes de qualquer resposta."
fi

exit 0
