import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";
import { writeFile } from "node:fs/promises";

const inputPath = process.argv[2] ?? "D:/AI/CityOfAnimals/output/documents/F004-DISTRICT.1/feature_progress.f004-design-active.xlsx";
const outputPath = process.argv[3] ?? "D:/AI/CityOfAnimals/output/documents/F004-DISTRICT.1/feature_progress.f004-design-active.png";

const input = await FileBlob.load(inputPath);
const workbook = await SpreadsheetFile.importXlsx(input);
const image = await workbook.render({
  sheetName: "Nine Dimensions",
  range: "A17:U20",
  scale: 1.5,
});
console.log(JSON.stringify({
  imageType: image?.constructor?.name,
  keys: Object.keys(image ?? {}),
  methods: image ? Object.getOwnPropertyNames(Object.getPrototypeOf(image)) : [],
}));
await writeFile(outputPath, Buffer.from(await image.arrayBuffer()));
console.log(JSON.stringify({ inputPath, outputPath, range: "A17:U20" }));
