# Producer Handoff

Status: F004-RESIDENT.1 DESIGN REBASELINE PACKAGE COMPLETE FOR REVIEW - FIGMA BLOCKED, RUNTIME NOT AUTHORIZED

## Read Order

1. `docs/WORKFLOW.md`
2. `docs/project_profile.yaml`
3. `docs/active_scope.yaml`
4. `PM/feature_progress.xlsx`
5. Latest receipts for active tasks only

## Unique Roles

- Producer: `Codex /root`
- Design owner: `Codex /root (F004-RESIDENT.1 design-rebaseline owner)`
- Engineering owner: `Codex /root (F-003 FARM.2 acceptance owner)`
- Art owner: `Codex /root (F-003 FARM.2 runtime-asset owner)`
- PM execution operator: `Codex /root`

## Current Batch

`PD-002` has formally rebaselined F-004 to `F004-RESIDENT.1`: players make low-frequency building, invitation, assignment and planning decisions while visible animal residents walk along roads, work, carry goods and live in the town. The representative loop is one house, one resident, one road segment, one field or workplace and one vehicle order. Version 1.0 of the A-H design package, UI priority source, visual quality contract and DOCX/PDF review package is complete for user review, but the editable Figma/FigJam source is still blocked. No Godot runtime or new F004 configuration write is authorized. F003-FARM.2 remains the accepted playable baseline evidence, not proof of the new direction.

## Shared Locks

No shared file or runtime lock is active. `F004-DESIGN-LOCK-001` was released through `docs/receipts/F004-DESIGN-LOCK-RELEASE-002.md` after the old direction was superseded and the control-plane sources were synchronized. The old F004 document, eight tables and package remain preserved as historical migration input. Any F-004 runtime change still requires Figma closure, user design approval and a new engineering read-only receipt with an exact non-conflicting write set.

## Producer Direction

`docs/decisions/PD-002-animal-resident-town-rebaseline.md` is the current product-direction authority. The single memory point is: animals are not buttons or bonuses; they are visible residents who walk, live and make the town work. `docs/features/F-004-resident-town-spatial-autonomy.md` is the current F004 functional source. Earlier core-loop, product-plan and market sources remain genre and migration context only where they do not conflict with PD-002. F005 rail freight must now depend on the resident, road, carrying and world-vehicle order foundations rather than the superseded manual production direction.

## Blockers

`BLOCKED: Figma UE attachment` remains material. On 2026-07-26, Figma `whoami` returned `skyfire / Starter / seat=View`; target-file `use_figma` failed at the MCP transport layer, the in-app browser load timed out, and the installed Chrome control channel returned unavailable. Editable frames/flows therefore have not been created or read back with a valid edit-capable path. User review of the `1x1` footprint catalog and the recommended resident/offline/order defaults is also pending. These blockers prevent design approval and runtime authorization; they are not file locks and must not be bypassed. F-001, F-002 and F003-FARM.2 remain closed for prototype.

## Git State

The user-designated remote is `git@github.com:BlacKKing4210/Home.git`. The audited pre-delivery baseline is `9fb0dc63595ce841528546c5474425d0bcc95702` on `main`; final delivery synchronization is verified separately after the design package, workbook and RAG receipts are committed. Dependency junctions, non-auditable task scratch data, Godot imports/translations, Python caches and workstation GPU caches remain ignored. Git connectivity and source synchronization do not change F004 design or runtime acceptance.

## Takeover State

`F004_RESIDENT_DESIGN_PACKAGE_COMPLETE_FIGMA_BLOCKED`: Codex `/root` remains the sole accountable producer. The stale old-direction lock is released, so coordination is no longer blocked by a file lock. The next product step is to restore editable Figma/FigJam delivery and obtain user review of the footprint catalog and recommended defaults before authorizing one representative Godot runtime slice. F-004 through F-010 remain non-runtime-authorized until their individual gates pass.
