# RAG Context Pack: REQ-COA-GIT-LOCK-AUDIT-20260726

- Query: CityOfAnimals GitHub origin main baseline commit verified stale F004 design lock released no active shared locks Figma blocked runtime unauthorized final handoff
- Feature IDs: F-004
- Index signature: `c204223feda828b1ce0d6fcf643a6002439d0f26d91a8c080875984005ab2f2d`
- Generated: 2026-07-26T05:44:36Z

Use these excerpts as grounded project evidence. Resolve conflicts through formal source authority; do not treat this pack as a new approval.

## 1. F004_DESIGN_RECEIPT — docs/receipts/F-004-DESIGN-001.md

Citation: `F004_DESIGN_RECEIPT:lines 1-35` | authority `approved` | version `F004-DISTRICT.1` | SHA-256 `8a9912c63b9383390f0f5cfdadc63af76cd9bccb580cae1b0588bab33f98e790` | chunk `fc6bcc85ac66f8cb7196ef5d`

# F-004 Formal Design Authorization

**Receipt:** F-004-DESIGN-001  
**State:** ACTIVE / CONFIG+DOCUMENT VALIDATED / FIGMA BLOCKED / FORMAL DESIGN ONLY  
**Date:** 2026-07-24  
**Producer and design owner:** Codex `/root`  
**Feature:** F-004 / F004-DISTRICT.1  
**Task fingerprint:** `D59A3CA5733E743B7316DE5F86D604BB592E6FD7C84EC5A45BD883C897CDDF25`

## Read-only preflight result

- Control-plane result: `READY / L3`.
- Route owner: `design_owner`.
- Duplicate tasks: none.
- Conflicting tasks or shared locks: none.
- Dependency: F003-FARM.2 is `ACCEPTED FOR PROTOTYPE` and its lock is released.
- L3 means a cross-domain milestone review is required. It does not authorize creating an agent, sub-agent, Codex task, thread or worktree.
- The unique producer remains Codex `/root`; the current agent directly owns this design package.

## Formal inputs

- `docs/roadmaps/PLAN-001-original-farm-town-content-ladder.md`
- `docs/roadmaps/PRODUCT-PLAN-001-city-of-animals.md`
- `docs/design/CORE-LOOP-001-original-farm-town-core-loop.md`
- `docs/design/CORE-FUNCTIONS-001-original-farm-town-design.md`
- `docs/research/2026-07-farm-town-market-architecture.md`
- `docs/features/F-003-farm-town-foundation-v2.md`
- `docs/receipts/F-003-FARM2-ENG-002.md`

## Authorized outcome

Create an implementation-ready general feature package for an original, commercially safe “Farm District Board and Industry I” slice:

1. preserve the accepted 1800 x 1700 FARM.2 world and organize its existing land into readable agriculture, animal and workshop districts;
2. define a world-first District Board and fixed

## 2. F004_DESIGN_RECEIPT — docs/receipts/F-004-DESIGN-001.md

Citation: `F004_DESIGN_RECEIPT:lines 32-67` | authority `approved` | version `F004-DISTRICT.1` | SHA-256 `8a9912c63b9383390f0f5cfdadc63af76cd9bccb580cae1b0588bab33f98e790` | chunk `917db644869102d03efd74f4`

ly safe “Farm District Board and Industry I” slice:

1. preserve the accepted 1800 x 1700 FARM.2 world and organize its existing land into readable agriculture, animal and workshop districts;
2. define a world-first District Board and fixed construction sites without implementing free land expansion;
3. activate a first connected extension of existing agriculture, animal and workshop content;
4. make at least one shared material visibly compete between two valid uses;
5. define exact original configuration tables, player-visible states, UI/UE, localization, persistence boundaries and QA;
6. deliver editable Figma/FigJam artifacts plus reviewed DOCX and PDF.

## Authorized write set

- `docs/features/F-004-farm-district-industry-i.md`
- `config/tables/f004_districts.csv`
- `config/tables/f004_sites.csv`
- `config/tables/f004_items.csv`
- `config/tables/f004_sources.csv`
- `config/tables/f004_animals.csv`
- `config/tables/f004_recipes.csv`
- `config/tables/f004_requests.csv`
- `config/tables/f004_locale.csv`
- `docs/receipts/F-004-DESIGN-001.md`
- `docs/active_scope.yaml`
- `docs/task_contract.md`
- `docs/project_profile.yaml`
- `docs/design_index.md`
- `docs/config_index.md`
- `docs/PM_HANDOFF.md`
- `PM/feature_progress.xlsx`
- `output/documents/F004-DISTRICT.1/`

The editable Figma artifact is an external design source registered by file key, URL, page and node references in the feature document.

