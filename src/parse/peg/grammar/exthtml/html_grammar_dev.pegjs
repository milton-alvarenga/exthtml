/********************************** HTML ************************************/

/**
 * Document is just a collection of elements.
 */
ExtHTMLDocument = __ nodes:Element* { return nodes; }

/**
 * Elements - https://www.w3.org/TR/html5/syntax.html#elements-0
 * Need to add custom HTML component (name-complement)
 * Text / See if it is necessary
 */
Element  = NL / RawText / Nested / SelfClose / Comment / ExtHTMLComment / DocType / Component / DynamicTextNode / TextNode

RawText  = Script / Style / Textarea / Title / PlainText

Script    "script"    = '<script'i    attrs:Attributes* '>' __ content:(ch:(!('</script'i    __ '>') c:. { return c; })*) __ '</script'i    __ '>' __ { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'SCRIPT_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
Style     "style"     = '<style'i     attrs:Attributes* '>' __ content:(ch:(!('</style'i     __ '>') c:. { return c; })*) __ '</style'i     __ '>' __ { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'STYLE_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
Textarea  "textarea"  = '<textarea'i  attrs:Attributes* '>' __ content:(ch:(!('</textarea'i  __ '>') c:. { return c; })*) __ '</textarea'i  __ '>' __ { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'TEXTAREA_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
Title     "title"     = '<title'i     attrs:Attributes* '>' __ content:(ch:(!('</title'i     __ '>') c:. { return c; })*) __ '</title'i     __ '>' __ { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'TITLE_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
PlainText "plaintext" = '<plaintext'i attrs:Attributes* '>' __ content:(ch:(!('</plaintext'i __ '>') c:. { return c; })*) __ '</plaintext'i __ '>' __ { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'PLAINTEXT_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }

Nested    "element"   = begin:HTMLTagBegin __ children:Element* end:HTMLTagEnd __ { begin.location = location(); begin.children.push(...children); return begin; }

HTMLTagBegin  "begin tag" = '<'  name:HTMLTagName attrs:Attributes* '>' { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'HTML_NESTED_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return ['attr','no_arg_attr'].includes(v.type) }).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
HTMLTagEnd    "end tag"   = '</' name:HTMLTagName __               '>'

TagBegin  "begin tag" = '<'  name:TagName attrs:Attributes* '>' { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'NESTED_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return ['attr','no_arg_attr'].includes(v.type) }).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
TagEnd    "end tag"   = '</' name:TagName __               '>'


/**
 * Void element (with self closing tag, w/o content)
 * - 'area'i / 'base'i / 'br'i / 'col'i / 'embed'i / 'hr'i / 'img'i / 'input'i / 'keygen'i / 'link'i / 'meta'i / 'param'i / 'source'i / 'track'i / 'wbr'i
 */
SelfClose "self close element" = '<' name:SelfCloseTagName attrs:Attributes* SelfCloseTag { attrs = attrs[0] || [];  return { section: 'ExtHTMLDocument', type: 'SELF_CLOSE_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }

Component "component" = NestedComponent / SelfCloseComponent

NestedComponent = begin:TagBegin __ children:Element* __ end:TagEnd __ { return { section: 'ExtHTMLDocument', type: 'COMPONENT', value: begin.value, attrs:[...begin.attrs], dynamic_attrs:[...begin.dynamic_attrs], event_attrs:[...begin.event_attrs], children:[...children], location: location() }; }

SelfCloseComponent = '<' name:TagName attrs:Attributes* SelfCloseTag __ { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'COMPONENT', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
					
 
Comment   "comment"   = '<!--' text:CommentText '-->' __ { return { section: 'ExtHTMLDocument', type: 'COMMENT_TEXT', value: text, location: location()} }

ExtHTMLComment "ExtHTML comment" = __ comments:(SingleLineComment / MultipleLineComment) __ { return comments; }

SingleLineComment "single line comment" = ( '//' / '#' ) c:(!NL .)* { return { section: 'ExtHTMLDocument', type: 'SINGLE_LINE_COMMENT', value: c.map(aV =>{ return aV[1]}).join(""), location: location() } }

MultipleLineComment "multiple line comment" = OpenMultipleLineComment text:(!CloseMultipleLineComment .)* CloseMultipleLineComment { return { section: 'ExtHTMLDocument', type: 'MULTIPLE_LINE_COMMENT', value: text.map(aV =>{ return aV[1]}).join(""), location: location() } }

OpenMultipleLineComment = '/*'

CloseMultipleLineComment = '*/'

CommentText = text:(!'-->' .)* { return text.map(function(v,idx,aOrigin){ return v.join(""); }).join(""); } 

DocType   "doctype"   = '<!DOCTYPE'i __ root:Symbol __ type:('public'i / 'system'i)? __ text:String* '>' __

GeneralCloseTag = SelfCloseTag / CloseTag

SelfCloseTag = __ '/>' __

CloseTag = __ '>' __


TextNode "text node" = v:Text { return { section: 'ExtHTMLDocument', type: 'TEXT_NODE', value: v.join(""), attrs:[], event_attrs:[], children:[], location: location() }; }

DynamicTextNode "dynamic text node" =  v:DynamicText { return { section: 'ExtHTMLDocument', type: 'DYNAMIC_TEXT_NODE', value: v, attrs:[], event_attrs:[], children:[], location: location() }; }

DynamicText "dynamic text" = v:VariableQuoteString { return v; }

Text "text"
  = ch:(c:[^<] &VariableQuoteString { return c })+
  / ch:(!HTMLTagEnd !TagEnd !SelfClose !Comment !DocType !DynamicTextNode !Component !Nested !RawText c:.{ return c })+

/**
 * Element attributes
 */
Attributes = whitespace attrs:( HTMLDomReferenceDirectiveAttribute / DynamicAttribute / EventAttribute / StaticAttribute / NoArgumentAttribute / NoArgumentMacroAttribute)+ &GeneralCloseTag { return attrs; }

StaticAttribute "attribute" = ( name:GlobalBooleanAttribute text:(__ '=' __ s:DoubleQuoteString)  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "html_global_boolean_attribute"}} )
                              / ( name:BooleanAttribute text:(__ '=' __ s:DoubleQuoteString)  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "html_boolean_attribute"}} )
                              / ( name:HTMLDataAttr text:(__ '=' __ s:DoubleQuoteString)  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "html_data_attribute"}} )
                              / ( name:GlobalNonBooleanAttribute text:(__ '=' __ s:DoubleQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "html_global_non_boolean_attribute"}} )
                              / ( name: ReadonlyMediaAttr text:( __ '=' __ s:DoubleQuoteString)  __  { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "html_media_readonly"}} )
                              / ( name: ReadonlyVideoAttr text:( __ '=' __ s:DoubleQuoteString)  __  { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "html_video_readonly"}} )
                              / ( name:HTMLAttrName text:(__ '=' __ s:DoubleQuoteString)  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "html_attribute"}} )
							                / ( name:AttrName text:(__ '=' __ s:DoubleQuoteString)  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "custom_attribute"}} )
                              / ( '*'name:SpecificDrallDirectives text:(__ '=' __ s:DoubleQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "drall_directive"}} )
                              / ( '('name:OptimizationReservedDirectivesMacro')' text:(__ '=' __ s:DoubleQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "macro_directive"}} )

