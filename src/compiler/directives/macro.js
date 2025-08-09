import { addDirective } from './../internals/directive.js'
import {extract_relevant_js_parts_evaluated_to_string} from './../compiler_exthtml.js'

// Re-export addDirective for reuse
export { addDirective }


function idname(attr,mode,result,variableName,parent_nm) {

    result.code.internal_import.add("setAttr")
    
    if( mode == "STATIC") {
        result.code.create.push(`setAttr(${variableName}, 'id', '${attr.value}')`)
        result.code.create.push(`setAttr(${variableName}, 'name', '${attr.value}')`)
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
        result.code.update.push(`setAttr(${variableName}, 'id', ${attr.value})`)
        result.code.update.push(`setAttr(${variableName}, 'name', ${attr.value})`)
    }
}


export let directives = {
    idname
}