import { buildProxy } from "./var"; 

const PRIMITIVE = 'primitive'
const REFERENCE = 'reference'

//Primitive types represent single, immutable values.
//Non-primitive types are objects which can store collections and more complex entities


/*
Primitive Type
Number: Numeric values (both integers and decimals)
String: Text values enclosed in quotes
Boolean: Logical values true or false
Undefined: A variable declared but not assigned a value
Null: Represents an intentional absence of value
Symbol: Unique, immutable values often used as keys in objects
BigInt: Represents integers larger than the Number type can safely represent
*/


/*
Reference Type
Object: A collection of key-value pairs
Array: An ordered list of values
Function: Blocks of code that can be reused
*/
function getType(value) {
  const primitiveTypes = ['string', 'number', 'boolean', 'undefined', 'bigint', 'symbol'];

  if (value === null) {
    return PRIMITIVE;  // null is considered a primitive type
  }

  if (primitiveTypes.includes(typeof value)) {
    return PRIMITIVE;
  }

  // Everything else is a reference type (object, function)
  return REFERENCE;
}

function r(nm, value, $$_changes){
  if ( getType(value) ==  PRIMITIVE ) {
    return value
  }

  return buildProxy(value, (change) => track(change,nm, $$_changes))
}

function setReactive(nm, value, dependencyTree,$$_changes){
  let depVar = dependencyTree.get(nm)
  depVar.dataType = getType(value)
  if( depVar.dataType == PRIMITIVE ){
    depVar.v = value
    return
  }
  depVar.v = buildProxy(value, (change) => track(change,nm, $$_changes))
}

function checkReactive(nm,value,dependencyTree,$$changes){
  let depVar = dependencyTree.get(nm)

  if( depVar.dataType == PRIMITIVE && depVar.v != value){
    depVar.v = value
    $$changes.add(nm)
  }
}

function track(change, nm, $$_changes){
  $$_changes(nm)

  console.log("function track: ",change)
}