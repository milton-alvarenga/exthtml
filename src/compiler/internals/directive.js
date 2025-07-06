// Function to add new directives dynamically
export function addDirective(name, fn) {
  if (typeof name !== "string" || typeof fn !== "function") {
    throw new Error("Invalid arguments for addDirective: expected (string, function)");
  }
  if (directives[name]) {
    console.warn(`Directive '${name}' already exists and will be overwritten.`);
  }
  directives[name] = fn;
}