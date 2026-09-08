# Zotero para pesquisa científica: passo a passo (MirandasTech)

Manual em formato de slides (57) sobre o Zotero 10 para pós-graduação: instalar (programa, Connector, conta e sincronização), capturar (DOI/ISBN, Connector, PDF, importação RIS/BibTeX, «Encontrar texto completo»), organizar (coleções, etiquetas, pesquisas salvas, duplicados), ler e anotar (leitor integrado, destaques, nota a partir das anotações), citar (estilos CSL, estilo ABNT, plugin do Word/LibreOffice/Google Docs, cópia rápida, ZoteroBib), exportar e integrar (BibTeX, RIS, CSL JSON, Better BibTeX, LaTeX/Overleaf, Obsidian, ASReview/Rayyan, backup), colaborar (sincronização, WebDAV, grupos), plugins, erros comuns, checklist, fluxo completo de uma revisão, glossário com popovers e referências. Capturas de tela reais e datadas (08/09/2026) do Zotero 10.0.1 em pt-BR com uma biblioteca de exemplo de artigos de acesso aberto, e do site zotero.org.

**Manual on-line:** https://manual.mirandastech.com.br/zotero/ · **PDF:** https://manual.mirandastech.com.br/zotero/manual.pdf

Manuais irmãos: **Metodologia da pesquisa científica** — https://metodologia.mirandastech.com.br/ · **Uso de IA na pesquisa científica** — https://manual.mirandastech.com.br/

| Pasta | O que há |
|---|---|
| `manual/` | deck HTML autônomo, PDF e fonte do artefato |
| `site/` | o que o servidor serve (`index.html`, `manual.pdf`) |
| `capturas/` | capturas reais, 08/09/2026, nomeadas por passo |
| `modelos/estilos/` | os dois estilos ABNT (autor-data e numérico) do repositório CSL, testados |
| `modelos/exemplo_exportacao/` | a coleção de exemplo exportada em BibTeX, BibLaTeX e CSL JSON pelo Better BibTeX, e a lista ABNT gerada pelo Zotero |
| `modelos/estrutura_colecoes.md` · `convencao_etiquetas.md` | estrutura de coleções e convenção de etiquetas sugeridas |
| `scripts/gerar_deck.py` | regenera HTML e PDF a partir do fonte |
| `Dockerfile` · `Caddyfile` · `railway.json` | deploy estático (Caddy) |

## Conector, plugin e agente: a biblioteca dentro do Claude e do Codex

O repositório é ao mesmo tempo um **plugin do Claude Code** (agente + skill + conector MCP) e um pacote para o **Codex** (CLI e app da OpenAI). O conector é o servidor MCP `scripts/zotero_mcp.py`: lê a biblioteca pela API local do Zotero (Zotero aberto, Configurações → Avançado → «Permitir que outros aplicativos neste computador se comuniquem com o Zotero») e expõe sete ferramentas — `status`, `listar_colecoes`, `buscar_itens`, `detalhar_item`, `referencia_abnt` (o próprio Zotero formata, estilo ABNT por padrão), `auditar` e `exportar_bbt` (Better BibTeX). Só lê; nunca altera a biblioteca. Requer `uv` (ou `pip install mcp`).

| Cliente | Instalar | Usar |
|---|---|---|
| **Claude Code** (plugin) | `/plugin marketplace add joaopaulomirandamatias/zotero-pesquisa-cientifica` → `/plugin install zotero-pesquisa@mirandastech-zotero` | «Bibliotecário, auditar minha biblioteca» — o agente usa o conector |
| **Claude Code** (sem plugin) | `bash scripts/instalar_claude.sh` (registra o MCP no escopo do usuário e copia agente e skill para `~/.claude`) | idem |
| **Claude Desktop** | o mesmo `instalar_claude.sh` acrescenta `zotero` em `claude_desktop_config.json`; reinicie o app | as ferramentas aparecem no menu de conectores |
| **Codex** (CLI e app) | `bash scripts/instalar_codex.sh` (`codex mcp add zotero …` + prompt `/bibliotecario` em `~/.codex/prompts`) | `/bibliotecario auditar a coleção "X"`; na pasta do repositório o Codex lê `AGENTS.md` |
| Outro cliente MCP | comando `uv run --with mcp python <caminho>/scripts/zotero_mcp.py` (stdio) | — |

| Onde | O que faz |
|---|---|
| `.claude-plugin/plugin.json` · `marketplace.json` · `.mcp.json` | manifesto do plugin, marketplace `mirandastech` e declaração do conector |
| `agents/bibliotecario.md` | **Agente Bibliotecário**: guia a configuração passo a passo, controla `PROGRESSO_ZOTERO.md`, roda a auditoria e explica por que uma referência saiu errada. Encaminha decisões de método ao **Metodólogo** e de uso de IA ao **Orientador** |
| `skills/bibliotecario-zotero/` | checklist de configuração, tabela problema → causa → correção → slide, comandos |
| `AGENTS.md` · `codex/prompts/bibliotecario.md` | instruções do Bibliotecário para o Codex e prompt `/bibliotecario` |
| `scripts/zotero_mcp.py` | o conector MCP (stdio) |
| `scripts/auditar_biblioteca.py` | a mesma auditoria pela linha de comando; só lê |
| `scripts/exportar_bbt.sh` | exporta uma coleção pelo Better BibTeX (`bibtex`, `biblatex`, `json`) sem abrir menus |
| `scripts/backup_zotero.sh` | backup datado da pasta de dados (recusa rodar com o Zotero aberto); mantém os 7 mais recentes |
| `scripts/instalar_claude.sh` · `instalar_codex.sh` · `instalar_skills.sh` | instaladores (Claude Code/Desktop, Codex, só agente+skill) |
| `.github/workflows/verificar.yml` | CI: integridade do deck, capturas referenciadas, scripts, manifestos e estilos válidos |

### Começar em três comandos
```bash
git clone https://github.com/joaopaulomirandamatias/zotero-pesquisa-cientifica.git
bash zotero-pesquisa-cientifica/scripts/instalar_claude.sh     # ou instalar_codex.sh
python3 zotero-pesquisa-cientifica/scripts/auditar_biblioteca.py --colecao "Minha coleção"   # com o Zotero aberto
```
No Claude Code, na pasta do projeto: **«Bibliotecário, configurar o Zotero»** ou **«Bibliotecário, auditar minha biblioteca»**. No Codex: **`/bibliotecario auditar a coleção "Minha coleção"`**.

### Os três agentes juntos
Na mesma pasta de projeto, o **Metodólogo** (repositório `metodologia-pesquisa-cientifica`) decide o método, o **Orientador** (`ia-na-pesquisa-cientifica`) o uso de IA, e o **Bibliotecário** cuida da ferramenta onde as decisões dos dois deixam rastro: a busca importada com data, a triagem etiquetada, a leitura anotada com página, a citação que a lista reproduz. Os três compartilham `DECISOES.md` e `USO_DE_IA.csv`; cada um controla o próprio checklist.

## Como citar
MATIAS, J. P. M. *Zotero para pesquisa científica: passo a passo.* MirandasTech, v1.0, set. 2026. CC BY 4.0.

## Declaração de uso de IA
Escrito com assistência de IA (Claude, Anthropic) na estruturação, redação, scripts e automação das capturas. Versão do Zotero, requisitos, planos de armazenamento, atalhos, nomes dos estilos ABNT no repositório CSL e compatibilidade dos plugins conferidos nas fontes oficiais em 08/09/2026. O autor responde integralmente pelo conteúdo. Zotero é um projeto da Corporation for Digital Scholarship; este manual não tem vínculo com o projeto.