DynamicAttribute "dynamic attribute" = ( name:GlobalBooleanAttribute text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "html_global_boolean_attribute"}} )
                                       / ( name:BooleanAttribute text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "html_boolean_attribute"}} )
                                       / ( name:HTMLDataAttr text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "html_data_attribute"}} )
                                       / ( name:GlobalNonBooleanAttribute text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "html_global_non_boolean_attribute"}} )
                                       / ( name: ReadonlyMediaAttr text:( __ '=' __ s:VariableQuoteString)  __  { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "html_media_readonly"}} )
                                       / ( name: ReadonlyVideoAttr text:( __ '=' __ s:VariableQuoteString)  __  { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "html_video_readonly"}} )
                                       / ( name:HTMLAttrName text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "html_attribute"}} )
									                     / ( '*'name:PrimitiveLanguageReservedDirectives text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "lang_directive"}} )
                                       / ( '*'name:SpecificDrallDirectives text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "drall_directive"}} )
                                       / ( '*'name:OptimizationReservedDirectives text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "optimization_directive"}} )
                                       / ( '('name:OptimizationReservedDirectivesMacro')' text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "macro_directive"}} )
                                       / ( name:AttrName text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "custom_attribute"}} )



GlobalBooleanAttribute "global_boolean_arg_attribute" = 'disabled'i / 'hidden'i / 'readonly'i

BooleanAttribute "boolean_arg_attribute" = 'allowfullscreen'i / 'allowpaymentrequest'i / 'async'i / 'autofocus'i / 'autoplay'i / 'checked'i / 'controls'i / 'default'i / 'defer'i / 'formnovalidate'i / 'inert'i / 'ismap'i / 'itemscope'i / 'loop'i / 'multiple'i / 'muted'i / 'nomodule'i / 'novalidate'i / 'open'i / 'playsinline'i / 'required'i / 'reversed'i / 'selected'i / 'shadowrootclonable'i / 'shadowrootdelegatesfocus'i / 'shadowrootserializable'i

