import { parse } from "../parse/exthtml/parser_exthtml.js"
import { parseStyle } from "../parse/css/parser_css.js"
import { parseScript } from "../parse/js/parser_js.js"
//import { style } from "../analyse/exthtml/directives/style";


export function exthtmlCompile(source_code_content){
    const ast = parse(source_code_content);
    let {scripts = [],exthtml = [],styles = []} = extract_sfc_contents_parts(ast)
    

    let parsedOutput = parseScriptsAndStylesTags(scripts,styles)
    scripts = parsedOutput[0]
    styles = parsedOutput[1]

    return [scripts,exthtml,styles]

    const analysis = analyse(ast)
    return generate4Web(ast,analysis)
    return {ast:JSON.stringify(ast, null, 4)}
}

function extract_sfc_contents_parts(ast){
    let scripts = []
    let exthtml = []
    let styles = []

    extractor_sfc_walker(ast, scripts, exthtml, styles)

    return {scripts, exthtml, styles}
}

function parseScriptsAndStylesTags(scripts,styles){

    for(let x = 0; x < scripts.length; x++){
        scripts[x].children = parseScript(scripts[x])
    }
    for(let x = 0; x < styles.length; x++){
        styles[x].children = parseStyle(styles[x])

    }
    
    return [scripts,styles]
}


function analyse(ast){
    
}

function generate4Web(ast,analysis){

}

function extractor_sfc_walker(ast, scripts, exthtml, styles, level){
    level = level || 1
    let output = []
    for (let i = 0; i < ast.length; i++) {
        let node = ast[i];
        if(node.section != 'ExtHTMLDocument'){
            continue
        }

        if( node.type == 'SCRIPT_TAG'){
            scripts.push(node)
        } else if( node.type == 'STYLE_TAG'){
            styles.push(node)
        } else {
            node.children = extractor_sfc_walker(node.children,scripts,exthtml,styles, level+1)
            if(level == 1){
                exthtml.push(node)
            }
            output.push(node)
        }
    }
    return output
}

function print_nodes(ast, indent = 0){
    const indentStr = '\t'.repeat(indent);

    ast.forEach(node => {
        node_print = {...node,children:undefined}
        console.log(indentStr+JSON.stringify(node_print,null,indentStr.replace("\t","    ")))
        // If node has children, recursively print them with increased indent
        if (node.children && node.children.length > 0) {
            printNodes(node.children, indent + 1);
        }
    })
}