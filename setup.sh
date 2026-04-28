#!/usr/bin/env bash
# Setup del marketplace su GitHub.
# Uso: ./setup.sh <github-username> <repo-name>
# Esempio: ./setup.sh lpolignone claude-plugins

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Uso: $0 <github-username> <repo-name>"
  echo "Esempio: $0 lpolignone claude-plugins"
  exit 1
fi

USER="$1"
REPO="$2"

# Sostituisci le coordinate GitHub nel README (l'unico file che le contiene).
echo "→ Aggiorno README.md con $USER/$REPO"

if [[ "$(uname)" == "Darwin" ]]; then SED_INPLACE=(sed -i '')
else SED_INPLACE=(sed -i); fi

"${SED_INPLACE[@]}" "s|<github-user>/<repo-name>|$USER/$REPO|g" README.md

# Init git se non già fatto.
if [[ ! -d .git ]]; then
  git init -q
  git checkout -q -b main 2>/dev/null || true
fi

git add -A
git commit -q -m "Initial commit: polignone-plugins marketplace with software-wiki plugin" || true

# Crea il repo su GitHub e pusha (se gh CLI è installato).
if command -v gh >/dev/null 2>&1; then
  echo "→ Uso gh CLI per creare $USER/$REPO"
  gh repo create "$USER/$REPO" --public --source=. --remote=origin --push
else
  echo "→ gh CLI non installato. Crea il repo a mano su https://github.com/new e poi:"
  echo "    git remote add origin git@github.com:$USER/$REPO.git"
  echo "    git push -u origin main"
fi

echo ""
echo "✅ Fatto. Da Claude Code in qualunque progetto:"
echo "   /plugin marketplace add $USER/$REPO"
echo "   /plugin install software-wiki@polignone-plugins"
