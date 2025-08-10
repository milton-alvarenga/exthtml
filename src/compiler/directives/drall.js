import { addDirective } from './../internals/directive.js'
import {extract_relevant_js_parts_evaluated_to_string} from './../compiler_exthtml.js'

// Re-export addDirective for reuse
export { addDirective }


function perm(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        reactiveFnName = `${variableName}__perm`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        for (const v of usedVars) {
            let depVar = result.dependencyTree.get(v)
            depVar.dependents.directives.add(reactiveFnName)
            result.dependencyTree[v] = depVar;
        }
        result.code.reactives.push(`function ${reactiveFnName}(){\n
            //@TODO
        }`)
    }
}

function permGroup(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        reactiveFnName = `${variableName}__perm`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        for (const v of usedVars) {
            let depVar = result.dependencyTree.get(v)
            depVar.dependents.directives.add(reactiveFnName)
            result.dependencyTree[v] = depVar;
        }
        result.code.reactives.push(`function ${reactiveFnName}(){\n
            //@TODO
        }`)
    }
}

function permMirror(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        reactiveFnName = `${variableName}__perm`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        for (const v of usedVars) {
            let depVar = result.dependencyTree.get(v)
            depVar.dependents.directives.add(reactiveFnName)
            result.dependencyTree[v] = depVar;
        }
        result.code.reactives.push(`function ${reactiveFnName}(){\n
            //@TODO
        }`)
    }
}

function permRedirect(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        reactiveFnName = `${variableName}__perm`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        for (const v of usedVars) {
            let depVar = result.dependencyTree.get(v)
            depVar.dependents.directives.add(reactiveFnName)
            result.dependencyTree[v] = depVar;
        }
        result.code.reactives.push(`function ${reactiveFnName}(){\n
            //@TODO
        }`)
    }
}

function val(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        reactiveFnName = `${variableName}__perm`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        for (const v of usedVars) {
            let depVar = result.dependencyTree.get(v)
            depVar.dependents.directives.add(reactiveFnName)
            result.dependencyTree[v] = depVar;
        }
        result.code.reactives.push(`function ${reactiveFnName}(){\n
            //@TODO
        }`)
    }
}

function mask(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        reactiveFnName = `${variableName}__perm`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        for (const v of usedVars) {
            let depVar = result.dependencyTree.get(v)
            depVar.dependents.directives.add(reactiveFnName)
            result.dependencyTree[v] = depVar;
        }
        result.code.reactives.push(`function ${reactiveFnName}(){\n
            //@TODO
        }`)
    }
}



export let directives = {
    perm,
    "perm-group":permGroup,
    "perm-mirror":permMirror,
    "perm-redirect":permRedirect,
    val,
    mask
}