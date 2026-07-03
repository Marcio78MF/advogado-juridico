# ADR-0003: Memory Engine local-first — SQLite cifrado + servidor MCP `mf-memoria`

- **Status**: aceito
- **Data**: 2026-07-03
- **Decisores**: Dr. Márcio (aprovação da RFC-0004 com condições)
- **Origem**: RFC-0004; achado B5 do red team; Future Review §1

## Contexto

Todas as ondas 2–5 da visão dependem de memória persistente, e não havia
nenhuma decisão de storage, sigilo ou interface de consulta. Skills em
Markdown não têm mecanismo nativo de acesso a dados estruturados.

## Decisão

1. **Local-first**: os dados vivem na máquina principal do escritório, em
   banco SQLite **cifrado**, em diretório fora de qualquer repositório Git.
2. **Acesso via MCP**: um servidor MCP próprio (`mf-memoria`) expõe
   operações nomeadas às skills; o runtime recebe respostas mínimas
   (veredito, agregado), nunca despejo de tabelas.
3. **Uma máquina no v1**; multi-dispositivo é fase futura (nova decisão
   quando chegar).
4. **Vocabulário de áreas** (12): cível, consumidor, bancário/consignados,
   criminal, previdenciário, tributário, família/sucessões, empresarial,
   ambiental, administrativo, trabalhista, trânsito.
5. **Desfecho obrigatório** (2–3 campos) ao encerrar caso, peça ou tarefa
   relevante — validado o custo operacional pelo Dr. Márcio.
6. **Retenção**: 5 anos, revisão anual, anonimização e expurgo quando
   aplicável.
7. Implementação condicionada às 8 salvaguardas da RFC-0004 (Decisões da
   revisão, item 7) e a plano técnico aprovado (`docs/design/mf-memoria-v1.md`).

## Alternativas consideradas

- Banco hospedado/nuvem: descartado no v1 — maior superfície de risco para
  dado sob sigilo profissional, custo recorrente, e contraria o gate de
  simplicidade (`MF-CONSTITUTION.md` §6).
- Arquivos JSON/Markdown estruturados: descartado — sem transação, sem
  cifragem nativa, sem consulta relacional; foi exatamente o modo de falha
  previsto na Future Review §1.
- Acesso direto ao arquivo pelo modelo (sem MCP): descartado — violaria o
  princípio do mínimo necessário no runtime (achado B2).

## Consequências

- Nasce o primeiro código de aplicação do MF-AOS, arrastando o tooling
  adiado no ADR-0002 (que deve ser marcado como parcialmente substituído na
  implementação).
- O conflict-check passa de prosa a mecanismo (gate no engine).
- Backup e gestão de chave viram responsabilidades operacionais novas do
  escritório (playbooks na implementação).
