import { ElementOperations } from './operations/ElementOperations.js'


export class extHTMLElement {
    constructor(setup, exthtml, result, parent_nm){
        this.external = {
            setup,
            exthtml,
            result,
            parent_nm
        }
        this.variable_name_prefix = "";
        this.variable_name = "";
        this.scope = "USE_CURRENT_SCOPE";
        this.extHTMLElementChildren = [];
        this.ops = new ElementOperations();
    }

    getVariableName(){
        if (this.variable_name){
            return this.variable_name
        }
        this.variable_name = this.variable_name_prefix+this.getElemCounter()
    }

    getElemCounter(){
        return this.external.setup.elem_counter++
    }

    main(){
        switch (this.external.exthtml.type) {
            case 'DYNAMIC_TEXT_NODE':
                this.variable_name_prefix = "$$dyn_txt_";
                this.ops.dynText(this.external.exthtml.value)
            case 'TEXT_NODE':
                this.variable_name_prefix = "$$txt_";
                this.ops.text(this.external.exthtml.value)
            case 'TEXTAREA_TAG':
                this.variable_name_prefix = "$$textarea_";
                break
            case 'TITLE_TAG':
                this.variable_name_prefix = "$$title_";
                break
            case 'PLAINTEXT_TAG':
                this.variable_name_prefix = "$$plaintext_";
                break
            case 'HTML_NESTED_TAG':
            case 'SELF_CLOSE_TAG':
                this.variable_name_prefix = `$$${this.external.exthtml.value.toLowerCase()}_`
                break
            case 'COMPONENT':
                this.scope = "NEW_ISOLATED_SCOPE";
                break
            default:
                throw Error(`${traverseExthtml.name} Error on unexpected type equal ${exthtml.type} and value ${exthtml.value} at line ${exthtml.location.line}`)
        }

        this.ops.el(exthtml.value);
        this.ops.append(this.external.parent_nm);
        this.ops.detach();

        /*
        //Recursive call
        this.exthtml.children.forEach(node => traverseExthtml(node, result, variableName, parent_nm))
        */
    }

    mount(){
        this.ops.exec()
        switch(this.scope){
            case "USE_CURRENT_SCOPE":
                this.mountOnCurrentScope();
            break;
            case "NEW_ISOLATED_SCOPE":
                this.mountAsNewScope();
            break;
            case "BLOCK_SCOPE":
                this.mountAsBlock();
            break;
            default:
        }
        
/*
//Check any type selector on css
if (
    this.exthtml.result.cssTree.typeSelector.hasOwnProperty(this.exthtml.value.toLowerCase())
){
    // Static class attribute for css type selector : set once on create
    result.code.create.push(`${variableName}.classList.add('${this.result.cssTree.typeSelector[exthtml.value.toLowerCase()]}')`)
}

//Check universal selector
if(this.result.cssTree.typeSelector.hasOwnProperty('*')){
    // Static class attribute for css type selector : set once on create
    result.code.create.push(`${variableName}.classList.add('${this.result.cssTree.typeSelector['*']}')`)
}

*/
    }

    mountOnCurrentScope(){
        //Regular mode

        let obj1 = this.external.result;
        let obj2 = this.ops.code()
        const keys = new Set([...Object.keys(obj1), ...Object.keys(obj2)]);


        keys.forEach(key => {
            const val1 = obj1[key];
            const val2 = obj2[key];

            if (val1 instanceof Set && val2 instanceof Set) {
                // Merge sets by combining their elements
                this.external.result[key] = new Set([...val1, ...val2]);
            } else if (Array.isArray(val1) && Array.isArray(val2)) {
                // Merge arrays by concatenation
                this.external.result[key] = [...val1, ...val2];
            } else {
                // If property exists only in one object or are primitive, take val2 if defined, else val1
                this.external.result[key] = val2 !== undefined ? val2 : val1;
            }
        });

    }

    //if
    //for (just add new alias to the own namespace)
    mountAsBlock(){
        //Detected during attribute parse
        this.external.result
    }

    //Component
    //Complete new scope
    mountAsNewScope(){
        //First thing to be detected
        this.external.result
    }
}