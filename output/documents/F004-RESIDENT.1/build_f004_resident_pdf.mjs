import fs from "node:fs/promises";
import path from "node:path";
import { pathToFileURL } from "node:url";
import { marked } from "marked";
import { chromium } from "playwright";

const projectRoot = process.argv[2] ?? "D:/AI/CityOfAnimals";
const outputPath =
  process.argv[3] ??
  `${projectRoot}/output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V1.1_REVIEW.pdf`;
const htmlPath =
  process.argv[4] ??
  `${projectRoot}/output/documents/F004-RESIDENT.1/CityOfAnimals_F004_Resident_Town_Spatial_Autonomy_V1.1_REVIEW.html`;
const browserExecutable =
  process.argv[5] ?? "C:/Program Files/Google/Chrome/Application/chrome.exe";

const penpotUrl =
  "https://design.penpot.app/#/workspace?team-id=bd31e32d-d69f-81e2-8008-62c66e2babc2&file-id=bd31e32d-d69f-81e2-8008-62cc67c1eeda&page-id=bd31e32d-d69f-81e2-8008-62cc67c1eedb";

const sourceFiles = [
  ["正式功能设计", "docs/features/F-004-resident-town-spatial-autonomy.md"],
  ["主页面 UI/UX 优先级", "docs/uiux/F004-RESIDENT.1-ui-priority.md"],
  ["视觉质量合同", "docs/design/F004-RESIDENT.1-visual-quality-contract.md"],
  ["产品方向决策", "docs/decisions/PD-002-animal-resident-town-rebaseline.md"],
  ["可编辑设计源决策", "docs/decisions/PD-003-penpot-editable-design-source.md"],
];

const imageFiles = [
  ["旧 F003 主地图运行基线", "output/runtime/F003-FARM2/iteration-a-main-map.png"],
  ["旧 F003 订单面板运行基线", "output/runtime/F003-FARM2/iteration-b-requests-panel.png"],
  ["Penpot 八个界面/状态评审面", "output/penpot/F004-RESIDENT.1/previews/F004-RESIDENT.1-screen-board.png"],
  ["Penpot 四张 UE/状态流程", "output/penpot/F004-RESIDENT.1/previews/F004-RESIDENT.1-flow-board.png"],
];

const escapeHtml = (value) =>
  value.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");

const dataUrl = async (relativePath) => {
  const filePath = path.join(projectRoot, relativePath);
  const bytes = await fs.readFile(filePath);
  return `data:image/png;base64,${bytes.toString("base64")}`;
};

marked.setOptions({ gfm: true, breaks: false });

const sections = [];
for (const [title, relativePath] of sourceFiles) {
  const markdown = await fs.readFile(path.join(projectRoot, relativePath), "utf8");
  sections.push(`
    <section class="source-section">
      <div class="section-kicker">${escapeHtml(relativePath)}</div>
      <h1>${escapeHtml(title)}</h1>
      <div class="markdown">${marked.parse(markdown)}</div>
    </section>
  `);
}

const figures = [];
for (const [caption, relativePath] of imageFiles) {
  figures.push(`
    <figure>
      <img src="${await dataUrl(relativePath)}" alt="${escapeHtml(caption)}" />
      <figcaption>${escapeHtml(caption)} · ${escapeHtml(relativePath)}</figcaption>
    </figure>
  `);
}

