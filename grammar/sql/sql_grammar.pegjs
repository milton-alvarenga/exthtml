/**
* https://github.com/antlr/grammars-v4/blob/master/sql/postgresql/PostgreSQLLexer.g4
* https://github.com/antlr/grammars-v4/blob/master/sql/postgresql/PostgreSQLParser.g4
*/


root = stmtblock

stmtblock = stmtmulti

stmtmulti = stmt? (SEMI stmt?)*

stmt
  = altereventtrigstmt
  / altercollationstmt
  / alterdatabasestmt
  / alterdatabasesetstmt
  / alterdefaultprivilegesstmt
  / alterdomainstmt
  / alterenumstmt
  / alterextensionstmt
  / alterextensioncontentsstmt
  / alterfdwstmt
  / alterforeignserverstmt
  / alterfunctionstmt
  / altergroupstmt
  / alterobjectdependsstmt
  / alterobjectschemastmt
  / alterownerstmt
  / alteroperatorstmt
  / altertypestmt
  / alterpolicystmt
  / alterseqstmt
  / altersystemstmt
  / altertablestmt
  / altertblspcstmt
  / altercompositetypestmt
  / alterpublicationstmt
  / alterrolesetstmt
  / alterrolestmt
  / altersubscriptionstmt
  / alterstatsstmt
  / altertsconfigurationstmt
  / altertsdictionarystmt
  / alterusermappingstmt
  / analyzestmt
  / callstmt
  / checkpointstmt
  / closeportalstmt
  / clusterstmt
  / commentstmt
  / constraintssetstmt
  / copystmt
  / createamstmt
  / createasstmt
  / createassertionstmt
  / createcaststmt
  / createconversionstmt
  / createdomainstmt
  / createextensionstmt
  / createfdwstmt
  / createforeignserverstmt
  / createforeigntablestmt
  / createfunctionstmt
  / creategroupstmt
  / creatematviewstmt
  / createopclassstmt
  / createopfamilystmt
  / createpublicationstmt
  / alteropfamilystmt
  / createpolicystmt
  / createplangstmt
  / createschemastmt
  / createseqstmt
  / createstmt
  / createsubscriptionstmt
  / createstatsstmt
  / createtablespacestmt
  / createtransformstmt
  / createtrigstmt
  / createeventtrigstmt
  / createrolestmt
  / createuserstmt
  / createusermappingstmt
  / createdbstmt
  / deallocatestmt
  / declarecursorstmt
  / definestmt
  / deletestmt
  / discardstmt
  / dostmt
  / dropcaststmt
  / dropopclassstmt
  / dropopfamilystmt
  / dropownedstmt
  / dropstmt
  / dropsubscriptionstmt
  / droptablespacestmt
  / droptransformstmt
  / droprolestmt
  / dropusermappingstmt
  / dropdbstmt
  / executestmt
  / explainstmt
  / fetchstmt
  / grantstmt
  / grantrolestmt
  / importforeignschemastmt
  / indexstmt
  / insertstmt
  / mergestmt
  / listenstmt
  / refreshmatviewstmt
  / loadstmt
  / lockstmt
  / notifystmt
  / preparestmt
  / reassignownedstmt
  / reindexstmt
  / removeaggrstmt
  / removefuncstmt
  / removeoperstmt
  / renamestmt
  / revokestmt
  / revokerolestmt
  / rulestmt
  / seclabelstmt
  / selectstmt
  / transactionstmt
  / truncatestmt
  / unlistenstmt
  / updatestmt
  / vacuumstmt
  / variableresetstmt
  / variablesetstmt
  / variableshowstmt
  / viewstmt


callstmt = "CALL" func_application

createrolestmt = "CREATE" "ROLE" roleid with_? optrolelist

with_ = "WITH"

optrolelist = createoptroleelem*

alteroptrolelist = alteroptroleelem*

alteroptroleelem
  = "PASSWORD" (sconst / "NULL")
  / ("ENCRYPTED" / "UNENCRYPTED") "PASSWORD" sconst
  / "INHERIT"
  / "CONNECTION" "LIMIT" signediconst
  / "VALID" "UNTIL" sconst
  / "USER" role_list
  / identifier

createoptroleelem
  = alteroptroleelem
  / "SYSID" iconst
  / "ADMIN" role_list
  / "ROLE" role_list
  / "IN" ("ROLE" / "GROUP") role_list

createuserstmt = "CREATE" "USER" roleid with_? optrolelist

alterrolestmt = "ALTER" ("ROLE" / "USER") rolespec with_? alteroptrolelist

in_database_ = "IN" "DATABASE" name

alterrolesetstmt = "ALTER" ("ROLE" / "USER") "ALL"? rolespec in_database_? setresetclause

droprolestmt = "DROP" ("ROLE" / "USER" / "GROUP") ("IF" "EXISTS")? role_list

creategroupstmt = "CREATE" "GROUP" roleid with_? optrolelist

altergroupstmt = "ALTER" "GROUP" rolespec (add_drop "USER" role_list)

add_drop = "ADD" / "DROP"

createschemastmt = "CREATE" "SCHEMA" ("IF" "NOT" "EXISTS")?
    (
      optschemaname? "AUTHORIZATION" rolespec
      / colid
    )
    optschemaeltlist

optschemaname = colid

optschemaeltlist = schema_stmt*

schema_stmt
  = createstmt
  / indexstmt
  / createseqstmt
  / createtrigstmt
  / grantstmt
  / viewstmt

variablesetstmt = "SET" ("LOCAL" / "SESSION")? set_rest

set_rest
  = "TRANSACTION" transaction_mode_list
  / "SESSION" "CHARACTERISTICS" "AS" "TRANSACTION" transaction_mode_list
  / set_rest_more

generic_set = var_name ("TO" / "=") (var_list / "DEFAULT")

set_rest_more
  = generic_set
  / var_name "FROM" "CURRENT"
  / "TIME" "ZONE" zone_value
  / "CATALOG" sconst
  / "SCHEMA" sconst
  / "NAMES" encoding_?
  / "ROLE" nonreservedword_or_sconst
  / "SESSION" "AUTHORIZATION" nonreservedword_or_sconst
  / "XML" "OPTION" document_or_content
  / "TRANSACTION" "SNAPSHOT" sconst

var_name = colid ("." colid)*

var_list = var_value ("," var_value)*

var_value
  = boolean_or_string_
  / numericonly

iso_level
  = "READ" ("UNCOMMITTED" / "COMMITTED")
  / "REPEATABLE" "READ"
  / "SERIALIZABLE"

boolean_or_string_
  = "TRUE"
  / "FALSE"
  / "ON"
  / nonreservedword_or_sconst

zone_value
  = sconst
  / identifier
  / constinterval sconst interval_?
  / constinterval "(" iconst ")" sconst
  / numericonly
  / "DEFAULT"
  / "LOCAL"

encoding_ = sconst / "DEFAULT"

nonreservedword_or_sconst = nonreservedword / sconst

variableresetstmt = "RESET" reset_rest

reset_rest
  = generic_reset
  / "TIME" "ZONE"
  / "TRANSACTION" "ISOLATION" "LEVEL"
  / "SESSION" "AUTHORIZATION"

generic_reset = var_name / "ALL"

setresetclause = "SET" set_rest / variableresetstmt

