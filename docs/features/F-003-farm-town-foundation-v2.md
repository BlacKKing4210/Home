# F-003 动物小镇农场经营地基 V2

**文档编号：** COA-F003-FARM.2  
**功能 ID：** F-003  
**当前版本：** V0.9  
**文档状态：** 评审中；Figma 节点登记后可转实现批准  
**主策划 / 制作策划：** Codex `/root`  
**制作程序 / 制作美术：** Codex `/root`（当前会话直接执行，不创建新代理）  
**创建日期：** 2026-07-24  
**目标画布：** 720 x 1280 竖屏  
**默认语言：** `zh-CN`；设置内可切换并持久化 `en`  
**研究输入：** `docs/research/2026-07-hay-day-moment-to-moment-gap-study.md`  
**制作人决策：** `docs/receipts/F-003-DEEPPLAY-001.md`

## 版本历史

| 版本 | 编写人 | 审核人 | 批准人 | 日期 | 更新内容 |
|---|---|---|---|---:|---|
| V0.9 | Codex `/root` | 制作人自审 | 待 Figma 门禁 | 2026-07-24 | 将旧版固定农场卡片重构为库存播种、作物增殖、双仓储、动物、机器队列、动态委托、余货市场和大型地图的经营地基。 |

## 开发计划

| 责任方 | 负责人 | 阶段 | 完成条件 |
|---|---|---|---|
| 策划 | Codex `/root` | 规则与配置 | 本文、配置契约、边界、验收和商业安全评审通过。 |
| UI/UE | Codex `/root` | 可编辑 Figma | 系统框架、UE、主地图、对象交互和状态页面均有可编辑节点和预览。 |
| 美术 | Codex `/root` | ART-003 | 现有整板和动物资源有来源、切分、透明度、尺寸、原点和运行时目标证据。 |
| 程序 | Codex `/root` | 迭代 A/B/C | 模型、地图、操作、目标和语言逐轮完成；每轮有行为证据和回归。 |
| QA | Codex `/root` | 里程碑验收 | 真实 720 x 1280 画面、可操作路径、边界/中断/返场和无头回归通过。 |

## 目录

1. 术语缩写与修订标记  
2. 设计目的  
3. 功能概述  
4. 系统框架  
5. UE 流程  
6. 参考资料  
7. 配置表调整  
8. 系统逻辑  
9. UI 界面及子玩法  
10. 相关需求  
11. 关联拓展  
12. 验收与 QA

## 1. 术语缩写与修订标记

- **田格：** 一次播种/收获的最小地图对象。
- **留种线：** 为下一轮播种保留的作物库存。
- **粮仓：** 只存放作物与果实的容量池。
- **货物屋：** 存放饲料、动物产品、制成品和建材的容量池。
- **机器队列：** 已扣除输入、等待顺序加工的配方列表。
- **成品位：** 已完成但尚未收取的机器输出；占用时会阻塞后续生产完成。
- **邻里委托：** 1—2 类物品组成的短目标交付。
- **橡果集市：** 本地 NPC 立即收购余货的离线出口。
- **锁定入口：** 地图上可见但本版本未实现的后续系统地标，不得计为完成内容。
- **F003-FARM.1：** 被制作人拒绝为新基线的旧固定卡片实现，保留作历史证据。
- **F003-FARM.2：** 本文定义的全新经营地基版本。

## 2. 设计目的

### 2.1 主要目标

- 让玩家在大型动物小镇地图中直接种植、收获、喂养、排产、交付和出售，而不是操作一组文字卡片。
- 让播种消耗库存、收获产生净增殖，从第一分钟建立真实的作物经济。
- 用粮仓/货物屋容量、机器队列和成品位形成可理解的排程压力。
- 让同一批作物至少拥有“留种、做饲料、加工、交委托、卖余货”五种用途。
- 在前 10 分钟持续提供至少一个无需付费、无需长时间等待的有意义动作。
- 使用现有动物和建筑资源建立丰富、可读、原创的大地图内容密度。

### 2.2 次要目标

- 为后续多阶段货运、访客服务、扩张材料和在线经济保留稳定数据接口。
- 玩家只看建筑/动物/图标即可理解大部分状态，文字集中在底部情境层和详细面板。
- 配置与界面全部支持 `zh-CN` / `en`，避免后续硬编码返工。

### 2.3 非目标

