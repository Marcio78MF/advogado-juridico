# Política de Segurança

## O que este repositório protege

Este repositório versiona **capacidade** (skills, documentação, automação) do
MF-AOS. Ele **nunca** deve conter:

- nome real de cliente ou parte adversa;
- número real de processo;
- conteúdo de peça, contrato ou documento real de caso;
- credencial, token, chave de API ou senha de qualquer serviço.

Esses itens estão protegidos por sigilo profissional advocatício (Estatuto da
OAB) e pela LGPD — a violação aqui não é um "vazamento de dados" genérico, é
falta ética.

## Controles ativos

- Varredura de segredos (gitleaks) em todo push e pull request (CI).
- Checklist obrigatório de dado sensível no template de PR.
- Regra permanente e inegociável deste repositório (Security First).

## Risco conhecido e aceito (registrado em 2026-07-03)

Documentos estratégicos do MF-AOS que viveram neste repositório antes da
separação (ADR-0004) **permanecem no histórico Git** — a remoção do HEAD
não os apaga de commits antigos. O proprietário decidiu **não** reescrever
o histórico por ora (ação irreversível). Mitigação vigente: nenhum dado
novo de negócio ou memória operacional entra neste repositório daqui em
diante; o conteúdo histórico não contém dado de cliente, apenas
planejamento de produto.

## Como reportar uma vulnerabilidade ou exposição

Se você identificar dado sensível commitado ou uma vulnerabilidade:

1. **Não abra issue pública** descrevendo o dado exposto.
2. Contate o proprietário do repositório diretamente
   (aba *Security* → *Report a vulnerability* do GitHub, ou e-mail do
   proprietário).
3. Dado sensível já commitado exige reescrita de histórico — ação
   irreversível que só o proprietário do repositório autoriza.
