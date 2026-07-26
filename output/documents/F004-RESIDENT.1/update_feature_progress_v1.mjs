import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";
import { writeFile } from "node:fs/promises";

const inputPath = process.argv[2] ?? "D:/AI/CityOfAnimals/PM/feature_progress.xlsx";
const outputPath =
  process.argv[3] ??
  "D:/AI/CityOfAnimals/tmp/F004-RESIDENT.1/feature_progress.v1.review.xlsx";
const previewPath =
  process.argv[4] ??
  "D:/AI/CityOfAnimals/output/documents/F004-RESIDENT.1/feature_progress.v1.review.png";

const input = await FileBlob.load(inputPath);
const workbook = await SpreadsheetFile.importXlsx(input);
const sheet = workbook.worksheets.getItem("Nine Dimensions");

sheet.getRange("H19:Q19").values = [[
  0.9,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0.1,
]];

sheet.getRange("R19:U19").values = [[
  "DESIGN PACKAGE COMPLETE / FIGMA BLOCKED",
  "Codex /root",
  "User reviews the V1.0 footprint catalog and recommended defaults; restore edit-capable Figma/FigJam write-readback before runtime authorization",
  "A-H design rebaseline, UI/UX priority, visual contract and DOCX/PDF package complete for review. BLOCKED: Figma UE attachment (skyfire Starter seat=View; MCP transport failed; browser/Chrome control unavailable). Runtime not authorized; old F004-DISTRICT.1 remains historical migration input.",
]];

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);

const image = await workbook.render({
  sheetName: "Nine Dimensions",
  range: "A17:U20",
  scale: 1.5,
});
await writeFile(previewPath, Buffer.from(await image.arrayBuffer()));

console.log(
  JSON.stringify({
    inputPath,
    outputPath,
    previewPath,
    updatedRange: "H19:U19",
    values: sheet.getRange("A19:U19").values,
  }),
);
