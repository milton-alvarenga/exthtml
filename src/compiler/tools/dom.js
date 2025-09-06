export function insert(target, node, anchor) {
	target.insertBefore(node, anchor || null);
}

function byId(id){
    return document.getElementById(id)
}

export function setAttr(elem, name, value) {
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

export function rmAttr(elem,name){
    return elem.removeAttribute(name);
}

function rmElem(elem){
    return elem.parent.removeChild(elem)
}

export function append(parent,elem){
    parent.appendChild(elem)
}

function el(tagName){
    return document.createElement(tagName)
}

function text(txt){
    return document.createTextNode(txt)
}

function getUniqueID(){
    
}

function detach(node) {
	if (node.parentNode) {
		node.parentNode.removeChild(node);
	}
}

function svg_element(name) {
	return document.createElementNS('http://www.w3.org/2000/svg', name);
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

function listen(node, event, handler, options) {
	node.addEventListener(event, handler, options);
	return () => node.removeEventListener(event, handler, options);
}

function prevent_default(fn) {
	return function (event) {
		event.preventDefault();
		return fn.call(this, event);
	};
}

function stop_propagation(fn) {
	return function (event) {
		event.stopPropagation();
		return fn.call(this, event);
	};
}

function stop_immediate_propagation(fn) {
	return function (event) {
		event.stopImmediatePropagation();
		return fn.call(this, event);
	};
}

/**
 * List of attributes that should always be set through the attr method,
 * because updating them through the property setter doesn't work reliably.
 * In the example of `width`/`height`, the problem is that the setter only
 * accepts numeric values, but the attribute can also be set to a string like `50%`.
 * If this list becomes too big, rethink this approach.
 */
const always_set_through_set_attribute = ['width', 'height'];

function set_attributes(node, attributes) {
	const descriptors = Object.getOwnPropertyDescriptors(node.__proto__);
	for (const key in attributes) {
		if (attributes[key] == null) {
			node.removeAttribute(key);
		} else if (key === 'style') {
			node.style.cssText = attributes[key];
		} else if (key === '__value') {
			(node ).value = node[key] = attributes[key];
		} else if (descriptors[key] && descriptors[key].set && always_set_through_set_attribute.indexOf(key) === -1) {
			node[key] = attributes[key];
		} else {
			attr(node, key, attributes[key]);
		}
	}
}

function set_svg_attributes(node, attributes) {
	for (const key in attributes) {
		attr(node, key, attributes[key]);
	}
}

function add_location(element, file, line, column, char) {
	element.__exthtml_meta = {
		loc: { file, line, column, char }
	};
}

export function addCssLinkOnHead(css_fullpath) {
  // Check if a link element with the same href already exists in the head
  const exists = Array.from(document.head.querySelectorAll('link[rel="stylesheet"]'))
    .some(link => link.getAttribute('href') === css_fullpath);

  if (!exists) {
    // Create new link element
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = css_fullpath;

    // Append to head
    document.head.appendChild(link);
  }
}