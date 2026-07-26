# RAG Context Pack: REQ-COA-F004-DESIGN-REBASELINE-CONTINUE-20260726

- Query: Continue F004-RESIDENT.1 V1.0 A-H design package complete for review Figma seat View blocked editable FigJam runtime false progress matrix superseded rules
- Feature IDs: F-004
- Index signature: `835285268b25ba121fe304c390dc30a8815c734f4ab2180c116ec428530991f0`
- Generated: 2026-07-26T06:34:04Z

Use these excerpts as grounded project evidence. Resolve conflicts through formal source authority; do not treat this pack as a new approval.

## 1. F004_RESIDENT_REBASELINE_RECEIPT — docs/receipts/F004-RESIDENT-DESIGN-REBASELINE-002.md

Citation: `F004_RESIDENT_REBASELINE_RECEIPT:lines 1-54` | authority `approved` | version `F004-RESIDENT.1-V1.0` | SHA-256 `90cecdd85f5808e1c5a870d9330dbe8ade080c85a3d1f2febed02174a1570b77` | chunk `337d07c149399e827febb4a8`

# F004-RESIDENT.1 设计重基线 V1.0 完成回执

- 项目：CityOfAnimals
- Feature：`F-004 / F004-RESIDENT.1`
- 现有任务：`F-004-RESIDENT-DESIGN-001`
- 请求：`REQ-COA-F004-DESIGN-REBASELINE-CONTINUE-20260726`
- 日期：2026-07-26
- 唯一 accountable producer / design owner：Codex `/root`
- 控制面动作：`continue_existing`
- 运行时权限：`false`
- 交付状态：`DESIGN PACKAGE COMPLETE FOR REVIEW / FIGMA BLOCKED`

## 1. RAG 与控制面

- 写入前项目 Gate：`READY`
- 写入前索引签名：`c204223feda828b1ce0d6fcf643a6002439d0f26d91a8c080875984005ab2f2d`
- 本请求 Context Receipt：`tmp/rag/receipts/tasks/REQ-COA-F004-DESIGN-REBASELINE-CONTINUE-20260726.json`
- Context citations：11
- 控制面：`READY / L3 / continue_existing`
- 任务去重：只命中同一个现有任务 `F-004-RESIDENT-DESIGN-001`
- 冲突任务：无
- 共享锁：无；`F004-DESIGN-LOCK-001` 已由 `F004-DESIGN-LOCK-RELEASE-002` 释放
- 最终 RAG 状态以本轮最后一次 `prepare` 后的 `tmp/rag/receipts/rag-gate.json` 和本请求 task receipt 为准。

本轮没有创建代理、子任务、线程、重复制作人或新的 Feature 身份。

## 2. A-H 完成结果

| 项目 | 结果 | 正式证据 |
|---|---|---|
| A. 只读基线与 RAG/控制面 | 完成 | 续接只读回执、本请求 RAG receipt、Active Scope、PM Handoff |
| B. 产品重基线 | 完成，待用户审阅 | `PD-002`、功能设计第 2–4 章 |
| C. 空间系统 | 完成，待用户批准占地目录 | 功能设计第 5 章 |
| D. 动物居民 UE 与状态机 | 完成，未实装 | 功能设计第 6–7 章、FigJam 可重放源 |
| E. 世界车辆订单 | 完成，未实装 | 功能设计第 8 章、FigJam 可重放源 |
| F. UI/UX 与视觉质量合同 | 内容完成；Figma 物质阻塞 | UI/UX 优先级、视觉质量合同、Figma 登记 |
| G. 推荐方案 | 完成 | 单一记忆点、代表性闭环、三个推荐默认值 |
| H. 进度与正式来源 | 完成 | 工作簿、Active Scope、Task Contract、PM Handoff、superseded 关系 |

## 3. 制作人设计判断

锁定单一记忆点：

> 动物不是按钮或加成，而是玩家看得见、会走路、会生活、会把小镇运转起来的居民。

