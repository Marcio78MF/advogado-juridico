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

Agente independente, sem contexto prévio, instruído a provar que a
arquitetura falhará. Leu todo o blueprint, a governança, o CI, 4 skills e
**executou o hook contra prompts reais**. Síntese do veredicto adversarial:

> "Este repositório contém 60 KB de constituições e 7 KB de código, e o
> código estava quebrado. Todas as garantias do sistema existem como prosa
> que o modelo é convidado a obedecer, e zero delas como mecanismo que o
> impeça de desobedecer. Enquanto a razão prosa:mecanismo não se inverter,
> cada nova onda da visão adicionará promessas ao passivo, não capacidades
> ao ativo."

O veredicto foi aceito como tese central: **a métrica de saúde do MF-AOS
passa a ser converter prosa em mecanismo** — cada garantia importante deve
migrar de "instrução que o modelo lê" para "controle que executa" (teste,
validação de CI, gate de skill, código determinístico).

### Achados do red team e disposição

| # | Achado (severidade) | Disposição |
|---|---|---|
| B1 | Conflict-check inexecutável (sem base de clientes para cruzar) e pulável pelo roteamento (CRÍTICO) | ✅ parcial: gate bloqueante adicionado à skill `onboarding-cliente` (pergunta obrigatória antes de qualquer kit). 🔶 A execução real do cruzamento depende do Memory Engine — registrado como requisito R1 do desenho (RFC-0004) |
| B2 | Política de sigilo protege o Git e ignora o canal do runtime (sessão LLM, conectores, LGPD art. 33) (CRÍTICO) | ✅ reconhecido em `MF-ARCHITECTURE.md` §5; 🔶 mapa de tratamento do runtime no backlog com prioridade alta, pré-requisito do Memory Engine |
| B3 | Hook lançado quebrado, contrato de API inventado e **sem registro** (`hooks/hooks.json` inexistente — o hook pode nunca ter sido acionado) (CRÍTICO) | ✅ regex/formato corrigidos na Parte A; ✅ `hooks/hooks.json` criado + campo `hooks` no `plugin.json` + verificação no CI; 🔶 teste em instalação limpa no backlog |
| B4 | Identidade dupla + propriedade intelectual (autoria de terceiro, sem LICENSE, plano de negócio do escritório em repositório instalável) (CRÍTICO) | ⏸️ = achado A2, urgência elevada — decisão do Dr. Márcio |
| B5 | Memory Engine sem uma única decisão de design, e Ondas 2–5 inteiras dependem dele (CRÍTICO) | ✅ endereçado: desenho técnico completo em `docs/rfc/0004-memory-engine.md`, em revisão pelo Dr. Márcio |
| B6 | Contradição de precedência do veto (ALTO) | ✅ = achado A1, corrigido na Parte A (o red team leu o HEAD anterior). Residual aceito: o veto ainda é prosa; vira mecanismo com o Audit Engine |
| B7 | Drift documental: contagens divergentes, claim falso de "carregado em toda sessão", regra de CHANGELOG obsoleta (ALTO) | ✅ corrigidos os quatro pontos citados; 🔶 verificação automatizada de consistência cruzada é candidata ao CI |
| B8 | Três fontes de roteamento divergentes; if-chain de regex não escala; orquestrador dispara em "preciso de ajuda" (ALTO) | 🔶 fonte única declarativa no backlog; inversão LLM-first já prevista (Future Review §3) |
| B9 | `gestao-prazos` é prosa probabilística apresentada como mitigação do risco mais fatal (ALTO) | ✅ matriz de riscos corrigida (skill = apoio, não mitigação); 🔶 motor determinístico de prazos no backlog com prioridade alta — primeiro candidato a código de aplicação |
| B10 | Registro de trabalho vaza metadado operacional mesmo com granularidade mensal (repo instalável + timestamps de commit + PJe público) (ALTO) | ✅ registro **suspenso** até a decisão B4; pertence ao Memory Engine privado (RFC-0004) |
| B11 | CI protege risco errado (gitleaks ≠ dado de cliente); revisão de fachada; branch protection nunca ativada (ALTO) | ✅ varredura CNJ+CPF+CNPJ no CI; ⏸️ branch protection segue pendente do Dr. Márcio (`playbooks/configurar-github.md`); limitação "nome de pessoa é indetectável por regex" documentada |
| B12 | Bounded contexts são tabela, não fronteiras (MÉDIO) | ✅ terminologia corrigida em `MF-ARCHITECTURE.md` §9: taxonomia que prefigura contexts; viram reais com o Memory Engine |
| B13 | "Conhecimento portável" é falso para tudo exceto a prosa (MÉDIO) | 🔶 aceito parcialmente: regra "domínio em `references/` (neutro), mecânica no `SKILL.md`" já vigente; extração de lógica de negócio para formato neutro fica como diretriz da Onda 2+ |
| B14 | "Multi-tenant é extensão, não reescrita" é infalsificável hoje e falsa amanhã (MÉDIO) | ✅ afirmação removida de `MF-ARCHITECTURE.md` §11 e substituída pela versão honesta |
| B15 | Contexto permanente sem freio de crescimento; proposta de kernel ~2k tokens + carga sob demanda (MÉDIO) | 🔶 = achado A10, descrição do item de backlog atualizada para a proposta do kernel |
| B16 | Governança dimensionada para time que não existe; IA aprovando o próprio ADR (MÉDIO) | 🔶 aceito com gate: na primeira revisão trimestral, todo artefato de processo que estiver vazio/sem uso é cortado. Decisões de arquitetura tomadas por Claude ficam sujeitas a ratificação do Dr. Márcio na revisão seguinte |
| B17 | Ondas 4–5 sem caminho estatístico (n pequeno, outcomes não capturados) (MÉDIO) | ✅ aceito: captura de desfecho entra no esquema da Onda 2 (RFC-0003/RFC-0004); Prediction reposicionado como *recuperação de casos semelhantes*, não aprendizado estatístico — n pequeno permite busca, não inferência |
| B18 | Hook: dependência de python3, injeção imperativa sequestrável por texto colado, nomes não canônicos no teste (BAIXO) | ✅ fallback jq + saída silenciosa; tom rebaixado a sugestão explicitamente ignorável; nomes canônicos no teste |
| B19 | Riscos ético-profissionais BR ignorados: Res. CNJ 615/2025, citação "de memória", dever de informar cliente (BAIXO na forma, ALTO no fundo) | ✅ invariante "nenhuma citação sem fonte verificada / marcador [CONFERIR NA FONTE]" em `MF-ARCHITECTURE.md` §3; 🔶 política formal OAB/CNJ no backlog |

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
