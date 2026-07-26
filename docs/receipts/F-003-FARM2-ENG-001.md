# F-003 FARM.2 Engineering Read-only Baseline and Write Authorization

**Receipt:** F-003-FARM2-ENG-001  
**State:** CLOSED / WRITES CONSUMED / SEE F-003-FARM2-ENG-002  
**Opened:** 2026-07-24  
**Owner:** Codex `/root`  
**Primary Skills:** `godot-feature-slice-implementation`, `game-project-control-plane`  
**Execution level:** L3 role-owned execution in the current task; no agent or extra Codex task was created  
**Fingerprint:** `8707CBDED14C3305B3436DB14545E98166C2D79D503936D6241256C72593572E`

## Approved sources

- Functional/configuration source: `docs/features/F-003-farm-town-foundation-v2.md`
- Formal document acceptance: `docs/receipts/F-003-FARM2-DOCUMENT-001.md`
- Editable Figma gate: `docs/receipts/F-003-FARM2-DESIGN-001.md`
- ART-003 gate: `docs/receipts/ART-003-FARM2-001.md`
- Asset manifest SHA-256: `24301875DE2305E562EC52668F3BB867B820F7BFD796B2555AC05729AB0D95ED`
- Old implementation lock release: `docs/receipts/F-003-FARM1-LOCK-RELEASE-001.md`

## Runtime and stable launch method

- Project root: `D:\AI\CityOfAnimals`
- Engine: Godot `4.6.2.stable.official.71f334935`
- Executable: `D:\Work\godot\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe`
- Automated test flags: `--headless --rendering-method gl_compatibility --rendering-driver opengl3 --audio-driver Dummy`
- The executable must run outside the filesystem sandbox. An isolated minimal project and the current FARM.1 test both exited `0`.
- Baseline test result: `TEST_PASS: Market Meadow, herd, local orders, CSV values, locale catalog, and direct hit regions verified.`
- Baseline test log: `tmp/F-003-spatial/farm1-baseline-test.log`
- Three pre-existing Godot GUI processes were observed with no main-window title. They are not treated as writers, are not terminated, and `.godot/` is outside the authorized write set.

## Starting hashes

| File | SHA-256 |
|---|---|
| `project.godot` | `5E3DFC7675FEA16C9EE5E708EF6466B9AE6C70F1D18C3066C8F320E9FDB15CB6` |
| `scenes/town_main.tscn` | `DB0969FE8CA74CE2128D4B2D775DABB803643DBDAD0DB0C722AE6B9BF9ED8386` |
| `scripts/town/town_config.gd` | `6AD636652E882AE8FB6EF1B83C14A697D1C761B4CDF7F6BDF34EC0DF90095485` |
| `scripts/town/town_model.gd` | `8476A5BA67739FCAA07A5DE0E7C158A9C2DC88A54CCFEA349BABD418893CABC7` |
| `scripts/town/town_text.gd` | `0B75E5227C01FA0213382BBDDFEFFB06E6E0B98F30CDE2FCD79935D0A0DA1B0A` |
| `scripts/town/town_view.gd` | `940879891927FC072D4C8E6799719AB1556FAFB4A58878B281B710D51FF3E0E2` |
| `tests/test_town_model.gd` | `CA7D277C3BE4F60767C9F6242580520515B57B97887ABB36B38E0A3CF980995A` |
| `config/tables/f003_farm_content.csv` | `7E246FA23115B02031B31E2588AFE323CF45ECCFDD48D84D5FECF79372C90B40` |
| `config/tables/f003_town_ui.csv` | `9787359252CD7F6DC10012D6BD343B21298B873CFCD9153E22858B15F71C8E8C` |

The same hashes were observed before and after the read-only baseline test.

## Authorized write set

