# F004-RESIDENT.1 Penpot V1.1 设计移交回执

- 日期：2026-07-26
- 请求：`REQ-F004-PENPOT-REBASELINE-20260726`
- Feature：`F-004 / F004-RESIDENT.1`
- 唯一 accountable producer：`Codex /root`
- 执行方式：当前制作人直接执行；未创建代理、子任务、线程或重复制作人
- 当前最高 Gate：`DESIGN_REBASELINE_REVIEW / PENPOT_IMPORT_SOURCE_READY`
- 运行时权限：`false`

## 1. 本轮完成

1. `PD-003` 已把 CityOfAnimals 的正式可编辑 UI/UE 源从 Figma/FigJam 切换为 Penpot；旧 Figma 席位与传输诊断只保留为历史证据。
2. `output/penpot/F004-RESIDENT.1/` 已形成 Penpot 可编辑导入包：
   - 8 个命名界面/状态组；
   - 4 个命名 UE/状态流程组；
   - 14 个必须回读的对象 ID；
   - `720×1280`、`zh-CN`、竖屏、`NOT_RUNTIME` 导入合同。
3. 已在真实像素尺寸导出和检查主地图、建造/道路、世界车辆订单三个 `720×1280` 关键帧。
4. `PM/feature_progress.xlsx` 已更新并重新读取验证：
   - F004 设计文档 `95%`；
   - Overall `10.55555556%`；
   - 当前阶段 `DESIGN PACKAGE V1.1 / PENPOT SOURCE PENDING`；
   - Overview 与 Active Batch 已从 F003/Figma 旧状态切到 F004/Penpot。
5. V1.1 正式评审包已生成：
   - DOCX 43 页；
   - PDF 43 页；
   - 879 个正文段落、27 张表、4 张审阅图片；
   - 11 张全页 contact sheet 覆盖全部 43 页。

## 2. 本地验证

| 检查 | 结论 |
|---|---|
| 两个 SVG XML 解析 | PASS |
| manifest 8 个 frame、4 个 flow、14 个 readback object | PASS；无缺失 ID |
| Penpot 总画板渲染 | PASS |
| 720×1280 主地图/建造/车辆订单关键帧 | PASS；无裁切、文字溢出或触控层级冲突 |
| feature_progress 写回与重新导入 | PASS |
| DOCX/PDF 全页视觉检查 | PASS；43/43 页，无空白页、截断或越界 |
| PDF 文本与字段检查 | PASS；无 `Reference source not found` / `Error!` |
| 运行时文件改动 | NONE |
| 项目共享锁 | NONE |
| `.git` 锁文件 | NONE |

## 3. 关键工件与 SHA-256

| 工件 | SHA-256 |
|---|---|
| `output/penpot/F004-RESIDENT.1/F004-RESIDENT.1-penpot-screen-source.svg` | `c6295643b7823dff79fa1ed726f83f81bb8cb86cec7172e283cf3d277c04b7cc` |
| `output/penpot/F004-RESIDENT.1/F004-RESIDENT.1-penpot-flow-source.svg` | `4dd65473786726825797bb745ae9bd64ce2ed9a981d0636c1b01fa96059affb4` |
| `output/penpot/F004-RESIDENT.1/penpot-import-manifest.json` | `5d08161b5006258f369c003f45a5e054c88f8754880735e8de08ad1c251589b0` |
| `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V1.1_REVIEW.docx` | `f0b9b0cd0c5f9d3b16479f5a8b274f210ce5dfb838121843513fb0b6cf4294dc` |
| `output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V1.1_REVIEW.pdf` | `f0b468eb0a2afb1adfd508b813232148c8bd01a9807ed39527be1c6fc77d9228` |
| `PM/feature_progress.xlsx` | `208b4ee3a4441561a9256346bcde357f9888a3245a41cf976385ae1553ce1189` |

## 4. RAG 与控制面

- 项目 Gate：`knowledge/index/rag-gate.json`
- Task Receipt：`knowledge/index/task-receipts/REQ-F004-PENPOT-REBASELINE-20260726.json`
- Context Pack：`knowledge/index/context/REQ-F004-PENPOT-REBASELINE-20260726.md`
- 控制面输入：`knowledge/index/REQ-F004-PENPOT-REBASELINE-20260726.control-plane.json`
- 最终 RAG 与控制面状态以本回执写入后最后一次 `prepare`、`pack` 和 `control_plane_check.py` 结果为准。

## 5. 未完成与边界

以下内容仍是物质性 Gate，不得误报为完成：

1. 在已认证 Penpot 账户中创建 `CityOfAnimals / F004-RESIDENT.1` 云端文件；
2. 导入本地 SVG，保留 8 个界面组、4 个流程组和对象命名；
3. 登记文件 URL、文件 ID、页面/画板与对象引用；
4. 再次打开并完成对象级可编辑/可选中回读；
5. 用户审阅并批准详细占地目录和推荐默认值；
6. 视觉质量合同审批；
7. 新工程只读回执、精确写集和 Godot 运行时实装授权。

静态 SVG、PNG、DOCX、PDF、工作簿、测试通过或窗口打开均不能替代 Penpot 云端可编辑回读，也不能证明运行时完成。

## 6. 下一步

用户在已打开的 Penpot 登录页完成登录后回复“已登录”。制作人随后只执行云端文件创建、SVG 导入、命名核对、对象回读与审阅登记；在上述 Gate 通过前不修改 Godot、配置表或玩家可见运行资源。
