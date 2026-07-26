# F-002 Farmboard Visual Language - Acceptance Record

**Status:** ACCEPTED FOR PROTOTYPE  
**Acceptance owner:** Codex /root  
**Date:** 2026-07-19

## Acceptance mapping

| Requirement | Evidence | Result |
|---|---|---|
| Original farm-like play canvas replaces text cards | Reviewed 720 x 1280 runtime capture: `docs/evidence/F-002-farmboard-runtime.png` | Pass |
| Existing loop remains playable | `tests/test_town_model.gd` passed the crop, bakery, delivery, second delivery, and fourth-field-unlock loop | Pass |
| Field, bakery, and van states are visually distinct | Runtime capture shows seed fields, a locked field, a bakery baking timer, a delivery van, item/reward bubbles, counts, and compact state feedback | Pass |
| Chinese default and English settings option persist | Headless test reset preferences, confirmed `zh-CN` default, changed to `en`, reloaded it, and reset to Chinese; runtime capture script opened the settings tray and switched both directions | Pass |
| No protected-reference runtime material | F-001 numeric CSV hash is unchanged; runtime scan of F-002 scripts/config found no Hay Day, Township, Supercell, Playrix, URL, or external asset reference | Pass |

## Runtime evidence

- Deterministic command: Godot 4.6.2 console, `--headless --path D:\AI\CityOfAnimals --script res://tests/test_town_model.gd`.
- Result: `TEST_PASS: Market Meadow normal loop, invalid states, CSV values, and hit regions verified.`
- Real interaction capture: a normal D3D12 scene run used pointer input on visible fields, the bakery, settings gear, and both language buttons before saving the reviewed image.
- Normal main-scene smoke: a separate normal runtime launch with `--quit-after 180` exited cleanly and loaded D3D12 Forward+ on the NVIDIA RTX 4060 Laptop GPU.

## Known prototype boundary

The Farmboard uses original vector primitives rather than final illustration assets. It is intentionally a development visual language, and its geometry may be replaced only through a separately approved art task.
