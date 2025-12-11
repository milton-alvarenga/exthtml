function lisIndices(map, start, endNew) {
  const seq = [];
  const pos = new Array(map.length);

  for (let i = 0; i < map.length; i++) {
    const v = map[i];
    if (v < 0) continue;
    const j = binarySearch(seq, v);
    if (j === seq.length) seq.push(v);
    else seq[j] = v;
    pos[i] = j;
  }

  return { lis: seq, pos };
}

function binarySearch(arr, value) {
  let lo = 0;
  let hi = arr.length;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (arr[mid] < value) lo = mid + 1;
    else hi = mid;
  }
  return lo;
}

export function reconcileReactive(parent, oldList, newList, getKey, createNode, before = null) {
  const oldLen = oldList.length;
  const newLen = newList.length;

  // Convert old list into keyed records:
  // { key, node, dispose }
  // new list must be shaped: { key, value }
  let old = oldList;
  let newItems = newList.map(value => ({
    key: getKey(value),
    value
  }));

  // Fast path: no old → insert all
  if (oldLen === 0) {
    for (let i = 0; i < newLen; i++) {
      const rec = createNode(newItems[i].value);
      newItems[i].node = rec.node;
      newItems[i].dispose = rec.dispose;
      parent.insertBefore(rec.node, before);
    }
    return newItems;
  }

  // Fast path: no new → remove all
  if (newLen === 0) {
    for (let i = 0; i < oldLen; i++) {
      old[i].dispose();
      parent.removeChild(old[i].node);
    }
    return [];
  }

  let start = 0;
  let endOld = oldLen - 1;
  let endNew = newLen - 1;

  // 1. Prefix scan
  while (
    start <= endOld &&
    start <= endNew &&
    old[start].key === newItems[start].key
  ) {
    // Reuse
    newItems[start].node = old[start].node;
    newItems[start].dispose = old[start].dispose;
    start++;
  }

  // 2. Suffix scan
  while (
    endOld >= start &&
    endNew >= start &&
    old[endOld].key === newItems[endNew].key
  ) {
    newItems[endNew].node = old[endOld].node;
    newItems[endNew].dispose = old[endOld].dispose;
    endOld--;
    endNew--;
  }

  // 3. All new matched by prefix scan
  if (start > endNew) {
    while (start <= endOld) {
      old[start].dispose();
      parent.removeChild(old[start].node);
      start++;
    }
    return newItems;
  }

  // 4. No old remaining — pure insertion
  if (start > endOld) {
    const ref = endNew + 1 < newLen ? newItems[endNew + 1].node : before;
    for (let i = endNew; i >= start; i--) {
      const rec = createNode(newItems[i].value);
      newItems[i].node = rec.node;
      newItems[i].dispose = rec.dispose;
      parent.insertBefore(rec.node, ref);
    }
    return newItems;
  }

  // 5. Build map key → newIndex
  const newIndexMap = new Map();
  for (let i = start; i <= endNew; i++) {
    newIndexMap.set(newItems[i].key, i);
  }

  // 6. Map old indices → new indices (-1 = removed)
  const toNewIndex = new Array(endOld - start + 1);
  for (let i = 0; i < toNewIndex.length; i++) toNewIndex[i] = -1;

  // Remove old items not present in new
  for (let i = start; i <= endOld; i++) {
    const rec = old[i];
    const idx = newIndexMap.get(rec.key);
    if (idx !== undefined) {
      toNewIndex[i - start] = idx;
    } else {
      rec.dispose();
      parent.removeChild(rec.node);
    }
  }

  // 7. Compute LIS over toNewIndex
  const { lis, pos } = lisIndices(toNewIndex, start, endNew);

  let lisPos = lis.length - 1;

  // 8. Insert/move from endNew→start
  for (let i = endNew; i >= start; i--) {
    const newItem = newItems[i];

    const oldIdx = toNewIndex.indexOf(i);
    let node, dispose;

    if (oldIdx === -1) {
      // new node + reactive root
      const rec = createNode(newItem.value);
      node = rec.node;
      dispose = rec.dispose;
    } else {
      node = old[start + oldIdx].node;
      dispose = old[start + oldIdx].dispose;
    }

    newItem.node = node;
    newItem.dispose = dispose;

    // Determine the reference node for insertion
    const currentRef = (i + 1 < newLen) ? newItems[i+1].node : before;

    if (oldIdx !== -1 && pos[oldIdx] === lisPos) {
      lisPos--; // part of LIS: do not move
    } else {
      parent.insertBefore(node, currentRef);
    }
  }

  return newItems;
}

