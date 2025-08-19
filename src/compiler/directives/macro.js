import { addDirective } from './../internals/directive.js'
import {extract_relevant_js_parts_evaluated_to_string} from './../compiler_exthtml.js'

// Re-export addDirective for reuse
export { addDirective }


function idname(attr,mode,result,variableName,node, parent_nm) {

    result.code.internal_import.add("setAttr")
    
    if( mode == "STATIC") {
        result.code.create.push(`setAttr(${variableName}, 'id', '${attr.value}')`)
        result.code.create.push(`setAttr(${variableName}, 'name', '${attr.value}')`)
    } else {
        let reactiveFnName = `${variableName}__idname`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        for (const v of usedVars) {
            let depVar = result.dependencyTree.get(v)
            depVar.dependents.directives.add(reactiveFnName)
            result.code.dependencyTree.push(`$$_depVar = $$_dependencyTree.get('${v}')`)
            result.code.dependencyTree.push(`$$_depVar.dependents.directives.add(${reactiveFnName})`)
        }
        result.code.reactives.push(`function ${reactiveFnName}(){\n
            setAttr(${variableName}, 'id', ${attr.value})\n
            setAttr(${variableName}, 'name', ${attr.value})\n
        }`)

        result.code.create.push(`${reactiveFnName}()`)
    }
}


export let directives = {
    idname
}