functionsetresetclause = "SET" set_rest_more / variableresetstmt

variableshowstmt
  = "SHOW" (
    var_name
    / "TIME" "ZONE"
    / "TRANSACTION" "ISOLATION" "LEVEL"
    / "SESSION" "AUTHORIZATION"
    / "ALL"
  )

constraintssetstmt = "SET" "CONSTRAINTS" constraints_set_list constraints_set_mode

constraints_set_list = "ALL" / qualified_name_list

constraints_set_mode = "DEFERRED" / "IMMEDIATE"

checkpointstmt = "CHECKPOINT"

discardstmt
  = "DISCARD" (
    "ALL"
    / "TEMP"
    / "TEMPORARY"
    / "PLANS"
    / "SEQUENCES"
  )

altertablestmt
  = "ALTER" (
    "TABLE" (
      ("IF" "EXISTS")? relation_expr (
        alter_table_cmds
        / partition_cmd
      )
      / "ALL" "IN" "TABLESPACE" name (
        "OWNED" "BY" role_list
      )? "SET" "TABLESPACE" name nowait_?
    )
    / "INDEX" (
      ("IF" "EXISTS")? qualified_name (
        alter_table_cmds
        / index_partition_cmd
      )
      / "ALL" "IN" "TABLESPACE" name (
        "OWNED" "BY" role_list
      )? "SET" "TABLESPACE" name nowait_?
    )
    / "SEQUENCE" ("IF" "EXISTS")? qualified_name alter_table_cmds
    / "VIEW" ("IF" "EXISTS")? qualified_name alter_table_cmds
    / "MATERIALIZED" "VIEW" (
      ("IF" "EXISTS")? qualified_name alter_table_cmds
      / "ALL" "IN" "TABLESPACE" name (
        "OWNED" "BY" role_list
      )? "SET" "TABLESPACE" name nowait_?
    )
    / "FOREIGN" "TABLE" ("IF" "EXISTS")? relation_expr alter_table_cmds
  )

alter_table_cmds = alter_table_cmd ("," alter_table_cmd)*

partition_cmd
  = (
    "ATTACH" "PARTITION" qualified_name partitionboundspec
    / "DETACH" "PARTITION" qualified_name
  )

index_partition_cmd = "ATTACH" "PARTITION" qualified_name

alter_table_cmd
  = (
    "ADD" (
      columnDef
      / "COLUMN" (
        columnDef
        / "IF" "NOT" "EXISTS" columnDef
      )
      / "IF" "NOT" "EXISTS" columnDef
    )
    / "ALTER" (
      "COLUMN"? colid (
        alter_column_default
        / "DROP" "NOT" "NULL"
        / "SET" "NOT" "NULL"
        / "DROP" "EXPRESSION"
        / "DROP" "EXPRESSION" "IF" "EXISTS"
        / "SET" "STATISTICS" signediconst
      )
      / iconst "SET" "STATISTICS" signediconst
      / "COLUMN"? colid (
        "SET" reloptions
        / "RESET" reloptions
        / "SET" "STORAGE" colid
        / "ADD" "GENERATED" generated_when "AS" "IDENTITY" optparenthesizedseqoptlist?
        / alter_identity_column_option_list
        / "DROP" "IDENTITY"
        / "DROP" "IDENTITY" "IF" "EXISTS"
      )
    )
    / "DROP" (
      "COLUMN"? (
        "IF" "EXISTS" colid drop_behavior?
        / colid drop_behavior?
      )
    )
    / "ALTER" "COLUMN"? colid (
      "SET" "DATA"? "TYPE" typename collate_clause? alter_using?
      / alter_generic_options
    )
    / "ADD" tableconstraint
    / "ALTER" "CONSTRAINT" name constraintattributespec
    / "VALIDATE" "CONSTRAINT" name
    / "DROP" "CONSTRAINT" (
      "IF" "EXISTS" name drop_behavior?
      / name drop_behavior?
    )
    / "SET" "WITHOUT" "OIDS"
    / "CLUSTER" "ON" name
    / "SET" "WITHOUT" "CLUSTER"
    / "SET" ("LOGGED" / "UNLOGGED")
    / "ENABLE" (
      "TRIGGER" (
        name
        / "ALL"
        / "USER"
        / "ALWAYS" name
        / "REPLICA" name
      )
      / "RULE" (
        name
        / "ALWAYS" name
        / "REPLICA" name
      )
      / "ROW" "LEVEL" "SECURITY"
    )
    / "DISABLE" (
      "TRIGGER" (
        name
        / "ALL"
        / "USER"
      )
      / "RULE" name
      / "ROW" "LEVEL" "SECURITY"
    )
    / "FORCE" "ROW" "LEVEL" "SECURITY"
    / "NO" "FORCE" "ROW" "LEVEL" "SECURITY"
    / "INHERIT" qualified_name
    / "NO" "INHERIT" qualified_name
    / "OF" any_name
    / "NOT" "OF"
    / "OWNER" "TO" rolespec
    / "SET" "TABLESPACE" name
    / "SET" reloptions
    / "RESET" reloptions
    / "REPLICA" "IDENTITY" replica_identity
    / alter_generic_options
  )

alter_column_default
  = (
    "SET" "DEFAULT" a_expr
    / "DROP" "DEFAULT"
  )

drop_behavior_
  = "CASCADE"
  / "RESTRICT"

collate_clause_ = "COLLATE" any_name

alter_using = "USING" a_expr

replica_identity
  = (
    "NOTHING"
    / "FULL"
    / "DEFAULT"
    / "USING" "INDEX" name
  )

reloptions = "(" reloption_list ")"

reloptions_ = "WITH" reloptions

reloption_list  = reloption_elem ("," reloption_elem)*

reloption_elem = colLabel ("=" def_arg / "." colLabel ("=" def_arg)?)?

alter_identity_column_option_list = alter_identity_column_option+

alter_identity_column_option
  = (
    "RESTART" ("WITH"? numericonly)?
    / "SET" (
      seqoptelem
      / "GENERATED" generated_when
    )
  )

partitionboundspec
  = (
    "FOR" "VALUES" (
      "WITH" "(" hash_partbound ")"
      / "IN" "(" expr_list ")"
      / "FROM" "(" expr_list ")" "TO" "(" expr_list ")"
    )
    / "DEFAULT"
  )

hash_partbound_elem = nonreservedword iconst

hash_partbound = hash_partbound_elem ("," hash_partbound_elem)*

altercompositetypestmt = "ALTER" "TYPE" any_name alter_type_cmds

alter_type_cmds = alter_type_cmd ("," alter_type_cmd)*

alter_type_cmd
  = (
    "ADD" "ATTRIBUTE" tablefuncelement drop_behavior_?
    / "DROP" "ATTRIBUTE" ("IF" "EXISTS")? colid drop_behavior_?
    / "ALTER" "ATTRIBUTE" colid set_data_? "TYPE" typename collate_clause_? drop_behavior_?
  )

closeportalstmt = "CLOSE" (cursor_name / "ALL")

copystmt
  = (
    "COPY" (
      binary_? qualified_name column_list_? (
        "FROM" (program_? copy_file_name copy_delimiter? "WITH"? copy_options where_clause?)
      )
      / "(" preparablestmt ")" "TO" program_? copy_file_name "WITH"? copy_options
    )
  )

