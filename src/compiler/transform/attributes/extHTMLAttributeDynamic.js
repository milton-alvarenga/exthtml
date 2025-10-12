class extHTMLAttributeDynamic {
    constructor(extHTMLElement) {
        this.extHTMLElement = extHTMLElement;
    }

    main() {

        switch (attr.category) {
            case "html_global_boolean_attribute":
            case "html_boolean_attribute":
                htmlBooleanAttr(attr, mode, result, variableName, node, parent_nm)
                break
            case "html_data_attribute":
                htmlDataAttr(attr, mode, result, variableName, node, parent_nm)
                break
            case "html_global_non_boolean_attribute":
            case "html_attribute":
                htmlRegularAttr(attr, mode, result, variableName, node, parent_nm)
                break
            case "html_media_readonly":
            case "html_video_readonly":
                htmlReadOnlyAttr(attr, mode, result, variableName, node, parent_nm)
                break
            case "class_directive":
                htmlClassDirective(attr, mode, result, variableName, node, parent_nm)
                break
            case "lang_directive":
                htmlLangDirective(attr, mode, result, variableName, node, parent_nm)
                break
            case "custom_attribute":
                htmlCustomAttr(attr, mode, result, variableName, node, parent_nm)
                break
            case "drall_directive":
                htmlDrallDirective(attr, mode, result, variableName, node, parent_nm)
                break
            case "macro_directive":
                htmlMacroDirective(attr, mode, result, variableName, node, parent_nm)
                break
            default:
                throw Error(`${this.constructor.name} class on ${this.main.name} method: Invalid ${mode.toLowerCase()} attribute on ${attr.name} as it is of category ${attr.category} not recognized`)
        }
    }
}