# RAG Context Pack: REQ-COA-F004-PRODUCER-DIRECTION-REAFFIRMED-20260726

- Query: F004-RESIDENT.1 producer reaffirms unified 1x1 footprint grid regenerated buildings world vehicle orders final generated roads fields editable Figma UIUX animal residents walking working housing invitation slow simulation no runtime implementation before design approval
- Feature IDs: F-004
- Index signature: `e41b62315e0cba60e11e14a7c67f328a26061dbe8f7478ef02732110b29562aa`
- Generated: 2026-07-26T08:25:44Z

Use these excerpts as grounded project evidence. Resolve conflicts through formal source authority; do not treat this pack as a new approval.

## 1. F004_RESIDENT_STRUCTURED_DECISION — docs/receipts/F004-RESIDENT-DECISION-STRUCTURED.txt

Citation: `F004_RESIDENT_STRUCTURED_DECISION:lines 1-9` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `6dd28cda4d02cf39d6da078435a65ce87412c8a3cde49edf3dbd607738b7cf2b` | chunk `1b784f3fdd37379e1ff0beae`

feature_id: F-004 / F004-RESIDENT.1
decision_state: DESIGN_REBASELINE_REVIEW + VISUAL_CONTRACT_REVIEW
approved_rule: 玩家以低频建造、邀请、派遣和长期规划经营动物居民小镇；动物从住房沿道路到岗位完成实际工作；空间统一使用以 1x1 田地为最小单位的整数网格；订单以到达、等待、装载和离场的世界车辆表达。
superseded_rule: F004-DISTRICT.1 的频繁手动生产点击、固定功能位、分区面板和裸订单卡进入 REVISE_REQUIRED / SUPERSEDED_BY F004-RESIDENT.1 / MIGRATION_INPUT / NOT_RUNTIME。
formal_source_target: docs/features/F-004-resident-town-spatial-autonomy.md; docs/decisions/PD-002-animal-resident-town-rebaseline.md; docs/uiux/F004-RESIDENT.1-ui-priority.md; docs/design/F004-RESIDENT.1-visual-quality-contract.md
affected_domains: product; game-design; spatial-grid; building-placement; road-network; resident-ai; job-scheduling; vehicle-orders; ui-ux; visual-quality; configuration; save-recovery; qa
affected_files: docs/decisions/PD-002-animal-resident-town-rebaseline.md; docs/receipts/PD-002-READ-ONLY.md; docs/features/F-004-resident-town-spatial-autonomy.md; docs/uiux/F004-RESIDENT.1-ui-priority.md; docs/design/F004-RESIDENT.1-visual-quality-contract.md; docs/tasks/F004-RESIDENT.1-design-rebaseline.md; output/figma/F004-RESIDENT.1/README.md; output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V0.9_REVIEW.docx; output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V0.9_REVIEW.pdf
execution_readiness: NOT_READY_FOR_RUNTIME; runtime_authority=false; requires user design review and editable Figma/FigJam write-readback before representative Godot slice
unresolved_producer_decisions: BLOCKED Figma UE attachment; user review of 1x1 footprint catalog V0.9

## 2. F004_RESIDENT_REAFFIRMED_DECISION — docs/receipts/F004-RESIDENT-PRODUCER-REAFFIRM-003.txt

Citation: `F004_RESIDENT_REAFFIRMED_DECISION:lines 1-10` | authority `approved` | version `F004-RESIDENT.1-V1.0` | SHA-256 `33e142f5a5824fdd3bfafebc00ccceba072ddfc18c94332db60a6abbdaf0b64c` | chunk `b16d5e2895bc9eb22a8090d6`