## Explicit exclusions

- No Godot scene, script, test, `project.godot`, save data or runtime-asset write.
- No F-005 rail freight, F-006 town services, F-007 air cargo or F-008

## 3. ACTIVE_SCOPE — docs/active_scope.yaml

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

## 5. PROJECT_PROFILE — docs/project_profile.yaml

Citation: `PROJECT_PROFILE:lines 1-52` | authority `canonical` | version `v1` | SHA-256 `cbc5f1c8ccc4b244ed522c9628da0dde64f791974765dce51f24e89dddf70cd3` | chunk `2ced5fb4d4591013251b1f45`

schema_version: 1
project:
  name: "CityOfAnimals"
  root: 'D:\AI\CityOfAnimals'
  engine: "Godot"
  stage: prototype

formal_sources:
  workflow: docs/WORKFLOW.md
  handoff: docs/PM_HANDOFF.md
  active_scope: docs/active_scope.yaml
  feature_progress: PM/feature_progress.xlsx
  design_index: docs/design_index.md
  config_index: docs/config_index.md

runtime:
  project_path: 'D:\AI\CityOfAnimals'
  candidate_paths:
    - assets/candidate/f003_farm2
  formal_asset_paths:
    - assets/runtime/f003_farm2
  task_temporary_root: tmp

presentation:
  default_platform: mobile
  orientation: portrait
  design_resolution: [720, 1280]
  responsive_scaling_required: true
  verification_resolution: [720, 1280]

localization:
  default_locale: zh-CN
  selectable_locales: [zh-CN, en]
  settings_path: "Settings > Language"
  persistence_required: true
  runtime_text_rule: "Use locale keys and locale tables for all player-visible text."

roles:
  producer: Codex /root
  design_owner: Codex /root (F-004 formal-design owner)
  engineering_owner: Codex /root (F-003 FARM.2 acceptance owner)
  art_owner: Codex /root (F-003 FARM.2 runtime-asset owner)
  pm_execution_operator: Codex /root

rules:
  one_active_producer: true
  execution_requires_read_only_receipt: true
  execution_requires_owner_write_authorization: true
  one_writer_per_shared_file: true
  existing_final_assets_have_priority: true
  ui_temporary_visuals_allowed: true
  non_ui_art_final_quality_from_first_production: true

## 6. ACTIVE_SCOPE — docs/active_scope.yaml

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

## 7. PROJECT_WORKFLOW — docs/WORKFLOW.md

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

## 8. F004_LOCK_RELEASE_RECEIPT — docs/receipts/F004-DESIGN-LOCK-RELEASE-002.md

Citation: `F004_LOCK_RELEASE_RECEIPT:lines 1-43` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `ca5a0703ab06f4be323a275faa6cb7a964491dddc7b3f9e3f9b631c6a06d577e` | chunk `6cdf6bc4e48f89f154dc39fe`

# F004 旧设计锁释放回执

- 回执 ID：`F004-DESIGN-LOCK-RELEASE-002`
- 日期：2026-07-26
- 唯一 accountable producer：Codex `/root`
- 释放锁：`F004-DESIGN-LOCK-001`
- 原任务：`F-004-DESIGN-001 / F004-DISTRICT.1`
- 当前任务：`F-004-RESIDENT-DESIGN-001 / F004-RESIDENT.1`
- 决策来源：`docs/decisions/PD-002-animal-resident-town-rebaseline.md`
- 控制面回执：`docs/receipts/COA-GIT-LOCK-CONTROL-PLANE-001.json`
- 只读回执：`docs/receipts/COA-GIT-LOCK-READ-ONLY-001.md`

## 释放判断

`F004-DISTRICT.1` 已被正式产品决策标记为：

`REVISE_REQUIRED / SUPERSEDED_BY F004-RESIDENT.1 / MIGRATION_INPUT / NOT_RUNTIME`

旧锁继续占用 `active_scope`、任务契约、索引、PM handoff 和进度工作簿只会造成控制面状态漂移。当前唯一制作人已经完成这些共享来源的原子同步，因此旧锁满足释放条件。

## 已完成的同步

