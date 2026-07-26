# ART-003 F003-FARM.2 资源准备合同

**合同编号：** ART-003-FARM2-001  
**版本：** ART-FARM2.1  
**状态：** `WRITE_AUTHORIZED / CANDIDATE / NOT_RUNTIME`  
**关联功能：** F-003 / F003-FARM.2  
**责任人：** Codex `/root`（制作人兼美术负责人）  
**首批计划消费者：** 后续单独工程回执授权的 `scripts/town/town_view.gd` 与 F003-FARM.2 地图场景  
**控制面指纹：** `7165BADF4FC3DEFAD654C49119BABED4FAB608FFD9592B87FA2E5024E8C15286`

## 1. 目标

把制作人已授权的四张原创建筑/农作板和五张项目内动物 PNG 整理成可追溯、可目视评审、可由后续工程任务消费的候选包。当前任务只完成来源冻结、整批评审、透明切分、归一化、清单和视觉 QA；不把任何文件放入正式或运行时目录，也不修改 Godot、场景、配置和测试。

## 2. 商业安全边界

- 只处理本合同列出的项目自有生成图和项目内已有动物 PNG。
- 参考 Hay Day/Township 的品类玩法、信息层级和经营语义，不复制其角色、建筑造型、贴图、图标、商标、文案、地图、UI 布局或数值。
- 不重绘、不拼接外部商业游戏资产，不从视频或截图提取资源。
- 原图主体像素只做确定性的背景透明化、边缘清理、等比缩放、对齐和画布归一化。
- 禁止从旧 `ART-001` 建筑风格评审板切分；它继续保持 `NO_SPLIT / NOT_RUNTIME`。

## 3. 来源冻结

### 3.1 建筑与农作整板

| 板号 | 来源 | SHA-256 | 规格 | 身份数 |
|---|---|---|---|---:|
| A | `C:\Users\76398\.codex\generated_images\019f7f4f-493e-7b21-8766-e256e7641e7f\exec-46192109-85ab-444c-a0c3-429caa3a3755.png` | `732DF4218000BE74F142907A9F8B65C26F631616FD8590742001884B7CFF8DD7` | 1536 x 1024 RGB | 7 |
| B | `C:\Users\76398\.codex\generated_images\019f7f4f-493e-7b21-8766-e256e7641e7f\exec-d5ab13cf-72de-47f5-9583-e81660c34b7d.png` | `031DEFDA240C2609E730376FF55934A02D6142793622A1AFC89F4CC9EE5D30F7` | 1536 x 1024 RGB | 4 |
| C | `C:\Users\76398\.codex\generated_images\019f7f4f-493e-7b21-8766-e256e7641e7f\exec-a6d4c21d-ca91-440b-9187-dc07e6a51403.png` | `74B4FA06E47191A05F7BDF8AB60F7719AE7F6A45219C0BC3796BFE603A175A84` | 1672 x 941 RGB | 5 |
| D | `C:\Users\76398\.codex\generated_images\019f7f4f-493e-7b21-8766-e256e7641e7f\exec-b8e58cf6-791c-439c-99bf-86c473a7abc9.png` | `55268CAF5756F5753B9A5B08DD521EBF0F52251352D2F528B347D13D5B6DF59B` | 1536 x 1024 RGB | 5 |

### 3.2 动物来源

| 资产 ID | 来源 | SHA-256 | 规格 |
|---|---|---|---|
| `animal_chicken_v1` | `assets/candidate/style_reference/animals/chicken.png` | `C9CE96C9A2051CDF041713F27FD668A34C0593D846B0346E08708A3FE8A3D5FC` | 512 x 512 RGBA |
| `animal_cow_v1` | `assets/candidate/style_reference/animals/cow.png` | `08688726FD23E39DA6BA666B1024657715F3FE95F9D41A8014C55677AF260371` | 512 x 512 RGBA |
| `animal_pig_v1` | `assets/candidate/style_reference/animals/pig.png` | `46C1747CC75527BD5364B5C92718C63FE6044F98D11848135C780C5B011A0AE5` | 512 x 512 RGBA |
| `animal_bear_v1` | `assets/candidate/style_reference/animals/bear.png` | `ACA7D5C74B4E0CBB12BB920413E563B0BCEB191710877FE68252EDE8FBCE4778` | 512 x 512 RGBA |
| `animal_rabbit_v1` | `assets/candidate/style_reference/animals/rabbit.png` | `18A95BCBBEAD2C3A6178B0F084FDA97FEA8A7BB22E9BEBF88CB3C4C1BD50F64D` | 512 x 512 RGBA |

## 4. 完整资产清单与固定单元格

整批评审板采用 5 列 x 6 行；每个身份只出现一次。单元格和切分矩形同时写入 `source-cell-map.json`，并以整批板 SHA-256 冻结。

