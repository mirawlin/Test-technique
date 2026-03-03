#!/bin/bash
set -e

# Réinitialise le repo à son état initial après un test.

git checkout main

# Supprimer toutes les branches locales sauf main
for branch in $(git branch | grep -v "main"); do
    git branch -D "$branch"
done

# Reset main au commit initial (tag "initial")
git reset --hard initial
git push --force origin main

# Supprimer les branches distantes du candidat
git fetch --prune
for branch in $(git branch -r | grep -v "main" | grep -v "HEAD" | sed 's/origin\///'); do
    git push origin --delete "$branch" 2>/dev/null || true
done

echo "Repo réinitialisé avec succès."