copy_from = "FROM" / "TO"

program_ = "PROGRAM"

copy_file_name = sconst / "STDIN" / "STDOUT"

copy_options = copy_opt_list / "(" copy_generic_opt_list ")"

copy_opt_item
  = "BINARY"
  / "FREEZE"
  / "DELIMITER" as_? sconst
  / "NULL" as_? sconst
  / "CSV"
  / "HEADER"
  / "QUOTE" as_? sconst
  / "ESCAPE" as_? sconst
  / "FORCE" "QUOTE" (columnlist / "*")
  / "FORCE" "NOT" "NULL" columnlist
  / "FORCE" "NULL" columnlist
  / "ENCODING" sconst

binary_ = "BINARY"

copy_delimiter = using_? "DELIMITER" sconst

using_ = "USING"

copy_generic_opt_list = copy_generic_opt_elem ("," copy_generic_opt_elem)*

copy_generic_opt_elem = colLabel copy_generic_opt_arg?

copy_generic_opt_arg = boolean_or_string_ / numericonly / "*" / "(" copy_generic_opt_arg_list ")"

copy_generic_opt_arg_list = copy_generic_opt_arg_list_item ("," copy_generic_opt_arg_list_item)*

copy_generic_opt_arg_list_item = boolean_or_string_

createstmt
  = "CREATE" opttemp? "TABLE"
    (
      (
        ("IF" "NOT" "EXISTS")? qualified_name
        (
          "(" opttableelementlist? ")" optinherit? optpartitionspec? table_access_method_clause? optwith? oncommitoption? opttablespace?
          / "OF" any_name opttypedtableelementlist? optpartitionspec? table_access_method_clause? optwith? oncommitoption? opttablespace?
          / "PARTITION" "OF" qualified_name opttypedtableelementlist? partitionboundspec optpartitionspec? table_access_method_clause? optwith? oncommitoption? opttablespace?
        )
      )
    )

opttemp = "TEMPORARY" / "TEMP" / ("LOCAL" ("TEMPORARY" / "TEMP")) / ("GLOBAL" ("TEMPORARY" / "TEMP")) / "UNLOGGED"

opttableelementlist = tableelementlist?

opttypedtableelementlist = "(" typedtableelementlist ")"

tableelementlist = tableelement ("," tableelement)*

typedtableelement = columnOptions / tableconstraint

columnDef = colid typename create_generic_options? colquallist

columnOptions = colid (WITH OPTIONS)? colquallist

colquallist = colconstraint*

colconstraint
  = "CONSTRAINT" name colconstraintelem
  / colconstraintelem
  / constraintattr
  / "COLLATE" any_name

colconstraintelem
  = "NOT" "NULL"
  / "NULL"
  / "UNIQUE" definition_? optconstablespace?
  / "PRIMARY" "KEY" definition_? optconstablespace?
  / "CHECK" "(" a_expr ")" no_inherit_?
  / "DEFAULT" b_expr
  / "GENERATED" generated_when "AS" (
      "IDENTITY" optparenthesizedseqoptlist?
    / "(" a_expr ")" "STORED"
  )
  / "REFERENCES" qualified_name column_list_? key_match? key_actions?

generated_when = "ALWAYS" / "BY" "DEFAULT"

constraintattr
  = "DEFERRABLE" 
  / "NOT" "DEFERRABLE" 
  / "INITIALLY" ("DEFERRED" / "IMMEDIATE")

tablelikeclause = "LIKE" qualified_name tablelikeoptionlist

tablelikeoptionlist = (("INCLUDING" / "EXCLUDING") tablelikeoption)*

tablelikeoption
  = "COMMENTS" 
  / "CONSTRAINTS" 
  / "DEFAULTS" 
  / "IDENTITY" 
  / "GENERATED" 
  / "INDEXES" 
  / "STATISTICS" 
  / "STORAGE" 
  / "ALL"

tableconstraint = ("CONSTRAINT" name)? constraintelem

constraintelem
    = CHECK OPEN_PAREN a_expr CLOSE_PAREN constraintattributespec
    / UNIQUE (
        OPEN_PAREN columnlist CLOSE_PAREN c_include_? definition_? optconstablespace? constraintattributespec
        / existingindex constraintattributespec
    )
    / PRIMARY KEY (
        OPEN_PAREN columnlist CLOSE_PAREN c_include_? definition_? optconstablespace? constraintattributespec
        / existingindex constraintattributespec
    )
    / EXCLUDE access_method_clause? OPEN_PAREN exclusionconstraintlist CLOSE_PAREN c_include_? definition_? optconstablespace? exclusionwhereclause?
        constraintattributespec
    / FOREIGN KEY OPEN_PAREN columnlist CLOSE_PAREN REFERENCES qualified_name column_list_? key_match? key_actions? constraintattributespec
    ;

no_inherit_ = NO INHERIT

column_list_ = OPEN_PAREN columnlist CLOSE_PAREN

columnlist = columnElem (COMMA columnElem)*

columnElem = colid

c_include_ = INCLUDE OPEN_PAREN columnlist CLOSE_PAREN

key_match = MATCH (FULL / PARTIAL / SIMPLE)

exclusionconstraintlist = exclusionconstraintelem (COMMA exclusionconstraintelem)*

exclusionconstraintelem = index_elem WITH (any_operator / OPERATOR OPEN_PAREN any_operator CLOSE_PAREN)

exclusionwhereclause = WHERE OPEN_PAREN a_expr CLOSE_PAREN

key_actions
    = key_update
    / key_delete
    / key_update key_delete
    / key_delete key_update

key_update = ON UPDATE key_action

key_delete = ON DELETE_P key_action

key_action
    = NO ACTION
    / RESTRICT
    / CASCADE
    / SET (NULL_P / DEFAULT)

optinherit = INHERITS OPEN_PAREN qualified_name_list CLOSE_PAREN

optpartitionspec = partitionspec

partitionspec = PARTITION BY colid OPEN_PAREN part_params CLOSE_PAREN

part_params = part_elem (COMMA part_elem)*

part_elem
    = colid collate_? class_?
    / func_expr_windowless collate_? class_?
    / OPEN_PAREN a_expr CLOSE_PAREN collate_? class_?

table_access_method_clause = USING name

optwith = WITH reloptions / WITHOUT OIDS

oncommitoption = ON COMMIT (DROP / DELETE_P ROWS / PRESERVE ROWS)

opttablespace = TABLESPACE name

optconstablespace = USING INDEX TABLESPACE name

existingindex = USING INDEX name

createstatsstmt = CREATE STATISTICS (IF_P NOT EXISTS)? any_name name_list_? ON expr_list FROM from_list

alterstatsstmt = ALTER STATISTICS (IF_P EXISTS)? any_name SET STATISTICS signediconst

createasstmt = CREATE opttemp? TABLE (IF_P NOT EXISTS)? create_as_target AS selectstmt with_data_?

create_as_target = qualified_name column_list_? table_access_method_clause? optwith? oncommitoption? opttablespace?

with_data_= WITH (DATA_P / NO DATA_P)

creatematviewstmt = CREATE optnolog? MATERIALIZED VIEW (IF_P NOT EXISTS)? create_mv_target AS selectstmt with_data_?

create_mv_target = qualified_name column_list_? table_access_method_clause? reloptions_? opttablespace?

optnolog = UNLOGGED

