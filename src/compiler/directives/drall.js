import { addDirective } from './../internals/directive.js'
import {extract_relevant_js_parts_evaluated_to_string} from './../compiler_exthtml.js'

// Re-export addDirective for reuse
export { addDirective }


function perm(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
    }
}

function permGroup(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
    }
}

function permMirror(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
    }
}

function permRedirect(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
    }
}

function val(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
    }
}

function mask(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
        extract_relevant_js_parts_evaluated_to_string(attr.value, result)
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