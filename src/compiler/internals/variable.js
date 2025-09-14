class DependencyGroup {
  constructor(
    variables,
    components,
    directives,
    functions,
    texts
  ) {
    variables = variables || [];
    components = components || [];
    directives = directives || [];
    functions = functions || [];
    texts = texts || [];

    this.variables = new Set(variables);
    this.components = new Set(components);
    this.directives = new Set(directives);
    this.functions = new Set(functions);
    this.texts = new Set(texts);
  }
}

class CssTree {
  constructor (
    idNames
  ){
    this.idNames = idNames || {}
  }

  get(varname) {
    if (!this.idNames[varname]) {
      this.idNames[varname] = varname;
    }

    return this.idNames[varname]
  }
}


export class DependencyTree {
  constructor(js = {}) {
    this.js = js;  // use the passed tree or empty object
    this.css = new CssTree();
  }

  get(varname) {
    if (!this.js[varname]) {
      this.js[varname] = new Variable()
    }

    /*
    const variable = this.js[varname]
    // The save method updates the js with the current variable value
    variable.save = () => {
      this.js[varname] = variable
    }
    return variable
    */

    return this.js[varname]
  }

  compile(dependencyTreeVarName) {
    dependencyTreeVarName = dependencyTreeVarName || '$$_depVar';
    let output = [];

    output.push(`$$_dependencyTree.css.idNames = ${JSON.stringify(this.css.idNames)}`)
    Object.keys(this.js).forEach(varname => {
      output.push(`${dependencyTreeVarName} = $$_dependencyTree.get('${varname}')`);
      output.push(`${dependencyTreeVarName}.declarationType = '${this.js[varname].declarationType}'`)
      output.push(`${dependencyTreeVarName}.recalculate = [${this.js[varname].recalculate.join(',')}]`)
      output.push(`${dependencyTreeVarName}.depOn(${JSON.stringify(Array.from(this.js[varname].dependsOn.variables))},[${Array.from(this.js[varname].dependsOn.components).join(',')}],[${Array.from(this.js[varname].dependsOn.directives).join(',')}],[${Array.from(this.js[varname].dependsOn.functions).join(',')}],[${Array.from(this.js[varname].dependsOn.texts).join(',')}])`)
      output.push(`${dependencyTreeVarName}.dep(${JSON.stringify(Array.from(this.js[varname].dependents.variables))},[${Array.from(this.js[varname].dependents.components).join(',')}],[${Array.from(this.js[varname].dependents.directives).join(',')}],[${Array.from(this.js[varname].dependents.functions).join(',')}],[${Array.from(this.js[varname].dependents.texts).join(',')}])`)
    });

    return output
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
    this.recalculate = []
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
    if (newValue !== this._v[this._v.length - 1]) {
      this._v.push(newValue)
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

  get dataType() {
    return this._dataType;
  }

  depOn(
    variables,
    components,
    directives,
    functions,
    texts
  ) {
    this.dependsOn = new DependencyGroup(
      variables,
      components,
      directives,
      functions,
      texts
    )
  }

  dep(
    variables,
    components,
    directives,
    functions,
    texts
  ) {
    this.dependents = new DependencyGroup(
      variables,
      components,
      directives,
      functions,
      texts
    )
  }
}