refreshmatviewstmt  = REFRESH MATERIALIZED VIEW concurrently_? qualified_name with_data_?

createseqstmt = CREATE opttemp? SEQUENCE (IF_P NOT EXISTS)? qualified_name optseqoptlist?

alterseqstmt = ALTER SEQUENCE (IF_P EXISTS)? qualified_name seqoptlist

optseqoptlist  = seqoptlist

optparenthesizedseqoptlist = OPEN_PAREN seqoptlist CLOSE_PAREN

seqoptlist = seqoptelem+

seqoptelem
    = AS simpletypename
    / CACHE numericonly
    / CYCLE
    / INCREMENT by_? numericonly
    / MAXVALUE numericonly
    / MINVALUE numericonly
    / NO (MAXVALUE | MINVALUE | CYCLE)
    / OWNED BY any_name
    / SEQUENCE NAME_P any_name
    / START with_? numericonly
    / RESTART with_? numericonly?

by_ = BY

numericonly
    = fconst
    / PLUS fconst
    / MINUS fconst
    / signediconst

numericonly_list = numericonly (COMMA numericonly)*

createplangstmt = CREATE or_replace_? trusted_? procedural_? LANGUAGE name (
        HANDLER handler_name inline_handler_? validator_?
    )?

trusted_ = TRUSTED

handler_name = name attrs?

inline_handler_ = INLINE_P handler_name

validator_clause = VALIDATOR handler_name / NO VALIDATOR

validator_ = validator_clause

procedural_ = PROCEDURAL

createtablespacestmt = CREATE TABLESPACE name opttablespaceowner? LOCATION sconst reloptions_?

opttablespaceowner = OWNER rolespec

droptablespacestmt = DROP TABLESPACE (IF_P EXISTS)? name

createextensionstmt = CREATE EXTENSION (IF_P NOT EXISTS)? name with_? create_extension_opt_list

create_extension_opt_list = create_extension_opt_item*

create_extension_opt_item
    = SCHEMA name
    / VERSION_P nonreservedword_or_sconst
    / FROM nonreservedword_or_sconst
    / CASCADE

alterextensionstmt = ALTER EXTENSION name UPDATE alter_extension_opt_list

alter_extension_opt_list = alter_extension_opt_item*

alter_extension_opt_item = TO nonreservedword_or_sconst

alterextensioncontentsstmt
    = ALTER EXTENSION name add_drop object_type_name name
    / ALTER EXTENSION name add_drop object_type_any_name any_name
    / ALTER EXTENSION name add_drop AGGREGATE aggregate_with_argtypes
    / ALTER EXTENSION name add_drop CAST OPEN_PAREN typename AS typename CLOSE_PAREN
    / ALTER EXTENSION name add_drop DOMAIN_P typename
    / ALTER EXTENSION name add_drop FUNCTION function_with_argtypes
    / ALTER EXTENSION name add_drop OPERATOR operator_with_argtypes
    / ALTER EXTENSION name add_drop OPERATOR CLASS any_name USING name
    / ALTER EXTENSION name add_drop OPERATOR FAMILY any_name USING name
    / ALTER EXTENSION name add_drop PROCEDURE function_with_argtypes
    / ALTER EXTENSION name add_drop ROUTINE function_with_argtypes
    / ALTER EXTENSION name add_drop TRANSFORM FOR typename LANGUAGE name
    / ALTER EXTENSION name add_drop TYPE_P typename

createfdwstmt = CREATE FOREIGN DATA_P WRAPPER name fdw_options_? create_generic_options?

fdw_option
    = HANDLER handler_name
    / NO HANDLER
    / VALIDATOR handler_name
    / NO VALIDATOR

fdw_options = fdw_option+
    ;

fdw_options_ = fdw_options

alterfdwstmt
    = ALTER FOREIGN DATA_P WRAPPER name fdw_options_? alter_generic_options
    / ALTER FOREIGN DATA_P WRAPPER name fdw_options

create_generic_options = OPTIONS OPEN_PAREN generic_option_list CLOSE_PAREN

generic_option_list = generic_option_elem (COMMA generic_option_elem)*

alter_generic_options = OPTIONS OPEN_PAREN alter_generic_option_list CLOSE_PAREN

alter_generic_option_list = alter_generic_option_elem (COMMA alter_generic_option_elem)*

alter_generic_option_elem
    = generic_option_elem
    / SET generic_option_elem
    / ADD_P generic_option_elem
    / DROP generic_option_name

generic_option_elem = generic_option_name generic_option_arg

generic_option_name = colLabel

generic_option_arg = sconst

createforeignserverstmt
    = CREATE SERVER name type_? foreign_server_version_? FOREIGN DATA_P WRAPPER name create_generic_options?
    / CREATE SERVER IF_P NOT EXISTS name type_? foreign_server_version_? FOREIGN DATA_P WRAPPER name create_generic_options?
  
type_ = TYPE_P sconst

foreign_server_version = VERSION_P (sconst / NULL_P)

foreign_server_version_ = foreign_server_version

alterforeignserverstmt = ALTER SERVER name (alter_generic_options / foreign_server_version alter_generic_options?)

createforeigntablestmt
    = CREATE FOREIGN TABLE qualified_name OPEN_PAREN opttableelementlist? CLOSE_PAREN optinherit? SERVER name create_generic_options?
    / CREATE FOREIGN TABLE IF_P NOT EXISTS qualified_name OPEN_PAREN opttableelementlist? CLOSE_PAREN optinherit? SERVER name create_generic_options?
    / CREATE FOREIGN TABLE qualified_name PARTITION OF qualified_name opttypedtableelementlist? partitionboundspec SERVER name create_generic_options?
    / CREATE FOREIGN TABLE IF_P NOT EXISTS qualified_name PARTITION OF qualified_name opttypedtableelementlist? partitionboundspec SERVER name create_generic_options?

importforeignschemastmt = IMPORT_P FOREIGN SCHEMA name import_qualification? FROM SERVER name INTO name create_generic_options?

import_qualification_type = LIMIT TO / EXCEPT

import_qualification = import_qualification_type OPEN_PAREN relation_expr_list CLOSE_PAREN

createusermappingstmt
    = CREATE USER MAPPING FOR auth_ident SERVER name create_generic_options?
    / CREATE USER MAPPING IF_P NOT EXISTS FOR auth_ident SERVER name create_generic_options?

auth_ident
    = rolespec
    / USER



























Operator = (OperatorCharacter / PlusMinus / Slash)+ / [+-]

PlusMinus = "+" / "-"

