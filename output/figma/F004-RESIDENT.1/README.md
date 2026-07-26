# F004-RESIDENT.1 Figma/FigJam 交付登记

## 当前状态

- 目标 Figma Design：<https://www.figma.com/design/uU2Oek5RqFb19CPoGl48lC/Untitled>
- 2026-07-25 顶层页面读取：`PASS`
- 具体页面元数据读取：`DEGRADED: transport send error`
- FigJam 生成：`BLOCKED: transport send error`
- 2026-07-25 收口复核：`whoami` 再次返回 `Transport send error`；按 Figma Skill 不对同一失败调用立即重试
- 2026-07-26 账户复核：`skyfire` / `skyfire's team` / Starter / `seat=View`
- 2026-07-26 目标文件只读 `use_figma`：`BLOCKED: MCP transport send error`
- 2026-07-26 内置浏览器目标文件：`BLOCKED: load timeout`
- 2026-07-26 Chrome 扩展控制：`BLOCKED: extension channel unavailable`
- 最终 Gate：`BLOCKED: Figma UE attachment`

本目录中的 `.mmd` 是可重放的图源草稿，不替代可编辑 Figma/FigJam 节点。只有远端节点真实创建、可编辑、读回并完成制作人审核，Figma Gate 才能通过。

## 图源

- `01-representative-player-ue.mmd`
- `02-resident-state-machine.mmd`
- `03-vehicle-order-state-machine.mmd`
- `04-spatial-placement-validation.mmd`

## 计划中的 Figma Design 节点

- `00_Product_Memory_Point`
- `01_Main_Map_720x1280`
- `02_Build_And_Road_Mode`
- `03_House_Invite_Assign`
- `04_Resident_And_Workplace_States`
- `05_Vehicle_Order_States`
- `06_Loading_Empty_Failure_Interrupted`
- `07_Component_And_Token_Sheet`

在 Figma 传输恢复前，不允许把本地 SVG/PNG/PDF 标记为设计门完成。

## 解除阻塞的精确条件

1. Figma 账户对目标 Design 文件具备可编辑权限，而不是仅有 `View`；
2. `use_figma` 可对目标文件完成一次只读节点清单并成功返回；
3. 八个计划节点和四张 FigJam 流程真实创建；
4. 逐个记录 file key、node ID、版本、owner 和状态覆盖；
5. 再次读回并截图核对，随后由用户完成设计审阅。

在以上五项全部满足前，本目录只保存可重放源与诊断证据，不把 Figma Gate 标记为通过。
