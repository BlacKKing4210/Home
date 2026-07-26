# F004-RESIDENT-DESIGN-001 正式决策与设计重基线回执

**项目：** CityOfAnimals  
**Feature：** `F-004 / F004-RESIDENT.1`  
**任务：** `F-004-RESIDENT-DESIGN-001`  
**日期：** 2026-07-25  
**唯一 accountable producer：** Codex `/root`  
**请求类型：** `producer_decision` + formal design rebaseline  
**任务指纹：** `BA4466ABDA82579862EA7476FF39D1A8B96ACB30A009EDCC85616914805E4897`  
**运行时权限：** `false`

## 1. 正式决策

CityOfAnimals 的 F004 产品方向重建为：

> 玩家规划一座真正有动物居民生活和工作的慢节奏小镇；玩家进行低频建造、邀请、派遣与长期规划，动物从住房沿道路走到建筑执行实际工作。

单一玩家记忆点：

> **动物不是按钮或加成，而是玩家看得见、会走路、会生活、会把小镇运转起来的居民。**

代表性闭环固定为：

`2×2 住房 → 邀请 1 名动物 → 道路通勤 → 1×1 田地/2×2 岗位 → 居民自动作业与搬运 → 订单车装载并离场`

旧 `F004-DISTRICT.1` 的手动生产点击、固定功能位、分区面板与裸订单卡不再是当前产品方向，状态建议为：

`REVISE_REQUIRED / SUPERSEDED_BY F004-RESIDENT.1 / MIGRATION_INPUT / NOT_RUNTIME`

F003 仅保留为历史可玩基线和可复用技术/资产来源，不证明新方向完成。

## 2. 只读基线与控制面

- 项目 RAG 已建立：`knowledge/knowledge_manifest.csv`、`knowledge/rag_config.json`、`knowledge/golden_queries.csv`。
- 项目 Gate：`tmp/rag/receipts/rag-gate.json`；最终状态必须以该文件的独立校验结果为准。
- 请求 Context Receipt：`tmp/rag/receipts/tasks/REQ-F004-RESIDENT-DESIGN-20260725.json`。
- 控制面 Intake：`tmp/COA-RESIDENT-REBASE/control-plane-document-intake.json`。
- 正式任务记录：`docs/tasks/F004-RESIDENT.1-design-rebaseline.md`。
- 旧设计锁：`F004-DESIGN-LOCK-001` 仍保护旧 F004 文档/配置、Active Scope、Task Contract、Profile、索引、PM Handoff 和进度工作簿。
- 工作区原本存在大量未跟踪/脏文件；本轮未清理、重置、覆盖无关内容。
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

只有以上设计门通过并获得运行时实装授权后，才能创建新配置表、修改 Godot 或制作一个代表性运行切片。批量重做道路、田地、建筑、居民和其他页面仍禁止。
