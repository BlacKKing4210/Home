# F004-RESIDENT.2 真实运行证据

状态：`RUNTIME_SLICE_APPROVED / SCALE_OUT_APPROVED`
引擎：Godot 4.6.2 stable official `71f334935c000924d403448e698df4441130df18`
玩家视角：720×1280 竖屏，Windows OpenGL 3.3 Compatibility，NVIDIA GeForce RTX 4060 Laptop GPU
正式入口：`project.godot -> scenes/town_main.tscn -> scripts/town/f004_resident2_view.gd`

## 玩家可见状态

| 证据 | 可见行为 | 验收点 |
|---|---|---|
| `output/runtime/F004-RESIDENT.2/01-default-neighborhood.png` | 原住房、兔子、道路、装卸院与到达中的乳品车 | 不是菜单式订单；地图保留真实世界入口 |
| `02-invalid-overlap.png` | 红色占地格、冲突符号、禁用确认 | 1×1 最小单位、真实重叠阻止 |
| `03-valid-road-footprint.png` | 绿色 1×1 道路生活点、完整网格 | 合法占地、道路连接和确认 |
| `04-neighborhood-invited.png` | 2×2 新住房、3×3 牧场、2×2 乳品工坊、熊居民和奶牛 | 正式原创资产，无字母块或临时资源 |
| `05-road-interrupted.png` | 道路缺口、居民等待、定位缺口 CTA | 路径中断可见且不丢任务 |
| `06-pasture-work.png` | 熊照料奶牛、作业小环、五段图形任务轨迹 | 居民替代逐批手动生产 |
| `07-creamery-work.png` | 熊在工坊加工、图形轨迹推进 | 搬运与加工发生在世界内 |
| `08-loading-blocked.png` | 熊保留乳品箱、装卸位阻塞 | 中断不吞物品、不重复产出 |
| `09-vehicle-departing.png` | 货箱 1/1、车辆离场、120 金币一次结算 | 世界车辆订单完成包装 |
| `10-two-residents-life.png` | 熊和兔子回到生活点、五段轨迹完成 | 双居民可见日常和慢节奏余韵 |
| `11-settings-en-reduced.png` | 英文与减少动态打开，遮罩内无成功粒子泄漏 | 中文默认、英文可选、设置持久化、可访问性 |

## 行为级验证

- `tests/test_f004_resident2_scene.gd`：91 项 PASS。
- 覆盖配置、12 项 approved/shared 运行资产、非法重叠、越界、未接路、四次顺序建造、一次性扣费、车辆到达、邀请、派遣、道路阻塞/恢复、照料、挤奶、搬运、加工、装车阻塞/恢复、一次性奖励、车辆离场、双居民生活、存档中断恢复、zh-CN/en 和 reduced-motion。
- F004.1 回归：`tests/test_f004_resident_scene.gd` PASS。
- F003 FARM.2 回归：`tests/test_farm2_scene.gd` PASS。
- 镇区模型回归：`tests/test_town_model.gd` PASS。
- 正式主入口短时启动：exit 0，无脚本或资源错误。

## 性能与资源

`output/runtime/F004-RESIDENT.2/runtime-metrics.json`：

- 实测 180 帧采样：约 167 FPS；
- 引擎捕获时 FPS：约 101；
- 静态内存：约 50.7 MB；
- 节点数：4；
- approved runtime assets：12；
- candidate/source/qa 路径泄漏：false；
- reduced-motion 与英文状态均完成真实入口检查。

## 证据边界

本证据关闭 F004.2 代表性扩面切片，并允许复用规则继续扩面；它不证明全量建筑、铁路、空运、海运、Android 真机、发行包或商业化已经完成。静态 Penpot、文档和图片不单独承担运行时证明，运行验收以 Godot 行为脚本和真实渲染画面为准。