feature_id: F-004 / F004-RESIDENT.1
decision_state: APPROVED_PRODUCT_DIRECTION / DESIGN_DETAILS_REVIEW_PENDING / FIGMA_BLOCKED / NOT_RUNTIME
approved_rule: 田地、道路和建筑统一使用以1x1田地为最小单位的整数占地；订单由世界车辆到达、等待、装载、完成和离场表达；主页面道路、田地和需重做建筑使用原创正式资产并先通过UIUX、可编辑Figma与视觉质量流程；动物作为居民承担全部建筑实际操作并沿道路通勤；住房、邀请、入住、生活、工作和长期规划组成慢节奏小镇体验。
superseded_rule: 旧方向的频繁逐次生产点击、裸订单功能卡、临时主页面资源、按现有贴图反推占地以及把动物当按钮或加成的表达继续保持REVISE_REQUIRED / SUPERSEDED / NOT_RUNTIME。
formal_source_target: docs/features/F-004-resident-town-spatial-autonomy.md; docs/decisions/PD-002-animal-resident-town-rebaseline.md; docs/active_scope.yaml; docs/task_contract.md; docs/PM_HANDOFF.md
affected_domains: product; game-design; spatial-grid; building-footprints; road-network; resident-ai; housing-invitation; job-scheduling; vehicle-orders; ui-ux; visual-quality; asset-production; configuration; save-recovery; qa
affected_files: docs/features/F-004-resident-town-spatial-autonomy.md; docs/active_scope.yaml; docs/task_contract.md; docs/PM_HANDOFF.md; knowledge/knowledge_manifest.csv; knowledge/golden_queries.csv
execution_readiness: READY_FOR_DESIGN_REVIEW_CONTINUATION_ONLY; exact footprint catalog, editable Figma/FigJam, configuration schemas and representative runtime slice remain unapproved; runtime_authority=false
unresolved_producer_decisions: approve exact V1.0 footprint catalog and recommended defaults after editable Figma/FigJam review; restore edit-capable Figma write-readback
reusable_method_candidate: none

## 3. F004_RESIDENT_STRUCTURED_DECISION — docs/receipts/F004-RESIDENT-DECISION-STRUCTURED.txt

Citation: `F004_RESIDENT_STRUCTURED_DECISION:lines 8-10` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `6dd28cda4d02cf39d6da078435a65ce87412c8a3cde49edf3dbd607738b7cf2b` | chunk `faafba75bda74de2e5a957c3`

R_RUNTIME; runtime_authority=false; requires user design review and editable Figma/FigJam write-readback before representative Godot slice
unresolved_producer_decisions: BLOCKED Figma UE attachment; user review of 1x1 footprint catalog V0.9 and recommended defaults for one main job per resident, bounded offline progress, and no hard MVP vehicle-order timer
reusable_method_candidate: false

## 4. TASK_CONTRACT — docs/task_contract.md

Citation: `TASK_CONTRACT:lines 1-16` | authority `canonical` | version `v1` | SHA-256 `770e9020108e0878fde16660ebbf1bc71dc20560eb4dda6f15d209f647258ca0` | chunk `4815292651da00127d693b6e`

# Current Execution Task Contract

F-004 has been formally rebaselined from `F004-DISTRICT.1` to `F004-RESIDENT.1`. The current task is design review and editable-design handoff only. Figma remains blocked and runtime implementation remains unauthorized.

- Task ID: `F-004-RESIDENT-DESIGN-001`.
- Version: `F004-RESIDENT.1`.
- Feature name: `Animal Resident Town Spatial & Autonomy Foundation`.
- Producer/design owner: Codex `/root`.
- Product decision: [PD-002 Animal Resident Town Rebaseline](decisions/PD-002-animal-resident-town-rebaseline.md).
- Producer direction reaffirmation: [F004-RESIDENT Producer Reaffirmation](receipts/F004-RESIDENT-PRODUCER-REAFFIRM-003.txt); the five product principles are approved, while the exact footprint catalog and recommended defaults remain under review.
- Design authorization: [PD-002 Read-only Receipt](receipts/PD-002-READ-ONLY.md).
- Current design receipt: [F004-RESIDENT-DESIGN-REBASELINE-002](receipts/F004-RESIDENT-DESIGN-REBASELINE-002.md).
- Formal output target: [F-004 Resident Town Spatial and Autonomy](features/F-004-resident-town-spatial-autonomy.md).
- Required handoff: approved `1x1` grid and footprint catalog, editable Figma/FigJam UE and state layouts, reviewed general-template DOCX/PDF, visual quality contract and milestone review.
- Current evidence: product rebaseline, spatial rules, resident/job state machine, vehicle-order UE, UI priority, visual contract, A-H completion audit and DOCX/PDF review package exist.
- Current blocker: `BLOCKED: Figma UE attachment`; local Mermaid sources, static figures and documents do not

