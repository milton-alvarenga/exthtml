import { parse } from "../parse/exthtml/parser_exthtml.js"
import { parseStyle } from "../parse/css/parser_css.js"
import { parseScript } from "../parse/js/parser_js.js"
import * as estreewalker from 'estree-walker';
import * as periscopic from 'periscopic';
import * as acorn from 'acorn'
import { inspect } from 'util';

//import { style } from "../analyse/exthtml/directives/style";


export function exthtmlCompile(source_code_content) {
    const ast = parse(source_code_content);
    let { scripts = [], exthtml = [], styles = [] } = extract_sfc_contents_parts(ast)

console.log(inspect(exthtml, { depth: null, colors: true, showHidden: true }));
    let parsedOutput = parseScriptsAndStylesTags(scripts, styles)
    scripts = parsedOutput[0]
    styles = parsedOutput[1]

    const analysis = analyse(exthtml,scripts)
    return [scripts, exthtml, styles]


    return generate4Web(ast, analysis)
    return { ast: JSON.stringify(ast, null, 4) }
}

function extract_sfc_contents_parts(ast) {
    let scripts = []
    let exthtml = []
    let styles = []

    extractor_sfc_walker(ast, scripts, exthtml, styles)

    return { scripts, exthtml, styles }
}

function parseScriptsAndStylesTags(scripts, styles) {

    for (let x = 0; x < scripts.length; x++) {
        scripts[x].children = parseScript(scripts[x])
    }
    for (let x = 0; x < styles.length; x++) {
        styles[x].children = parseStyle(styles[x])
    }

    return [scripts, styles]
}


function analyse(exthtml,scripts) {
    let ast = scripts
    const result = {
        variables: new Set(),
        willChange: new Set(),
        willUseInTemplate: new Set(),
        reactiveDeclarations: {}
    }

    const reactiveDeclarations = []
    const toRemove = new Set()

    for (let x = 0; x < ast.length; x++) {
        const { scope, map, globals } = periscopic.analyze(ast[x].children)
        result.variables = new Set(scope.declarations.keys())

        ast[x].children.body.forEach((node, index) => {
            if (node.type === 'LabeledStatement' && node.label.name === '$') {
                toRemove.add(node);
                const body = node.body;
                const left = body.expression.left;
                const right = body.expression.right;
                const dependencies = [];

                estreewalker.walk(right, {
                    enter(node) {
                        if (node.type === 'Identifier') {
                            dependencies.push(node.name);
                        }
                    },
                });
                result.willChange.add(left.name);
                const reactiveDeclaration = {
                    assignees: [left.name],
                    dependencies: dependencies,
                    node: body,
                    index,
                };
                reactiveDeclarations.push(reactiveDeclaration);
            }
        });
        ast[x].children.body = ast[x].children.body.filter((node) => !toRemove.has(node))
        result.reactiveDeclarations = reactiveDeclarations

        let currentScope = scope
        estreewalker.walk(ast[x].children, {
            enter(node) {
                if (map.has(node)) currentScope = map.get(node);
                if (
                    node.type === 'UpdateExpression'
                    ||
                    node.type === 'AssignmentExpression'
                ) {
                    const names = periscopic.extract_names(
                        node.type === 'UpdateExpression' ? node.argument : node.left
                    );
                    for (const name of names) {
                        if (
                            currentScope.find_owner(name) === rootScope
                            ||
                            globals.has(name)
                        ) {
                            result.willChange.add(name);
                        }
                    }
                }
            },
            leave(node) {
                if (map.has(node)) currentScope = currentScope.parent;
            },
        });

        exthtml.forEach(node => traverseExthtml(node))

        /*
                console.log(inspect(scope, { depth: null, colors: true, showHidden: true }));
                console.log(inspect(map, { depth: null, colors: true, showHidden: true }));
                console.log(inspect(globals, { depth: null, colors: true, showHidden: true }));
        */
        console.log(inspect(result, { depth: null, colors: true, showHidden: true }));
    }

}

function traverseExthtml(exthtml){
    switch(exthtml.type){
        case 'NEW_LINE':
        case 'SINGLE_LINE_COMMENT':
        case 'MULTIPLE_LINE_COMMENT':
        case 'COMMENT_TEXT':
        case 'SCRIPT_TAG':
        case 'STYLE_TAG':
        case 'TEXT_NODE':
            return
        case 'DYNAMIC_TEXT_NODE':
            exthtml.value
            return
    }
    exthtml.children.forEach( node => traverseExthtml(node))
    exthtml.dynamic_attrs.forEach( dynamicAttr => traverseExthtmlAttr(dynamicAttr))
    exthtml.event_attrs.forEach( eventAttr => traverseExthtmlEventAttr(eventAttr))
}

function traverseExthtmlAttr(dynamicAttr){
    switch(dynamicAttr.category){
        case "html_global_boolean_attribute":
        case "html_boolean_attribute":
            htmlBooleanAttr(dynamicAttr)
        break;
        case "html_data_attribute":
            htmlDataAttr(dynamicAttr)
        case "html_global_non_boolean_attribute":
        case "html_attribute":
            htmlRegularAttr(dynamicAttr)
        case "html_media_readonly":
        case "html_video_readonly":
            htmlReadOnlyAttr(dynamicAttr)
        case "custom_attribute":
            htmlMacroAttr(dynamicAttr)
        case "drall_directive":
            htmlDrallDirective(dynamicAttr)
        case "macro_directive":
            htmlMacroDirective(dynamicAttr)
    }
}

function traverseExthtmlEventAttr(eventAttr){

}


function htmlBooleanAttr(dynamicAttr){

}

function htmlDataAttr(dynamicAttr){

}

function htmlRegularAttr(dynamicAttr){
    //class
    //style
}

function htmlReadOnlyAttr(dynamic_attrs){

}

function htmlMacroAttr(dynamicAttr){

}

function htmlDrallDirective(dynamicAttr){

}

function htmlMacroDirective(dynamicAttr){

}


function generate4Web(ast, analysis) {

}

function extractor_sfc_walker(ast, scripts, exthtml, styles, level) {
    level = level || 1
    let output = []
    for (let i = 0; i < ast.length; i++) {
        let node = ast[i];
        if (node.section != 'ExtHTMLDocument') {
            continue
        }

        if (node.type == 'SCRIPT_TAG') {
            scripts.push(node)
        } else if (node.type == 'STYLE_TAG') {
            styles.push(node)
        } else {
            node.children = extractor_sfc_walker(node.children, scripts, exthtml, styles, level + 1)
            if (level == 1) {
                exthtml.push(node)
            }
            output.push(node)
        }
    }
    return output
}

function print_nodes(ast, indent = 0) {
    const indentStr = '\t'.repeat(indent);

    ast.forEach(node => {
        node_print = { ...node, children: undefined }
        console.log(indentStr + JSON.stringify(node_print, null, indentStr.replace("\t", "    ")))
        // If node has children, recursively print them with increased indent
        if (node.children && node.children.length > 0) {
            printNodes(node.children, indent + 1);
        }
    })
}