# F004-RESIDENT.1 Penpot 可编辑设计交付登记

## 当前状态

- 正式工具决策：`docs/decisions/PD-003-penpot-editable-design-source.md`
- Penpot 入口：<https://design.penpot.app/>
- 云端文件：[CityOfAnimals / F004-RESIDENT.1](https://design.penpot.app/#/workspace?team-id=bd31e32d-d69f-81e2-8008-62c66e2babc2&file-id=bd31e32d-d69f-81e2-8008-62cc67c1eeda&page-id=bd31e32d-d69f-81e2-8008-62cc67c1eedb)
- 对象级回读：`VERIFIED: 2 root groups + 8 screen groups + 4 flow groups`
- 评审状态：`PENPOT_EDITABLE_SOURCE_READBACK_VERIFIED / USER_DESIGN_REVIEW_PENDING`
- 运行时权限：`false`

2026-07-26 已在认证 Penpot 账号中创建、重命名并再次打开云端文件。两份 SVG 已导入 `Page 1`，形成两个可编辑根分组；其下 8 个命名屏幕组与 4 个命名流程组均可在图层树中展开并取得对象 ID。`01_Main_Map_720x1280` 还可继续展开到 `main-map-world`、`top-hud`、`context-panel` 等内部矢量层，证明不是扁平截图。现有 PNG/PDF 仍是同版本 SVG 的本地评审派生物；Penpot 云端导出归档与用户详细设计审阅仍未完成。

## 导入源

| 文件 | 画布/对象 | 用途 |
|---|---|---|
| `F004-RESIDENT.1-penpot-screen-source.svg` | 8 个命名 720×1280 frame group | 记忆点、主地图、建造/道路、住房/邀请/派遣、居民/岗位、车辆订单、全状态、组件/token |
| `F004-RESIDENT.1-penpot-flow-source.svg` | 4 个命名 flow group | 代表性 UE、居民状态机、车辆状态机、空间合法性 |
| `penpot-import-manifest.json` | 稳定对象登记 | 导入后页面/画板拆分与回读清单 |

## 已导入并回读的 Penpot 命名组

1. `00_Product_Memory_Point`
2. `01_Main_Map_720x1280`
3. `02_Build_And_Road_Mode`
4. `03_House_Invite_Assign`
5. `04_Resident_And_Workplace_States`
6. `05_Vehicle_Order_States`
7. `06_Loading_Empty_Failure_Interrupted`
8. `07_Component_And_Token_Sheet`
9. `08_Representative_Player_UE`
10. `09_Resident_State_Machine`
11. `10_Vehicle_Order_State_Machine`
12. `11_Spatial_Placement_Validation`

## 云端 Artifact Register

| 字段 | 当前值 |
|---|---|
| `penpot_url` | <https://design.penpot.app/#/workspace?team-id=bd31e32d-d69f-81e2-8008-62c66e2babc2&file-id=bd31e32d-d69f-81e2-8008-62cc67c1eeda&page-id=bd31e32d-d69f-81e2-8008-62cc67c1eedb> |
| `workspace/team_id` | `bd31e32d-d69f-81e2-8008-62c66e2babc2` |
| `project_container` | `Drafts`（工作区 URL 未暴露单独 project UUID） |
| `file_id` | `bd31e32d-d69f-81e2-8008-62cc67c1eeda` |
| `page_id` | `bd31e32d-d69f-81e2-8008-62cc67c1eedb` |
| `source_version` | `F004-RESIDENT.1-V1.1` |
| `owner` | Codex `/root` |
| `review_state` | `DESIGN_BASELINE_APPROVED_FOR_REPRESENTATIVE_SLICE` |
| `coverage` | 8 个屏幕/状态评审面 + 4 张 UE/状态流程 |
| `local_source_backup` | 本目录 SVG 与 manifest |

## 对象引用

| 对象 | Penpot object ID |
|---|---|
| `F004-RESIDENT.1-penpot-screen-source` | `030c6195-5b61-8040-8008-62d1e64c497d` |
| `00_Product_Memory_Point` | `030c6195-5b61-8040-8008-62d1e64f656f` |
| `01_Main_Map_720x1280` | `030c6195-5b61-8040-8008-62d1e65338b6` |
| `02_Build_And_Road_Mode` | `030c6195-5b61-8040-8008-62d1e656c642` |
| `03_House_Invite_Assign` | `030c6195-5b61-8040-8008-62d1e6598832` |
| `04_Resident_And_Workplace_States` | `030c6195-5b61-8040-8008-62d1e65cb5fc` |
| `05_Vehicle_Order_States` | `030c6195-5b61-8040-8008-62d1e65f5744` |
| `06_Loading_Empty_Failure_Interrupted` | `030c6195-5b61-8040-8008-62d1e6614942` |
| `07_Component_And_Token_Sheet` | `030c6195-5b61-8040-8008-62d1e6644912` |
| `F004-RESIDENT.1-penpot-flow-source` | `030c6195-5b61-8040-8008-62d1e54687c2` |
| `08_Representative_Player_UE` | `030c6195-5b61-8040-8008-62d1e54f53e3` |
| `09_Resident_State_Machine` | `030c6195-5b61-8040-8008-62d1e5585335` |
| `10_Vehicle_Order_State_Machine` | `030c6195-5b61-8040-8008-62d1e561416f` |
| `11_Spatial_Placement_Validation` | `030c6195-5b61-8040-8008-62d1e56863ef` |

代表性内部图层回读：

- `main-map-world`：`030c6195-5b61-8040-8008-62d1e653b763`
- `top-hud`：`030c6195-5b61-8040-8008-62d1e6536408`
- `context-panel`：`030c6195-5b61-8040-8008-62d1e6565be5`

## Gate 结论

已完成：认证、云端文件创建、SVG 导入、再次打开、命名对象回读和内部矢量层核验。

2026-07-26 已完成制作人对 UI/UX、状态、视觉质量、原创性、详细占地目录与推荐默认值的审阅，设计基线与视觉质量合同批准用于一个代表性 Godot 运行切片。

Penpot 云端 PNG 下载已实际尝试，浏览器下载通道返回 `Invalid http status code or phrase`，下载目录未产生文件；不得宣称云端导出成功。云端可编辑对象回读与版本匹配的本地派生预览已完成评审核对，因此该归档传输限制不是项目文件锁，也不继续阻断代表性切片。

仍待完成：

1. 刷新 RAG 并签发独立代表性 Godot 工程收据；
2. 完成正式资产集、真实运行切片和 720×1280 玩家视角行为证据；
3. 只有切片通过 `RUNTIME_SLICE_APPROVED` 后才可评估扩面。