- 不在本版本实现在线交易、好友、社群、求助或排行榜。
- 不实现完整列车、船运、航空或访客服务链；只允许显示原创锁定地标。
- 不实现商业变现、付费加速、广告或抽奖。
- 不复制参考产品的名字、数值、配方、地图、UI 布局、美术、角色、文本、代码或商业资产。
- 不在没有 ART-003 来源和运行时准备证据时使用整板候选图。

## 3. 功能概述

1. 玩家从大型 45° 动物小镇进入，第一视野包含成熟田、空田、粮仓、货物屋、混粮坊、鸡舍、牛栏、面包房、乳坊、委托板和橡果集市。
2. 玩家点击作物图标后扫过空田；每格消耗 1 单位对应作物库存。缺种时连续动作安全停止。
3. 作物成熟后扫过田格收获；容量足够时每格返回配置产量，产生净增殖，并显示库存与经验反馈。
4. 玩家把余量留作下一轮种子，或送入混粮坊、动物栏、生产机器、邻里委托或橡果集市。
5. 动物先消耗饲料再计时产出；机器入队时原子扣除原料，按队列顺序加工，完成后等待玩家收取。
6. 粮仓/货物屋满时相关收取动作被阻塞，但成熟作物、动物产物和机器成品不丢失。
7. 完成委托获得金币和声望；出售余货获得较低但即时的金币，并释放仓位。
8. 金币用于建设空位和容量升级，逐步让地图出现更多可见生产能力。

**单一主要决策：** 当前收获下一步应该留种、喂养、排产、交付还是出售？

**玩家记忆点：** 扫过一片成熟田，看到作物库存瞬间净增长，接着把余量拖入混粮坊或橡果集市，动物和机器同时“活”起来。

## 4. 系统框架

### 4.1 资源流

`作物库存 -> 播种 -> 成熟田 -> 收获净增殖`

收获后的作物分流：

- `作物 -> 留种 -> 下一轮播种`
- `作物 -> 混粮坊 -> 饲料 -> 动物栏 -> 动物产品`
- `作物 / 动物产品 -> 机器队列 -> 制成品`
- `作物 / 动物产品 / 制成品 -> 邻里委托 -> 金币 + 声望`
- `余货 -> 橡果集市 -> 金币`
- `金币 -> 建设 / 仓储升级 -> 新生产能力与容量`

### 4.2 时间层

- **5—30 秒：** 选择作物、连续播种/收获、看见净增长。
- **1—5 分钟：** 饲料、动物和机器队列排程。
- **3—15 分钟：** 三张动态委托、余货出售和建设选择。
- **小时级：** 容量升级、更多建筑和地图扩张。
- **后续版本：** 多箱货运、访客服务和异步协作。

### 4.3 Figma UE & UI/UX Artifact Register

