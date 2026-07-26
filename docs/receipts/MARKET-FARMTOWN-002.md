# MARKET-FARMTOWN.2 研究补充回执

**状态：** 已完成（研究与路线文档；不授予功能实现写入权限）  
**日期：** 2026-07-20  
**责任制作人：** Codex /root  
**范围：** 为 CityOfAnimals 的原创农场小镇内容架构补充制作人提供的视频登记、可审计的观察方法和官方资料信号。

## 读档与边界

- 已读取项目工作流、项目 Profile、活动范围、PM 交接、任务合同、设计/配置索引和功能进度矩阵。
- 队列确认：F-003 仍是唯一活动功能，状态为 `IMPLEMENTED_PENDING_VISUAL_CAPTURE`；其截图验收与共享锁未解除。
- 本次只写入 `docs/`、`output/pdf/` 与任务临时目录；未改动任何 Godot 场景、脚本、配置、测试、资源或功能进度行。

## 研究证据

| 证据 | 结果 | 使用边界 |
|---|---|---|
| 制作人提供的三段 B 站链接：`BV1gt421M7HN`、`BV1vK421Y7u9`、`BV17r5x63E7a` | 已登记为逐帧观察清单。B 站详情与检索接口在直连及 `127.0.0.1:7890` 代理下均出现 TLS 接收错误；网页阅读器未能解析视频页。 | 不从未实际读取的画面推断功能；不使用其资产、布局、文案、数值、建筑或配方。 |
| [Township Farming & Production](https://playrix.helpshift.com/hc/en/3-township/faq/15993-farming-production/) | 证实农场/工厂生产与多类订单通道的系统层存在。 | 仅提炼“不同交付时域”的抽象结构。 |
| [Township Airport](https://playrix.helpshift.com/hc/en/3-township/faq/15028-how-does-the-airport-work/) 与 [Special Buildings](https://playrix.helpshift.com/hc/en/3-township/faq/15064-what-do-special-buildings-do/) | 证实分格装载、手动发运与不同基础设施角色。 | 不采用原作货单、奖励、时间、建筑或界面表达。 |
| [Hay Day Production Buildings](https://support.supercell.com/hay-day/en/articles/production-building.html) | 证实生产状态/能力是一个持久可读的游戏层。 | F-004 使用原创状态机与图标反馈。 |
| [Hay Day Town Basics](https://support.supercell.com/hay-day/en/articles/town-basics-2.html) 与 [Town Visitors](https://support.supercell.com/hay-day/en/articles/how-to-serve-the-town-visitors.html) | 证实服务建筑、货物需求与回流可构成独立内容层。 | F-006 以原创城镇服务链实现，不使用原作访客、建筑或要求。 |

## 交付与验收

| 验收项 | 结果 |
|---|---|
| 三条视频链接被保留且未被虚构为已观看结论 | 通过。 |
| 形成可复用的“录像观察 -> 原创规格”转译表，并含无复制核查 | 通过，见 `MARKET-FARMTOWN.2`。 |
| 官方资料只支持系统层的抽象结论 | 通过。 |
| F-004、F-006、F-007 的可见状态/服务链/物流验收方向更明确，且未改变队列与依赖 | 通过。 |
| PDF 已生成，渲染为 3 页并逐页完成视觉检查 | 通过。 |

## 最终产物

- `docs/research/2026-07-farm-town-market-architecture.md`：升级至 `MARKET-FARMTOWN.2`。
- `docs/design_index.md`、`docs/roadmaps/PLAN-001-original-farm-town-content-ladder.md`、`docs/PM_HANDOFF.md`：同步引用版本。
- `output/pdf/2026-07-farm-town-market-architecture-research.pdf`：经视觉检查的用户审阅版本。

## 后续门槛

本回执不授权 F-004 或任何运行时写入。若要把录像转为可实现的原创功能来源，需要可核验的播放/截图/时间戳输入；之后仍须先完成 F-003 的干净 720 x 1280 截图验收，再为 F-004 创建独立功能来源、配置表、读档回执和写入授权。
