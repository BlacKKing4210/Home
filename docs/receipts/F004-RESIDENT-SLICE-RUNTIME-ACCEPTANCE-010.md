# F004-RESIDENT.1 代表性运行切片验收回执

**Receipt：** `F004-RESIDENT-SLICE-RUNTIME-ACCEPTANCE-010`
**日期：** 2026-07-26
**Feature：** F-004 / F004-RESIDENT.1
**Task：** F-004-RESIDENT-SLICE-001
**Owner / 制作人 / 工程 / 主美：** Codex `/root`
**状态：** `CLOSED / RUNTIME_SLICE_APPROVED`
**Scale-out：** `NOT AUTHORIZED`

## 结论

F004-RESIDENT.1 的唯一代表性闭环已完成正式运行验收。玩家以低频方式建造住房、邀请兔子居民并派岗；居民沿道路自动完成麦田作业、携带、工坊加工、装卸与回家；世界内订单车等待、装载、离场并结算。切片同时证明统一占地、动物居民存在感、低频操作、订单包装、正式资产、中文默认、英文选择、减弱动态、中断/恢复和保存恢复。

验收后：

- 未解决 `BLOCKER = 0`；
- 未解决 `MATERIAL = 0`；
- 最高门为 `RUNTIME_SLICE_APPROVED`；
- `SCALE_OUT_APPROVED = false`；
- F005～F010、更多建筑/居民和商业发行仍需独立授权。

## 正式来源

- 产品决定：`docs/decisions/PD-002-animal-resident-town-rebaseline.md`
- Penpot 决定：`docs/decisions/PD-003-penpot-editable-design-source.md`
- 功能设计：`docs/features/F-004-resident-town-spatial-autonomy.md`
- UI/UX 优先级：`docs/uiux/F004-RESIDENT.1-ui-priority.md`
- 视觉质量合同：`docs/design/F004-RESIDENT.1-visual-quality-contract.md`
- Penpot 登记：`output/penpot/F004-RESIDENT.1/README.md`
- 资产合同：`docs/art/F004-RESIDENT-SLICE.1-asset-contract.md`
- 工程写入授权：`docs/receipts/F004-RESIDENT-SLICE-ENG-READ-ONLY-008.md`
- 资产批准：`docs/receipts/F004-RESIDENT-SLICE-ASSET-APPROVAL-009.md`

## 玩家可见证据

- 证据索引：`docs/evidence/F004-RESIDENT.1/README.md`
- 对齐清单：`docs/evidence/F004-RESIDENT.1/runtime-parity-checklist.md`
- 720 × 1280 截图：`output/runtime/F004-RESIDENT.1/01-default-unbuilt.png` 至 `06-settings-en-reduced.png`
- 性能指标：`output/runtime/F004-RESIDENT.1/runtime-metrics.json`
- 真实主入口：`town_main.tscn` 的 `CityOfAnimals (DEBUG)` 窗口完成建造、邀请、派岗、自动生产、订单 `1/1`、金币 `40 → 120`、英文和减弱动态真实点击。

## 行为验收

Godot 4.6.2 正常渲染和无头回归均输出 `F004_RESIDENT_TESTS_PASSED`。行为覆盖精确占地、道路图、建造/邀请/派岗、道路阻塞恢复、装卸阻塞恢复、加工与原子结算、中途存档恢复、中文默认、英文和减弱动态持久化、运行资产数、设置触控入口及连续帧采样。最终详细模式回归在主动释放程序化音频播放对象后正常退出，不再出现 `ObjectDB instances leaked at exit`。

连续 120 帧实测 `164.69 FPS`，引擎采样 `74 FPS`，静态内存 `64,762,206 bytes`；超过视觉合同的 Windows 30 FPS 验收底线与 60 FPS 目标。

## 运行资产与原创安全

- 新增 6 个整套批准资产；复用 1 个项目自有批准兔子。
- 运行时只从 `approved/` 和登记的项目兔子路径加载。
- 资源 `source/`、`qa/`、候选板和处理脚本不进入玩家运行加载路径。
- 没有复制商业角色、Logo、地图、UI 布局、文案或数值。
- 活跃 F004 路径没有 Emoji、字母块、临时占位图或 `NOT_RUNTIME` 泄漏。

## 剩余边界

以下不影响本切片批准，但不能被误报为已完成：

- Penpot 云端 PNG 下载仍有浏览器传输错误；编辑源、对象级回读和本地同版本预览已验证，因此只属于归档限制。
- 大地图内容密度、更多居民日常、更多建筑族和铁路/空运尚未 scale-out。
- Android 真机、发行包、商店、服务器和公开部署未验收。

## 锁与清理

- 无共享文件锁、项目锁或运行锁。
- 本任务启动的验收窗口已关闭。
- 现有 CityOfAnimals 与 Fisher Godot 编辑器未终止。
- 没有安排本机关机；用户此前已明确停止关机任务。

## 制作人决定

批准 F004-RESIDENT.1 代表性运行切片，并允许把本切片验证过的网格、占地、居民任务、世界车辆订单、正式资产导入、原生 UI、动效与可访问性规则作为后续独立功能的输入。禁止在没有新的功能源、RAG/控制面回执与授权时批量扩面。
