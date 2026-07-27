# F004-RESIDENT.2 工程阶段只读与锁替换回执

**Receipt：** `F004-RESIDENT-SCALEOUT-ENG-READ-ONLY-015`
**日期：** 2026-07-27
**Request：** `REQ-F004-RESIDENT2-ENGINEERING-20260727`
**Feature / Version：** F-004.2 / F004-RESIDENT.2 V1.1
**Task：** `F-004-RESIDENT-SCALEOUT-002`
**唯一 accountable producer / engineering owner：** Codex `/root`

## 1. 只读结论

- RAG：`READY`
- Sources：91
- Chunks：495
- Golden queries：29/29
- Mean recall：1.0
- Pass rate：1.0
- Index signature：`38b3e389fc196c35f70b2eb417acf69b231f3c3da3c4235478f7492cb4d40b57`
- Task receipt：`knowledge/index/task-receipts/REQ-F004-RESIDENT2-ENGINEERING-20260727.json`
- Control plane：`READY / L3 / engineering_owner`
- Control fingerprint：`1CB2B50B487530865EECDC63D94BDDD14B943C709F516F96D5F4DC9551BCD3DF`
- Duplicate tasks：0
- Conflicting tasks：0

设计、Penpot、视觉合同与资产整套均已通过独立里程碑。`assets/runtime/f004_resident_slice2/runtime-manifest.json` 记录八项 approved-only 资产，原始板、候选板、QA 板和旧熊/奶牛保持 `NOT_RUNTIME`。

## 2. 真实基线

- 正式主入口：`project.godot → scenes/town_main.tscn`
- 当前主入口脚本：`scripts/town/f004_resident_view.gd`
- F004.1 验收基线：`F004-RESIDENT-SLICE-RUNTIME-ACCEPTANCE-010`
- F004.1 主模型/配置/测试均保留，不作为 F004.2 的隐式实现。
- 现有主场景只有一个原生 `Control` 根节点；F004.2 可继续使用 Godot 原生绘制、动态文本、触控 hit region 和响应式 720×1280 变换，不需要扁平截图 UI。
- 当前工程无运行时写锁冲突；资产锁可在本回执落盘时原子归还并替换。

## 3. 工程切片判断

F004.2 不修改已验收 F004.1 的模型、配置、测试或资产。新增独立 `resident2` 文件组，并在行为、画面和回归通过后把 `town_main.tscn` 指向新视图；同时新增 `scenes/f004_resident1_baseline.tscn` 作为显式可运行回滚入口。

代表性闭环：

1. 玩家从单一建造入口打开图形资产条；
2. 选择对象并在世界网格实际放置 `1×1` 道路、`2×2` 第二住房、`3×3` 乳畜牧场和 `2×2` 乳品工坊；
3. 非法重叠/越界显示世界内红色占地和第一原因，合法占地显示绿色边界；
4. 玩家邀请熊并只做一次长期乳品岗位派遣；
5. 熊自动沿道路执行照料、挤奶、搬运、加工、装车；
6. 第二车辆到达、等待、装满、鸣笛离场并幂等奖励；
7. 熊与已有兔子返回住房或 `1×1` 生活点；
8. 道路阻断、装卸阻断、保存中断和恢复均不复制产出或奖励。

## 4. 精确写集

- `config/tables/f004_resident2_*.csv`
- `scripts/town/f004_resident2_*.gd`
- `scenes/f004_resident1_baseline.tscn`
- `scenes/f004_resident2.tscn`
- `scenes/town_main.tscn`
- `tests/test_f004_resident2_scene.gd`
- `output/runtime/F004-RESIDENT.2/`
- `docs/evidence/F004-RESIDENT.2/`
- `docs/receipts/F004-RESIDENT-SCALEOUT-ENG-*.md`
- `docs/receipts/F004-RESIDENT-SCALEOUT-RUNTIME-*.md`
- `docs/config_index.md`
- `docs/design_index.md`
- `PM/feature_progress.xlsx`
- `docs/active_scope.yaml`
- `docs/task_contract.md`
- `docs/PM_HANDOFF.md`

明确不写：

- F004.1 的 `f004_resident_*.gd`、七张 CSV、测试与批准资产；
- F003/F005-F010；
- Penpot 云端对象；
- `source/`、`qa/`、旧熊/奶牛；
- 服务器、阿里云、导出发布或关机。

## 5. 数据与运行边界

所有经济、占地、任务时长、岗位、车辆、日程、动效和音频调参写入 `config/tables/f004_resident2_*.csv`。运行配置必须独立校验：

- ID 唯一；
- 正整数占地；
- 入口位于占地边界外；
- 放置不越界、不重叠；
- 道路四向连通；
- 工作点、任务链和订单产物可达；
- 资产路径只来自 `runtime-manifest.json` 的 `approved_assets`；
- zh-CN/en 本地化完整；
- reduced-motion 值存在；
- 保存 schema 与幂等交易 ID 有效。

## 6. 验收

必须同时通过：

- 配置/模型/保存/本地化/场景行为测试；
- 默认、放置、非法、邀请、派遣、行走、工作、搬运、成功、阻塞、中断/恢复、生活、设置状态；
- 真实 `720×1280` Godot 正常渲染截图；
- 主入口真实触控路径，而非只调用模型；
- approved-only 资产检查与玩家可见零临时资源检查；
- 120 帧性能/内存/节点证据；
- F004.1 回归测试仍通过；
- 无脚本错误、资源导入阻塞或后台写锁。

窗口打开、退出码 0、静态设计或单元测试不能单独关闭运行门。

## 7. 原子锁替换

归还：

- `F004-RESIDENT-SCALEOUT-ASSET-LOCK-003`

获取：

- `F004-RESIDENT-SCALEOUT-ENG-LOCK-004`

只有 `RUNTIME_SLICE_APPROVED` 回执和真实行为证据完成后才归还工程锁。当前 `runtime_authority=true` 仅授权上述代表性切片，不等于 `runtime_complete` 或 `SCALE_OUT_APPROVED`。
