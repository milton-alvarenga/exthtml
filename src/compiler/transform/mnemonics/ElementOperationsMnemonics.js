import { getStructure } from '../../internals/analyze.js'

export class ElementOperationsMnemonics {
    constructor(){
        this.operations = [];
        this.result = getStructure();
        this._variableName = "";
    }

    set variableName(variableName) {
        this._variableName = variableName
    }

    // Actual implementations of operations
    append(parent_nm) {
        this.result.code.internal_import.add("append");
        this.result.code.mount.push(`$$_append(${parent_nm},${this._variableName})`);
    }

    el(str_elem) {
        this.result.code.internal_import.add("el");
        this.result.code.elems.push(this._variableName);
        this.result.code.create.push(`${this._variableName} = $$_el('${str_elem}')`);
    }

    detach() {
        this.result.code.internal_import.add("detach");
        this.result.code.destroy.push(`$$_detach(${this._variableName})`);
    }

    dynText(txt, result) {
        this.text(txt)
        reactiveFnName = `${this._variableName}__textContent`
        let usedVars = extract_relevant_js_parts_evaluated_to_string(txt, result)
        for (const v of usedVars) {
            let depVar = this.result.dependencyTree.get(v)
            depVar.dependents.texts.add(reactiveFnName)
        }
        this.result.code.reactives.push(`function ${reactiveFnName}(){${this._variableName}.textContent = ${txt}}\n`)
    }

    text(txt) {
        this.result.code.internal_import.add("text")
        this.result.code.internal_import.add("append");
        this.result.code.internal_import.add("detach");
        this.result.code.elems.push(variableName)
        this.result.code.create.push(`${this._variableName} = $$_text('${codeUtils.escapeNewLine(txt)}')`)
    }

    exec() {
        if (!this._variableName) {
            throw new Error("ElementOperationMnemonics error on exec. No variable name")
        }
        this.operations.forEach(mnemonic => {
            const op = mnemonic.shift();
            this[op](...mnemonic);
        });
    }
}