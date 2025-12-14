import path from 'path';
import { exthtmlCompileFile } from './src/compiler/compiler_exthtml.js';
import { fileURLToPath } from 'url';
import { dirname,basename } from 'path';
import { inspect } from 'util';


import fs from 'fs';
import { execSync } from 'child_process';

const update_parser_code = true;


if(update_parser_code){
  const file1 = './src/parse/exthtml/parser_exthtml.js';
  const file2 = './src/parse/peg/grammar/exthtml/current.pegjs';

  const stat1 = fs.statSync(file1);
  const stat2 = fs.statSync(file2);

  if (stat1.mtime < stat2.mtime) {
    execSync('npm run build', { stdio: 'inherit' });
    console.log("Reexecute the script. The dependencie of the compiler has been updated and need to be reloaded to work.")
    process.exit(0)
  }
}





// __dirname replacement in ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

//const filePathIfNoneInformed = './src/examples/exthtml/increase_decrease/with_css_on_class_bool_and_no_function.exthtml';
//const filePathIfNoneInformed = './src/examples/exthtml/object_and_array_reactivity/object_reactivity.exthtml';
//const filePathIfNoneInformed = './src/examples/exthtml/object_and_array_reactivity/array_reactivity.exthtml';
//const filePathIfNoneInformed = './src/examples/exthtml/var_modified_but_could_be_reseted/var_modified_but_could_be_reseted.exthtml';
//const filePathIfNoneInformed = './src/examples/exthtml/array_reactivity/array_reactivity.exthtml';
//const filePathIfNoneInformed = './src/examples/exthtml/events_on_btn/events_on_btn.exthtml';
//const filePathIfNoneInformed = './src/examples/exthtml/var_reactivity/var_reactivity.exthtml';
//const filePathIfNoneInformed = './src/examples/exthtml/input_reactivity_with_event/input_reactivity_with_event.exthtml'
//const filePathIfNoneInformed = './src/examples/exthtml/var_reactivity_with_logic/var_reactivity_with_logic.exthtml'
//const filePathIfNoneInformed = './src/examples/exthtml/svelte_based/vars/samples/imports/index.exthtml'
//const filePathIfNoneInformed = './src/examples/exthtml/svelte_based/vars/samples/duplicate-non-hoistable/index.exthtml'
//const filePathIfNoneInformed = './src/examples/exthtml/svelte_based/vars/samples/modular-vars/index.exthtml'
//const filePathIfNoneInformed = './src/examples/exthtml/script_inside_html/script_code_inside_component.exthtml'
//const filePathIfNoneInformed = './src/examples/exthtml/macro_attribute/idname_attribute.exthtml'
//const filePathIfNoneInformed = './src/examples/exthtml/lang_attribute/if/simple_div.exthtml'
//const filePathIfNoneInformed = '../exthtml_vite_plugin/tests/kindergarten/if_directive/simple_and_direct_before/index.exthtml'
//const filePathIfNoneInformed = '../exthtml_vite_plugin/tests/kindergarten/if_directive/double_ifs_conditional/index.exthtml'
//const filePathIfNoneInformed = '../exthtml_vite_plugin/tests/kindergarten/for_directive/simple_array/index.exthtml'
//const filePathIfNoneInformed = '../exthtml_vite_plugin/tests/kindergarten/if_directive/nested_ifs/index.exthtml'
const filePathIfNoneInformed = './src/examples/exthtml/simple_component/main.exthtml';


const args = process.argv.slice(2);

// If an argument is passed, save it to filePath, else undefined
const filePath = args.length > 0 ? args[0] : path.join(__dirname, filePathIfNoneInformed);


async function main() {
  try {
    let [scripts,exthtml,styles,generate_code, generated_ctx] = await exthtmlCompileFile(filePath);

    for( let x = 0; x < scripts.length; x++){
        let script = scripts[x]

        for( let i = 0; i < script.children.length; i++ ){
          //console.log(inspect(script.children[i], { depth: null, colors: true }));
        }
    }

    //console.log(generated_ctx)
    //console.log(generate_code)
    //fs.writeFileSync('output_ctx.js', generated_ctx);
    fs.writeFileSync('output.js', generate_code);
    //fs.writeFileSync(path.basename(filePath, path.extname(filePath))+".js", generate_code);
  } catch (err) {
    console.error('Error reading file:', err);
  }
}

main();
