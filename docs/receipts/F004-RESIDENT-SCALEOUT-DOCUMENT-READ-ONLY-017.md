# F004-RESIDENT.2 文档打包只读回执

**Receipt:** `F004-RESIDENT-SCALEOUT-DOCUMENT-READ-ONLY-017`
**日期：** 2026-07-27
**Request：** `REQ-F004-RESIDENT2-DOCUMENT-CLOSE-20260727`
**Feature / Version：** `F-004.2 / F004-RESIDENT.2 V1.2`
**唯一 accountable producer / documentation owner：** Codex `/root`

## 1. RAG 与控制面

- 项目 RAG：`READY`
- Gate：`knowledge/index/rag-gate.json`
- Task receipt：`knowledge/index/task-receipts/REQ-F004-RESIDENT2-DOCUMENT-CLOSE-20260727.json`
- Context pack：`knowledge/index/context/REQ-F004-RESIDENT2-DOCUMENT-CLOSE-20260727.md`
- Index signature：`1c787d8d8f1b6485b877a2c51356861f6452181ab51b4d72133d41e06b190422`
- Golden query mean recall@k：`1.0`
- Golden query pass rate：`1.0`

本次引用覆盖 F004.2 正式功能设计、PD-004 制作人决策、PD-002 产品重基线、PD-003 Penpot 正式设计源、只读基线、视觉质量合同、资产合同及既有运行验收边界。

## 2. 只读基线

- F004.2 已达到 `RUNTIME_SLICE_APPROVED / SCALE_OUT_APPROVED`。
- 运行验收：`docs/receipts/F004-RESIDENT-SCALEOUT-RUNTIME-ACCEPTANCE-016.md`。
- 玩家可见证据：`docs/evidence/F004-RESIDENT.2/README.md`。
- Penpot 已认证保存、重开并完成对象级回读。
- 91 项 F004.2 行为断言、F004.1/F003/镇区回归、720×1280 真实渲染、性能和 approved-only 资源检查已经通过。
- 当前没有工程、资产、Penpot、WPS 或导入写锁。正在打开的 Godot 编辑器属于用户交互进程，不是项目写锁，不会关闭。

## 3. 本阶段唯一写集

允许：

- `output/documents/F004-RESIDENT.2/`
- `docs/receipts/F004-RESIDENT-SCALEOUT-DOCUMENT-018.md`
- 本阶段必要的 `docs/active_scope.yaml`、`docs/PM_HANDOFF.md`、`docs/task_contract.md`
- 最终 RAG 同步所需的 `knowledge/knowledge_manifest.csv`、`knowledge/golden_queries.csv` 与生成索引/回执

不允许：

- 修改 F004.1 已验收代码、配置、资源和证据；
- 修改 F004.2 已验收运行逻辑、配置数值或 approved 资源；
- 开始 F-005 或后续功能；
- 批量生成新建筑、角色或页面；
- 关闭用户 Godot 编辑器、启动关机任务或部署服务器。

## 4. 文档验收

1. 使用通用正式功能设计模板生成可编辑 DOCX。
2. 同时输出 PDF 审阅版。
3. 文档包含 Penpot 可编辑源登记、真实运行截图、配置表目录、状态/行为验收和明确非完成边界。
4. PDF 逐页渲染并进行视觉 QA；无截断、空白异常、图片溢出或不可读表格。
5. DOCX/PDF 记录 SHA-256、页数和视觉 QA 结果。
6. 完成后归还文档锁，并在最终索引源更新后重新 prepare RAG。

## 5. 临时锁

- Lock：`F004-RESIDENT-SCALEOUT-DOC-LOCK-005`
- Owner：Codex `/root`
- Write set：仅第 3 节列出的文档、正式状态与 RAG 收尾文件
- Release condition：DOCX/PDF 生成与视觉 QA 通过、正式回执落盘、最终 RAG `READY`
