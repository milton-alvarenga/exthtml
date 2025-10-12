export default class Component {
    constructor(ast){
        this.reactive_vars = {}
        //??reactive_declaration => watches?
        this.vars = {}
    }


}


class Variable {
    constructor(){
        this.v = []
        this._declaration_type = ""
        //The variables that this reactive declaration depends on — when any of these change, the reactive declaration runs again
        this.dependsOn = new DependencyGroup()
        this.dependents = new DependencyGroup()
    }

    get declaration_type(){
        return this._declaration_type
    }

    set addValue(v){
        if (v != this.v[this.v.length-1]){
            this.v.push(v)
        }

    }

    set declaration_type(value){
        const allowedValues = ["var","let","export"]
        if (allowedValues.includes(value)) {
            this._declaration_type = value;
        } else {
            throw new Error(`Invalid value for variable: ${value}. Allowed values are ${allowedValues.join(", ")}`);
        }
    }
}

class DependencyGroup {
  constructor() {
    this.variable = [];
    this.components = [];
    this.directives = [];
    this.function = [];
  }
}