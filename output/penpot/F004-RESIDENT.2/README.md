# F004-RESIDENT.2 Penpot 交接

## 当前状态

`PENPOT_SCALEOUT_READBACK_VERIFIED / LOCAL_EDITABLE_BACKUP_READY / NOT_RUNTIME`

本目录保存 F004.2 的可编辑 SVG 导入源和对象登记。Penpot 云端文件是 UI/UE 设计变更源；SVG 是本地可编辑备份和导入源，不能单独证明设计门通过。

## 云端目标

- 文件：`CityOfAnimals / F004-RESIDENT.1`
- URL：`https://design.penpot.app/#/workspace?team-id=bd31e32d-d69f-81e2-8008-62c66e2babc2&file-id=bd31e32d-d69f-81e2-8008-62cc67c1eeda&page-id=bd31e32d-d69f-81e2-8008-62cc67c1eedb`
- Team ID：`bd31e32d-d69f-81e2-8008-62c66e2babc2`
- File ID：`bd31e32d-d69f-81e2-8008-62cc67c1eeda`
- Page ID：`bd31e32d-d69f-81e2-8008-62cc67c1eedb`
- 方式：在同一文件追加 F004.2 命名根组，保留 F004.1 历史源。

## 可编辑导入源

- `F004-RESIDENT.2-penpot-screen-source.svg`
- `F004-RESIDENT.2-penpot-flow-source.svg`
- `penpot-import-manifest.json`

## 必须回读

1. 两个 F004.2 根组；
2. 六个 720×1280 页面组；
3. 四个状态/流程组；
4. `placement-footprint-3x3`、`invalid-overlap-cells`、`second-house-2x2`、`bear-resident`、`dairy-pasture`、`creamery-2x2`、`milk-carried-good`、`dairy-order-truck`、`two-resident-life-state`；
5. 顶部 HUD、底部情境层与主要 CTA。

2026-07-27 已完成：

- 两个本地 SVG 导入认证 Penpot 文件；
- F004.2 页面根组位置 `X=2000, Y=-911`，与历史 F004.1 源分离；
- F004.2 流程根组位置 `X=2000, Y=2100`，位于页面组下方；
- 云端显示“已保存”后重开同一 URL；
- 六个页面、四张流程和代表性内部矢量对象均保持唯一名称与稳定对象 ID；
- 精确引用写入 `penpot-import-manifest.json`。

这些画面是设计源，不是运行截图；Godot 必须用原生控件、动态文本、响应式布局和正式运行资产重建。