ReadonlyMediaAttr "read_only_media_attributes" = 'duration'i / 'buffered'i / 'seekable'i / 'played'i / 'seeking'i / 'ended'i / 'readyState'i

ReadonlyVideoAttr "read_only_video_attributes" = 'videoHeight'i / 'videoWidth'i / 'naturalWidth'i / 'naturalHeight'i

HTMLDataAttr "data-*" = 'data-' [a-zA-Z_]+([-][a-zA-Z0-9:_])*

GlobalNonBooleanAttribute "global_non_boolean_attribute" = 'accesskey'i / 'class'i / 'contenteditable'i / 'contextmenu'i / HTMLDataAttr / 'dir'i / 'draggable'i / 'dropzone'i / 'id'i / 'inputmode'i / 'lang'i / 'spellcheck'i / 'style'i / 'tabindex'i / 'title'i / 'translate'i

NoArgumentAttribute "no_arg_attribute" = ( '*'name:NoArgumentsLanguageReservedDirectives __ { return { name: name, value: null, type:"no_arg_attr", category: "lang_directive"}} )

NoArgumentMacroAttribute "no_arg_macro_attribute" = ( '('name:OptimizationReservedDirectivesMacroWithNoArgument')' __ { return { name: name, value: null, type:"no_arg_attr", category: "macro_directive"}} )


EventAttribute "event attribute" = ( '@'name:HTMLAttrName event_modifiers:('.'EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "html_attribute", modifiers:event_modifiers.map(v=>v[1])}} )
                                   / ( '@'name:KeyboardEvent keyboard_keys:(':'KeyboardKeys)? event_modifiers:('.'EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "html_attribute", modifiers:event_modifiers.map(v=>v[1]), keyboard_keys:keyboard_keys ? keyboard_keys.filter((v,idx)=>{return idx > 0}) : []}} ) 
                                   / ( '@'name:MouseEvent mouse_keys:(':' MouseClick )? keyboard_modifiers_keys:('.'KeyboardSystemModifiersKeys)* event_modifiers:('.' EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "html_attribute", modifiers:event_modifiers.map(v=>v[1]), mouse_keys:mouse_keys ? mouse_keys[1] : "", keyboard_modifiers_keys:keyboard_modifiers_keys ? keyboard_modifiers_keys.flat(2).filter(v=>[".",":"].indexOf(v) == -1) : []}} )
                                   / ( '@'name:MouseEvent keyboard_modifiers_keys:(':' (KeyboardSystemModifiersKeys'.')+ )? mouse_keys:MouseClick event_modifiers:('.' EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "html_attribute", modifiers:event_modifiers.map(v=>v[1]), mouse_keys:mouse_keys ? mouse_keys : "", keyboard_modifiers_keys:keyboard_modifiers_keys ? keyboard_modifiers_keys.flat(2).filter(v=>[".",":"].indexOf(v) == -1) : []}} )
								                   / ( '@'name:AttrName event_modifiers:('.'EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "custom_attribute", modifiers:event_modifiers.map(v=>v[1])}} ) 

HTMLDomReferenceDirectiveAttribute = '#'name:HTMLDomVarName __ { return { name: name, value: null, type:"dyn_attr", category: "html_dom_ref_directive"}}

PrimitiveLanguageReservedDirectives = 'if' / 'for' / 'model' / 'in' / 'out'

NoArgumentsLanguageReservedDirectives = 'forelse'

ExtendedLanguageReservedDirectives = 'else' / 'elseif' /  'switch' / 'case' / 'default' / 'fallthrough'

OptimizationReservedDirectives = 'show' / 'hide'

OptimizationReservedDirectivesMacro = 'idname'

OptimizationReservedDirectivesMacroWithNoArgument = 'for'

SpecificDrallDirectives = 'perm' / SpecificDrallPermSimplificationDirectives / 'val' / 'mask'

SpecificDrallPermSimplificationDirectives = 'perm-group' / 'perm-mirror' / 'perm-redirect'

HTMLAttrName "html attribute" = LegacyHtmlAttrName / CurrentHtmlAttrName

LegacyHtmlAttrName = 'background'i / 'bgcolor'i / 'border'i / 'color'i / 'height'i / 'manifest'i / 'width'i

