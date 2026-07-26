# PD-002 动物居民小镇产品重基线——只读与控制面回执

**日期：** 2026-07-25  
**请求 ID：** `REQ-COA-RESIDENT-TOWN-REBASE-20260725`  
**决策版本：** `PRODUCT-REBASELINE.1`  
**执行级别：** `L3`（跨系统正式设计；当前唯一制作人直接执行，不创建代理、子任务或线程）  
**唯一 accountable producer：** Codex `/root`  
**状态：** `READY_FOR_DESIGN_REBASELINE_ONLY`  
**运行时权限：** `false`

## 1. RAG Gate

- 项目 Gate：`tmp/rag/receipts/rag-gate.json`
- 本请求 Context Receipt：`tmp/rag/receipts/tasks/REQ-COA-RESIDENT-TOWN-REBASE-20260725.json`
- 上下文包：`tmp/rag/context/REQ-COA-RESIDENT-TOWN-REBASE-20260725.md`
- 状态：`READY`
- 活跃来源：46
- 稳定分块：263
- 黄金问题：15 / 15
- `mean_recall_at_k=1.0`
- `pass_rate=1.0`
- 索引签名：`884171f0cf2bbd63b3b5332fda89abbea0c19f6b429bf1d8221b36c0fdf1b44e`
- Context Receipt 引用数：8；均带 source ID、路径、定位器、版本与 SHA-256。

本次判断以项目正式来源与上述请求上下文为依据；旧聊天摘要不作为项目权威。

## 2. 控制面结果

- 输入：`tmp/COA-RESIDENT-REBASE/control-plane-intake.json`
- 检查器：最新版 `game-project-control-plane`
- 结果：`READY`
- 路由：`design_owner`
- 执行层级：`L3`
- 冲突任务：0
- 重复任务：0
- 必需动作：`send_structured_decision_receipt_to_control_plane`
- 状态沉淀：`formal_source_and_structured_decision_receipt`

本轮写集与 `F004-DESIGN-LOCK-001` 不相交。现有锁内文件、八张 `f004_*.csv`、`PM/feature_progress.xlsx`、`docs/active_scope.yaml`、`docs/task_contract.md`、各索引与旧 F004 文档包均保持只读。

## 3. 只读基线

| 对象 | 当前正式状态 | 本次处理 |
|---|---|---|
| `F003-FARM.2` | `ACCEPTED PLAYABLE PROTOTYPE` | 只保留为旧方向可玩证据、真实画面基线与可复用技术/资产来源；不把其手动生产规则当作新方向授权。 |
| `F003-VQ.1` | `RUNTIME_SLICE_APPROVED`，`SCALE_OUT_APPROVED=false` | 保留采收反馈与性能方法证据；旧记忆点与高频采收动作不向新方向扩面。 |
| `F004-DISTRICT.1` | 设计/配置/DOCX/PDF 通过，`BLOCKED: Figma UE attachment`，`runtime_authority=false` | 记录为 `REVISE_REQUIRED / PROPOSED_SUPERSEDED`；锁未释放前不改旧来源。 |
| `F-005` | `ROADMAP ONLY` | 因新 F004 身份与订单车辆前置关系变化而继续暂停。 |

进度矩阵只读渲染：`PM/feature_progress.xlsx` → `Nine Dimensions!A17:U20`。

- F003：100%，`ACCEPTED PLAYABLE PROTOTYPE`
- F004：22%，`FORMAL DESIGN HOLD / FIGMA`
- F005：0%，`ROADMAP ONLY`
- 公式错误扫描：0

## 4. 冲突与被覆盖规则

1. F003 要求玩家直接播种、收获、喂养、排产、收取和交付；新决策改为居民自动执行日常生产，玩家只做低频建造、邀请、派遣和调整。
2. F004 继续继承“手动收取”、固定功能位、分区营建板与站点原地变形；新决策要求先批准统一网格、占地、道路、作业点和自主居民系统，再决定建筑与分区。
3. F003/F004 的订单主要以委托板、卡片和面板表达；新决策要求用世界内车辆到达、等待、装载、离场表达订单。
4. 项目 Profile 的 `ui_temporary_visuals_allowed=true` 仍是旧通用设置；本次正式决策对模拟经营主页面建立更高优先级的局部覆盖：玩家可见评审与验收路径禁止临时资源、字母块和占位图。
5. F003 的玩家记忆点“收获飞入粮仓”与旧核心循环“看一眼地图，做下一次生产或发运选择”均降为历史基线；新单一记忆点以动物居民存在感为中心。

## 5. 锁与写入所有权

### 活跃共享锁

`F004-DESIGN-LOCK-001`，Owner：Codex `/root`。

锁范围包括旧 F004 功能文档、`f004_*.csv`、Active Scope、Task Contract、Profile、索引、PM Handoff、进度矩阵和旧文档包。释放条件仍是旧 F004 设计里程碑与控制面同步；本轮不擅自释放。

### 本轮独立写集

