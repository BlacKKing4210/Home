# F004-RESIDENT.1 设计重基线 V1.0 完成回执

- 项目：CityOfAnimals
- Feature：`F-004 / F004-RESIDENT.1`
- 现有任务：`F-004-RESIDENT-DESIGN-001`
- 请求：`REQ-COA-F004-DESIGN-REBASELINE-CONTINUE-20260726`
- 日期：2026-07-26
- 唯一 accountable producer / design owner：Codex `/root`
- 控制面动作：`continue_existing`
- 运行时权限：`false`
- 交付状态：`DESIGN PACKAGE COMPLETE FOR REVIEW / FIGMA BLOCKED`

## 1. RAG 与控制面

- 写入前项目 Gate：`READY`
- 写入前索引签名：`c204223feda828b1ce0d6fcf643a6002439d0f26d91a8c080875984005ab2f2d`
- 本请求 Context Receipt：`tmp/rag/receipts/tasks/REQ-COA-F004-DESIGN-REBASELINE-CONTINUE-20260726.json`
- Context citations：11
- 控制面：`READY / L3 / continue_existing`
- 任务去重：只命中同一个现有任务 `F-004-RESIDENT-DESIGN-001`
- 冲突任务：无
- 共享锁：无；`F004-DESIGN-LOCK-001` 已由 `F004-DESIGN-LOCK-RELEASE-002` 释放
- 最终 RAG 状态以本轮最后一次 `prepare` 后的 `tmp/rag/receipts/rag-gate.json` 和本请求 task receipt 为准。

本轮没有创建代理、子任务、线程、重复制作人或新的 Feature 身份。

## 2. A-H 完成结果

| 项目 | 结果 | 正式证据 |
|---|---|---|
| A. 只读基线与 RAG/控制面 | 完成 | 续接只读回执、本请求 RAG receipt、Active Scope、PM Handoff |
| B. 产品重基线 | 完成，待用户审阅 | `PD-002`、功能设计第 2–4 章 |
| C. 空间系统 | 完成，待用户批准占地目录 | 功能设计第 5 章 |
| D. 动物居民 UE 与状态机 | 完成，未实装 | 功能设计第 6–7 章、FigJam 可重放源 |
| E. 世界车辆订单 | 完成，未实装 | 功能设计第 8 章、FigJam 可重放源 |
| F. UI/UX 与视觉质量合同 | 内容完成；Figma 物质阻塞 | UI/UX 优先级、视觉质量合同、Figma 登记 |
| G. 推荐方案 | 完成 | 单一记忆点、代表性闭环、三个推荐默认值 |
| H. 进度与正式来源 | 完成 | 工作簿、Active Scope、Task Contract、PM Handoff、superseded 关系 |

## 3. 制作人设计判断

锁定单一记忆点：

> 动物不是按钮或加成，而是玩家看得见、会走路、会生活、会把小镇运转起来的居民。

减法目标：

- 取消常态逐次播种、收获、喂养、开机和收取；
- 玩家只做低频建造、邀请、派遣、道路与长期优先级调整；
- 不新增重复货币、常驻菜单或说明文字来包装订单。

代表性闭环：

`2×2 住房 → 一名居民 → 连通道路 → 1×1 田地或代表岗位 → 居民作业与搬运 → 一辆订单车装载并离场`

## 4. 正式来源与哈希

