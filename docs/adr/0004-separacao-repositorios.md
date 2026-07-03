# ADR-0004: Separação entre plugin público e MF-AOS privado

- **Status**: aceito (execução pendente — ver Consequências)
- **Data**: 2026-07-03
- **Decisores**: Dr. Márcio
- **Origem**: achados A2 (revisão interna) e B4 (red team); RFC-0004,
  decisão 2

## Contexto

Este repositório acumula duas identidades incompatíveis: (a) plugin público
`advogado-juridico`, de autoria original de Misael Holanda, instalável por
qualquer escritório; (b) o sistema operacional privado do escritório Márcio
França — blueprint com roadmap de negócio, memória institucional e
instruções operacionais próprias. O red team demonstrou os riscos: exposição
de estratégia comercial a adversários, inferência de padrões de trabalho via
metadados, contaminação de propriedade intelectual e terceiros herdando o
`CLAUDE.md` de outro escritório.

## Decisão

O MF-AOS passa a viver em **repositório privado separado**. O repositório
público permanece como o plugin genérico (skills + hook + governança
técnica), sem plano de negócio, sem memória operacional e sem instruções
específicas do escritório.

## Alternativas consideradas

- Tornar este repositório inteiro privado: descartado — mataria o plugin
  como produto instalável e não resolveria a autoria de terceiro.
- Manter tudo junto com avisos: descartado — aviso não impede inferência
  adversarial nem resolve licenciamento.

## Consequências

- O código do `mf-memoria` (ADR-0003) nasce já no repositório privado.
- Migram para o privado: `MF-PRODUCT.md` (roadmap/backlog de negócio),
  `MF-VISION-2030.md`, `memory/`, `CURRENT_STATE.md` e as partes do
  `CLAUDE.md` específicas do escritório. Permanecem no público: skills,
  hook, CI técnico, `CONTRIBUTING.md`, `SECURITY.md`, versões genéricas dos
  documentos que fizerem sentido para qualquer escritório.
- A escolha de licença do plugin público destrava (com a verificação de
  autoria junto a Misael Holanda como pré-requisito).
- **Execução pendente**: a criação do repositório privado é ato do Dr.
  Márcio (ou de sessão autorizada com acesso a ele); o plano de migração
  detalhado será o primeiro passo da implementação do `mf-memoria`
  (`docs/design/mf-memoria-v1.md`, Fase 0).
