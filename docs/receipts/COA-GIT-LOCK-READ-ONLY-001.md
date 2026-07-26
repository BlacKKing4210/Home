# CityOfAnimals Git 与锁状态只读回执

- 回执 ID：`COA-GIT-LOCK-READ-ONLY-001`
- 请求 ID：`REQ-COA-GIT-LOCK-AUDIT-20260726`
- 日期：2026-07-26
- 唯一 accountable producer：Codex `/root`
- 请求类型：制作人执行请求；Git 远端接入与阻塞锁排查
- 项目根目录：`D:\AI\CityOfAnimals`
- RAG Gate：`tmp/rag/receipts/rag-gate.json`
- 请求上下文回执：`tmp/rag/receipts/tasks/REQ-COA-GIT-LOCK-AUDIT-20260726.json`

## 只读结论

1. 本地目录已经是 Git 仓库，分支为 `main`，但当前没有首个提交，也没有配置远端。
2. `git@github.com:BlacKKing4210/Home.git` 的 SSH 只读探测成功；远端没有任何 ref，按当前证据是空仓库。仓库公开/私有属性未能通过未登录 GitHub API 独立确认，因此不得将其视为公开发布目标。
3. 本地没有 `.git/index.lock`、`.git/config.lock`、`.git/HEAD.lock`，也没有 Godot、Excel、Word、PowerPoint、Git 或 SSH 写进程。`.godot/editor/project_metadata.cfg` 是编辑器元数据，不是阻塞锁。
4. 当前 Git 未跟踪项约 30,681 个。主要膨胀来源是 `tmp/`、嵌套 `node_modules` junction、Godot 生成的 `.import`/`.translation`、Python 缓存和本机 Vulkan 管线缓存。不能直接全量暂存或推送。
5. 未发现名称级凭据文件，也未在候选正式文件中命中常见私钥、GitHub Token、AWS Key 或明文密码模式。该结果只支持下一步安全整理，不替代提交前复检。
6. 真正会阻塞制作流程的是正式状态中的 `F004-DESIGN-LOCK-001`。它保护旧的 `F004-DISTRICT.1`，但 `PD-002` 已将当前方向重基线为 `F004-RESIDENT.1`。`docs/active_scope.yaml`、`docs/task_contract.md`、`docs/PM_HANDOFF.md`、两个索引和进度工作簿尚未同步，因此旧锁不能只删除，必须连同正式来源一次性迁移并留下释放回执。
7. Figma UE 仍为 `BLOCKED`，运行时权限仍为 `false`。释放旧设计锁只解除过期的文件协调阻塞，不等于设计批准、运行时授权或功能完成。

## 已核验的可复用正式来源

- 产品决策：`docs/decisions/PD-002-animal-resident-town-rebaseline.md`
- 新功能策划：`docs/features/F-004-resident-town-spatial-autonomy.md`
- UI/UX 优先级：`docs/uiux/F004-RESIDENT.1-ui-priority.md`
- 视觉质量合同：`docs/design/F004-RESIDENT.1-visual-quality-contract.md`
- 当前设计回执：`docs/receipts/F004-RESIDENT-DESIGN-001.md`
- 当前设计任务：`docs/tasks/F004-RESIDENT.1-design-rebaseline.md`
- 可编辑设计登记：`output/figma/F004-RESIDENT.1/README.md`

## 获准写入范围

本回执后只允许进行以下原子同步：

- 更新 `.gitignore`，排除本机构建缓存、临时目录、依赖 junction 和可再生导入产物；
- 将 Git 远端 `origin` 设置为用户指定的 `git@github.com:BlacKKing4210/Home.git`；
- 更新 `docs/active_scope.yaml`、`docs/task_contract.md`、`docs/PM_HANDOFF.md`、`docs/design_index.md`、`docs/config_index.md`；
- 更新 `PM/feature_progress.xlsx` 的 F-004 行，不沿用旧方向完成度；
- 新增 `docs/receipts/F004-DESIGN-LOCK-RELEASE-002.md`；
- 更新 RAG 清单、索引、Gate 和本请求上下文回执；
- 仅在提交前敏感信息、大文件、状态一致性和 RAG 检查全部通过后，创建首个 Git 提交并推送 `main`。

## 明确不在本次写入范围

- 不修改 Godot 场景、脚本、运行时资源、配置表或保存数据；
- 不创建新的动物、建筑、道路、田地或 UI 资产；
- 不把旧 F004 的文档、配置或证据删除；只标记为历史迁移输入；
- 不把 Figma、静态文档、测试、窗口打开或退出码当成运行时完成证据；
- 不安排关机。当前仍有 Figma、用户设计审阅和运行时授权阻塞，不满足条件式关机前提。

## 写后验证要求

1. 控制面检查通过，且旧锁有明确释放回执；
2. 正式来源、进度工作簿和 RAG 对 `F004-RESIDENT.1` 的身份与状态一致；
3. 工作簿无公式错误、样式破坏或旧 22% 完成度泄漏；
4. Git 候选文件不含 `tmp/`、依赖 junction、本机缓存、`.import`、`.translation`、`*.pyc` 或敏感信息；
5. 推送后远端 `main` 与本地提交一致；若远端写入失败，必须保持状态为未完成，不得卡住或误报成功。
