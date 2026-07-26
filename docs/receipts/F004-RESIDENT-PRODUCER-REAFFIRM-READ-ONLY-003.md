# F004-RESIDENT.1 制作人方向再确认只读回执

- 请求：`REQ-COA-F004-PRODUCER-DIRECTION-REAFFIRMED-20260726`
- Feature：`F-004 / F004-RESIDENT.1`
- 日期：2026-07-26
- 唯一 accountable producer / design owner：Codex `/root`
- 既有任务：`F-004-RESIDENT-DESIGN-001`
- 本轮性质：`producer_decision` 的正式回写，不创建新任务、代理、线程或 Feature
- 运行时权限：`false`

## 1. RAG 与控制面

- 项目 RAG Gate：`READY`
- 索引签名：`835285268b25ba121fe304c390dc30a8815c734f4ab2180c116ec428530991f0`
- 本请求 Context Receipt：`tmp/rag/receipts/tasks/REQ-COA-F004-PRODUCER-DIRECTION-REAFFIRMED-20260726.json`
- Context citations：10
- 控制面：`CONCERNS / L3 / continue_role_conversation`
- `CONCERNS` 原因：必须先发送结构化决策回执并写回正式来源；不是文件锁、任务冲突或 RAG 失败
- 重复任务：无
- 冲突任务：无
- 共享锁：无
- `.git/*.lock`：无

## 2. 制作人意见的正式解释

本轮确认的是产品方向五原则：

1. 所有田地、道路和建筑遵循以最小 `1×1` 田地为单位的统一整数占地；建筑资源服从批准后的占地目录，而不是让规则迁就旧图。
2. 订单使用在世界中到达、等待、装载、完成并离场的车辆表达，不继续使用裸功能卡作为主要体验。
3. 道路、田地和需要重做的建筑采用原创正式资产；主页面先完成 UI/UX、可编辑设计与视觉质量评审，玩家可见验收不允许临时资源。
4. 动物是居民和所有建筑日常操作的实际执行者；玩家只做低频建造、邀请、派遣和优先级调整。
5. 住房、邀请、入住、生活、工作和小镇长期运转组成慢节奏核心体验。

这次确认不等于批准详细占地尺寸目录、全部建筑清单、Figma 节点、配置表、运行时实现或批量资产生产。

## 3. 只读基线

| 来源 | SHA-256 |
|---|---|
| `docs/decisions/PD-002-animal-resident-town-rebaseline.md` | `f27b1a6d5e5675c384928859a54832b736fe334f8185721fbcd21d2d3a171e3c` |
| `docs/features/F-004-resident-town-spatial-autonomy.md` | `c94599ace261771233ba6e39bea6d1a4f4a60ddeb601e5feb72ef9797cc27341` |
| `docs/active_scope.yaml` | `4a97ef384371a227128c6a7a5752e6333a447efb0adb893b4f8074349776af0d` |
| `docs/task_contract.md` | `349e1fb386f2358b979efd3a53b725e409eef1f66933cf72020dd90deb4a495e` |
| `docs/PM_HANDOFF.md` | `8697fad73bf998ff5b6186f6f77c41245a00882de3a76fefbcc2bd4e0bc9e64d` |
| `knowledge/knowledge_manifest.csv` | `151b7a0cc39a466c17c183bd928664dd737fdc32d1fa8579faa7446c792079db` |
| `knowledge/golden_queries.csv` | `f0209e957f95db70c9c0190085d096455837e1c799f833f6f8c46efe4aa55bec` |
| `PM/feature_progress.xlsx` | `591643b6c6ff0bdc17ce700ad49a0331203d8b725252009aaabe58e2275eeef4` |
| Git HEAD | `14be37f5faa296aef06d1c884392dac80620b56d` |

## 4. 本轮允许写集

- 本回执与结构化制作人决策回执
- `docs/features/F-004-resident-town-spatial-autonomy.md`
- `docs/active_scope.yaml`
- `docs/task_contract.md`
- `docs/PM_HANDOFF.md`
- `knowledge/knowledge_manifest.csv`
- `knowledge/golden_queries.csv`
- 本请求 RAG context/task receipt 与最终项目 Gate

排除：Godot 场景、脚本、测试、运行时资源、配置表、建筑/道路/田地生图、批量资产、Figma Gate 伪关闭、F005 及后续功能。

## 5. 判定

`READY FOR PRODUCER DECISION WRITEBACK ONLY`

正式回写后仍保持 `DESIGN_REBASELINE_REVIEW / VISUAL_CONTRACT_REVIEW`。只有详细占地目录与可编辑 Figma/FigJam 通过后，才能建立新的配置/工程只读回执；本回执不授权运行时。
