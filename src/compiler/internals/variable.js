class DependencyGroup {
  constructor() {
    this.variables = new Set();
    this.components = new Set();
    this.directives = new Set();
    this.functions = new Set();
  }
}

class Variable {
  constructor(initialValue = undefined) {
    this.v = initialValue === undefined ? [] : [initialValue];
    this._declarationType = ""; // var, let, export, etc.
    this.dependsOn = new DependencyGroup();
    this.dependents = new DependencyGroup();
  }

  get declarationType() {
    return this._declarationType;
  }

  set declarationType(value) {
    const allowedValues = ["var", "let", "export", "const"];
    if (allowedValues.includes(value)) {
      this._declarationType = value;
    } else {
      throw new Error(
        `Invalid value for declarationType: ${value}. Allowed values are ${allowedValues.join(
          ", "
        )}`
      );
    }
  }

  // Add a new value only if different from the latest
  set v(newValue) {
    if (newValue !== this.v[this.v.length - 1]) {
      this.v.push(newValue);
    }
  }

  // Get the current/latest value
  get v() {
    return this.v[this.v.length - 1];
  }
}
