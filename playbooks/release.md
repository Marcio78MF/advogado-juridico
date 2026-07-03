# Playbook: Release

Procedimento completo em [`RELEASE.md`](../RELEASE.md) — este playbook apenas
aponta para lá para manter fonte única. Resumo: CI verde → bump SemVer em
`plugin.json` → `CHANGELOG.md` datado → commit `chore(release): vX.Y.Z`
via PR → tag anotada → Release no GitHub.
