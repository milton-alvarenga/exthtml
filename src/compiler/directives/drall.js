import { addDirective } from './../internals/directive.js'

// Re-export addDirective for reuse
export { addDirective }


function perm(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
    }
}

function permGroup(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
    }
}

function permMirror(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
    }
}

function permRedirect(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
    }
}

function val(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
    }
}

function mask(attr,mode,result,variableName,parent_nm) {
    if( mode == "STATIC") {
    } else {
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