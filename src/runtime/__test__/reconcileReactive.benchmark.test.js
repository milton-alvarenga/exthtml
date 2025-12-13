// src/runtime/__test__/reconcileReactive.benchmark.test.js
import { jest } from '@jest/globals';
import { reconcileReactive } from "../for2.js";

// --- Helper functions copied from reconcileReactive.test.js ---
function makeParent() {
  return {
    children: [],
    insertBefore(node, ref) {
      const idx = this.children.indexOf(node);
      if (idx !== -1) {
        this.children.splice(idx, 1);
      }
      const refIdx = ref ? this.children.indexOf(ref) : -1;
      if (refIdx === -1) {
        this.children.push(node);
      } else {
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

function createNodeFactory(parent) { // Accept parent as argument
  return jest.fn(item => {
    const node = makeNode(item);
    const dispose = jest.fn(() => {
      // Simulate detach: remove node from parent's children array
      const idx = parent.children.indexOf(node);
      if (idx !== -1) {
        parent.children.splice(idx, 1);
      }
    });
    return { node, dispose };
  });
}

function makePrimitiveNode(item) {
  return { id: item };
}

function createPrimitiveNodeFactory(parent) { // Accept parent as argument
  return jest.fn(item => {
    const node = makePrimitiveNode(item);
    const dispose = jest.fn(() => {
      const idx = parent.children.indexOf(node);
      if (idx !== -1) {
        parent.children.splice(idx, 1);
      }
    });
    return { node, dispose };
  });
}

function getPrimitiveKey(item) {
  return item;
}

function getMixedKey(item) {
  if (typeof item === 'object' && item !== null && 'id' in item) {
    return item.id;
  }
  return item;
}

function makeMixedNode(item) {
  if (typeof item === 'object' && item !== null && 'id' in item) {
    return { id: item.id };
  }
  return { id: item };
}

function createMixedNodeFactory(parent) { // Accept parent as argument
  return jest.fn(item => {
    const node = makeMixedNode(item);
    const dispose = jest.fn(() => {
      const idx = parent.children.indexOf(node);
      if (idx !== -1) {
        parent.children.splice(idx, 1);
      }
    });
    return { node, dispose };
  });
}
// --- End Helper functions ---

describe("reconcileReactive() Benchmarking", () => {
  const SIZES = [100, 1000, 5000]; // Test with different array sizes

  SIZES.forEach(size => {
    test(`Benchmark: No changes in a list of ${size} items`, () => {
      const parent = makeParent();
      const createNode = createNodeFactory(parent); // Pass parent

      let initialItems = Array.from({ length: size }, (_, i) => ({ id: i, value: `Item ${i}` }));
      let structuredOldItems = initialItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getKey(item), node: rec.node, dispose: rec.dispose };
      });
      createNode.mockClear();

      const newItems = [...initialItems]; // Identical list

      const startTime = performance.now();
      reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);
      const endTime = performance.now();

      console.log(`  Size ${size} - No changes: ${endTime - startTime} ms`);
      expect(createNode).not.toHaveBeenCalled(); // No new nodes should be created
      expect(parent.children.map(n => n.id)).toEqual(newItems.map(item => item.id));
    });

    test(`Benchmark: Appending ${size / 10} items to a list of ${size} items`, () => {
      const parent = makeParent();
      const createNode = createNodeFactory(parent); // Pass parent

      let initialItems = Array.from({ length: size }, (_, i) => ({ id: i, value: `Item ${i}` }));
      let structuredOldItems = initialItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getKey(item), node: rec.node, dispose: rec.dispose };
      });
      createNode.mockClear();

      const itemsToAdd = Array.from({ length: size / 10 }, (_, i) => ({ id: size + i, value: `New Item ${size + i}` }));
      const newItems = [...initialItems, ...itemsToAdd];

      const startTime = performance.now();
      reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);
      const endTime = performance.now();

      console.log(`  Size ${size} - Append ${size / 10} items: ${endTime - startTime} ms`);
      expect(createNode).toHaveBeenCalledTimes(itemsToAdd.length); // Only new nodes should be created
      expect(parent.children.map(n => n.id)).toEqual(newItems.map(item => item.id));
    });

    test(`Benchmark: Prepending ${size / 10} items to a list of ${size} items`, () => {
      const parent = makeParent();
      const createNode = createNodeFactory(parent); // Pass parent

      let initialItems = Array.from({ length: size }, (_, i) => ({ id: i, value: `Item ${i}` }));
      let structuredOldItems = initialItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getKey(item), node: rec.node, dispose: rec.dispose };
      });
      createNode.mockClear();

      const itemsToAdd = Array.from({ length: size / 10 }, (_, i) => ({ id: -(i + 1), value: `New Item ${-(i + 1)}` }));
      const newItems = [...itemsToAdd, ...initialItems];

      const startTime = performance.now();
      reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);
      const endTime = performance.now();

      console.log(`  Size ${size} - Prepend ${size / 10} items: ${endTime - startTime} ms`);
      expect(createNode).toHaveBeenCalledTimes(itemsToAdd.length); // Only new nodes should be created
      expect(parent.children.map(n => n.id)).toEqual(newItems.map(item => item.id));
    });

    test(`Benchmark: Removing ${size / 10} items from the middle of a list of ${size} items`, () => {
      const parent = makeParent();
      const createNode = createNodeFactory(parent); // Pass parent

      let initialItems = Array.from({ length: size }, (_, i) => ({ id: i, value: `Item ${i}` }));
      let structuredOldItems = initialItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getKey(item), node: rec.node, dispose: rec.dispose };
      });
      createNode.mockClear();

      const newItems = [...initialItems];
      newItems.splice(Math.floor(size / 2) - Math.floor(size / 20), size / 10); // Remove from middle

      const startTime = performance.now();
      reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);
      const endTime = performance.now();

      console.log(`  Size ${size} - Remove ${size / 10} items from middle: ${endTime - startTime} ms`);
      expect(createNode).not.toHaveBeenCalled(); // No new nodes should be created
      // Check dispose calls for removed items
      const removedItems = initialItems.filter(item => !newItems.some(nItem => nItem.id === item.id));
      removedItems.forEach(item => {
        const oldItem = structuredOldItems.find(o => o.key === item.id);
        expect(oldItem.dispose).toHaveBeenCalledTimes(1);
      });
      expect(parent.children.map(n => n.id)).toEqual(newItems.map(item => item.id));
    });

    test(`Benchmark: Moving items (reverse order) in a list of ${size} items`, () => {
      const parent = makeParent();
      const createNode = createNodeFactory(parent); // Pass parent

      let initialItems = Array.from({ length: size }, (_, i) => ({ id: i, value: `Item ${i}` }));
      let structuredOldItems = initialItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getKey(item), node: rec.node, dispose: rec.dispose };
      });
      createNode.mockClear();

      const newItems = [...initialItems].reverse(); // Reverse the list

      const startTime = performance.now();
      reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);
      const endTime = performance.now();

      console.log(`  Size ${size} - Reverse order: ${endTime - startTime} ms`);
      expect(createNode).not.toHaveBeenCalled(); // No new nodes should be created
      structuredOldItems.forEach(item => expect(item.dispose).not.toHaveBeenCalled()); // No items should be disposed
      expect(parent.children.map(n => n.id)).toEqual(newItems.map(item => item.id));
    });

    test(`Benchmark: Random shuffle of a list of ${size} items`, () => {
      const parent = makeParent();
      const createNode = createNodeFactory(parent); // Pass parent

      let initialItems = Array.from({ length: size }, (_, i) => ({ id: i, value: `Item ${i}` }));
      let structuredOldItems = initialItems.map(item => {
        const rec = createNode(item);
        parent.children.push(rec.node);
        return { key: getKey(item), node: rec.node, dispose: rec.dispose };
      });
      createNode.mockClear();

      // Simple Fisher-Yates shuffle
      const newItems = [...initialItems];
      for (let i = newItems.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [newItems[i], newItems[j]] = [newItems[j], newItems[i]];
      }

      const startTime = performance.now();
      reconcileReactive(parent, structuredOldItems, newItems, getKey, createNode);
      const endTime = performance.now();

      console.log(`  Size ${size} - Random shuffle: ${endTime - startTime} ms`);
      expect(createNode).not.toHaveBeenCalled(); // No new nodes should be created
      structuredOldItems.forEach(item => expect(item.dispose).not.toHaveBeenCalled()); // No items should be disposed
      expect(parent.children.map(n => n.id)).toEqual(newItems.map(item => item.id));
    });
  });
});
