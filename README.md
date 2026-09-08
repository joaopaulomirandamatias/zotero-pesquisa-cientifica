# Zotero para pesquisa científica: passo a passo (MirandasTech)

Manual em formato de slides (55) sobre o Zotero 10 para pós-graduação: instalar (programa, Connector, conta e sincronização), capturar (DOI/ISBN, Connector, PDF, importação RIS/BibTeX, «Encontrar texto completo»), organizar (coleções, etiquetas, pesquisas salvas, duplicados), ler e anotar (leitor integrado, destaques, nota a partir das anotações), citar (estilos CSL, estilo ABNT, plugin do Word/LibreOffice/Google Docs, cópia rápida, ZoteroBib), exportar e integrar (BibTeX, RIS, CSL JSON, Better BibTeX, LaTeX/Overleaf, Obsidian, ASReview/Rayyan, backup), colaborar (sincronização, WebDAV, grupos), plugins, erros comuns, checklist, fluxo completo de uma revisão, glossário com popovers e referências. Capturas de tela reais e datadas (08/09/2026) do Zotero 10.0.1 em pt-BR com uma biblioteca de exemplo de artigos de acesso aberto, e do site zotero.org.

**Manual on-line:** https://zotero.mirandastech.com.br/ · **PDF:** https://zotero.mirandastech.com.br/manual.pdf

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

## Automação: agente Bibliotecário e scripts

| Onde | O que faz |
|---|---|
| `.claude/agents/bibliotecario.md` | **Agente Bibliotecário**: guia a configuração passo a passo, controla `PROGRESSO_ZOTERO.md`, roda a auditoria e explica por que uma referência saiu errada. Encaminha decisões de método ao **Metodólogo** e de uso de IA ao **Orientador** |
| `.claude/skills/bibliotecario-zotero/` | checklist de configuração, tabela problema → causa → correção → slide, comandos |
| `scripts/auditar_biblioteca.py` | pela API local do Zotero (Configurações → Avançado → «Permitir que outros aplicativos…»), lista itens sem DOI, sem PDF, sem autor/ano, em CAIXA ALTA, capturados como página web e prováveis duplicados; só lê |
| `scripts/exportar_bbt.sh` | exporta uma coleção pelo Better BibTeX (`bibtex`, `biblatex`, `json`) sem abrir menus |
| `scripts/backup_zotero.sh` | backup datado da pasta de dados (recusa rodar com o Zotero aberto); mantém os 7 mais recentes |
| `scripts/instalar_skills.sh` | instala agente e skill em `~/.claude` |
| `.github/workflows/verificar.yml` | CI: integridade do deck, capturas referenciadas, scripts e estilos válidos |

### Começar em três comandos
```bash
git clone https://github.com/joaopaulomirandamatias/zotero-pesquisa-cientifica.git
bash zotero-pesquisa-cientifica/scripts/instalar_skills.sh
python3 zotero-pesquisa-cientifica/scripts/auditar_biblioteca.py --colecao "Minha coleção"   # com o Zotero aberto
```
No Claude Code, na pasta do projeto: **«Bibliotecário, configurar o Zotero»** ou **«Bibliotecário, auditar minha biblioteca»**.

### Os três agentes juntos
Na mesma pasta de projeto, o **Metodólogo** (repositório `metodologia-pesquisa-cientifica`) decide o método, o **Orientador** (`ia-na-pesquisa-cientifica`) o uso de IA, e o **Bibliotecário** cuida da ferramenta onde as decisões dos dois deixam rastro: a busca importada com data, a triagem etiquetada, a leitura anotada com página, a citação que a lista reproduz. Os três compartilham `DECISOES.md` e `USO_DE_IA.csv`; cada um controla o próprio checklist.

## Como citar
MATIAS, J. P. M. *Zotero para pesquisa científica: passo a passo.* MirandasTech, v1.0, set. 2026. CC BY 4.0.

## Declaração de uso de IA
Escrito com assistência de IA (Claude, Anthropic) na estruturação, redação, scripts e automação das capturas. Versão do Zotero, requisitos, planos de armazenamento, atalhos, nomes dos estilos ABNT no repositório CSL e compatibilidade dos plugins conferidos nas fontes oficiais em 08/09/2026. O autor responde integralmente pelo conteúdo. Zotero é um projeto da Corporation for Digital Scholarship; este manual não tem vínculo com o projeto.
