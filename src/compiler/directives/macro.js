import { addDirective } from './../internals/directive.js'

// Re-export addDirective for reuse
export { addDirective }


function idname(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
        result.code.create.push(`setAttr('${variableName}', 'id', '${attr.value}')`)
        result.code.create.push(`setAttr('${variableName}', 'name', '${attr.value}')`)
    } else {
        result.code.update.push(`setAttr('${variableName}', 'id', ${attr.value})`)
        result.code.update.push(`setAttr('${variableName}', 'name', ${attr.value})`)
    }
}


export let directives = {
    idname
}