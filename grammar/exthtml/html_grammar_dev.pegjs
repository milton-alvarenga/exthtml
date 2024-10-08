Code = ExtHTML / ExtHTMLDocument

ExtHTML = statements

statements = statement+

statement = compound_stmt / simple_stmts / drall_stmts

drall_stmts = ExtFrontend / ExtBackend / ExtSQL / ExtRoutine

compound_stmt = 'pass'//function_def / if_stmt / class_def / with_stmt / for_stmt / try_stmt / match_stmt / while_stmt

simple_stmts = 'pass'

ExtFrontend = ExtRouter / ExtCSS / ExtVIEW

ExtBackend = ExtGO / ExtJS / ExtPHP

ExtSQL = ExtSQLStreamVar __ '=' __ 'DB::' DrallExtSQL / SQL

ExtRouter = 'ROUTER::'

ExtVIEW = 'VIEW::' __ content:ExternalLanguageContent __ { return content; }

ExtCSS = 'CSS::' __ content:ExternalLanguageContent __ { return content; }

ExtGO = 'GO::' __ content:ExternalLanguageContent __ { return content; }

ExtJS = 'JS::' __ content:ExternalLanguageContent __ { return content; }

ExtPHP = 'PHP::' __ content:ExternalLanguageContent __ { return content; }

ExtRoutine = SimpleExtRoutine / BlockExtRoutine

SimpleExtRoutine = '#%' name:VarName __ { return name }

BlockExtRoutine = '#%' name:VarName __ '{' '}' __ { return name }

ExternalLanguageContent
  = chars:($ExternalLanguageContentNestedBraces*) { return chars }

ExternalLanguageContentNestedBraces
  = "{" ExternalLanguageContent "}"     // Match balanced braces recursively
  / !"}" .                              // Match any character except the closing brace of the outermost level


VarName = $([a-zA-Z_][a-zA-Z0-9_]*)

ExtSQLStreamVar = ExtSQLStreamSingleVar / ExtSQLStreamMultipleVar

ExtSQLStreamSingleVar = '@' VarName

ExtSQLStreamMultipleVar = '@{' __ name:VarName names:(',' __ VarName)* __'}' { names = (names.length) ? names.map(o=>o[2]) : []; return {names:[name,...names]} }

DrallExtSQL = DrallExtSQLStandard / DrallExtSQLNew / DrallExtSQLOptimized

DrallExtSQLStandard = DrallExtSQLStandardTable 'todo'

DrallExtSQLStandardTable = table:SQLTableName / '{' __ table:SQLTableName tables:(',' __ SQLTableName)* __ '}'

/* see this classification */
/* https://trello.com/c/rYgLLi5U/1195-devblog-pesquisar-e-escrever-sobre */
SQL = 	SQLDataDefinitionStatements
        / SQLDataManipulationStatements
        / SQLTransactionalAndLockingStatements
        / SQLReplicationStatements
        / SQLPreparedStatements
        / SQLCompoundStatementSyntax
        / SQLDatabaseAdministrationStatements
        / SQLUtilityStatements

/* https://dev.mysql.com/doc/refman/8.0/en/sql-data-definition-statements.html */
SQLDataDefinitionStatements = 	SQLDataDefinitionStatementsAlter / 
								                SQLDataDefinitionStatementsCreate /
                                SQLDataDefinitionStatementsDrop /
                                SQLDataDefinitionStatementsRename /
                                SQLDataDefinitionStatementsTruncate

/* https://dev.mysql.com/doc/refman/8.0/en/sql-data-manipulation-statements.html */
SQLDataManipulationStatements = DrallExtSQLStandardSELECT


/* https://dev.mysql.com/doc/refman/8.0/en/sql-transactional-statements.html */
SQLTransactionalAndLockingStatements = 	SQLTransactionalAndLockingStatementsBegin /
									  	SQLTransactionalAndLockingStatementsCommit /
                                        SQLTransactionalAndLockingStatementsRollback /
                                        SQLTransactionalAndLockingStatementsStartTransaction
