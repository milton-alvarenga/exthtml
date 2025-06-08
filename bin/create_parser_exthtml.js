import fs from 'fs';
import peg from 'peggy';


const grammar_content = fs.readFileSync("./src/parse/peg/grammar/exthtml/current.pegjs", "utf8");

const parserSource = peg.generate(grammar_content,{output:"source", format: "es"});

// Ensure the output directory exists
const outputDir = "./dist/exthtml";
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Write the parser source code to the file
fs.writeFileSync(`${outputDir}/parser.js`, parserSource, "utf8");

console.log("Parser source saved to ./dist/exthtml/parser.js");