# F-003 FARM.2 Formal Document Acceptance Receipt

**Receipt:** F-003-FARM2-DOCUMENT-001  
**State:** CLOSED / FORMAL DOCUMENT ACCEPTED  
**Opened:** 2026-07-24  
**Owner:** Codex `/root`  
**Primary Skills:** `game-feature-design-docs`, `documents`, `pdf`, `game-project-control-plane`  
**Execution level:** L1 direct execution  
**Fingerprint:** `92744745982BB12E8D5244B9AD8B0E29AEDE81374DA1AAFBF07284C95DB47529`

## Formal source and baseline

- Functional source: `docs/features/F-003-farm-town-foundation-v2.md`
- General template: `C:\Users\76398\.codex\skills\artifact-template-game-feature-design-general\assets\reference.docx`
- Template SHA-256 before and after use: `AAA5392B9329DF2FF1ADBC314048663ACDFEDC542AC65F57C5F8AECF6754087E`
- Editable Figma gate: `docs/receipts/F-003-FARM2-DESIGN-001.md`
- Asset preparation gate: `docs/receipts/ART-003-FARM2-001.md`
- Runtime/config/test paths remain frozen.

## Authorized write set

- `docs/receipts/F-003-FARM2-DOCUMENT-001.md`
- `docs/features/F-003-farm-town-foundation-v2.md`
- `docs/design_index.md`
- `docs/task_contract.md`
- `docs/active_scope.yaml`
- `docs/PM_HANDOFF.md`
- `PM/feature_progress.xlsx`

## Acceptance contract

1. DOCX inherits the retained general-template page, style, header/footer and table language.
2. Word fields produce a current TOC plus `PAGE / NUMPAGES`.
3. PDF is A4 portrait and every page passes visual review.
4. All seven figures are readable, captioned, have alternate text and point to the editable Figma source.
5. No template placeholder remains.
6. The project state advances to the engineering read-only receipt gate without authorizing any runtime write.

## Control-plane result

- status: `READY`
- duplicates: none
- write conflicts: none
- runtime writes: none
- irreversible actions: none

## Close condition

Close only after the final DOCX/PDF hashes, structural audits, 21-page visual review, project source synchronization and visually verified workbook update are recorded.

## Completion evidence

- Final DOCX: `output/documents/F003-FARM.2/CityOfAnimals_F003_Farm_Town_Foundation_V2.docx`
  - SHA-256: `0D763EECF6179BC5C2071B3852B96D27CF823E78942654B0078E12C26A1B5697`
- Final PDF: `output/pdf/CityOfAnimals_F003_Farm_Town_Foundation_V2.pdf`
  - SHA-256: `CA1D7F15DEF5A9881F3E1015B9DFD7EB27A6AC6F5E307D36F76AB1BC8BF89A42`
  - A4 portrait, 21 pages.
- Word field audit: 33 `PAGEREF`, one `PAGE`, one `NUMPAGES`; refreshed by Microsoft Word before export.
- Section audit: one A4 portrait section, retained 0.59-inch margins, linked header/footer disabled as expected.
- Image audit: seven inline Figma review figures, all with captions and alternate text.
- Accessibility audit: high `0`, medium `0`, low `0`.
- Placeholder scan: none of `[填写]`, `[粘贴`, `[YYYY`, `[机制名称]`, or `在此插入` remains.
- Visual review: `output/documents/F003-FARM.2/final-render-2/page-01.png` through `page-21.png` were inspected at original detail; no blank page, clipped figure, cut table row, footer collision, or unreadable diagram remains.
- Workbook candidate preview: `output/documents/F003-FARM.2/feature_progress.farm2-document-ready.png` was visually inspected across `Nine Dimensions!A17:U20`.
- Official workbook: `PM/feature_progress.xlsx`
  - SHA-256: `3732156421A0A64D275A760C8730091ED423768559DC617262A002F984E9A9E6`
  - F-003 row: design document `100%`, UI `100%`, icon/image `90%`, overall `32%`, stage `ENGINEERING RECEIPT GATE`.
- `docs/features/F-003-farm-town-foundation-v2.md`, `docs/design_index.md`, `docs/task_contract.md`, `docs/active_scope.yaml`, and `docs/PM_HANDOFF.md` now agree on the engineering receipt gate.
- Runtime/config/test paths were not modified. The 26 prepared assets remain `NOT_RUNTIME`.