/*
DrallExtSQLStandardAlterTable
/ DrallExtSQLStandardAnalyze
/ DrallExtSQLStandardAttach // See who use it
/ DrallExtSQLStandardExplain
/ DrallExtSQLStandardCreateIndex
/ DrallExtSQLStandardCreateTable
/ DrallExtSQLStandardCreateTrigger
/ DrallExtSQLStandardCreateView
/ DrallExtSQLStandardCreateVirtualTable // See who use it
/ DrallExtSQLStandardDelete
/ DrallExtSQLStandardDetach // See who use it
/ DrallExtSQLStandardDrop
/ DrallExtSQLStandardInsert
/ DrallExtSQLStandardPragma // See who use it
/ DrallExtSQLStandardReindex // See who use it
/ DrallExtSQLStandardRelease // See who use it

/ DrallExtSQLStandardSavepoint
/ 
/ DrallExtSQLStandardUpdate
/ DrallExtSQLStandardVaccuum
*/

SQLTransactionalAndLockingStatementsBegin = 'todo'
SQLTransactionalAndLockingStatementsCommit = 'todo'
SQLTransactionalAndLockingStatementsRollback = 'todo'
SQLTransactionalAndLockingStatementsStartTransaction = 'todo'

/* https://dev.mysql.com/doc/refman/8.0/en/sql-replication-statements.html */
SQLReplicationStatements = "TODO"

/* https://dev.mysql.com/doc/refman/8.0/en/sql-prepared-statements.html */
SQLPreparedStatements = "TODO"

/* https://dev.mysql.com/doc/refman/8.0/en/sql-compound-statements.html */
SQLCompoundStatementSyntax = 'TODO'

/* https://dev.mysql.com/doc/refman/8.0/en/sql-server-administration-statements.html */
SQLDatabaseAdministrationStatements = 	'TODO' 

/* https://dev.mysql.com/doc/refman/8.0/en/sql-utility-statements.html */
SQLUtilityStatements = 	SQLUtilityStatementsDescribe /
						SQLUtilityStatementsExplain /
                        SQLUtilityStatementsHelp /
                        SQLUtilityStatementsUse


SQLDataDefinitionStatementsAlter = 'TODO' /* https://dev.mysql.com/doc/refman/8.0/en/sql-data-definition-statements.html */

SQLDataDefinitionStatementsCreate = 'TODO' /* https://dev.mysql.com/doc/refman/8.0/en/sql-data-definition-statements.html */

SQLDataDefinitionStatementsDrop = 'TODO' /* https://dev.mysql.com/doc/refman/8.0/en/sql-data-definition-statements.html */

SQLDataDefinitionStatementsRename = 'TODO' /* https://dev.mysql.com/doc/refman/8.0/en/sql-data-definition-statements.html */

SQLDataDefinitionStatementsTruncate = 'TODO' /* https://dev.mysql.com/doc/refman/8.0/en/sql-data-definition-statements.html */

SQLUtilityStatementsDescribe = 'TODO'
SQLUtilityStatementsExplain = 'TODO'
SQLUtilityStatementsHelp = 'TODO'
SQLUtilityStatementsUse = 'TODO'



DrallExtSQLStandardAlterTable = "https://www.postgresql.org/docs/current/sql-altertable.html"
//    / insert_stmt
//    / pragma_stmt / reindex_stmt / release_stmt / rollback_stmt / savepoint_stmt
//    / select_stmt
//    / update_stmt / update_stmt_limited
//    / vacuum_stmt

DrallExtSQLStandardDrop = DrallExtSQLStandardDropIndex / DrallExtSQLStandardDropTable / DrallExtSQLStandardDropTrigger / DrallExtSQLStandardDropView

DrallExtSQLStandardDropIndex = "TODO"
DrallExtSQLStandardDropTable = "TODO"
DrallExtSQLStandardDropTrigger = "TODO"
DrallExtSQLStandardDropView = "TODO"



DrallExtSQLStandardSELECT = DrallExtSQLStandardWITH? "SELECT" whitespace (DrallExtSQLStandardSELECTDistinctOrAll? whitespace)? DrallExtSQLStandardColumns DrallExtSQLStandardFrom DrallExtSQLStandardWhere? DrallExtSQLStandardGroup? DrallExtSQLStandardHaving?

/* [ ALL | DISTINCT [ ON ( expression [, ...] ) ] ] */
DrallExtSQLStandardSELECTDistinctOrAll = "ALL" / DrallExtSQLStandardSELECTDistinct

