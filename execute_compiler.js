import fs from 'fs/promises';
import path from 'path';
import { exthtmlCompile } from './src/compiler/compiler_exthtml.js';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import { inspect } from 'util';

// __dirname replacement in ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const filePath = path.join(__dirname, './src/examples/exthtml/increase_decrease/with_css_on_class_bool_and_no_function.exthtml');

async function main() {
  try {
    const source_code_content = await fs.readFile(filePath, 'utf8');

    let [scripts,exthtml,styles] = exthtmlCompile(source_code_content);

    for( let x = 0; x < scripts.length; x++){
        let script = scripts[x]

        for( let i = 0; i < script.children.length; i++ ){
            console.log(inspect(script.children[i], { depth: null, colors: true }));
        }
    }
  } catch (err) {
    console.error('Error reading file:', err);
  }
}

main();
