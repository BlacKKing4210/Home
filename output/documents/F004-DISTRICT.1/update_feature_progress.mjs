import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";

const inputPath = "D:/AI/CityOfAnimals/PM/feature_progress.xlsx";
const outputPath = process.argv[2] ?? "D:/AI/CityOfAnimals/output/documents/F004-DISTRICT.1/feature_progress.f004-design-active.xlsx";

const input = await FileBlob.load(inputPath);
const workbook = await SpreadsheetFile.importXlsx(input);
const sheet = workbook.worksheets.getItem("Nine Dimensions");

sheet.getRange("H19:Q19").values = [[
  1,
  1,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  2 / 9,
]];
sheet.getRange("R19:U19").values = [[
  "FORMAL DESIGN HOLD / FIGMA",
  "Codex /root",
  "Restore Figma connection; create and verify six editable UE/UI nodes; close design milestone",
  "PASS: eight-table validation and 27-page DOCX/PDF QA. BLOCKED: Figma UE attachment. Runtime not authorized; design lock remains active.",
]];

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);
console.log(JSON.stringify({ outputPath, updatedRange: "H19:U19" }));
