# RAG Context Pack: REQ-COA-GIT-LOCK-AUDIT-20260726

- Query: CityOfAnimals current GitHub remote setup initial commit safety F004-RESIDENT.1 active scope old design lock release receipt Figma blocker runtime authority progress matrix
- Feature IDs: GLOBAL, F-004
- Index signature: `34ae788b93f7fa1dfb3b0dc0bcec8e226a40e775f8631d9b25af0bff7ede68cd`
- Generated: 2026-07-25T16:47:46Z

Use these excerpts as grounded project evidence. Resolve conflicts through formal source authority; do not treat this pack as a new approval.

## 1. ACTIVE_SCOPE — docs/active_scope.yaml

Citation: `ACTIVE_SCOPE:lines 1-45` | authority `canonical` | version `v1` | SHA-256 `c6fcc501f72122452bfb8f834ab9893b5ede7b7f5f0faa33e46d587be5ca95af` | chunk `77e721de6c864e051010ff3b`

schema_version: 1
scope_id: SCOPE-001
updated_on: "2026-07-26"

authority:
  producer: Codex /root
  design_owner: Codex /root (F004-RESIDENT.1 design-rebaseline owner)
  engineering_owner: Codex /root (F-003 FARM.2 acceptance owner)
  art_owner: Codex /root (F-003 FARM.2 runtime-asset owner)
  pm_execution_operator: Codex /root
  default_write_scope: docs/ and PM/ (producer coordination only)

priority_order:
  source: PM/feature_progress.xlsx
  same_priority_tiebreaker: feature_id_ascending
  completed_features_last: true
  skip_only_for: [unmet_dependency, shared_lock, safety_blocker]

monitoring:
  active_batch_nodes: []
  active_batch_tasks: []
  dependency_paused_nodes: []
  deferred_paused_nodes: []
  exception_interval_minutes: 30
  progress_refresh_interval_hours: 6
  healthy_result: quiet

feature_progress:
  workbook: PM/feature_progress.xlsx
  first_sheet: Nine Dimensions
  row_definition: one_complete_feature
  dimensions: [design_document, numeric_table, code, scene, UI, icon_or_image, scene_integration, image_integration, UI_integration]
  not_applicable_display: Not needed
  source_collection: [functional_documents, numeric_or_config_tables, version_plan, filed_producer_directives, latest_accountable_receipts]

active_modules:
  - feature_id: F-004
    task_id: F-004-RESIDENT-DESIGN-001
    name: Animal Resident Town Spatial and Autonomy Foundation
    version: F004-RESIDENT.1
    phase: DESIGN_REBASELINE_REVIEW
    state: DESIGN_REBASELINE_REVIEW_FIGMA_BLOCKED_NOT_RUNTIME_AUTHORIZED
    producer: Codex /root
    design_owner: Codex /root
    primary_skill:

## 2. ACTIVE_SCOPE — docs/active_scope.yaml

Citation: `ACTIVE_SCOPE:lines 90-127` | authority `canonical` | version `v1` | SHA-256 `c6fcc501f72122452bfb8f834ab9893b5ede7b7f5f0faa33e46d587be5ca95af` | chunk `20e35ed03d3ff1f209b1fee2`

dependency: F-009 acceptance plus a separate product decision, functional/configuration source, receipt, and write authorization

completed_modules:
  - feature_id: F-003
    name: Animal Town Farm Foundation V2
    version: F003-FARM.2
    state: ACCEPTED_FOR_PROTOTYPE
    formal_source: docs/features/F-003-farm-town-foundation-v2.md
    evidence: docs/receipts/F-003-FARM2-ENG-002.md
    player_visible_evidence: docs/evidence/F-003-FARM2/README.md
  - feature_id: F-003-HIST
    name: Herd and Local Orders
    version: F003-FARM.1
    state: SUPERSEDED_ARCHIVED
    evidence: docs/receipts/F-003-FARM1-LOCK-RELEASE-001.md
  - feature_id: F-002
    name: Farmboard Visual Language
    state: ACCEPTED_FOR_PROTOTYPE
    evidence: docs/receipts/F-002-ENG-002.md
  - feature_id: F-001
    name: Market Meadow P0
    state: ACCEPTED_FOR_PROTOTYPE
    evidence: docs/receipts/F-001-ENG-003.md

shared_locks: []

