const fs = require("fs");
const peg = require("peggy");
const jsonDiff = require('json-diff');



const grammar_content = fs.readFileSync("./grammar/exthtml/current.pegjs", "utf8");

const parserSource = peg.generate(grammar_content,{output:"source"});

// Ensure the output directory exists
const outputDir = "./dist/exthtml";
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Write the parser source code to the file
fs.writeFileSync(`${outputDir}/parser.js`, parserSource, "utf8");

console.log("Parser source saved to ./dist/exthtml/parser.js");