function getById(id) {
    return document.getElementById(id)
}

function setAttr(elem, name, value) {
    if (!(elem instanceof Element)) {
        throw new Error('First argument must be a DOM Element')
    }
    if (typeof name !== 'string') {
        throw new Error('Attribute name must be a string')
    }
    if (value === null || value === undefined) {
        // Remove attribute if value is null or undefined
        return rmAttr(elem, name)
    } else {
        // Set or create attribute
        return elem.setAttribute(name, String(value))
    }
}



export function set_attributes(node, attributes) {
  const descriptors = Object.getOwnPropertyDescriptors(Object.getPrototypeOf(node));
  for (const key in attributes) {
    if (attributes[key] == null) {
      node.removeAttribute(key);
    } else if (key === 'style') {
      node.style.cssText = attributes[key];
    } else if (key === '__value') {
      node.value = node[key] = attributes[key];
    } else if (descriptors[key] && descriptors[key].set && ['width', 'height'].indexOf(key) === -1) {
      node[key] = attributes[key];
    } else {
      attr(node, key, attributes[key]);
    }
  }
}



export function attr(elem, attribute, value) {
	if (value == null) elem.removeAttribute(attribute);
	else if (elem.getAttribute(attribute) !== value) elem.setAttribute(attribute, value);
}

function rmAttr(elem, name) {
    return elem.removeAttribute(name);
}

function rmElem(elem) {
    return elem.parent.removeChild(elem)
}

function append(parent, elem) {
    return parent.appendChild(elem)
}

//create element
function el(tagName) {
    return document.createElement(tagName)
}

//create text element
function text(txt) {
    return document.createTextNode(txt)
}

function space() {
    return text(' ')
}

function empty() {
    return text('')
}

function comment(content){
    return document.createComment(content)
}

function getUniqueID() {

}

function detach(elem){
    if(elem.parentNode) {
		elem.parentNode.removeChild(elem)
    }
}

function init(){

}

function insert(parent, elem, child){
    parent.insertBefore(elem, child || null);
}

function noop(){

}

function listen(node,event,handler,options){
    node.addEventListener(event, handler, options);
    return () => node.removeEventListener(event, handler, options);
}

export function children(element) {
	return Array.from(element.childNodes);
}

export function object_without_properties(obj, exclude) {
  const target = {};
  for (const k in obj) {
    if (
      has_prop(obj, k) &&
      exclude.indexOf(k) === -1
    ) {
      target[k] = obj[k];
    }
  }
  return target;
}

export function svg_element(name) {
  return document.createElementNS('http://www.w3.org/2000/svg', name);
}

export function set_svg_attributes(elem, attributes) {
	for (const key in attributes) {
		attr(elem, key, attributes[key]);
	}
}


export function prevent_default(fn) {
    return function (event) {
        event.preventDefault();
        return fn.call(this, event);
    };
}

export function stop_propagation(fn) {
    return function (event) {
        event.stopPropagation();
        return fn.call(this, event);
    };
}

export function stop_immediate_propagation(fn) {
    return function (event) {
        event.stopImmediatePropagation();
        return fn.call(this, event);
    };
}

export function self(fn) {
	return function (event) {
		if (event.target === this) fn.call(this, event);
	};
}

export function trusted(fn) {
	return function (event) {
		if (event.isTrusted) fn.call(this, event);
	};
}

export function to_number(value) {
	return value === '' ? null : +value;
}

export function set_custom_element_data(elem, prop, value) {
	if (prop in elem) {
		elem[prop] = typeof elem[prop] === 'boolean' && value === '' ? true : value;
	} else {
		attr(elem, prop, value);
	}
}

function run_all(fns){
    fns.forEach(run);
}

export function run(fn) {
	return fn();
}

function safe_not_equal(){

}

function set_data(text, data){
	data = '' + data;
	if (text.data === data) return;
	text.data = data;
}

export function set_input_value(input, value) {
	input.value = value == null ? '' : value;
}

export function set_input_type(input, type) {
	try {
		input.type = type;
	} catch (e) {
		// do nothing
	}
}

export function set_style(node, key, value, important) {
	if (value == null) {
		node.style.removeProperty(key);
	} else {
		node.style.setProperty(key, value, important ? 'important' : '');
	}
}

export function select_option(select, value, mounting) {
	for (let i = 0; i < select.options.length; i += 1) {
		const option = select.options[i];

		if (option.__value === value) {
			option.selected = true;
			return;
		}
	}

	if (!mounting || value !== undefined) {
		select.selectedIndex = -1; // no option should be selected
	}
}

export function select_options(select, value) {
	for (let i = 0; i < select.options.length; i += 1) {
		const option = select.options[i];
		option.selected = ~value.indexOf(option.__value);
	}
}

export function select_value(select) {
	const selected_option = select.querySelector(':checked');
	return selected_option && selected_option.__value;
}

export function select_multiple_value(select) {
	return [].map.call(select.querySelectorAll(':checked'), option => option.__value);
}