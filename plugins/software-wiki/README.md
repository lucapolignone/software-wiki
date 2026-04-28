# software-wiki

Plugin per Claude Code che mantiene una wiki di prodotto software unificando guida utente e documentazione tecnica.

## Cosa fa

- **Schema condiviso** per organizzare doc utente e doc tecnica nello stesso repo, con le **feature page come ponte unico** fra le due viste (niente duplicazione).
- **Ingest interattivo** di fonti markdown (spec, RFC, release notes, transcript di meeting): Claude legge la fonte, discute i takeaway con te, aggiorna le pagine giuste, marca le contraddizioni.
- **Lint** della wiki (link rotti, pagine orfane, contraddizioni aperte, frontmatter incompleto, status incoerenti).
- **Bootstrap** veloce: un comando crea tutta la struttura e il `CLAUDE.md` di default.

## Componenti

| Componente | Tipo | Trigger |
|---|---|---|
| `software-wiki:conventions` | Skill auto-triggered | Si carica quando la conversazione menziona wiki, doc di prodotto, ingest, feature page, ADR |
| `/software-wiki:bootstrap [nome-prodotto]` | Comando esplicito | Crea la struttura `raw/` + `wiki/` + `CLAUDE.md` |
| `/software-wiki:collect [--move] [--include-readme] [path]` | Comando esplicito | Raccoglie file `.md` sparsi in `raw/`, sicuro by default |
| `/software-wiki:ingest <source>` | Comando esplicito | Ingestisce una fonte da `raw/` seguendo il workflow |

## Quickstart

```bash
# Test locale senza installazione
claude --plugin-dir ./software-wiki

# Dentro Claude Code, in un repo nuovo:
/software-wiki:bootstrap "Nome del Prodotto"

# Quando hai fonti sparse da raccogliere:
/software-wiki:collect ./docs

# Per ingestire una fonte:
/software-wiki:ingest spec-export-v3.2
```

## Schema della wiki (default)

```
raw/                      # Fonti immutabili
wiki/
├── index.md              # Catalogo (leggere per primo a ogni query)
├── log.md                # Append-only
├── overview.md           # Sintesi prodotto
├── glossary.md
├── features/             # ⭐ PONTE utente↔tecnico
├── user/{tasks,concepts,reference,troubleshooting}/
├── tech/
│   ├── architecture.md
│   └── {components,apis,data-models,infra,runbooks}/
├── decisions/            # ADR immutabili
└── sources/              # Una pagina per fonte ingestita
CLAUDE.md                 # Schema completo (caricato automaticamente da Claude Code)
```

Lo schema completo (frontmatter, workflow ingest/query/lint, anti-pattern) è in `skills/conventions/assets/CLAUDE.md`. Viene copiato in radice del progetto al bootstrap, e da quel momento il `CLAUDE.md` del progetto è la fonte di verità (puoi personalizzarlo: il plugin rispetta le tue modifiche).

## Sicurezza in `/software-wiki:collect`

Il comando esclude **sempre** dalla scansione:
- `wiki/` (la wiki stessa)
- `raw/` (già destinazione)
- `CLAUDE.md` a qualsiasi livello
- `.git/`, `node_modules/`, `.obsidian/`, `dist/`, `build/`, dotfile

Default è **copia**, non spostamento. Mostra sempre la lista candidati prima di toccare i file e aspetta conferma esplicita.

## Personalizzazione

Dopo il bootstrap, modifica il `CLAUDE.md` del progetto per:
- Aggiungere sotto-cartelle `tech/` (es. `tech/protocols/`, `tech/security/`).
- Definire status feature custom (es. `internal-only`, `private-beta`).
- Rendere `owners` obbligatorio anche per feature.
- Aggiungere frontmatter di dominio (es. `compliance: [gdpr, soc2]`).

Logga il cambio come `refactor` in `wiki/log.md`.
