# RAG Context Pack: REQ-F004-RESIDENT-DESIGN-20260725

- Query: CityOfAnimals F004 animal resident slow town design rebaseline grid footprints roads resident autonomous jobs vehicle orders UI UX visual contract structured decision receipt Figma blocked runtime not authorized
- Feature IDs: F-004
- Index signature: `47cb307149578242fc1c43206cfd20dba366f596165310c90973de54f8eb14c0`
- Generated: 2026-07-25T16:15:15Z

Use these excerpts as grounded project evidence. Resolve conflicts through formal source authority; do not treat this pack as a new approval.

## 1. PRODUCT_REBASE_DECISION — docs/decisions/PD-002-animal-resident-town-rebaseline.md

Citation: `PRODUCT_REBASE_DECISION:lines 93-99` | authority `canonical` | version `PRODUCT-REBASELINE.1` | SHA-256 `f27b1a6d5e5675c384928859a54832b736fe334f8185721fbcd21d2d3a171e3c` | chunk `d79194b1ead7c477c8742bd9`

`
- 视觉质量合同：`docs/design/F004-RESIDENT.1-visual-quality-contract.md`
- 只读/控制面回执：`docs/receipts/PD-002-READ-ONLY.md`
- DOCX/PDF：`output/documents/F004-RESIDENT.1/`
- Figma/FigJam 登记与草稿源：`output/figma/F004-RESIDENT.1/`

下一阶段必须先由用户审阅设计重基线、占地目录和 Figma/FigJam；未获得运行时实装授权前，不修改 Godot。

## 2. F004_RESIDENT_STRUCTURED_DECISION — docs/receipts/F004-RESIDENT-DECISION-STRUCTURED.txt

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

## 3. F004_RESIDENT_FINAL_RECEIPT — docs/receipts/F004-RESIDENT-DESIGN-001.md

Citation: `F004_RESIDENT_FINAL_RECEIPT:lines 40-64` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `8eed6089a4695d8e1be3a9221707bf5a1eb87a474c7bc0068640a57a86ed5498` | chunk `1e98d08ef425684dd7a41496`

本存在大量未跟踪/脏文件；本轮未清理、重置、覆盖无关内容。
- 本轮未修改 Godot、旧 `config/tables/f004_*.csv`、`docs/active_scope.yaml`、`docs/task_contract.md`、`docs/project_profile.yaml`、`PM/feature_progress.xlsx`。

## 3. 本轮正式来源

| 交付 | 路径 | SHA-256 |
|---|---|---|
| 产品重基线决策 | `docs/decisions/PD-002-animal-resident-town-rebaseline.md` | `f27b1a6d5e5675c384928859a54832b736fe334f8185721fbcd21d2d3a171e3c` |
| 只读回执 | `docs/receipts/PD-002-READ-ONLY.md` | `f7d84031f58123e75e38bdd28ef5ec58787945fff6fde4ab282b4a44d321d9c7` |
| 通用功能策划案 Markdown 源 | `docs/features/F-004-resident-town-spatial-autonomy.md` | `3115e1fce3bdae6c8d1e9b2e44b8ab716f41298a2d18541a84cdbb688f63c737` |
| UI/UX 优先级 | `docs/uiux/F004-RESIDENT.1-ui-priority.md` | `9b3e08cb86c204ede367ac399d8f8b619724996b0975926b0ba1f4c242a421ab` |
| 视觉质量合同 | `docs/design/F004-RESIDENT.1-visual-quality-contract.md` | `baccbf15c0a5b94d23fb62b4479670702a3248518660dfee4bcdbee32afb99b7` |
| Figma/FigJam 登记 | `output/figma/F004-RESIDENT.1/README.md` | `b1bf7973b5bc48109d965cbd50584a0b767c4ef76cd21a6edd7b2469a8c0d403` |
| 正式 DOCX | `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V0.9_REVIEW.docx` | `ebace7363fbe9fbcd4c559c893a40a37ba1655ab85f5eca1cf881bcb4eb5ef33` |
| 审阅 PDF | `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V0.9_REVIEW.pdf` | `d1d1da21d64af9c2bb1a86038a58ca5c3045c24207262d4781de8f2f19022438` |

## 4. 设计覆盖

本轮完成并落盘：

- 产品感受、单一记忆点、核心循环、三层节奏和操作频率目标；
- 旧规则保留/删除/合并/覆盖关系；
- `1×1` 逻辑网格、田地/道路/建筑占地目录、合法性、入口、作业点、队列点、道路图、寻路、遮挡；
- 建房、邀请、入住、生活、派遣、行走、排队、作业、搬运、阻塞、中断/恢复；
-

## 4. PRODUCT_REBASE_DECISION — docs/decisions/PD-002-animal-resident-town-rebaseline.md

Citation: `PRODUCT_REBASE_DECISION:lines 55-99` | authority `canonical` | version `PRODUCT-REBASELINE.1` | SHA-256 `f27b1a6d5e5675c384928859a54832b736fe334f8185721fbcd21d2d3a171e3c` | chunk `c2e31bfbc30f4a80ab483654`

的输入/输出约束；不要求玩家逐次点击启动和收取。 |
| F003/F004 物品与建筑 ID | 迁移输入 | 经过占地、作业点、视觉质量和新状态机审核后决定复用/改造/废弃。 |
| 玩家直接播种、收获、喂养、开始机器、点击成品收取 | 删除为默认主循环 | 由已派遣居民在资源和道路条件满足时自动执行；玩家只调整岗位与优先级。 |
| 委托板/订单卡作为主要表达 | 合并到车辆订单 | 订单信息可在选中车辆时显示，常态以车辆和装载物表达。 |
| F004 分区营建板 | 降级/待重审 | 如保留，只用于长期规划，不承担日常生产操作或成为常驻主菜单。 |
| F004 固定功能位 | 取消为默认 | 改为网格合法放置；仅剧情/地标可使用固定位置。 |
| 手动收取是普遍契约 | 删除 | 常规产出由居民搬运；仓储满或装载点阻塞才保留世界内待处理状态。 |
| F003-VQ.1 收获飞入 HUD | 保留为历史反馈方法 | 新方向优先显示居民搬运和车辆装载；HUD 飞行只作短反馈，不替代世界因果。 |
| 临时 UI、字母块、占位图可进入主页面评审 | 局部覆盖为禁止 | 模拟经营主页面玩家可见评审、截图和运行验收只接受正式/批准资产。 |

## Feature 身份建议

推荐把当前 `F-004` 重建为：

- **Feature ID：** `F-004`
- **版本：** `F004-RESIDENT.1`
- **名称：** `动物居民小镇：空间秩序与自主作业基础`
- **旧版本关系：** `F004-DISTRICT.1 -> REVISE_REQUIRED / SUPERSEDED_BY F004-RESIDENT.1`
- **依赖：** F003 只作为旧方向可玩基线、资产和技术来源
- **下游：** F005 铁路货运必须改为建立在车辆装载、道路网络和居民搬运之上
- **当前阶段：** `DESIGN_REBASELINE_REVIEW`
- **运行时权限：** `false`

不新建 F011。F004 是矩阵中最高优先级且尚未进入运行时的功能；直接重建其版本关系最能保持路线清晰，也避免旧 F004 与新基础并行争夺同一产品位置。

## 少数待确认事项

以下不阻塞本次设计评审，均已给出推荐默认值：

1. **岗位控制粒度：** 推荐“一名居民同一工作时段只有一个主岗位”，不做 RTS 式连续点选移动。
2. **离线推进：** 推荐离线只结算已排定、路径已验证、输入已保留的工作块；玩家回到游戏后先表现一次有限的返场/交付，不让居民在镜头前瞬移。
3. **订单超时：** 推荐 MVP 无硬失败倒计时；玩家可主动谢绝，车辆空驶离开并在稍后刷新，保持慢节奏。

只有用户明确反对以上推荐时才改向；其余细节由制作人在正式设计和后续代表性切片中继续收敛。

## 正式来源与下一步

- 完整功能设计：`docs/features/F-004-resident-town-spatial-autonomy.md`
- UI/UX 优先级：`docs/uiux/F004-RESIDENT.1-ui-priority.md`
- 视觉质量合同：`docs/design/F004-RESIDENT.1-visual-quality-contract.md`
- 只读/控制面回执：`docs/receipts/PD-002-READ-ONLY.md`
- DOCX/PDF：`output/documents/F004-RESIDENT.1/`
- Figma/FigJam 登记与草稿源：`output/figma/F004-RESIDENT.1/`

下一阶段必须先由用户审阅设计重基线、占地目录和

## 5. F004_RESIDENT_SOURCE — docs/features/F-004-resident-town-spatial-autonomy.md

Citation: `F004_RESIDENT_SOURCE:lines 467-499` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `3115e1fce3bdae6c8d1e9b2e44b8ab716f41298a2d18541a84cdbb688f63c737` | chunk `35c83d496f8c34ecc1855214`

布或扩面做出的视觉批准。

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
| `f004_resident_role_castings.csv` | `character_or_type,role_id,mode,reason,work_method,skill_source,risk_control,status` | 多对多角色映射与伦理审核。 |
| `f004_resident_jobs.csv` | `job_id,building_id,task_type,input,output,duration,priority,transport_rule` | 可自动执行的岗位任务。 |
| `f004_resident_schedules.csv` |

## 6. F004_RESIDENT_STRUCTURED_DECISION — docs/receipts/F004-RESIDENT-DECISION-STRUCTURED.txt

Citation: `F004_RESIDENT_STRUCTURED_DECISION:lines 8-10` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `6dd28cda4d02cf39d6da078435a65ce87412c8a3cde49edf3dbd607738b7cf2b` | chunk `faafba75bda74de2e5a957c3`

R_RUNTIME; runtime_authority=false; requires user design review and editable Figma/FigJam write-readback before representative Godot slice
unresolved_producer_decisions: BLOCKED Figma UE attachment; user review of 1x1 footprint catalog V0.9 and recommended defaults for one main job per resident, bounded offline progress, and no hard MVP vehicle-order timer
reusable_method_candidate: false

## 7. F004_RESIDENT_SOURCE — docs/features/F-004-resident-town-spatial-autonomy.md

Citation: `F004_RESIDENT_SOURCE:lines 686-727` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `3115e1fce3bdae6c8d1e9b2e44b8ab716f41298a2d18541a84cdbb688f63c737` | chunk `f533833dfb1bb3cad1af405d`

- 居民、道路、建筑入口、作业点和车辆在 50% 预览可读。
- 状态气泡预算满足，常态不出现菜单/感叹号海洋。
- zh-CN 与 en 不溢出。
- 触控区、安全区、焦点、reduced-motion、加载/空态/失败/中断全部验证。
- 帧率、内存、节点数、导航重建频率有行为级证据。

静态文档、PNG、Figma、配置校验、无头测试和退出码都不能关闭运行时 Gate。

## 15. Figma UE & UI/UX Artifact Register

| 图类型 | 可编辑源 | 页面/节点 | 版本 | Owner | 当前状态 | 覆盖 |
|---|---|---|---|---|---|---|
| 720×1280 主地图与组件 | [现有 Figma Design](https://www.figma.com/design/uU2Oek5RqFb19CPoGl48lC/Untitled) | 计划 `CityOfAnimals / F004-RESIDENT.1` | V0.9 | Codex `/root` | `PENDING WRITE/READBACK` | 主地图、道路/住房/岗位/车辆、状态与 token |
| 代表性玩家 UE | 待生成 FigJam | 待登记 | V0.9 | Codex `/root` | `PENDING` | 建房—邀请—派遣—作业—装载—离场 |
| 居民状态机 | 待生成 FigJam | 待登记 | V0.9 | Codex `/root` | `PENDING` | 身份、日常任务、阻塞与恢复 |
| 车辆状态机 | 待生成 FigJam | 待登记 | V0.9 | Codex `/root` | `PENDING` | 到达、等待、装载、离场、失败 |
| 空间合法性流程 | 待生成 FigJam | 待登记 | V0.9 | Codex `/root` | `PENDING` | 占地、入口、道路、路径与事务 |

本地 Mermaid/SVG/PNG/PDF 只是草稿或预览；只有可编辑 Figma/FigJam 是最终 UI/UE 源。

## 16. 进度矩阵与正式来源更新建议

在释放旧 `F004-DESIGN-LOCK-001` 并获得用户批准后，建议一次性同步：

### F004 行

- Complete feature：`Animal Resident Town Spatial & Autonomy Foundation`
- Functional source：`docs/features/F-004-resident-town-spatial-autonomy.md`
- Numeric source：上述 `f004_resident_*.csv`（创建并验证后填写）
- Producer directive：`PRODUCT-REBASELINE.1`
- Design doc：在用户和 Figma 门通过前保持审阅中，不写 100%
- Numeric table：0%，因为尚未创建新表
- Code/Scene/UI/Integration：0%
- Overall：不沿用旧 22% 作为新版本完成度
- Current stage：`DESIGN REBASELINE / FIGMA PENDING`
- Next milestone：用户批准占地目录 + Figma/FigJam 可编辑交付
- Blocker：`BLOCKED: Figma UE attachment; runtime not authorized`

### Superseded 关系

-

## 8. F004_RESIDENT_SOURCE — docs/features/F-004-resident-town-spatial-autonomy.md

Citation: `F004_RESIDENT_SOURCE:lines 719-758` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `3115e1fce3bdae6c8d1e9b2e44b8ab716f41298a2d18541a84cdbb688f63c737` | chunk `09cfe235508b15871ab9c1b4`

de/Scene/UI/Integration：0%
- Overall：不沿用旧 22% 作为新版本完成度
- Current stage：`DESIGN REBASELINE / FIGMA PENDING`
- Next milestone：用户批准占地目录 + Figma/FigJam 可编辑交付
- Blocker：`BLOCKED: Figma UE attachment; runtime not authorized`

### Superseded 关系

- `F004-DISTRICT.1`：历史支持/迁移输入，不计入新 F004 完成度。
- 旧 F004 八表：保留文件与哈希，标记 `NOT_RUNTIME / MIGRATION_INPUT`，不删除。
- F003：保持 100% 历史可玩基线，不把其完成度继承到新 F004。
- F005：继续 0%，依赖新 F004 接受。

在当前锁未释放前，本轮只给出同步建议，不修改矩阵、Active Scope、PM Handoff、Task Contract 或索引。

## 17. 当前 Gate 与待确认项

### 最高 Gate

`DESIGN_REBASELINE_REVIEW` + `VISUAL_CONTRACT_REVIEW`

### 仍未通过

- 用户尚未批准占地目录 V0.9；
- Figma/FigJam 尚未全部写入并读回；
- 新配置表未获授权、未创建；
- 没有新方向的 Godot 实装；
- 没有真实 720×1280 新切片；
- `ASSET_SET_APPROVED`、`RUNTIME_SLICE_APPROVED`、`SCALE_OUT_APPROVED` 均未通过。

### 推荐默认值

1. 一名居民每个工作时段一个主岗位；
2. 不做 RTS 式持续指挥；
3. 常规产出自动搬运，满仓时世界内阻塞；
4. 订单无硬超时，允许谢绝；
5. 逻辑四向道路，等距绘制；
6. 占地目录按本文 V0.9 进入 Figma 评审。

用户批准本文和 Figma/FigJam 后，再创建新的工程只读回执与配置合同；没有新的运行时授权，不进入 Godot。

## 9. PD002_READ_ONLY_RECEIPT — docs/receipts/PD-002-READ-ONLY.md

Citation: `PD002_READ_ONLY_RECEIPT:lines 1-47` | authority `approved` | version `PRODUCT-REBASELINE.1` | SHA-256 `f7d84031f58123e75e38bdd28ef5ec58787945fff6fde4ab282b4a44d321d9c7` | chunk `971c5d0b3014e0cdc38be300`

# PD-002 动物居民小镇产品重基线——只读与控制面回执

**日期：** 2026-07-25  
**请求 ID：** `REQ-COA-RESIDENT-TOWN-REBASE-20260725`  
**决策版本：** `PRODUCT-REBASELINE.1`  
**执行级别：** `L3`（跨系统正式设计；当前唯一制作人直接执行，不创建代理、子任务或线程）  
**唯一 accountable producer：** Codex `/root`  
**状态：** `READY_FOR_DESIGN_REBASELINE_ONLY`  
**运行时权限：** `false`

## 1. RAG Gate

- 项目 Gate：`tmp/rag/receipts/rag-gate.json`
- 本请求 Context Receipt：`tmp/rag/receipts/tasks/REQ-COA-RESIDENT-TOWN-REBASE-20260725.json`
- 上下文包：`tmp/rag/context/REQ-COA-RESIDENT-TOWN-REBASE-20260725.md`
- 状态：`READY`
- 活跃来源：46
- 稳定分块：263
- 黄金问题：15 / 15
- `mean_recall_at_k=1.0`
- `pass_rate=1.0`
- 索引签名：`884171f0cf2bbd63b3b5332fda89abbea0c19f6b429bf1d8221b36c0fdf1b44e`
- Context Receipt 引用数：8；均带 source ID、路径、定位器、版本与 SHA-256。

本次判断以项目正式来源与上述请求上下文为依据；旧聊天摘要不作为项目权威。

## 2. 控制面结果

- 输入：`tmp/COA-RESIDENT-REBASE/control-plane-intake.json`
- 检查器：最新版 `game-project-control-plane`
- 结果：`READY`
- 路由：`design_owner`
- 执行层级：`L3`
- 冲突任务：0
- 重复任务：0
- 必需动作：`send_structured_decision_receipt_to_control_plane`
- 状态沉淀：`formal_source_and_structured_decision_receipt`

本轮写集与 `F004-DESIGN-LOCK-001` 不相交。现有锁内文件、八张 `f004_*.csv`、`PM/feature_progress.xlsx`、`docs/active_scope.yaml`、`docs/task_contract.md`、各索引与旧 F004 文档包均保持只读。

## 3. 只读基线

| 对象 | 当前正式状态 | 本次处理 |
|---|---|---|
| `F003-FARM.2` | `ACCEPTED PLAYABLE PROTOTYPE` | 只保留为旧方向可玩证据、真实画面基线与可复用技术/资产来源；不把其手动生产规则当作新方向授权。 |
| `F003-VQ.1` | `RUNTIME_SLICE_APPROVED`，`SCALE_OUT_APPROVED=false` | 保留采收反馈与性能方法证据；旧记忆点与高频采收动作不向新方向扩面。 |
| `F004-DISTRICT.1` | 设计/配置/DOCX/PDF 通过，`BLOCKED: Figma UE attachment`，`runtime_authority=false` | 记录为 `REVISE_REQUIRED /

