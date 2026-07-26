# F-003 FARM.1 Historical Runtime Lock Release

**Receipt:** F-003-FARM1-LOCK-RELEASE-001  
**State:** CLOSED / ARCHIVED / LOCK RELEASED  
**Date:** 2026-07-24  
**Owner:** Codex `/root`  
**Primary Skill:** `game-project-control-plane`  
**Execution level:** L1 direct execution  
**Fingerprint:** `D79BBA270DC423D002A7CAD2D61C449AB40D3D9348C9A9D494E99809B9C06F15`

## Basis

- `docs/receipts/F-003-DEEPPLAY-001.md` superseded F003-FARM.1 as the active product direction.
- `docs/features/F-003-farm-town-foundation-v2.md` is the accepted F003-FARM.2 formal source.
- Editable Figma, ART-003 preparation, and formal document gates for FARM.2 have passed.

## Released task and paths

The task `F003-ENG-001-IMPL` is now terminal `ARCHIVED`. Its former write lock on:

- `project.godot`
- `scripts/town/town_config.gd`
- `scripts/town/town_model.gd`
- `scripts/town/town_text.gd`
- `scripts/town/town_view.gd`
- `tests/test_town_model.gd`

is released.

## Preservation rule

F003-FARM.1 code, tests, receipts and screenshots remain recoverable historical evidence. This receipt does not delete, rewrite, accept, or promote them, and it grants no new runtime authority by itself.

## Next gate

F003-FARM.2 must pass its own engineering read-only baseline and explicit write-set receipt before any of the released paths can be modified.
