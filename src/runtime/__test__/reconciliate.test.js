import { jest } from "@jest/globals";
import {reconcile} from "../for.js";

function makeParent() {
  return {
    children: [],
    insertBefore(node, ref) {
      // remove node if already exists
      const idx = this.children.indexOf(node);
      if (idx !== -1) {
        this.children.splice(idx, 1);
      }

      // insert at new position
      const refIdx = ref ? this.children.indexOf(ref) : -1;
      // Insert node at the correct position
      if (refIdx === -1) {
        // No reference node, so append to the end
        this.children.push(node);
      } else {
        // Insert before the reference node
        this.children.splice(refIdx, 0, node);
      }
    },
    removeChild(node) {
      const idx = this.children.indexOf(node);
      if (idx !== -1) this.children.splice(idx, 1);
    }
  };
}


function makeNode(item) {
  return { id: item.id };
}

function getNode(item) {
  return item._node;
}

// FIXED: no parent.children.push() here!
function createNodeFactory(parent) {
  return function (item) {
    const node = makeNode(item);
    item._node = node;
    return node;
  };
}

function getKey(item) {
  return item.id;
}

describe("reconcile()", () => {
    
  test("append new items (old empty)", () => {
    const parent = makeParent();
    const oldItems = [];
    const newItems = [{ id: 1 }, { id: 2 }, { id: 3 }];

    const createNode = createNodeFactory(parent);

    reconcile(parent, oldItems, newItems, getKey, createNode, getNode);

    expect(parent.children.map(n => n.id)).toEqual([1, 2, 3]);
  });

  test("remove old items (new empty)", () => {
    const parent = makeParent();

    const oldItems = [{ id: 1 }, { id: 2 }];
    oldItems.forEach(item => (item._node = makeNode(item)));
    parent.children = oldItems.map(i => i._node);

    const newItems = [];
    const createNode = jest.fn();

    reconcile(parent, oldItems, newItems, getKey, createNode, getNode);

    expect(parent.children).toEqual([]);
  });

  test("move items (3 → 1 → 2)", () => {
    const parent = makeParent();

    const oldItems = [{ id: 1 }, { id: 2 }, { id: 3 }];
    oldItems.forEach(item => (item._node = makeNode(item)));
    parent.children = oldItems.map(i => i._node);

    const newItems = [{ id: 3 }, { id: 1 }, { id: 2 }];

    const createNode = jest.fn(); // should NOT be used

    reconcile(parent, oldItems, newItems, getKey, createNode, getNode);

    expect(parent.children.map(n => n.id)).toEqual([3, 1, 2]);
    expect(createNode).not.toHaveBeenCalled();

    // Additional check: Ensure the nodes are the same as in oldItems
    expect(parent.children[0]).toBe(oldItems[2]._node); // 3 should be reused
    expect(parent.children[1]).toBe(oldItems[0]._node); // 1 should be reused
    expect(parent.children[2]).toBe(oldItems[1]._node); // 2 should be reused
  });

  test("insert, move, remove mixed", () => {
    const parent = makeParent();

    const oldItems = [{ id: 1 }, { id: 2 }, { id: 3 }];
    oldItems.forEach(item => (item._node = makeNode(item)));
    parent.children = oldItems.map(i => i._node);

    const newItems = [{ id: 2 }, { id: 4 }, { id: 1 }];

    const createNode = createNodeFactory(parent);

    reconcile(parent, oldItems, newItems, getKey, createNode, getNode);

    expect(parent.children.map(n => n.id)).toEqual([2, 4, 1]);
    expect(parent.children.find(n => n.id === 3)).toBeUndefined();
  });

  test("common prefix + suffix fast paths", () => {
    const parent = makeParent();

    const oldItems = [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }];
    oldItems.forEach(item => (item._node = makeNode(item)));
    parent.children = oldItems.map(i => i._node);

    const newItems = [{ id: 1 }, { id: 2 }, { id: 5 }, { id: 4 }];

    const createNode = createNodeFactory(parent);

    reconcile(parent, oldItems, newItems, getKey, createNode, getNode);

    expect(parent.children.map(n => n.id)).toEqual([1, 2, 5, 4]);

    expect(parent.children[0]).toBe(oldItems[0]._node);
    expect(parent.children[1]).toBe(oldItems[1]._node);
    expect(parent.children[3]).toBe(oldItems[3]._node);
  });
});