/**
 * Document is just a collection of elements.
 */
Document = __ nodes:Element* { return nodes; }

/**
 * Elements - https://www.w3.org/TR/html5/syntax.html#elements-0
 * Need to add custom HTML component (name-complement)
 * Text / See if it is necessary
 */
Element  = NL / RawText / Nested / SelfClose / Comment / ExtHTMLComment / DocType / Component / DynamicTextNode / TextNode

RawText  = Script / Style / Textarea / Title / PlainText

Script    "script"    = '<script'i    attrs:Attributes* '>' __ content:(ch:(!('</script'i    __ '>') c:. { return c; })*) __ '</script'i    __ '>' __ { attrs = attrs[0] || []; return { type: 'SCRIPT_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
Style     "style"     = '<style'i     attrs:Attributes* '>' __ content:(ch:(!('</style'i     __ '>') c:. { return c; })*) __ '</style'i     __ '>' __ { attrs = attrs[0] || []; return { type: 'STYLE_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
Textarea  "textarea"  = '<textarea'i  attrs:Attributes* '>' __ content:(ch:(!('</textarea'i  __ '>') c:. { return c; })*) __ '</textarea'i  __ '>' __ { attrs = attrs[0] || []; return { type: 'TEXTAREA_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
Title     "title"     = '<title'i     attrs:Attributes* '>' __ content:(ch:(!('</title'i     __ '>') c:. { return c; })*) __ '</title'i     __ '>' __ { attrs = attrs[0] || []; return { type: 'TITLE_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
PlainText "plaintext" = '<plaintext'i attrs:Attributes* '>' __ content:(ch:(!('</plaintext'i __ '>') c:. { return c; })*) __ '</plaintext'i __ '>' __ { attrs = attrs[0] || []; return { type: 'PLAINTEXT_TAG', value: content.join(""), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }

Nested    "element"   = begin:HTMLTagBegin __ children:Element* __ end:HTMLTagEnd __ { begin.location = location(); begin.children.push(...children); return begin; }

HTMLTagBegin  "begin tag" = '<'  name:HTMLTagName attrs:Attributes* '>' { return { type: 'NESTED_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
HTMLTagEnd    "end tag"   = '</' name:HTMLTagName __               '>'

TagBegin  "begin tag" = '<'  name:TagName attrs:Attributes* '>' { attrs = attrs[0] || []; return { type: 'NESTED_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
TagEnd    "end tag"   = '</' name:TagName __               '>'


/**
 * Void element (with self closing tag, w/o content)
 * - 'area'i / 'base'i / 'br'i / 'col'i / 'embed'i / 'hr'i / 'img'i / 'input'i / 'keygen'i / 'link'i / 'meta'i / 'param'i / 'source'i / 'track'i / 'wbr'i
 */
SelfClose "self close element" = '<' name:SelfCloseTagName __ attrs:Attributes __ SelfCloseTag __ { return { type: 'SELF_CLOSE_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }

Component "component" = NestedComponent / SelfCloseComponent

NestedComponent = begin:TagBegin __ children:Element* __ end:TagEnd __ { return { type: 'COMPONENT', value: begin.value, attrs:[...begin.attrs], dynamic_attrs:[...begin.dynamic_attrs], event_attrs:[...begin.event_attrs], directives:[], children:[...children], location: location() }; }

SelfCloseComponent = '<' name:TagName attrs:Attributes* SelfCloseTag __ { attrs = attrs[0] || []; return { type: 'COMPONENT', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
					
 
Comment   "comment"   = '<!--' text:CommentText '-->' __ { return { type: 'COMMENT_TEXT', value: text, location: location()} }

ExtHTMLComment "ExtHTML comment" = comments:(SingleLineComment / MultipleLineComment) { return comments; }

SingleLineComment "single line comment" = ( '//' / '#' ) c:(!NL .)* { return { type: 'SINGLE_LINE_COMMENT', value: c.map(aV =>{ return aV[1]}).join(""), location: location() } }

MultipleLineComment "multiple line comment" = OpenMultipleLineComment text:(!CloseMultipleLineComment .)* { return { type: 'MULTIPLE_LINE_COMMENT', value: text.map(aV =>{ return aV[1]}).join(""), location: location() } }

OpenMultipleLineComment = '/*'

CloseMultipleLineComment = '*/'

CommentText = text:(!'-->' .)* { return text.map(function(v,idx,aOrigin){ return v.join(""); }).join(""); } 

DocType   "doctype"   = '<!DOCTYPE'i __ root:Symbol __ type:('public'i / 'system'i)? __ text:String* '>' __

GeneralCloseTag = SelfCloseTag / CloseTag

SelfCloseTag = '/>' __

CloseTag = '>' __


TextNode "text node" = v:Text { return { type: 'TEXT_NODE', value: v.join(""), attrs:[], event_attrs:[], directives:[], children:[], location: location() }; }

DynamicTextNode "dynamic text node" =  v:DynamicText { return { type: 'DYNAMIC_TEXT_NODE', value: v, attrs:[], event_attrs:[], directives:[], children:[], location: location() }; }

DynamicText "dynamic text" = v:VariableQuoteString { return v; }

Text "text"
  = ch:(c:[^<] &VariableQuoteString { return c })+
  / ch:(!HTMLTagEnd !TagEnd !SelfClose !Comment !DocType !DynamicTextNode !Component !Nested !RawText c:.{ return c })+

/**
 * Element attributes
 */
Attributes = ___ attrs:( DynamicAttribute / EventAttribute / StaticAttribute)* __ &GeneralCloseTag __ { return attrs; }

StaticAttribute "attribute" = name:AttrName	 __ text:(__ '=' __ s:DoubleQuoteString)?  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr"}}

DynamicAttribute "dynamic attribute" = name:AttrName __ text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr"}}

EventAttribute "event attribute" = '@'name:AttrName __ text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr"}}

HTMLAttribute "html attribute" = LegacyHtmlAttrName 
								/ CurrentHtmlAttrName

LegacyHtmlAttrName = 'background'i / 'bgcolor'i / 'border'i / 'color'i / 'height'i / 'manifest'i / 'width'i

CurrentHtmlAttrName = 'accept-charset'i / 'accesskey'i / 'action'i / 'align'i / 'allow'i / 'alt'i / 'async'i
					   / 'autocapitalize'i / 'autocomplete'i / 'autofocus'i / 'autoplay'i / 'buffered'i
                       / 'capture'i /'challenge'i / 'charset'i / 'checked'i / 'cite'i / 'class'i / 'code'i
                       / 'codebase'i / 'cols'i / 'colspan'i / 'content'i / 'contenteditable'i / 'contextmenu'i
                       / 'controls'i / 'coords'i / 'crossorigin'i / 'csp'i / 'data'i / 'data-*'i /'datetime'i
                       / 'decoding'i / 'default'i / 'defer'i / 'dir'i / 'dirname'i / 'disabled'i / 'download'i
                       / 'draggable'i / 'dropzone'i / 'enctype'i / 'enterkeyhint'i / 'for'i / 'form'i / 'formaction'i
                       / 'formenctype'i / 'formmethod'i / 'formnovalidate'i / 'formtarget'i / 'headers'i / 'hidden'i
                       / 'high'i / 'href'i / 'hreflang'i / 'http-equiv'i / 'icon'i / 'id'i / 'importance'i
                       / 'integrity'i / 'intrinsicsize'i / 'inputmode'i / 'ismap'i / 'itemprop'i / 'keytype'i / 'kind'i
                       / 'label'i / 'lang'i / 'language'i / 'loading'i / 'list'i / 'loop'i / 'low'i / 'max'i / 'maxlength'i
                       / 'minlength'i / 'media'i / 'method'i / 'min'i / 'multiple'i / 'muted'i / 'name'i / 'novalidate'i
                       / 'open'i / 'optimum'i / 'pattern'i / 'ping'i / 'placeholder'i / 'poster'i / 'preload'i / 'radiogroup'i
                       / 'readonly'i / 'referrerpolicy'i / 'rel'i / 'required'i / 'reversed'i / 'rows'i / 'rowspan'i / 'sandbox'i
                       / 'scope'i / 'scoped'i / 'selected'i / 'shape'i / 'size'i / 'sizes'i / 'slot'i / 'span'i / 'spellcheck'i
                       / 'src'i / 'srcdoc'i / 'srclang'i / 'srcset'i / 'start'i / 'step'i / 'style'i / 'summary'i / 'tabindex'i
                       / 'target'i / 'title'i / 'translate'i / 'type'i / 'usemap'i / 'value'i / 'wrap'i

/**
 * String - single, double, w/o quotes
 */
String "string"
  = DoubleQuoteString
  / SingleQuoteString
  / ch:([^"'<>` ]+)      __ { return ch.join(""); }
  
  
DoubleQuoteString = '"'  ch:([^"]*)      '"'  __ { return ch.join(""); }

SingleQuoteString = '\'' ch:([^']*)      '\'' __ { return ch.join(""); }

VariableQuoteString = '{' ch:([^}]*) '}' { return ch.join(""); }


SelfCloseTagName =  'area'i / 'base'i / 'br'i / 'col'i / 'embed'i / 'hr'i / 'img'i / 'input'i / 'link'i
	/ 'meta'i / 'param'i / 'source'i / 'track'i / 'wbr'i / 'command'i / 'keygen'i /'menuitem'i

HTMLTagName = Html4ExclusivesTagName / Html5TagName

Html4ExclusivesTagName = 'acronym'i / 'applet'i / 'big'i / 'center'i / 'dir'i / 'font'i / 'frameset'i / 'frame'i
	/ 'noframes'i / 'strike'i / 'tt'i

Html5TagName = 'abbr'i / 'address'i / 'area'i / 'article'i / 'aside'i / 'audio'i / 'a'i / 'base'i
	/ 'basefont'i / 'bdi'i / 'bdo'i / 'blockquote'i / 'body'i / 'br'i / 'button'i / 'b'i / 'canvas'i / 'caption'i
    / 'cite'i / 'code'i / 'col'i / 'colgroup'i / 'data'i / 'datalist'i / 'dd'i / 'del'i / 'details'i
    / 'dfn'i / 'dialog'i / 'div'i / 'dl'i / 'dt'i / 'em'i / 'embed'i / 'fieldset'i / 'figcaption'i
    / 'figure'i / 'footer'i / 'form'i / 'h1'i / 'h2'i / 'h3'i / 'h4'i / 'h5'i / 'h6'i / 'head'i / 'header'i
    / 'hr'i / 'html'i / 'iframe'i / 'img'i / 'input'i / 'ins'i / 'i'i / 'kbd'i / 'label'i / 'legend'i
    / 'link'i / 'li'i / 'main'i / 'map'i / 'mark'i / 'meta'i / 'meter'i / 'nav'i / 'noscript'i
    / 'object'i / 'ol'i / 'optgroup'i / 'option'i / 'output'i / 'p'i / 'param'i / 'picture'i / 'pre'i
    / 'progress'i / 'q'i / 'rp'i / 'rt'i / 'ruby'i / 'samp'i / 'script'i / 'section'i / 'select'i
    / 'small'i / 'source'i / 'span'i / 'strong'i / 'sub'i / 'summary'i / 'sup'i / 'svg'i / 's'i
    / 'table'i / 'tbody'i / 'td'i / 'template'i / 'tfoot'i / 'th'i / 'thead'i / 'time'i
    / 'track'i / 'tr'i  / 'ul'i / 'u'i / 'var'i / 'video'i / 'wbr'i

TagName = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

AttrName = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

Symbol = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

___ "required space characters" = [ \t\u000C]+ / NL

__ "space characters" = [ \t\u000C]* / NL*

NL "new line" = v:[\r\n]+ { return { type: 'NEW_LINE', value: v, attrs:[], dynamic_attrs:[], event_attrs:[], directives:[], children:[], location: location() }; }
