import * as acorn from 'acorn';



export function parseScript(script_ast){
    let node = script_ast
    if(
        node.section != 'ExtHTMLDocument'
        ||
        node.type != 'SCRIPT_TAG'
    ){
        throw new Error("Unexpected node on parseScript.");
    }

    const code = node.value
    return parseCode(code)
}

export function parseCode(source_code){
    return acorn.parse(source_code, { ecmaVersion: 2022 })
}

function extract_names(jsNode, result = []) {
  switch (jsNode.type) {
    case 'Identifier':
      result.push(jsNode.name);
      break;
    case 'BinaryExpression':
      extract_names(jsNode.left, result);
      extract_names(jsNode.right, result);
      break;
  }
  return result
}

export function createSetReactiveNode(varName) {
    return {
        type: 'ExpressionStatement',
        expression: {
            type: 'CallExpression',
            callee: { type: 'Identifier', name: 'setReactive' },
            arguments: [
                { type: 'Literal', value: varName },
                { type: 'Identifier', name: varName },
                { type: 'Identifier', name: '$$_dependencyTree' },
                { type: 'Identifier', name: '$$_changes' }
            ]
        }
    }
}

export function createCheckReactiveNode(varName) {
    return {
        type: 'ExpressionStatement',
        expression: {
            type: 'CallExpression',
            callee: { type: 'Identifier', name: 'checkReactive' },
            arguments: [
                { type: 'Literal', value: varName },
                { type: 'Identifier', name: varName },
                { type: 'Identifier', name: '$$_dependencyTree' },
                { type: 'Identifier', name: '$$_changes' }
            ]
        }
    }
}

// alert
// confirm
// prompt
// setTimeout
// clearTimeout
// setInterval
// clearInterval
// console.xxxx
// fetch
// localStorage
// sessionStorage
// navigator.xxxxx
// history.xxxxxx
// window.xxxxx

/*
Program Structure
    Program
    BlockStatement
    EmptyStatement
    ExpressionStatement
    LabeledStatement
    BreakStatement
    ContinueStatement
    WithStatement
    ReturnStatement
    ThrowStatement
    TryStatement
    CatchClause
    DebuggerStatement

Declarations
    FunctionDeclaration
    VariableDeclaration
    VariableDeclarator
    ClassDeclaration

Expressions
    ThisExpression
    ArrayExpression
    ObjectExpression
    Property
    FunctionExpression
    ArrowFunctionExpression
    YieldExpression
    Literal
    UnaryExpression
    UpdateExpression
    BinaryExpression
    AssignmentExpression
    LogicalExpression
    MemberExpression
    ConditionalExpression
    CallExpression
    NewExpression
    SequenceExpression
    TemplateLiteral
    TaggedTemplateExpression
    TemplateElement
    ClassExpression
    MetaProperty
    Super
    ImportExpression

Patterns (used in destructuring)
    ObjectPattern
    ArrayPattern
    RestElement
    AssignmentPattern
    Identifier

Statements related to modules
    ImportDeclaration
    ImportSpecifier
    ImportDefaultSpecifier
    ImportNamespaceSpecifier
    ExportNamedDeclaration
    ExportDefaultDeclaration
    ExportAllDeclaration
    ExportSpecifier

Classes
    ClassBody
    MethodDefinition

Miscellaneous
    AwaitExpression
    ChainExpression
    PrivateIdentifier
*/