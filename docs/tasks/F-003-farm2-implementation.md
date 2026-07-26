# F-003 FARM.2 Godot Vertical Slice Implementation

**Task ID:** F003-FARM2-ENG-IMPL  
**Status:** COMPLETED — ITERATIONS A/B/C ACCEPTED FOR PROTOTYPE  
**Owner:** Codex `/root` acting as engineering owner  
**Feature:** F-003 / F003-FARM.2  
**Receipt:** `docs/receipts/F-003-FARM2-ENG-001.md`

## Goal

Replace the rejected fixed-card FARM.1 prototype with a large, draggable, 45-degree animal-town production foundation whose primary information is conveyed by fields, animals, buildings, products, timers and direct object interaction.

## Inputs

- `docs/features/F-003-farm-town-foundation-v2.md`
- `output/documents/F003-FARM.2/CityOfAnimals_F003_Farm_Town_Foundation_V2.docx`
- `output/pdf/CityOfAnimals_F003_Farm_Town_Foundation_V2.pdf`
- Figma file `uU2Oek5RqFb19CPoGl48lC`, page `CityOfAnimals F003 Farm Foundation V2`
- `output/art/ART-003-FARM2/split-manifest.json`

## Dependencies and conflict scope

- Design, Figma, ART-003 preparation and formal document gates are closed.
- FARM.1 is terminal archived and its old runtime lock is released.
- This task exclusively owns the write set in `F-003-FARM2-ENG-001`.
- `.godot/` and the three pre-existing Godot GUI processes are not touched.

## Module boundaries

### Configuration database

- Active script: `scripts/town/farm2_config.gd`.
- Owns nine `f003_v2_*.csv` schemas, required columns, stable IDs and cross-reference validation.
- Must not own gameplay state or player-visible hardcoded text.

### Authoritative town model

- Active script: `scripts/town/farm2_model.gd`.
- Owns inventory, dual capacity, plots, animals, machine queues/output slots, requests, market, rewards and time transitions.
- All mutations preflight then commit atomically.
- Must not read input events or draw UI.

### Save/preferences

- Active scripts: `scripts/town/farm2_save.gd` and `scripts/town/farm2_text.gd`.
- Owns versioned serialization, migration, offline elapsed time and settings persistence.
- Must not auto-collect products or bypass model preconditions.

### Town view

- Active script: `scripts/town/farm2_view.gd`.
- Owns 720 x 1280 presentation, world camera, hit testing, panels, feedback, texture display and reduced-motion presentation.
- Must send intent to the model; it must not change inventory or timers directly.

### Runtime asset package

- Owns copied, approved ART-003 files and a runtime manifest.
- Candidate paths remain non-runtime and are never loaded directly.

## Iteration acceptance

### Iteration A

- Model tests prove crop, storage, animals, machines, requests and market behavior.
- Main scene parses and starts.
- Large world contains at least 18 identifiable objects and supports camera drag.
- Runtime loads promoted approved assets only.

### Iteration B

- Object interactions expose the intended actions and all blocked states.
- Save/reload, offline progression, language persistence and old-save migration pass.
- 720 x 1280 scene evidence shows a world larger than one screen.

### Iteration C

- Reduced-motion fallback, procedural state feedback, touch affordances, safe areas and text wrapping pass.
- Deterministic ten-minute simulation never reaches an unrecoverable no-action state.
- Normal mode, explicit test mode, rendered evidence and final authorized-file audit pass.

## Verification commands

Use the Godot 4.6.2 console executable outside the sandbox with:

```text
--headless --rendering-method gl_compatibility --rendering-driver opengl3 --audio-driver Dummy
```

Run model and scene tests separately. Run normal mode separately with no test flags or automatic acceptance flow. Record logs, screenshots and hashes under the authorized evidence/output roots.

## Cleanup

Remove temporary user data, one-off capture drivers, intermediate screenshots and empty task directories after evidence is recorded. Do not remove historical FARM.1 sources or evidence.

## Closure

- Completion receipt: `docs/receipts/F-003-FARM2-ENG-002.md`
- Player-visible evidence index: `docs/evidence/F-003-FARM2/README.md`
- Completed on: 2026-07-24
- Result: the active main scene now uses the FARM.2 modules, a draggable 1800 x 1700 town, 12 plots, 16 configured buildings, 26 promoted runtime textures, and the accepted crop/animal/machine/request/market/settings routes.
- Boundary: this is an accepted playable prototype vertical slice, not a claim that the later rail, air-cargo, cooperative, live-ops, monetization, or release-package roadmap is implemented.
