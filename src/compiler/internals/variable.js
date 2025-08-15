class DependencyGroup {
  constructor() {
    this.variables = new Set();
    this.components = new Set();
    this.directives = new Set();
    this.functions = new Set();
    this.texts = new Set();
  }
}


export class DependencyTree {
  constructor(tree = {}) {
    this.tree = tree;  // use the passed tree or empty object
  }

  get(varname) {
    if (!this.tree[varname]) {
      this.tree[varname] = new Variable()
    }

    /*
    const variable = this.tree[varname]
    // The save method updates the tree with the current variable value
    variable.save = () => {
      this.tree[varname] = variable
    }
    return variable
    */

    return this.tree[varname]
  }
}


/*
export function addDependency(dependent, dependsOn) {
  if (!dependencyGraph[dependent]) {
    dependencyGraph[dependent] = new Set();
  }
  dependencyGraph[dependent].add(dependsOn);
}
*/


class Variable {
  constructor(initialValue = undefined) {
    this._v = initialValue === undefined ? [] : [initialValue]
    this._declarationType = "" // var, let, export, etc.
    this._dataType = ""
    this.dependsOn = new DependencyGroup()
    this.dependents = new DependencyGroup()
  }

  get declarationType() {
    return this._declarationType
  }

  set declarationType(value) {
    const allowedValues = ["var", "let", "export", "const"];
    if (allowedValues.includes(value)) {
      this._declarationType = value
    } else {
      throw new Error(
        `Invalid value for declarationType: ${value}. Allowed values are ${allowedValues.join(
          ", "
        )}`
      )
    }
  }

  // Add a new value only if different from the latest
  set v(newValue) {
    if (newValue !== this._v[this.v.length - 1]) {
      this.v.push(newValue)
    }
  }

  // Get the current/latest value
  get v() {
    return this._v[this._v.length - 1]
  }

  set dataType(newValue) {
    if (this._dataType == "" && newValue !== this._dataType) {
      this._dataType = newValue
    }
  }

  get dataType(){
    return this._dataType;
  }
}
