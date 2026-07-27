# Current Execution Task Contract

## Active Task

None. F004.2 and its formal document package are closed; no follow-up feature has acquired write authority.

The final request-specific RAG receipt is generated as
`knowledge/index/task-receipts/REQ-F004-RESIDENT2-FINAL-CLOSE-20260727.json`
after the last indexed-source synchronization.

## Most Recently Closed Task

- Task ID: `F-004-RESIDENT-SCALEOUT-DOCUMENT-003`.
- Feature identity: documentation close for `F-004.2 / F004-RESIDENT.2 V1.2`.
- Status: `DOCUMENT_PACKAGE_APPROVED`.
- Read-only receipt: [F004-RESIDENT-SCALEOUT-DOCUMENT-READ-ONLY-017](receipts/F004-RESIDENT-SCALEOUT-DOCUMENT-READ-ONLY-017.md).
- Document receipt: [F004-RESIDENT-SCALEOUT-DOCUMENT-018](receipts/F004-RESIDENT-SCALEOUT-DOCUMENT-018.md).
- Output: `output/documents/F004-RESIDENT.2/`.
- Lock: `F004-RESIDENT-SCALEOUT-DOC-LOCK-005` returned.

## Most Recently Closed Runtime Task

- Task ID: `F-004-RESIDENT-SCALEOUT-002`.
- Feature identity: `F-004.2 / F004-RESIDENT.2 V1.2`.
- Name: `Resident Dairy Neighborhood and Daily Life Scale-Out`.
- Producer/design/art/engineering owner: Codex `/root`.
- Producer decision: [PD-004 Resident Quality Scale-Out](decisions/PD-004-resident-quality-scaleout.md).
- Runtime acceptance: [F004-RESIDENT-SCALEOUT-RUNTIME-ACCEPTANCE-016](receipts/F004-RESIDENT-SCALEOUT-RUNTIME-ACCEPTANCE-016.md).
- Player-visible evidence: [F004-RESIDENT.2 evidence](evidence/F004-RESIDENT.2/README.md).
- RAG task receipt: refreshed after final indexed-source synchronization.
- Current phase: `CLOSED`.
- Runtime completion: `true` for F004.2.
- Scale-out approval: `true` for reuse of the approved rules only.

## Exact Player-Facing Slice

1. Player enters an expansion placement state and can read legal/illegal footprints.
2. Player places `1×1` roads, a `2×2` second home, a `3×3` dairy pasture and a `2×2` creamery.
3. Player invites a bear resident, assigns the dairy role and then stops issuing production clicks.
4. Bear walks by road, cares for and milks the pasture cow, carries milk to the creamery, processes the dairy crate and loads a second world vehicle.
5. Vehicle visibly arrives, waits, loads, departs and rewards once.
6. Rabbit and bear return to their homes or a configured `1×1` leisure point after work.

## Current Gates

- F004-RESIDENT.1 baseline: `RUNTIME_SLICE_APPROVED`.
- F004-RESIDENT.2 design source: `DESIGN_SCALEOUT_BASELINE_APPROVED`.
- F004-RESIDENT.2 Penpot: `PENPOT_SCALEOUT_READBACK_VERIFIED`.
- F004-RESIDENT.2 visual contract: `VISUAL_SCALEOUT_CONTRACT_APPROVED`.
- F004-RESIDENT.2 asset set: `ASSET_SET_APPROVED`.
- F004-RESIDENT.2 runtime: `RUNTIME_SLICE_APPROVED`.
- F004 broad reusable rule set: `SCALE_OUT_APPROVED`.

## Lock

No active shared lock. `F004-RESIDENT-SCALEOUT-ENG-LOCK-004` was returned by the runtime acceptance receipt. F004.1 remains an explicit rollback baseline.

## Priority Exception

F-005 remains `ROADMAP_ONLY`. It is skipped only because the user explicitly required the F004 footprint, animal-resident, multi-building and life-quality gaps to be completed first. This does not delete or accept F-005.

## Non-Completion Boundaries

- Static docs, Penpot, local SVG, files or windows did not prove runtime; F004.2 closed with Godot behavior and real-render evidence.
- Existing F004.1 percentages were not transferred to F004.2; it passed independently.
- No bulk historical-building import, train, air cargo, Android release, server deployment or shutdown is included.