## 5. TASK_CONTRACT — docs/task_contract.md

Citation: `TASK_CONTRACT:lines 15-21` | authority `canonical` | version `v1` | SHA-256 `770e9020108e0878fde16660ebbf1bc71dc20560eb4dda6f15d209f647258ca0` | chunk `f431aa217b5861c15fd32776`

esident/job state machine, vehicle-order UE, UI priority, visual contract, A-H completion audit and DOCX/PDF review package exist.
- Current blocker: `BLOCKED: Figma UE attachment`; local Mermaid sources, static figures and documents do not close this gate.
- Latest Figma diagnosis: `skyfire / Starter / seat=View`; target-file MCP transport failed, in-app browser load timed out, and the installed Chrome control channel was unavailable on 2026-07-26.
- Runtime exclusion: do not edit Godot scenes, scripts, tests, save data, `project.godot`, runtime assets or create new F004 configuration tables under this task.
- Engineering gate: user approval of the detailed footprint catalog/recommended defaults and verified editable Figma/FigJam write-readback must pass before a new representative-slice read-only receipt can authorize runtime work.
- Superseded source: `F004-DISTRICT.1` and its eight CSVs are preserved as historical migration input and are not runtime authority.
- Baseline: [F-003 Farm Foundation V2](features/F-003-farm-town-foundation-v2.md) and [F-003 FARM.2 Acceptance](receipts/F-003-FARM2-ENG-002.md) remain the accepted playable prototype evidence only.

## 6. PM_HANDOFF — docs/PM_HANDOFF.md

Citation: `PM_HANDOFF:lines 1-23` | authority `approved` | version `v1` | SHA-256 `0a934e22abc73b97b09d55dbf32bf9a7fdc3ac63a5134e0255e4b88c9d1517f8` | chunk `1e0e83e72acb8ea8d1496643`

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

`PD-002` has formally rebaselined F-004 to `F004-RESIDENT.1`: players make low-frequency building, invitation, assignment and planning decisions while visible animal residents walk along roads, work, carry goods and live in the town. On 2026-07-26 the producer reaffirmed all five high-level principles: unified integer footprints based on the `1×1` field unit, world vehicle orders, formal original main-map assets after UI/UX design, animal residents executing building work, and a slow housing/invitation/life/work loop. The representative loop is one house, one resident, one road segment, one field or workplace and one vehicle order. Version 1.0 of the A-H design package, UI priority source, visual quality contract and DOCX/PDF review package is complete for detailed review, but the exact footprint catalog/defaults and editable Figma/FigJam source are still pending/blocked. No Godot runtime or new F004 configuration write is authorized. F003-FARM.2 remains the accepted playable

## 7. CONFIG_INDEX — docs/config_index.md

Citation: `CONFIG_INDEX:lines 1-8` | authority `approved` | version `v1` | SHA-256 `562982a7fa52a7662127d10ea47df41a5863a2862602a8e6995cee929eb4c3cd` | chunk `8470d8938ebf61a2b1c1c7ae`

# Numeric And Configuration Index

