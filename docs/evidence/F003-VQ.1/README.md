# F003-VQ.1 代表性运行切片证据

**日期：** 2026-07-25  
**引擎：** Godot `4.6.2.stable.official.71f334935`  
**渲染器：** OpenGL 3.3 Compatibility / NVIDIA GeForce RTX 4060 Laptop GPU  
**设计画布：** 720 x 1280 竖屏  
**门禁结论：** `RUNTIME_SLICE_APPROVED`  
**扩面结论：** `SCALE_OUT_APPROVED = false`

## 1. 玩家可见结果

- 起始镜头从 `x=420` 微调到 `x=380`，把 12 块田地放回主视觉中心并避免左侧成熟田块被截。
- 草地改为低频、低对比的 45° 大块纹理，农田区增加轻量色块、接触阴影和边界，建筑与田块的剪影更清楚。
- 成熟田块使用作物完整剪影、暖金外环和既有状态徽标；引导箭头在首次田地交互后退出，不再遮挡成熟作物。
- 成功收获后，程序化作物粒子从田块沿弧线飞向粮仓容量区，终点显示 `+产量`；田块与库存仍由权威模型原子结算。
- 粮仓满时不播放成功飞行，成熟作物保留，田块与容量区出现珊瑚阻塞反馈。
- 减少动态效果使用短时起点/终点静态高亮和 `+产量`，不进行粒子位移。

## 2. 真实 720 x 1280 OpenGL 画面

| 状态 | 文件 | 证明 |
|---|---|---|
| 默认 | `output/runtime/F003-VQ.1/vq-default.png` | 农田焦点、降噪地面、接触阴影与现有 HUD |
| 交互/成熟 | `output/runtime/F003-VQ.1/vq-ready.png` | 完整作物剪影、暖金外环、确认徽标 |
| 反馈中段 | `output/runtime/F003-VQ.1/vq-harvest-success.png` | 成功后才出现的世界到粮仓弧线粒子 |
| 成功结算 | `output/runtime/F003-VQ.1/vq-harvest-settle.png` | 粮仓终点环、容量变化与 `+3` |
| 失败 | `output/runtime/F003-VQ.1/vq-granary-blocked.png` | 48/48、成熟作物保留、无成功飞行 |
| 减少动态效果 | `output/runtime/F003-VQ.1/vq-reduced-motion.png` | 静态起点/终点高亮和 `+3` |

对比板：`docs/evidence/F003-VQ.1/runtime-comparison.png`。  
可编辑样式帧预览：`docs/evidence/F003-VQ.1/style-frame-preview.png`。

## 3. 正常玩家入口验收

不是测试场景替代：

1. 通过 `project.godot -> scenes/town_main.tscn` 启动新的正常 `CityOfAnimals (DEBUG)` 窗口。
2. 当前真实存档进入时粮仓为 `42/48`，三块作物处于成熟待收状态。
3. 点击一块成熟作物，田块回空、粮仓变为 `46/48`，正常入口显示 `+4`：
   `docs/evidence/F003-VQ.1/interactive-normal-entry-harvest-success.png`。
4. 只剩 2 空位时点击另一块产量为 4 的成熟作物，粮仓保持 `46/48`，作物保留：
   `docs/evidence/F003-VQ.1/interactive-normal-entry-blocked-retained.png`。
5. 临时验收窗口通过正常关闭路径退出；既有 CityOfAnimals 编辑器调试窗口及其他项目进程未终止。

Windows DPI 缩放后的窗口证据为 483 x 885 逻辑像素；项目和 OpenGL 捕获仍使用正式 720 x 1280 设计/渲染画布。

验收过程中发现并关闭了一个遗留 Godot 崩溃对话框。Windows 应用事件确认唯一对应事件发生于 `2026-07-25 13:08:04`，故障进程为 PID `10912`；它早于当前 CityOfAnimals 编辑器/运行实例（`13:21:01`、`13:22:01`）和本轮正常入口验收窗口。此后没有新的 Godot 应用崩溃事件，正常入口成功完成收获、容量阻塞与正常退出，因此该对话框不属于本切片的复现性故障。

## 4. 行为与回归

| 日志 | 结果 |
|---|---|
| `tmp/F003-VQ1/visual-regression.log` | `TEST_PASS`；真实 OpenGL；6 张 720 x 1280 状态画面；性能采样 |
| `tmp/F003-VQ1/headless-farm2.log` | `TEST_PASS`；FARM.2 全路由和 F003-VQ.1 成功/阻塞/减少动态/连续触发/中断 |
| `tmp/F003-VQ1/farm1-regression.log` | `TEST_PASS`；历史 F003 作用域回归 |
| `tmp/F003-VQ1/main-scene-smoke.log` | 正常主场景入口；OpenGL；无脚本错误 |

