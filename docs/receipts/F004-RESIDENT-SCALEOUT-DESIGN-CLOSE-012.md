# F004-RESIDENT.2 设计与 Penpot 关闭回执

**Receipt：** `F004-RESIDENT-SCALEOUT-DESIGN-CLOSE-012`
**日期：** 2026-07-27
**Request：** `REQ-F004-RESIDENT-QUALITY-SCALEOUT-20260726`
**Feature / Version：** F-004.2 / F004-RESIDENT.2 V1.0
**Task：** `F-004-RESIDENT-SCALEOUT-002`
**唯一 accountable producer：** Codex `/root`

## 结论

`DESIGN_SCALEOUT_BASELINE_APPROVED`
`PENPOT_SCALEOUT_READBACK_VERIFIED`
`VISUAL_SCALEOUT_CONTRACT_APPROVED`
`ASSET_SET_APPROVED = false`
`RUNTIME_AUTHORITY = false`

F004.2 已完成实现前设计门：真实占地放置、第二住房、熊居民邀请、乳品派遣、照料/挤奶/搬运/加工/装车、第二车辆订单和双居民日常均有正式规则、状态、UI/UX、视觉与资产合同。此回执不证明资产或运行时完成。

## 正式来源

- `docs/features/F-004-resident-dairy-neighborhood-scaleout.md`
- `docs/uiux/F004-RESIDENT.2-ui-priority.md`
- `docs/design/F004-RESIDENT.2-visual-quality-contract.md`
- `docs/art/F004-RESIDENT.2-asset-contract.md`
- `output/penpot/F004-RESIDENT.2/penpot-import-manifest.json`

## Penpot 云端回读

- 文件：`CityOfAnimals / F004-RESIDENT.1`
- URL：`https://design.penpot.app/#/workspace?team-id=bd31e32d-d69f-81e2-8008-62c66e2babc2&file-id=bd31e32d-d69f-81e2-8008-62cc67c1eeda&page-id=bd31e32d-d69f-81e2-8008-62cc67c1eedb`
- 页面根组位置：`X=2000, Y=-911`
- 流程根组位置：`X=2000, Y=2100`
- 云端状态：显示“已保存”后重开同一 URL，文件标题和 team/file/page ID 保持一致。
- 顶层：2 个 F004.2 导入根、2 个内容根。
- 页面：6/6 唯一命名对象回读通过。
- 流程：4/4 唯一命名对象回读通过。

代表性内部对象回读：

| 对象 | Penpot ID |
|---|---|
| `placement-footprint-3x3` | `eba48188-d2c7-80cc-8008-639d64615aed` |
| `invalid-overlap-cells` | `eba48188-d2c7-80cc-8008-639d6464ddf3` |
| `second-house-2x2` | `eba48188-d2c7-80cc-8008-639d64670f58` |
| `bear-resident` | `eba48188-d2c7-80cc-8008-639d6467b1fa` |
| `dairy-pasture` | `eba48188-d2c7-80cc-8008-639d646a2d45` |
| `creamery-2x2` | `eba48188-d2c7-80cc-8008-639d646a7da1` |
| `milk-carried-good` | `eba48188-d2c7-80cc-8008-639d646ee2ee` |
| `dairy-order-truck` | `eba48188-d2c7-80cc-8008-639d646f136b` |
| `two-resident-life-state` | `eba48188-d2c7-80cc-8008-639d71f421d2` |
| `bear-dairy-blocked-state` | `eba48188-d2c7-80cc-8008-639d71efb20b` |
| `vehicle-settled-state` | `eba48188-d2c7-80cc-8008-639d71f1acb5` |

完整 ID 表在 manifest 中，重开后 ID 保持一致。

## 视觉与 UI/UX 评审

审阅输出：

- `output/penpot/F004-RESIDENT.2/previews/F004-RESIDENT.2-screen-board.png`
- `output/penpot/F004-RESIDENT.2/previews/F004-RESIDENT.2-flow-board.png`
- 6 张 `720×1280` 单页预览。

通过项：

- 六个页面均只有一个主要决定或无操作观察态；
- 合法/非法占地使用边界、纹理、入口与短原因，不只依赖颜色；
- 第二住房、熊、牧场、工坊、奶罐、车辆和双居民日常均可无说明文字读出主要功能；
- 没有常驻“挤奶/加工/收取/装车”按钮；
- 中文层级、主要 CTA、世界区和底部情境层清楚；
- 流程覆盖放置、熊乳品任务、车辆结算和双居民日程；
- 未发现复制商业角色、logo、布局或 UI 身份；
- 未解决 `BLOCKER = 0`、`MATERIAL = 0`。

## 授权边界

本回执只释放设计锁，并授权：

1. 按 `COA-ART-F004-RESIDENT-SLICE-002` 制作一张完整整套候选板；熊/奶牛候选审计后的精确板位调整由独立资产只读回执记录；
2. 审计项目自有熊和奶牛候选；
3. 整套通过后再建立精确工程写集和运行时回执。

当前仍禁止：

- 直接把候选资产放入运行路径；
- 批量生成其他建筑或多个风格变体；
- 修改 Godot 主入口、配置或存档；
- 把静态设计误报为用户五项需求整体完成。