| Feature ID | Configuration source | Runtime target | Status |
|---|---|---|---|
| F-004 | No current `F004-RESIDENT.1` configuration tables are authorized yet. Proposed sources must cover grid/footprints, roads/work points, residents/housing, jobs/queues, workplaces/production, vehicle orders and locale/state feedback after design approval. | Not assigned; runtime work remains unauthorized | `0%` numeric-table implementation for the new direction. Exact schemas and filenames remain design proposals until the footprint catalog and editable Figma/FigJam gate are approved. |
| F-004-HIST | `config/tables/f004_districts.csv`, `f004_sites.csv`, `f004_items.csv`, `f004_sources.csv`, `f004_animals.csv`, `f004_recipes.csv`, `f004_requests.csv`, and `f004_locale.csv` | Historical design only; not assigned to runtime | Superseded `F004-DISTRICT.1` migration input. Its validator remains `PASS`, but the tables do not define the resident autonomy, road graph, footprint, work-point or world-vehicle contracts required by `F004-RESIDENT.1`. |
| F-003 | `config/tables/f003_v2_items.csv`, `f003_v2_crops.csv`, `f003_v2_storage.csv`, `f003_v2_recipes.csv`, `f003_v2_animals.csv`, `f003_v2_buildings.csv`, `f003_v2_requests.csv`, `f003_v2_world.csv`, and `f003_v2_locale.csv` | `scripts/town/farm2_config.gd`, `farm2_model.gd`, `farm2_text.gd`, `farm2_save.gd`, and `farm2_view.gd` | Runtime-integrated and acceptance-tested in `docs/receipts/F-003-FARM2-ENG-002.md`; the active main scene uses FARM.2. |
| F-003-HIST | `config/tables/f003_farm_content.csv`

## 8. FEATURE_PROGRESS — PM/feature_progress.xlsx

Citation: `FEATURE_PROGRESS:sheet Nine Dimensions, chars 5410-7004` | authority `approved` | version `v1` | SHA-256 `591643b6c6ff0bdc17ce700ad49a0331203d8b725252009aaabe58e2275eeef4` | chunk `85c115ecc0d3e24a46e0d050`

y
F-003	Animal Town Farm Foundation V2	Original animal-town farm production foundation	docs/features/F-003-farm-town-foundation-v2.md	config/tables/f003_v2_items,crops,storage,recipes,animals,buildings,requests,world,locale.csv	F003-FARM.2: 12 plots, animal care, machine queues, requests, market, and a draggable 1800 x 1700 town	P0	1	1	1	1	1	1	1	1	1	1	ACCEPTED PLAYABLE PROTOTYPE	Codex /root	Start F-004 formal design intake	F003-FARM2-ENG-002: five real 720 x 1280 captures, 26 runtime assets, behavior tests and normal startup passed; no F-004 runtime authority
F-004	Animal Resident Town Spatial & Autonomy Foundation	Producer-approved resident-town rebaseline	docs/features/F-004-resident-town-spatial-autonomy.md	Pending F004-RESIDENT.1 grid, resident, job, workplace, vehicle-order and locale schemas after design approval	PD-002 / F004-RESIDENT.1: visible animal residents walk roads, live, work, carry goods and fulfill world-vehicle orders	P0	0.9	0	0	0	0	0	0	0	0	0.1	DESIGN PACKAGE COMPLETE / FIGMA BLOCKED	Codex /root	User reviews the V1.0 footprint catalog and recommended defaults; restore edit-capable Figma/FigJam write-readback before runtime authorization	A-H design rebaseline, UI/UX priority, visual contract and DOCX/PDF package complete for review. BLOCKED: Figma UE attachment (skyfire Starter seat=View; MCP transport failed; browser/Chrome control unavailable). Runtime not authorized; old F004-DISTRICT.1 remains historical migration input.
F-005	Rail Freight Yard	Original farm-town roadmap	docs/roadmaps/PLAN-001-original-farm-town-content-ladder.md	Pending dedicated

## 9. F004_RESIDENT_SOURCE — docs/features/F-004-resident-town-spatial-autonomy.md

Citation: `F004_RESIDENT_SOURCE:lines 453-500` | authority `approved` | version `F004-RESIDENT.1-V1.0` | SHA-256 `3110de889fa248e758bf7ede50c55150fd7b135ea7ef60a12d890c2a285a8073` | chunk `71f936c662fc82e05f108c71`