- `docs/decisions/PD-002-animal-resident-town-rebaseline.md`
- `docs/receipts/PD-002-READ-ONLY.md`
- `docs/features/F-004-resident-town-spatial-autonomy.md`
- `docs/design/F004-RESIDENT.1-visual-quality-contract.md`
- `docs/uiux/F004-RESIDENT.1-ui-priority.md`
- `output/documents/F004-RESIDENT.1/`
- `output/figma/F004-RESIDENT.1/`
- `tmp/COA-RESIDENT-REBASE/`

Writer：Codex `/root`。没有第二写入者。

## 6. 脏工作区

仓库处于大量未跟踪文件状态，`git status --short --untracked-files=all` 返回超过一万条记录，包含项目源码、资产、导入缓存、旧输出、文档与依赖目录。该状态被视为用户现有工作区；本轮不清理、不重置、不移动、不提交，也不把无关文件纳入写集。

## 7. 可复用资产与方法

| 来源 | 可复用内容 | 限制 |
|---|---|---|
| `assets/runtime/f003_farm2/` | 5 个动物、21 个建筑/田地类运行资源；透明画布与候选到运行时哈希已验证 | 当前状态是 `ENGINEERING_PROMOTED_PROTOTYPE_RUNTIME`；进入新主页面正式视觉验收前须逐项重审占地、身份、质量和是否需要重做。 |
| `scripts/town/farm2_*` | 地图相机、交互分层、保存和反馈方法 | 旧高频交互不能直接继承为新玩法。 |
| `zhanchengdashi-1930s-animal-ui-core` | `unit_motion_feedback.gd` 的移动姿态方法、视觉子节点约束、可中断/重置与 reduced-motion 方法 | 仅为用户自有内部复用；不照搬战斗动作语义、1930s UI 身份或页面布局。动物图像公开发行前仍需独立权利审查。 |
| F003/F004 配置 | 物品、配方、建筑 ID、资源网络与本地化键 | 作为迁移输入，不作为新空间/居民状态机的最终表结构。 |

## 8. 基线严重度

### BLOCKER

1. 没有一套被批准的逻辑网格、统一占地、道路连接、作业点与自主寻路合同。
2. 动物是静态生产对象或建筑附属物，不是会入住、行走、工作和生活的居民。
3. 订单由面板/卡片主导，没有世界内车辆到达、装载与离场闭环。
4. 新方向的可编辑 Figma/FigJam 尚未创建并验证。

### MATERIAL

1. 田地、道路和建筑的尺度关系不统一，建筑看似漂浮在草地，空间秩序弱。
2. 道路存在视觉断裂，不能证明建筑入口可达。
3. 主 HUD 与底部导航占用大，世界内状态因果被菜单和文字稀释。
4. 当前建筑/田地资源质量与新方向正式主页面要求之间仍有明显差距。
5. F004 的固定功能位与手动收取会继续制造高操作频率。

### POLISH

1. 缺少生活节奏、居民停留、装载、离场、环境声与状态过渡。
2. 遮挡处理、选中边界、安全区与小屏 50% 检查仍需新切片验证。

## 9. 基线哈希

| 文件 | SHA-256 |
|---|---|
| `docs/features/F-003-farm-town-foundation-v2.md` | `4F568013F6605D9BE4858B3642DA23FAE9129E838EB93C7D271E213855D250B4` |
| `docs/features/F-004-farm-district-industry-i.md` | `3DB6662B0CB86C1C29EB8C58FF60EDEF4A1D547865AB43B2FCDA143F6C02CACE` |
| `docs/active_scope.yaml` | `C72F44175DCFA1792F774DD13A847358CA32C0A9F86CCE83E51906F4D2AC1BAE` |
| `PM/feature_progress.xlsx` | `DBE5D1BD6B3E7CD95CF9DAEFCD9E342F0B79EACEF80E23ED09B521B7D0563959` |
| `assets/runtime/f003_farm2/runtime-manifest.json` | `C16B3CE0985A1379A5ED928E54308664F5283ADC3F7D7F633316106B7370AC86` |
| RAG Gate | `A0CE05F7C6B1948210819F4CDD9E496430750A17CC2EA264193CF985D5F877A8` |
| Task Context Receipt | `CE1329E262A4828F7A890EEB52427001BB1500F5EB35EED9AEEF6AECBC03E36A` |

## 10. 授权与停止线

本回执仅授权：

- 记录产品决策；
- 编写通用模板级正式设计源；
- 定义空间、居民、订单车辆、UI/UX 与视觉质量合同；
- 创建/更新本次独立 Figma/FigJam 设计交付；
- 生成 DOCX/PDF 评审包。

本回执不授权：

- 修改 Godot 场景、脚本、测试或运行时资产；
- 修改旧 F004 锁内文件或八张配置表；
- 修改进度矩阵/Active Scope/PM Handoff；
- 批量生图或批量重做建筑；
- 将任何新方向标记为运行时 Ready、Accepted 或 Scale-out。

**最高允许阶段：** `DESIGN_REBASELINE_REVIEW` / `VISUAL_CONTRACT_REVIEW`。  
**Figma 未经读回验证时：** `BLOCKED: Figma UE attachment`。