DrallExtSQLStandardSELECTDistinct = "DISTINCT" whitespace ("ON" __ "(" __ DrallExtSQLStandardExpr+ __ ")" )?

DrallExtSQLStandardExpr = "TODO"

DrallExtSQLStandardWITH = "WITH" (whitespace "RECURSIVE")? whitespace DrallExtSQLStandardWITHQuery

DrallExtSQLStandardWITHQuery = "TODO"

DrallExtSQLStandardColumns = 'TODO'

DrallExtSQLStandardFrom = 'FROM' (whitespace 'ONLY')?  SQLTableName '*'? DrallExtSQLStandardTableAS? DrallExtSQLStandardTableSample? DrallExtSQLStandardFromSubSelect?

DrallExtSQLStandardTableAS = 'AS'? whitespace SQLNameAlias __ '(' __ SQLColumnAlias __  ')'

DrallExtSQLStandardTableSample = 'TABLESAMPLE' whitespace ( 'SYSTEM' / 'BERNOULLI' ) __ '(' __ ([0-9] / [0-9]{2} / '100') __ ')' (whitespace 'REPEATABLE' '(' __ Integer __')')?

SQLColumnAlias = SQLColumnName 'AS'? SQLNameAlias ("," SQLColumnAlias)*

DrallExtSQLStandardFromSubSelect = (whitespace 'LATERAL')? whitespace '(' __ DrallExtSQLStandardSELECT __')' DrallExtSQLStandardTableAS?

SQLTableName = $([a-zA-Z_][a-zA-Z0-9_]{0,62})

SQLNameAlias = VarName

SQLColumnName = VarName

DrallExtSQLStandardWhere = whitespace 'WHERE' whitespace SQLExpression

SQLComparisonOperator = $("=") / $("!=") / $("<>") / $("<=") / $(">=") / $("<") / $(">")

SQLLogicalAndOperator = $("AND")

SQLLogicalOrOperator = $("OR")

SQLExpression = SQLColumnName

SQLComparison = SQLColumnName

DrallExtSQLStandardGroup = 'GROUP BY' whitespace ( 'ALL' / 'DISTINCT' )? DrallExtSQLStandardGroupElement

DrallExtSQLStandardGroupElement = 'TODO'

DrallExtSQLStandardHaving = 'HAVING' 'TODO'

/*
[ WITH [ RECURSIVE ] with_query [, ...] ]
SELECT [ ALL | DISTINCT [ ON ( expression [, ...] ) ] ]
    [ * | expression [ [ AS ] output_name ] [, ...] ]
    [ FROM from_item [, ...] ]
    [ WHERE condition ]
    [ GROUP BY [ ALL | DISTINCT ] grouping_element [, ...] ]
    [ HAVING condition ]
    [ WINDOW window_name AS ( window_definition ) [, ...] ]
    [ { UNION | INTERSECT | EXCEPT } [ ALL | DISTINCT ] select ]
    [ ORDER BY expression [ ASC | DESC | USING operator ] [ NULLS { FIRST | LAST } ] [, ...] ]
    [ LIMIT { count | ALL } ]
    [ OFFSET start [ ROW | ROWS ] ]
    [ FETCH { FIRST | NEXT } [ count ] { ROW | ROWS } { ONLY | WITH TIES } ]
    [ FOR { UPDATE | NO KEY UPDATE | SHARE | KEY SHARE } [ OF table_name [, ...] ] [ NOWAIT | SKIP LOCKED ] [...] ]

where from_item can be one of:

    [ ONLY ] table_name [ * ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
                [ TABLESAMPLE sampling_method ( argument [, ...] ) [ REPEATABLE ( seed ) ] ]
    [ LATERAL ] ( select ) [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    with_query_name [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    [ LATERAL ] function_name ( [ argument [, ...] ] )
                [ WITH ORDINALITY ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    [ LATERAL ] function_name ( [ argument [, ...] ] ) [ AS ] alias ( column_definition [, ...] )
    [ LATERAL ] function_name ( [ argument [, ...] ] ) AS ( column_definition [, ...] )
    [ LATERAL ] ROWS FROM( function_name ( [ argument [, ...] ] ) [ AS ( column_definition [, ...] ) ] [, ...] )
                [ WITH ORDINALITY ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    from_item join_type from_item { ON join_condition | USING ( join_column [, ...] ) [ AS join_using_alias ] }
    from_item NATURAL join_type from_item
    from_item CROSS JOIN from_item

and grouping_element can be one of:

    ( )
    expression
    ( expression [, ...] )
    ROLLUP ( { expression | ( expression [, ...] ) } [, ...] )
    CUBE ( { expression | ( expression [, ...] ) } [, ...] )
    GROUPING SETS ( grouping_element [, ...] )

and with_query is:

    with_query_name [ ( column_name [, ...] ) ] AS [ [ NOT ] MATERIALIZED ] ( select | values | insert | update | delete )
        [ SEARCH { BREADTH | DEPTH } FIRST BY column_name [, ...] SET search_seq_col_name ]
        [ CYCLE column_name [, ...] SET cycle_mark_col_name [ TO cycle_mark_value DEFAULT cycle_mark_default ] USING cycle_path_col_name ]

TABLE [ ONLY ] table_name [ * ]
*/
DrallExtSQLStandardEXPLAIN = "EXPLAIN" DrallExtSQLStandardSELECT

