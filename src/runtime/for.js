export function reconcile(parent, oldItems, newItems, getKey, createNode, getNode) {
  let oldStart = 0,
      newStart = 0,
      oldEnd = oldItems.length - 1,
      newEnd = newItems.length - 1;

  // skip prefix
  while (
    oldStart <= oldEnd &&
    newStart <= newEnd &&
    getKey(oldItems[oldStart]) === getKey(newItems[newStart])
  ) {
    newItems[newStart]._node = oldItems[oldStart]._node;
    oldStart++;
    newStart++;
  }

  // skip suffix
  while (
    oldStart <= oldEnd &&
    newStart <= newEnd &&
    getKey(oldItems[oldEnd]) === getKey(newItems[newEnd])
  ) {
    newItems[newEnd]._node = oldItems[oldEnd]._node;
    oldEnd--;
    newEnd--;
  }

  if (oldStart > oldEnd) {
    // append new
    const nextNode = newEnd + 1 < newItems.length ? getNode(newItems[newEnd + 1]) : null;
    for (let i = newStart; i <= newEnd; i++) {
      const node = createNode(newItems[i]);
      newItems[i]._node = node;
      parent.insertBefore(node, nextNode);
    }
    return newItems;
  }

  if (newStart > newEnd) {
    // remove old
    for (let i = oldStart; i <= oldEnd; i++) {
      parent.removeChild(getNode(oldItems[i]));
    }
    return newItems;
  }

  // build key → index map for new items
  const map = new Map();
  for (let i = newStart; i <= newEnd; i++) map.set(getKey(newItems[i]), i);

  // mark old items for removal or reuse
  for (let i = oldStart; i <= oldEnd; i++) {
    const key = getKey(oldItems[i]);
    if (!map.has(key)) parent.removeChild(getNode(oldItems[i]));
    else map.set(key, -i - 1); // negative = reused
  }

  // insert/move items backward
  let nextNode = newEnd + 1 < newItems.length ? getNode(newItems[newEnd + 1]) : null;
  for (let i = newEnd; i >= newStart; i--) {
    const item = newItems[i];
    const marker = map.get(getKey(item));
    let node;

    if (marker >= 0) {
      // new node
      node = createNode(item);
    } else {
      // existing node
      node = getNode(oldItems[-marker - 1]);
    }

    item._node = node;
    parent.insertBefore(node, nextNode);
    nextNode = node; // crucial: update nextNode to the inserted node
  }

  return newItems;
}
