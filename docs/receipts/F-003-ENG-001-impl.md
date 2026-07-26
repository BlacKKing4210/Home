# F-003 Implementation Evidence - Capture Pending

**Receipt:** F003-ENG-001-IMPL  
**State:** IMPLEMENTED / NOT ACCEPTED  
**Verified:** 2026-07-20  
**Accountable producer and engineering owner:** Codex /root

## Delivered behavior

- `TownConfig` now merges the sealed F-001 numeric source with F003-DATA.1 while retaining duplicate-ID and column validation.
- `TownModel` generalizes production to data-driven building state. `crumbworks`, `willow_pen`, and `threadmill` each use `idle -> busy -> ready -> collect` and localized failure feedback.
- The Farmboard now exposes recognisable original vector objects for bakery, Willow Pen, Threadmill, and a three-ticket order board. Tickets fulfill the existing loaf order plus Fleece Bundle and Yarn Crate independently.
- The footer shows Grainleaf, Meadow Loaf, Soft Fleece, and Yarn Roll inventory. All F-003 player-visible labels and feedback come from `f003_town_ui.csv` and continue to use the accepted Chinese-default/English-persistent setting.
- `project.godot`, project workflow/profile, and the selected common workflow now record portrait 720 x 1280 as the default mobile presentation target.

## Behavior evidence

| Acceptance area | Evidence |
|---|---|
| Data and locale integration | `TownConfig.load_default()` and `TownText.new()` parsed both F-003 CSVs in the passing deterministic test. Cross-reference scan reported `CONTENT_ROWS=16`, `BAD_ITEM_REFS=` and `MISSING_LOCALE_KEYS=`. |
| Original-loop regression | The passing test exercised crop -> bakery -> loaf order -> fourth-plot unlock without changing F-001 values. |
| New chain | The passing test exercised Grainleaf -> Willow Pen -> two Soft Fleece -> Threadmill -> Yarn Roll -> Yarn Crate. |
| Three order types | The passing test fulfilled Market Cart, Fleece Bundle, and Yarn Crate, with configured rewards. |
| Failure and direct interaction | The passing test covered missing fleece, busy Willow Pen, full fleece storage, field edges, three building edges, three order-ticket edges, Settings, and locale persistence. |
| Normal startup | `Godot_v4.6.2-stable_win64_console.exe --resolution 720x1280 --quit-after 3` exited 0 and reported the NVIDIA D3D12 renderer without script errors. |
| Safety | F-001 config SHA-256 remains `75D921EE2C185E2FE75247C088CE1AD2B963727A05D61D17AB44F580D4670F34`; F-002 locale SHA-256 remains `97AAAC58929A8A3193CD6041AD840C501A16E1A7ECFAD978312409FF1784D3E4`; F-003 runtime/config files contain no `Township`, `Hay Day`, `Supercell`, `Playrix`, or external URL. |

## Final scoped hashes

| Path | SHA-256 |
|---|---|
| `project.godot` | `BCEDB08D43E0D9B6888191F2D81E3BE5362A5357996EFB7749AE0BC4DAB27158` |
| `scripts/town/town_config.gd` | `6AD636652E882AE8FB6EF1B83C14A697D1C761B4CDF7F6BDF34EC0DF90095485` |
| `scripts/town/town_model.gd` | `8476A5BA67739FCAA07A5DE0E7C158A9C2DC88A54CCFEA349BABD418893CABC7` |
| `scripts/town/town_text.gd` | `0B75E5227C01FA0213382BBDDFEFFB06E6E0B98F30CDE2FCD79935D0A0DA1B0A` |
| `scripts/town/town_view.gd` | `940879891927FC072D4C8E6799719AB1556FAFB4A58878B281B710D51FF3E0E2` |
| `config/tables/f003_farm_content.csv` | `7E246FA23115B02031B31E2588AFE323CF45ECCFDD48D84D5FECF79372C90B40` |
| `config/tables/f003_town_ui.csv` | `9787359252CD7F6DC10012D6BD343B21298B873CFCD9153E22858B15F71C8E8C` |
| `tests/test_town_model.gd` | `CA7D277C3BE4F60767C9F6242580520515B57B97887ABB36B38E0A3CF980995A` |

`scenes/town_main.tscn`, F-001 numeric data, and F-002 locale data are unchanged. The task-local visual capture was not saved because it was black/blocked and would not be valid player-visible evidence.

## Remaining acceptance blocker

The deterministic model test and normal startup passed. A Windows Graphics Capture attempt for the separately launched `CityOfAnimals (DEBUG)` window returned a black frame while an existing `Godot_v4.6.2-stable_win64.exe - Application Error` dialog was present and blocked target activation. The dialog was not touched because its ownership is not established. Capture F-003 again in a clean Godot desktop state; then record `docs/evidence/F-003-herd-orders-runtime.png`, run the final visual review, and create `F-003-ENG-002.md` before accepting or releasing the lock.
