# F004-RESIDENT-SLICE.1 整套资产批准收据

- 日期：2026-07-26
- 制作人 / 主美：Codex `/root`
- 状态：`ASSET_SET_APPROVED`
- 资产数：6 个新原创资产 + 1 个复用项目原创兔子
- 运行时扩面：`false`

## 证据

- 合同：`docs/art/F004-RESIDENT-SLICE.1-asset-contract.md`
- 原始整套板：`assets/runtime/f004_resident_slice/source/F004-RESIDENT-SLICE.1-whole-set-board.png`
- 透明 QA 板：`assets/runtime/f004_resident_slice/qa/F004-RESIDENT-SLICE.1-approved-alpha-board.png`
- 清单：`assets/runtime/f004_resident_slice/runtime-manifest.json`
- 确定性处理：`assets/runtime/f004_resident_slice/source/process_board.py`

## 玩家可见资产

- `resident_house`：2×2 居民住房
- `road_tile`：1×1 道路/通行地块
- `wheat_field`：1×1 成熟田地与空作业点
- `workshop_granary`：2×2 谷仓工坊
- `loading_yard`：3×2 装卸场
- `order_truck`：订单车辆
- `resident_rabbit`：复用 F003 已批准项目原创兔子

## 评审

- 人类农夫问题已修正，产品身份一致。
- 单元格串入和洋红残边已修正。
- 最终透明 QA 板无相邻格碎片；轮廓、光向、材质与色彩角色统一。
- 资产只能从 `approved/` 路径加载；`source/` 和 `qa/` 不得进入运行时。
- 本收据仅放行代表性切片资产，不放行批量建筑或页面扩面。
