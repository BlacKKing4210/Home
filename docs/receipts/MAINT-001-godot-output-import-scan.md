# MAINT-001 Godot 启动导入卡死维修回执

**状态：** READY / AUTHORIZED FOR NARROW STARTUP REPAIR  
**负责人：** Codex `/root`  
**日期：** 2026-07-25  
**主 Skill：** `godot-feature-slice-implementation`

## 目标

恢复 CityOfAnimals 的 Godot 4.6 编辑器启动，不改变任何玩法、场景、配置或运行时资产。

## 只读基线

- 用户可见症状：编辑器长期停在“正在导入或重新导入资产 98%”，当前条目为 `pages_viewArrow.svg`。
- `pages_viewArrow.svg` 来自 `output/documents/F003-FARM.2/node_modules/pdfjs-dist` 和 `output/documents/F004-DISTRICT.1/node_modules/pdfjs-dist`，不是游戏资产。
- 两个 `node_modules` 都是指向 Codex 共享运行时依赖的目录连接；Godot 因 `output/` 缺少 `.gdignore` 而递归扫描并重复导入相同 PDF.js 图标。
- 当前 CityOfAnimals 编辑器进程通过命令行 `--path D:/AI/CityOfAnimals --editor` 独立识别；其他 Godot 进程属于另外两个项目。

## 写入范围

- `output/.gdignore`
- `docs/receipts/MAINT-001-godot-output-import-scan.md`
- 自动生成的 `.godot/` 导入缓存仅可在验证需要时重建，不属于项目源文件。

## 禁止范围

- 不修改 `project.godot`、`scenes/`、`scripts/`、`config/`、`assets/runtime/`、测试或 F-004 设计源。
- 不终止或修改 `fisher`、`zhanchengdashi` 的 Godot 进程。

## 验收

1. Godot 不再扫描 `output/` 中的文档依赖。
2. 项目级无头导入正常结束且日志中没有脚本/资源错误。
3. CityOfAnimals 编辑器能够重新启动并越过导入阻塞。
4. 临时验证日志只保留在 `tmp/`，不进入运行时路径。

## 完成证据

- `output/.gdignore` 写入后，Godot 文件系统缓存中的 `res://output/` 条目从 `1018` 降为 `0`，`pages_viewArrow.svg` 条目从 `4` 降为 `0`。
- Godot 4.6.2 在沙箱外完成项目级 `--headless --editor --import --quit`；文件扫描、编辑器布局和 `res://scenes/town_main.tscn` 加载均完成。
- 正常模式无头启动加载 `town_main.tscn` 与 `farm2_view.gd` 后正常退出；两个验证日志中没有 `ERROR`、`SCRIPT ERROR`、解析错误或资源加载失败。
- 新的 CityOfAnimals 编辑器进程 PID `508` 保持响应，并拉起 PID `10700` 的 `town_main.tscn` 720 x 1280 调试实例；Windows 画面检查确认编辑器已经越过导入弹窗。
- `fisher` PID `16592` 与 `zhanchengdashi` PID `1876` 全程未终止、未修改。
- 唯一剩余输出是 Godot 内置手柄映射的 `misc2` 提示，不影响项目导入或运行。

## 关闭结论

**PASS / CLOSED。** 根因是非运行时 `output/` 目录缺少 Godot 扫描隔离，并通过最小 `.gdignore` 修复。没有修改玩法脚本、场景、配置、运行时资产或 F-004 设计源。