OperatorCharacter = [*/<>=~!@%^&|`?#]


OperatorEndingWithPlusMinus = (OperatorCharacterNotAllowPlusMinusAtEnd / "-" / "/")* OperatorCharacterAllowPlusMinusAtEnd Operator? ("+" / "-")+

OperatorCharacterNotAllowPlusMinusAtEnd = [^+-]

OperatorCharacterAllowPlusMinusAtEnd = [~!@%^&|`?#]





Identifier = IdentifierStartChar IdentifierChar*

IdentifierStartChar = [a-zA-Z_\u00AA\u00B5\u00BA\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF\u0100-\uD7FF\uE000-\uFFFF]

IdentifierChar = StrictIdentifierChar / "$"

StrictIdentifierChar = IdentifierStartChar / [0-9]




/* Quoted Identifiers
*
*   These are divided into four separate tokens, allowing distinction of valid quoted identifiers from invalid quoted
*   identifiers without sacrificing the ability of the lexer to reliably recover from lexical errors in the input.
*/

// This is a quoted identifier which only contains valid characters but is not terminated
QuotedIdentifier = '"' (!["\u0000"] / '""')* '"'

// This is a quoted identifier which is terminated but contains a \u0000 character
UnterminatedQuotedIdentifier = '"' (!["\u0000"] / '""')*

InvalidQuotedIdentifier = InvalidUnterminatedQuotedIdentifier '"'

// This is a quoted identifier which is unterminated and contains a \u0000 character
InvalidUnterminatedQuotedIdentifier = '"' ('""' / [^"])*


/* Unicode Quoted Identifiers
 *
 *   These are divided into four separate tokens, allowing distinction of valid Unicode quoted identifiers from invalid
 *   Unicode quoted identifiers without sacrificing the ability of the lexer to reliably recover from lexical errors in
 *   the input. Note that escape sequences are never checked as part of this determination due to the ability of users
 *   to change the escape character with a UESCAPE clause following the Unicode quoted identifier.
 *
 * TODO: these rules assume "" is still a valid escape sequence within a Unicode quoted identifier.
 */
UnicodeQuotedIdentifier = "U&" QuotedIdentifier

// This is a Unicode quoted identifier which only contains valid characters but is not terminated
UnterminatedUnicodeQuotedIdentifier = "U&" UnterminatedQuotedIdentifier

// This is a Unicode quoted identifier which is terminated but contains a \u0000 character
InvalidUnicodeQuotedIdentifier = "U&" InvalidQuotedIdentifier

// This is a Unicode quoted identifier which is unterminated and contains a \u0000 character
InvalidUnterminatedUnicodeQuotedIdentifier = "U&" InvalidUnterminatedQuotedIdentifier







// String Constants (4.1.2.1)

StringConstant = UnterminatedStringConstant "'"

UnterminatedStringConstant = "'" ("''" / [^'])*

// String Constants with C-style Escapes (4.1.2.2)
BeginEscapeStringConstant = "E'"





UnicodeEscapeStringConstant = UnterminatedUnicodeEscapeStringConstant "'"

UnterminatedUnicodeEscapeStringConstant = "U&" UnterminatedStringConstant



// Dollar-quoted String Constants (4.1.2.4)
/* "The tag, if any, of a dollar-quoted string follows the same rules as an
* unquoted identifier, except that it cannot contain a dollar sign."
*/
BeginDollarStringConstant = "$" tag:Tag? "$"






// Bit-strings Constants (4.1.2.5)

// Assuming IdentifierStartChar and StrictIdentifierChar are defined elsewhere
Tag = IdentifierStartChar StrictIdentifierChar*

// Bit-string Constants
BinaryStringConstant = UnterminatedBinaryStringConstant "'"

UnterminatedBinaryStringConstant = "B'" [01]*

InvalidBinaryStringConstant = InvalidUnterminatedBinaryStringConstant "'"

InvalidUnterminatedBinaryStringConstant = "B" UnterminatedStringConstant

// Hexadecimal String Constants
HexadecimalStringConstant = UnterminatedHexadecimalStringConstant "'"

UnterminatedHexadecimalStringConstant = "X'" [0-9A-Fa-f]*

InvalidHexadecimalStringConstant = InvalidUnterminatedHexadecimalStringConstant "'"

InvalidUnterminatedHexadecimalStringConstant = "X" UnterminatedStringConstant











// Numeric Constants (4.1.2.6)
Integral = digits:Digits { return parseInt(digits.join(""), 10); }

BinaryIntegral = "0b" digits:Digits { return parseInt(digits.join(""), 2); }

OctalIntegral = "0o" digits:Digits { return parseInt(digits.join(""), 8); }

HexadecimalIntegral = "0x" digits:Digits { return parseInt(digits.join(""), 16); }

NumericFail = digits:Digits ".." { handleNumericFail(); }

Numeric = digits1:Digits "." digits2:Digits? (
      "E" sign:[+-]? digits3:Digits { 
        // Handle scientific notation
      }
    )?
  / "." digits:Digits (
      "E" sign:[+-]? digits2:Digits { 
        // Handle scientific notation
      }
    )?
  / digits:Digits "E" sign:[+-]? digits2:Digits { 
      // Handle scientific notation
    }

Digits
  = [0-9]+

PLSQLVARIABLENAME
  = ":" [A-Z_] [A-Z_0-9$]*

PLSQLIDENTIFIER
  = ':"' (
      "\\" .
    / '""'
    / [^"\\]
    )* '"'



// WHITESPACE (4.1)
Whitespace = [ \t]+ { return null; }

Newline = ("\r" "\n"? / "\n") { return null; }

/*
_ "whitespace" = [ \t\n\r]*

__ "whitespace" = [ \t\n\r]+
*/








// COMMENTS (4.1.5)
LineComment = "--" (!"\\n" .)* { return null; }

BlockComment = "/*" (!"*/" .)* "*/" { return null; }

UnterminatedBlockComment = "/*" (
      "/"* BlockComment
    / [^/*]
    / "/"+ [^/*]
    / "*"+ [^/*]
    )*
    (
      "/"*
    / "*"+
    / "/"* UnterminatedBlockComment
    )?









// META-COMMANDS
MetaCommand = "\\"


EscapeStringConstant = "E'" EscapeStringText "'"

UnterminatedEscapeStringConstant = EscapeStringText "\\"?

EscapeSequence = "\\" .


EscapeStringText = (
      "''"
    / "\\" (
        "x" [0-9a-fA-F]
      / "u" [0-9a-fA-F]{4}
      / "U" [0-9a-fA-F]{8}
      / [^xuU]
      )
    / [^'\\]
    )*

InvalidEscapeStringConstant = InvalidEscapeStringText "'"

InvalidUnterminatedEscapeStringConstant = InvalidEscapeStringText "\\"? // EOF is implicit

InvalidEscapeStringText = (
      "''"
    / "\\" .
    / [^'\\]
    )*

  
// AfterEscapeStringConstantMode
AfterEscapeStringConstant = (
      Whitespace { return { type: "Whitespace" }; }
    / Newline { 
        // Switch to AfterEscapeStringConstantWithNewlineMode
        return { type: "Newline" }; 
      }
    / "" { /* skip and pop mode */ }
    )

// AfterEscapeStringConstantWithNewlineMode
AfterEscapeStringConstantWithNewline = (
      Whitespace { return { type: "Whitespace" }; }
    / Newline { return { type: "Newline" }; }
    / "'" { /* more and switch to EscapeStringConstantMode */ }
    / "" { /* skip and pop mode */ }
    )







// Maybe there is a problem to string cotaining $ inside. Need to check
// = (!"$" . / "$" [^0-9])* 
DollarText = (!"$" . / "$" (!"$" .))*

EndDollarStringConstant = "$" tag:Tag? "$" &{ return isTag(); } { popTag(); return "DOLLAR_STRING_CONSTANT_END"; }

MetaSemi = ";" &{ return isSemiColon(); } { return "SEMI"; }

MetaOther = (!(";" / "\r" / "\n" / "\\" / "\"") .)* ( "\\" / [\r\n]+ ) { return "SEMI"; }





// KEYWORDS (Appendix C)

JSON = "JSON"i

JSON_ARRAY = "JSON_ARRAY"i

JSON_ARRAYAGG = "JSON_ARRAYAGG"i

JSON_EXISTS = "JSON_EXISTS"i

JSON_OBJECT = "JSON_OBJECT"i

JSON_OBJECTAGG = "JSON_OBJECTAGG"i

JSON_QUERY = "JSON_QUERY"i

JSON_SCALAR = "JSON_SCALAR"i

JSON_SERIALIZE = "JSON_SERIALIZE"i

JSON_TABLE = "JSON_TABLE"i

JSON_VALUE = "JSON_VALUE"i

MERGE_ACTION = "MERGE_ACTION"i

SYSTEM_USER = "SYSTEM_USER"i

ABSENT = "ABSENT"i

ASENSITIVE = "ASENSITIVE"i

ATOMIC = "ATOMIC"i

BREADTH = "BREADTH"i

COMPRESSION = "COMPRESSION"i

CONDITIONAL = "CONDITIONAL"i

DEPTH = "DEPTH"i

EMPTY_P = "EMPTY"i

FINALIZE = "FINALIZE"i

INDENT = "INDENT"i

KEEP = "KEEP"i

KEYS = "KEYS"i

NESTED = "NESTED"i

OMIT = "OMIT"i

PARAMETER = "PARAMETER"i

PATH = "PATH"i

PLAN = "PLAN"i

QUOTES = "QUOTES"i

SCALAR = "SCALAR"i

SOURCE = "SOURCE"i

STRING_P = "STRING"i

TARGET = "TARGET"i

UNCONDITIONAL = "UNCONDITIONAL"i

PERIOD = "PERIOD"

FORMAT_LA = "FORMAT_LA"












// reserved keywords

ALL = 'ALL'

ANALYSE = 'ANALYSE'

ANALYZE = 'ANALYZE'

AND = 'AND'

ANY = 'ANY'

ARRAY = 'ARRAY'

AS = 'AS'

ASC = 'ASC'

ASYMMETRIC = 'ASYMMETRIC'

BOTH = 'BOTH'

CASE = 'CASE'

CAST = 'CAST'

CHECK = 'CHECK'

COLLATE = 'COLLATE'

COLUMN = 'COLUMN'

CONSTRAINT = 'CONSTRAINT'

CREATE = 'CREATE'

CURRENT_CATALOG = 'CURRENT_CATALOG'

CURRENT_DATE = 'CURRENT_DATE'

CURRENT_ROLE = 'CURRENT_ROLE'

CURRENT_TIME = 'CURRENT_TIME'

CURRENT_TIMESTAMP = 'CURRENT_TIMESTAMP'

CURRENT_USER = 'CURRENT_USER'

DEFAULT = 'DEFAULT'

DEFERRABLE = 'DEFERRABLE'

DESC = 'DESC'

DISTINCT = 'DISTINCT'

DO = 'DO'

ELSE = 'ELSE'

EXCEPT = 'EXCEPT'

FALSE_P = 'FALSE'

FETCH = 'FETCH'

FOR = 'FOR'

FOREIGN = 'FOREIGN'

FROM = 'FROM'

GRANT = 'GRANT'

GROUP_P = 'GROUP'

HAVING = 'HAVING'

IN_P = 'IN'

INITIALLY = 'INITIALLY'

INTERSECT = 'INTERSECT'

INTO = 'INTO'

LATERAL_P = 'LATERAL'

LEADING = 'LEADING'

LIMIT = 'LIMIT'

LOCALTIME = 'LOCALTIME'

LOCALTIMESTAMP = 'LOCALTIMESTAMP'

NOT = 'NOT'

NULL_P = 'NULL'

OFFSET = 'OFFSET'

ON = 'ON'

ONLY = 'ONLY'

OR = 'OR'

ORDER = 'ORDER'

PLACING = 'PLACING'

PRIMARY = 'PRIMARY'

REFERENCES = 'REFERENCES'

RETURNING = 'RETURNING'

SELECT = 'SELECT'

SESSION_USER = 'SESSION_USER'

SOME = 'SOME'

SYMMETRIC = 'SYMMETRIC'

TABLE = 'TABLE'

THEN = 'THEN'

TO = 'TO'

TRAILING = 'TRAILING'

TRUE_P = 'TRUE'

UNION = 'UNION'

UNIQUE = 'UNIQUE'

USER = 'USER'

USING = 'USING'

VARIADIC = 'VARIADIC'

WHEN = 'WHEN'

WHERE = 'WHERE'

WINDOW = 'WINDOW'

WITH = 'WITH'









// reserved keywords (can be function or type)


AUTHORIZATION = 'AUTHORIZATION'

BINARY = 'BINARY'

COLLATION = 'COLLATION'

CONCURRENTLY = 'CONCURRENTLY'

CROSS = 'CROSS'

CURRENT_SCHEMA = 'CURRENT_SCHEMA'

FREEZE = 'FREEZE'

FULL = 'FULL'

ILIKE = 'ILIKE'

INNER_P = 'INNER'

IS = 'IS'

ISNULL = 'ISNULL'

JOIN = 'JOIN'

LEFT = 'LEFT'

LIKE = 'LIKE'

NATURAL = 'NATURAL'

NOTNULL = 'NOTNULL'

OUTER_P = 'OUTER'

OVER = 'OVER'

OVERLAPS = 'OVERLAPS'

RIGHT = 'RIGHT'

SIMILAR = 'SIMILAR'

VERBOSE = 'VERBOSE'









// non-reserved keywords

ABORT_P = 'ABORT'

ABSOLUTE_P = 'ABSOLUTE'

ACCESS = 'ACCESS'

ACTION = 'ACTION'

ADD_P = 'ADD'

ADMIN = 'ADMIN'

AFTER = 'AFTER'

AGGREGATE = 'AGGREGATE'

ALSO = 'ALSO'

ALTER = 'ALTER'

ALWAYS = 'ALWAYS'

ASSERTION = 'ASSERTION'

ASSIGNMENT = 'ASSIGNMENT'

AT = 'AT'

ATTRIBUTE = 'ATTRIBUTE'

BACKWARD = 'BACKWARD'

BEFORE = 'BEFORE'

BEGIN_P = 'BEGIN'

BY = 'BY'

CACHE = 'CACHE'

CALLED = 'CALLED'

CASCADE = 'CASCADE'

CASCADED = 'CASCADED'

CATALOG = 'CATALOG'

CHAIN = 'CHAIN'

CHARACTERISTICS = 'CHARACTERISTICS'

CHECKPOINT = 'CHECKPOINT'

CLASS = 'CLASS'

CLOSE = 'CLOSE'

CLUSTER = 'CLUSTER'

COMMENT = 'COMMENT'

COMMENTS = 'COMMENTS'

COMMIT = 'COMMIT'

COMMITTED = 'COMMITTED'

CONFIGURATION = 'CONFIGURATION'

CONNECTION = 'CONNECTION'

CONSTRAINTS = 'CONSTRAINTS'

CONTENT_P = 'CONTENT'

CONTINUE_P = 'CONTINUE'

CONVERSION_P = 'CONVERSION'

COPY = 'COPY'

COST = 'COST'

CSV = 'CSV'

CURSOR = 'CURSOR'

CYCLE = 'CYCLE'

DATA_P = 'DATA'

DATABASE = 'DATABASE'

DAY_P = 'DAY'

DEALLOCATE = 'DEALLOCATE'

DECLARE = 'DECLARE'

DEFAULTS = 'DEFAULTS'

DEFERRED = 'DEFERRED'

DEFINER = 'DEFINER'

DELETE_P = 'DELETE'

DELIMITER = 'DELIMITER'

DELIMITERS = 'DELIMITERS'

DICTIONARY = 'DICTIONARY'

DISABLE_P = 'DISABLE'

DISCARD = 'DISCARD'

DOCUMENT_P = 'DOCUMENT'

DOMAIN_P = 'DOMAIN'

DOUBLE_P = 'DOUBLE'

DROP = 'DROP'

EACH = 'EACH'

ENABLE_P = 'ENABLE'

ENCODING = 'ENCODING'

ENCRYPTED = 'ENCRYPTED'

ENUM_P = 'ENUM'

ESCAPE = 'ESCAPE'

EVENT = 'EVENT'

EXCLUDE = 'EXCLUDE'

EXCLUDING = 'EXCLUDING'

EXCLUSIVE = 'EXCLUSIVE'

EXECUTE = 'EXECUTE'

EXPLAIN = 'EXPLAIN'

EXTENSION = 'EXTENSION'

EXTERNAL = 'EXTERNAL'

FAMILY = 'FAMILY'

FIRST_P = 'FIRST'

FOLLOWING = 'FOLLOWING'

FORCE = 'FORCE'

FORWARD = 'FORWARD'

FUNCTION = 'FUNCTION'

FUNCTIONS = 'FUNCTIONS'

GLOBAL = 'GLOBAL'

GRANTED = 'GRANTED'

HANDLER = 'HANDLER'

HEADER_P = 'HEADER'

HOLD = 'HOLD'

HOUR_P = 'HOUR'

IDENTITY_P = 'IDENTITY'

IF_P = 'IF'

IMMEDIATE = 'IMMEDIATE'

IMMUTABLE = 'IMMUTABLE'

IMPLICIT_P = 'IMPLICIT'

INCLUDING = 'INCLUDING'

INCREMENT = 'INCREMENT'

INDEX = 'INDEX'

INDEXES = 'INDEXES'

INHERIT = 'INHERIT'

INHERITS = 'INHERITS'

INLINE_P = 'INLINE'

INSENSITIVE = 'INSENSITIVE'

INSERT = 'INSERT'

INSTEAD = 'INSTEAD'

INVOKER = 'INVOKER'

ISOLATION = 'ISOLATION'

KEY = 'KEY'

LABEL = 'LABEL'

LANGUAGE = 'LANGUAGE'

LARGE_P = 'LARGE'

LAST_P = 'LAST'
//LC_COLLATE			 = 'LC'_'COLLATE

//LC_CTYPE			 = 'LC'_'CTYPE

LEAKPROOF = 'LEAKPROOF'

LEVEL = 'LEVEL'

LISTEN = 'LISTEN'

LOAD = 'LOAD'

LOCAL = 'LOCAL'

LOCATION = 'LOCATION'

LOCK_P = 'LOCK'

MAPPING = 'MAPPING'

MATCH = 'MATCH'

MATCHED = 'MATCHED'

MATERIALIZED = 'MATERIALIZED'

MAXVALUE = 'MAXVALUE'

MERGE = 'MERGE'

MINUTE_P = 'MINUTE'

MINVALUE = 'MINVALUE'

MODE = 'MODE'

MONTH_P = 'MONTH'

MOVE = 'MOVE'

NAME_P = 'NAME'

NAMES = 'NAMES'

NEXT = 'NEXT'

NO = 'NO'

NOTHING = 'NOTHING'

NOTIFY = 'NOTIFY'

NOWAIT = 'NOWAIT'

NULLS_P = 'NULLS'

OBJECT_P = 'OBJECT'

OF = 'OF'

OFF = 'OFF'

OIDS = 'OIDS'

OPERATOR = 'OPERATOR'

OPTION = 'OPTION'

OPTIONS = 'OPTIONS'

OWNED = 'OWNED'

OWNER = 'OWNER'

PARSER = 'PARSER'

PARTIAL = 'PARTIAL'

PARTITION = 'PARTITION'

PASSING = 'PASSING'

PASSWORD = 'PASSWORD'

PLANS = 'PLANS'

PRECEDING = 'PRECEDING'

PREPARE = 'PREPARE'

PREPARED = 'PREPARED'

PRESERVE = 'PRESERVE'

PRIOR = 'PRIOR'

PRIVILEGES = 'PRIVILEGES'

PROCEDURAL = 'PROCEDURAL'

PROCEDURE = 'PROCEDURE'

PROGRAM = 'PROGRAM'

QUOTE = 'QUOTE'

RANGE = 'RANGE'

READ = 'READ'

REASSIGN = 'REASSIGN'

RECHECK = 'RECHECK'

RECURSIVE = 'RECURSIVE'

REF = 'REF'

REFRESH = 'REFRESH'

REINDEX = 'REINDEX'

RELATIVE_P = 'RELATIVE'

RELEASE = 'RELEASE'

RENAME = 'RENAME'

REPEATABLE = 'REPEATABLE'

REPLACE = 'REPLACE'

REPLICA = 'REPLICA'

RESET = 'RESET'

RESTART = 'RESTART'

RESTRICT = 'RESTRICT'

RETURNS = 'RETURNS'

REVOKE = 'REVOKE'

ROLE = 'ROLE'

ROLLBACK = 'ROLLBACK'

ROWS = 'ROWS'

RULE = 'RULE'

SAVEPOINT = 'SAVEPOINT'

SCHEMA = 'SCHEMA'

SCROLL = 'SCROLL'

SEARCH = 'SEARCH'

SECOND_P = 'SECOND'

SECURITY = 'SECURITY'

SEQUENCE = 'SEQUENCE'

SEQUENCES = 'SEQUENCES'

SERIALIZABLE = 'SERIALIZABLE'

SERVER = 'SERVER'

SESSION = 'SESSION'

SET = 'SET'

SHARE = 'SHARE'

SHOW = 'SHOW'

SIMPLE = 'SIMPLE'

SNAPSHOT = 'SNAPSHOT'

STABLE = 'STABLE'

STANDALONE_P = 'STANDALONE'

START = 'START'

STATEMENT = 'STATEMENT'

STATISTICS = 'STATISTICS'

STDIN = 'STDIN'

STDOUT = 'STDOUT'

STORAGE = 'STORAGE'

STRICT_P = 'STRICT'

STRIP_P = 'STRIP'

SYSID = 'SYSID'

SYSTEM_P = 'SYSTEM'

TABLES = 'TABLES'

TABLESPACE = 'TABLESPACE'

TEMP = 'TEMP'

TEMPLATE = 'TEMPLATE'

TEMPORARY = 'TEMPORARY'

TEXT_P = 'TEXT'

TRANSACTION = 'TRANSACTION'

TRIGGER = 'TRIGGER'

TRUNCATE = 'TRUNCATE'

TRUSTED = 'TRUSTED'

TYPE_P = 'TYPE'

TYPES_P = 'TYPES'

UNBOUNDED = 'UNBOUNDED'

UNCOMMITTED = 'UNCOMMITTED'

UNENCRYPTED = 'UNENCRYPTED'

UNKNOWN = 'UNKNOWN'

UNLISTEN = 'UNLISTEN'

UNLOGGED = 'UNLOGGED'

UNTIL = 'UNTIL'

UPDATE = 'UPDATE'

VACUUM = 'VACUUM'

VALID = 'VALID'

VALIDATE = 'VALIDATE'

VALIDATOR = 'VALIDATOR'
//VALUE				 = 'VALUE

VARYING = 'VARYING'

VERSION_P = 'VERSION'

VIEW = 'VIEW'

VOLATILE = 'VOLATILE'

WHITESPACE_P = 'WHITESPACE'

WITHOUT = 'WITHOUT'

WORK = 'WORK'

WRAPPER = 'WRAPPER'

WRITE = 'WRITE'

XML_P = 'XML'

YEAR_P = 'YEAR'

YES_P = 'YES'

ZONE = 'ZONE'












// non-reserved keywords (can not be function or type)

BETWEEN = 'BETWEEN'

BIGINT = 'BIGINT'

BIT = 'BIT'

BOOLEAN_P = 'BOOLEAN'

CHAR_P = 'CHAR'

CHARACTER = 'CHARACTER'

COALESCE = 'COALESCE'

DEC = 'DEC'

DECIMAL_P = 'DECIMAL'

EXISTS = 'EXISTS'

EXTRACT = 'EXTRACT'

FLOAT_P = 'FLOAT'

GREATEST = 'GREATEST'

INOUT = 'INOUT'

INT_P = 'INT'

INTEGER = 'INTEGER'

INTERVAL = 'INTERVAL'

LEAST = 'LEAST'

NATIONAL = 'NATIONAL'

NCHAR = 'NCHAR'

NONE = 'NONE'

NULLIF = 'NULLIF'

NUMERIC = 'NUMERIC'

OVERLAY = 'OVERLAY'

POSITION = 'POSITION'

PRECISION = 'PRECISION'

REAL = 'REAL'

ROW = 'ROW'

SETOF = 'SETOF'

SMALLINT = 'SMALLINT'

SUBSTRING = 'SUBSTRING'

TIME = 'TIME'

TIMESTAMP = 'TIMESTAMP'

TREAT = 'TREAT'

TRIM = 'TRIM'

VALUES = 'VALUES'

VARCHAR = 'VARCHAR'

XMLATTRIBUTES = 'XMLATTRIBUTES'

XMLCOMMENT = 'XMLCOMMENT'

XMLAGG = 'XMLAGG'

XML_IS_WELL_FORMED = 'XML_IS_WELL_FORMED'

XML_IS_WELL_FORMED_DOCUMENT = 'XML_IS_WELL_FORMED_DOCUMENT'

XML_IS_WELL_FORMED_CONTENT = 'XML_IS_WELL_FORMED_CONTENT'

XPATH = 'XPATH'

XPATH_EXISTS = 'XPATH_EXISTS'

XMLCONCAT = 'XMLCONCAT'

XMLELEMENT = 'XMLELEMENT'

XMLEXISTS = 'XMLEXISTS'

XMLFOREST = 'XMLFOREST'

XMLPARSE = 'XMLPARSE'

XMLPI = 'XMLPI'

XMLROOT = 'XMLROOT'

XMLSERIALIZE = 'XMLSERIALIZE'
//MISSED

CALL = 'CALL'

CURRENT_P = 'CURRENT'

ATTACH = 'ATTACH'

DETACH = 'DETACH'

EXPRESSION = 'EXPRESSION'

GENERATED = 'GENERATED'

LOGGED = 'LOGGED'

STORED = 'STORED'

INCLUDE = 'INCLUDE'

ROUTINE = 'ROUTINE'

TRANSFORM = 'TRANSFORM'

IMPORT_P = 'IMPORT'

POLICY = 'POLICY'

METHOD = 'METHOD'

REFERENCING = 'REFERENCING'

NEW = 'NEW'

OLD = 'OLD'

VALUE_P = 'VALUE'

SUBSCRIPTION = 'SUBSCRIPTION'

PUBLICATION = 'PUBLICATION'

OUT_P = 'OUT'

END_P = 'END'

ROUTINES = 'ROUTINES'

SCHEMAS = 'SCHEMAS'

PROCEDURES = 'PROCEDURES'

INPUT_P = 'INPUT'

SUPPORT = 'SUPPORT'

PARALLEL = 'PARALLEL'

SQL_P = 'SQL'

DEPENDS = 'DEPENDS'

OVERRIDING = 'OVERRIDING'

CONFLICT = 'CONFLICT'

SKIP_P = 'SKIP'

LOCKED = 'LOCKED'

TIES = 'TIES'

ROLLUP = 'ROLLUP'

CUBE = 'CUBE'

GROUPING = 'GROUPING'

SETS = 'SETS'

TABLESAMPLE = 'TABLESAMPLE'

ORDINALITY = 'ORDINALITY'

XMLTABLE = 'XMLTABLE'

COLUMNS = 'COLUMNS'

XMLNAMESPACES = 'XMLNAMESPACES'

ROWTYPE = 'ROWTYPE'

NORMALIZED = 'NORMALIZED'

WITHIN = 'WITHIN'

FILTER = 'FILTER'

GROUPS = 'GROUPS'

OTHERS = 'OTHERS'

NFC = 'NFC'

NFD = 'NFD'

NFKC = 'NFKC'

NFKD = 'NFKD'

UESCAPE = 'UESCAPE'

VIEWS = 'VIEWS'

NORMALIZE = 'NORMALIZE'

DUMP = 'DUMP'

ERROR = 'ERROR'

USE_VARIABLE = 'USE_VARIABLE'

USE_COLUMN = 'USE_COLUMN'

CONSTANT = 'CONSTANT'

PERFORM = 'PERFORM'

GET = 'GET'

DIAGNOSTICS = 'DIAGNOSTICS'

STACKED = 'STACKED'

ELSIF = 'ELSIF'

WHILE = 'WHILE'

FOREACH = 'FOREACH'

SLICE = 'SLICE'

EXIT = 'EXIT'

RETURN = 'RETURN'

RAISE = 'RAISE'

SQLSTATE = 'SQLSTATE'

DEBUG = 'DEBUG'

INFO = 'INFO'

NOTICE = 'NOTICE'

WARNING = 'WARNING'

EXCEPTION = 'EXCEPTION'

ASSERT = 'ASSERT'

LOOP = 'LOOP'

OPEN = 'OPEN'

FORMAT = 'FORMAT'












PARAM = "$" [0-9]+

Dollar = "$"

OpenParen = "("

CloseParen = ")"

OpenBracket = "["

CloseBracket = "]"

Comma = ","

Semi = ";"

Colon = ":"

Star = "*"

Equal = "="

Dot = "."

Plus = "+"

Minus = "-"

Slash = "/"

Caret = "^"

Lt = "<"

Gt = ">"

LessLess = "<<"

GreaterGreater = ">>"

ColonEquals = ":="

LessEquals = "<="

EqualsGreater = "=>"

GreaterEquals = ">="

DotDot = ".."

NotEquals = "<>"

Typecast = "::"

Percent = "%"