const elOps = new ElementOperations("divElem");
const attrsOps = new AttributesOperations(elOps._variableName, elOps.result);

// Append some attribute operations
attrsOps.setAttribute("class", "my-class");
attrsOps.dynamicAttribute("data-value", "someDynamicJSValue");

// Later execute both sets of operations
elOps.exec();
attrsOps.exec();

import { getStructure } from "../../internals/analyze.js";
import {AttributesOperationsMnemonics} from "../mnemonics/AttributesOperationsMnemonics.js"

class AttributesOperations {
    constructor() {
        // Pass in the structure used by ElementOperations to modify code
        this.result = getStructure();
        this.AttributesOperationsMnemonics = new AttributesOperationsMnemonics(result)
    }

    set variableName(variableName) {
        this.AttributesOperationsMnemonics.variableName = variableName
    }

    // Add attribute or update attribute value
    setAttribute(attrName, attrValue) {
        this.operations.push(['setAttribute', attrName, attrValue]);
    }

    setDataAttribute(attrName, attrValue) {
        this.operations.push(['setDataAttribute', attrName, attrValue]);
    }

    // Remove an attribute
    removeAttribute(attrName) {
        this.operations.push(['removeAttribute', attrName]);
    }

    // Set attribute with a dynamic value expression
    dynamicAttribute(attrName, valueExpression) {
        this.operations.push(['dynamicAttribute', attrName, valueExpression]);
    }

    exec() {
        this.AttributesOperationsMnemonics.exec()
    }
}
