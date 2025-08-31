function is_function(thing) {
	return typeof thing === 'function';
}

function is_empty(obj) {
	return Object.keys(obj).length === 0;
}

export function noop() {}

function blank_object() {
	return Object.create(null);
}