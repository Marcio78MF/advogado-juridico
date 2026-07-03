# Revisão Constitucional — Julho/2026

Revisão crítica de todo o blueprint (visão, constituição, arquitetura,
agentes, operações, ADRs, RFCs, governança e código) com mandato explícito
de encontrar contradições, sem compromisso de confirmar decisões anteriores.
Conduzida em duas frentes independentes: **Parte A** (revisão interna, por
quem construiu — viés admitido) e **Parte B** (red team externo, agente
independente sem contexto prévio, instruído a provar que a arquitetura
falhará).

Legenda de status: ✅ corrigido nesta revisão · 🔶 registrado no backlog ·
⏸️ decisão do Dr. Márcio.

## Parte A — Revisão interna

### A1 (ALTO) Contradição de precedência: veto de segurança vs. exceção do preâmbulo ✅
A Constituição dizia que uma instrução explícita do Dr. Márcio afasta
qualquer princípio; `MF-AGENTS.md` §4 dizia que o papel de Security Engineer
veta "mesmo sobre pedido explícito". As duas regras eram incompatíveis.
**Correção**: preâmbulo da Constituição emendado — sigilo profissional e dado
de cliente não são afastáveis nem por instrução pontual; todo o resto é.

### A2 (ALTO) Crise de identidade do repositório ⏸️
O repositório é, ao mesmo tempo: (a) um plugin público de autoria de
terceiro (`plugin.json` → Misael Holanda; `README.md` ensina qualquer
advogado a instalar via `github:misaelholanda/advogado-juridico`) e (b) o
sistema operacional privado do escritório Márcio França, com `CLAUDE.md`
contendo instruções pessoais, `memory/` com padrões de trabalho do
escritório e roadmap de negócio próprio. Consequências se não resolvido:
terceiros que instalarem o plugin carregam o blueprint de outro escritório;
o `memory/` do escritório vira conteúdo público de um produto genérico; e a
licença fica juridicamente travada (autoria original é de terceiro).
**Decisão necessária (Dr. Márcio)**: separar em dois repositórios (plugin
genérico público × MF-AOS privado) ou assumir este como fork privado do
escritório. Registrado como pendência em `CURRENT_STATE.md`.

### A3 (CRÍTICO) Bug de roteamento: `RE |REsp` casava com "sobre" ✅
O padrão da skill `analise-sentenca` continha `RE ` sem âncora — em texto
minúsculo, casa com o interior de "sobre", "sempre", "livre" etc. Testado e
confirmado: *"faça um post sobre direito do consumidor"*, *"me ajude a
pensar sobre o roadmap"* e *"quero informações sobre honorários"* eram todos
roteados para `analise-sentenca`. Na prática, grande parte das frases em
português era sequestrada por uma única skill. **Correção**: padrões
ancorados (`recurso extraordinário|recurso especial|\bresp\.? [0-9]|\bre
[0-9]`); teste de regressão com 22 casos criado
(`scripts/test-roteamento.sh`) e integrado ao CI.

### A4 (MÉDIO) Formato de saída do hook fora do contrato ✅
O hook emitia JSON com o campo `additionalSystemPrompt`, que não faz parte
do contrato do evento `UserPromptSubmit` — funcionava por acidente (o JSON
bruto era anexado como contexto e o modelo o interpretava). **Correção**:
saída em stdout simples, o mecanismo documentado.

### A5 (MÉDIO) Vazamento por metadados no registro de trabalho ✅
`memory/registro-de-trabalho.md` pedia *data* + tipo de demanda. Data exata
correlacionável com atos processuais públicos (publicações, audiências)
permite inferir a que caso uma linha "anônima" se refere. **Correção**:
granularidade mensal obrigatória, com a justificativa gravada no próprio
arquivo. Regra geral derivada: anonimização exige pensar em *correlação*,
não apenas em omissão de nomes.

### A6 (MÉDIO) Quatro mecanismos de aprendizado sobrepostos ✅
Self Evolution Engine (§1), MF Evolution Engine (§9), MF Intelligence Engine
(onda 3) e Meta Orchestrator observam/aprendem — risco de virarem quatro
módulos concorrentes. **Correção**: taxonomia explícita gravada em
`MF-OPERATIONS.md` §9 — são estágios e papéis de um único ciclo (loop por
tarefa → detecção de padrão → instrumentação → consumo/decisão).

