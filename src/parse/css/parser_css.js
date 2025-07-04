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
    return csstree.parse(code).children
}

// generate CSS from AST
function ast2strCss(ast){
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