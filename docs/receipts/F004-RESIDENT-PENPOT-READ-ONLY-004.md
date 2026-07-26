# F004-RESIDENT.1 Penpot 切换只读回执

- 请求：`REQ-F004-PENPOT-REBASELINE-20260726`
- Feature：`F-004 / F004-RESIDENT.1`
- 日期：2026-07-26
- 唯一 accountable producer / design owner：Codex `/root`
- 现有任务：`F-004-RESIDENT-DESIGN-001`
- 请求性质：已批准的设计工具重基线与未完成设计任务续接
- 运行时权限：`false`

## 1. RAG 与控制面

- 写入前项目 RAG Gate：`READY`
- 黄金问题：`20/20 PASS`
- 请求 Context Receipt：`knowledge/index/task-receipts/REQ-F004-PENPOT-REBASELINE-20260726.json`
- Context citations：8
- 控制面：`CONCERNS / L3 / continue_role_conversation`
- Required actions：发送结构化决策回执并写回正式来源
- 重复任务：无
- 冲突任务：无
- 共享锁：无
- `.git/*.lock`：无

`CONCERNS` 的唯一原因是 Penpot 替代决策尚未写入正式来源，不是文件锁、任务锁、产品冲突或 RAG 失败。

## 2. 当前正式基线

- `F003-FARM.2` 仅保留为已接受的旧方向可玩原型基线。
- `F004-RESIDENT.1` 是唯一 P0 活动功能。
- A-H 产品、空间、居民、车辆、UI/UX、视觉合同和 DOCX/PDF V1.0 已形成。
- 旧 `F004-DISTRICT.1` 与八张配置表保持 `HISTORICAL_MIGRATION_INPUT_NOT_RUNTIME`。
- 旧 `F004-DESIGN-LOCK-001` 已释放；当前没有项目文件锁。
- 详细占地目录、推荐默认值、可编辑设计源和运行时授权仍未通过。

## 3. Penpot 能力实测

- `https://design.penpot.app/` 可访问，已到达中文登录页。
- 当前内置浏览器没有已认证 Penpot 会话。
- Chrome 控制通道当前不可用；检查显示 ChatGPT Chrome Extension 的 native host 注册/清单不存在，且默认 Chrome 用户数据目录未被检测到。
- 本轮没有请求、读取或保存密码、验证码、Cookie、Token 或其他凭据。
- 未创建 Penpot 云端文件，因此不得标记 `PENPOT_EDITABLE_SOURCE_READY`。

## 4. 允许写集

- Penpot 决策与项目工作流；
- F004 功能设计、UI/UX、视觉质量合同与任务来源；
- Penpot 可导入的本地可编辑 SVG 设计源与 Artifact Register；
- DOCX/PDF 评审包；
- Active Scope、Task Contract、PM Handoff、设计/配置索引和进度工作簿；
- RAG manifest、golden queries、最终 Gate 和本请求 Context Receipt。

## 5. 排除

- Godot 场景、脚本、测试、存档、`project.godot`、运行时资产；
- 新 `f004_resident_*.csv`；
- 道路、田地、建筑、居民或车辆的批量正式资产生产；
- F005 及后续功能；
- 本地 Penpot 持久服务、自托管数据库或公开端口；
- 条件式关机。

## 6. 判定

`READY FOR FORMAL PENPOT REBASELINE WRITEBACK AND LOCAL EDITABLE IMPORT SOURCE`

本回执不证明远端 Penpot 文件完成，不批准视觉合同，不授权运行时。
