import {Var} from './var.js'

//based on 
// https://www.perplexity.ai/search/what-is-the-best-method-on-mod-e4qA9bJETdSeXK7FtBsNQQ
// and
// https://vuejs.org/guide/extras/reactivity-in-depth
// and
// https://github.com/themarcba/vue-reactivity/blob/main/reactivity.js
// Special thanks to Perplexity.ai.

let activeEffect = null
let targetMap = new WeakMap()

// Register an effect
function track(target, key) {
    // Get depsMap from targetMap
    let depsMap = targetMap.get(target)
    if (!depsMap) {
        // new depsMap if it doesn't exist yet
        depsMap = new Map()
        targetMap.set(target, depsMap)
    }

    // Get dep from depsMap
    let dep = depsMap.get(key)
    if (!dep) {
        // new dep if it doesn't exist yet
        dep = new Set()
        depsMap.set(key, dep)
    }

    // Add effect
    if (activeEffect) dep.add(activeEffect)
}

// Execute all registered effects for the target/key combination
function trigger(target, key) {
    // Get depsMap from targetMap
    let depsMap = targetMap.get(target)
    if (!depsMap) {
        // If there is no depsMap, no need to resume
        return
    }

    // Get dep from depsMap
    let dep = depsMap.get(key)
    if (!dep) {
        // If there is no dep, no need to resume
        return
    }

    // Execute all effects
    dep.forEach(effect => effect())
}

// Makes an object "reactive". Changes will be triggered, once the property is tracked
function reactive(target) {
    if (typeof target !== 'object' || target === null) {
        return target
    }
    const handler = {
        get(target, key, receiver) {
            const result = Reflect.get(target, key, receiver)
            track(target, key) //track changes for the key in the target
            // Make nested objects reactive
            return typeof result === 'object' ? reactive(result) : result
        },
        set(target, key, value, receiver) {
            const result = Reflect.set(target, key, value, receiver)
            trigger(target, key) // trigger a change in the target
            return result
        },
    }
    return new Proxy(target, handler)
}


// Watcher
function effect(fn) {
    activeEffect = fn
    // Only execute when there is an activeEffect
    if (activeEffect) activeEffect()
    activeEffect = null
}

// The ref class is a reactive object with a single value (called "value")
function ref(raw) {
    let r = {
        // Intercept getter
        get value() {
            track(r, 'value')
            return raw
        },
        // Intercept setter
        set value(newValue) {
            raw = newValue
            trigger(r, 'value')
        },
    }
    return r
}

function react(any) {
    // Check if input is an array or plain object
    if (Array.isArray(any) || (any !== null && typeof any === 'object')) {
        return reactive(any);
    } else {
        // For primitive values or refs, return a ref
        return ref(any);
    }
}

// Computed property
function computed(getter) {
    let result = ref()
    effect(() => {
        result.value = getter()
    })
}