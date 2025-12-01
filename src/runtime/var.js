/*
//Example of how to use
const data = {
  a: 1,
  arr: [1, 2, {x: 5}],
  nested: { b: 2 }
};

const proxiedData = buildProxy(data, (change) => {
  console.log('Change detected:', change);
});

// Setting a property on root object
proxiedData.a = 10;

// Setting nested object property
proxiedData.nested.b = 20;

// Modifying an array element
proxiedData.arr[0] = 100;

// Using array mutating method
proxiedData.arr.push(200);

// Modifying deeply nested object inside array
proxiedData.arr[2].x = 50;
*/

export function buildProxy(obj, callback, path = []) {
  if (!isObjectOrArray(obj)) {
    // primitive, no need to proxy
    return obj;
  }
  
  const arrayMutations = ['push', 'pop', 'shift', 'unshift', 'splice', 'sort', 'reverse'];

  const handler = {
    get(target, prop, receiver) {
      const value = Reflect.get(target, prop, receiver);

      if (typeof value === 'function' && Array.isArray(target) && arrayMutations.includes(prop)) {
        // Wrap array mutator methods to catch changes
        return function(...args) {
          const oldLength = target.length;
          const result = value.apply(target, args);

          // Callback on mutation - you can customize this info as you like
          callback({
            action: 'array-' + prop,
            path: path.join('.'),
            arguments: args,
            oldLength: oldLength,
            newLength: target.length,
            target: target
          });
          return result;
        };
      }

      if (isObjectOrArray(value)) {
        // Recursively wrap nested object/array
        return buildProxy(value, callback, path.concat(prop));
      }

      return value;
    },

    set(target, prop, value, receiver) {
      const oldValue = target[prop];
      const success = Reflect.set(target, prop, value, receiver);
      if (success) {
        const fullPath = path.concat(prop).join('.');
        callback({
          action: 'set',
          path: fullPath,
          oldValue,
          newValue: value,
          target: target
        });
      }
      return success;
    },

    deleteProperty(target, prop) {
      if (prop in target) {
        const oldValue = target[prop];
        const fullPath = path.concat(prop).join('.');
        const success = Reflect.deleteProperty(target, prop);
        if (success) {
          callback({
            action: 'delete',
            path: fullPath,
            oldValue,
            target: target
          });
          return true;
        }
        return false;
      }
      return true; // property didn't exist anyway
    }
  };

  return new Proxy(obj, handler);
}

function isObjectOrArray(value) {
  return value !== null && (typeof value === 'object');
}





/*
import {track,trigger} from './reactive.js'

class Var {
    constructor(name, value) {
        this.name = name;
        this._value = value;
    }

    get value() {
        //track('$$__view',this.name)
        return this._value;
    }

    set value(val) {
        //trigger('$$__view',this.name)
        console.log(this.name)
        this._value = val;
    }

    toString() {
        return this._value;
    }

    valueOf() {
        return this._value;
    }
}

function buildProxy(obj, callback, path = []) {
  const handler = {
    set(target, prop, value) {
      const fullPath = path.concat(prop).join('.');
      const oldValue = target[prop];
      callback({
        action: 'set',
        path: fullPath,
        oldValue,
        newValue: value,
      });
      return Reflect.set(target, prop, value);
    },
    get(target, prop) {
      const value = Reflect.get(target, prop);
      if (value && typeof value === 'object') {
        // Wrap nested object/array in Proxy as well
        return buildProxy(value, callback, path.concat(prop));
      }
      return value;
    }
  };
  return new Proxy(obj, handler);
}

function isArray(value) {
  return Array.isArray(value);
}
*/