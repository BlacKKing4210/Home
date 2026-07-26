# F-003 FARM.2 Playable Vertical Slice Acceptance

**Receipt:** F-003-FARM2-ENG-002  
**State:** CLOSED / ACCEPTED FOR PROTOTYPE  
**Date:** 2026-07-24  
**Owner:** Codex `/root`  
**Feature:** F-003 / F003-FARM.2  
**Source authorization:** `docs/receipts/F-003-FARM2-ENG-001.md`  
**Player-visible evidence:** `docs/evidence/F-003-FARM2/README.md`

## Outcome

The rejected fixed-card FARM.1 presentation has been replaced as the active main scene by an original, commercial-safe, large-town production foundation. The live Godot scene now presents a 720 x 1280 portrait town on an 1800 x 1700 draggable world with:

- 12 directly interactive crop plots and three configured crops;
- separate granary and storehouse pressure;
- chicken and cow feed/timer/explicit-collection routes;
- four original machines with input validation, queue limits, output-slot blocking and explicit collection;
- three atomic neighborhood requests and a seed-reserve-protected roadside market;
- 16 configured buildings, distant content, locked future factories and visible expansion capacity;
- 26 approved project-owned runtime textures promoted from ART-003 with unchanged per-file hashes;
- Chinese first-launch UI, English selection, preference persistence and reduced-motion selection;
- versioned saves, safe FARM.1 migration, bounded offline timer advancement and no offline auto-collection.

The implementation deliberately learns the genre's production-chain density and object-led interaction grammar without using commercial game art, names, maps, UI layouts, values, text, code, or proprietary content.

## Iteration record

### Iteration A — authoritative core and first world

- Added nine validated `f003_v2_*.csv` tables and cross-reference validation.
- Added isolated FARM.2 configuration, model, locale and save modules.
- Promoted five animal and 21 building/crop textures to the runtime package.
- Connected the main scene to the FARM.2 view and compatibility renderer.
- Produced the first real 720 x 1280 map capture.

### Iteration B — spatial breadth and object routes

- Added camera pan/clamps, a materially different far-world view, object hit regions and state badges.
- Added crop, machine, animal, request, market and settings context routes.
- Added versioned load/migration/offline behavior and language/reduced-motion persistence.
- Produced expanded-map and request-panel evidence.

### Iteration C — simultaneous production and acceptance polish

- Verified simultaneous crop, animal and machine timers.
- Added direct market exchange, clean default framing, full English settings evidence, touch-size targets and reduced-motion behavior.
- Ran a deterministic ten-minute economy simulation with a meaningful action available every second.
- Ran final real-renderer, headless, historical-scope and normal-startup regressions.

## Acceptance results

| Acceptance | Evidence | Result |
|---|---|---|
| Configuration authority | `farm2_config.gd`, nine CSVs, final FARM.2 log | PASS |
| Crop economy and seed protection | 12-plot cycle, full-granary atomic rejection, market reserve tests | PASS |
| Dual storage | granary/storehouse capacity tests and live HUD bars | PASS |
| Animal production | feed -> timer -> explicit collection; active-production capture | PASS |
| Machine queues | two-slot queue, one-time input deduction, blocked output and next-item start | PASS |
| Requests | failed atomic preflight, successful reward, refresh timer; request capture | PASS |
| Large navigable town | 1800 x 1700 CSV world, camera clamps, default and expanded captures | PASS |
| Runtime art | 5 animal + 21 building/crop PNGs; candidate/runtime mismatch count `0` | PASS |
| Locale/settings | Chinese default, English live/persisted, reduced motion; English capture | PASS |
| Save/interruption | schema 2 save/reload, safe legacy migration, bounded offline tick | PASS |
| Long-run guard | deterministic 600-second simulation | PASS |
| Main scene | normal launch, no test arguments, exit `0`, no script error | PASS |
| Historical regression | `tests/test_town_model.gd`, exit `0` | PASS |

## Final commands and logs

All commands used Godot `4.6.2.stable.official.71f334935`.