| 图类型 | 可编辑源 | 页面/区段 | 节点 | 版本 | 负责人 | 评审状态 | 覆盖 |
|---|---|---|---|---|---|---|---|
| 系统框架 | [Figma Design](https://www.figma.com/design/uU2Oek5RqFb19CPoGl48lC/Untitled) | `CityOfAnimals F003 Farm Foundation V2` | `city_of_animals_f003_farm2_ue 1 / 00_System_Framework` | V1.0 / 2026-07-24 | Codex `/root` | `VERIFIED EDITABLE` | 资源流、时间层、阻塞点、后续接口 |
| 玩家 UE 流程 | 同上 | 同上 | `city_of_animals_f003_farm2_ue 1 / 01_Player_UE_Flow` | V1.0 / 2026-07-24 | Codex `/root` | `VERIFIED EDITABLE` | 进入、收获、播种、分流、失败、返回 |
| 主地图与相机 | 同上 | 同上 | `city_of_animals_f003_farm2_ue 1 / 02_Main_Map_720x1280` | V1.0 / 2026-07-24 | Codex `/root` | `VERIFIED EDITABLE` | 720 x 1280、拖拽相机、18+ 对象 |
| 建筑交互 | 同上 | 同上 | `city_of_animals_f003_farm2_ue 1 / 03_Object_Interactions` | V1.0 / 2026-07-24 | Codex `/root` | `VERIFIED EDITABLE` | 田地、动物、机器、仓储、委托、市场 |
| 状态与边界 | 同上 | 同上 | `city_of_animals_f003_farm2_ue 1 / 04_States_And_Edges` | V1.0 / 2026-07-24 | Codex `/root` | `VERIFIED EDITABLE` | 缺种、缺料、仓满、锁定、中断、返场 |
| 设置与语言 | 同上 | 同上 | `city_of_animals_f003_farm2_ue 1 / 05_Settings_720x1280` | V1.0 / 2026-07-24 | Codex `/root` | `VERIFIED EDITABLE` | 首次 zh-CN、英文选择、持久化和减弱动态效果 |

**门禁结果：** `PASSED`。Figma 桌面端已验证上述根 Frame 和命名 Group 均为可编辑矢量节点；Figma Starter API 配额未返回 GUID，因此以稳定页面/层名称作为节点引用。评审预览为 `output/figma/F003-FARM.2/city_of_animals_f003_farm2_ue-preview.png`，可重导入源为同目录 SVG；Figma 文件仍是 UI/UE 源真相。

## 5. UE 流程

### 5.1 首次进入

1. 镜头对准成熟的金穗草田、粮仓和混粮坊。
2. 成熟田出现可收取图标，底部只显示“收获”一个主动作提示。
3. 玩家划过成熟田，逐格播放收获反馈；HUD 同时显示 `+产量` 和粮仓占用变化。
4. 末格收获后打开三向情境选择：继续播种、去混粮坊、去橡果集市。
5. 玩家选择继续播种，作物盘只展示已解锁且库存大于 0 的作物。
6. 玩家扫过空田，库存逐格减少，田格切换为生长态。
7. 引导结束，镜头允许自由拖动；不再用强制弹窗打断。

### 5.2 常规收获与播种

| 起点 | 玩家动作 / 系统事件 | 条件 | 终点 | 失败 / 返回 |
|---|---|---|---|---|
| 空闲地图 | 点击空田 | 有已选作物且库存足够 | 单格播种 | 无选择则打开作物盘；缺种显示缺种反馈 |
| 空闲地图 | 划过连续空田 | 每格通过库存预检 | 逐格播种 | 最后一格安全停止；不透支 |
| 成熟田 | 点击或划过 | 粮仓有完整产量空间 | 收获并增加库存 | 粮仓满：保持成熟，不丢产物 |
| 生长田 | 点击 | 未成熟 | 显示剩余时间 | 返回地图；本版本无付费加速 |

### 5.3 生产与收取

1. 点击机器，底部情境层显示配方图标、输入库存、当前队列和一个主 CTA。
2. 选择配方后做全部输入预检；通过时一次性扣除并入队。
3. 空闲机器立即启动首项；其余项保持顺序。
4. 计时结束后，若成品位为空，则产品进入成品位并显示收取图标。
5. 玩家点击收取；货物屋有空间则入仓并启动下一项，否则保留成品并显示货仓满。

### 5.4 动物

1. 点击空腹动物栏；若有对应饲料，主 CTA 为“喂养”。
2. 喂养成功后一次性扣除饲料，动物进入生产中。
3. 计时结束后动物栏进入可收取态。
4. 收取前检查货物屋；成功后增加动物产品并回到空腹态。

### 5.5 委托与市场

- 委托板同时保留 3 张请求；完成一张后从已解锁池补充。
- 不合适的请求可丢弃，槽位显示刷新倒计时。
- 缺货时点击需求图标，镜头可跳转到相关来源建筑，不自动购买。
- 橡果集市让玩家选物和数量，确认后原子扣货并发金币；价值低于目标委托，作用是释放仓位。

### 5.6 手势冲突

- 从空白地面开始且位移超过 `camera_pan_threshold_px`：相机平移。
- 从可操作田格开始且经过相邻田格：田地连续操作。
- 从建筑开始且位移未超过阈值：对象选择。
- 已打开底部情境层时，地图拖动仍可用；面板纵向滑动只在面板范围生效。
- 多指缩放不属于 MVP；保留 `camera_zoom_min/max` 配置但锁定同值。

## 6. 参考资料

- `https://www.youtube.com/watch?v=zgAysNgvDuk`：只参考“高频作物循环同时牵动库存、仓储和出售吞吐”的品类观察；播放器内容未逐帧核验。
- Supercell 官方支持页：只用于确认队列、成品阻塞、分仓、订单、市场、扩张和城镇服务等系统事实。
- `docs/research/2026-07-hay-day-moment-to-moment-gap-study.md`：完整来源、证据等级、未核验项和原创转译。

## 7. 配置表调整

所有新字段进入 `config/tables/*.csv`，不得埋在 `town_view.gd` 或控件文本中。

### 7.1 `config/tables/f003_v2_items.csv`

| 字段 | 类型 | 规则 |
|---|---|---|
| `item_id` | string/id | 唯一 ID；保存、配方、订单和 locale 关联键。 |
| `category` | enum | `crop`, `feed`, `animal_product`, `product`, `material`。 |
| `storage_type` | enum | `granary` 或 `storehouse`。 |
| `unlock_level` | int | 默认 1，最小 1。 |
| `initial_amount` | int | 初始库存；必须通过前 10 分钟无硬锁模拟。 |
| `stack_size` | int | 单格逻辑上限；MVP 仅用于校验。 |
| `market_coin_value` | int | NPC 集市单价；不等于委托价值。 |
| `icon_key` | string | 指向项目内图标/emoji/SVG 键。 |
| `name_locale_key` | string | 指向 locale 表。 |

首轮 ID：`golden_sprig`, `cloud_bean`, `root_carrot`, `leafy_feed`, `spotted_egg`, `cloud_milk`, `hearth_loaf`, `soft_cream`, `root_preserve`。

### 7.2 `config/tables/f003_v2_crops.csv`

| 字段 | 类型 | 首轮约束 |
|---|---|---|
| `crop_id` | id | 必须存在于 items。 |
| `grow_seconds` | float | `golden_sprig=8`, `cloud_bean=25`, `root_carrot=60`；原创原型值。 |
| `plant_cost` | int | 首轮均为 1。 |
| `harvest_yield` | int | 分别为 3、3、4；必须大于 `plant_cost`。 |
| `xp_per_plot` | int | 1—3；只由模型发放。 |
| `field_visual_key` | string | 空、幼苗、生长、成熟四态资源前缀。 |

### 7.3 `config/tables/f003_v2_storage.csv`

| 字段 | 类型 | 默认值 / 规则 |
|---|---|---|
| `storage_id` | id | `granary`, `storehouse`。 |
| `base_capacity` | int | 48 / 40。 |
| `upgrade_level` | int | 初始 1。 |
| `capacity_per_level` | int | 12 / 10。 |
| `upgrade_costs` | id-count list | 引用 items 中的原创建材；MVP 可显示锁定升级。 |
| `building_id` | id | 地图建筑关联。 |

容量公式：`capacity = base_capacity + (upgrade_level - 1) * capacity_per_level`。

### 7.4 `config/tables/f003_v2_recipes.csv`

| 字段 | 类型 | 规则 |
|---|---|---|
| `recipe_id` | id | 唯一。 |
| `machine_id` | id | `feedworks`, `dawn_bakery`, `cloud_dairy`。 |
| `input_items` | id-count list | 入队时原子扣除。 |
| `output_item_id` | id | 进入成品位。 |
| `output_count` | int | 首轮 1。 |
| `duration_seconds` | float | 12—50 秒的原创 MVP 时长。 |
| `unlock_level` | int | 首轮 1—3。 |
| `queue_icon_key` | string | 队列图标。 |

首轮配方：

- `leafy_feed`: `golden_sprig*2 + cloud_bean*1 -> leafy_feed*1`, 12 秒；
- `hearth_loaf`: `golden_sprig*3 + spotted_egg*1 -> hearth_loaf*1`, 35 秒；
- `soft_cream`: `cloud_milk*2 -> soft_cream*1`, 40 秒；
- `root_preserve`: `root_carrot*3 + cloud_bean*1 -> root_preserve*1`, 50 秒；作为面包房之外的后续同批机器候选，不要求首轮地图全部开放。

### 7.5 `config/tables/f003_v2_animals.csv`

| 字段 | 类型 | 首轮值 |
|---|---|---|
| `pen_id` | id | `sunny_coop`, `willow_cow_pen`。 |
| `animal_asset_id` | id | `animal_chicken_v1`, `animal_cow_v1`。 |
| `animal_count` | int | 3 / 2。 |
| `feed_item_id` | id | `leafy_feed`。 |
| `feed_cost` | int | 1 / 2。 |
| `output_item_id` | id | `spotted_egg` / `cloud_milk`。 |
| `output_count` | int | 2 / 2。 |
| `duration_seconds` | float | 18 / 30。 |

### 7.6 `config/tables/f003_v2_buildings.csv`

| 字段 | 类型 | 规则 |
|---|---|---|
| `building_id` | id | 唯一。 |
| `building_type` | enum | `machine`, `pen`, `storage`, `request`, `market`, `landmark`, `locked_gateway`, `construction_site`。 |
| `world_x`, `world_y` | float | 世界坐标；不得写在视图逻辑。 |
| `footprint_w`, `footprint_h` | int | 等距地块占用。 |
| `asset_id` | id | ART-003 运行时资源 ID。 |
| `unlock_level` | int | 未解锁显示锁定/工地。 |
| `build_coin_cost` | int | 建造成本。 |
| `build_seconds` | float | 建造时间。 |
| `queue_slots` | int | 机器 2—3；非机器 0。 |
| `name_locale_key` | string | locale 键。 |

### 7.7 `config/tables/f003_v2_requests.csv`

| 字段 | 类型 | 规则 |
|---|---|---|
| `request_pool_id` | id | 首轮 `neighbor_basic`。 |
| `slot_count` | int | 3。 |
| `min_item_types`, `max_item_types` | int | 1 / 2。 |
| `eligible_categories` | list | crop、animal_product、product。 |
| `amount_min`, `amount_max` | int | 按解锁级别和类别限制。 |
| `coin_multiplier` | float | 只作用于委托奖励。 |
| `renown_reward_min/max` | int | 1—4。 |
| `discard_refresh_seconds` | float | 30 秒原创 MVP 值。 |
| `seed_salt` | string | 可复现生成，便于 QA。 |

### 7.8 `config/tables/f003_v2_world.csv`

| 字段 | 类型 | 默认 |
|---|---|---|
| `world_width`, `world_height` | int | 1800 / 1700。 |
| `camera_min_x/max_x/min_y/max_y` | float | 由世界边界和安全区决定。 |
| `camera_pan_threshold_px` | float | 12。 |
| `field_drag_step_px` | float | 24。 |
| `camera_zoom_min/max` | float | MVP 同为 1.0。 |
| `starter_field_count` | int | 12。 |
| `autosave_interval_seconds` | float | 10。 |

### 7.9 `config/tables/f003_v2_locale.csv`

列：`locale_key,zh_CN,en`。所有建筑、物品、状态、按钮、失败反馈和设置文本必须使用 locale key。

设置保存源：`user://city_of_animals_preferences.cfg::language_code`，首次启动默认 `zh-CN`，可选 `en`。

## 8. 系统逻辑

### 8.1 权威模型

- `town_model.gd` 或后续拆分的领域模型是库存、计时、队列、奖励和保存的唯一权威。
- `town_view.gd` 只发送意图和表现结果，不直接改库存、金币、队列或完成时间。
- 所有扣除/发放使用“预检 -> 原子提交 -> 事件 -> 保存脏标记”顺序。
- 游戏离线计时使用保存的 Unix 时间戳；返场计算只推进已开始的作物、动物、机器和建造，不自动收取。
- 可复现请求生成使用保存种子与槽位序号，重进不得无故换单。

### 8.2 作物状态机

`EMPTY -> GROWING -> READY -> EMPTY`

- `EMPTY + plant(crop)`：检查 crop 解锁、库存和手势目标；扣 `plant_cost`；记录 `ready_at`。
- `GROWING`：返场或 tick 达到 `ready_at` 后转 `READY`。
- `READY + harvest`：检查粮仓完整容量；发放 `harvest_yield` 与 XP；转 `EMPTY`。
- 容量不足：停留 `READY`；不部分收取、不溢出、不丢失。

### 8.3 机器状态机

`IDLE -> PROCESSING -> OUTPUT_READY -> IDLE/PROCESSING`

- 入队只要队列未满且输入足够；入队时扣料。
- `IDLE` 收到首项立即记录 `finish_at`。
- 完成时如成品位为空，进入 `OUTPUT_READY`；等待项不越过成品位。
- 收取成功后，如果队列还有项，立即启动下一项。
- 返场可完成当前项，但不穿透成品位批量完成多个队列项。

### 8.4 动物状态机

`HUNGRY -> PRODUCING -> READY -> HUNGRY`

- 喂养时扣饲料并记录 `ready_at`。
- 货物屋满时保持 `READY`。
- 收取成功发产物并回到 `HUNGRY`。

### 8.5 委托事务

1. 读取当前槽位需求。
2. 一次性验证所有物品库存。
3. 一次性扣除所有需求。
4. 发放金币和声望。
5. 记录事件与完成计数。
6. 根据槽位种子生成下一张请求。
7. 任一步骤失败则不扣货、不发奖、不换单。

### 8.6 保存与迁移

保存字段至少包含：

- `schema_version`
- `language_code`
- `coins`, `renown`, `player_level`
- `inventories`
- `storage_upgrade_levels`
- `fields[crop_id,state,ready_at]`
- `machines[queue,current,finish_at,output]`
- `pens[state,ready_at]`
- `requests[slot,state,refresh_at,seed]`
- `buildings[unlock,construction_finish_at]`
- `camera_position`

旧 F003-FARM.1 存档必须通过 `schema_version` 迁移到安全初始状态；不得把不存在的旧数据解释成已扣除库存。

### 8.7 状态与边界矩阵

| 状态 / 场景 | 进入条件 | 允许操作 | 系统处理 | 页面/反馈 | 退出条件 |
|---|---|---|---|---|---|
| 缺种 | 连续播种下一格库存不足 | 换作物、去市场/来源 | 不透支、不回滚已成功田格 | 最后一格抖动 + 作物图标缺口 | 选到有库存作物 |
| 粮仓满 | 收获完整产量放不下 | 开粮仓、出售作物 | 保持成熟 | 田地保留成熟 + 粮仓脉冲 | 释放足够空间 |
| 货物屋满 | 收动物/机器成品放不下 | 开货物屋、交委托、出售 | 保留可收状态 | 建筑保留成品图标 | 释放足够空间 |
| 机器队列满 | 尝试追加配方 | 收成品、等待 | 不扣原料 | 槽位边框和禁用 CTA | 有空槽 |
| 缺原料 | 配方或委托预检失败 | 跳转来源、关闭 | 不扣除 | 缺少项以图标数量显示 | 库存满足 |
| 请求刷新 | 玩家丢弃请求 | 查看其他槽 | 记录 `refresh_at` | 槽位变倒计时 | 倒计时结束 |
| 建筑锁定 | 等级/金币不足 | 查看需求、关闭 | 不建造 | 工地/锁图标 | 条件满足 |
| 中断/切后台 | 系统通知 | 无 | 保存脏数据与时间戳 | 不弹失败 | 回前台重算 |
| 旧存档 | schema 低于 V2 | 继续 | 安全迁移并记录 | 一次性简短提示 | 新 schema 保存成功 |
| 无可行动项 | 所有产线等待且无可播种 | 查看计时、市场、建设 | 检测防硬锁救援 | 给出“最近完成”对象导航 | 出现可操作对象 |

## 9. UI 界面及子玩法

### 9.1 页面清单

| 页面 ID / 名称 | 入口 | 退出 / 返回 | 主要状态 | Figma 节点 |
|---|---|---|---|---|
| `F003-MAP` 主地图 | 启动/返回 | 设置或系统退出 | idle、pan、selected、blocked、return | 待登记 |
| `F003-CROP` 作物盘 | 点击空田/播种工具 | 选作物/点外部 | available、locked、empty | 待登记 |
| `F003-CONTEXT` 底部情境层 | 选对象 | 下滑/点外部/完成动作 | one-primary-action、disabled、success | 待登记 |
| `F003-MACHINE` 机器配方层 | 选机器 | 返回地图 | idle、processing、queue-full、output-ready | 待登记 |
| `F003-STORAGE` 双仓详情 | 选仓储/HUD 容量 | 返回地图 | normal、near-full、full | 待登记 |
| `F003-REQUESTS` 邻里委托 | 选委托板 | 返回地图 | ready、missing、refreshing、success | 待登记 |
| `F003-MARKET` 橡果集市 | 选市场 | 取消/确认 | item-select、quantity、confirm、empty | 待登记 |
| `F003-SETTINGS` 设置 | 齿轮 | 保存返回 | zh-CN、en | 待登记 |

### 9.2 主地图信息优先级

- **P0：** 当前可操作对象状态、选中对象、一个主动作、相关物品数量。
- **P1：** 金币、声望/等级、相关仓储容量、当前委托目标、相机方向。
- **P2：** 队列槽、建设需求、最近完成对象导航、语言/设置。
- **P3：** 装饰、环境叙事、次要居民气泡。

### 9.3 HUD

- 左上：玩家等级/声望进度。
- 顶部中：金币。
- 右上：设置。
- 选中田地时显示粮仓占用；选中机器/动物时显示货物屋占用；不同时常驻两个巨大容量条。
- 底部情境层最多一个强调 CTA；次要动作使用小图标或滑动列表。

### 9.4 对象状态表达

| 对象 | 默认 | 进行中 | 可收取 | 阻塞 |
|---|---|---|---|---|
| 田格 | 土壤/作物阶段 | 生长视觉 + 可选剩余时间 | 成熟作物 + 收获工具图标 | 成熟不变 + 粮仓满图标 |
| 动物栏 | 动物饥饿动作 | 吃食/闲逛 + 小计时环 | 产物图标 | 产物 + 货物屋满图标 |
| 机器 | 建筑闲置微动 | 烟/轮子/灯 + 队列点 | 成品篮图标 | 成品篮 + 货物屋满 |
| 委托板 | 三张纸卡轮廓 | 无 | 可完成请求高亮 | 缺货物品图标 |
| 市场 | 摊位与货箱 | 无 | 可出售箭头 | 无可售物时空箱 |

### 9.5 可访问性

- 720 x 1280 竖屏；适配安全区，不让 HUD 贴系统刘海/手势区。
- 可点击目标至少 52 x 52 逻辑像素。
- 状态不能只靠红/绿；使用图标、轮廓、动画和文本组合。
- 正文和关键数量满足可读对比；地图文字带描边/底板。
- 设置里提供 `reduced_motion` 预留键；MVP 至少停止无限摇摆和强闪烁。

## 10. 相关需求

### 10.1 美术资源需求

| 资源 ID / 名称 | 用途 | 规格 / 状态 | 负责人 / 优先级 |
|---|---|---|---|
| `animal_chicken_v1` | 鸡舍动物 | 现有 512 RGBA 候选；ART-003 后运行时缩放 | Codex / P0 |
| `animal_cow_v1` | 牛栏动物 | 现有 512 RGBA 候选；ART-003 后运行时缩放 | Codex / P0 |
| `building_feedworks_v1` | 混粮坊 | 现有整板切分；透明 PNG；统一脚点 | Codex / P0 |
| `building_coop_v1` | 鸡舍 | 现有整板切分；透明 PNG | Codex / P0 |
| `building_cow_pen_v1` | 牛栏 | 现有整板切分或现有畜栏候选 | Codex / P0 |
| `building_bakery_v1` | 面包房 | 现有整板切分；透明 PNG | Codex / P0 |
| `building_dairy_v1` | 乳坊 | 现有整板切分；透明 PNG | Codex / P0 |
| `building_granary_v1` | 粮仓 | 现有整板切分；透明 PNG | Codex / P0 |
| `building_storehouse_v1` | 货物屋 | 现有整板切分；透明 PNG | Codex / P0 |
| `building_market_v1` | 橡果集市 | 现有整板切分；透明 PNG | Codex / P0 |
| `field_*_stage_*` | 三种作物四阶段 | 可由现有田地板切分/原型 SVG 补位 | Codex / P0 |
| `state_icon_*` | 缺种/缺料/仓满/可收取 | 原创 SVG 图标，不使用商业 UI | Codex / P0 |

切分后图像要求：RGBA、透明背景、无外部文字/水印、主体完整、统一白边策略、脚点和占地元数据明确；整板原图只作来源证据，不作为运行时纹理。

### 10.2 音乐音效需求

MVP 可用程序性临时音，不从商业产品提取：

- `sfx_plant`, `sfx_harvest_chain`, `sfx_collect`, `sfx_queue`, `sfx_order_complete`, `sfx_storage_full`
- 连续收获每格音高轻微递增，结束后复位；减少动效设置关闭强烈连锁效果。

### 10.3 动效需求

- 使用 Tween/AnimationPlayer 对视觉子节点做弹跳、挤压、轻旋、闪光和飘字。
- 不移动逻辑坐标、碰撞、焦点或触摸区域。
- 反馈可中断、可复位；节点离树时停止无限循环。

### 10.4 功能打点需求

| 事件名 | 触发时机 | 参数 / 数据源 | 目的 |
|---|---|---|---|
| `crop_planted` | 成功播种一格 | crop_id, stock_after, field_id | 验证留种线与连续播种 |
| `crop_harvested` | 成功收获一格 | crop_id, yield, capacity_after | 验证增殖与仓压 |
| `action_blocked` | 任意预检失败 | reason, object_id, item_id | 发现硬锁和信息问题 |
| `recipe_queued` | 配方入队 | machine_id, recipe_id, queue_depth | 调整产线节奏 |
| `animal_collected` | 收动物产品 | pen_id, item_id | 验证动物链 |
| `request_completed` | 委托原子完成 | request_id, item_types, coins, renown | 调整目标价值 |
| `market_sold` | 集市出售 | item_id, amount, coins | 检查余货吞吐 |
| `session_no_action` | 30 秒无可执行动作 | blockers, timers | 检测前 10 分钟硬锁 |

## 11. 关联拓展

- F-004 可在本地经营地基通过后扩充农区、工业建筑和建设位，不得绕过 F003 模型契约。
- F-005 及以后可复用委托事务、库存和机器接口实现多箱货运。
- 城镇访客复用“需求 -> 服务建筑 -> 等待 -> 奖励”接口，但必须是独立功能。
- 在线市场需要服务器权威和阿里云部署档案；本地 NPC 市场不得静默升级成联网服务。
- 后续内容批次可增加猪、羊、兔、果树、纺织和制酱，不改变双仓储和生产队列基本语义。

## 12. 验收与 QA

### 12.1 交付验收

- [x] 策划：所有目标、规则、状态、边界、配置和版本一致。
- [x] Figma：系统框架、UE、主地图、建筑交互和状态矩阵有可编辑节点及预览。
- [x] 数据：所有可调项位于本文声明的 `config/tables/*.csv`。
- [x] 程序：播种扣库存、收获净增殖、双仓储、动物、队列、委托和市场全部由权威模型处理。
- [x] 地图：720 x 1280 真实运行画面中可见大于一屏的世界，支持拖动并有 18+ 可辨对象。
- [x] 操作：田地连续播种/收获与相机拖动不冲突。
- [x] 边界：缺种、缺料、粮仓满、货物屋满、队列满、请求刷新、中断和旧存档均无丢失/透支。
- [x] 节奏：配置化前 10 分钟模拟始终至少存在一个有意义动作。
- [x] 语言：首次为简体中文，可切英文且重启保持选择；无未登记硬编码玩家文本。
- [x] 美术实装：26 个动物/建筑/田块具备 ART-003 来源、切分、尺寸、原点、联系表和运行时清单；候选与运行时逐项哈希一致。
- [x] QA：模型测试、无头启动、真实玩家画面、操作路径和作用域回归通过。
- [x] 文档：DOCX/PDF 完成结构检查；可编辑 Figma 与登记版本一致。

### 12.2 关键测试

1. 初始金穗草 12 个，连续播种 12 格后恰好为 0；任何第 13 格操作不透支。
2. 12 格收获后获得 36 个，净增长 24；容量不足以容纳完整一格产量时保持成熟。
3. 机器入队失败不扣料；成功入队只扣一次；重进不重复扣料。
4. 成品位未收时，后续队列不穿透完成。
5. 货物屋满时鸡蛋/牛奶/成品均保留可收状态。
6. 委托多物品中任一不足时全部不扣；成功时全部扣除并只发一次奖励。
7. 丢弃委托后重进，刷新剩余时间连续且请求不随机变化。
8. 相机拖动从空地开始；田地划动从田格开始；两者不相互触发。
9. 切后台跨越完成时间后，返回只更新状态，不自动收取或跳过成品位。
10. 旧存档迁移后拥有安全初始种子，不出现负数、丢建筑或语言丢失。

### 12.3 待确认与评审记录

| 问题 / 决策 | 状态 | 责任人 | 截止日期 | 结论及影响版本 |
|---|---|---|---:|---|
| 可编辑 Figma 节点与预览登记 | 已完成 | Codex `/root` | 2026-07-24 | 页面、稳定层名和完整预览已登记；见 `F-003-FARM2-DESIGN-001`。 |
| ART-003 整板切分、来源登记与运行时晋级 | 已完成 / `RUNTIME` | Codex `/root` | 2026-07-24 | 26 个候选通过来源板和机械 QA，并以零哈希差异晋级 `assets/runtime/f003_farm2/`。 |
| 通用模板 DOCX/PDF 与逐页视觉 QA | 已完成 | Codex `/root` | 2026-07-24 | 21 页 A4 PDF、目录/页码、7 张可编辑 Figma 评审图、替代文本和结构审计通过；见 `F-003-FARM2-DOCUMENT-001`。 |
| F003-FARM.2 工程只读基线、三轮迭代与行为验收 | 已完成 | Codex `/root` | 2026-07-24 | `F-003-FARM2-ENG-001` 授权写入；A/B/C 三轮完成；`F-003-FARM2-ENG-002` 以五张真实画面和四组运行日志关闭。 |
