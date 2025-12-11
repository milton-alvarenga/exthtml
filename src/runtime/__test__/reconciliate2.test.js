import { jest } from '@jest/globals';
import {reconcileReactive} from "../for2.js";

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

function getKey(item) {
    return item.id;
}

// `getNode` is not used by reconcileReactive
// function getNode(item) {
//   return item._node;
// }

// FIXED: no parent.children.push() here!
function createNodeFactory() { // parent is not strictly needed here
  return jest.fn(item => {
    const node = makeNode(item);
    return { node, dispose: jest.fn() };
  });
}
// Helper functions for primitive arrays (strings, numbers)
function makePrimitiveNode(item) {
  return { id: item }; // Use item itself as ID for testing assertions
}

function createPrimitiveNodeFactory() { // Parent is not strictly needed for primitive node creation
    return jest.fn(item => {
        const node = makePrimitiveNode(item);
        return { node, dispose: jest.fn() };
    });
}

function getPrimitiveKey(item) {
  return item;
}

// New helper functions for mixed arrays
function getMixedKey(item) {
  if (typeof item === 'object' && item !== null && 'id' in item) {
    return item.id;
  }
  return item; // Primitive type
}

function makeMixedNode(item) {
  if (typeof item === 'object' && item !== null && 'id' in item) {
    return { id: item.id };
  }
  return { id: item }; // Primitive type
}

function createMixedNodeFactory() {
  return jest.fn(item => {
    const node = makeMixedNode(item);
    return { node, dispose: jest.fn() };
  });
}