DrallExtSQLNew = tables:DrallExtSQLSingleTableSelector __ '.new' __ '(' __ ')' __ { return tables }

DrallExtSQLUpdate = tables:DrallExtSQLSingleTableSelector __ '.set' __ 'WHITE SET FIELD AND WHERE RULES AND RETURNING RULES TOO' __ { return tables }

DrallExtSQLOptimized = DrallExtSQLOptimizedTableSelector DrallExtSQLOptimizedTableFieldsSelector? DrallExtSQLOptimizedWhereRules? DrallExtSQLOptimizedGroupBy? DrallExtSQLOptimizedHaving? DrallExtSQLOptimizedOrderBy? DrallExtSQLOptimizedLimit? DrallExtSQLOptimizedOffset?

DrallExtSQLOptimizedTableSelector = tables:DrallExtSQLSingleTableSelector / tables:DrallExtSQLMultiTableSelector

DrallExtSQLSingleTableSelector = VarName

DrallExtSQLMultiTableSelector = '{' __ table:VarName tables:(',' __ VarName)* __ '}' { tables = (tables.length) ? tables.map(o=>o[2]) : []; return {tables:[table,...tables]} }

DrallExtSQLOptimizedTableFieldsSelector = '[' '@TODO' ']'

DrallExtSQLOptimizedWhereRules = '(' '@TODO_EXPR' ')'

DrallExtSQLOptimizedGroupBy = '.groupby' __ '(' __ '@TODO' __ ')'

DrallExtSQLOptimizedHaving = '.having' __ '(' __ '@TODO' __ ')'

DrallExtSQLOptimizedOrderBy = '.orderby' __ '(' __ '@TODO' __ ')'

DrallExtSQLOptimizedLimit = '.limit' __ '(' __ Integer __ ')'

DrallExtSQLOptimizedOffset = '.offset' __ '(' __ Integer __ ')' /* pode ser VIEW var or some other language var */

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

HTMLTagBegin  "begin tag" = '<'  name:HTMLTagName attrs:Attributes* '>' { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'HTML_NESTED_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
HTMLTagEnd    "end tag"   = '</' name:HTMLTagName __               '>'

TagBegin  "begin tag" = '<'  name:TagName attrs:Attributes* '>' { attrs = attrs[0] || []; return { section: 'ExtHTMLDocument', type: 'NESTED_TAG', value: name.toUpperCase(), attrs:attrs.filter((v) => { return v.type == 'attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), dynamic_attrs:attrs.filter((v) => { return v.type == 'dyn_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), event_attrs:attrs.filter((v) => { return v.type == 'event_attr'}).map( (v) => { delete v.type;  v.pos = attrs.indexOf(v); return v}), children:[], location: location() }; }
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
Attributes = whitespace attrs:( HTMLDomReferenceDirectiveAttribute / DynamicAttribute / EventAttribute / StaticAttribute )+ &GeneralCloseTag { return attrs; }

StaticAttribute "attribute" = ( name:HTMLAttrName text:(__ '=' __ s:DoubleQuoteString)  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "html_attribute"}} )
							  / ( name:AttrName text:(__ '=' __ s:DoubleQuoteString)  __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "custom_attribute"}} )
                              / ( '*'name:SpecificDrallDirectives text:(__ '=' __ s:DoubleQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "drall_directive"}} )
                              / ( '*'name:OptimizationReservedDirectivesOrMarcro text:(__ '=' __ s:DoubleQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"attr", category: "macro_directive"}} )