减法目标：

- 取消常态逐次播种、收获、喂养、开机和收取；
- 玩家只做低频建造、邀请、派遣、道路与长期优先级调整；
- 不新增重复货币、常驻菜单或说明文字来包装订单。

代表性闭环：

`2×2 住房 → 一名居民 → 连通道路 → 1×1 田地或代表岗位 → 居民作业与搬运 →

## 2. F004_RESIDENT_SOURCE — docs/features/F-004-resident-town-spatial-autonomy.md

Citation: `F004_RESIDENT_SOURCE:lines 714-762` | authority `approved` | version `F004-RESIDENT.1-V1.0` | SHA-256 `c94599ace261771233ba6e39bea6d1a4f4a60ddeb601e5feb72ef9797cc27341` | chunk `218dbbd7dfcb248420adebce`

读回执、RAG task receipt | `READY`；无共享锁；正式基线干净；运行时未授权。 |
| B. 产品重基线 | 第 2–4 章、PD-002 | 完成，待用户审阅。 |
| C. 空间系统 | 第 5 章 | `1×1` 网格、占地、入口、道路、作业点、寻路、遮挡规则完成，待批准。 |
| D. 动物居民 UE 与状态机 | 第 6–7 章 | 完整覆盖建房至中断/恢复；配置和 QA 合同完成，未创建运行表。 |
| E. 世界车辆订单 | 第 8 章 | 到达、等待、装载、离场、失败/阻塞完成。 |
| F. 主页面 UI/UX 与视觉合同 | 第 9–10 章及两个附属正式来源 | 内容完成；可编辑 Figma/FigJam 仍是物质阻塞。 |
| G. 推荐方案 | 第 3–4、17 章 | 单一推荐方案和少数待确认默认值已给出。 |
| H. 进度矩阵与正式来源 | 第 16 章、Active Scope、PM Handoff、工作簿 | Feature 身份与 superseded 关系已同步；未误报 Ready。 |

## 17. 进度矩阵与正式来源状态

旧 `F004-DESIGN-LOCK-001` 已正式释放。当前正式来源按下列状态同步，不把静态文档或旧 22% 继承为新方向完成：

### F004 行

- Complete feature：`Animal Resident Town Spatial & Autonomy Foundation`
- Functional source：`docs/features/F-004-resident-town-spatial-autonomy.md`
- Numeric source：上述 `f004_resident_*.csv`（创建并验证后填写）
- Producer directive：`PRODUCT-REBASELINE.1`
- Design doc：90%，A-H 和文档包完成，但用户和 Figma 门通过前不写 100%
- Numeric table：0%，因为尚未创建新表
- Code/Scene/UI/Integration：0%
- Overall：10%，不沿用旧 22% 作为新版本完成度
- Current stage：`DESIGN PACKAGE COMPLETE / FIGMA BLOCKED`
- Next milestone：用户批准占地目录 + Figma/FigJam 可编辑交付
- Blocker：`BLOCKED: Figma UE attachment; runtime not authorized`

### Superseded 关系

- `F004-DISTRICT.1`：历史支持/迁移输入，不计入新 F004 完成度。
- 旧 F004 八表：保留文件与哈希，标记 `NOT_RUNTIME / MIGRATION_INPUT`，不删除。
- F003：保持 100% 历史可玩基线，不把其完成度继承到新 F004。
- F005：继续 0%，依赖新 F004 接受。

矩阵、Active Scope、PM Handoff、Task Contract 与索引在本轮按该状态收口；运行时权限仍为 `false`。

## 18. 当前 Gate 与待确认项

### 最高 Gate

`DESIGN_REBASELINE_REVIEW` + `VISUAL_CONTRACT_REVIEW`

### 仍未通过

- 用户尚未批准占地目录 V1.0；
- Figma/FigJam 尚未全部写入并读回；
- 新配置表未获授权、未创建；
- 没有新方向的 Godot 实装；
- 没有真实 720×1280

## 3. TASK_CONTRACT — docs/task_contract.md

Citation: `TASK_CONTRACT:lines 1-17` | authority `canonical` | version `v1` | SHA-256 `349e1fb386f2358b979efd3a53b725e409eef1f66933cf72020dd90deb4a495e` | chunk `3736639ccdc1bfe243f8d5e2`

# Current Execution Task Contract

F-004 has been formally rebaselined from `F004-DISTRICT.1` to `F004-RESIDENT.1`. The current task is design review and editable-design handoff only. Figma remains blocked and runtime implementation remains unauthorized.

- Task ID: `F-004-RESIDENT-DESIGN-001`.
- Version: `F004-RESIDENT.1`.
- Feature name: `Animal Resident Town Spatial & Autonomy Foundation`.
- Producer/design owner: Codex `/root`.
- Product decision: [PD-002 Animal Resident Town Rebaseline](decisions/PD-002-animal-resident-town-rebaseline.md).
- Design authorization: [PD-002 Read-only Receipt](receipts/PD-002-READ-ONLY.md).
- Current design receipt: [F004-RESIDENT-DESIGN-REBASELINE-002](receipts/F004-RESIDENT-DESIGN-REBASELINE-002.md).
- Formal output target: [F-004 Resident Town Spatial and Autonomy](features/F-004-resident-town-spatial-autonomy.md).
- Required handoff: approved `1x1` grid and footprint catalog, editable Figma/FigJam UE and state layouts, reviewed general-template DOCX/PDF, visual quality contract and milestone review.
- Current evidence: product rebaseline, spatial rules, resident/job state machine, vehicle-order UE, UI priority, visual contract, A-H completion audit and DOCX/PDF review package exist.
- Current blocker: `BLOCKED: Figma UE attachment`; local Mermaid sources, static figures and documents do not close this gate.
- Latest Figma diagnosis: `skyfire / Starter / seat=View`; target-file MCP transport failed, in-app browser load timed out, and the installed Chrome control channel was unavailable on 2026-07-26.
- Runtime exclusion: do not edit

## 4. F004_RESIDENT_FINAL_RECEIPT — docs/receipts/F004-RESIDENT-DESIGN-001.md

Citation: `F004_RESIDENT_FINAL_RECEIPT:lines 54-117` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `8eed6089a4695d8e1be3a9221707bf5a1eb87a474c7bc0068640a57a86ed5498` | chunk `1b33d9535a555291d1fdefad`

f` | `d1d1da21d64af9c2bb1a86038a58ca5c3045c24207262d4781de8f2f19022438` |