ntract.md`

### 9.1 主页面层级

- P0：居民路径/动作/阻塞，建筑入口/岗位，车辆装载。
- P1：住房/岗位空位、仓储容量、车辆等待。
- P2：选中对象的成本、输入、产出、时长、优先级。
- P3：履历、统计、设置和完整说明。

### 9.2 无临时资源验收规则

以下路径禁止出现 emoji、字母块、灰色占位、未批准候选或整页截图 UI：

- 主页面制作人评审；
- Figma style frame 的“正式视觉”帧；
- 720×1280 玩家视角截图/视频；
- 代表性切片行为验收；
- 对外包、发布或扩面做出的视觉批准。

机械测试可使用 dev-only 占位，但必须：

- 位于不进入玩家入口的测试场景；
- 标记 `DEV_ONLY / NOT_RUNTIME`;
- 不出现在玩家可见验收证据；
- 不提升任何视觉 Gate。

### 9.3 Godot UI 合同

- 使用引擎原生 `Control`、Theme、容器、动态文本与本地化键。
- 不用扁平全屏截图假装 UI。
- 动效只改视觉子节点，不改布局、触控、焦点、碰撞或逻辑坐标。
- 所有主组件覆盖 default、selected、pressed、disabled、loading、empty、success、failure、blocked、interrupted、reduced-motion。

## 10. 配置与数据来源

本节是待批准的新表合同，不代表文件已创建。

| 建议文件 | 核心字段 | 职责 |
|---|---|---|
| `f004_resident_world.csv` | `key,value` | 网格投影、世界边界、导航、同屏预算、离线参数。 |
| `f004_resident_footprints.csv` | `footprint_id,w,h,category,rotatable,clearance_rule` | 统一占地目录。 |
| `f004_resident_buildings.csv` | `building_id,footprint_id,asset_id,entrance,workpoints,job_slots,storage_links` | 建筑、住房、岗位与资产关联。 |
| `f004_resident_roads.csv` | `road_id,terrain_rule,connection_mask,asset_set,cost` | 道路形态、连接与建造。 |
| `f004_resident_workpoints.csv` | `workpoint_id,building_id,kind,offset,queue_offsets,capacity` | 入口、作业、输入、输出、装卸与队列。 |
| `f004_resident_animal_types.csv` | `animal_type_id,silhouette,size,visible_trait,risk_note` | 动物类型，不存职业上限。 |
| `f004_resident_roles.csv` | `role_id,tasks,workplace,plain_name,satire_boundary` | 日常职业/社会身份。 |
| `f004_resident_characters.csv` | `character_id,animal_type_id,name,training,experience,interest,asset_id` | 个体居民。 |
| `f004_resident_role_castings.csv` |

## 10. F004_DESIGN_RECEIPT — docs/receipts/F-004-DESIGN-001.md

Citation: `F004_DESIGN_RECEIPT:lines 62-86` | authority `approved` | version `F004-DISTRICT.1` | SHA-256 `8a9912c63b9383390f0f5cfdadc63af76cd9bccb580cae1b0588bab33f98e790` | chunk `c62b081ef9233a451d4a4386`

e key, URL, page and node references in the feature document.

## Explicit exclusions

- No Godot scene, script, test, `project.godot`, save data or runtime-asset write.
- No F-005 rail freight, F-006 town services, F-007 air cargo or F-008 land expansion implementation.
- No copied commercial-game art, map, UI layout, text, names, recipes, values, code or proprietary assets.
- No agent creation, server work, deployment, monetization or external publication.

## Design acceptance gates

- General feature document contains one player-facing memory point and at least five observable rules.
- UI priority is recorded before drawing, including entry, exit, loading, empty, disabled, failure, success and interrupted states.
- Player UE, system/state flow and 720 x 1280 screen layouts are editable in Figma/FigJam and their node references are verified.
- All eight F-004 CSVs have exact field contracts, locale coverage and passing cross-reference validation.
- DOCX and PDF are generated from the approved content and pass visual inspection.
- A separate milestone review confirms commercial safety, F-003 compatibility, implementation readiness and continued runtime gating.

## Runtime authority

This receipt a
[chunk truncated by context budget]
