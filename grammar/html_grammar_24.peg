//INPUT
Sou um text node<!-- comp -->
Sou um {dynamic} text node
{Funcionou}
{Funcionou2}
Sou um {text dynamic} text node
Está tudo certo com {texto dynamico aqui} funcionando?
<!-- Component abaixo -->
<teste/>
<teste attr="ok"/>
<teste attr={ok}/>
<input>
<input/>
<input />
<input type="text"/>
<input type="text" />
<input type={jsvar}/>
<input type={jsvar} />
<input type="text" type2="text2"/>
<input type="text" type2="text2" />
<input type="text" type2="text2" type3="text3"/>
<input type="text" type2="text2" type3="text3" />
<textarea></textarea>
<textarea width="30"></textarea>
<textarea width="30">Inner Text</textarea>
<b></b>
{Funcionou}
<!--
<b>Inner Text</b>
<b><center></center></b>
<b><center>Inner Text</center></b>
<select obs></select>
<select obs><options></options></select>
<select obs><options>Val1</options></select>
<select obs><options></options><options></options></select>
<select obs><options>Val1</options><options>Val2</options></select>
-->






/**
 * Document is just a collection of elements.
 */
Document = __ nodes:Element* { return nodes; }

/**
 * Elements - https://www.w3.org/TR/html5/syntax.html#elements-0
 * Need to add custom HTML component (name-complement)
 * Text / See if it is necessary
 */
Element  = NL / RawText / Nested / SelfClose / Comment / DocType / Component / DynamicTextNode / TextNode

RawText  = Script / Style / Textarea / Title / PlainText

Script    "script"    = '<script'i    attrs:Attributes '>' __ content:(ch:(!('</script'i    __ '>') c:. { c })*) __ '</script'i    __ '>' __
Style     "style"     = '<style'i     attrs:Attributes '>' __ content:(ch:(!('</style'i     __ '>') c:. { c })*) __ '</style'i     __ '>' __
Textarea  "textarea"  = '<textarea'i  attrs:Attributes '>' __ content:(ch:(!('</textarea'i  __ '>') c:. { c })*) __ '</textarea'i  __ '>' __ { return { type: 'TEXTAREA', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
Title     "title"     = '<title'i     attrs:Attributes '>' __ content:(ch:(!('</title'i     __ '>') c:. { c })*) __ '</title'i     __ '>' __
PlainText "plaintext" = '<plaintext'i attrs:Attributes '>' __ content:(ch:(!('</plaintext'i __ '>') c:. { c })*) __ '</plaintext'i __ '>' __

Nested    "element"   = begin:TagBegin __ children:Element* __ end:TagEnd __ { begin.location = location(); return begin; }

TagBegin  "begin tag" = '<'  name:TagName attrs:Attributes '>' { return { type: 'NESTED_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }
TagEnd    "end tag"   = '</' name:TagName __               '>'

/**
 * Void element (with self closing tag, w/o content)
 * - 'area'i / 'base'i / 'br'i / 'col'i / 'embed'i / 'hr'i / 'img'i / 'input'i / 'keygen'i / 'link'i / 'meta'i / 'param'i / 'source'i / 'track'i / 'wbr'i
 */
SelfClose "self close element" = '<' name:SelfCloseTagName __ attrs:Attributes __ CloseTag __ { return { type: 'SELF_CLOSE_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }

Component "component" = '<' name:TagName attrs:Attributes? ('/>' / '>') __ { return { type: 'COMPONENT', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type; return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type; return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type; return v}), directives:[], children:[], location: location() }; }

Comment   "comment"   = '<!--' text:CommentText '-->' __ { return { type: 'COMMENT_TEXT', value: text, location: location()} }

CommentText = text:(!'-->' .)* { return text.map(function(v,idx,aOrigin){ return v.join(""); }).join(""); } 

DocType   "doctype"   = '<!DOCTYPE'i __ root:Symbol __ type:('public'i / 'system'i)? __ text:String* '>' __

CloseTag = ('/>' / '>') __


TextNode "text node" = v:Text { return { type: 'TEXT_NODE', value: v.join(""), attrs:[], event_attrs:[], directives:[], children:[], location: location() }; }

DynamicTextNode "dynamic text node" =  v:DynamicText { return { type: 'DYNAMIC_TEXT_NODE', value: v, attrs:[], event_attrs:[], directives:[], children:[], location: location() }; }

DynamicText "dynamic text" = __ v:VariableQuoteString __ { return v; }

Text "text"
  = ch:(c:[^<] &VariableQuoteString { return c })+
  / ch:(!TagEnd !SelfClose !Comment !DocType !VariableQuoteString !Component c:.{ return c })+

/**
 * Element attributes
 */
Attributes = __ attrs:( StaticAttribute / DynamicAttribute / EventAttribute )* __ &CloseTag __ { return attrs; }

StaticAttribute "attribute" = name:AttrName __ text:(__ '=' __ s:DoubleQuoteString)?  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr"}}

DynamicAttribute "dynamic attribute" = name:AttrName __ text:(__ '=' __ s:VariableQuoteString)? __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr"}}

EventAttribute "event attribute" = '@'name:AttrName __ text:(__ '=' __ s:String)? __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr"}}

/**
 * String - single, double, w/o quotes
 */
String "string"
  = DoubleQuoteString
  / SingleQuoteString
  / ch:([^"'<>` ]+)      __ { return ch.join(""); }
  
  
DoubleQuoteString = '"'  ch:([^"]*)      '"'  __ { return ch.join(""); }

SingleQuoteString = '\'' ch:([^']*)      '\'' __ { return ch.join(""); }

VariableQuoteString = '{' ch:([^}]*) '}' __ { return ch.join(""); }


SelfCloseTagName =  'area'i / 'base'i / 'br'i / 'col'i / 'embed'i / 'hr'i / 'img'i / 'input'i / 'link'i
	/ 'meta'i / 'param'i / 'source'i / 'track'i / 'wbr'i / 'command'i / 'keygen'i /'menuitem'i

TagName = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

AttrName = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

Symbol = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

___ "required space characters" = [ \t\u000C]+ / NL

__ "space characters" = [ \t\u000C]* / NL*

NL "new line" = v:[\r\n]+ { return { type: 'NEW_LINE', value: v, attrs:[], dynamic_attrs:[], event_attrs:[], directives:[], children:[], location: location() }; }
