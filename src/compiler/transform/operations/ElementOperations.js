import {ElementOperationsMnemonics} from "../mnemonics/ElementOperationsMnemonics.js"


export class ElementOperations {
    constructor() {
        this.ElementOperationsMnemonics = new ElementOperationsMnemonics()
    }

    set variableName(variableName) {
        this.ElementOperationsMnemonics.variableName = variableName
    }

    append(parent_nm) {
        this.ElementOperationsMnemonics.operations.push(['append', parent_nm]);
    }

    el(str_elem) {
        this.ElementOperationsMnemonics.operations.push(['el', str_elem.toLowerCase()]);
    }

    detach() {
        this.ElementOperationsMnemonics.operations.push(['detach']);
    }

    dynText(txt,result) {
        this.ElementOperationsMnemonics.operations.push(['dynText', txt, result])
    }

    text(txt) {
        this.ElementOperationsMnemonics.operations.push(['text', txt])
    }

    exec() {
        this.ElementOperationsMnemonics.exec()
    }

    code() {
        return this.ElementOperationsMnemonics.result.code
    }
}
