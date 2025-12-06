
/**
 * @param {Element} parent
 * @param {() => any[]} getter
 * @param {(item: any) => any} keyFn
 * @param {(item: any, key: any) => { key: any, update: (item: any) => void, mount: (parent: Element, anchor: Node) => void, first_node: () => Node, destroy: () => void }} createFn
 * @returns {() => void}
 */
export function keyed(parent, getter, keyFn, createFn) {
    const anchor = document.createComment('keyed-anchor');
    parent.appendChild(anchor);
    let blocks = [];

    function update() {
        const new_list = getter();
        const new_blocks = [];
        const old_map = new Map();
        
        blocks.forEach((block, i) => {
            old_map.set(block.key, { block, i });
        });

        let next_node = anchor;

        for (let i = new_list.length - 1; i >= 0; i--) {
            const item = new_list[i];
            const key = keyFn(item);
            let block_info = old_map.get(key);
            let block;

            if (block_info) {
                block = block_info.block;
                block.update(item);
                old_map.delete(key);
            } else {
                block = createFn(item, key);
            }
            
            // This is a simple mount, for a more optimized version,
            // we'd need to check if the node is already in the correct position.
            block.mount(parent, next_node);
            
            next_node = block.first_node();
            new_blocks[i] = block;
        }

        // Destroy remaining old blocks that were not in the new list
        for (const [key, { block }] of old_map.entries()) {
            block.destroy();
        }
        
        blocks = new_blocks;
    }
    
    update();
    return update;
}
