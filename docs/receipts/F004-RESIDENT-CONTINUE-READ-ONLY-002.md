# F004-RESIDENT.1 设计重基线继续执行只读回执

- 项目：CityOfAnimals
- Feature：`F-004 / F004-RESIDENT.1`
- 现有任务：`F-004-RESIDENT-DESIGN-001`
- 本次请求：`REQ-COA-F004-DESIGN-REBASELINE-CONTINUE-20260726`
- 日期：2026-07-26
- 唯一 accountable producer / design owner：Codex `/root`
- 控制面动作：`continue_existing`
- 执行级别：`L3`
- 状态：`READY FOR DESIGN-ONLY CONTINUATION`
- 运行时权限：`false`

## 1. RAG 与控制面

- Project Gate：`tmp/rag/receipts/rag-gate.json`
- Project Gate 状态：`READY`
- Index signature：`c204223feda828b1ce0d6fcf643a6002439d0f26d91a8c080875984005ab2f2d`
- 本请求 Context Receipt：`tmp/rag/receipts/tasks/REQ-COA-F004-DESIGN-REBASELINE-CONTINUE-20260726.json`
- Context citation count：`11`
- 控制面检查：`READY`
- 控制面 `task_action`：`continue_existing`
- 重复任务：仅命中同一现有任务 `F-004-RESIDENT-DESIGN-001`，未创建新任务
- 冲突任务：无

## 2. 已加载的强制流程

- `city-of-animals-project-adapter`
- `game-project-rag`
- `game-studio-orchestrator`
- `game-project-control-plane`
- `lean-game-design-director`
- `ui-design-priority`
- `game-visual-quality-pipeline`
- `game-feature-design-docs`
- `codex-game-studio-default`

补充交付流程：Figma/FigJam、Documents、PDF、Spreadsheets。没有创建代理、子任务、线程或第二制作人。

## 3. 当前正式状态

- `PD-002` 已批准产品方向进入设计重基线。
- A-H 的 Markdown 设计主体、UI/UX 优先级、视觉质量合同、37 页 DOCX/PDF 评审包和四份可重放 Mermaid 草稿已经存在。
- F004 当前最高阶段仍是 `DESIGN_REBASELINE_REVIEW + VISUAL_CONTRACT_REVIEW`。
- `F004-DESIGN-LOCK-001` 已于 2026-07-26 正式释放；`docs/active_scope.yaml::shared_locks` 为空。
- `F004-DISTRICT.1` 及其八张旧配置表保留为 `MIGRATION_INPUT / NOT_RUNTIME`。
- F003-FARM.2 仅保留为已验收可玩原型基线，不证明新方向完成。
- 当前唯一材料性缺口是可编辑 Figma/FigJam 的创建、节点读回、制作人审阅登记，以及由此触发的 DOCX/PDF/正式来源同步。

## 4. 当前工作区

- Git HEAD：`9fb0dc63595ce841528546c5474425d0bcc95702`
- 正式项目文件无未提交修改。
- 本次 RAG 上下文和任务回执为新增审计文件。
- `.git/*.lock`：无。
- CityOfAnimals Godot 编辑器进程为用户现有会话，不构成 Git 或正式设计文件锁；本次不修改 Godot，不结束该进程。

## 5. 基线哈希

| 路径 | SHA-256 |
|---|---|
| `docs/decisions/PD-002-animal-resident-town-rebaseline.md` | `f27b1a6d5e5675c384928859a54832b736fe334f8185721fbcd21d2d3a171e3c` |
| `docs/features/F-004-resident-town-spatial-autonomy.md` | `3115e1fce3bdae6c8d1e9b2e44b8ab716f41298a2d18541a84cdbb688f63c737` |
| `docs/uiux/F004-RESIDENT.1-ui-priority.md` | `9b3e08cb86c204ede367ac399d8f8b619724996b0975926b0ba1f4c242a421ab` |
| `docs/design/F004-RESIDENT.1-visual-quality-contract.md` | `baccbf15c0a5b94d23fb62b4479670702a3248518660dfee4bcdbee32afb99b7` |
| `output/figma/F004-RESIDENT.1/README.md` | `b1bf7973b5bc48109d965cbd50584a0b767c4ef76cd21a6edd7b2469a8c0d403` |
| `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V0.9_REVIEW.docx` | `ebace7363fbe9fbcd4c559c893a40a37ba1655ab85f5eca1cf881bcb4eb5ef33` |
| `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V0.9_REVIEW.pdf` | `d1d1da21d64af9c2bb1a86038a58ca5c3045c24207262d4781de8f2f19022438` |
| `PM/feature_progress.xlsx` | `64c9ddfe7ada9646576f4894299938f2658835968571279e9e717abd0ddece33` |

## 6. 本次授权写集

- F004 当前功能、UI/UX、视觉合同与交付登记
- `output/figma/F004-RESIDENT.1/`
- `output/documents/F004-RESIDENT.1/`
- 项目进度矩阵、Active Scope、Task Contract、索引与 PM Handoff
- 本次正式回执与必要的 RAG 清单/黄金查询/回执

排除：Godot 场景、脚本、测试、运行时资源、`project.godot`、新 F004 配置表、批量生图或批量建筑重做。

## 7. 继续执行判定

`READY FOR DESIGN-ONLY CONTINUATION`

下一步先验证 Figma 写入能力。若写入与读回成功，则创建可编辑主地图/状态设计和四张 FigJam 流程，更新 Artifact Register 与文档包；若仍不可用，必须保留 `BLOCKED: Figma UE attachment`，不得误报设计门通过。
