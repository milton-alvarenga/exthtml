export function once(fn) {
	let ran = false;
	return function( ...args) {
		if (ran) return;
		ran = true;
		fn.call(this, ...args);
	};
}

export function null_to_empty(value) {
	return value == null ? '' : value;
}