- `docs/tasks/F-003-farm2-implementation.md`
- `docs/receipts/F-003-FARM2-ENG-001.md`
- `docs/receipts/F-003-FARM2-ENG-002.md`
- `project.godot`
- `scenes/town_main.tscn`
- `scripts/town/town_config.gd`
- `scripts/town/town_model.gd`
- `scripts/town/town_text.gd`
- `scripts/town/town_save.gd`
- `scripts/town/town_view.gd`
- `scripts/town/farm2_config.gd`
- `scripts/town/farm2_model.gd`
- `scripts/town/farm2_text.gd`
- `scripts/town/farm2_save.gd`
- `scripts/town/farm2_view.gd`
- `config/tables/f003_v2_items.csv`
- `config/tables/f003_v2_crops.csv`
- `config/tables/f003_v2_storage.csv`
- `config/tables/f003_v2_recipes.csv`
- `config/tables/f003_v2_animals.csv`
- `config/tables/f003_v2_buildings.csv`
- `config/tables/f003_v2_requests.csv`
- `config/tables/f003_v2_world.csv`
- `config/tables/f003_v2_locale.csv`
- `assets/runtime/f003_farm2/`
- `tests/test_town_model.gd`
- `tests/test_farm2_scene.gd`
- `docs/evidence/F-003-FARM2/`
- `output/runtime/F003-FARM.2/`
- `tmp/F-003-farm2-engineering/`

The old FARM.1 CSVs and evidence are historical read-only inputs and must not be rewritten.

The five `farm2_*` modules are the active implementation path. The old `town_*` scripts remain authorized only for a narrow compatibility adapter if required; their preferred outcome is unchanged historical preservation. This amendment avoids terminating or competing with any pre-existing Godot process.

## Three iteration milestones

### A — Authoritative core and large world

- Nine validated CSV tables and cross-reference checks.
- Seed-backed 12-plot crop economy, separate granary/storehouse capacity, chicken/cow production, machine queues, three dynamic requests and surplus market.
- 1800 x 1700 world, camera drag, 18+ visible objects, and first runtime promotion of approved ART-003 assets.
- Model and scene smoke tests.

### B — Player-facing interaction and persistence

- Object-driven context panels, blocked/ready/queue feedback, settings, `zh-CN` default, English switch and persistence.
- Save/load schema, offline timer advancement without automatic collection, and FARM.1 safe migration.
- Touch/camera gesture separation and responsive 720 x 1280 layout.

### C — Polish and acceptance

- Procedural state motion with reduced-motion fallback, readable state markers, touch feedback and screenshot parity pass.
- Ten-minute deterministic economy simulation, boundary/regression suite, normal-mode smoke, real rendered player evidence and scoped file/hash audit.

## Acceptance-to-path map

| Acceptance | Observable path |
|---|---|
| Seed conservation and net growth | select empty plot -> choose crop -> seed deducted -> timer -> ready -> full-yield harvest |
| Dual storage | crop/feed affect granary; animal/machine/material output affects storehouse; full capacity preserves ready state |
| Animal production | select chicken/cow enclosure -> feed -> timer -> ready -> collect |
| Machine queues | select machine -> enqueue recipe -> input deducted once -> queue/full/output-slot states -> collect |
| Requests and market | open request board -> atomic multi-item completion; open market -> choose surplus and confirm sale |
| Large 45-degree town | launch normal mode -> drag map beyond one viewport -> identify at least 18 objects/buildings |
| Language and persistence | Settings -> Language -> English -> restart -> English remains; switch back to Simplified Chinese |
| Save and interruption | start timers -> save/quit -> advance clock -> reload -> state advances but items are not auto-collected |

## Forbidden and non-goal scope

- No commercial game assets, names, UI layouts, exact values, map, copy, or proprietary content.
- No train, air cargo, online market, cooperative, monetization, advertising, server, or Alibaba Cloud deployment in F003-FARM.2.
- No edits to `.godot/`, generated imports, unrelated docs/assets, F-001/F-002 historical evidence, or F-004+ roadmap content.

## Gate result

`READY`: formal sources agree, old lock is released, starting hashes are stable, the write set is non-conflicting, Godot 4.6.2 has a reproducible outside-sandbox test command, and every acceptance item maps to an observable path. Separate iteration and milestone review evidence remains mandatory.

The authorized implementation completed on 2026-07-24. Final behavior, rendered evidence, scoped regression and hash audit are recorded in `docs/receipts/F-003-FARM2-ENG-002.md`.
