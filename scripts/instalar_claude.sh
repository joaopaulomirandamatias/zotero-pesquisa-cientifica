#!/usr/bin/env bash
# Registra o conector MCP «zotero» e instala agente + skill no Claude Code (escopo do usuário) e,
# se existir, no Claude Desktop. Alternativa sem este script: no Claude Code,
#   /plugin marketplace add joaopaulomirandamatias/zotero-pesquisa-cientifica  →  /plugin install zotero-pesquisa@mirandastech-zotero
set -e
AQUI="$(cd "$(dirname "$0")/.." && pwd)"; SRV="$AQUI/scripts/zotero_mcp.py"
command -v uv >/dev/null || { echo "Instale o uv (https://docs.astral.sh/uv/) ou troque o comando por: python3 -m pip install mcp && python3 $SRV"; exit 1; }
if command -v claude >/dev/null; then
  claude mcp remove zotero -s user >/dev/null 2>&1 || true
  claude mcp add --scope user --transport stdio zotero -- uv run --with mcp python "$SRV" && echo "Claude Code: conector zotero registrado (escopo do usuário)"
fi
mkdir -p ~/.claude/skills ~/.claude/agents
cp -r "$AQUI/skills/bibliotecario-zotero" ~/.claude/skills/ && cp "$AQUI/agents/bibliotecario.md" ~/.claude/agents/ && echo "Claude Code: agente Bibliotecário e skill instalados em ~/.claude"
for CFG in "$HOME/.config/Claude/claude_desktop_config.json" "$HOME/Library/Application Support/Claude/claude_desktop_config.json" "$APPDATA/Claude/claude_desktop_config.json"; do
  [ -f "$CFG" ] || continue
  python3 - "$CFG" "$SRV" <<'PY'
import json,sys; p,srv=sys.argv[1],sys.argv[2]; d=json.load(open(p))
d.setdefault("mcpServers",{})["zotero"]={"command":"uv","args":["run","--with","mcp","python",srv]}
json.dump(d,open(p,"w"),indent=2,ensure_ascii=False); print("Claude Desktop: conector zotero adicionado em",p,"(reinicie o app)")
PY
done
echo; echo "Com o Zotero aberto e a API local ligada (Configurações → Avançado), peça: \"Bibliotecário, auditar minha biblioteca\"."
