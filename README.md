# claude-plugins

Marketplace personale di plugin per [Claude Code](https://code.claude.com).

## Plugin disponibili

### `software-wiki`

Mantieni una wiki di prodotto software che unisce guida utente e documentazione tecnica in un knowledge base markdown strutturato. Le **feature page** fanno da ponte fra le due viste, eliminando la duplicazione utente/tecnico.

Componenti:

- `software-wiki:conventions` — skill auto-triggered con lo schema della wiki
- `/software-wiki:bootstrap [nome-prodotto]` — inizializza una wiki nuova
- `/software-wiki:collect [--move] [--include-readme] [path]` — raccoglie file `.md` sparsi in `raw/`
- `/software-wiki:ingest <source>` — ingest interattivo di una fonte da `raw/`

Doc completa in [`plugins/software-wiki/README.md`](plugins/software-wiki/README.md).

## Installazione

Da Claude Code, una volta sola:

```text
/plugin marketplace add lucapolignone/software-wiki
/plugin install software-wiki@polignone-plugins
```

## Test locale

Prima di pushare, da dentro la cartella del repo:

```bash
# test del plugin senza marketplace
claude --plugin-dir ./plugins/software-wiki

# oppure aggiungi il marketplace locale
/plugin marketplace add ./
/plugin install software-wiki@polignone-plugins
```

## Aggiornamento

Per pubblicare una nuova versione: bump del campo `version` in `plugins/software-wiki/.claude-plugin/plugin.json`, commit e push. Gli utenti del marketplace ricevono l'update con `/plugin marketplace update`.

Se ometti `version`, ogni commit conta come versione nuova (semplice ma poco controllato — utile durante lo sviluppo, da fissare prima di considerare il plugin "stabile").

## Sviluppo

```bash
# Validazione del marketplace e del plugin
claude plugin validate .

# Test locale
claude --plugin-dir ./plugins/software-wiki

# Reload dopo modifiche durante una sessione Claude Code
/reload-plugins
```

Per il pattern di crescita futuro (aggiunta di hook, subagent dedicato, MCP per ricerca sulla wiki) vedi le note finali in `plugins/software-wiki/README.md`.

## Licenza

MIT — vedi [LICENSE](LICENSE).
