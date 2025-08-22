import fs from 'fs';
import path from 'path';
import peg from 'peggy';


const grammar_content = fs.readFileSync("../src/parse/peg/grammar/exthtml/current.pegjs", "utf8");

const parserSource = peg.generate(grammar_content,{output:"source", format: "es"});

// Ensure the output directory exists
const outputDir = "./dist/exthtml";
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Write the parser source code to the file
// Write the parser source code to the file
const parserFile = path.join(outputDir, "parser.js");
fs.writeFileSync(parserFile, parserSource, "utf8");


console.log("Parser source saved to ./dist/exthtml/parser.js");

// Now check and create the symlink if it does not exist:
const symlinkPath = path.join("src", "parse", "exthtml", "parser_exthtml.js");
const targetPath = path.relative(path.dirname(symlinkPath), parserFile);

try {
  // Check if symlinkPath exists and is a symlink
  const stat = fs.existsSync(symlinkPath) ? fs.lstatSync(symlinkPath) : null;

  if (stat && stat.isSymbolicLink()) {
    console.log(`Symlink already exists at ${symlinkPath}`);
  } else {
    // Ensure parent directory exists
    fs.mkdirSync(path.dirname(symlinkPath), { recursive: true });

    // If file (or broken symlink) exists, remove it before creating symlink
    if (fs.existsSync(symlinkPath)) {
      fs.unlinkSync(symlinkPath);
    }

    // Create the symlink. Use 'file' type for compatibility (especially on Windows)
    fs.symlinkSync(targetPath, symlinkPath, "file");
    console.log(`Symlink created: ${symlinkPath} → ${targetPath}`);
  }
} catch (err) {
  console.error("Error handling symlink:", err);
  process.exit(1);
}
