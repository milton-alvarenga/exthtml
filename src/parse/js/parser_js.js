import * as acorn from 'acorn';



export function parseScript(scripts_ast){
    let output = []
    for (let i = 0; i < scripts_ast.length; i++) {
        let node = scripts_ast[i]
        if(
            node.section != 'ExtHTMLDocument'
            ||
            node.type == 'SCRIPT_TAG'
        ){
            throw new Error("Unexpected node on parserScript.");
        }

        const code = node.value
        let ast = {
            script: acorn.parse(code, { ecmaVersion: 2022 })
        }
        output.push(ast)
    }
    return output
}
