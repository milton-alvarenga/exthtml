class extHTMLAttributes {
    constructor(extHTMLElement) {
        this.extHTMLElement = extHTMLElement;
    }

    main() {
        processStaticAttributes()
        processDynamicAttributes()
        processEventAttributes()
    }
    
    //Static
    processStaticAttributes(){
        this.extHTMLElement.external.exthtml.attrs.forEach(attr => traverseExthtmlAttr(attr, "STATIC", result, variableName, exthtml, parent_nm))
    }

    //Dynamic
    processDynamicAttributes(){
        this.extHTMLElement.external.exthtml.dynamic_attrs.forEach(dynamicAttr => traverseExthtmlAttr(dynamicAttr, "DYNAMIC", result, variableName, exthtml, parent_nm))
    }

    //Dynamic
    processEventAttributes(){
        this.extHTMLElement.external.exthtml.event_attrs.forEach(eventAttr => traverseExthtmlEventAttr(eventAttr, "DYNAMIC", result, variableName, parent_nm))
    }


}