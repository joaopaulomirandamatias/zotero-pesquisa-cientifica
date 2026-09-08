#!/usr/bin/env bash
# Instala o agente Bibliotecário e a skill do Zotero no Claude Code (pessoal: ~/.claude). Convive com o Metodólogo e o Orientador.
set -e
AQUI="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p ~/.claude/skills ~/.claude/agents
cp -r "$AQUI/skills/bibliotecario-zotero" ~/.claude/skills/
cp "$AQUI/agents/bibliotecario.md" ~/.claude/agents/
echo "instalado: $(ls ~/.claude/agents | tr '\n' ' ')"
for a in metodologo orientador; do [ -f ~/.claude/agents/$a.md ] && echo "· $a também instalado" ; done
echo; echo "No Claude Code, na pasta do projeto: \"Bibliotecário, auditar minha biblioteca\" (com o Zotero aberto)."