## 4. 设计覆盖

本轮完成并落盘：

- 产品感受、单一记忆点、核心循环、三层节奏和操作频率目标；
- 旧规则保留/删除/合并/覆盖关系；
- `1×1` 逻辑网格、田地/道路/建筑占地目录、合法性、入口、作业点、队列点、道路图、寻路、遮挡；
- 建房、邀请、入住、生活、派遣、行走、排队、作业、搬运、阻塞、中断/恢复；
- 世界车辆订单的到达、等待、承诺、装载、离场、冷却和阻塞状态；
- 主页面 P0–P3 信息层级、明确移除项、完整状态、触控、文本、可访问性；
- 原创 2D 卡通视觉质量合同、运行时分层、动效/声音职责、性能预算和反复制约束；
- 一个且仅一个代表性运行切片合同；
- 配置表、保存 schema、QA 和进度矩阵更新建议。

## 5. 文档 QA

- DOCX/PDF 均由通用正式功能设计模板生成。
- PDF：37 页，A4，Word 导出，带标签。
- Word 目录已更新，覆盖 1–3 级标题。
- Heading audit：`Heading 1 = 58`，`Heading 2 = 65`，无层级错误。
- Image audit：2 张真实旧运行基线截图，均为 inline。
- Accessibility audit：`high=0 / medium=0 / low=0`。
- 37 页已按联系表和附录交界逐页检查；未发现文字/表格越界、编号跨章节续号或空白页。
- 静态文档、PDF 与截图不等于运行时行为证据。

