import * as acorn from 'acorn';



export function parseScript(script_ast) {
    let node = script_ast
    if (
        node.section != 'ExtHTMLDocument'
        ||
        node.type != 'SCRIPT_TAG'
    ) {
        throw new Error("Unexpected node on parseScript.");
    }

    const code = node.value
    return parseCode(code)
}

export function parseCode(source_code) {
    return acorn.parse(source_code, { ecmaVersion: 2022, sourceType: 'module' })
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
            type: 'AssignmentExpression',
            operator: '=',
            left: { type: 'Identifier', name: varName },
            right: {
                type: 'CallExpression',
                callee: { type: 'Identifier', name: '$$_setReactive' },
                arguments: [
                    { type: 'Literal', value: varName },
                    { type: 'Identifier', name: varName },
                    { type: 'Identifier', name: '$$_dependencyTree' },
                    { type: 'Identifier', name: '$$_changes' }
                ]
            }
        }
    }

}

export function createCheckReactiveNode(varName) {
    return {
        type: 'ExpressionStatement',
        expression: {
            type: 'CallExpression',
            callee: { type: 'Identifier', name: '$$_checkReactive' },
            arguments: [
                { type: 'Literal', value: varName },
                { type: 'Identifier', name: varName },
                { type: 'Identifier', name: '$$_dependencyTree' },
                { type: 'Identifier', name: '$$_changes' }
            ]
        }
    }
}

function getRootIdentifierName(node) {
    let curr = node;
    while (curr.type === 'MemberExpression') {
        curr = curr.object;
    }
    if (curr.type === 'Identifier') {
        return curr.name;
    }
    return null;
}

export function parseEventDescription(eventDescription) {
    let ast = parseCode(eventDescription)

    if (!ast || !ast.body || !ast.body[0] || ast.body[0].type !== 'ExpressionStatement') {
        throw new Error("Unsupported expression type: " + (ast && ast.body && ast.body[0] ? ast.body[0].type : 'Unknown') + " and description: " + eventDescription);
    }

    ast = ast.body[0].expression

    if (ast.type === "Identifier") {
        // Case: just function name, e.g. fnName
        return {
            type: "functionName",
            name: ast.name,
            parameters: null
        };
    }
    else if (ast.type === "CallExpression") {
        const callee = ast.callee;

        if (callee.type === 'MemberExpression') {
            const fullPath = getMemberExpressionName(callee);
            const variable = getRootIdentifierName(callee);
            const methodName = variable && fullPath.startsWith(variable + '.') ? fullPath.substring(variable.length + 1) : fullPath;

            const type = ast.arguments.length > 0 ? 'methodCallWithParams' : 'methodCall';

            return {
                type,
                variable,
                methodName,
                parameters: ast.arguments.map(arg => eventDescription.slice(arg.start, arg.end))
            };
        }

        // Fallback for simple function calls like myFunction()
        const fnName = callee.name;
        if (!fnName) {
            throw new Error("Unsupported callee structure");
        }

        if (ast.arguments.length === 0) {
            // fnName()
            return {
                type: "functionCall",
                name: fnName,
                parameters: [],
            };
        } else {
            // fnName(params...)
            // Extract parameter source code or expressions
            // Here, parameters can be further parsed or stringified
            return {
                type: "functionCallWithParams",
                name: fnName,
                parameters: ast.arguments.map(arg => eventDescription.slice(arg.start, arg.end)),
            };
        }
    }
    else if (ast.type === "AssignmentExpression") {
        // Case: an assignment, e.g. someVar = expr
        // Extract variable changed (left side)
        const variableChanged = getAssignmentLeftSide(ast.left);
        // Extract dependencies from the right side (could be identifiers, function calls etc.)
        const dependencies = extractDependencies(ast.right);

        return {
            type: "assignment",
            variableChanged,
            dependencies,
        };
    }
    else if (ast.type === "ArrowFunctionExpression") {
        const parameters = ast.params.map(param => eventDescription.slice(param.start, param.end));
        const bodyType = ast.body.type === "BlockStatement" ? "block" : "expression";
        const rawBody = eventDescription.slice(ast.body.start, ast.body.end);

        return {
            type: "arrowFunction",
            parameters,
            bodyType,
            rawBody: rawBody,
        };
    }
    else if (ast.type == "UpdateExpression") {
        // Extract the variable changed (argument of the UpdateExpression)
        const variableChanged = getAssignmentLeftSide(ast.argument);
        // For UpdateExpression, dependencies are usually just the argument itself
        // or could be empty if you don't need dependencies here

        const dependencies = []

        return {
            type: "updateExpression",
            variableChanged,
            dependencies,
            // e.g. ++ or --
            operator: ast.operator,
            // boolean: true if ++x, false if x++
            prefix: ast.prefix
        };
    }
    else {
        throw new Error("Unsupported expression type: " + ast.type + " and description: " + eventDescription);
    }
}

// Helper: extract variable name for AssignmentExpression left side
function getAssignmentLeftSide(node) {
    if (node.type === "Identifier") {
        return node.name;
    }
    if (node.type === "MemberExpression") {
        return getMemberExpressionName(node);
    }
    // Extend as needed for destructuring or other patterns
    throw new Error("Unknown assignment left side structure");
}

// Helper: extract full name from MemberExpression e.g. obj.prop or obj['prop']
function getMemberExpressionName(node) {
    if (node.type !== "MemberExpression") return null;
    const objectName = node.object.type === "Identifier" ? node.object.name : getMemberExpressionName(node.object);
    const propertyName = node.property.type === "Identifier" ? node.property.name : `[${node.property.value}]`;
    return `${objectName}.${propertyName}`;
}

// Helper: extract dependencies (identifiers) from an AST node (right side of assignment)
// This example returns list of identifier names appearing anywhere in the expression
function extractDependencies(node) {
    const deps = new Set();
    function walk(n) {
        switch (n.type) {
            case "Identifier":
                deps.add(n.name);
                break;
            case "MemberExpression":
                walk(n.object);
                if (n.property.type !== "Identifier") walk(n.property);
                break;
            case "CallExpression":
                walk(n.callee);
                n.arguments.forEach(arg => walk(arg));
                break;
            case "BinaryExpression":
            case "LogicalExpression":
                walk(n.left);
                walk(n.right);
                break;
            case "UnaryExpression":
                walk(n.argument);
                break;
            case "ConditionalExpression":
                walk(n.test);
                walk(n.consequent);
                walk(n.alternate);
                break;
            // Add other expression types as needed
            default:
                if (n.body) {
                    if (Array.isArray(n.body)) n.body.forEach(walk);
                    else walk(n.body);
                }
                if (n.argument) walk(n.argument);
                break;
        }
    }
    walk(node);
    return Array.from(deps);
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