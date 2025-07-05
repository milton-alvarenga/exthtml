import fs from 'fs/promises';
import { parse } from "../parse/exthtml/parser_exthtml.js"
import { parseStyle } from "../parse/css/parser_css.js"
import { parseScript } from "../parse/js/parser_js.js"
import * as macro from "./directives/macro.js"
import * as drall from "./directives/drall.js"
import * as estreewalker from 'estree-walker';
import * as periscopic from 'periscopic';
import * as acorn from 'acorn'
import { inspect } from 'util';

//import { style } from "../analyse/exthtml/directives/style";

let __VERSION__ = '0.0.1'

let elem_counter = 1

export async function exthtmlCompileFile(filePath) {
    const source_code_content = await fs.readFile(filePath, 'utf8');
    try {
        return exthtmlCompile(source_code_content);
    } catch (err) {
        err.errors.unshift(new Error(`Error on file ${filePath}`))

        throw new AggregateError(err.errors)
    }
}


export function exthtmlCompile(source_code_content) {
    const ast = parse(source_code_content);
    let { scripts = [], exthtml = [], styles = [] } = extract_sfc_contents_parts(ast)

    console.log(inspect(exthtml, { depth: null, colors: true, showHidden: true }));
    let parsedOutput = parseScriptsAndStylesTags(scripts, styles)
    scripts = parsedOutput[0]
    styles = parsedOutput[1]

    const analysis = analyse(exthtml, scripts, styles)
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


function analyse(exthtml, scripts, styles) {
    const result = {
        variables: new Set(),
        willChange: new Set(),
        willUseInTemplate: new Set(),
        reactiveDeclarations: {},
        code: {
            elems: [],
            create: [],
            mount: [],
            update: [],
            destroy: []
        }
    }

    const reactiveDeclarations = []
    const toRemove = new Set()

    for (let x = 0; x < scripts.length; x++) {
        const { scope, map, globals } = periscopic.analyze(scripts[x].children)
        result.variables = new Set(scope.declarations.keys())

        scripts[x].children.body.forEach((node, index) => {
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
        scripts[x].children.body = scripts[x].children.body.filter((node) => !toRemove.has(node))
        result.reactiveDeclarations = reactiveDeclarations


        let currentScope = scope
        estreewalker.walk(scripts[x].children.body, {
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

        exthtml.forEach(node => traverseExthtml(node, result, 'ROOT'))

        /*
                console.log(inspect(scope, { depth: null, colors: true, showHidden: true }));
                console.log(inspect(map, { depth: null, colors: true, showHidden: true }));
                console.log(inspect(globals, { depth: null, colors: true, showHidden: true }));
        */
        console.log(inspect(result, { depth: null, colors: true, showHidden: true }));
    }

}

function traverseExthtml(exthtml, result, parent_nm) {
    let variableName = ''
    try {
        switch (exthtml.type) {
            case 'NEW_LINE':
            case 'SINGLE_LINE_COMMENT':
            case 'MULTIPLE_LINE_COMMENT':
            case 'COMMENT_TEXT':
            case 'SCRIPT_TAG':
            case 'STYLE_TAG':
                return
            case 'DYNAMIC_TEXT_NODE':
                variableName = `dyn_txt_${elem_counter++}`
                result.code.elems.push(variableName)
                result.code.create.push(`${variableName} = text(${exthtml.value})`)
                result.code.update.push(`${variableName}.textContent = ${exthtml.value}`)
                result.code.mount.push(`append(${parent_nm},${variableName})`)
                result.code.destroy.push(`detach(${variableName})`)
                return

            case 'TEXT_NODE':
                variableName = `txt_${elem_counter++}`
                result.code.elems.push(variableName)
                result.code.create.push(`${variableName} = text('${exthtml.value}')`)
                result.code.mount.push(`append(${parent_nm},${variableName})`)
                result.code.destroy.push(`detach(${variableName})`)
                return

            case 'TEXTAREA_TAG':
                variableName = `textarea_${elem_counter++}`
                break
            case 'TITLE_TAG':
                variableName = `textarea_${elem_counter++}`
                break
            case 'PLAINTEXT_TAG':
                variableName = `plaintext_${elem_counter++}`
                break
            case 'HTML_NESTED_TAG':
                variableName = `${exthtml.value.toLowerCase()}_${elem_counter++}`
                break
            case 'SELF_CLOSE_TAG':
                variableName = `${exthtml.value.toLowerCase()}_${elem_counter++}`
                result.code.elems.push(variableName)
                exthtml.dynamic_attrs.forEach(dynamicAttr => traverseExthtmlAttr(dynamicAttr))
                exthtml.event_attrs.forEach(eventAttr => traverseExthtmlEventAttr(eventAttr))
                result.code.mount.push(`append(${parent_nm},${variableName})`)
                result.code.destroy.push(`detach(${variableName})`)
                return
            case 'COMPONENT':

                break
            default:
                throw Error(`${traverseExthtml.name} Error on unexpected type equal ${exthtml.type} and value ${exthtml.value} at line ${exthtml.location.line}`)
        }

        result.code.elems.push(variableName)
        result.code.create.push(`${variableName} = el('${exthtml.value.toLowerCase()}')`)

        exthtml.children.forEach(node => traverseExthtml(node, result, variableName, parent_nm))
        exthtml.attrs.forEach(staticAttr => traverseExthtmlAttr(staticAttr, "STATIC", result, variableName, parent_nm))
        exthtml.dynamic_attrs.forEach(dynamicAttr => traverseExthtmlAttr(dynamicAttr, "DYNAMIC", result, variableName, parent_nm))
        exthtml.event_attrs.forEach(eventAttr => traverseExthtmlEventAttr(eventAttr, "DYNAMIC", result, variableName, parent_nm))

        result.code.mount.push(`append(${parent_nm},${variableName})`)
        result.code.destroy.push(`detach(${variableName})`)
    } catch (err) {
        let errors = [err, new Error(`${traverseExthtml.name} Error on ${exthtml.type}.${exthtml.value} at line ${exthtml.location.line}`)]
        throw new AggregateError(errors)
    }
}

function traverseExthtmlAttr(attr, mode, result, variableName, parent_nm) {
    let aValidMode = ['DYNAMIC','STATIC']

    if (!aValidMode.includes(mode)) {
        throw new Error(`Invalid mode: ${mode}. Expected one of: ${aValidMode.join(', ')}`);
    }


    switch (attr.category) {
        case "html_global_boolean_attribute":
        case "html_boolean_attribute":
            htmlBooleanAttr(attr, mode, result, variableName, parent_nm)
            break
        case "html_data_attribute":
            htmlDataAttr(attr, mode, result, variableName, parent_nm)
            break
        case "html_global_non_boolean_attribute":
        case "html_attribute":
            htmlRegularAttr(attr, mode, result, variableName, parent_nm)
            break
        case "html_media_readonly":
        case "html_video_readonly":
            htmlReadOnlyAttr(attr, mode, result, variableName, parent_nm)
            break
        case "custom_attribute":
            htmlCustomAttr(attr, mode, result, variableName, parent_nm)
            break
        case "drall_directive":
            htmlDrallDirective(attr, mode, result, variableName, parent_nm)
            break
        case "macro_directive":
            htmlMacroDirective(attr, mode, result, variableName, parent_nm)
            break
        default:
            throw Error(`${traverseExthtmlAttr.name} function: Invalid ${mode.lowercase()} attribute on ${attr.name} as it is of category ${attr.category} not recognized`)
    }
}

function checkMode(mode){
    let aValidMode = ['DYNAMIC','STATIC']

    if (!aValidMode.includes(mode)) {
        throw new Error(`Invalid mode: ${mode}. Expected one of: ${aValidMode.join(', ')}`);
    }
}

function traverseExthtmlEventAttr(eventAttr, mode, result, variableName, parent_nm) {
    checkMode(mode)
}


function htmlBooleanAttr(attr, mode, result, variableName, parent_nm) {
    checkMode(mode)

    if( mode == "STATIC") {
        result.code.create.push(`setAttr('${variableName}', '${attr.name}', '${attr.value}')`)
    } else {
        result.code.update.push(`setAttr('${variableName}', '${attr.name}', ${attr.value})`)
    }
}

function htmlDataAttr(attr, mode, result, variableName, parent_nm) {
    checkMode(mode)
}

function htmlRegularAttr(attr, mode, result, variableName, parent_nm) {
    checkMode(mode)
    //class
    //style
}

function htmlReadOnlyAttr(attr, mode, result, variableName, parent_nm) {
    throw Error(`${htmlReadOnlyAttr.name} function: Invalid ${mode.lowercase()} attribute on ${attr.name} as it is readonly attribute`)
}

function htmlCustomAttr(attr, mode, result, variableName, parent_nm) {
    checkMode(mode)
}

function htmlDrallDirective(attr, mode, result, variableName, parent_nm) {
    checkMode(mode)

    if ( ! (attr.name in drall.directives) ){
        throw Error(`${htmlMacroDirective.name} function: Invalid ${mode.lowercase()} attribute on ${attr.name} as it is macro directive attribute but the compiler could not found it on directive list`)
    }

    drall.directives[attr.name](attr, mode, result, variableName, parent_nm)
}

function htmlMacroDirective(attr, mode, result, variableName, parent_nm) {
    checkMode(mode)

    if ( ! (attr.name in macro.directives) ){
        throw Error(`${htmlMacroDirective.name} function: Invalid ${mode.lowercase()} attribute on ${attr.name} as it is macro directive attribute but the compiler could not found it on directive list`)
    }

    macro.directives[attr.name](attr, mode, result, variableName, parent_nm)
}


function generate4Web(ast, analysis) {
    const banner = `Generated by ExtHTML v${__VERSION__}`
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