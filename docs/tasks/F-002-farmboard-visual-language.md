# F-002 Farmboard Visual Language - Implementation Contract

**Contract version:** F002-ENG-001  
**State:** COMPLETE - ACCEPTED FOR PROTOTYPE  
**Accountable owner:** Codex /root, Engineering Owner  
**Execution task:** Current producer session; no sub-agent is authorized  
**Primary Skill:** `godot-feature-slice-implementation`  
**Required coordination:** CityOfAnimals project adapter, `game-studio-orchestrator`, `ui-design-priority`

## Goal

Deliver an original vector Farmboard that communicates the existing Market Meadow loop primarily through fields, a bakery, delivery van, item icons, counts, and short contextual feedback. Add the mandated `zh-CN` default and selectable persistent English language setting without changing F-001 economy or progression behavior.

## Approved sources

| Source | Version | Access |
|---|---|---|
| `docs/features/F-002-farmboard-visual-language.md` | F002-VIS.1 | Read-only after authorization |
| `config/tables/f001_market_meadow.csv` | F001-DATA.3 | Read-only; numeric behavior must not change |
| `config/tables/f002_town_ui.csv` | F002-UI.1 | Runtime language source |
| `docs/WORKFLOW.md` | WORKFLOW-1 | Read-only |
| `docs/project_profile.yaml` | schema 1 | Read-only |

## Baselines and runtime

| Path | Starting SHA-256 |
|---|---|
| `scenes/town_main.tscn` | `DB0969FE8CA74CE2128D4B2D775DABB803643DBDAD0DB0C722AE6B9BF9ED8386` |
| `scripts/town/town_model.gd` | `EEAE8941E9F75CBE87AC7D32657EAB28230A9F44A987082586A7F9310A34FEC2` |
| `scripts/town/town_view.gd` | `84B859C2210A0D524B8236135C3C9D8E1B702FFDEFA9F66748E41D50E87EA4EB` |
| `tests/test_town_model.gd` | `D0E338E722520A2855B7551CCD87F64B4731A3CBD9D1B9510B85258B30A2C3B2` |
| `project.godot` | `BA80364D9DE21B5F285F4D1DB9161726486BB3CB2EAE8A05C5A17776DD6B922A` |

- Runtime project: `D:\AI\CityOfAnimals`.
- Stable engine executable: `D:\Work\godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe`.
- Existing Godot process snapshot was empty during the F-002 receipt. Never terminate user processes.
- Temporary root: `tmp/F-002-farmboard/`; retain only the reviewed final evidence under `docs/evidence/`.

## Isolated write scope after authorization

- `scripts/town/town_model.gd`
- `scripts/town/town_view.gd`
- `scripts/town/town_text.gd` (new)
- `config/tables/f002_town_ui.csv`
- `tests/test_town_model.gd`
- `docs/evidence/F-002-farmboard-runtime.png`
- completion receipt and project coordination files owned by the producer

## Forbidden changes

- `config/tables/f001_market_meadow.csv`, `scenes/town_main.tscn`, and `project.godot`.
- F-001 economic rules, timers, capacities, recipes, plot count, new gameplay systems, commercial-reference assets or strings, external art, generated raster art, and Fisher source files.

## Acceptance evidence

1. Deterministic headless test proves the F-001 loop, invalid states, F-002 language catalog, locale persistence, and centre/edge hit targets for all visible world objects.
2. Normal isolated Godot launch renders the Farmboard without script errors and does not enter a test state.
3. Real interaction evidence shows visual transitions for a field, bakery, and delivery van, plus a working language selection.
4. A reviewed 720 x 1280 screenshot shows the original Farmboard using project-owned vector/placeholder visuals.
5. Static scans and final hashes prove F-001 numeric data remains untouched and changed runtime files contain no protected-reference terms or external asset paths.

## Read-only receipt and authorization

The read-only receipt is `docs/receipts/F-002-ENG-001.md`. Completion acceptance, evidence, and final hashes are recorded in `docs/receipts/F-002-ENG-002.md`.
