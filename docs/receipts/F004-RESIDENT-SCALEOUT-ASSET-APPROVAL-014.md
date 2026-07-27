# F004-RESIDENT.2 整套资产批准回执

**Receipt：** `F004-RESIDENT-SCALEOUT-ASSET-APPROVAL-014`
**日期：** 2026-07-27
**Request：** `REQ-F004-RESIDENT-QUALITY-SCALEOUT-20260726`
**Feature / Version：** F-004.2 / F004-RESIDENT.2 V1.1
**Task：** `F-004-RESIDENT-SCALEOUT-002`
**唯一 accountable producer / art owner：** Codex `/root`

## 1. 阶段结论

- `ASSET_SET_APPROVED`
- `RUNTIME_IMPORT_READY`
- `runtime_authority=false`
- BLOCKER：0
- MATERIAL：0
- POLISH：0

本回执只批准八项资产与清单，不证明 Godot 运行切片、交互、状态、性能或发布完成。下一步必须先提交独立工程只读回执、替换资产写锁并取得精确运行时写集。

## 2. RAG 与控制面基线

- RAG：`READY`
- Sources：89
- Chunks：479
- Golden queries：28/28
- Mean recall：1.0
- Pass rate：1.0
- Index signature：`c7e672a9b83be893d07985ae719ae5bfb9bef461759389ad1673fa4e0f1e6eed`
- Task receipt：`knowledge/index/task-receipts/REQ-F004-RESIDENT-QUALITY-SCALEOUT-20260726.json`
- Control plane：`READY / L3 / art_owner`
- Control fingerprint：`27B70C01525A618F6D9D5215072CD6651C605A7BEACB4E48E4006C06CC4A93F3`

## 3. 唯一整套板

- 原始生图：`assets/runtime/f004_resident_slice2/source/F004-RESIDENT-SLICE.2-whole-set-board-raw.png`
- 原始 SHA-256：`79050AC11EF764A4F595D81BC8BD5B7E8418B597B95DF4C4B2767B76668B8CBE`
- 确定性背景规范化板：`assets/runtime/f004_resident_slice2/source/F004-RESIDENT-SLICE.2-whole-set-board.png`
- 规范化 SHA-256：`C4CC244334FD2F4B36E9C73A2BE87076252437F0247E4A20885E4619FD21546B`
- 布局：4 列 × 2 行
- 尺寸：1774 × 887
- 规范化为纯 `#FF00FF` 的背景像素：1,015,611
- 未生成第二套风格、变体或额外建筑。

第 6 格在同一整套合同内只做过一次定向修订：把无功能语义的奶油罐改为饲料袋，使可见道具与 `DAIRY_FEED → DAIRY_CARRY_MILK → DAIRY_LOAD_ORDER` 闭环一致；其余七格与构图保持不变。

## 4. 批准资产

| 运行 ID | 像素尺寸 | 逻辑占地/类型 | 单元最小间距 | 洋红污染比 | SHA-256 |
|---|---:|---|---:|---:|---|
| `resident_house_b` | 427×428 | 2×2 | 24 px | 0 | `467686EE014BB328636DF80EB80905BA01550C2E623FE3EE608A3BF3C305D06D` |
| `dairy_pasture` | 473×367 | 3×3 | 24 px | 0 | `33B059D8F5B3F0B08E39B9579C3E95D2C82FC3086B1B8337E8B76D267E10D114` |
| `creamery` | 433×412 | 2×2 | 32 px | 0 | `1C233119A5FF90BBC1AF42DB55869067D48D5E84F5342B3A629CE5B212AE3298` |
| `road_life_tile` | 387×253 | 1×1 | 46 px | 0 | `7761DB5C5DD3005071E38C12DFE6479BFFEB3E2FA6B794768346F26248445E1F` |
| `dairy_order_truck` | 409×337 | 动态对象 | 65 px | 0 | `F76F50D1148310660A414EC67BDB2ECD9D9DA960CFE9B47D70594B79F1EA4B0E` |
| `dairy_goods_set` | 344×290 | 搬运/装载道具 | 65 px | 0 | `A8570773491B848997FB762AC491D7CFEA36D7AD8102048AD398210D57FD8F8B` |
| `resident_bear_dairy` | 255×372 | 动物居民 | 32 px | 0 | `951A32CB9310A3196CDEECB409DC518FC36E2274115C9C5155632A8EE058E5B1` |
| `pasture_cow` | 386×315 | 牧场动物，非居民 | 78.03 px | 0 | `F293A21B5EB5E75FEE7AACD3D21DE07AD1A690EE24E62FF1178608F48F92F8C7` |

批准目录：`assets/runtime/f004_resident_slice2/approved/`。只有 `runtime-manifest.json` 中同时满足 `approved=true` 与 `runtime_allowed=true` 的路径可在后续工程阶段引用。

## 5. QA 证据

- Alpha 整套板：`assets/runtime/f004_resident_slice2/qa/F004-RESIDENT-SLICE.2-approved-alpha-board.png`
- Alpha 板 SHA-256：`68CFA4EFB60EDA16F8F8DD242891D69C11E8AC323246381A85FC39210DE2250F`
- 96px/64px 移动端可读性板：`assets/runtime/f004_resident_slice2/qa/F004-RESIDENT-SLICE.2-approved-mobile-readability.png`
- 移动端板 SHA-256：`E301B6C271B7FA497F1060D5FCF979AF85BBBCAC230578390F80B3A31FA415E4`
- 运行清单：`assets/runtime/f004_resident_slice2/runtime-manifest.json`
- 清单 SHA-256：`4D12B5712B1D85C10CA6657CCA36C842938816F0CD02A788BBF403331D111266`

检查结果：

- 八个预期对象全部存在且顺序正确；
- 建筑/道路占地剪影、入口和功能部件可读；
- 熊是有乳品岗位身份的居民，奶牛是牧场动物，未混淆；
- 64px 与 96px 下仍可区分八项主要剪影；
- 背景已确定性规范化，拆分后 Alpha 完整；
- 可见像素洋红污染比均为 0；
- 没有白色贴纸边、文字、logo、水印、商业角色或参考游戏布局；
- 旧 `animal_bear_v1.png` 与 `animal_cow_v1.png` 保持历史文件，继续 `NOT_RUNTIME_F004.2`。

## 6. 运行路径隔离

以下内容始终 `NOT_RUNTIME`：

- `source/`
- `qa/`
- `qa/candidates/`
- 原始整套板、规范化整套板、候选板和 QA 板

后续工程必须通过清单加载 `approved/`，并对配置引用进行 allowlist 验证。任何候选、旧熊/奶牛、emoji、字母块、开发色块或未批准 SVG 进入玩家可见主页面，都构成 BLOCKER。

## 7. 下一门

下一门为独立工程接收：

1. 重新 prepare RAG 并生成工程阶段 task receipt；
2. 归还 `F004-RESIDENT-SCALEOUT-ASSET-LOCK-003`；
3. 原子获取新的工程写锁；
4. 创建精确 F004.2 CSV、模型、视图、测试与代表性场景写集；
5. 只有真实 720×1280 玩家视角行为证据通过后，才允许 `RUNTIME_SLICE_APPROVED`。
