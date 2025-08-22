import { DependencyTree } from './variable.js';
import {emptyCssTree} from '../../parse/css/parser_css.js';

export function getStructure(){
    return {
        declared_variables: new Set(),
        declared_const: new Set(),
        undeclared_variables: new Set(),
        dependencyTree: new DependencyTree(),
        cssTree: emptyCssTree(),
        /*
        Function declarations using the function keyword (e.g., function changeOK() { ... })
        Function expressions (e.g., const fn = function() { ... })
        Arrow functions (e.g., const fn = () => { ... })
        */
        functions: new Set(),
        willChange: new Set(),
        willUseInTemplate: new Set(),
        reactiveDeclarations: {},
        scope:{},
        code: {
            internal_import: new Set(),
            component_arguments: new Set(),
            imports: [],
            shared_state: [],
            regular_state: [],
            dependencyTree: [],
            elems: [],
            reactives: [],
            create: [],
            mount: [],
            update: [],
            destroy: []
        }
    }
}