## 6. Figma Gate

- 目标 Design：`https://www.figma.com/design/uU2Oek5RqFb19CPoGl48lC/Untitled`
- 已有顶层页面读取历史证据，但当前具体元数据、FigJam 写入和收口 `whoami` 均遇到 `Transport send error`。
- 最近可验证席位信息为 Starter / `seat=View`。
- 本地 `.mmd` 仅是可重放草稿，不替代远端可编辑 Figma/FigJam 节点。

最终状态：

`BLOCKED: Figma UE attachment`

## 7. 最高 Gate

本轮最高达到：

- `DESIGN_REBASELINE_REVIEW`
- `VISUAL_CONTRACT_REVIEW`

尚未通过：

- `DESIGN_REBASELINE_APPROVED`
- `VISUAL_CONTRACT_APPROVED`
- `ASSET_SET_APPROVED`
- `RUNTIME_SLICE_APPROVED`
- `SCALE_OUT_APPROVED`
- `RELEASE_VISUAL_APPROVED`

## 8. 进度矩阵更新建议

在释放 `F004-DESIGN-LOCK-001` 并获得用户批准后，建议原子更新 `PM/feature_progress.xlsx`：

- F004 身份改为 `F004-RESIDENT.1`；
- Complete Feature：`Animal Resident Town Spatial & Autonomy Foundation`；
- Current Stage：`DESIGN REBASELINE / FIGMA PENDING`；
- Overall：不沿用旧 22% 作为新方向完成度；
- Design doc：在用户批准与 Figma 可编辑源通过前不写 100%；
- Numeric

## 5. F004_RESIDENT_STRUCTURED_DECISION — docs/receipts/F004-RESIDENT-DECISION-STRUCTURED.txt

Citation: `F004_RESIDENT_STRUCTURED_DECISION:lines 8-10` | authority `approved` | version `F004-RESIDENT.1` | SHA-256 `6dd28cda4d02cf39d6da078435a65ce87412c8a3cde49edf3dbd607738b7cf2b` | chunk `faafba75bda74de2e5a957c3`

R_RUNTIME; runtime_authority=false; requires user design review and editable Figma/FigJam write-readback before representative Godot slice
unresolved_producer_decisions: BLOCKED Figma UE attachment; user review of 1x1 footprint catalog V0.9 and recommended defaults for one main job per resident, bounded offline progress, and no hard MVP vehicle-order timer
reusable_method_candidate: false

## 6. ACTIVE_SCOPE — docs/active_scope.yaml

Citation: `ACTIVE_SCOPE:lines 39-70` | authority `canonical` | version `v1` | SHA-256 `4a97ef384371a227128c6a7a5752e6333a447efb0adb893b4f8074349776af0d` | chunk `66de9ac9dfc53335be483586`

tial and Autonomy Foundation
    version: F004-RESIDENT.1
    phase: DESIGN_REBASELINE_REVIEW
    state: DESIGN_PACKAGE_COMPLETE_FIGMA_BLOCKED_NOT_RUNTIME_AUTHORIZED
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
      - docs/receipts/F004-RESIDENT-CONTINUE-READ-ONLY-002.md
      - docs/features/F-003-farm-town-foundation-v2.md
      - docs/features/F-004-farm-district-industry-i.md
    authorization: docs/receipts/PD-002-READ-ONLY.md
    current_receipt: docs/receipts/F004-RESIDENT-DESIGN-REBASELINE-002.md
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
    producer_direction:

## 7. F004_RESIDENT_STRUCTURED_DECISION — docs/receipts/F004-RESIDENT-DECISION-STRUCTURED.txt

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

## 8. F004_RESIDENT_SOURCE — docs/features/F-004-resident-town-spatial-autonomy.md

