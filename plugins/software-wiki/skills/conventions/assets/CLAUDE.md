# CLAUDE.md — Wiki di prodotto software

Mantieni una wiki che unisce guida utente e doc tecnica. L'utente cura le fonti e fa domande; tu scrivi e mantieni. Aggiorna questo file quando emergono pattern (logga come `refactor`).

## Struttura

Tre directory: `raw/` (fonti immutabili, solo lettura) · `wiki/` (gestita da te) · `CLAUDE.md`.

```
wiki/
├── index.md             # Catalogo. LEGGERE PER PRIMO ad ogni query.
├── log.md               # Append-only. Formato: ## [YYYY-MM-DD] <tipo> | <oggetto>
├── overview.md          # Sintesi prodotto. Rivedere ogni ~10 ingest.
├── glossary.md
├── features/            # ⭐ PONTE utente↔tecnico — vedi sotto
├── user/{tasks,concepts,reference,troubleshooting}/
├── tech/
│   ├── architecture.md
│   └── {components,apis,data-models,infra,runbooks}/
├── decisions/           # ADR NNNN-titolo.md, IMMUTABILI (supersede, non modificare)
└── sources/             # Una pagina per fonte ingestita
```

`kebab-case`, link `[[wikilink]]`. Una pagina = un concetto. >400 righe → spezza.
Tipi log: `ingest`, `query`, `lint`, `refactor`, `decision`.

## Le feature sono il ponte (regola centrale)

**Una sola pagina canonica per feature in `features/`.** Tasks e components linkano lì, mai viceversa — evita divergenza utente/tecnico.

```markdown
---
type: feature
status: stable|beta|experimental|deprecated|removed
sources: [[...]]
last_updated: YYYY-MM-DD
---
# Nome
Riassunto 2-3 frasi.

## 👤 Vista utente
Scenari, posizione UI/CLI, limiti. Link a [[user/tasks/...]].

## ⚙️ Vista tecnica
[[tech/components/...]], [[tech/apis/...]], [[tech/data-models/...]], [[decisions/...]], [[tech/runbooks/...]].

## Storia
- vX.Y (data): cambiamento ([[sources/...]])

## Domande aperte
- [ ] ...
```

## Frontmatter

Universali su ogni pagina: `type`, `last_updated`. Aggiunte per tipo:

| Tipo            | Aggiungi                                                    |
|-----------------|-------------------------------------------------------------|
| `feature`       | `status`, `sources`                                         |
| `user-task`     | `feature`                                                   |
| `tech-component`| `status`, `owners`, `sources`                               |
| `api`           | `version`, `status`, `sources`                              |
| `decision`      | `status` (proposed/accepted/superseded), `date` invece di `last_updated` |
| `source`        | `kind`, `ingested_on`, `original_path` invece di `last_updated` |

## Workflow: ingest

1. Leggi fonte da `raw/`.
2. **Discuti 3-6 takeaway con l'utente prima di scrivere.** Chiedi cosa enfatizzare.
3. Crea `sources/<slug>.md`.
4. Aggiorna in ordine: feature(s) → component/API → concept/glossary → eventuale ADR nuovo.
5. **Contraddizioni: NON sovrascrivere.** Aggiungi `> ⚠️ Contraddizione` con entrambe versioni e fonti. Logga.
6. Aggiorna `index.md` per pagine nuove.
7. Append a `log.md`.
8. Riepiloga all'utente.

>20 pagine toccate → proponi di spezzare la fonte.

## Workflow: query

1. **Leggi `index.md` per primo.**
2. Leggi candidate (parti da `features/` e `overview.md` per domande ampie).
3. Cita esplicitamente: `secondo [[features/...]] …`.
4. Sintesi nuova/comparazione/mappa → **proponi di filearla**, non perderla in chat.
5. Info mancanti: dillo, suggerisci fonti o lint.
6. Append a `log.md`.

Output: md, tabella, Mermaid, checklist, runbook.

## Workflow: lint (su richiesta)

**Proponi fix, non correggere senza conferma.**

1. Link rotti.
2. Pagine orfane (escluso index/log).
3. `⚠️ Contraddizione` aperti.
4. Stale: `last_updated` anteriore alla fonte più recente che la cita.
5. Concetti ricorrenti senza pagina propria.
6. Feature senza link a component (e viceversa).
7. Frontmatter incompleto.
8. Status incoerenti (es. feature `stable` su component `experimental`).
9. `## Domande aperte` aperte → suggerisci cosa investigare.

## Convenzioni

- `user/tasks/`: imperativo. Resto: terza persona neutra.
- Mai duplicare, sempre linkare.
- Citazioni brevi e virgolettate con link a `sources/`. Default: parafrasare.
- Date ISO. Versioni `vX.Y`. Endpoint `METHOD /path`. Path/codice in `monospace`.
- Diagrammi: Mermaid inline; SVG in `wiki/assets/` se serve.

## Anti-pattern

- ❌ Duplicare contenuto fra `user/` e `tech/` invece di centralizzare in `features/`.
- ❌ Aggiornare pagina senza toccare `last_updated`/`sources`.
- ❌ Cancellare contenuto contraddittorio invece di marcarlo.
- ❌ Modificare ADR esistenti (supersede, non riscrivere).
- ❌ Toccare `raw/`.
- ❌ Rispondere senza leggere `index.md`.
- ❌ Ingestire più fonti senza confermare i takeaway.