## 10. F004_RESIDENT_SOURCE — docs/features/F-004-resident-town-spatial-autonomy.md

Citation: `F004_RESIDENT_SOURCE:lines 412-481` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `3115e1fce3bdae6c8d1e9b2e44b8ab716f41298a2d18541a84cdbb688f63c737` | chunk `a66449df84ac2a685b3ca53e`

1. 地图边缘出现车辆即将到达的轻提示。
2. 车辆沿道路进入装卸场，减速并停靠。
3. 货箱或装卸架显示 1–3 种需求物和容量，不展示整页卡片。
4. 玩家点车辆查看简短需求，并选择“承诺”或“谢绝”。
5. 承诺后，符合条件的产出配送优先级提高；居民自动搬运。
6. 每次装载都在世界内显示货物进入货箱。
7. 装满后车辆进入完成状态，短鸣笛并开走。
8. 奖励在车辆越过离场检查点后一次发放；HUD 只做短确认。

### 8.3 状态机

| 状态 | 世界表现 | 允许动作 | 出口 |
|---|---|---|---|
| `OFF_MAP_SCHEDULED` | 地图边缘到达提示 | 无 | 到时进入 |
| `APPROACHING` | 车辆沿入口道路行驶 | 观察 | 到达泊位 |
| `DOCKING` | 减速、对齐装卸场 | 无 | 停靠 |
| `WAITING_DECISION` | 司机/货箱等待 | 承诺/谢绝 | `WAITING_GOODS` / `DEPARTING_EMPTY` |
| `WAITING_GOODS` | 货箱显示缺口 | 定位来源/谢绝 | 货物到达/取消 |
| `LOADING` | 居民与货物进入装卸动作 | 观察 | 继续等待/装满 |
| `READY_TO_DEPART` | 满载、完成灯/旗 | 无 | 短延时 |
| `DEPARTING` | 鸣笛、沿路离开 | 观察 | 离场检查点 |
| `REWARDED` | HUD 奖励确认 | 无 | 冷却 |
| `COOLDOWN` | 装卸位空 | 无 | 安排下一辆 |
| `BLOCKED` | 泊位/道路/装卸点异常 | 定位/修路/清理 | 条件恢复 |