released_locks:
  - lock_id: F004-DESIGN-LOCK-001
    owner: Codex /root
    task_id: F-004-DESIGN-001
    released_on: "2026-07-26"
    release_receipt: docs/receipts/F004-DESIGN-LOCK-RELEASE-002.md
    reason: F004-DISTRICT.1 was superseded by the approved PD-002 product rebaseline; formal sources and progress state were synchronized to F004-RESIDENT.1.
    preserves:
      - docs/features/F-004-farm-district-industry-i.md
      - config/tables/f004_*.csv
      - output/documents/F004-DISTRICT.1/
    preserved_status: HISTORICAL_MIGRATION_INPUT_NOT_RUNTIME

## 3. ACTIVE_SCOPE — docs/active_scope.yaml

Citation: `ACTIVE_SCOPE:lines 39-70` | authority `canonical` | version `v1` | SHA-256 `c6fcc501f72122452bfb8f834ab9893b5ede7b7f5f0faa33e46d587be5ca95af` | chunk `9050941b4530656c10f99483`

ial and Autonomy Foundation
    version: F004-RESIDENT.1
    phase: DESIGN_REBASELINE_REVIEW
    state: DESIGN_REBASELINE_REVIEW_FIGMA_BLOCKED_NOT_RUNTIME_AUTHORIZED
    producer: Codex /root
    design_owner: Codex /root
    primary_skill: game-feature-design-docs + ui-design-priority + game-visual-quality-pipeline
    task_fingerprint: BA4466ABDA82579862EA7476FF39D1A8B96ACB30A009EDCC85616914805E4897
    formal_inputs:
      - docs/decisions/PD-002-animal-resident-town-rebaseline.md
      - docs/features/F-004-resident-town-spatial-autonomy.md
      - docs/uiux/F004-RESIDENT.1-ui-priority.md
      - docs/design/F004-RESIDENT.1-visual-quality-contract.md
      - docs/receipts/F004-RESIDENT-DESIGN-001.md
      - docs/features/F-003-farm-town-foundation-v2.md
      - docs/features/F-004-farm-district-industry-i.md
    authorization: docs/receipts/PD-002-READ-ONLY.md
    current_receipt: docs/receipts/F004-RESIDENT-DESIGN-001.md
    editable_design_register: output/figma/F004-RESIDENT.1/README.md
    blocker: "BLOCKED: Figma UE attachment"
    runtime_authority: false
queued_modules:
  - feature_id: F-005
    name: Rail Freight Yard
    state: ROADMAP_ONLY
    producer_direction: docs/roadmaps/PLAN-001-original-farm-town-content-ladder.md
    dependency: F004-RESIDENT.1 representative runtime slice approval plus a dedicated functional/configuration source, receipt, and write authorization
  - feature_id: F-006
    name: Town Trade Quarter and Industry II
    state: ROADMAP_ONLY
    producer_direction: docs/roadmaps/PLAN-001-original-farm-town-content-ladder.md
    dependency:

## 4. TASK_CONTRACT — docs/task_contract.md

Citation: `TASK_CONTRACT:lines 1-17` | authority `canonical` | version `v1` | SHA-256 `1b926af18e14729aadb0bd9301b3983505bc424b02c546a6ef826267913427dd` | chunk `c1e744b62d610f3b69a36b6e`

# Current Execution Task Contract

F-004 has been formally rebaselined from `F004-DISTRICT.1` to `F004-RESIDENT.1`. The current task is design review and editable-design handoff only. Figma remains blocked and runtime implementation remains unauthorized.

- Task ID: `F-004-RESIDENT-DESIGN-001`.
- Version: `F004-RESIDENT.1`.
- Feature name: `Animal Resident Town Spatial & Autonomy Foundation`.
- Producer/design owner: Codex `/root`.
- Product decision: [PD-002 Animal Resident Town Rebaseline](decisions/PD-002-animal-resident-town-rebaseline.md).
- Design authorization: [PD-002 Read-only Receipt](receipts/PD-002-READ-ONLY.md).
- Current design receipt: [F004-RESIDENT-DESIGN-001](receipts/F004-RESIDENT-DESIGN-001.md).
- Formal output target: [F-004 Resident Town Spatial and Autonomy](features/F-004-resident-town-spatial-autonomy.md).
- Required handoff: approved `1x1` grid and footprint catalog, editable Figma/FigJam UE and state layouts, reviewed general-template DOCX/PDF, visual quality contract and milestone review.
- Current evidence: product rebaseline, spatial rules, resident/job state machine, vehicle-order UE, UI priority, visual contract and 37-page DOCX/PDF review package exist.
- Current blocker: `BLOCKED: Figma UE attachment`; local Mermaid sources, static figures and documents do not close this gate.
- Runtime exclusion: do not edit Godot scenes, scripts, tests, save data, `project.godot`, runtime assets or create new F004 configuration tables under this task.
- Engineering gate: user design review and verified editable Figma/FigJam write-readback must pass