关键行为：

- `Farm2FeedbackLayer` 为单一纯视觉子节点，`mouse_filter=IGNORE`、`focus_mode=NONE`。
- 成功动效只在 `harvest_plot()` 返回 `true` 后触发。
- 阻塞路径库存不变、作物状态保持 `ready`，最后事件类型为 `blocked`。
- 打开面板或拖动地图会清理世界反馈；离树时清理全部活动反馈。
- 连续五次快速收获时活动组上限保持 4，不无限创建节点。
- 现有设置入口、720 x 1280 设计缩放、地图拖动、双仓储、动物、机器、委托、市场和语言持久化回归通过。

## 5. 性能

真实 OpenGL 同一测试窗口：

| 场景 | 实测帧间隔 FPS | Draw calls | Primitives | 静态内存 | 峰值内存 |
|---|---:|---:|---:|---:|---:|
| 静态 F003-VQ.1 | 151.1 | 268 | 3,792 | 47.5 MiB | 49.7 MiB |
| 4 组并发反馈 | 143.0 | 345 | 6,488 | 47.7 MiB | 58.7 MiB |

优化前同一压力点为 657 draw calls / 9,216 primitives；最终通过降低地面重复绘制密度与圆环细分降至 345 / 6,488。该结果是 Windows 桌面原型证据，不替代 Android 真机性能验收。

## 6. 哈希

| 文件 | SHA-256 |
|---|---|
| `scripts/town/farm2_view.gd` | `F354C43996923B343E99548F86C000BE779F6FC2B6CF4EAF83A9CFD06D81B0F6` |
| `scripts/town/farm2_feedback_layer.gd` | `D2660A6BE846263AB7C9BE31C65F8EC248606CD236E05AB2CA14763B18C26815` |
| `tests/test_farm2_scene.gd` | `D6AEE7AADFD7617A89E83788F8ADAE8572DF6880350EE5E59354FB1E00C9FE28` |
| `assets/runtime/f003_farm2/runtime-manifest.json` | `C16B3CE0985A1379A5ED928E54308664F5283ADC3F7D7F633316106B7370AC86` |
| `vq-default.png` | `A0E64FE87102B4F39FE0E18F5678740076AA315377270E68C6586D14E68AFBAB` |
| `vq-ready.png` | `784068D3788A4C29A6C64144D27D84501FD81C76D707DC8847CCEBADCABA3BB6` |
| `vq-harvest-success.png` | `C5A0125C8A9E053217DE3625F36C92D8FBB833D33B9499FC33AB0CBD3F5A4FA8` |
| `vq-harvest-settle.png` | `65B9F10B65937209164AC48ECD3C3AEC409BE43882FEB668FCAB606ADA276C99` |
| `vq-granary-blocked.png` | `185374BB34DFC33222EC283FBEFC5E4AB32402E098C20C65B0CF44BD015E08C9` |
| `vq-reduced-motion.png` | `2571D26505D561112145645F69E30AA309F9BDC0528660C6A65F77AB9890B501` |
| `runtime-comparison.png` | `11218D648A8EC2DE5CD53073471E291B3EB2D890528A539644A947502B34AE02` |
| `style-frame-preview.png` | `4D9824D8E5842C37349A0BBDE95425AE2AFB5F3BD9DF8674440F17A1B3C109A1` |
| `interactive-normal-entry-before.png` | `7320F8C4AE650C3DE0609AC7A4D279C79967C599459E9583CEEF0C2ED6C67481` |
| `interactive-normal-entry-harvest-success.png` | `09485DA2C7DB55D0B198FFEFFF04796A1E3E66B1221A54F5C76EC8FEEBCF6702` |
| `interactive-normal-entry-blocked-retained.png` | `4E9E80A6A794CC7DE81BAB970C7F5ACAB090F9D76859F7050DDD4D886143BF38` |

## 7. 门与边界

- `BLOCKER`：0。
- `MATERIAL`：0。
- `POLISH`：新 Figma 样式帧附件仍 Pending；合规音频尚未提供；Android 真机触控和性能未验收。
- `RUNTIME_SLICE_APPROVED`：通过。
- `SCALE_OUT_APPROVED`：未通过；没有批量推广到动物、机器、委托、市场或其他页面。
- F004 仍为 `BLOCKED: Figma UE attachment`、`runtime_authority=false`；本切片没有修改任何 F004 正式源或运行时。
- 正式范围、交接和进度矩阵的完成同步被 `F004-DESIGN-LOCK-001` 阻止；控制平面结论及等待条件见 `docs/receipts/F003-VQ-SYNC-001.md`，没有绕过该锁。
