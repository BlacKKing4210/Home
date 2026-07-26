import fs from "node:fs/promises";
import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";

const sourcePath = "D:/AI/CityOfAnimals/PM/feature_progress.xlsx";
const outputPath = "D:/AI/CityOfAnimals/output/documents/F003-FARM.2/feature_progress.farm2-document-ready.xlsx";
const previewPath = "D:/AI/CityOfAnimals/output/documents/F003-FARM.2/feature_progress.farm2-document-ready.png";

const input = await FileBlob.load(sourcePath);
const workbook = await SpreadsheetFile.importXlsx(input);
const sheet = workbook.worksheets.getItem("Nine Dimensions");

sheet.getRange("A18:U18").values = [[
  "F-003",
  "Animal Town Farm Foundation V2",
  "Original farm-town foundation replacement",
  "docs/features/F-003-farm-town-foundation-v2.md",
  "Planned f003_v2_items/crops/storage/recipes/animals/buildings/requests/world/locale tables",
  "F003-FARM.2: inventory-backed farming, animals, machine queues, surplus market, and a large 720 x 1280 town map",
  "P0",
  1,
  0,
  0,
  0,
  1,
  0.90,
  0,
  0,
  0,
  0.32,
  "ENGINEERING RECEIPT GATE",
  "Codex /root",
  "Create F003-FARM.2 engineering baseline/implementation receipt",
  "Design/Figma/ART-003/DOCX/PDF gates passed; Godot remains frozen and 26 assets remain NOT_RUNTIME until engineering receipt",
]];

const preview = await workbook.render({
  sheetName: "Nine Dimensions",
  range: "A17:U20",
  scale: 1.4,
  format: "png",
});
await fs.writeFile(previewPath, new Uint8Array(await preview.arrayBuffer()));

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);

const check = await workbook.inspect({
  kind: "region",
  sheetId: "Nine Dimensions",
  range: "A17:U20",
  maxChars: 9000,
});
console.log(check.ndjson);