## 5. PROJECT_WORKFLOW — docs/WORKFLOW.md

Citation: `PROJECT_WORKFLOW:lines 1-31` | authority `canonical` | version `v1` | SHA-256 `a8085fbf17d027d6025407be915087dda47636f8dfd9bd05fbfb6086a485fbc0` | chunk `a5e46afa2266e3ab2aa48592`

# CityOfAnimals Production Workflow

Version: WORKFLOW-1

## Authority

- One accountable producer owns priority, shared-file ordering, and final status.
- Design, engineering, and art owners are long-lived role entrances.
- Role owners define contracts, monitor their tasks, and accept results.
- Production is performed by short-lived execution tasks.
- The PM execution operator monitors and refreshes status but cannot make producer decisions.

## Requirement Intake

Natural-language producer requests are valid intake. File behavior-changing requests into a functional source and corresponding configuration source before implementation when required. Do not ask for redundant confirmation when the requested outcome and identity are clear from approved sources.

## Work Order

Use `PM/feature_progress.xlsx` as the advancement queue. Higher priority goes first. Same priority uses ascending feature ID. Completed features are last. Skip only for dependencies, shared locks, or safety blockers and record the reason.

## Execution Task Gate

Every task has one objective, one accountable owner, one primary Skill, one isolated write scope, source baselines, acceptance evidence, cleanup, and close conditions.

The task first submits a read-only receipt. The owner independently reviews it and explicitly authorizes writes. Contract READY is not task READY.

## Runtime And Asset Rules

- Final assets already available must be used completely.
- Missing assets may use explicit development placeholders.
- UI may use temporary visuals; non-UI art targets final quality from first production.

## 6. PM_HANDOFF — docs/PM_HANDOFF.md

Citation: `PM_HANDOFF:lines 27-39` | authority `approved` | version `v1` | SHA-256 `4aa9e85f93359a533dbafc1876394fcb463472534223adae19f125ffd67fce93` | chunk `57c4706aa1709ce4fc64f980`

