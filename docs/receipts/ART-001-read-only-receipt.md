# ART-001 Read-only Receipt

**状态：** READY / candidate-only  
**任务指纹：** `044F634213B1A8382D04F36B6933AE85655617B97CF9AD63B9A9AB16336692B7`  
**执行级别：** L1 direct_execute  
**责任人：** Codex /root（美术负责人）

## 已核对

- 制作人已明确要求移植动物图，并确定当前动物与建筑美术统一。
- F-003 是唯一活跃运行时任务；其锁定文件与 ART-001 候选资源写入集无交集。
- F-004 仍为 ROADMAP ONLY；ART-001 不创建 F-004 运行时资产、不修改其功能或配置来源。
- 五张来源动物 PNG 均为 512 x 512 RGBA；建筑候选评审板为 1536 x 1024 RGB。
- `assets/candidate/style_reference/` 及 ART-001 合同在本次执行前不存在，因此无覆盖风险。

## 允许的候选写入

仅允许写入 `docs/tasks/ART-001-animal-building-style-unification.md`、ART-001 收据以及 `assets/candidate/style_reference/`。该目录必须通过 `.gdignore` 与运行时隔离。

## 授权与界限

制作人本轮指令构成候选资源迁移授权。候选风格锁定仅用于后续美术评审；将资产拆分、正式归档或接入 F-004 仍须新的正式合同和视觉验收。
