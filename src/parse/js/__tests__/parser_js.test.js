import {
    parseScript,
    parseCode,
    createSetReactiveNode,
    createCheckReactiveNode,
    parseEventDescription
} from '../parser_js.js';

describe('parser_js', () => {
    describe('parseCode', () => {
        it('should parse a simple javascript code string into an AST', () => {
            const code = 'const a = 1;';
            const ast = parseCode(code);
            expect(ast).toBeDefined();
            expect(ast.type).toBe('Program');
            expect(ast.body[0].type).toBe('VariableDeclaration');
        });
    });

    describe('parseScript', () => {
        it('should parse the code from a valid SCRIPT_TAG node', () => {
            const script_ast = {
                section: 'ExtHTMLDocument',
                type: 'SCRIPT_TAG',
                value: 'let x = 10;'
            };
            const ast = parseScript(script_ast);
            expect(ast).toBeDefined();
            expect(ast.type).toBe('Program');
            expect(ast.body[0].type).toBe('VariableDeclaration');
        });

        it('should throw an error for an invalid node type', () => {
            const invalid_ast = {
                section: 'ExtHTMLDocument',
                type: 'HTML_TAG',
                value: '<div></div>'
            };
            expect(() => parseScript(invalid_ast)).toThrow("Unexpected node on parseScript.");
        });
    });

    describe('createSetReactiveNode', () => {
        it('should create a valid AST node for setting a reactive variable', () => {
            const varName = 'myVar';
            const node = createSetReactiveNode(varName);
            expect(node.type).toBe('ExpressionStatement');
            expect(node.expression.type).toBe('AssignmentExpression');
            expect(node.expression.left.name).toBe(varName);
            expect(node.expression.right.callee.name).toBe('$$_setReactive');
        });
    });

    describe('createCheckReactiveNode', () => {
        it('should create a valid AST node for checking a reactive variable', () => {
            const varName = 'myVar';
            const node = createCheckReactiveNode(varName);
            expect(node.type).toBe('ExpressionStatement');
            expect(node.expression.type).toBe('CallExpression');
            expect(node.expression.callee.name).toBe('$$_checkReactive');
            expect(node.expression.arguments[0].value).toBe(varName);
        });
    });

    describe('parseEventDescription', () => {
        it('should parse a function name identifier', () => {
            const result = parseEventDescription('myFunction');
            expect(result).toEqual({
                type: 'functionName',
                name: 'myFunction',
                parameters: null
            });
        });

        it('should parse a function call without parameters', () => {
            const result = parseEventDescription('myFunction()');
            expect(result).toEqual({
                type: 'functionCall',
                name: 'myFunction',
                parameters: []
            });
        });

        it('should parse a function call with parameters', () => {
            const result = parseEventDescription('myFunction(a, 1, "hello")');
            expect(result).toEqual({
                type: 'functionCallWithParams',
                name: 'myFunction',
                parameters: ['a', '1', '"hello"']
            });
        });

        it('should parse an assignment expression', () => {
            const result = parseEventDescription('a = b + 1');
            expect(result).toEqual({
                type: 'assignment',
                variableChanged: 'a',
                dependencies: ['b']
            });
        });
        
        it('should parse an assignment to a member expression', () => {
            const result = parseEventDescription('user.name = "John"');
            expect(result).toEqual({
                type: 'assignment',
                variableChanged: 'user.name',
                dependencies: []
            });
        });

        it('should parse an arrow function with no params and block body', () => {
            const result = parseEventDescription('() => { console.log("hi"); }');
            expect(result).toEqual({
                type: 'arrowFunction',
                parameters: [],
                bodyType: 'block',
                rawBody: '{ console.log("hi"); }'
            });
        });

        it('should parse an arrow function with params and expression body', () => {
            const result = parseEventDescription('(a, b) => a + b');
            expect(result).toEqual({
                type: 'arrowFunction',
                parameters: ['a', 'b'],
                bodyType: 'expression',
                rawBody: 'a + b'
            });
        });

        it('should parse a postfix update expression', () => {
            const result = parseEventDescription('i++');
            expect(result).toEqual({
                type: 'updateExpression',
                variableChanged: 'i',
                dependencies: [],
                operator: '++',
                prefix: false
            });
        });

        it('should parse a prefix update expression', () => {
            const result = parseEventDescription('--j');
            expect(result).toEqual({
                type: 'updateExpression',
                variableChanged: 'j',
                dependencies: [],
                operator: '--',
                prefix: true
            });
        });

        it('should parse an array push', () => {
            const result = parseEventDescription('items.push("F")');
            expect(result).toEqual({
                type: 'methodCallWithParams',
                variable: 'items',
                methodName:  'push',
                parameters: ['"F"']
            });
        });

        it('should parse an multi-level object', () => {
            const result = parseEventDescription('varnm.second_level.method_call("argument1")');
            expect(result).toEqual({
                type: 'methodCallWithParams',
                variable: 'varnm',
                methodName:  'second_level.method_call',
                parameters: ['"argument1"']
            });
        });

        it('should parse an array pop', () => {
            const result = parseEventDescription('items.pop()');
            expect(result).toEqual({
                type: 'methodCall',
                variable: 'items',
                methodName: 'pop',
                parameters: []
            });
        });

        it('should throw an error for unsupported expression types', () => {
            expect(() => parseEventDescription('class A {}')).toThrow(/Unsupported expression type/);
        });
    });
});