eipts/F004-DESIGN-LOCK-RELEASE-002.md` after the old direction was superseded and the control-plane sources were synchronized. The old F004 document, eight tables and package remain preserved as historical migration input. Any F-004 runtime change still requires Figma closure, user design approval and a new engineering read-only receipt with an exact non-conflicting write set.

## Producer Direction

`docs/decisions/PD-002-animal-resident-town-rebaseline.md` is the current product-direction authority. The single memory point is: animals are not buttons or bonuses; they are visible residents who walk, live and make the town work. `docs/features/F-004-resident-town-spatial-autonomy.md` is the current F004 functional source. Earlier core-loop, product-plan and market sources remain genre and migration context only where they do not conflict with PD-002. F005 rail freight must now depend on the resident, road, carrying and world-vehicle order foundations rather than the superseded manual production direction.

## Blockers

`BLOCKED: Figma UE attachment` remains material. The target Figma file can be identified, but editable frames/flows have not been created and read back with a valid edit-capable seat. User review of the `1x1` footprint catalog and the recommended resident/offline/order defaults is also pending. These blockers prevent design approval and runtime authorization; they are not file locks and must not be bypassed. F-001, F-002 and F003-FARM.2 remain closed for prototype.

## Git State

The user-designated remote is `git@github.com:BlacKKing4210/Home.git`. The

## 7. PM_HANDOFF — docs/PM_HANDOFF.md

Citation: `PM_HANDOFF:lines 1-27` | authority `approved` | version `v1` | SHA-256 `4aa9e85f93359a533dbafc1876394fcb463472534223adae19f125ffd67fce93` | chunk `35a83f3154da170ed6f5fb6f`

# Producer Handoff

Status: F004-RESIDENT.1 DESIGN REBASELINE REVIEW - FIGMA BLOCKED, RUNTIME NOT AUTHORIZED

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

`PD-002` has formally rebaselined F-004 to `F004-RESIDENT.1`: players make low-frequency building, invitation, assignment and planning decisions while visible animal residents walk along roads, work, carry goods and live in the town. The representative loop is one house, one resident, one road segment, one field or workplace and one vehicle order. The design package, UI priority source, visual quality contract and DOCX/PDF review package exist, but the editable Figma/FigJam source is still blocked. No Godot runtime or new F004 configuration write is authorized. F003-FARM.2 remains the accepted playable baseline evidence, not proof of the new direction.

## Shared Locks

No shared file or runtime lock is active. `F004-DESIGN-LOCK-001` was released through `docs/receipts/F004-DESIGN-LOCK-RELEASE-002.md` after the old direction was superseded and the control-plane sources were synchronized. The old F004 document, eight tables and package remain preserved as historical migration input. Any F-004 runtime

## 8. PM_HANDOFF — docs/PM_HANDOFF.md

Citation: `PM_HANDOFF:lines 35-43` | authority `approved` | version `v1` | SHA-256 `4aa9e85f93359a533dbafc1876394fcb463472534223adae19f125ffd67fce93` | chunk `45be0ccd37784b76a3076e99`

design approval and runtime authorization; they are not file locks and must not be bypassed. F-001, F-002 and F003-FARM.2 remain closed for prototype.

## Git State

The user-designated remote is `git@github.com:BlacKKing4210/Home.git`. The local repository began with no commits and no remote; a guarded initial commit may be created only after generated caches, temporary dependency junctions, sensitive data and large files are excluded and RAG is rebuilt. Git connectivity is independent from feature acceptance.

## Takeover State

`F004_RESIDENT_DESIGN_REVIEW_FIGMA_BLOCKED`: Codex `/root` remains the sole accountable producer. The stale old-direction lock is released, so coordination is no longer blocked by a file lock. The next product step is still to restore editable Figma/FigJam delivery, review the footprint catalog, and close the design milestone before authorizing one representative Godot runtime slice. F-004 through F-010 remain non-runtime-authorized until their individual gates pass.

## 9. PROJECT_AGENTS — AGENTS.md

Citation: `PROJECT_AGENTS:lines 1-10` | authority `canonical` | version `v1` | SHA-256 `80d8187733e3cc892136f801078a130ccab0e031bf6e49492b0299690444ed22` | chunk `f5f28f0a47ec615fa3491e65`

# CityOfAnimals Workspace Rules
## Current Adaptive Game Workflow

This is the current common game-workflow rule and takes precedence over later generic workflow wording in this file. Preserve every project-specific rule, approved design, engine constraint, and data pipeline as the project adapter.

Use `game-studio-orchestrator` from the personal `game-studio-agent-workflow` plugin as the primary workflow. Load `game-project-control-plane` for intake, state synchronization, task deduplication, write-lock checks, evidence tracking, and adaptive routing. Keep exactly one accountable producer; the control plane is the producer-facing coordination surface, not a second producer.

Classify requests as discussion, producer decision, execution request, status query, or reusable-method candidate. Use the smallest safe level: L0 inline discussion/status, L1 direct low-risk single-domain execution with reproducible checks, L2 bounded work with separate review, L3 only the needed design/engineering/art owner for cross-domain, shared, high-risk, milestone, or concurrent work, and L4 for unresolved material or irreversible choices. If profile, priority, active-scope, ownership, or write-lock sources are absent, return NOT READY instead of inventing state.

Before any production write, confirm the formal source, owner, primary Skill, task fingerprint, non-conflicting write set, baseline, acceptance, evidence, and cleanup conditions; record a read-only receipt. Use the priority matrix when it exists: higher priority, then ascending feature ID, with skip reasons recorded. Close only with

## 10. PROJECT_PROFILE — docs/project_profile.yaml

Citation: `PROJECT_PROFILE:lines 1-52` | authority `canonical` | version `v1` | SHA-256 `cbc5f1c8ccc4b244ed522c9628da0dde64f791974765dce51f24e89dddf70cd3` | chunk `2ced5fb4d4591013251b1f45`

schema_version: 1
project:
  name: "CityOfAnimals"
  root: 'D:\AI\CityOfAnimals'
  engine: "Godot"
  stage: prototype

formal_sources:
  wo
[chunk truncated by context budget]
