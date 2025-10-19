import { addDirective } from './../internals/directive.js'
import {extract_relevant_js_parts_evaluated_to_string} from './../compiler_exthtml.js'

// Re-export addDirective for reuse
export { addDirective }


function _if(attr,mode,result,variableName,node,parent_nm) {
    /*
    if( mode == "STATIC") {
    } else {
        reactiveFnName = `${variableName}__if`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        for (const v of usedVars) {
            let depVar = result.dependencyTree.get(v)
            depVar.dependents.directives.add(reactiveFnName)
        }
        result.code.reactives.push(`function ${reactiveFnName}(){\n
            //@TODO
        }`)
    }
    */
}

function _for(attr,mode,result,variableName,node,parent_nm){

}



export let directives = {
    "if":_if,
    "for":_for
}