### A7 (MÉDIO) Roadmap por calendário vs. gates por evidência ✅
Os trimestres T1–T8 de `MF-PRODUCT.md` conflitavam silenciosamente com a
regra da visão de que "onda só começa quando a anterior provou valor".
**Correção**: regra de precedência gravada em `MF-PRODUCT.md` §4 — gates
prevalecem sobre calendário.

### A8 (MÉDIO) Hook dispara em sessões de desenvolvimento 🔶
O hook roda em *toda* mensagem, inclusive quando a sessão é de engenharia
deste próprio repositório — "revisar esse contrato social da skill X" seria
roteado para `revisao-contratos`. Sem correção barata hoje (o hook não sabe
o propósito da sessão). Backlog: guarda de contexto quando houver mecanismo.

### A9 (BAIXO) CI prometia mais do que entregava em dados sensíveis ✅/🔶
`SECURITY.md` promete proteção a dado de cliente, mas gitleaks detecta
credenciais, não nomes ou números de processo. **Correção parcial**:
varredura do padrão CNJ (`NNNNNNN-DD.AAAA.J.TR.OOOO`) adicionada a
`scripts/validate.sh` — números de processo agora quebram o CI. Nomes de
pessoas seguem indetectáveis por regex; a defesa é processo (template de PR
+ revisão), registrado como limitação conhecida.

### A10 (BAIXO) Crescimento do contexto permanente 🔶
`CLAUDE.md` carrega 7 documentos em toda sessão. Com o crescimento natural
do blueprint, o custo de contexto (tokens, atenção) cresce junto. Backlog:
orçamento de tamanho por documento quando a soma passar de ~1.500 linhas.

### A11 (BAIXO) Sem LICENSE, com convite público de instalação ⏸️
Sem licença, o default legal é "todos os direitos reservados" — contraditório
com um README que convida instalação. Já pendente em `CURRENT_STATE.md`;
esta revisão eleva a urgência por causa de A2 (a autoria de terceiro trava a
escolha).

## Parte B — Red Team externo

*(Relatório do agente independente consolidado abaixo — achados que
coincidem com a Parte A estão marcados; os novos receberam numeração B.)*

<!-- PARTE_B_PENDENTE -->

## Future Review — retrospectiva imaginada de 2032

"Quais decisões de 2026 impediram a evolução?" — as quatro respostas mais
prováveis, para neutralizá-las agora:

1. **"Apostamos memória em Markdown/Git por tempo demais."** O blueprint
   diz que o Memory Engine viverá "fora deste repositório", mas **nunca diz
   onde** — essa é a maior lacuna de arquitetura aberta hoje. Se a Onda 2
   começar sem essa decisão (um ADR de storage: arquivo local estruturado
   vs. SQLite vs. serviço), a memória nascerá improvisada. → Backlog com
   prioridade alta.
2. **"Tudo pressupunha Claude Code como runtime."** A visão promete
   conhecimento portável, mas skills/hook são formato proprietário. Mitigação
   real já existente: o conhecimento de domínio vive em `references/` como
   Markdown puro. Regra a manter: domínio nas `references/`, mecânica no
   `SKILL.md` — assim a troca de runtime custa a mecânica, não o acervo.
3. **"Roteamento por palavra-chave não sobreviveu a 40 skills."** A3 provou
   que já é frágil com 18. O fallback LLM (orquestrador) já é o caminho:
   planejar a inversão — orquestrador decide, hook apenas dá dica — antes da
   skill nº 25.
4. **"Nunca medimos a qualidade das skills."** Existe teste de *roteamento*,
   mas nenhum golden set de *conteúdo* (uma minuta boa vs. ruim). Sem isso,
   regressões de qualidade jurídica são invisíveis. → Candidato natural para
   o T3 (Audit Engine).

## Novas capacidades propostas nesta rodada (encaminhadas como RFC)

- `docs/rfc/0001-mf-dna.md` — princípios decisórios do escritório como
  camada explícita.
- `docs/rfc/0002-decision-replay.md` — rastreabilidade decisão → ADR → RFC →
  commit.
- `docs/rfc/0003-aprendizado-por-desfecho.md` — correlacionar ações →
  resultados (petição acolhida, acordo célere), a evolução do Evolution
  Engine.
