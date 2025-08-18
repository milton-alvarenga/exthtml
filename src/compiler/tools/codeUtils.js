export function escapeNewLine(variable){
    return variable.replace(/\n/g, '\\n')
}