# F004-RESIDENT.1 代表性运行切片工程只读收据

- 日期：2026-07-26
- 制作人 / 工程 owner / 美术 owner：Codex `/root`
- Feature：`F-004`
- Task：`F-004-RESIDENT-SLICE-001`
- 版本：`F004-RESIDENT.1`
- 状态：`READY`
- 执行级别：`L3`，由现有唯一 `engineering_owner` 承担；未创建代理、子任务或线程

## RAG

- Gate：`knowledge/index/rag-gate.json`
- Gate 状态：`READY`
- 评估：22/22 黄金问题通过，平均 Recall@K 1.0
- 索引签名：`8c8434e58058e9617309623f1b24c685de7680f1dec67dae2d88151cbcc7f3f9`
- 任务收据：`knowledge/index/task-receipts/REQ-F004-RESIDENT-SLICE-ENG3-20260726.json`
- 任务引用：9 条，包含当前产品决策、F004-RESIDENT.1 功能源与视觉质量合同

## 控制面

- 检查状态：`READY`
- Route owner：`engineering_owner`
- Action：`activate_role_owner`
- Fingerprint：`F298F639BB1607B9C2833F90E6085541FB84E33F32A46BEC2C8C7C451625E0A9`
- Duplicate：无
- Conflict：无
- Shared/project lock：无
- 必须保留独立里程碑评审；本收据不等于验收。

## 唯一代表性闭环

住房 `2x2` + 一名兔子居民 + `1x1` 道路 + `1x1` 田地 + `2x2` 代表性工作建筑 + `3x2` 装卸场 + 一辆世界内订单车。

玩家只进行低频建造、邀请和派遣。居民自行出门、沿路通勤、工作、搬运；订单车到达、等待、装载并离开。切片必须覆盖断路/阻塞、中断/恢复、成功、设置、中文默认、英文切换和 reduced-motion。

## 精确写集

- `config/tables/f004_resident_grid.csv`
- `config/tables/f004_resident_types.csv`
- `config/tables/f004_resident_jobs.csv`
- `config/tables/f004_resident_workplaces.csv`
- `config/tables/f004_vehicle_orders.csv`
- `config/tables/f004_vehicle_routes.csv`
- `config/tables/f004_resident_locale.csv`
- `scripts/town/f004_resident_config.gd`
- `scripts/town/f004_resident_model.gd`
- `scripts/town/f004_resident_save.gd`
- `scripts/town/f004_resident_text.gd`
- `scripts/town/f004_resident_view.gd`
- `scenes/town_main.tscn`
- `tests/test_f004_resident_scene.gd`
- `assets/runtime/f004_resident_slice/`
- `docs/art/F004-RESIDENT-SLICE.1-asset-contract.md`
- `docs/evidence/F004-RESIDENT.1/`
- `docs/receipts/F004-RESIDENT-SLICE-*`
- `docs/active_scope.yaml`
- `docs/task_contract.md`
- `docs/PM_HANDOFF.md`
- `docs/config_index.md`
- `docs/design_index.md`
- `PM/feature_progress.xlsx`

## 验收边界

- 玩家可见主页面不得出现 emoji、字母块、灰框或未批准占位资源。
- 新资产必须先通过一套整体评审板，再从批准像素进入 runtime 路径。
- 运行 UI 使用 Godot 原生控件/绘制、动态文本和响应式输入，不使用整屏截图。
- 静态图、Penpot、文件存在、测试通过或退出码 0 均不能单独证明完成。
- 只有真实 720×1280 玩家视角证据、行为级闭环、状态覆盖、回归和零 BLOCKER/MATERIAL 后，才可到 `RUNTIME_SLICE_APPROVED`。
- 不在本任务批量扩展 F-005 至 F-010，也不执行关机。
