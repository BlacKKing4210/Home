# F004-RESIDENT.1 玩家可见与行为级证据

**Feature：** F-004 / F004-RESIDENT.1
**证据日期：** 2026-07-26
**引擎：** Godot `4.6.2-stable.official.71f334935`
**画布：** 720 × 1280 竖屏
**最高门：** `RUNTIME_SLICE_APPROVED`
**完成回执：** `docs/receipts/F004-RESIDENT-SLICE-RUNTIME-ACCEPTANCE-010.md`

## 玩家可见闭环

本切片只验证一个代表性闭环：玩家建造 `2x2` 居民住房，邀请一名兔子居民并派岗；兔子沿 `1x1` 道路前往 `1x1` 麦田作业，把产物送入 `2x2` 谷仓工坊，再将订单货箱送至 `3x2` 装卸场；等待中的订单车完成装载、离场并结算奖励，兔子回家休息。

玩家只执行建造、邀请、派岗与调整道路等低频决策。生产、搬运、装载和离场由动物居民与世界内车辆可见地完成。

## 真实 720 × 1280 运行画面

| 证据 | 玩家可见内容 | SHA-256 |
|---|---|---|
| `output/runtime/F004-RESIDENT.1/01-default-unbuilt.png` | 默认中文、明确占地网格、待建 `2x2` 住房、等待车辆与单一主操作 | `021D1A922D124E4A5B92C247B394FCFA66CFA4834F09737D006D2D0A9770079B` |
| `output/runtime/F004-RESIDENT.1/02-resident-invited.png` | 住房建成、兔子入住、派岗入口 | `0A8343DED55970F65E1C1D72FD9A96D975FBEE847EA7EF399C9CFE4CA88B435D` |
| `output/runtime/F004-RESIDENT.1/03-road-blocked.png` | 道路关闭标记、居民等待、世界与信息卡双重阻塞反馈 | `7186AF83E79E52669357FF8BD94C8A71CF49B853EA8EBEDFD40E16A191E2E96D` |
| `output/runtime/F004-RESIDENT.1/04-field-work.png` | 居民到达麦田并进行有剩余时间的可见作业 | `C11353EA9F913DCCB088739C6BE39882A27F91C327FC5D9C84F32C34BA8BEF35` |
| `output/runtime/F004-RESIDENT.1/05-order-success.png` | 货车装载完成、奖励反馈、订单 `1/1`、居民回家 | `1BA1FA6B8EBE871AABA0D2AD9941F972B96D8D040CFA63039ECCCF3674756A21` |
| `output/runtime/F004-RESIDENT.1/06-settings-en-reduced.png` | 英文运行界面与减弱动态设置 | `01F036734548F2C7F86CE532E2F765B71BEDB615B704D343FDB7F74826A738AB` |

这些图片由 Godot 正常 OpenGL 兼容渲染路径在固定 720 × 1280 `SubViewport` 中生成，不是 Penpot 静态设计稿或整屏运行贴图。

## 真实主入口桌面交互

2026-07-26 从项目真实 `town_main.tscn` 启动 `CityOfAnimals (DEBUG)`，使用干净验收参数避免读取历史存档，并逐步执行真实窗口点击：

1. 点击“建造”：金币 `180 → 60`，半透明占地预览替换为正式住房。
2. 点击“发出邀请”：金币 `60 → 40`，兔子居民在住房前出现。
3. 点击“安排岗位”：兔子沿道路移动到麦田，状态变为“正在收割”。
4. 不再点击生产按钮：兔子自动完成田地、工坊、装卸场和回家流程；订单从 `0/1 → 1/1`，金币 `40 → 120`，车辆离场。
5. 点击设置：中英文切换成功；减弱动态切换成功。

该验收窗口由本任务启动并在验收后单独关闭；现有 CityOfAnimals 与 Fisher Godot 编辑器均未终止。

## 行为与状态证据

`tests/test_f004_resident_scene.gd` 在 Godot 4.6.2 中通过全部断言并输出 `F004_RESIDENT_TESTS_PASSED`。覆盖：

- 精确占地、道路图和无重叠校验；
- 建造、邀请、派岗与资源扣除；
- 道路阻塞、中断、恢复；
- 麦田作业、携带、工坊加工、装卸和车辆离场；
- 装卸容量阻塞且不吞货，解除后继续；
- 中途保存、重新加载和剩余时间恢复；
- 中文默认、英文与减弱动态持久化；
- 真实视图加载 6 个批准切片资产和 1 个项目批准兔子资产；
- 720 × 1280 设置触控入口；
- 正常渲染画面和连续帧性能采样。

## 性能与运行预算

`output/runtime/F004-RESIDENT.1/runtime-metrics.json`：

- 连续 120 帧实测：`164.69 FPS`；
- 引擎采样：`74 FPS`；
- 静态内存：`64,762,206 bytes`；
- 节点数：`4`；
- 当前帧渲染对象：`416`；
- 目标画布：`720 × 1280`；
- 指标文件 SHA-256：`A9D9C044452ACC05FE29BCF0397FDB21995E80C7B42CA799DDB258727E4F9D43`。

该结果超过视觉质量合同的 Windows 验收底线 30 FPS 与目标 60 FPS。它是本机 Windows OpenGL 代表切片证据，不等同于 Android 真机性能或发行包验收。

## 资产路径审计

- 运行时只加载 `assets/runtime/f004_resident_slice/approved/` 下的 6 个批准资产和已登记的项目兔子。
- `source/` 与 `qa/` 只存在于资产清单的溯源字段中，运行脚本与场景没有加载它们。
- 活跃 F004 场景、脚本、配置和测试中未发现商业参考项目名、未批准占位图、Emoji 或 `NOT_RUNTIME` 资源路径。
- 历史 F001/F003 配置仍保留旧 `emoji` 字段，但不属于 F004 活跃运行路径。

## 验收边界

`RUNTIME_SLICE_APPROVED` 只批准这一代表性闭环及其复用规则，不自动批准批量建筑生成、更多居民、F-005～F-010、Android 包、真机触控、公开部署或商业发行。大地图内容密度和更多生活行为属于后续独立 scale-out 工作。
