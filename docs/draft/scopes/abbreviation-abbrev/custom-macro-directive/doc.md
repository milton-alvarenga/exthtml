# How to create a custom Macro Directive (abbreviation-abbrev)

To create a function to be used as new Macro Directives by your project, the extHTML created a **dynamically way to add new directives** to the exported `directives` object from Macro Directire file, similar to how Vue allows adding components via `Vue.component()`. 

The current setup exports a `directives` object with all standard extHTML macro directives.

## How to do it

### Step 1: Create some directive file in your project

```js
// newDirective.js
import { addDirective } from "./directives/macro.js";


function myNewDirective(attr, mode, result, variableName, parent_nm) {
  // Your directive logic here
  if (mode === "STATIC") {
    result.code.create.push(`console.log('Static mode for ${variableName}')`);
  } else {
    result.code.update.push(`console.log('Update mode for ${variableName}')`);
  }
}

// Register the new directive
addDirective('mydirectivename', myNewDirective);
```


### Step 2: Using directives later in your app

```extHTML
<script>
function execEvent(){
    console.log("I am working");
}
</script>
<input type="text" (mydirectivename) />
<button (mydirectivename) @click={execEvent}>Click me</button>
```

### Step 3: On bash, compile your project
```bash
node execute_compiler.js
```


## Summary
- Create your directive file
- Import `addDirective` from "./directives/macro.js"
- Register new directives
- The `directives` object stays updated and can be used anywhere in your project