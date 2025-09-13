import * as csstree from 'css-tree';

export function parseStyle(style_ast){
    let node = style_ast
    if(
        node.section != 'ExtHTMLDocument'
        ||
        node.type != 'STYLE_TAG'
    ){
        throw new Error("Unexpected node on parserStyle.");
    }
    const code = node.value
    style_ast.hash = hash(code)
    style_ast.prefix = 'exthtml'
    return csstree.parse(code)
}

export function updateNames(style){
    let classNames = {}
    let idNames = {}
    let typeSelect = {}

    // Walk AST and extract class and id selectors
    csstree.walk(style.children, {
        visit: 'Selector',
        enter(node) {
            node.children.forEach(child => {
                if (child.type === 'ClassSelector') {
                    let new_nm = style.prefix+'-'+style.hash+'-'+child.name
                    classNames[child.name] = new_nm
                    child.name = new_nm
                } else if (child.type === 'IdSelector') {
                    let new_nm = style.prefix+'-'+style.hash+'-'+child.name
                    idNames[child.name] = new_nm
                    child.name = new_nm
                } else if (child.type === 'TypeSelector') {
                    let new_nm = style.prefix+'-'+style.hash+'-'+child.name
                    typeSelect[child.name] = new_nm
                    child.name = `.${new_nm}`
                }
            });
        }
    });
    return {
        classNames,
        idNames,
        typeSelect
    }
}

export function emptyCssTree(){
    return {
        "classNames":{},
        "idNames":{},
        "typeSelect":{}
    }
}

// generate CSS from AST
export function ast2strCss(ast){
    return csstree.generate(ast)
}


function traverseAst(ast){
    // traverse AST and modify it
    csstree.walk(ast, (node) => {
        if (node.type === 'ClassSelector' && node.name === 'example') {
            node.name = 'hello';
        }
    });
    return ast
}

function getAllClassesName(ast){
    const classNames = new Set()

    csstree.walk(ast, node => {
        if (node.type === 'ClassSelector') {
            classNames.add(node.name)
        }
    })

    return Array.from(classNames)
}

function getAllIdsSelectors(ast){
    const idSelectors = new Set()

    csstree.walk(ast, node => {
        if (node.type === 'IdSelector') {
            idSelectors.add(node.name);
        }
    })
 
    return Array.from(idSelectors)
}

function getAllAttributeSelector(ast){
    const attributeSelectors = new Set()

    csstree.walk(ast, node => {
        if (node.type === 'AttributeSelector') {
            // Re-generate the attribute selector text from the node
            const attrSelector = csstree.generate(node);
            attributeSelectors.add(attrSelector);
        }
    })

    return Array.from(attributeSelectors)
}

function hash(str) {
  let hash = 5381;
  let i = str.length;

  while (i--) {
    hash = (hash * 33) ^ str.charCodeAt(i);
  }

  // Convert to positive 32-bit integer and then to base36 string
  return (hash >>> 0).toString(36);
}
