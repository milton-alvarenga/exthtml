export function create_node() {
    return {
        section: 'VirtualExtHTMLDocument',
        type: '',
        value: '',
        attrs: [],
        dynamic_attrs: [],
        event_attrs: [],
        children: [],
        location: {
            start: {
                offset: -1,
                line: -1,
                column: -1
            },
            end: {
                offset: -1,
                line: -1,
                column: -1
            }
        }
    }
}

export function create_attribute() {
    return {
        name: '',
        value: '',
        category: '',
        pos: -1
    }
}