describe("reconcileReactive()", () => {
    
  test("append new items (old empty)", () => {
    
    const parent = makeParent();

    const oldItems = []; // reconcileReactive expects structured oldList, but empty is fine
    const newItems = [{ id: 1 }, { id: 2 }, { id: 3 }];

    const createNode = createNodeFactory(); // Adapted to return {node, dispose}

    const result = reconcileReactive(parent, oldItems, newItems, getKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual([1, 2, 3]);
    expect(result.map(r => r.key)).toEqual([1, 2, 3]);
    expect(result.map(r => r.node.id)).toEqual([1, 2, 3]);
  });

  test("remove old items (new empty)", () => {
    const parent = makeParent();

    const initialOldItems = [{ id: 1 }, { id: 2 }];
    const createNode = createNodeFactory(); // To get nodes for initial setup

    // Manually create the structured oldList that reconcileReactive expects
    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node); // Manually populate parent children
      return { key: getKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = [];
    
    const result = reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);

    expect(parent.children).toEqual([]);
    expect(result).toEqual([]);
    structuredOldItems.forEach(item => expect(item.dispose).toHaveBeenCalled()); // Ensure dispose was called
  });

  test("move items (3 → 1 → 2)", () => {
    const parent = makeParent();

    const initialOldItems = [{ id: 1 }, { id: 2 }, { id: 3 }];
    const createNode = createNodeFactory();

    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node);
      return { key: getKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = [{ id: 3 }, { id: 1 }, { id: 2 }];
    createNode.mockClear(); // Clear mock calls before reconcile

    const result = reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual([3, 1, 2]);
    expect(createNode).not.toHaveBeenCalled(); // should NOT be used for new items

    // Additional check: Ensure the nodes are the same as in oldItems
    // Compare directly with the node references from structuredOldItems
    expect(parent.children[0]).toBe(structuredOldItems[2].node); // 3 should be reused
    expect(parent.children[1]).toBe(structuredOldItems[0].node); // 1 should be reused
    expect(parent.children[2]).toBe(structuredOldItems[1].node); // 2 should be reused
    
    // Ensure dispose was not called for reused items
    structuredOldItems.forEach(item => expect(item.dispose).not.toHaveBeenCalled());
  });

  test("insert, move, remove mixed", () => {
    const parent = makeParent();

    const initialOldItems = [{ id: 1 }, { id: 2 }, { id: 3 }];
    const createNode = createNodeFactory();

    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node);
      return { key: getKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = [{ id: 2 }, { id: 4 }, { id: 1 }]; // '4' is new, '3' is removed
    createNode.mockClear();

    const result = reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual([2, 4, 1]);
    expect(result.map(r => r.node.id)).toEqual([2, 4, 1]);
    expect(result.find(r => r.key === 4).dispose).not.toHaveBeenCalled(); // new node dispose should not be called

    // Old item '3' should have its dispose called
    expect(structuredOldItems[2].dispose).toHaveBeenCalledTimes(1);
    
    // Old items '1' and '2' should not have dispose called
    expect(structuredOldItems[0].dispose).not.toHaveBeenCalled();
    expect(structuredOldItems[1].dispose).not.toHaveBeenCalled();
  });

  test("common prefix + suffix fast paths", () => {
    const parent = makeParent();

    const initialOldItems = [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }];
    const createNode = createNodeFactory();

    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node);
      return { key: getKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = [{ id: 1 }, { id: 2 }, { id: 5 }, { id: 4 }]; // '5' is new, '3' is removed
    createNode.mockClear();

    const result = reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual([1, 2, 5, 4]);
    expect(result.map(r => r.node.id)).toEqual([1, 2, 5, 4]);

    expect(parent.children[0]).toBe(structuredOldItems[0].node);
    expect(parent.children[1]).toBe(structuredOldItems[1].node);
    expect(parent.children[3]).toBe(structuredOldItems[3].node);

    // Old item '3' should have its dispose called
    expect(structuredOldItems[2].dispose).toHaveBeenCalledTimes(1);

    // Other old items should not have dispose called
    expect(structuredOldItems[0].dispose).not.toHaveBeenCalled();
    expect(structuredOldItems[1].dispose).not.toHaveBeenCalled();
    expect(structuredOldItems[3].dispose).not.toHaveBeenCalled();
  });

  // New tests for simple string arrays
  describe("reconcileReactive() with string arrays", () => {
    test("append new items (old empty) with strings", () => {
      const parent = makeParent();
      const oldItems = [];
      const newItems = ['A', 'B', 'C'];

      const createNode = createPrimitiveNodeFactory();

      const result = reconcileReactive(parent, oldItems, newItems, getPrimitiveKey, createNode);

      expect(parent.children.map(n => n.id)).toEqual(['A', 'B', 'C']);
      expect(result.map(r => r.key)).toEqual(['A', 'B', 'C']);
      expect(result.map(r => r.node.id)).toEqual(['A', 'B', 'C']);
    });

    test("remove old items (new empty) with strings", () => {
      const parent = makeParent();
      const initialOldItems = ['A', 'B'];
      const createNode = createPrimitiveNodeFactory();

      const structuredOldItems = initialOldItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getPrimitiveKey(item), node: rec.node, dispose: rec.dispose };
      });

      const newItems = [];
      
      const result = reconcileReactive(parent, structuredOldItems, newItems, getPrimitiveKey, createNode);

      expect(parent.children).toEqual([]);
      expect(result).toEqual([]);
      structuredOldItems.forEach(item => expect(item.dispose).toHaveBeenCalled());
    });

    test("move items (C → A → B) with strings", () => {
      const parent = makeParent();
      const initialOldItems = ['A', 'B', 'C'];
      const createNode = createPrimitiveNodeFactory();

      const structuredOldItems = initialOldItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getPrimitiveKey(item), node: rec.node, dispose: rec.dispose };
      });

      const newItems = ['C', 'A', 'B'];
      createNode.mockClear();

      const result = reconcileReactive(parent, structuredOldItems, newItems, getPrimitiveKey, createNode);

      expect(parent.children.map(n => n.id)).toEqual(['C', 'A', 'B']);
      expect(createNode).not.toHaveBeenCalled(); 

      // Additional check: Ensure the nodes are the same as in oldItems
      expect(parent.children[0]).toBe(structuredOldItems[2].node); // 'C' should be reused
      expect(parent.children[1]).toBe(structuredOldItems[0].node); // 'A' should be reused
      expect(parent.children[2]).toBe(structuredOldItems[1].node); // 'B' should be reused
      
      // Ensure dispose was not called for reused items
      structuredOldItems.forEach(item => expect(item.dispose).not.toHaveBeenCalled());
    });

    test("insert, move, remove mixed with strings", () => {
      const parent = makeParent();
      const initialOldItems = ['A', 'B', 'C'];
      const createNode = createPrimitiveNodeFactory();

      const structuredOldItems = initialOldItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getPrimitiveKey(item), node: rec.node, dispose: rec.dispose };
      });

      const newItems = ['B', 'D', 'A']; // 'D' is new, 'C' is removed
      createNode.mockClear();

      const result = reconcileReactive(parent, structuredOldItems, newItems, getPrimitiveKey, createNode);

      expect(parent.children.map(n => n.id)).toEqual(['B', 'D', 'A']);
      expect(result.map(r => r.node.id)).toEqual(['B', 'D', 'A']);

      // Old item 'C' should have its dispose called
      expect(structuredOldItems[2].dispose).toHaveBeenCalledTimes(1);
      
      // Old items 'A' and 'B' should not have dispose called
      expect(structuredOldItems[0].dispose).not.toHaveBeenCalled();
      expect(structuredOldItems[1].dispose).not.toHaveBeenCalled();
    });

    test("common prefix + suffix fast paths with strings", () => {
      const parent = makeParent();
      const initialOldItems = ['A', 'B', 'C', 'D'];
      const createNode = createPrimitiveNodeFactory();

      const structuredOldItems = initialOldItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getPrimitiveKey(item), node: rec.node, dispose: rec.dispose };
      });

      const newItems = ['A', 'B', 'E', 'D']; // 'E' is new, 'C' is removed
      createNode.mockClear();

      const result = reconcileReactive(parent, structuredOldItems, newItems, getPrimitiveKey, createNode);

      expect(parent.children.map(n => n.id)).toEqual(['A', 'B', 'E', 'D']);
      expect(result.map(r => r.node.id)).toEqual(['A', 'B', 'E', 'D']);

      expect(parent.children[0]).toBe(structuredOldItems[0].node);
      expect(parent.children[1]).toBe(structuredOldItems[1].node);
      expect(parent.children[3]).toBe(structuredOldItems[3].node);

      // Old item 'C' should have its dispose called
      expect(structuredOldItems[2].dispose).toHaveBeenCalledTimes(1);

      // Other old items should not have dispose called
      expect(structuredOldItems[0].dispose).not.toHaveBeenCalled();
      expect(structuredOldItems[1].dispose).not.toHaveBeenCalled();
      expect(structuredOldItems[3].dispose).not.toHaveBeenCalled();
    });
  });
});

