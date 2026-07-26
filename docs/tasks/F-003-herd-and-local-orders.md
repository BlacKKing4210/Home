# F-003 Herd and Local Orders - Implementation Contract

**Contract version:** F003-ENG-001  
**State:** AUTHORIZED FOR IMPLEMENTATION  
**Accountable owner:** Codex /root, Engineering Owner  
**Execution task:** Current producer session; no sub-agent is authorized  
**Primary Skill:** `godot-feature-slice-implementation`  
**Required coordination:** CityOfAnimals project adapter, `game-studio-orchestrator`, `game-system-delivery-pipeline`, `ui-design-priority`

## Goal

Deliver an original, visual 720 x 1280 farm loop: Grainleaf can feed the Willow Pen, Soft Fleece can feed the Threadmill, and three local order tickets can independently pay rewards. Preserve the F-001 crop/bakery/field loop and F-002 localization contract.

## Approved sources

| Source | Version | Access |
|---|---|---|
| `docs/features/F-003-herd-and-local-orders.md` | F003-FARM.1 | Read-only after authorization |
| `config/tables/f003_farm_content.csv` | F003-DATA.1 | F-003 runtime numeric source |
| `config/tables/f003_town_ui.csv` | F003-UI.1 | F-003 locale source |
| `config/tables/f001_market_meadow.csv` | F001-DATA.3 | Read-only sealed source |
| `config/tables/f002_town_ui.csv` | F002-UI.1 | Read-only sealed locale source |
| `docs/WORKFLOW.md` and `docs/project_profile.yaml` | WORKFLOW-1 / schema 1 | Mobile presentation source |

## Baselines and runtime

| Path | Starting SHA-256 |
|---|---|
| `project.godot` | `BCEDB08D43E0D9B6888191F2D81E3BE5362A5357996EFB7749AE0BC4DAB27158` |
| `scenes/town_main.tscn` | `DB0969FE8CA74CE2128D4B2D775DABB803643DBDAD0DB0C722AE6B9BF9ED8386` |
| `scripts/town/town_config.gd` | `E327A67CE325739959B19FA451D0B2ABD537371EEEDE88C9A9BC7FB08C4E48E0` |
| `scripts/town/town_model.gd` | `E08983850A4406BE8F9F21706002D8808AF287F02266EAE09AD5A96CAFD7CA29` |
| `scripts/town/town_text.gd` | `037DC9772B5D941E42DFC3F6582C5CD32874D68240969673077DB151129AEF9F` |
| `scripts/town/town_view.gd` | `D6B42292C73A682EDA799C33BAC09274DEDA795AAF7AF1054988C2A0C65B12E6` |
| `tests/test_town_model.gd` | `B909C2533239C22AD2FAF0276AC76657E2A6C7D71D8D29BB223287D42F46C922` |
| `config/tables/f001_market_meadow.csv` | `75D921EE2C185E2FE75247C088CE1AD2B963727A05D61D17AB44F580D4670F34` |
| `config/tables/f002_town_ui.csv` | `97AAAC58929A8A3193CD6041AD840C501A16E1A7ECFAD978312409FF1784D3E4` |
| `config/tables/f003_farm_content.csv` | `7E246FA23115B02031B31E2588AFE323CF45ECCFDD48D84D5FECF79372C90B40` |
| `config/tables/f003_town_ui.csv` | `9787359252CD7F6DC10012D6BD343B21298B873CFCD9153E22858B15F71C8E8C` |

- Runtime project: `D:\AI\CityOfAnimals`.
- Stable engine executable: `D:\Work\godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe`.
- Read-only process snapshot: no `Godot*` or `CityOfAnimals*` process was found. Never terminate a user process.
- Temporary root: `tmp/F-003-herd-orders/`; retain only reviewed evidence under `docs/evidence/`.

## Isolated write scope

- `project.godot`
- `scripts/town/town_config.gd`
- `scripts/town/town_model.gd`
- `scripts/town/town_text.gd`
- `scripts/town/town_view.gd`
- `config/tables/f003_farm_content.csv`
- `config/tables/f003_town_ui.csv`
- `tests/test_town_model.gd`
- `docs/evidence/F-003-herd-orders-runtime.png`
- F-003 receipt and producer coordination files owned by the producer

## Forbidden changes

- `config/tables/f001_market_meadow.csv`, `config/tables/f002_town_ui.csv`, and `scenes/town_main.tscn`.
- F-001 crop/bakery/loaf/field numbers, F-002 language persistence behavior, commercial-reference assets or terms, external images, generated raster art, train/rail code, air-cargo code, new currency, save progression, or network code.

## Acceptance evidence

1. Headless test proves the old bread loop and plot unlock, the new Grainleaf -> Soft Fleece -> Yarn Roll loop, all three local orders, lack-of-input, busy, full-inventory, and direct hit centres/edges.
2. Normal isolated Godot launch renders the full Farmboard at 720 x 1280 without script errors or a test-only state.
3. Real interaction evidence shows each new production object transition and one new order completion through the normal UI path.
4. A reviewed 720 x 1280 screenshot shows original project-owned vector treatment for fields, bakery, Willow Pen, Threadmill, order tickets, and delivery van.
5. Static scans, config parsing, and final hashes prove sealed F-001/F-002 data stayed unchanged and changed runtime files contain no protected commercial-reference terms or external asset paths.

## Close conditions

Record completion in `docs/receipts/F-003-ENG-002.md`, release shared locks, update the matrix and handoff, keep F-004/F-005 queued only, and remove all task-local temporary scripts, previews, logs, and test preferences.
