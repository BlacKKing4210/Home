import fs from "node:fs/promises";
import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";

const sourcePath = "D:/AI/CityOfAnimals/PM/feature_progress.xlsx";
const outputPath = "D:/AI/CityOfAnimals/output/documents/F003-FARM.2/feature_progress.farm2.xlsx";
const previewPath = "D:/AI/CityOfAnimals/output/documents/F003-FARM.2/feature_progress.farm2.png";

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
  0.85,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0.09,
  "DESIGN / FIGMA GATE",
  "Codex /root",
  "Complete editable Figma UE and ART-003 preparation",
  "Figma attachment and runtime-asset preparation; Godot frozen until a new engineering receipt",
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
process.stdout.write(check.ndjson);
