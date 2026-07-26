import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";

const inputPath = process.argv[2] ?? "D:/AI/CityOfAnimals/PM/feature_progress.xlsx";
const input = await FileBlob.load(inputPath);
const workbook = await SpreadsheetFile.importXlsx(input);
const sheet = workbook.worksheets.getItem("Nine Dimensions");
console.log(JSON.stringify({
  inputPath,
  header: sheet.getRange("A1:U3").values,
  active_rows: sheet.getRange("A16:U20").values,
  active_formulas: sheet.getRange("H18:Q20").formulas,
}, null, 2));
