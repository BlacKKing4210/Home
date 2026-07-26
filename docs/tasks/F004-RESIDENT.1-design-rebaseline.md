# F004-RESIDENT.1 设计重基线任务记录

**Task ID：** `F-004-RESIDENT-DESIGN-001`  
**Request ID：** `REQ-F004-RESIDENT-DESIGN-20260725`  
**Feature ID：** `F-004`  
**版本：** `F004-RESIDENT.1`  
**Owner：** Codex `/root`  
**状态：** `DESIGN_PACKAGE_V1_1_PENPOT_SOURCE_PENDING`
**Task fingerprint：** `BA4466ABDA82579862EA7476FF39D1A8B96ACB30A009EDCC85616914805E4897`  
**运行时权限：** `false`

## 正式输入

- `docs/decisions/PD-002-animal-resident-town-rebaseline.md`
- `docs/decisions/PD-003-penpot-editable-design-source.md`
- `docs/receipts/F004-RESIDENT-PENPOT-READ-ONLY-004.md`
- `docs/receipts/PD-002-READ-ONLY.md`
- `tmp/rag/receipts/rag-gate.json`
- `tmp/rag/receipts/tasks/REQ-F004-RESIDENT-DESIGN-20260725.json`
- `docs/features/F-003-farm-town-foundation-v2.md`
- `docs/features/F-004-farm-district-industry-i.md`（历史迁移输入）
- `PM/feature_progress.xlsx`（只读）

## 写集

- `docs/tasks/F004-RESIDENT.1-design-rebaseline.md`
- `docs/decisions/PD-002-animal-resident-town-rebaseline.md`
- `docs/receipts/PD-002-READ-ONLY.md`
- `docs/features/F-004-resident-town-spatial-autonomy.md`
- `docs/design/F004-RESIDENT.1-visual-quality-contract.md`
- `docs/uiux/F004-RESIDENT.1-ui-priority.md`
- `output/documents/F004-RESIDENT.1/`
- `output/penpot/F004-RESIDENT.1/`
- `output/figma/F004-RESIDENT.1/`（历史诊断与 Mermaid 草稿）
- `tmp/COA-RESIDENT-REBASE/`

## 完成条件

1. 产品、空间、居民、车辆、UI/UX 与视觉合同完整；
2. 通用模板 DOCX/PDF 生成并完成视觉检查；
3. Penpot 云端导入并对象级读回，或准确记录认证/连接依赖；
4. 旧 F004 的 superseded/migration 关系明确；
5. 不修改旧共享锁内文件；
6. 保留独立里程碑评审；
7. 不声明运行时完成。

## 当前控制面

- `status=READY`
- `execution_level=L3`
- `conflicting_task_ids=[]`
- `duplicate_task_ids=[]`
- `required_actions=[send_structured_decision_receipt_to_control_plane]`

`PD-003` 与结构化决策回执已写入；里程碑评审将在独立 Penpot handoff 回执中记录。该任务仍是原 `F-004-RESIDENT-DESIGN-001`，没有新建重复任务。
