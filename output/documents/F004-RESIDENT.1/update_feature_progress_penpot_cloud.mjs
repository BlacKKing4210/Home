import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";
import { writeFile } from "node:fs/promises";

const inputPath = process.argv[2] ?? "D:/AI/CityOfAnimals/PM/feature_progress.xlsx";
const outputPath = process.argv[3] ?? inputPath;
const reviewCopyPath =
  process.argv[4] ??
  "D:/AI/CityOfAnimals/output/penpot/F004-RESIDENT.1/feature_progress.F004-PENPOT-CLOUD-V1.1.xlsx";
const previewPath =
  process.argv[5] ??
  "D:/AI/CityOfAnimals/output/penpot/F004-RESIDENT.1/previews/feature-progress-f004-cloud.png";

const workbook = await SpreadsheetFile.importXlsx(await FileBlob.load(inputPath));
const matrix = workbook.worksheets.getItem("Nine Dimensions");
const overview = workbook.worksheets.getItem("Overview");
const activeBatch = workbook.worksheets.getItem("Active Batch");

matrix.getRange("C19").values = [[
  "Producer-approved resident-town rebaseline / verified Penpot editable handoff",
]];
matrix.getRange("H19").values = [[1]];
matrix.getRange("Q19").values = [[1 / 9]];
matrix.getRange("R19:U19").values = [[
  "DESIGN PACKAGE V1.1 / PENPOT SOURCE VERIFIED / USER REVIEW PENDING",
  "Codex /root",
  "User reviews the 1x1 footprint catalog and recommended resident/offline/order defaults; approve the design baseline before any runtime slice",
  "Authenticated Penpot file/import/reopen/object readback verified. PENDING: cloud export archive and user detailed design review. No file lock. Runtime not authorized; F003 remains baseline and old F004-DISTRICT.1 remains historical input.",
]];

overview.getRange("D5").values = [[
  "Review F004 footprint catalog/defaults and Penpot package; runtime remains unauthorized",
]];

activeBatch.getRange("E5:H5").values = [[
  "PENPOT READBACK VERIFIED / USER REVIEW PENDING",
  "Authenticated file, 8 screen groups, 4 flow groups, 14 object IDs and nested vector readback verified",
  "User approves footprint catalog/defaults and visual/UI contract; then issue separate runtime-slice receipt",
  "No file lock. Cloud export archive and user detailed review pending; runtime_authority=false",
]];

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);
await output.save(reviewCopyPath);

const image = await workbook.render({
  sheetName: "Nine Dimensions",
  range: "A17:U20",
  scale: 1.5,
});
await writeFile(previewPath, Buffer.from(await image.arrayBuffer()));

const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 100 },
  summary: "final formula error scan",
});

console.log(
  JSON.stringify({
    inputPath,
    outputPath,
    reviewCopyPath,
    previewPath,
    matrixRow: matrix.getRange("A19:U19").values,
    overviewD5: overview.getRange("D5").values,
    activeBatchE5H5: activeBatch.getRange("E5:H5").values,
    errorScan: errors.ndjson,
  }),
);
