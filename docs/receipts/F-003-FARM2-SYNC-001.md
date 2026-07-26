# F-003 FARM.2 Control-plane Synchronization Receipt

**Receipt:** F003-FARM2-SYNC-001  
**State:** CLOSED / PRODUCER COORDINATION SYNC VERIFIED  
**Verified:** 2026-07-24  
**Owner:** Codex `/root`  
**Primary Skill:** `game-project-control-plane`  
**Execution level:** L1 direct execution  
**Fingerprint:** `4E86409C92F1DDD2C4DC98546F140064E5A3DDC4ECC84D4239A1F997F9D8F3CD`

## Formal decision loaded

- `docs/receipts/F-003-DEEPPLAY-001.md` records the producer rejection of the old F003-FARM.1 direction.
- `docs/features/F-003-farm-town-foundation-v2.md` is the current F003-FARM.2 functional source.
- The old request to capture the rejected runtime is superseded. Its code, tests, receipts, and evidence remain historical and recoverable.
- F-004 and later roadmap features remain inactive.

## Authorized write set

- `docs/active_scope.yaml`
- `docs/PM_HANDOFF.md`
- `docs/task_contract.md`
- `docs/design_index.md`
- `docs/config_index.md`
- `docs/features/F-003-farm-town-foundation-v2.md` (heading typo correction only)
- `PM/feature_progress.xlsx`
- this receipt

## Required state after sync

- F-003 remains the only P0 active feature, now under version `F003-FARM.2`.
- Current stage becomes `DESIGN / FIGMA GATE`.
- The next milestone is an editable Figma UE package plus ART-003 runtime-asset preparation.
- Runtime/config/test paths remain frozen until a separate engineering read-only receipt and write authorization.
- Old F003-FARM.1 implementation progress does not count as completed code/UI/integration for F003-FARM.2.

## Control-plane check

- status: `READY`
- duplicates: none
- write conflicts: none
- runtime writes: none
- irreversible actions: none

## Close condition

Close after all six coordination sources show F003-FARM.2 consistently and the workbook row is visually verified without altering unrelated rows or formatting.

## Completion evidence

- `docs/active_scope.yaml`, `docs/PM_HANDOFF.md`, `docs/task_contract.md`, `docs/design_index.md`, and `docs/config_index.md` now point to F003-FARM.2 and preserve F003-FARM.1 as historical.
- `PM/feature_progress.xlsx::Nine Dimensions!A18:U18` now records `DESIGN / FIGMA GATE`, overall `9%`, the current formal source, the Figma/ART-003 next milestone, and the runtime freeze.
- The edited workbook range was rendered and visually inspected; the existing header, fills, row styling, percentages, and neighboring F-004/F-005 rows were preserved.
- Official workbook SHA-256 after verification: `3B1098F495DF404F7A17B63CD0DD52A52C6852201D32A0E1E1EAC2706505CCFF`.