DynamicAttribute "dynamic attribute" = ( name:HTMLAttrName text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "html_attribute"}} )
									   / ( '*'name:PrimitiveLanguageReservedDirectives text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "lang_directive"}} )
                                       / ( '*'name:SpecificDrallDirectives text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "drall_directive"}} )
                                       / ( '*'name:OptimizationReservedDirectives text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "optimization_directive"}} )
                                       / ( '*'name:OptimizationReservedDirectivesOrMarcro text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "macro_directive"}} )
                                       / ( name:AttrName text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"dyn_attr", category: "custom_attribute"}} )

EventAttribute "event attribute" = ( '@'name:HTMLAttrName event_modifiers:('.'EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "html_attribute", modifiers:event_modifiers.map(v=>v[1])}} )
                                   / ( '@'name:KeyboardEvent keyboard_keys:(':'KeyboardKeys)? event_modifiers:('.'EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "html_attribute", modifiers:event_modifiers.map(v=>v[1]), keyboard_keys:keyboard_keys ? keyboard_keys.filter((v,idx)=>{return idx > 0}) : []}} ) 
                                   / ( '@'name:MouseEvent mouse_keys:(':' MouseClick )? keyboard_modifiers_keys:('.'KeyboardSystemModifiersKeys)* event_modifiers:('.' EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "html_attribute", modifiers:event_modifiers.map(v=>v[1]), mouse_keys:mouse_keys ? mouse_keys[1] : "", keyboard_modifiers_keys:keyboard_modifiers_keys ? keyboard_modifiers_keys.flat(2).filter(v=>[".",":"].indexOf(v) == -1) : []}} )
                                   / ( '@'name:MouseEvent keyboard_modifiers_keys:(':' (KeyboardSystemModifiersKeys'.')+ )? mouse_keys:MouseClick event_modifiers:('.' EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "html_attribute", modifiers:event_modifiers.map(v=>v[1]), mouse_keys:mouse_keys ? mouse_keys : "", keyboard_modifiers_keys:keyboard_modifiers_keys ? keyboard_modifiers_keys.flat(2).filter(v=>[".",":"].indexOf(v) == -1) : []}} )
								   / ( '@'name:AttrName event_modifiers:('.'EventModifiers)* text:(__ '=' __ s:VariableQuoteString) __ { return { name: name, value: (text && text[3]) ? text[3] : "", type:"event_attr", category: "custom_attribute", modifiers:event_modifiers.map(v=>v[1])}} ) 

HTMLDomReferenceDirectiveAttribute = '#'name:HTMLDomVarName __ { return { name: name, value: null, type:"dyn_attr", category: "html_dom_ref_directive"}}

PrimitiveLanguageReservedDirectives = 'if' / 'for' / 'model'

ExtendedLanguageReservedDirectives = 'else' / 'elseif' / 'forelse' / 'switch' / 'case' / 'default' / 'fallthrough'

OptimizationReservedDirectives = 'show' / 'hide'

OptimizationReservedDirectivesOrMarcro = 'idname'

SpecificDrallDirectives = 'perm' / SpecificDrallPermSimplificationDirectives / 'val' / 'mask'

SpecificDrallPermSimplificationDirectives = 'perm-group' / 'perm-mirror' / 'perm-redirect'

HTMLAttrName "html attribute" = LegacyHtmlAttrName / CurrentHtmlAttrName

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

TagName = $([a-zA-Z_\-] [a-zA-Z0-9:_\-]*)

AttrName = $([a-zA-Z_\-] [a-zA-Z0-9:_\-]*)

Symbol = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

HTMLDomVarName = $([a-zA-Z_$][a-zA-Z_$0-9]*)

whitespace "required space characters" = [ \t\u000C]+ / NL

__ "space characters" = [ \t\u000C]* / NL*

NL "new line" = v:[\r\n]+ { return { section: 'ExtHTMLDocument', type: 'NEW_LINE', value: v, attrs:[], dynamic_attrs:[], event_attrs:[], children:[], location: location() }; }