CurrentHtmlAttrName = 'accept-charset'i / 'accesskey'i / 'action'i / 'align'i / 'allow'i / 'alt'i
					             / 'autocapitalize'i / 'autocomplete'i / 'buffered'i
                       / 'capture'i /'challenge'i / 'charset'i / 'cite'i / 'class'i / 'code'i
                       / 'codebase'i / 'cols'i / 'colspan'i / 'content'i / 'contenteditable'i / 'contextmenu'i
                       / 'coords'i / 'crossorigin'i / 'csp'i / 'data'i / 'datetime'i
                       / 'decoding'i / 'dir'i / 'dirname'i / 'download'i
                       / 'draggable'i / 'dropzone'i / 'enctype'i / 'enterkeyhint'i / 'for'i / 'form'i / 'formaction'i
                       / 'formenctype'i / 'formmethod'i / 'formtarget'i / 'headers'i
                       / 'high'i / 'href'i / 'hreflang'i / 'http-equiv'i / 'icon'i / 'id'i / 'importance'i
                       / 'integrity'i / 'intrinsicsize'i / 'inputmode'i / 'keytype'i / 'kind'i
                       / 'label'i / 'lang'i / 'language'i / 'loading'i / 'list'i / 'low'i / 'max'i / 'maxlength'i
                       / 'minlength'i / 'media'i / 'method'i / 'min'i / 'name'i
                       / 'optimum'i / 'pattern'i / 'ping'i / 'placeholder'i / 'poster'i / 'preload'i / 'radiogroup'i
                       / 'referrerpolicy'i / 'rel'i / 'rows'i / 'rowspan'i / 'sandbox'i
                       / 'scope'i / 'scoped'i / 'shape'i / 'size'i / 'sizes'i / 'slot'i / 'span'i / 'spellcheck'i
                       / 'src'i / 'srcdoc'i / 'srclang'i / 'srcset'i / 'start'i / 'step'i / 'style'i / 'summary'i / 'tabindex'i
                       / 'target'i / 'title'i / 'translate'i / 'type'i / 'usemap'i / 'value'i / 'wrap'i
/**
TODO
HTMLEventName "html event name" = KeyboardEvent / 'list_of_events_here'

ALL KEYBOARDS KEYS
https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values#modifier_keys
*/

KeyboardEvent = 'keydown' / 'keypress' / 'keyup'

KeyboardKeys = 'enter' / 'tab' / 'delete' / 'esc' / 'space' / 'up' / 'down' / 'left' / 'right'   

KeyboardSystemModifiersKeys = 'ctrl' / 'alt' / 'shift' / 'meta' / 'altgraph' / 'fn'

MouseEvent = 'click' / 'mousedown' / 'mouseup' / 'mousemove' / 'dblclick' / 'mouseover' / 'mouseout'
             / 'mouseenter' / 'mouseleave'

MouseClick = 'left' / 'right' / 'middle'

EventModifiers = 'stop' / 'prevent' / 'capture' / 'self' / 'once' / 'passive' / 'debounce' / 'throttle'


/**
 * String - single, double, w/o quotes
 */
