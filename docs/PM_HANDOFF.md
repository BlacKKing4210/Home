# Producer Handoff

Status: F004-RESIDENT.1 V1.1 DESIGN REBASELINE READY FOR PENPOT IMPORT - AUTH/READBACK AND USER REVIEW PENDING, RUNTIME NOT AUTHORIZED

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

`PD-002` has formally rebaselined F-004 to `F004-RESIDENT.1`: players make low-frequency building, invitation, assignment and planning decisions while visible animal residents walk along roads, work, carry goods and live in the town. On 2026-07-26 the producer reaffirmed all five high-level principles: unified integer footprints based on the `1×1` field unit, world vehicle orders, formal original main-map assets after UI/UX design, animal residents executing building work, and a slow housing/invitation/life/work loop. `PD-003` now selects Penpot as the formal editable UI/UE source and supersedes the Figma-only tool dependency. The representative loop is one house, one resident, one road segment, one field or workplace and one vehicle order. Version 1.1 preserves the full A-H design package and adds Penpot-importable named SVG sources for eight 720×1280 review frames and four UE/state flows. The updated progress workbook, 43-page DOCX/PDF package and validation receipt are recorded in `docs/receipts/F004-RESIDENT-PENPOT-HANDOFF-004.md`. The exact footprint catalog/defaults, authenticated Penpot import/readback, and user review remain pending. No Godot runtime or new F004 configuration write is authorized. F003-FARM.2 remains the accepted playable baseline evidence, not proof of the new direction.

## Shared Locks

No shared file or runtime lock is active. `F004-DESIGN-LOCK-001` was released through `docs/receipts/F004-DESIGN-LOCK-RELEASE-002.md` after the old direction was superseded and the control-plane sources were synchronized. The old F004 document, eight tables and package remain preserved as historical migration input. Any F-004 runtime change still requires Penpot editable-source closure, user design approval and a new engineering read-only receipt with an exact non-conflicting write set.

## Producer Direction

`docs/decisions/PD-002-animal-resident-town-rebaseline.md` is the current product-direction authority, with the 2026-07-26 reaffirmation recorded in `docs/receipts/F004-RESIDENT-PRODUCER-REAFFIRM-003.txt`. The single memory point is: animals are not buttons or bonuses; they are visible residents who walk, live and make the town work. `docs/features/F-004-resident-town-spatial-autonomy.md` is the current F004 functional source. Earlier core-loop, product-plan and market sources remain genre and migration context only where they do not conflict with PD-002. F005 rail freight must now depend on the resident, road, carrying and world-vehicle order foundations rather than the superseded manual production direction.

## Blockers

The Figma seat/transport/browser diagnosis is historical and no longer blocks the active route. The current material dependency is `PENDING: Penpot authenticated editable file creation/readback`: Penpot SaaS is reachable, but the current browser session is not authenticated. Eight named 720×1280 screen/state frames and four named UE/state flows now exist as local editable SVG import sources under `output/penpot/F004-RESIDENT.1/`; they are not a substitute for a real Penpot file. The producer has confirmed the five high-level product principles, but review of the exact `1×1`-based footprint catalog and the recommended resident/offline/order defaults is still pending. These dependencies prevent design approval and runtime authorization; they are not file locks and must not be bypassed. F-001, F-002 and F003-FARM.2 remain closed for prototype.

## Git State

The user-designated remote is `git@github.com:BlacKKing4210/Home.git`. The audited pre-write baseline for this Penpot rebaseline continuation is `f5c21bf7749f8eb31ac9a3ab55cda9f93a2cde93` on `main`; final delivery synchronization is verified separately after the decision receipt and refreshed RAG receipts are committed. Dependency junctions, non-auditable task scratch data, Godot imports/translations, Python caches and workstation GPU caches remain ignored. Git connectivity and source synchronization do not change F004 design or runtime acceptance.

## Takeover State

`F004_RESIDENT_V1_1_PENPOT_SOURCE_PENDING`: Codex `/root` remains the sole accountable producer. The stale old-direction lock is released, so coordination is no longer blocked by a file lock. The next product step is to authenticate Penpot, import and read back the named editable sources, then obtain user review of the footprint catalog and recommended defaults before authorizing one representative Godot runtime slice. F-004 through F-010 remain non-runtime-authorized until their individual gates pass.
