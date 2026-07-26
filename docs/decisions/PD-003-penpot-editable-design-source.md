# PD-003 Penpot 可编辑设计源切换

**决策状态：** `APPROVED / FORMAL SOURCE RECORDED`
**决策日期：** 2026-07-26
**适用项目：** CityOfAnimals
**适用功能：** `F-004 / F004-RESIDENT.1` 及后续新建或物质性修改的玩家可见设计
**制作人：** Codex `/root`
**运行时权限：** `false`

## 正式决策

CityOfAnimals 从本决策起使用 **Penpot** 作为当前正式可编辑 UI、UE、状态图、页面布局、组件与视觉评审源。Figma/FigJam 不再是 F004 继续设计的前置依赖。

该切换只替换设计工具，不降低原有门槛：

1. 必须存在真实 Penpot 文件，而不是只有 PNG、PDF、SVG、Mermaid 或截图。
2. 文件必须可编辑、可再次打开并完成对象级回读。
3. 页面、画板、组件、状态与流程对象必须有稳定名称或对象引用。
4. 评审导出必须与 Penpot 源版本一致，并保留清晰的 PNG/PDF 预览。
5. 静态文档、导入源或浏览器打开成功不能单独关闭可编辑设计 Gate。
6. Penpot 设计通过也不等于 Godot 运行时完成；运行时仍需单独只读回执、精确写集和行为级证据。

## 正式源与派生物

| 类型 | 正式地位 | 要求 |
|---|---|---|
| Penpot 云端可编辑文件 | UI/UE 与视觉评审 source of truth | 登记 URL、workspace/project/file ID、页面/画板、对象引用、版本、owner、review state 与覆盖范围 |
| 本地可编辑 SVG | Penpot 导入源与可审计备份 | 保留图层/分组/对象命名；不得单独标记 Gate 通过 |
| PNG/PDF | 评审预览与文档附件 | 必须注明对应 Penpot 版本 |
| Mermaid | 逻辑草稿 | 可用于早期推理，不是最终可编辑交付 |
| Figma/FigJam 历史文件 | 历史证据 | 不删除、不重写；不再阻塞当前 F004 |

## F004 迁移结论

- 旧状态 `BLOCKED: Figma UE attachment` 改为 `SUPERSEDED TOOL BLOCKER / HISTORICAL EVIDENCE`。
- 当前新状态为 `PENDING: Penpot authenticated editable file creation and readback`。
- `output/figma/F004-RESIDENT.1/` 保留为历史诊断与 Mermaid 草稿来源。
- 新登记目录为 `output/penpot/F004-RESIDENT.1/`。
- F004 的八个页面/状态评审面和四张流程图继续保留原覆盖要求，只把承载工具改为 Penpot。
- 当前 Penpot SaaS 登录页已验证可访问；尚无本任务可用的已认证会话，因此本决策不伪报远端可编辑文件已创建。

## Penpot Gate

`PENPOT_EDITABLE_SOURCE_READY` 必须同时满足：

1. 在 `https://design.penpot.app/` 的已认证账号中创建 `CityOfAnimals / F004-RESIDENT.1`；
2. 导入或原生建立完整页面、组件、状态和四张流程图；
3. 记录 file URL、ID、页面/画板与对象引用；
4. 再次打开文件并验证关键对象可选中、可编辑；
5. 导出 PNG/PDF 并与源版本一致；
6. 制作人完成视觉、信息层级、状态覆盖和原创性审阅；
7. 用户完成详细占地目录与推荐默认值审阅。

在上述条件完成前，最高状态只能是 `DESIGN_REBASELINE_REVIEW / PENPOT_SOURCE_PENDING`。

## 托管约束

当前优先使用 Penpot 官方云服务。若未来选择自托管，必须另行获得部署授权，并按项目服务器规则部署到制作人批准的阿里云环境；不得在本地工作站留下持久化 Penpot 服务、数据库或公开端口。

## 未改变的边界

- `runtime_authority=false`；
- 不修改 Godot 场景、脚本、测试、存档、`project.godot` 或运行时资产；
- 不创建 `f004_resident_*.csv`；
- 不批量生成道路、田地、建筑或居民资产；
- 不把静态设计、测试通过、窗口打开或退出码当成运行时验收；
- 不复制 Township、Hay Day、Animal Crossing 或其他商业产品的角色、美术、UI、布局、文案、数值或商业身份。
