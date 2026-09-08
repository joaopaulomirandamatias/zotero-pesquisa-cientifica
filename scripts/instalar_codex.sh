#!/usr/bin/env bash
# Registra o conector MCP «zotero» no Codex (CLI e app — ambos leem ~/.codex/config.toml) e instala o prompt /bibliotecario.
set -e
AQUI="$(cd "$(dirname "$0")/.." && pwd)"; SRV="$AQUI/scripts/zotero_mcp.py"
command -v uv >/dev/null || { echo "Instale o uv (https://docs.astral.sh/uv/) ou troque o comando por: python3 -m pip install mcp && python3 $SRV"; exit 1; }
if command -v codex >/dev/null; then
  codex mcp remove zotero >/dev/null 2>&1 || true
  codex mcp add zotero -- uv run --with mcp python "$SRV" && echo "Codex: conector zotero registrado em ~/.codex/config.toml"
else
  mkdir -p ~/.codex; printf '\n[mcp_servers.zotero]\ncommand = "uv"\nargs = ["run", "--with", "mcp", "python", "%s"]\n' "$SRV" >> ~/.codex/config.toml; echo "Codex: seção [mcp_servers.zotero] acrescentada em ~/.codex/config.toml"
fi
mkdir -p ~/.codex/prompts && cp "$AQUI/codex/prompts/bibliotecario.md" ~/.codex/prompts/ && echo "Codex: prompt /bibliotecario instalado em ~/.codex/prompts"
echo "Dica: para o Codex chamar as ferramentas sem pedir aprovação a cada vez (todas só leem), acrescente em ~/.codex/config.toml, por ferramenta:"; echo "  [mcp_servers.zotero.tools.status]"; echo "  approval_mode = \"auto\"      # valores aceitos: auto, prompt, writes, approve"
echo; echo "Abra o Codex na pasta do projeto (ele lê AGENTS.md deste repositório) e peça: /bibliotecario auditar a coleção \"Minha revisão\"."