String "string"
  = DoubleQuoteString
  / SingleQuoteString
  / ch:([^"'<>` ]+)      __ { return ch.join(""); }

Integer = $([0-9])+
  
  
DoubleQuoteString = '"'  ch:([^"]*)      '"'  __ { return ch.join(""); }

SingleQuoteString = '\'' ch:([^']*)      '\'' __ { return ch.join(""); }

VariableQuoteString = '{' ch:([^}]*) '}' { return ch.join(""); }


SelfCloseTagName =  'area'i / 'base'i / 'br'i / 'col'i / 'embed'i / 'hr'i / 'img'i / 'input'i / 'link'i
	/ 'wbr'i / 'command'i / 'keygen'i /'menuitem'i / SelfCloseTagNameHtml5

SelfCloseTagNameHtml5 = 'meta'i / 'param'i / 'source'i / 'track'i / 'wbr'i

/* Check if need to classified by is_void, is_html or is_svg on output */
HTMLTagName = Html4ExclusivesTagName / Html5TagName / SvgElementName

Html4ExclusivesTagName = 'acronym'i / 'applet'i / 'basefont'i / 'big'i / 'center'i / 'dir'i / 'font'i / 'frameset'i / 'frame'i
	/ 'noframes'i / 'strike'i / 'tt'i

Html5TagName = 'abbr'i / 'address'i / 'area'i / 'article'i / 'aside'i / 'audio'i / 'a'i / 'base'i
	/ 'basefont'i / 'bdi'i / 'bdo'i / 'blockquote'i / 'body'i / 'br'i / 'button'i / 'b'i / 'canvas'i / 'caption'i
    / 'cite'i / 'code'i / 'col'i / 'colgroup'i / 'data'i / 'datalist'i / 'dd'i / 'del'i / 'details'i
    / 'dfn'i / 'dialog'i / 'div'i / 'dl'i / 'dt'i / 'em'i / 'embed'i / 'fieldset'i / 'figcaption'i
    / 'figure'i / 'footer'i / 'form'i / 'h1'i / 'h2'i / 'h3'i / 'h4'i / 'h5'i / 'h6'i / 'head'i / 'header'i
    / 'hr'i / 'html'i / 'iframe'i / 'img'i / 'input'i / 'ins'i / 'i'i / 'kbd'i / 'label'i / 'legend'i
    / 'link'i / 'li'i / 'main'i / 'map'i / 'mark'i / 'meter'i / 'nav'i / 'noscript'i
    / 'object'i / 'ol'i / 'optgroup'i / 'option'i / 'output'i / 'p'i / 'picture'i / 'pre'i
    / 'progress'i / 'q'i / 'rp'i / 'rt'i / 'ruby'i / 'samp'i / 'script'i / 'section'i / 'select'i
    / 'small'i / 'span'i / 'strong'i / 'sub'i / 'summary'i / 'sup'i / 'svg'i / 's'i
    / 'table'i / 'tbody'i / 'td'i / 'template'i / 'tfoot'i / 'th'i / 'thead'i / 'time'i
    / 'tr'i  / 'ul'i / 'u'i / 'var'i / 'video'i

SvgElementName = SvgElementNameShapeElements
                / SvgElementNameContainerElement
                / SvgElementNameFilterPrimitives
                / SvgElementNameAnimationElements
                / SvgElementNameTextRelatedElements
                / SvgElementNameFontAndGlyphElements
                / SvgElementNameOtherSpecializedElements

SvgElementNameShapeElements = 'circle'i / 'ellipse'i / 'line'i / 'path'i / 'polygon'i / 'polyline'i / 'rect'i
                              / 'image'i

SvgElementNameContainerElement = 'svg'i / 'g'i / 'symbol'i / 'defs'i / 'metadata'i / 'switch'i / 'use'i / 'view'i

SvgElementNameFilterPrimitives = 'feBlend'i / 'feColorMatrix'i / 'feComposite'i
                                  / 'feComponentTransfer'i / 'feConvolveMatrix'i / 'feDiffuseLighting'i / 'feDisplacementMap'i /  'feDistantLight'i
                                  / 'feDropShadow'i / 'feFlood'i / 'feFuncA'i / 'feFuncB'i / 'feFuncG'i / 'feFuncR'i / 'feGaussianBlur'i
                                  / 'feImage'i / 'feMerge'i / 'feMergeNode'i / 'feMorphology'i / 'feOffset'i / 'fePointLight'i / 'feSpecularLighting'i
                                  / 'feSpotLight'i / 'feTile'i / 'feTurbulence'i

SvgElementNameAnimationElements = 'animate'i / 'animateMotion'i / 'animateTransform'i / 'mpath'i / 'set'i

SvgElementNameTextRelatedElements = 'text'i / 'tspan'i / 'textPath'i / 'tref'i / 'desc'i / 'title'i

SvgElementNameFontAndGlyphElements = 'font'i / 'font-face'i / 'glyph'i / 'missing-glyph'i / 'hkern'i / 'vkern'i

SvgElementNameOtherSpecializedElements = 'clipPath'i / 'mask'i / 'pattern'i / 'marker'i / 'filter'i / 'foreignObject'i / 'mesh'i / 'color-profile'i / 'cursor'i / 'discard'i
                                        / 'hatch'i / 'hatchpath'i / 'linearGradient'i / 'meshgradient'i / 'meshpatch'i / 'meshrow'i
                                        / 'radialGradient'i / 'script'i / 'solidcolor'i / 'stop'i / 'style'i
                                        / 'unknown'i

TagName = $([a-zA-Z_\-] [a-zA-Z0-9:_\-]*)

AttrName = $([a-zA-Z_\-] [a-zA-Z0-9:_\-]*)

Symbol = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

HTMLDomVarName = $([a-zA-Z_$][a-zA-Z_$0-9]*)

whitespace "required space characters" = [ \t\u000C]+ / NL

__ "space characters" = [ \t\u000C]* / NL*

NL "new line" = v:[\r\n]+ { return { section: 'ExtHTMLDocument', type: 'NEW_LINE', value: v, attrs:[], dynamic_attrs:[], event_attrs:[], children:[], location: location() }; }