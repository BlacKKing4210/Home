# F004 旧设计锁释放回执

- 回执 ID：`F004-DESIGN-LOCK-RELEASE-002`
- 日期：2026-07-26
- 唯一 accountable producer：Codex `/root`
- 释放锁：`F004-DESIGN-LOCK-001`
- 原任务：`F-004-DESIGN-001 / F004-DISTRICT.1`
- 当前任务：`F-004-RESIDENT-DESIGN-001 / F004-RESIDENT.1`
- 决策来源：`docs/decisions/PD-002-animal-resident-town-rebaseline.md`
- 控制面回执：`docs/receipts/COA-GIT-LOCK-CONTROL-PLANE-001.json`
- 只读回执：`docs/receipts/COA-GIT-LOCK-READ-ONLY-001.md`

## 释放判断

`F004-DISTRICT.1` 已被正式产品决策标记为：

`REVISE_REQUIRED / SUPERSEDED_BY F004-RESIDENT.1 / MIGRATION_INPUT / NOT_RUNTIME`

旧锁继续占用 `active_scope`、任务契约、索引、PM handoff 和进度工作簿只会造成控制面状态漂移。当前唯一制作人已经完成这些共享来源的原子同步，因此旧锁满足释放条件。

## 已完成的同步

- `docs/active_scope.yaml` 已将活动身份切换为 `F004-RESIDENT.1`，`shared_locks` 为空，并登记本释放回执；
- `docs/task_contract.md` 已切换到居民小镇设计重基线与 Figma 阻塞状态；
- `docs/PM_HANDOFF.md` 已同步当前产品记忆点、阻塞、Git 状态和下一步；
- `docs/design_index.md` 已把新 F004 设为当前来源，把 `F004-DISTRICT.1` 降为历史迁移输入；
- `docs/config_index.md` 已明确新方向的数值表为 `0%` 且尚未授权，旧八表只作历史迁移输入；
- `PM/feature_progress.xlsx` 的 `Nine Dimensions!A19:U19` 已改为 `F004-RESIDENT.1` 身份，九维完成度全部为 `0%`，不继承旧方向的 `22.22%`；
- 更新后的工作簿通过公式错误扫描，`#REF!`、`#DIV/0!`、`#VALUE!`、`#NAME?`、`#N/A` 命中为零，并完成样式渲染复核；
- Git 层面没有 `.git/index.lock`、`.git/config.lock` 或 `.git/HEAD.lock`，也没有相关编辑器写进程。

## 保留与禁止

- 保留 `docs/features/F-004-farm-district-industry-i.md`、`config/tables/f004_*.csv` 和 `output/documents/F004-DISTRICT.1/`，不删除用户已有成果；
- 这些历史内容不再拥有运行时权威，不得据此继续手动生产点击、固定功能位或裸订单卡方向；
- 本次释放没有创建新的共享锁，因为当前处于用户设计审阅和 Figma 阻塞阶段，没有获准的运行时写任务；
- `BLOCKED: Figma UE attachment`、用户设计审阅和 `runtime_authority=false` 继续有效。

## 结果

`RELEASED: F004-DESIGN-LOCK-001`

该结果只解除失效的文件协调锁，不代表：

- `DESIGN_REBASELINE_APPROVED`
- `VISUAL_CONTRACT_APPROVED`
- `RUNTIME_SLICE_APPROVED`
- F004 功能完成
- 整批工作完成
- 满足关机条件