| 单元格 | 资产 ID | 来源板 | 原图切分矩形 `[x0,y0,x1,y1]` |
|---|---|---|---|
| R1C1 | `plot_wheat_ready_v1` | A | `[40,150,350,450]` |
| R1C2 | `plot_clover_ready_v1` | A | `[345,175,685,455]` |
| R1C3 | `plot_sunflower_ready_v1` | A | `[650,115,1055,475]` |
| R1C4 | `plot_carrot_ready_v1` | A | `[1025,115,1530,490]` |
| R1C5 | `orchard_apple_v1` | A | `[25,430,545,925]` |
| R2C1 | `plot_tea_bush_v1` | A | `[515,480,1005,925]` |
| R2C2 | `building_feedworks_v1` | A | `[975,420,1530,935]` |
| R2C3 | `pen_sheep_v1` | B | `[40,115,470,495]` |
| R2C4 | `building_chicken_coop_v1` | B | `[465,115,895,500]` |
| R2C5 | `pen_pig_v1` | B | `[200,470,745,900]` |
| R3C1 | `building_granary_v1` | B | `[755,170,1520,865]` |
| R3C2 | `building_dairy_v1` | C | `[130,85,480,410]` |
| R3C3 | `building_preserve_v1` | C | `[535,70,895,415]` |
| R3C4 | `building_textile_v1` | C | `[1010,35,1510,425]` |
| R3C5 | `building_juice_press_v1` | C | `[180,430,625,830]` |
| R4C1 | `building_bakery_industrial_v1` | C | `[680,365,1475,920]` |
| R4C2 | `building_chicken_coop_v2` | D | `[10,55,505,525]` |
| R4C3 | `building_storehouse_v1` | D | `[470,35,1020,525]` |
| R4C4 | `building_grainworks_v1` | D | `[995,25,1530,535]` |
| R4C5 | `building_bakery_shop_v1` | D | `[145,465,725,995]` |
| R5C1 | `building_roadside_market_v1` | D | `[710,460,1370,1005]` |
| R5C2 | `animal_chicken_v1` | animal | full image |
| R5C3 | `animal_cow_v1` | animal | full image |
| R5C4 | `animal_pig_v1` | animal | full image |
| R5C5 | `animal_bear_v1` | animal | full image |
| R6C1 | `animal_rabbit_v1` | animal | full image |

R6C2—R6C5 标记为 `RESERVED`，不得放入额外未登记身份。

## 5. 整批评审门禁

在生成单件透明图之前，先生成：

- `output/art/ART-003-FARM2/review/ART-003-FARM2-source-board.png`
- `output/art/ART-003-FARM2/source-cell-map.json`

整批板要求：

- 5 x 6 固定网格，资产身份与单元格一一对应；
- 标签位于图像单元格之外，不压在主体上；
- 主体完整、不越格、不重复、不混合；
- 建筑裁片在内存中应用与最终输出相同的“边缘连通背景 + 中央主体连通域”预览掩码，动物保留原 alpha；评审板不落盘单件文件；
- 视觉负责人目视通过后记录板 SHA-256，之后才允许确定性透明化。

## 6. 单件输出规范

- 输出：512 x 512 RGBA PNG；
- 等比缩放，不拉伸；只允许缩小，不对来源主体放大；
- 至少 32 px 安全边距；水平居中；可见主体底部对齐到 y=480；
- 透明角点；无整板背景、标签、水印或相邻主体；
- 白色外描边策略保持一致，不把蓝色屋顶或深色轮廓误删；
- 元数据记录来源板、原始矩形、输出哈希、色彩模式、透明度范围、非透明包围盒、占用率和底部中心原点；
- 小图预览统一按 96 x 96 区域等比展示，不生成独立玩法资产。

## 7. 透明化方法

建筑板裁片通过“从裁片四边开始的连通背景分割”去除平滑青蓝背景，再只保留最接近裁片中心的主体连通域，以排除矩形边缘不可避免的相邻整板碎片。实现必须只删除与边缘连通、满足背景色相/亮度和邻域连续性约束的像素；白色外描边和被白边包围的蓝色屋顶不能被删除。边缘只可做一像素的抗锯齿整理。动物 PNG 保留原图 alpha，仅做等比归一化和对齐。

脚本、参数和结果必须可重复运行；每次运行先核验本合同的来源哈希，来源不一致即失败。

## 8. 输出路径与晋级边界

| 层级 | 路径 | 本任务状态 |
|---|---|---|
| 评审与证据 | `output/art/ART-003-FARM2/` | 允许写入 |
| 候选准备包 | `assets/candidate/f003_farm2/prepared/` | 允许写入；必须有 `.gdignore` |
| 正式归档 | `assets/formal/f003_farm2/v1/` | 仅保留目标，不创建 |
| 运行时 | `assets/runtime/f003_farm2/` | 仅保留目标，不创建 |

候选准备包保持 `NOT_RUNTIME`。只有在本任务视觉评审为 `READY_FOR_ENGINEERING`，并且后续独立工程回执登记首个消费者、加载路径、场景用途和回归范围后，才能把获选子集复制到正式/运行时目录。

## 9. 允许写入

- `docs/tasks/ART-003-f003-farm2-asset-preparation.md`
- `docs/receipts/ART-003-FARM2-001.md`
- `docs/receipts/F-003-FARM2-DESIGN-001.md`
- `docs/features/F-003-farm-town-foundation-v2.md`
- `docs/active_scope.yaml`
- `docs/PM_HANDOFF.md`
- `PM/feature_progress.xlsx`
- `output/art/ART-003-FARM2/`
- `assets/candidate/f003_farm2/`

禁止修改：`project.godot`、`scenes/`、`scripts/`、`config/`、`tests/`、`assets/formal/` 和 `assets/runtime/`。

## 10. 完成与评审

本任务需经过两个独立里程碑：

1. **SOURCE BOARD APPROVED：** 26 个身份、单元格、裁片和来源正确，整批板哈希已冻结。
2. **PREPARED PACKAGE APPROVED：** 26 个 512 RGBA 候选通过浅色、深色、棋盘格和 96 px 联系表目视检查；清单与哈希复核通过；无运行时引用。

结果只能是：

- `READY_FOR_ENGINEERING / NOT_RUNTIME`；
- `REVISION_REQUIRED / NOT_RUNTIME`；
- `BLOCKED / NOT_RUNTIME`。
