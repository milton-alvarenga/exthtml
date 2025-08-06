import {track,trigger} from './reactive.js'

class Var {
    constructor(name, value) {
        this.name = name;
        this._value = value;
    }

    get value() {
        track('primary',this.name)
        return this._value;
    }

    set value(val) {
        trigger('primary',this.name)
        this._value = val;
    }

    toString() {
        return this._value;
    }

    valueOf() {
        return this._value;
    }
}