describe("reconcileReactive() with mixed arrays", () => {
  test("append new items (old empty) with mixed types", () => {
    const parent = makeParent();
    const oldItems = [];
    const newItems = [{ id: 1 }, 'B', { id: 3 }, 'D'];

    const createNode = createMixedNodeFactory();

    const result = reconcileReactive(parent, oldItems, newItems, getMixedKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual([1, 'B', 3, 'D']);
    expect(result.map(r => r.key)).toEqual([1, 'B', 3, 'D']);
    expect(result.map(r => r.node.id)).toEqual([1, 'B', 3, 'D']);
  });

  test("remove old items (new empty) with mixed types", () => {
    const parent = makeParent();
    const initialOldItems = [{ id: 1 }, 'B', { id: 3 }];
    const createNode = createMixedNodeFactory();

    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node);
      return { key: getMixedKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = [];
    
    const result = reconcileReactive(parent, structuredOldItems, newItems, getMixedKey, createNode);

    expect(parent.children).toEqual([]);
    expect(result).toEqual([]);
    structuredOldItems.forEach(item => expect(item.dispose).toHaveBeenCalled());
  });

  test("move items (D → A → B) with mixed types", () => {
    const parent = makeParent();
    const initialOldItems = ['A', { id: 2 }, 'C', 'D'];
    const createNode = createMixedNodeFactory();

    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node);
      return { key: getMixedKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = ['D', 'A', { id: 2 }, 'C'];
    createNode.mockClear();

    const result = reconcileReactive(parent, structuredOldItems, newItems, getMixedKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual(['D', 'A', 2, 'C']);
    expect(createNode).not.toHaveBeenCalled(); 

    expect(parent.children[0]).toBe(structuredOldItems[3].node); // 'D' should be reused
    expect(parent.children[1]).toBe(structuredOldItems[0].node); // 'A' should be reused
    expect(parent.children[2]).toBe(structuredOldItems[1].node); // {id:2} should be reused
    expect(parent.children[3]).toBe(structuredOldItems[2].node); // 'C' should be reused
    
    structuredOldItems.forEach(item => expect(item.dispose).not.toHaveBeenCalled());
  });

  test("insert, move, remove mixed with mixed types", () => {
    const parent = makeParent();
    const initialOldItems = [{ id: 1 }, 'B', { id: 3 }];
    const createNode = createMixedNodeFactory();

    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node);
      return { key: getMixedKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = ['B', { id: 4 }, { id: 1 }]; // {id:4} is new, {id:3} is removed
    createNode.mockClear();

    const result = reconcileReactive(parent, structuredOldItems, newItems, getMixedKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual(['B', 4, 1]);
    expect(result.map(r => r.node.id)).toEqual(['B', 4, 1]);

    expect(result.find(r => r.key === 4).dispose).not.toHaveBeenCalled(); // new node dispose should not be called

    expect(structuredOldItems[2].dispose).toHaveBeenCalledTimes(1); // Old item {id:3} should have its dispose called
    
    expect(structuredOldItems[0].dispose).not.toHaveBeenCalled();
    expect(structuredOldItems[1].dispose).not.toHaveBeenCalled();
  });

  test("common prefix + suffix fast paths with mixed types", () => {
    const parent = makeParent();
    const initialOldItems = [{ id: 1 }, 'B', { id: 3 }, 'D'];
    const createNode = createMixedNodeFactory();

    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node);
      return { key: getMixedKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = [{ id: 1 }, 'B', { id: 5 }, 'D']; // {id:5} is new, {id:3} is removed
    createNode.mockClear();

    const result = reconcileReactive(parent, structuredOldItems, newItems, getMixedKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual([1, 'B', 5, 'D']);
    expect(result.map(r => r.node.id)).toEqual([1, 'B', 5, 'D']);

    expect(parent.children[0]).toBe(structuredOldItems[0].node);
    expect(parent.children[1]).toBe(structuredOldItems[1].node);
    expect(parent.children[3]).toBe(structuredOldItems[3].node);

    expect(structuredOldItems[2].dispose).toHaveBeenCalledTimes(1); // Old item {id:3} should have its dispose called

    expect(structuredOldItems[0].dispose).not.toHaveBeenCalled();
    expect(structuredOldItems[1].dispose).not.toHaveBeenCalled();
    expect(structuredOldItems[3].dispose).not.toHaveBeenCalled();
  });

  test("insert, move, remove with numbers, booleans, and objects", () => {
    const parent = makeParent();
    const initialOldItems = [{ id: 1 }, true, 3, 'D', false];
    const createNode = createMixedNodeFactory();

    const structuredOldItems = initialOldItems.map(item => {
      const rec = createNode(item);
      parent.children.push(rec.node);
      return { key: getMixedKey(item), node: rec.node, dispose: rec.dispose };
    });

    const newItems = [true, { id: 1 }, 'E', 3, false]; // 'E' is new, 'D' is removed
    createNode.mockClear();

    const result = reconcileReactive(parent, structuredOldItems, newItems, getMixedKey, createNode);

    expect(parent.children.map(n => n.id)).toEqual([true, 1, 'E', 3, false]);
    expect(result.map(r => r.node.id)).toEqual([true, 1, 'E', 3, false]);

    expect(createNode).toHaveBeenCalledTimes(1);
    expect(createNode).toHaveBeenCalledWith('E');

    const removedItem = structuredOldItems.find(item => item.key === 'D');
    expect(removedItem.dispose).toHaveBeenCalledTimes(1);
  });
});