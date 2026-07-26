# ART-001 动物与建筑美术风格统一

**版本：** ART-STYLE.1  
**状态：** `CANDIDATE_STYLE_LOCK`；候选资源迁移已完成；`NOT_RUNTIME`  
**责任人：** Codex /root（美术负责人）  
**关联主线：** F-004 的后续美术参考，不授予 F-004 运行时开发或资源接入权限  

## 制作人规则

将 `D:\AI\zhanchengdashi\assets\card_art\animals` 中用于当前评审的动物 PNG 移植为 CityOfAnimals 的内部候选风格参考；以同批评审建筑板确定动物与 45°建筑的共用美术语言。

这是内部项目间、由制作人指定的候选参考迁移。不得把候选目录加入运行时、场景、注册表、游戏配置或发布资产。

## 资产合同

| 身份 | 来源 | 候选目标 | 规格 | 作用 |
|---|---|---|---|---|
| chicken | `D:\AI\zhanchengdashi\assets\card_art\animals\chicken.png` | `assets/candidate/style_reference/animals/chicken.png` | 512 x 512, RGBA | 家禽与轮廓参考 |
| cow | `D:\AI\zhanchengdashi\assets\card_art\animals\cow.png` | `assets/candidate/style_reference/animals/cow.png` | 512 x 512, RGBA | 养殖与体块参考 |
| pig | `D:\AI\zhanchengdashi\assets\card_art\animals\pig.png` | `assets/candidate/style_reference/animals/pig.png` | 512 x 512, RGBA | 暖色与圆润比例参考 |
| bear | `D:\AI\zhanchengdashi\assets\card_art\animals\bear.png` | `assets/candidate/style_reference/animals/bear.png` | 512 x 512, RGBA | 深色轮廓与毛色层次参考 |
| rabbit | `D:\AI\zhanchengdashi\assets\card_art\animals\rabbit.png` | `assets/candidate/style_reference/animals/rabbit.png` | 512 x 512, RGBA | 浅色外描边与柔和高光参考 |
| building review board | 生成的 ART-001 评审板 | `assets/candidate/style_reference/building_review/art-001-animal-town-buildings-board.png` | 1536 x 1024, RGB | 五座建筑的统一风格评审面 |

候选目录必须包含 `.gdignore`。正式归档与运行时目标均为“未指定”；没有新的正式合同和视觉验收时，不得拆分建筑板或移动任何候选资源。

## 建筑板评审边界

建筑板画布为 1536 x 1024，按“上排鸡舍、奶牛棚、饲料坊；下排面包房、集市大厅”的 3+2 阅读顺序评审。背景为统一的低饱和青蓝，不含标签、网格或 UI。

该画布没有获批的无重叠切分矩形、透明底或单件尺寸合同，故其状态为 `NO_SPLIT`。它只锁定整套建筑与动物的风格关系，不可作为任何单件运行时建筑资源的来源。

## 统一风格锁定

1. **轮廓：** 可读主轮廓与内部结构使用深近黑描边；主体外沿保留连续、明显的白色贴纸式描边。
2. **形体：** 动物与建筑都采用大体块、圆角、友好比例；建筑以拱顶、圆角屋檐和宽阔入口代替写实硬边。
3. **上色：** 使用干净的暖色块和少量柔和赛璐璐高光；禁止 PBR 金属感、写实木纹、密集瓦片纹理和照片式阴影。
4. **配色：** 奶油白、蜂蜜黄、番茄红、栗棕、叶绿、柔和青绿为共同主色范围；深色仅用于轮廓、缝隙和少数结构层级。
5. **建筑视角：** 正交 45°斜俯视，完整表现屋顶、入口和小型草地基座；动物保持卡片式正侧 3/4 视角，二者靠轮廓、比例、上色统一，而非强行统一镜头。
6. **动物化元素：** 仅允许爪形窗、耳形通风口、叶形风向标等小尺度建筑语义；不得把动物角色、表情或角色资产直接绘入建筑。

## 评审板与验收

评审建筑为鸡舍、奶牛棚、饲料坊、面包房、集市大厅。它们与五张动物 PNG 的深色描边、厚白外轮廓、圆润比例、暖色分块及柔和高光一致，故本任务将该规范标记为 `CANDIDATE_STYLE_LOCK`。

本锁定只证明候选风格统一，不等同于 F-004 正式美术批准，也不等同于单个建筑已获拆分、透明化、归档或运行时接入批准。

## 写入范围与完成条件

允许写入：本合同、ART-001 收据、`assets/candidate/style_reference/` 下列出的六张 PNG、`.gdignore` 与清单。

完成时必须证明：

- 五张动物 PNG 的 SHA-256 与来源完全相同；
- 建筑评审板可读取、尺寸为 1536 x 1024，且不会被当作可拆分正式资源；
- 候选路径由 `.gdignore` 隔离；
- 不改动代码、场景、配置、运行时资源注册或 F-003 锁定文件；
- 清单记录来源、尺寸、哈希、`NOT_RUNTIME` 状态与风格锁定规则。
