# F004-RESIDENT.1 Penpot 云端回写只读回执

**日期：** 2026-07-26
**Request ID：** `REQ-F004-PENPOT-CLOUD-IMPORT-20260726`
**Feature / Version：** `F-004 / F004-RESIDENT.1-V1.1`
**现有任务：** `F-004-RESIDENT-DESIGN-001`
**Owner：** Codex `/root`
**运行时权限：** `false`

## 1. 只读基线

- Git：`main @ b71a71a962fb637310ccdd03e69842f0d0e4406e`
- Remote：`git@github.com:BlacKKing4210/Home.git`
- 项目共享锁：无；`F004-DESIGN-LOCK-001` 已由既有释放回执关闭。
- 控制面：`status=READY`、`execution_level=L3`、`task_action=continue_existing`
- 重复任务：仅识别现有 `F-004-RESIDENT-DESIGN-001`，未创建新任务。
- 冲突任务/写锁：无。
- RAG task receipt：`knowledge/index/task-receipts/REQ-F004-PENPOT-CLOUD-IMPORT-20260726.json`
- RAG index signature：`acf07085141f177c4c41490a24602174e2cf8ac022dc651c4c9031134db588d4`

## 2. 导入源基线

| 文件 | SHA-256 |
|---|---|
| `output/penpot/F004-RESIDENT.1/F004-RESIDENT.1-penpot-screen-source.svg` | `c6295643b7823dff79fa1ed726f83f81bb8cb86cec7172e283cf3d277c04b7cc` |
| `output/penpot/F004-RESIDENT.1/F004-RESIDENT.1-penpot-flow-source.svg` | `4dd65473786726825797bb745ae9bd64ce2ed9a981d0636c1b01fa96059affb4` |
| `output/penpot/F004-RESIDENT.1/penpot-import-manifest.json` | `5d08161b5006258f369c003f45a5e054c88f8754880735e8de08ad1c251589b0` |

## 3. 已授权但不越界的操作

用户已完成 Penpot 登录并要求继续原 F004 设计任务。控制面通过后，已在认证账号中创建并导入云端文件；本回执记录在任何项目正式来源、进度矩阵或交接文件回写之前。

允许写入：

- Penpot 云端文件 `CityOfAnimals / F004-RESIDENT.1`
- 本地 Penpot 登记与 manifest
- F004 设计、UI/UX、视觉合同、任务与交接状态
- V1.1 DOCX/PDF 中的 Penpot Artifact Register
- `PM/feature_progress.xlsx`
- 本次只读/移交回执与 RAG manifest

明确禁止：

- Godot 场景、脚本、测试、存档、`project.godot` 与运行时资产
- 新建 F004 配置表
- 批量生图或资产 scale-out
- 把 Penpot、DOCX、PDF、静态截图或测试结果称为运行时完成

## 4. 本次验收

1. 真实云端文件 URL、team/file/page ID 可再次打开；
2. 两个导入源形成两个可编辑 SVG 根分组；
3. 8 个界面组、4 个流程组和两个根分组共 14 个对象均取得对象 ID；
4. `01_Main_Map_720x1280` 可继续展开到 `main-map-world`、`top-hud`、`context-panel` 等内部图层；
5. 正式来源把 Penpot Gate 与“用户详细设计审阅”分开记录；
6. `runtime_authority=false` 保持不变。

## 5. 尚未关闭的产品 Gate

Penpot 可编辑源完成不会自动批准详细设计。以下仍需用户审阅：

- `1×1` 基准下的占地目录与推荐默认值；
- 居民/离线/车辆订单默认节奏；
- 视觉合同与主页面信息层级；
- 后续代表性 Godot 切片的单独运行时授权。