1. Real-renderer visual/interaction regression:
   - Compatibility OpenGL windowed run with `res://tests/test_farm2_scene.gd -- --farm2-capture`.
   - Log: `tmp/F-003-farm2-engineering/final-visual-regression.log`
   - Result: exit `0`, `TEST_PASS`.
2. FARM.2 full headless behavior regression:
   - Flags: `--headless --rendering-method gl_compatibility --rendering-driver opengl3 --audio-driver Dummy`.
   - Log: `tmp/F-003-farm2-engineering/final-headless-farm2.log`
   - Result: exit `0`, `TEST_PASS`.
3. FARM.1 scoped regression:
   - Script: `res://tests/test_town_model.gd`.
   - Log: `tmp/F-003-farm2-engineering/final-farm1-regression.log`
   - Result: exit `0`, `TEST_PASS`.
4. Normal main scene:
   - Same headless renderer flags, no test script or test arguments, `--quit-after 5`.
   - Log: `tmp/F-003-farm2-engineering/final-main-scene-smoke.log`
   - Result: exit `0`, no script error.

## Final implementation hashes

| File | SHA-256 |
|---|---|
| `project.godot` | `1419AEFC3B0A80174461BE73F23F6DA5B61D687E7AADE190B4A184DB00C69548` |
| `scenes/town_main.tscn` | `8260A49E85807CEB1C7D3F46DC5A140B246222C1A611EC566BF671CDE4483D3B` |
| `scripts/town/farm2_config.gd` | `EC2C5A07DDAEAA6CE4B126381E81FF910E6000FEDF7EED5792AD446DEFD2E73E` |
| `scripts/town/farm2_model.gd` | `0F802A368C4F758A36AB071F434616C447726F3262DC53C262E9FC902729B486` |
| `scripts/town/farm2_text.gd` | `5D15FA81F044E7A1EEC363BE1C5F695E677ACA99A1CA685104BEC2B225C429FC` |
| `scripts/town/farm2_save.gd` | `793A459DF51BE3D9137596E237EDC23ABCE556A726B4E7076FBFCA39D18AE87A` |
| `scripts/town/farm2_view.gd` | `8A1F004D0A70FA6DF182AACD8740A8CD9607CFA20731ADE3F63E0487EF7A23D2` |
| `tests/test_farm2_scene.gd` | `23A3B5869B1B03033B07A34076683E36F206C1B76138ADC9E4772BD5D9A2918C` |
| `assets/runtime/f003_farm2/runtime-manifest.json` | `C16B3CE0985A1379A5ED928E54308664F5283ADC3F7D7F633316106B7370AC86` |
| `assets/runtime/f003_farm2/source-split-manifest.json` | `24301875DE2305E562EC52668F3BB867B820F7BFD796B2555AC05729AB0D95ED` |

The nine final CSV hashes are recorded by path in the engineering audit output; all load and cross-reference validation passed. The seven historical FARM.1 files listed in `F-003-FARM2-ENG-001` retain their exact starting hashes.

## Scoped safety audit

- Historical FARM.1 scripts, tests and CSVs: seven of seven hashes unchanged.
- Candidate-to-runtime image comparison: 26 files, zero missing, zero hash mismatch.
- Active runtime/config/test scan for `assets/candidate`, `Township`, `Hay Day`, `Supercell`, and `Playrix`: no matches.
- The main scene references only `res://scripts/town/farm2_view.gd`.
- Existing Godot GUI processes and `.godot/` were not intentionally terminated, cleaned or repurposed.
- No F-004+ implementation, server work, deployment, monetization, online marketplace, rail or air-cargo feature was added under F-003.

## Closure decision

`ACCEPTED FOR PROTOTYPE`: F003-FARM.2 meets its formal behavior, UI/UE, runtime-art, large-world, configuration, persistence and evidence gates. Its shared implementation lock may be released.

This does not claim production release readiness. Android packaging, physical-device touch acceptance, commercial final art, telemetry backend, later districts, rail freight, sky cargo, cooperative systems and live operations remain separately gated work.
