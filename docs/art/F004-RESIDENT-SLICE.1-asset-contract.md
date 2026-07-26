# F004-RESIDENT-SLICE.1 代表性资产整套合同

- 合同 ID：`COA-ART-F004-RESIDENT-SLICE-001`
- 日期：2026-07-26
- 制作人 / 主美：Codex `/root`
- 状态：`ASSET_SET_APPROVED`
- 目标：为一个 720×1280、45° 等距动物居民闭环提供正式、原创、可追溯且无占位泄漏的运行资产。

## 1. 一句话方向

圆润、厚实、可读的手绘动物小镇：温暖奶油墙、珊瑚红屋顶、青绿色功能点与低饱和自然地面组成稳定色彩角色；每个对象先清楚表达占地、入口和用途，再增加生活细节。

## 2. 整套清单与固定板位

整套评审板为严格 `3列 × 2行`，背景使用纯色 `#FF00FF` 便于确定性去背，不得含文字、标签、logo 或水印。

| 单元格 | 运行 ID | 资产 | 逻辑占地 | 主要可读点 |
|---:|---|---|---:|---|
| 1 | `resident_house` | 动物居民住房 | `2x2` | 正面门、温暖窗、邮箱/花盆，能读出“可入住” |
| 2 | `road_tile` | 小镇道路菱形地块 | `1x1` | 四边连接清楚，中央通行带连续，旋转后可拼接 |
| 3 | `wheat_field` | 成熟小麦田 | `1x1` | 土壤边界清楚、作物不越界，能读出作业格 |
| 4 | `workshop_granary` | 代表性谷仓工坊 | `2x2` | 正面入口、作业台/粮袋、明确工作点 |
| 5 | `loading_yard` | 路边装卸场 | `3x2` | 车辆等待位、货箱/坡道、道路接口 |
| 6 | `order_truck` | 世界内订单车 | 动态对象 | 车头方向、货箱容量、装满后离场 |

兔子居民沿用已批准的项目原创资产：

- `assets/runtime/f003_farm2/animals/animal_rabbit_v1.png`

## 3. 视觉与技术约束

- 45° 等距、2D 手绘卡通、深青灰轮廓、柔和局部接触影。
- 同一光源：左上方暖光；阴影短、软、不过度写实。
- 轮廓、细节密度、明度分组与现有 F003 正式资产相容，但新资产必须原创。
- 所有对象完整位于单元格内，四周留足透明安全边距，不跨格。
- 不复制 Township、Hay Day、Animal Crossing 的角色、建筑、车辆、布局、配色、logo、文案或商业身份。
- 去背后边缘不得有明显洋红污染；透明边界无白边。
- 玩家可见运行路径只使用整套批准后从评审板确定性拆出的像素。

## 4. 参考来源

以下仅作为项目自身形状、轮廓与材质一致性参考：

- `assets/runtime/f003_farm2/animals/animal_rabbit_v1.png`
- `assets/runtime/f003_farm2/buildings/plot_wheat_ready_v1.png`
- `assets/runtime/f003_farm2/buildings/building_granary_v1.png`
- `assets/runtime/f003_farm2/buildings/building_dairy_v1.png`

## 5. 运行时目标

- 评审板：`assets/runtime/f004_resident_slice/source/F004-RESIDENT-SLICE.1-whole-set-board.png`
- 拆分资产：`assets/runtime/f004_resident_slice/approved/*.png`
- 清单：`assets/runtime/f004_resident_slice/runtime-manifest.json`
- 运行时只加载 `approved/` 与已批准的兔子资产。
- `source/`、候选图和 QA 中间文件不得被运行场景引用。

## 6. Gate

1. `WHOLE_SET_CANDIDATE`：整套板生成，仍为 `NOT_RUNTIME`。
2. `ASSET_SET_APPROVED`：主美检查格数、身份一致性、占地可读性、透明边缘、原创性和目标尺寸；零 BLOCKER/MATERIAL。
3. `RUNTIME_IMPORT_READY`：只从批准板确定性拆分、去背、规范命名并记录哈希。
4. `RUNTIME_SLICE_APPROVED`：真实 720×1280 运行切片中通过焦点、边界、触控、状态和性能检查。

## 7. 整套评审结果

- 初版 MATERIAL：麦田出现人类农夫，违反动物居民记忆点，未放行。
- 修正版：移除人类，只保留空作业点、工具与篮筐；其余五格保持统一。
- 拆分 QA 首轮 MATERIAL：装卸场/车辆边缘出现相邻格碎片和洋红残边，未放行。
- 确定性脚本修正：保留单元格最大连通主体并加强洋红去除。
- 最终 QA 板：`assets/runtime/f004_resident_slice/qa/F004-RESIDENT-SLICE.1-approved-alpha-board.png`
- 结论：六个资产格数、身份、占地可读性、方向、透明边缘和整套一致性通过；零未解决 BLOCKER/MATERIAL。
- Gate：`ASSET_SET_APPROVED`