- `docs/active_scope.yaml` 已将活动身份切换为 `F004-RESIDENT.1`，`shared_locks` 为空，并登记本释放回执；
- `docs/task_contract.md` 已切换到居民小镇设计重基线与 Figma 阻塞状态；
- `docs/PM_HANDOFF.md` 已同步当前产品记忆点、阻塞、Git 状态和下一步；
- `docs/design_index.md` 已把新 F004 设为当前来源，把 `F004-DISTRICT.1` 降为历史迁移输入；
- `docs/config_index.md` 已明确新方向的数值表为 `0%` 且尚未授权，旧八表只作历史迁移输入；
- `PM/feature_progress.xlsx` 的 `Nine Dimensions!A19:U19` 已改为 `F004-RESIDENT.1` 身份，九维完成度全部为 `0%`，不继承旧方向的 `22.22%`；
- 更新后的工作簿通过公式错误扫描，`#REF!`、`#DIV/0!`、`#VALUE!`、`#NAME?`、`#N/A` 命中为零，并完成样式渲染复核；
- Git 层面没有 `.git/index.lock`、`.git/config.lock` 或 `.git/HEAD.lock`，也没有相关编辑器写进程。

## 保留与禁止

- 保留 `docs/features/F-004-farm-district-industry-i.md`、`config/tables/f004_*.csv` 和 `output/documents/F004-DISTRICT.1/`，不删除用户已有成果；
- 这些历史内容不再拥有运行时权威，不得据此继续手动生产点击、固定功能位或裸订单卡方向；
- 本次释放没有创建新的共享锁，因为当前处于用户设计审阅和 Figma 阻塞阶段，没有获准的运行时写任务；
- `BLOCKED: Figma UE attachment`、用户设计审阅和 `runtime_authority=false` 继续有效。

## 结果

`RELEASED: F004-DESIGN-LOCK-001`

## Git

## 9. F004_LOCK_RELEASE_RECEIPT — docs/receipts/F004-DESIGN-LOCK-RELEASE-002.md

Citation: `F004_LOCK_RELEASE_RECEIPT:lines 34-61` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `ca5a0703ab06f4be323a275faa6cb7a964491dddc7b3f9e3f9b631c6a06d577e` | chunk `ef9969bbacf1e817288e5144`

RICT.1/`，不删除用户已有成果；
- 这些历史内容不再拥有运行时权威，不得据此继续手动生产点击、固定功能位或裸订单卡方向；
- 本次释放没有创建新的共享锁，因为当前处于用户设计审阅和 Figma 阻塞阶段，没有获准的运行时写任务；
- `BLOCKED: Figma UE attachment`、用户设计审阅和 `runtime_authority=false` 继续有效。

## 结果

`RELEASED: F004-DESIGN-LOCK-001`

## Git 基线同步

- 远端：`git@github.com:BlacKKing4210/Home.git`
- 分支：`main`，跟踪 `origin/main`
- 首个基线提交：`5128e5a5bd27b2e61bf3f9c3137f2f36c92a1ca5`
- 推送：`PASS`
- 推送后只读校验：本地与远端 `refs/heads/main` 哈希一致
- 提交边界：305 个文件、34.54 MB；未包含 `node_modules` junction、非审计 `tmp`、`.godot`、`.import`、`.translation`、`*.pyc`、本机 Vulkan 管线缓存或常见凭据模式
- 二进制完整性：115 个 PNG/PDF/DOCX/XLSX 等文件的 Git 暂存 blob 与工作区字节哈希一致
- 工程检查：Godot `4.6.2` 无界面导入与 `tests/test_town_model.gd` 回归均为退出码 `0`

该结果只解除失效的文件协调锁，不代表：

- `DESIGN_REBASELINE_APPROVED`
- `VISUAL_CONTRACT_APPROVED`
- `RUNTIME_SLICE_APPROVED`
- F004 功能完成
- 整批工作完成
- 满足关机条件

## 10. GIT_LOCK_READ_ONLY_RECEIPT — docs/receipts/COA-GIT-LOCK-READ-ONLY-001.md

Citation: `GIT_LOCK_READ_ONLY_RECEIPT:lines 1-30` | authority `approved` | version `GIT-LOCK.1` | SHA-256 `466425ace923e005b0fb2402f4f2a0dc82aea54bac384cfc8ece78888f6d2675` | chunk `9c2a9e9296acb45c646dd8fb`

# CityOfAnimals Git 与锁状态只读回执

- 回执 ID：`COA-GIT-LOCK-READ-ONLY-001`
- 请求 ID：`REQ-COA-GIT-LOCK-AUDIT-20260726`
- 日期：2026-07-26
- 唯一 accountable producer：Codex `/root`
- 请求类型：制作人执行请求；Git 远端接入与阻塞锁排查
- 项目根目录：`D:\AI\CityOfAnimals`
- RAG Gate：`tmp/rag/receipts/rag-gate.json`
- 请求上下文回执：`tmp/rag/receipts/tasks/REQ-COA-GIT-LOCK-AUDIT-20260726.json`

## 只读结论

1. 本地目录已经是 Git 仓库，分支为 `main`，但当前没有首个提交，也没有配置远端。
2. `git@github.com:BlacKKing4210/H
[chunk truncated by context budget]
