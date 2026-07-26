# F003-FARM.2 General Feature Template Contract

## Reference

- Path: `C:\Users\76398\.codex\skills\artifact-template-game-feature-design-general\assets\reference.docx`
- SHA-256: `AAA5392B9329DF2FF1ADBC314048663ACDFEDC542AC65F57C5F8AECF6754087E`
- Size: 48,570 bytes
- Render: 7 pages, `output/documents/F003-FARM.2/template-reference-render/page-1.png` through `page-7.png`
- Evidence: `output/documents/F003-FARM.2/template-style-evidence.json`
- Section count: 1
- Body inventory: 103 top-level paragraphs, 25 tables, 13 Heading 1 paragraphs, 13 Heading 2 paragraphs

## Page system

- A4 portrait: 8.268 x 11.693 in.
- Margins: 0.590 in on all four sides.
- Header/footer distance: 0.394 in.
- One section, NEW_PAGE start, no odd/even or different first-page behavior.
- Footer source pattern: right-aligned `PAGE / NUMPAGES`.
- Page 1 is the metadata cover; page 2 is the full TOC; pages 3 onward contain the numbered specification.

## Typography

- East Asian document language: Simplified Chinese.
- Body style: `Normal`, SimSun, 10.5 pt, 17 pt line height, 5 pt after.
- Title: 22 pt, bold, `#111111`, single line, 10 pt after, keep with next.
- Heading 1: 22 pt, bold, `#111111`, 17 pt before, 16.5 pt after, keep with next.
- Heading 2: 16 pt, bold, `#111111`, 13 pt before/after, keep with next.
- Heading 3: 12 pt, bold, `#111111`, 6 pt before/after, keep with next.
- List Bullet: template numbering definition, 16 pt line height, 3 pt after, body color `#222222`.
- Instructional text uses gray; editable placeholders use blue; configuration/data references use green; hard constraints use red.
- Do not introduce a second type scale, branded cover, generic design preset, or decorative header.

## Tables and recurring components

- Main grid style: `Table Grid`, full usable width, black 0.5 pt borders, vertically centered cells, wrapped text.
- Header rows: pale blue fill matching the reference; bold black text; repeat on continuation pages when a table spans pages.
- Metadata section headers (`版本控制`, `版本历史`, `开发计划`) use a single-cell pale-blue band.
- No fixed row heights; rows expand with content.
- Keep the reference cell margin, paragraph rhythm and alternating role widths; short status/date/version columns remain narrow.
- Page 1 components: title/rule, usage note, version-control table, version history, development plan.
- Diagram components: 4-column artifact register immediately followed by a bordered figure slot and caption.
- UI and state tables use the exact reference header treatment and information order.

## Content flow and slot map

1. Page 1 title and metadata: rewrite with COA-F003-FARM.2, owner, status, dates, Figma URL and config version.
2. Page 2 TOC: preserve real bookmarks/PAGEREF fields and refresh in Word after content replacement.
3. `1. 术语缩写与修订标记`: keep marker legend, replace instruction with project terms and authoritative meanings.
4. `2. 设计目的`: fill primary, secondary and non-goals.
5. `3. 功能概述`: concise observable loop.
6. `4. 系统框架`: Figma register and a review image derived from the verified editable Figma source.
7. `5. UE 流程图`: Figma register, review image and complete transition rows.
8. `6. 参考视频`: source links and explicit commercial-safety use boundaries.
9. `7. 配置表调整`: exact `config/tables/*.csv::field` definitions and ownership.
10. `8. 系统逻辑`: overall logic artifact, mechanism rules and edge-state matrix.
11. `9. UI 界面及子玩法`: page list, map/object/settings page specifications, Figma layer references and UI element contracts.
12. `10. 相关需求`: ART-003 assets, audio and telemetry.
13. `11. 关联拓展`: related systems, dependencies and explicitly deferred content.
14. `12. 验收与 QA`: delivery checklist, behavior tests and review status.

Optional template rows may be cloned with their full row properties. Unsupported empty placeholders must be removed rather than left visible. All final diagrams remain editable in Figma; embedded PNG is a review export only.

## Package preservation

Preserve the reference package's styles, numbering, theme, footnotes/endnotes shells, headers/footers and custom XML unless a documented content insertion necessarily adds media/relationships. The following reference parts are preserve-only:

- `word/styles.xml` SHA-256 `7B34B622BAF9FED13FE0074162A279BCA314E59E04D5DD2F136C595807E20077`
- `word/numbering.xml` SHA-256 `E3F653BBA535128DE4965228852170A5FF180F90B049FBE66CC8FB3285D46A73`
- `word/theme/theme1.xml` SHA-256 `B2295D3198893D2C03F5E584C749A15751B798AEFDCD9BEE2889F13903D68CB2`
- `word/footer1.xml` SHA-256 `3663C2A558330F8BA259C5611C1AA6821305F4DE8A369BD943F635656264E4DD`
- `word/footer2.xml` contains PAGE/NUMPAGES and may only change through Word field refresh.
- `word/footer3.xml` SHA-256 `C32DE16685DEFFAECE438CEAE11662AB1B00B4A959C716ACAD6550238DCFD9D1`
- `word/header1.xml`, `header2.xml`, `header3.xml` are blank structural parts and remain present.
- `customXml/*`, footnotes/endnotes and root relationships remain present.

`word/document.xml`, `word/_rels/document.xml.rels`, `[Content_Types].xml`, `docProps/*` and media relationships are editable only as required to replace content, add the reviewed figure and update document metadata.

## Fidelity gates

- Retained reference hash remains unchanged.
- A4 geometry, margins, footer position, pale-blue table language, heading ladder and body rhythm remain recognizably template-derived.
- No visible template instructions, bracket placeholders or stale `V0.1` fields remain.
- TOC and footer fields display the final page count after Word refresh.
- Final DOCX and PDF render with no clipping, overlap, broken table, missing CJK glyph, orphan heading or blank diagram placeholder.
- Every final page is inspected at 100% through PNG renders; PDF page count and text extraction are checked.
- Figma URL, file key, page name, named editable layers, source version and coverage match `F-003-FARM2-DESIGN-001`.
- ART-003 is described as `READY_FOR_ENGINEERING / NOT_RUNTIME`; the document must not imply runtime integration is complete.

