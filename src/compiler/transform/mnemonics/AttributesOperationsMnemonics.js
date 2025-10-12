class AttributesOperationsMnemonics {
    constructor(result) {
        this._variableName;
        this.operations = [];
        // Pass in the structure used by ElementOperations to modify code
        this.result = result; 
    }

    set variableName(variableName) {
        this._variableName = variableName;
    }

    // Internal implementations of attribute operations
    setAttribute(attrName, attrValue) {
        // Import any utility function if needed
        this.result.code.internal_import.add("setAttr");
        // Add code to set attribute statically during creation or update phase
        this.result.code.create.push(
            `$$_setAttr(${this._variableName}, '${attrName}', '${attrValue}')`
        );
    }

    removeAttribute(attrName) {
        this.result.code.internal_import.add("rmAttr");
        this.result.code.update.push(
            `$$_rmAttr(${this._variableName}, '${attrName}')`
        );
    }

    dynamicAttribute(attrName, valueExpression) {
        this.result.code.internal_import.add("setAttr");
        this.result.code.reactives.push(
            `function ${this._variableName}__attr_${attrName}(){ $$_setAttr(${this._variableName}, '${attrName}', ${valueExpression}) }\n`
        );
        // Here you could also add dependency tracking similar to _dynText in ElementOperations if needed
    }

    exec(variableName) {
        this.variableName(variableName)
        if (!this._variableName) {
            throw new Error("AttributesOperation error on exec. No variable name");
        }
        this.operations.forEach(mnemonic => {
            const op = mnemonic.shift();
            this[op](...mnemonic);
        });
    }
}