| 交付 | 路径 | SHA-256 |
|---|---|---|
| 产品决策 | `docs/decisions/PD-002-animal-resident-town-rebaseline.md` | `f27b1a6d5e5675c384928859a54832b736fe334f8185721fbcd21d2d3a171e3c` |
| 功能设计 V1.0 | `docs/features/F-004-resident-town-spatial-autonomy.md` | `c94599ace261771233ba6e39bea6d1a4f4a60ddeb601e5feb72ef9797cc27341` |
| UI/UX 优先级 V1.0 | `docs/uiux/F004-RESIDENT.1-ui-priority.md` | `178b1a4f237bd016956d04b235c85e0e12c155af27b6e8223ed278512b1ee785` |
| 视觉质量合同 V1.0 | `docs/design/F004-RESIDENT.1-visual-quality-contract.md` | `7fb3f8fd0ae5a9eeea20cd52b386be148b38ba76591252388275c5eea57f78f9` |
| Figma/FigJam 登记 | `output/figma/F004-RESIDENT.1/README.md` | `7015078a3a5a44fee9974f4d01aa3ef045af7262775e834351dacf91fd830b7c` |
| 可编辑 DOCX | `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V1.0_REVIEW.docx` | `17bdeed113bc5c9a74e1e09d1e1a9934c28fedd7e47a66dce4ad0197bc2b93f2` |
| 审阅 PDF | `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V1.0_REVIEW.pdf` | `94d0385ed90d6579c337b45943abe446d4ae645209186d2ef2d2e331353dd8ab` |
| 进度矩阵 | `PM/feature_progress.xlsx` | `591643b6c6ff0bdc17ce700ad49a0331203d8b725252009aaabe58e2275eeef4` |

## 5. 文档与工作簿 QA

- DOCX：821 个段落、26 张表、2 张旧方向真实运行基线截图。
- PDF：38 页，A4，Tagged，无加密、无 JavaScript、无可疑对象。
- 10 张 contact sheet 已逐页检查；未发现空白页、正文/表格截断、越界、错误字段或损坏图片。
- DOCX 文本检查：`Error! = 0`，`Reference source not found = 0`。
- 工作簿 `Nine Dimensions!A17:U20` 已渲染检查。
- F004：Design doc 90%，其余八维 0%，Overall 10%。
- F004 阶段：`DESIGN PACKAGE COMPLETE / FIGMA BLOCKED`。
- 没有把旧 F004 的 22%、静态文档或流程草稿误报为新方向运行时进度。

## 6. Figma 物质阻塞

2026-07-26 的精确诊断：

1. Figma `whoami` 成功：`skyfire / skyfire's team / Starter / seat=View`；
2. 对目标 Design `uU2Oek5RqFb19CPoGl48lC` 的只读 `use_figma` 在 MCP 传输层失败；
3. 内置浏览器打开目标文件超时；
4. 已安装 Chrome 的扩展控制通道返回不可用；
5. 八个 Design 节点和四张 FigJam 图未真实创建、未获得 node ID、未读回。

结论：

`BLOCKED: Figma UE attachment`

本地 `.mmd`、DOCX、PDF、PNG 和联系表都不能替代可编辑 Figma/FigJam。

## 7. 当前最高 Gate

已达到：

- `DESIGN_REBASELINE_REVIEW`
- `VISUAL_CONTRACT_REVIEW`

未达到：

- `DESIGN_REBASELINE_APPROVED`
- `VISUAL_CONTRACT_APPROVED`
- `ASSET_SET_APPROVED`
- `RUNTIME_SLICE_APPROVED`
- `SCALE_OUT_APPROVED`
- `RELEASE_VISUAL_APPROVED`

## 8. 未授权内容

本轮没有：

- 修改 Godot 场景、脚本、测试、存档或 `project.godot`；
- 创建新的 `f004_resident_*.csv`；
- 生成或批量重做道路、田地、建筑、居民资产；
- 把 F003 当作新方向完成证据；
- 安排本机关机。

条件式关机要求尚未满足：Figma、用户设计审阅和运行时授权仍未关闭，因此不得安排关机。

## 9. 下一审阅入口

用户只需审阅：

1. 单一记忆点与低频规划方向；
2. `1×1` 网格和占地目录 V1.0；
3. 一名居民一个主岗位、有限离线推进、MVP 订单无硬倒计时三个推荐默认值；
4. Figma 编辑权限/连接恢复后，再审阅八个 Design 节点和四张 FigJam。

在以上设计门通过并获得新的运行时实装授权前，不进入 Godot。
