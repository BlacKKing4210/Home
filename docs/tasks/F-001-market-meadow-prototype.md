# F-001 Market Meadow P0 - Implementation Contract

**Contract version:** F001-ENG-001  
**State:** COMPLETE - ACCEPTED FOR PROTOTYPE  
**Accountable owner:** Codex /root, Engineering Owner  
**Execution task:** `/root/f001_receipt`  
**Primary Skill:** `godot-feature-slice-implementation`  
**Required coordination:** `game-studio-orchestrator`, CityOfAnimals project adapter

## Goal

Deliver a locally playable, original CityOfAnimals P0 showing a complete Sunseed -> Grainleaf -> Meadow Loaf -> Market Cart -> fourth-plot loop, using only project-owned code, emoji, and original SVG placeholders.

## Read-only sources and baselines

| Source | Baseline | Access |
|---|---|---|
| `docs/features/F-001-market-meadow-p0.md` | F001-P0.1 | Read-only |
| `config/tables/f001_market_meadow.csv` | F001-DATA.3 | Read-only until refreshed authorization after updated receipt |
| `project.godot` | SHA-256 `99DA2D6BCC697F0CA10EDB5471D57EDE5A9E33BA567A305295D645A5B92AEC14` | Read-only unless producer separately authorizes a main-scene setting |
| Fisher UI reference | User-owned, inspected 2026-07-19 | Read-only; principles only, no direct UI/code/asset copying |

## Isolated implementation write scope after explicit authorization

- `scenes/town_main.tscn`
- `scripts/town/town_model.gd`
- `scripts/town/town_config.gd`
- `scripts/town/town_view.gd`
- `assets/prototype/*.svg`
- `tests/test_town_model.gd`
- `project.godot` only to set the application main scene, if needed

The producer remains the only writer for `docs/`, `PM/`, and the configuration source. Do not alter Fisher.

## Dependencies, locks, and safety

- Dependency: read-only receipt must identify the local Godot executable and any existing CityOfAnimals process before writes.
- Lock: no shared runtime writer is active. The assigned execution task owns every runtime path above while active.
- Temporary root: `tmp/F-001-market-meadow/`.
- Safety: do not use commercial reference assets, names, UI captures, or generated raster art. Emoji and original SVG placeholders only.

## Acceptance evidence

1. A deterministic headless test proves normal and invalid model transitions.
2. A normal Godot launch displays the portrait UI and can be interacted with using mouse input.
3. A screenshot or runtime capture shows the original UI with emoji/SVG placeholders and material/order state.
4. A targeted static check proves only authorized paths were changed; task temporary files are removed.

## First read-only receipt format

Report loaded Skills, source hashes, planned files, conflicts, existing process state, test executable, and `READY`, `CONCERNS`, or `NOT READY`. A receipt is not authorization to write.

The prior receipt and authorization are recorded in `docs/receipts/F-001-ENG-001.md`. The accepted F001-DATA.3 receipt is in `docs/receipts/F-001-ENG-002.md`; completion evidence and final hashes are in `docs/receipts/F-001-ENG-003.md`.
