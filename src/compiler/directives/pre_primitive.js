import { addDirective } from './../internals/directive.js'
import {create_node} from './../internals/ast_exthtml.js'
import {extract_relevant_js_parts_evaluated_to_string} from './../compiler_exthtml.js'

// Re-export addDirective for reuse
export { addDirective }


function createVirtualNode(attr, node, parent_elem, parent_pos) {
    let new_node = create_node();
    new_node.section = 'VirtualExtHTMLElem';
    new_node.type = 'Virtual' + attr.name.toUpperCase();
    new_node.value = attr.value;

    // Remove the attribute from original node's dynamic attributes
    node.dynamic_attrs.splice(attr.pos, 1);

    // Make the current node a child of the new virtual node
    new_node.children.push(node);

    // Replace current node in parent's children with new virtual node
    parent_elem[parent_pos] = new_node;
}

function _if(attr, mode, result, variableName, node, parent_nm, parent_elem, parent_pos) {
    createVirtualNode(attr, node, parent_elem, parent_pos);
}

function _for(attr, mode, result, variableName, node, parent_nm, parent_elem, parent_pos) {
    createVirtualNode(attr, node, parent_elem, parent_pos);
}


export let directives = {
    "if":_if,
    "for":_for
}