Citation: `F004_RESIDENT_SOURCE:lines 681-718` | authority `approved` | version `F004-RESIDENT.1-V1.0` | SHA-256 `c94599ace261771233ba6e39bea6d1a4f4a60ddeb601e5feb72ef9797cc27341` | chunk `6cd7b80b7b23ad7a25d07955`

全等待并可定位原因。 |
| VO-08 | 中断/恢复 | 不复制货物、不重复奖励。 |

### 14.5 玩家可见视觉 QA

- 真实 Godot 720×1280 玩家视角，不以静态 Figma、窗口打开或 exit code 替代。
- 主页面不出现临时图、emoji、字母块、候选/NOT_RUNTIME 资源。
- 居民、道路、建筑入口、作业点和车辆在 50% 预览可读。
- 状态气泡预算满足，常态不出现菜单/感叹号海洋。
- zh-CN 与 en 不溢出。
- 触控区、安全区、焦点、reduced-motion、加载/空态/失败/中断全部验证。
- 帧率、内存、节点数、导航重建频率有行为级证据。

静态文档、PNG、Figma、配置校验、无头测试和退出码都不能关闭运行时 Gate。

## 15. Figma UE & UI/UX Artifact Register

| 图类型 | 可编辑源 | 页面/节点 | 版本 | Owner | 当前状态 | 覆盖 |
|---|---|---|---|---|---|---|
| 720×1280 主地图与组件 | [现有 Figma Design](https://www.figma.com/design/uU2Oek5RqFb19CPoGl48lC/Untitled) | 计划 `CityOfAnimals / F004-RESIDENT.1` | V1.0 | Codex `/root` | `BLOCKED: WRITE/READBACK` | 主地图、道路/住房/岗位/车辆、状态与 token |
| 代表性玩家 UE | 待生成 FigJam | 待登记 | V1.0 | Codex `/root` | `BLOCKED` | 建房—邀请—派遣—作业—装载—离场 |
| 居民状态机 | 待生成 FigJam | 待登记 | V1.0 | Codex `/root` | `BLOCKED` | 身份、日常任务、阻塞与恢复 |
| 车辆状态机 | 待生成 FigJam | 待登记 | V1.0 | Codex `/root` | `BLOCKED` | 到达、等待、装载、离场、失败 |
| 空间合法性流程 | 待生成 FigJam | 待登记 | V1.0 | Codex `/root` | `BLOCKED` | 占地、入口、道路、路径与事务 |

本地 Mermaid/SVG/PNG/PDF 只是草稿或预览；只有可编辑 Figma/FigJam 是最终 UI/UE 源。

2026-07-26 复核证据：Figma `whoami` 成功返回 `skyfire / Starter / seat=View`；对目标 Design 文件的只读 `use_figma` 调用在 MCP 传输层失败；内置浏览器打开目标文件超时；Chrome 扩展控制通道返回不可用。以上均不能证明节点可写或可读回，因此 Gate 必须保持阻塞。

## 16. A-H 设计重基线完成度

| 项目 | 正式来源 | 当前结论 |
|---|---|---|
| A. 只读基线与 RAG/控制面 | 本文、续接只读回执、RAG task receipt | `READY`；无共享锁；正式基线干净；运行时未授权。 |
| B. 产品重基线 | 第 2–4 章、PD-002 | 完成，待用户审阅。 |
| C. 空间系统 | 第 5 章 | `1×1` 网格、占地、入口、道路、作业点、寻路、遮挡规则完成，待批准。 |
| D. 动物居民 UE 与状态机 | 第 6–7 章 | 完整覆盖建房至中断/恢复；配置和 QA 合同完成，未创建运行表。 |
| E. 世界车辆订单 | 第 8 章 |

## 9. F004_RESIDENT_REBASELINE_RECEIPT — docs/receipts/F004-RESIDENT-DESIGN-REBASELINE-002.md

Citation: `F004_RESIDENT_REBASELINE_RECEIPT:lines 38-73` | authority `approved` | version `F004-RESIDENT.1-V1.0` | SHA-256 `90cecdd85f5808e1c5a870d9330dbe8ade080c85a3d1f2febed02174a1570b77` | chunk `021e12229864b6fec8c6bd63`

ct、PM Handoff、superseded 关系 |

## 3. 制作人设计判断

锁定单一记忆点：

> 动物不是按钮或加成，而是玩家看得见、会走路、会生活、会把小镇运转起来的居民。

减法目标：

- 取消常态逐次播种、收获、喂养、开机和收取；
- 玩家只做低频建造、邀请、派遣、道路与长期优先级调整；
- 不新增重复货币、常驻菜单或说明文字来包装订单。

代表性闭环：

`2×2 住房 → 一名居民 → 连通道路 → 1×1 田地或代表岗位 → 居民作业与搬运 → 一辆订单车装载并离场`

## 4. 正式来源与哈希

| 交付 | 路径 | SHA-256 |
|---|---|---|
| 产品决策 | `docs/decisions/PD-002-animal-resident-town-rebaseline.md` | `f27b1a6d5e5675c384928859a54832b736fe334f8185721fbcd21d2d3a171e3c` |
| 功能设计 V1.0 | `docs/features/F-004-resident-town-spatial-autonomy.md` | `c94599ace261771233ba6e39bea6d1a4f4a60ddeb601e5feb72ef9797cc27341` |
| UI/UX 优先级 V1.0 | `docs/uiux/F004-RESIDENT.1-ui-priority.md` | `178b1a4f237bd016956d04b235c85e0e12c155af27b6e8223ed278512b1ee785` |
| 视觉质量合同 V1.0 | `docs/design/F004-RESIDENT.1-visual-quality-contract.md` | `7fb3f8fd0ae5a9eeea20cd52b386be148b38ba76591252388275c5eea57f78f9` |
| Figma/FigJam 登记 | `output/figma/F004-RESIDENT.1/README.md` | `7015078a3a5a44fee9974f4d01aa3ef045af7262775e834351dacf91fd830b7c` |
| 可编辑 DOCX | `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V1.0_REVIEW.docx` | `17bdeed113bc5c9a74e1e09d1e1a9934c28fedd7e47a66dce4ad0197bc2b93f2` |
| 审阅 PDF | `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V1.0_REVIEW.pdf` | `94d0385ed90d6579c337b45943abe446d4ae645209186d2ef2d2e331353dd8ab` |
| 进度矩阵 | `PM/feature_progress.xlsx` | `591643b6c6ff0bdc17ce700ad49a0331203d8b725252009aaabe58e2275eeef4` |

## 5. 文档与工作簿 QA

- DOCX：821 个段落、26 张表、2 张旧方向真实运行基线截图。
- PDF：38 页，A4，Tagged，无加密、无 JavaScript、无可疑对象。
- 10 张 contact sheet

## 10. PRODUCT_REBASE_DECISION — docs/decisions/PD-002-animal-resident-town-rebaseline.md

Citation: `PRODUCT_REBASE_DECISION:lines 93-99` | authority `canonical` | version `PRODUCT-REBASELINE.1` | SHA-256 `f27b1a6d5e5675c384928859a54832b736fe334f8185721fbcd21d2d3a171e3c` | chunk `d79194b1ead7c477c8742bd9`

`
- 视觉质量合同：`docs/design/F004-RESIDENT.1-visual-quality-contract.md`
- 只读/控制面回执：`docs/receipts/PD-002-READ-ONLY.md`
- DOCX/PDF：`output/documents/F004-RESIDENT.1/`
- Figma/FigJam 登记与草稿源：`output/figma/F004-RESIDENT.1/`

下一阶段必须先由用户审阅设计重基线、占地目录和 Figma/FigJam；未获得运行时实装授权前，不修改 Godot。
