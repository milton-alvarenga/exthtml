// Function to add new custom attribute dynamically
export function addCustomAttribute(name, fn) {
  if (typeof name !== "string" || typeof fn !== "function") {
    throw new Error("Invalid arguments for addCustomAttribute: expected (string, function)");
  }
  if (customAttributes[name]) {
    console.warn(`addCustomAttribute '${name}' already exists and will be overwritten.`);
  }
  customAttributes[name] = fn;
}