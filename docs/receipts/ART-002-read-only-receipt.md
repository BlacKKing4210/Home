# ART-002 Read-only Receipt

**状态：** READY / candidate atlas only  
**责任人：** Codex /root（美术负责人）  
**主技能：** game-batch-raster-asset-board-production

## 范围

- 目标：生成覆盖 36 个已列建筑/地块对象的七张分区候选板和一张总览图谱，并以体量阶梯验证大小差异。
- 输入：PLAN-001 的内容类别、制作人本轮建筑清单指令、ART-001 风格锁定和五张内部候选动物参考图。
- 允许写入：ART-002 合同/收据，以及 `assets/candidate/buildings/art-002/`。
- 禁止写入：代码、场景、配置、运行时资源、ART-001 文件和 F-003 锁定文件。

## 冲突与证据

F-003 的当前锁仅涉及运行时工程文件，与候选目录无交集。F-004 仍为路线图状态，因此 ART-002 被明确限制为 `NOT_RUNTIME` 与 `NO_SPLIT`。制作人本轮指令构成候选总览板授权；视觉验收仍由制作人保留。
