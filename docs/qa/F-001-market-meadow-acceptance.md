# F-001 Market Meadow P0 - Acceptance Record

**Status:** ACCEPTED FOR PROTOTYPE  
**Producer:** Codex /root  
**Date:** 2026-07-19

## Evidence summary

| Acceptance area | Evidence | Result |
|---|---|---|
| Data contract | F001-DATA.3 parses 14 columns and 10 unique IDs; starting state, capacities, recipes, rewards, and unlock cost match the functional source. | PASS |
| Complete loop | Deterministic Godot test completed plant -> grow -> harvest -> process -> collect -> order twice -> unlock. | PASS |
| Invalid interactions | The same test covers early harvest, insufficient materials, busy workshop, full inventory, locked plot, retained ripe crop, and visible feedback. | PASS |
| Input coverage | Center and edge hit checks cover a plot, workshop, and Market Cart. | PASS |
| Normal runtime | Isolated Vulkan launch exited 0 and loaded `town_main.tscn` plus all three prototype SVGs. | PASS |
| Visual state | [Initial runtime capture](../evidence/F-001-market-meadow-runtime.png) was rendered and visually reviewed at 720 x 1280. | PASS |
| Commercial boundary | Targeted scan found no Township, Playrix, Supercell, or protected-reference strings in runtime paths. All visuals are emoji or project-owned SVG placeholders. | PASS |

## Commands and outcomes

- Isolated import used the local Godot console executable with temporary `APPDATA`/`LOCALAPPDATA`, `--headless --import`, and a task-local log. It completed successfully.
- Deterministic test output: `TEST_PASS: Market Meadow normal loop, invalid states, CSV values, and hit regions verified.`
- Normal Vulkan launch used the same isolated environment and exited with code 0 after loading the main scene and its SVG resources.
- Runtime capture output: `CAPTURE_PASS: res://tmp/F-001-market-meadow/town-runtime.png`; the reviewed copy is stored under `docs/evidence/`.

## Known evidence boundary

The test suite exercises model transitions and hit regions deterministically. The archived screenshot shows the fresh interactive state; it is not a recording of the full two-order playthrough. The complete playthrough is proved by the deterministic behavior test above.
