# F004-RESIDENT.1 Penpot 可编辑设计交付登记

## 当前状态

- 正式工具决策：`docs/decisions/PD-003-penpot-editable-design-source.md`
- Penpot 入口：<https://design.penpot.app/>
- 云端文件：`PENDING: authenticated Penpot file creation`
- 对象级回读：`PENDING`
- 评审状态：`DESIGN_REBASELINE_REVIEW / PENPOT_SOURCE_PENDING`
- 运行时权限：`false`

2026-07-26 已验证 Penpot 官方云服务登录页可访问，但当前浏览器没有已认证会话。以下 SVG 是保留组名、对象 ID 和真实 720×1280 画布的 Penpot 导入源与本地备份，不单独满足 `PENPOT_EDITABLE_SOURCE_READY`，也不得进入 Godot 玩家可见运行路径。

## 导入源

| 文件 | 画布/对象 | 用途 |
|---|---|---|
| `F004-RESIDENT.1-penpot-screen-source.svg` | 8 个命名 720×1280 frame group | 记忆点、主地图、建造/道路、住房/邀请/派遣、居民/岗位、车辆订单、全状态、组件/token |
| `F004-RESIDENT.1-penpot-flow-source.svg` | 4 个命名 flow group | 代表性 UE、居民状态机、车辆状态机、空间合法性 |
| `penpot-import-manifest.json` | 稳定对象登记 | 导入后页面/画板拆分与回读清单 |

## 计划中的 Penpot 页面

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
| `penpot_url` | `PENDING` |
| `workspace_id` | `PENDING` |
| `project_id` | `PENDING` |
| `file_id` | `PENDING` |
| `source_version` | `F004-RESIDENT.1-V1.1` |
| `owner` | Codex `/root` |
| `review_state` | `PENDING_AUTHENTICATED_IMPORT_AND_READBACK` |
| `coverage` | 8 个屏幕/状态评审面 + 4 张 UE/状态流程 |
| `local_source_backup` | 本目录 SVG 与 manifest |

## Gate 解除条件

1. 用户在 Penpot 完成登录；
2. 创建 `CityOfAnimals / F004-RESIDENT.1` 文件；
3. 导入本目录 SVG，并按 manifest 拆分为命名页面/画板；
4. 验证关键对象可选中、可编辑，登记 URL、ID 与对象引用；
5. 导出 PNG/PDF 并与源版本核对；
6. 制作人完成 UI/UX、状态、视觉质量与原创性审阅；
7. 用户批准详细占地目录与推荐默认值。

在以上条件完成前，不把本地 SVG、DOCX、PDF、截图或网页打开状态标记为可编辑设计 Gate 通过。
