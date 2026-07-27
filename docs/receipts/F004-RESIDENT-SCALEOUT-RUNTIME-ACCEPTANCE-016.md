# F004-RESIDENT.2 运行时验收与工程锁归还回执

**Receipt：** `F004-RESIDENT-SCALEOUT-RUNTIME-ACCEPTANCE-016`
**日期：** 2026-07-27
**Request：** `REQ-F004-RESIDENT2-ENGINEERING-20260727`
**Feature / Version：** `F-004.2 / F004-RESIDENT.2 V1.2`
**Task：** `F-004-RESIDENT-SCALEOUT-002`
**唯一 accountable producer / engineering owner：** Codex `/root`

## 1. 结论

`RUNTIME_SLICE_APPROVED / SCALE_OUT_APPROVED`

F004.2 的代表性扩面切片已经真实实现并通过行为、玩家可见画面、性能、资源隔离和回归验收。`SCALE_OUT_APPROVED` 只允许后续功能复用本切片的空间、居民、车辆、UI、资产和 QA 规则；不表示全量建筑或后续运输系统已经完成。

## 2. 玩家可见完成项

1. 玩家实际放置 `1×1` 道路生活点、`2×2` 第二住房、`3×3` 乳品牧场和 `2×2` 乳品工坊。
2. 越界、重叠和未接路有世界内红色占地、冲突图形和禁用确认；合法位置使用绿色完整占地。
3. 玩家花费现有金币建房和邀请熊居民，只做一次长期乳品岗位派遣。
4. 熊从住房沿 4 邻接道路到牧场，自动完成照料、挤奶、搬运、加工和装车。
5. 奶牛是牧场生产动物；兔子和熊是有住房、岗位、位置与生活状态的居民。
6. 第二辆订单车到达、等待、显示 0/1，装满后显示 1/1、播放成功反馈并驶离，一次性结算 120 金币。
7. 道路断开与装卸位占用可中断；恢复后从检查点继续，货物和奖励不复制。
8. 完成后熊和兔子返回可见生活点；底部五段图形轨迹表达照料、挤奶、加工、装车和生活。
9. 默认简体中文；设置可切换并持久化英文与减少动态。
10. 主页面玩家可见对象全部来自正式 approved/shared 运行资源，不含临时字母块或 candidate/source/qa 路径。

## 3. 行为证据

正式命令：

`Godot_v4.6.2-stable_win64_console.exe --headless --path D:\AI\CityOfAnimals --script res://tests/test_f004_resident2_scene.gd --rendering-method gl_compatibility --rendering-driver opengl3 --audio-driver Dummy`

结果：

- 91 项断言 PASS；
- `F004_RESIDENT2_TESTS_PASSED`；
- 配置、模型、保存、文本、场景、触控、资源隔离和全部闭环状态通过；
- 测试视图显式关闭音频生成器，详细退出检查无 ObjectDB 泄漏；
- 正式主入口以正常 Windows 图形与音频路径短时启动 exit 0，无脚本/资源错误。

真实渲染命令使用同一测试脚本，移除 `--headless`、加入 `--resolution 720x1280` 与 `--f004-resident2-capture`。11 张玩家视角和指标位于 `output/runtime/F004-RESIDENT.2/`。

## 4. 玩家视角与性能证据

- 状态索引：`docs/evidence/F004-RESIDENT.2/README.md`
- 视觉复审：`docs/evidence/F004-RESIDENT.2/runtime-parity-checklist.md`
- 目标分辨率：720×1280
- 渲染器：Windows OpenGL 3.3 Compatibility / NVIDIA RTX 4060 Laptop GPU
- 180 帧实测：约 167 FPS
- 捕获时引擎 FPS：约 101
- 静态内存：约 50.7 MB
- 节点数：4
- approved/shared runtime assets：12
- candidate asset leak：false
- 最终严重度：`BLOCKER 0 / MATERIAL 0 / POLISH 0`

## 5. 回归

| 范围 | 结果 |
|---|---|
| `tests/test_f004_resident_scene.gd` | `F004_RESIDENT_TESTS_PASSED` |
| `tests/test_farm2_scene.gd` | FARM.2 全量回归 PASS |
| `tests/test_town_model.gd` | 镇区、畜群、本地订单、CSV、locale 与 hit region PASS |
| `project.godot -> scenes/town_main.tscn` | F004.2 正式入口正常启动 |
| `scenes/f004_resident1_baseline.tscn` | F004.1 显式可运行回滚入口保留 |

## 6. 运行时来源

- 12 张配置表：`config/tables/f004_resident2_*.csv`
- 原生模型/保存/本地化/视图：`scripts/town/f004_resident2_*.gd`
- 正式主场景：`scenes/town_main.tscn`
- 独立切片：`scenes/f004_resident2.tscn`
- F004.1 回滚入口：`scenes/f004_resident1_baseline.tscn`
- 资产清单：`assets/runtime/f004_resident_slice2/runtime-manifest.json`
- 运行时测试：`tests/test_f004_resident2_scene.gd`
- Penpot 对象回读：`output/penpot/F004-RESIDENT.2/penpot-import-manifest.json`

## 7. 锁与状态

归还：

- `F004-RESIDENT-SCALEOUT-ENG-LOCK-004`

释放条件全部满足：真实 720×1280 行为证据、91 项断言、F004.1/F003/镇区回归、approved-only 资产检查、性能证据以及 `BLOCKER 0 / MATERIAL 0`。当前无项目写锁、WPS 锁或导入阻塞；正在打开的 CityOfAnimals Godot 编辑器属于用户交互进程，不被视为写锁并未被关闭。

## 8. 非完成边界

- 没有把全游戏历史建筑全部重生成。
- 没有实现铁路、空运、海运、复杂社交、Android 真机或发行。
- 没有宣称静态 Penpot、文档、图片或 exit code 0 单独证明运行完成。
- 后续扩面必须新建正式 feature identity、RAG task receipt、只读回执和精确写集；不得直接批量生图或铺开代码。
