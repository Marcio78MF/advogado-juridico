#!/usr/bin/env bash
# Valida a integridade estrutural do plugin advogado-juridico / MF-AOS.
# Usado localmente (scripts/validate.sh) e no CI (.github/workflows/ci.yml).
set -euo pipefail

cd "$(dirname "$0")/.."
ERROS=0

erro() {
  echo "ERRO: $1" >&2
  ERROS=$((ERROS + 1))
}

# 1. Manifesto do plugin é JSON válido e tem os campos mínimos
if ! jq -e '.name and .version and .description' .claude-plugin/plugin.json >/dev/null 2>&1; then
  erro ".claude-plugin/plugin.json inválido ou sem name/version/description"
fi

# 2. Versão segue SemVer
if ! jq -r '.version' .claude-plugin/plugin.json | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  erro "versão em plugin.json não segue SemVer (MAJOR.MINOR.PATCH)"
fi

# 3. Toda skill tem SKILL.md
for dir in skills/*/; do
  if [ ! -f "${dir}SKILL.md" ]; then
    erro "skill sem SKILL.md: ${dir}"
  fi
done

# 4. Hook existe e é executável
if [ ! -x hooks/detectar-demanda-juridica.sh ]; then
  erro "hooks/detectar-demanda-juridica.sh ausente ou sem permissão de execução"
fi

# 5. Documentos do blueprint existem
for doc in MF-CONSTITUTION.md MF-PRODUCT.md MF-ARCHITECTURE.md MF-AGENTS.md MF-OPERATIONS.md CLAUDE.md CURRENT_STATE.md; do
  if [ ! -f "$doc" ]; then
    erro "documento do blueprint ausente: $doc"
  fi
done

if [ "$ERROS" -gt 0 ]; then
  echo "Validação falhou com $ERROS erro(s)." >&2
  exit 1
fi
echo "Validação OK: manifesto, skills, hook e blueprint íntegros."
