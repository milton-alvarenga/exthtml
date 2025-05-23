Code = ExtHTML /* / ExtHTMLDocument */

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


TagName = $([a-zA-Z_\-] [a-zA-Z0-9:_\-]*)

AttrName = $([a-zA-Z_\-] [a-zA-Z0-9:_\-]*)

Symbol = $([a-zA-Z0-9_\-] [a-zA-Z0-9:_\-]*)

HTMLDomVarName = $([a-zA-Z_$][a-zA-Z_$0-9]*)

whitespace "required space characters" = [ \t\u000C]+ / NL

__ "space characters" = [ \t\u000C]* / NL*

NL "new line" = v:[\r\n]+ { return { section: 'ExtHTMLDocument', type: 'NEW_LINE', value: v, attrs:[], dynamic_attrs:[], event_attrs:[], children:[], location: location() }; }