### 8.4 失败与慢节奏

- MVP 不使用硬失败倒计时。
- 玩家可谢绝订单；车辆空驶离开，不扣罚资源，稍后刷新。
- 车辆等待不冻结小镇，也不弹强制模态。
- 道路被删除或泊位占用时，车辆停在入口安全点，不穿越建筑。
- 奖励以 `order_instance_id` 幂等；中断恢复不重复。

## 9. UI/UX 与视觉质量

完整 UI/UX：`docs/uiux/F004-RESIDENT.1-ui-priority.md`  
视觉合同：`docs/design/F004-RESIDENT.1-visual-quality-contract.md`

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
- 所有主组件覆盖

## 11. F004_RESIDENT_FINAL_RECEIPT — docs/receipts/F004-RESIDENT-DESIGN-001.md

Citation: `F004_RESIDENT_FINAL_RECEIPT:lines 110-135` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `8eed6089a4695d8e1be3a9221707bf5a1eb87a474c7bc0068640a57a86ed5498` | chunk `8c5618f4b213cbac425c8bfb`

：

- F004 身份改为 `F004-RESIDENT.1`；
- Complete Feature：`Animal Resident Town Spatial & Autonomy Foundation`；
- Current Stage：`DESIGN REBASELINE / FIGMA PENDING`；
- Overall：不沿用旧 22% 作为新方向完成度；
- Design doc：在用户批准与 Figma 可编辑源通过前不写 100%；
- Numeric table：`0%`，因为新配置表尚未获授权创建；
- Code/Scene/UI/Integration：`0%`；
- Next milestone：用户批准占地目录与可编辑 Figma/FigJam；
- Blocker：`BLOCKED: Figma UE attachment; runtime not authorized`；
- `F004-DISTRICT.1`：保留历史/迁移输入，标记被 `F004-RESIDENT.1` 覆盖，不删除；
- F005：继续保持 roadmap-only，依赖 F004 代表性运行切片通过。

工作簿本轮只读，未写入。

## 9. 下一步授权边界

下一步只请求用户审阅：

1. 单一记忆点与低频规划方向；
2. `1×1` 网格和占地目录 V0.9；
3. “一名居民一个主岗位”、有限离线推进、MVP 订单无硬倒计时三个推荐默认值；
4. Figma/FigJam 可编辑交付恢复。

只有以上设计门通过并获得运行时实装授权后，才能创建新配置表、修改 Godot 或制作一个代表性运行切片。批量重做道路、田地、建筑、居民和其
[chunk truncated by context budget]