const html = `<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8" />
  <title>CityOfAnimals F004-RESIDENT.1 V1.1</title>
  <style>
    @page { size: A4; margin: 18mm 16mm 18mm 16mm; }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      color: #1f3230;
      font-family: "Microsoft YaHei", "Noto Sans CJK SC", Arial, sans-serif;
      font-size: 10.2pt;
      line-height: 1.58;
      background: #fffdf6;
    }
    .cover {
      min-height: 250mm;
      padding: 24mm 18mm;
      background:
        radial-gradient(circle at 82% 15%, rgba(248, 190, 72, .26), transparent 28%),
        linear-gradient(145deg, #f9f0d0 0%, #fffdf6 46%, #e0f1dc 100%);
      border: 2px solid #245f59;
      break-after: page;
      position: relative;
    }
    .eyebrow { color: #28766d; font-weight: 700; letter-spacing: .08em; }
    .cover h1 { margin: 16mm 0 4mm; font-size: 30pt; line-height: 1.16; color: #183c38; }
    .cover h2 { margin: 0 0 10mm; font-size: 16pt; color: #8b5b1e; }
    .memory {
      margin: 14mm 0;
      padding: 8mm;
      border-left: 5px solid #e59a2e;
      background: rgba(255,255,255,.74);
      font-size: 15pt;
      font-weight: 700;
      color: #244f49;
    }
    .status-card {
      margin-top: 10mm;
      padding: 7mm 8mm;
      background: #174c47;
      color: #fff;
      border-radius: 10px;
    }
    .status-card strong { color: #ffe49a; }
    .meta-grid {
      display: grid;
      grid-template-columns: 42mm 1fr;
      gap: 2mm 5mm;
      margin-top: 11mm;
      font-size: 9.2pt;
    }
    .meta-grid dt { font-weight: 700; color: #3f6f69; }
    .meta-grid dd { margin: 0; overflow-wrap: anywhere; }
    .review-summary, .visual-evidence, .source-section {
      break-before: page;
      padding-top: 2mm;
    }
    h1 { color: #174c47; font-size: 22pt; line-height: 1.24; margin: 0 0 6mm; }
    h2 { color: #286d64; font-size: 15pt; line-height: 1.35; margin: 8mm 0 3mm; break-after: avoid; }
    h3 { color: #7d5520; font-size: 12pt; margin: 6mm 0 2mm; break-after: avoid; }
    h4 { color: #355f59; margin: 5mm 0 2mm; break-after: avoid; }
    p { margin: 0 0 3.2mm; orphans: 3; widows: 3; }
    ul, ol { margin: 2mm 0 4mm 6mm; padding-left: 5mm; }
    li { margin-bottom: 1.4mm; }
    blockquote {
      margin: 4mm 0;
      padding: 3mm 5mm;
      border-left: 4px solid #e59a2e;
      background: #fff5db;
    }
    code {
      font-family: Consolas, monospace;
      font-size: 8.7pt;
      color: #6e3b19;
      background: #f3ead5;
      padding: .2mm 1mm;
      border-radius: 3px;
      overflow-wrap: anywhere;
    }
    pre {
      white-space: pre-wrap;
      overflow-wrap: anywhere;
      background: #193e3a;
      color: #f6f4e9;
      padding: 4mm;
      border-radius: 6px;
    }
    pre code { color: inherit; background: transparent; padding: 0; }
    table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
      margin: 4mm 0 6mm;
      font-size: 8.1pt;
      break-inside: auto;
    }
    thead { display: table-header-group; }
    tr { break-inside: avoid; }
    th, td {
      border: 1px solid #9cb8b3;
      padding: 2mm;
      vertical-align: top;
      overflow-wrap: anywhere;
    }
    th { background: #28766d; color: #fff; font-weight: 700; }
    tbody tr:nth-child(even) { background: #f3f7ed; }
    a { color: #1266a3; text-decoration: none; overflow-wrap: anywhere; }
    .section-kicker {
      color: #79918d;
      font-size: 8.5pt;
      font-family: Consolas, monospace;
      margin-bottom: 2mm;
    }
    .decision-list {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 4mm;
      margin: 5mm 0;
    }
    .decision-card {
      padding: 5mm;
      border: 1px solid #a9c5bf;
      border-radius: 8px;
      background: #f8fbf4;
      break-inside: avoid;
    }
    .decision-card strong { display: block; color: #1f655d; margin-bottom: 2mm; }
    figure { margin: 0 0 9mm; break-inside: avoid; }
    figure img {
      display: block;
      max-width: 100%;
      max-height: 225mm;
      margin: 0 auto;
      object-fit: contain;
      border: 1px solid #9cb8b3;
      background: #fff;
    }
    figcaption { margin-top: 2mm; font-size: 8.4pt; color: #5c716d; }
    .warning {
      padding: 5mm;
      background: #fff0e5;
      border: 1px solid #df8e64;
      border-radius: 7px;
      color: #713c23;
    }
  </style>
</head>
<body>
  <section class="cover">
    <div class="eyebrow">CITY OF ANIMALS · FORMAL GAME FEATURE DESIGN</div>
    <h1>动物居民小镇<br />空间与自治基础</h1>
    <h2>F004-RESIDENT.1 · 产品与设计重基线 V1.1</h2>
    <div class="memory">动物不是按钮或加成，而是玩家看得见、会走路、会生活、会把小镇运转起来的居民。</div>
    <div class="status-card">
      <strong>最高 Gate：</strong>PENPOT_EDITABLE_SOURCE_READBACK_VERIFIED<br />
      <strong>仍待：</strong>云端导出归档、用户详细设计评审<br />
      <strong>运行时：</strong>runtime_authority=false；未进入 Godot 实装
    </div>
    <dl class="meta-grid">
      <dt>目标画布</dt><dd>720 × 1280 竖屏，zh-CN 默认，Settings 可切换 English</dd>
      <dt>可编辑设计源</dt><dd><a href="${penpotUrl}">Penpot · CityOfAnimals / F004-RESIDENT.1</a></dd>
      <dt>Penpot 文件</dt><dd>file bd31e32d-d69f-81e2-8008-62cc67c1eeda · page bd31e32d-d69f-81e2-8008-62cc67c1eedb</dd>
      <dt>回读证据</dt><dd>8 个界面组、4 个流程组、14 个根/组对象引用，以及主地图 3 个代表性嵌套矢量</dd>
      <dt>Owner</dt><dd>Codex /root · sole accountable producer</dd>
      <dt>日期</dt><dd>2026-07-26</dd>
    </dl>
  </section>

  <section class="review-summary">
    <h1>审阅摘要</h1>
    <p>本包完成 A–H 设计重基线以及 Penpot 云端可编辑源的认证、导入、重新打开和对象级回读。它证明设计源可继续编辑，不证明用户已批准规则，也不证明运行时完成。</p>
    <div class="decision-list">
      <div class="decision-card"><strong>空间秩序</strong>田地边长定义最小 1×1 单位；道路、建筑、入口和作业点都服从整数占地目录。</div>
      <div class="decision-card"><strong>低频经营</strong>频繁生产点击改为建造、邀请、派遣和长期调整；居民自行通勤与作业。</div>
      <div class="decision-card"><strong>世界订单</strong>订单用车辆到达、等待、装载和离场表达，不再是脱离场景的裸功能。</div>
      <div class="decision-card"><strong>正式表现</strong>主页面不得用临时字母块或占位图参加玩家可见验收；原创资产先过 UI/UX 和视觉质量门。</div>
    </div>
    <h2>本轮需要用户审阅</h2>
    <ol>
      <li>批准 V1.1 占地目录和道路/入口/作业点规则。</li>
      <li>批准推荐默认值：单居民单主岗位、非 RTS 指挥、自动搬运、满仓世界阻塞、订单无硬超时可谢绝、逻辑四向道路。</li>
      <li>批准主页面信息层级、居民状态、车辆订单状态与视觉质量合同。</li>
    </ol>
    <div class="warning"><strong>边界：</strong>批准前不创建 F004 新配置表、不批量重做建筑、不进入 Godot 代表性切片。</div>
  </section>

  <section class="visual-evidence">
    <h1>基线与 Penpot 评审面</h1>
    ${figures.join("\n")}
  </section>

  ${sections.join("\n")}
</body>
</html>`;

await fs.writeFile(htmlPath, html, "utf8");
const browser = await chromium.launch({
  headless: true,
  executablePath: browserExecutable,
});
try {
  const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
  await page.goto(pathToFileURL(htmlPath).href, { waitUntil: "networkidle" });
  await page.emulateMedia({ media: "print" });
  await page.pdf({
    path: outputPath,
    format: "A4",
    printBackground: true,
    displayHeaderFooter: true,
    headerTemplate: `<div style="font-size:8px;color:#69807c;width:100%;padding:0 16mm;">CityOfAnimals · F004-RESIDENT.1 · V1.1</div>`,
    footerTemplate: `<div style="font-size:8px;color:#69807c;width:100%;padding:0 16mm;text-align:right;">第 <span class="pageNumber"></span> / <span class="totalPages"></span> 页</div>`,
    margin: { top: "18mm", right: "16mm", bottom: "18mm", left: "16mm" },
    preferCSSPageSize: true,
  });
} finally {
  await browser.close();
}

const stats = await fs.stat(outputPath);
console.log(JSON.stringify({ outputPath, htmlPath, bytes: stats.size }));
