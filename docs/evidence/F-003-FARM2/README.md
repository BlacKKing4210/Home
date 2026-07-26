# F-003 FARM.2 Player-visible and Behavior Evidence

**Feature:** F-003 / F003-FARM.2  
**Evidence date:** 2026-07-24  
**Engine:** Godot `4.6.2.stable.official.71f334935`  
**Canvas:** 720 x 1280 portrait  
**Completion receipt:** `docs/receipts/F-003-FARM2-ENG-002.md`

## Player-visible captures

| Iteration | Evidence | What it proves |
|---|---|---|
| A | `output/runtime/F003-FARM2/iteration-a-main-map.png` | Default portrait HUD, 12-field starter district, storage, buildings, direct state badges and bottom navigation. |
| B | `output/runtime/F003-FARM2/iteration-b-expanded-map.png` | Camera reaches a materially different part of the 1800 x 1700 world containing more factories, animals, locked content and the river edge. |
| B | `output/runtime/F003-FARM2/iteration-b-requests-panel.png` | Three simultaneous original requests, multi-item requirements and configured rewards in the live UI. |
| C | `output/runtime/F003-FARM2/iteration-c-active-production.png` | Simultaneous crop, animal and machine timers with promoted runtime art. |
| C | `output/runtime/F003-FARM2/iteration-c-settings-en.png` | Live English selection, persistent-language UI, reduced-motion setting and English navigation labels. |

All five files are real Godot OpenGL viewport captures at exactly 720 x 1280. They are not planning mockups.

## Behavior logs

| Evidence | Result |
|---|---|
| `tmp/F-003-farm2-engineering/final-visual-regression.log` | `TEST_PASS`; real OpenGL renderer, five screenshots, all behavior routes. |
| `tmp/F-003-farm2-engineering/final-headless-farm2.log` | `TEST_PASS`; FARM.2 configuration, economy, storage, production, persistence, locale, simulation, view and interaction routes. |
| `tmp/F-003-farm2-engineering/final-farm1-regression.log` | `TEST_PASS`; historical FARM.1 scoped regression remains intact. |
| `tmp/F-003-farm2-engineering/final-main-scene-smoke.log` | Exit `0`; normal main scene, no test arguments. |

## Evidence hashes

| File | SHA-256 |
|---|---|
| `iteration-a-main-map.png` | `6E6DAA3258B64B28A1C826C78CEA50F0579EFE5531BE993E4C6FC80B57FA0D61` |
| `iteration-b-expanded-map.png` | `CF116C2C14D77BD287B96E3868237C37EEB64135118A9AD72321639EA5A967FD` |
| `iteration-b-requests-panel.png` | `8EAB5FBE97A893816D42C35000BF9A16FD8B0F89235952D436987A72EAFF351A` |
| `iteration-c-active-production.png` | `3F245EA42C47EB1A3C6AFCC5FF32B5742833056732C3330C9F355AF77CB059F4` |
| `iteration-c-settings-en.png` | `C3D9D135173BD3BA131E02589B1F686576571BBD6F5C37F3D4F4CD213715C3C6` |
| `final-visual-regression.log` | `961934DB0C3C7FF8200E4B80318F5B3CB85388B174E95195451EE9C2A1366A84` |
| `final-headless-farm2.log` | `777B8CDA7220550BDD83F8DE1F80B6F9693A4974A150D5B6AC48CF75A927EFA2` |
| `final-farm1-regression.log` | `62E6785BDAC0B13F323CC03C6CA0C309B60E23A2E183A1CA1EB717EC1CBECB5C` |
| `final-main-scene-smoke.log` | `DA76A36A586EC310AE98A6BF8844AB87166457610861A810027A91D273CBB93F` |

## Boundary

The capture harness uses a fixed 720 x 1280 Godot `SubViewport` and sends the same player-intent routes as the live view. It proves rendered layout and behavior integration on the Windows OpenGL runtime. It does not claim Android packaging, physical-device touch, storefront, public deployment, or later-roadmap completion.
