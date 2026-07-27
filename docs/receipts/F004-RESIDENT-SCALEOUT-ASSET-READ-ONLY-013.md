# F004-RESIDENT.2 资产阶段只读与锁替换回执

**Receipt：** `F004-RESIDENT-SCALEOUT-ASSET-READ-ONLY-013`
**日期：** 2026-07-27
**Request：** `REQ-F004-RESIDENT-QUALITY-SCALEOUT-20260726`
**Feature / Version：** F-004.2 / F004-RESIDENT.2 V1.1
**Task：** `F-004-RESIDENT-SCALEOUT-002`
**唯一 accountable producer / art owner：** Codex `/root`

## 设计门与 RAG

- `DESIGN_SCALEOUT_BASELINE_APPROVED`
- `PENPOT_SCALEOUT_READBACK_VERIFIED`
- `VISUAL_SCALEOUT_CONTRACT_APPROVED`
- RAG：`READY`
- Golden queries：27/27，mean recall `1.0`，pass rate `1.0`
- Index signature：`e2171c7558d7dbfc31fb0d603199b655c227c9f9dea951417268c570f4ee7898`
- Task receipt：`knowledge/index/task-receipts/REQ-F004-RESIDENT-QUALITY-SCALEOUT-20260726.json`
- Control plane：`READY / L3 / art_owner`
- Control fingerprint：`27B70C01525A618F6D9D5215072CD6651C605A7BEACB4E48E4006C06CC4A93F3`

## 候选角色只读审计

| 候选 | 尺寸 | Alpha | SHA-256 | 结论 |
|---|---:|---|---|---|
| `assets/runtime/f003_farm2/animals/animal_bear_v1.png` | 512×512 | 是 | `F3096B32A30CB24D38BA3F050C5EABF860BF1DE2BA6EF862B7DB4C048B8CF52E` | MATERIAL：正侧面贴纸感、厚白边、无居民/乳品岗位身份；`NOT_RUNTIME_F004.2` |
| `assets/runtime/f003_farm2/animals/animal_cow_v1.png` | 512×512 | 是 | `624CA248D06D1307F1D902313D83A0385010AF93508FA98A8943A805C60DD732` | MATERIAL：正侧面贴纸感、厚白边、等距/光向与新建筑不一致；`NOT_RUNTIME_F004.2` |

两项资产不删除、不覆盖，只保留为历史项目资产。F004.2 使用同一整套合同重做匹配的熊居民和牧场奶牛。

## 授权整套

资产合同：`docs/art/F004-RESIDENT.2-asset-contract.md` V1.1。

只授权一张 `4列 × 2行` 整套候选板：

1. `resident_house_b`
2. `dairy_pasture`
3. `creamery`
4. `road_life_tile`
5. `dairy_order_truck`
6. `dairy_goods_set`
7. `resident_bear_dairy`
8. `pasture_cow`

候选板状态始终为 `WHOLE_SET_CANDIDATE / NOT_RUNTIME`，直到主美检查和拆分 QA 关闭所有 BLOCKER/MATERIAL。

## 锁替换

关闭并归还：`F004-RESIDENT-SCALEOUT-DESIGN-LOCK-002`。
原子取得：`F004-RESIDENT-SCALEOUT-ASSET-LOCK-003`。

精确写集：

- `assets/runtime/f004_resident_slice2/source/`
- `assets/runtime/f004_resident_slice2/qa/`
- `assets/runtime/f004_resident_slice2/approved/`
- `assets/runtime/f004_resident_slice2/runtime-manifest.json`
- `docs/receipts/F004-RESIDENT-SCALEOUT-ASSET-*.md`
- `PM/feature_progress.xlsx`
- `docs/active_scope.yaml`
- `docs/task_contract.md`
- `docs/PM_HANDOFF.md`

## 禁止范围

- 不生成第二套候选或风格变体；
- 不批量重做其他建筑；
- 不把候选、source、QA 或旧熊/奶牛送入运行路径；
- 不修改运行时代码、配置、场景、存档或主入口；
- 不把资产板、测试或文件存在误报为运行完成；
- 不执行关机。
