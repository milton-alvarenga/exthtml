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

auth_ident = rolespec / USER

dropusermappingstmt
    = DROP USER MAPPING FOR auth_ident SERVER name
    / DROP USER MAPPING IF_P EXISTS FOR auth_ident SERVER name

alterusermappingstmt
    = ALTER USER MAPPING FOR auth_ident SERVER name alter_generic_options

createpolicystmt
    = CREATE POLICY name ON qualified_name rowsecuritydefaultpermissive? rowsecuritydefaultforcmd? rowsecuritydefaulttorole? rowsecurityoptionalexpr? rowsecurityoptionalwithcheck?

alterpolicystmt = ALTER POLICY name ON qualified_name rowsecurityoptionaltorole? rowsecurityoptionalexpr? rowsecurityoptionalwithcheck?

rowsecurityoptionalexpr = USING OPEN_PAREN a_expr CLOSE_PAREN

rowsecurityoptionalwithcheck = WITH CHECK OPEN_PAREN a_expr CLOSE_PAREN

rowsecuritydefaulttorole = TO role_list

rowsecurityoptionaltorole = TO role_list

rowsecuritydefaultpermissive = AS identifier

rowsecuritydefaultforcmd = FOR row_security_cmd

row_security_cmd
    = ALL
    / SELECT
    / INSERT
    / UPDATE
    / DELETE_P

createamstmt = CREATE ACCESS METHOD name TYPE_P am_type HANDLER handler_name

am_type = INDEX  / TABLE

createtrigstmt
    = CREATE TRIGGER name triggeractiontime triggerevents ON qualified_name triggerreferencing? triggerforspec? triggerwhen? EXECUTE
        function_or_procedure func_name OPEN_PAREN triggerfuncargs CLOSE_PAREN
    / CREATE CONSTRAINT TRIGGER name AFTER triggerevents ON qualified_name optconstrfromtable? constraintattributespec FOR EACH ROW triggerwhen? EXECUTE
        function_or_procedure func_name OPEN_PAREN triggerfuncargs CLOSE_PAREN

triggeractiontime
    = BEFORE
    / AFTER
    / INSTEAD OF

triggerevents = triggeroneevent (OR triggeroneevent)*

triggeroneevent
    = INSERT
    / DELETE_P
    / UPDATE
    / UPDATE OF columnlist
    / TRUNCATE

triggerreferencing = REFERENCING triggertransitions

triggertransitions = triggertransition+

triggertransition = transitionoldornew transitionrowortable as_? transitionrelname

transitionoldornew = NEW / OLD

transitionrowortable = TABLE / ROW

transitionrelname = colid

triggerforspec = FOR triggerforopteach? triggerfortype

triggerforopteach = EACH

triggerfortype = ROW / STATEMENT

triggerwhen = WHEN OPEN_PAREN a_expr CLOSE_PAREN

function_or_procedure = FUNCTION / PROCEDURE

triggerfuncargs = (triggerfuncarg (COMMA triggerfuncarg)*)

triggerfuncarg
    = iconst
    / fconst
    / sconst
    / colLabel

optconstrfromtable = FROM qualified_name

constraintattributespec = constraintattributeElem*

constraintattributeElem
    = NOT DEFERRABLE
    / DEFERRABLE
    / INITIALLY IMMEDIATE
    / INITIALLY DEFERRED
    / NOT VALID
    / NO INHERIT

createeventtrigstmt
    = CREATE EVENT TRIGGER name ON colLabel EXECUTE function_or_procedure func_name OPEN_PAREN CLOSE_PAREN
    / CREATE EVENT TRIGGER name ON colLabel WHEN event_trigger_when_list EXECUTE function_or_procedure func_name OPEN_PAREN CLOSE_PAREN

event_trigger_when_list = event_trigger_when_item (AND event_trigger_when_item)*

event_trigger_when_item = colid IN_P OPEN_PAREN event_trigger_value_list CLOSE_PAREN

event_trigger_value_list = sconst (COMMA sconst)*

altereventtrigstmt = ALTER EVENT TRIGGER name enable_trigger

enable_trigger
    = ENABLE_P
    / ENABLE_P REPLICA
    / ENABLE_P ALWAYS
    / DISABLE_P

createassertionstmt = CREATE ASSERTION any_name CHECK OPEN_PAREN a_expr CLOSE_PAREN constraintattributespec

definestmt
    = CREATE or_replace_? AGGREGATE func_name aggr_args definition
    / CREATE or_replace_? AGGREGATE func_name old_aggr_definition
    / CREATE OPERATOR any_operator definition
    / CREATE TYPE_P any_name definition
    / CREATE TYPE_P any_name
    / CREATE TYPE_P any_name AS OPEN_PAREN opttablefuncelementlist? CLOSE_PAREN
    / CREATE TYPE_P any_name AS ENUM_P OPEN_PAREN enum_val_list_? CLOSE_PAREN
    / CREATE TYPE_P any_name AS RANGE definition
    / CREATE TEXT_P SEARCH PARSER any_name definition
    / CREATE TEXT_P SEARCH DICTIONARY any_name definition
    / CREATE TEXT_P SEARCH TEMPLATE any_name definition
    / CREATE TEXT_P SEARCH CONFIGURATION any_name definition
    / CREATE COLLATION any_name definition
    / CREATE COLLATION IF_P NOT EXISTS any_name definition
    / CREATE COLLATION any_name FROM any_name
    / CREATE COLLATION IF_P NOT EXISTS any_name FROM any_name

definition = OPEN_PAREN def_list CLOSE_PAREN

def_list = def_elem (COMMA def_elem)*

def_elem = colLabel (EQUAL def_arg)?

def_arg
    = func_type
    / reserved_keyword
    / qual_all_op
    / numericonly
    / sconst
    / NONE

old_aggr_definition = OPEN_PAREN old_aggr_list CLOSE_PAREN

old_aggr_list = old_aggr_elem (COMMA old_aggr_elem)*

old_aggr_elem = identifier EQUAL def_arg

enum_val_list_ = enum_val_list

enum_val_list = sconst (COMMA sconst)*

alterenumstmt
    = ALTER TYPE_P any_name ADD_P VALUE_P if_not_exists_? sconst
    / ALTER TYPE_P any_name ADD_P VALUE_P if_not_exists_? sconst BEFORE sconst
    / ALTER TYPE_P any_name ADD_P VALUE_P if_not_exists_? sconst AFTER sconst
    / ALTER TYPE_P any_name RENAME VALUE_P sconst TO sconst

if_not_exists_ = IF_P NOT EXISTS

createopclassstmt = CREATE OPERATOR CLASS any_name default_? FOR TYPE_P typename USING name opfamily_? AS opclass_item_list

opclass_item_list = opclass_item (COMMA opclass_item)*

opclass_item
    = OPERATOR iconst any_operator opclass_purpose? recheck_?
    / OPERATOR iconst operator_with_argtypes opclass_purpose? recheck_?
    / FUNCTION iconst function_with_argtypes
    / FUNCTION iconst OPEN_PAREN type_list CLOSE_PAREN function_with_argtypes
    / STORAGE typename

default_ = DEFAULT

opfamily_ = FAMILY any_name

opclass_purpose = FOR SEARCH / FOR ORDER BY any_name

recheck_= RECHECK

createopfamilystmt = CREATE OPERATOR FAMILY any_name USING name

alteropfamilystmt
    = ALTER OPERATOR FAMILY any_name USING name ADD_P opclass_item_list
    / ALTER OPERATOR FAMILY any_name USING name DROP opclass_drop_list

opclass_drop_list = opclass_drop (COMMA opclass_drop)*

opclass_drop
    = OPERATOR iconst OPEN_PAREN type_list CLOSE_PAREN
    / FUNCTION iconst OPEN_PAREN type_list CLOSE_PAREN

dropopclassstmt
    = DROP OPERATOR CLASS any_name USING name drop_behavior_?
    / DROP OPERATOR CLASS IF_P EXISTS any_name USING name drop_behavior_?

dropopfamilystmt
    = DROP OPERATOR FAMILY any_name USING name drop_behavior_?
    / DROP OPERATOR FAMILY IF_P EXISTS any_name USING name drop_behavior_?

dropownedstmt = DROP OWNED BY role_list drop_behavior_?

reassignownedstmt = REASSIGN OWNED BY role_list TO rolespec

dropstmt
    = DROP object_type_any_name IF_P EXISTS any_name_list_ drop_behavior_?
    / DROP object_type_any_name any_name_list_ drop_behavior_?
    / DROP drop_type_name IF_P EXISTS name_list drop_behavior_?
    / DROP drop_type_name name_list drop_behavior_?
    / DROP object_type_name_on_any_name name ON any_name drop_behavior_?
    / DROP object_type_name_on_any_name IF_P EXISTS name ON any_name drop_behavior_?
    / DROP TYPE_P type_name_list drop_behavior_?
    / DROP TYPE_P IF_P EXISTS type_name_list drop_behavior_?
    / DROP DOMAIN_P type_name_list drop_behavior_?
    / DROP DOMAIN_P IF_P EXISTS type_name_list drop_behavior_?
    / DROP INDEX CONCURRENTLY any_name_list_ drop_behavior_?
    / DROP INDEX CONCURRENTLY IF_P EXISTS any_name_list_ drop_behavior_?

object_type_any_name
    = TABLE
    / SEQUENCE
    / VIEW
    / MATERIALIZED VIEW
    / INDEX
    / FOREIGN TABLE
    / COLLATION
    / CONVERSION_P
    / STATISTICS
    / TEXT_P SEARCH PARSER
    / TEXT_P SEARCH DICTIONARY
    / TEXT_P SEARCH TEMPLATE
    / TEXT_P SEARCH CONFIGURATION

object_type_name
    = drop_type_name
    / DATABASE
    / ROLE
    / SUBSCRIPTION
    / TABLESPACE

drop_type_name
    = ACCESS METHOD
    / EVENT TRIGGER
    / EXTENSION
    / FOREIGN DATA_P WRAPPER
    / procedural_? LANGUAGE
    / PUBLICATION
    / SCHEMA
    / SERVER

object_type_name_on_any_name
    = POLICY
    / RULE
    / TRIGGER

any_name_list_ = any_name (COMMA any_name)*

any_name = colid attrs?

attrs = (DOT attr_name)+

type_name_list = typename (COMMA typename)*

truncatestmt = TRUNCATE table_? relation_expr_list restart_seqs_? drop_behavior_?

restart_seqs_ = CONTINUE_P IDENTITY_P / RESTART IDENTITY_P

commentstmt
    = COMMENT ON object_type_any_name any_name IS comment_text
    / COMMENT ON COLUMN any_name IS comment_text
    / COMMENT ON object_type_name name IS comment_text
    / COMMENT ON TYPE_P typename IS comment_text
    / COMMENT ON DOMAIN_P typename IS comment_text
    / COMMENT ON AGGREGATE aggregate_with_argtypes IS comment_text
    / COMMENT ON FUNCTION function_with_argtypes IS comment_text
    / COMMENT ON OPERATOR operator_with_argtypes IS comment_text
    / COMMENT ON CONSTRAINT name ON any_name IS comment_text
    / COMMENT ON CONSTRAINT name ON DOMAIN_P any_name IS comment_text
    / COMMENT ON object_type_name_on_any_name name ON any_name IS comment_text
    / COMMENT ON PROCEDURE function_with_argtypes IS comment_text
    / COMMENT ON ROUTINE function_with_argtypes IS comment_text
    / COMMENT ON TRANSFORM FOR typename LANGUAGE name IS comment_text
    / COMMENT ON OPERATOR CLASS any_name USING name IS comment_text
    / COMMENT ON OPERATOR FAMILY any_name USING name IS comment_text
    / COMMENT ON LARGE_P OBJECT_P numericonly IS comment_text
    / COMMENT ON CAST OPEN_PAREN typename AS typename CLOSE_PAREN IS comment_text

comment_text = sconst / NULL_P

seclabelstmt
    = SECURITY LABEL provider_? ON object_type_any_name any_name IS security_label
    / SECURITY LABEL provider_? ON COLUMN any_name IS security_label
    / SECURITY LABEL provider_? ON object_type_name name IS security_label
    / SECURITY LABEL provider_? ON TYPE_P typename IS security_label
    / SECURITY LABEL provider_? ON DOMAIN_P typename IS security_label
    / SECURITY LABEL provider_? ON AGGREGATE aggregate_with_argtypes IS security_label
    / SECURITY LABEL provider_? ON FUNCTION function_with_argtypes IS security_label
    / SECURITY LABEL provider_? ON LARGE_P OBJECT_P numericonly IS security_label
    / SECURITY LABEL provider_? ON PROCEDURE function_with_argtypes IS security_label
    / SECURITY LABEL provider_? ON ROUTINE function_with_argtypes IS security_label

provider_ = FOR nonreservedword_or_sconst

security_label = sconst / NULL_P

fetchstmt = FETCH fetch_args  / MOVE fetch_args

fetch_args
    = cursor_name
    / from_in cursor_name
    / NEXT from_in_? cursor_name
    / PRIOR from_in_? cursor_name
    / FIRST_P from_in_? cursor_name
    / LAST_P from_in_? cursor_name
    / ABSOLUTE_P signediconst from_in_? cursor_name
    / RELATIVE_P signediconst from_in_? cursor_name
    / signediconst from_in_? cursor_name
    / ALL from_in_? cursor_name
    / FORWARD from_in_? cursor_name
    / FORWARD signediconst from_in_? cursor_name
    / FORWARD ALL from_in_? cursor_name
    / BACKWARD from_in_? cursor_name
    / BACKWARD signediconst from_in_? cursor_name
    / BACKWARD ALL from_in_? cursor_name

from_in = FROM / IN_P

from_in_ = from_in

grantstmt = GRANT privileges ON privilege_target TO grantee_list grant_grant_option_?

revokestmt
    = REVOKE privileges ON privilege_target FROM grantee_list drop_behavior_?
    / REVOKE GRANT OPTION FOR privileges ON privilege_target FROM grantee_list drop_behavior_?

privileges
    = privilege_list
    / ALL
    / ALL PRIVILEGES
    / ALL OPEN_PAREN columnlist CLOSE_PAREN
    / ALL PRIVILEGES OPEN_PAREN columnlist CLOSE_PAREN

privilege_list = privilege (COMMA privilege)*

privilege
    = SELECT column_list_?
    / REFERENCES column_list_?
    / CREATE column_list_?
    / colid column_list_?

privilege_target
    = qualified_name_list
    / TABLE qualified_name_list
    / SEQUENCE qualified_name_list
    / FOREIGN DATA_P WRAPPER name_list
    / FOREIGN SERVER name_list
    / FUNCTION function_with_argtypes_list
    / PROCEDURE function_with_argtypes_list
    / ROUTINE function_with_argtypes_list
    / DATABASE name_list
    / DOMAIN_P any_name_list_
    / LANGUAGE name_list
    / LARGE_P OBJECT_P numericonly_list
    / SCHEMA name_list
    / TABLESPACE name_list
    / TYPE_P any_name_list_
    / ALL TABLES IN_P SCHEMA name_list
    / ALL SEQUENCES IN_P SCHEMA name_list
    / ALL FUNCTIONS IN_P SCHEMA name_list
    / ALL PROCEDURES IN_P SCHEMA name_list
    / ALL ROUTINES IN_P SCHEMA name_list

grantee_list = grantee (COMMA grantee)*

grantee = rolespec / GROUP_P rolespec

grant_grant_option_ = WITH GRANT OPTION

grantrolestmt = GRANT privilege_list TO role_list grant_admin_option_? granted_by_?

revokerolestmt
    = REVOKE privilege_list FROM role_list granted_by_? drop_behavior_?
    / REVOKE ADMIN OPTION FOR privilege_list FROM role_list granted_by_? drop_behavior_?

grant_admin_option_ = WITH ADMIN OPTION

granted_by_ = GRANTED BY rolespec

alterdefaultprivilegesstmt = ALTER DEFAULT PRIVILEGES defacloptionlist defaclaction

defacloptionlist = defacloption*

defacloption
    = IN_P SCHEMA name_list
    / FOR ROLE role_list
    / FOR USER role_list

defaclaction
    = GRANT privileges ON defacl_privilege_target TO grantee_list grant_grant_option_?
    / REVOKE privileges ON defacl_privilege_target FROM grantee_list drop_behavior_?
    / REVOKE GRANT OPTION FOR privileges ON defacl_privilege_target FROM grantee_list drop_behavior_?

defacl_privilege_target
    = TABLES
    / FUNCTIONS
    / ROUTINES
    / SEQUENCES
    / TYPES_P
    / SCHEMAS

//create index
indexstmt
    = CREATE unique_? INDEX concurrently_? index_name_? ON relation_expr access_method_clause? OPEN_PAREN index_params CLOSE_PAREN include_? reloptions_? opttablespace? where_clause?
    / CREATE unique_? INDEX concurrently_? IF_P NOT EXISTS name ON relation_expr access_method_clause? OPEN_PAREN index_params CLOSE_PAREN include_? reloptions_? opttablespace? where_clause?

unique_ = UNIQUE

single_name_ = colid

concurrently_ = CONCURRENTLY

index_name_ = name

access_method_clause = USING name

index_params = index_elem (COMMA index_elem)*

index_elem_options
    = collate_? class_? asc_desc_? nulls_order_?
    / collate_? any_name reloptions asc_desc_? nulls_order_?

index_elem
    = colid index_elem_options
    / func_expr_windowless index_elem_options
    / OPEN_PAREN a_expr CLOSE_PAREN index_elem_options

include_ = INCLUDE OPEN_PAREN index_including_params CLOSE_PAREN

index_including_params = index_elem (COMMA index_elem)*

collate_ = COLLATE any_name

class_= any_name

asc_desc_ = ASC / DESC

//TOD NULLS_LA was used
nulls_order_
    = NULLS_P FIRST_P
    / NULLS_P LAST_P

createfunctionstmt
    = CREATE or_replace_? (FUNCTION | PROCEDURE) func_name func_args_with_defaults (
        RETURNS (func_return | TABLE OPEN_PAREN table_func_column_list CLOSE_PAREN)
    )? createfunc_opt_list

or_replace_ = OR REPLACE

func_args = OPEN_PAREN func_args_list? CLOSE_PAREN

func_args_list = func_arg (COMMA func_arg)*

function_with_argtypes_list = function_with_argtypes (COMMA function_with_argtypes)*

function_with_argtypes = func_name func_args / type_func_name_keyword / colid indirection?

func_args_with_defaults = OPEN_PAREN func_args_with_defaults_list? CLOSE_PAREN

func_args_with_defaults_list = func_arg_with_default (COMMA func_arg_with_default)*

func_arg
    = arg_class param_name? func_type
    / param_name arg_class? func_type
    / func_type

arg_class
    = IN_P OUT_P?
    / OUT_P
    / INOUT
    / VARIADIC

param_name = type_function_name

func_return = func_type

func_type = typename / SETOF? type_function_name attrs PERCENT TYPE_P

func_arg_with_default = func_arg ((DEFAULT / EQUAL) a_expr)?

aggr_arg = func_arg

aggr_args
    = OPEN_PAREN (
        STAR
        / aggr_args_list
        / ORDER BY aggr_args_list
        / aggr_args_list ORDER BY aggr_args_list
    ) CLOSE_PAREN

aggr_args_list = aggr_arg (COMMA aggr_arg)*

aggregate_with_argtypes = func_name aggr_args

aggregate_with_argtypes_list = aggregate_with_argtypes (COMMA aggregate_with_argtypes)*

createfunc_opt_list = createfunc_opt_item+

common_func_opt_item
    = CALLED ON NULL_P INPUT_P
    / RETURNS NULL_P ON NULL_P INPUT_P
    / STRICT_P
    / IMMUTABLE
    / STABLE
    / VOLATILE
    / EXTERNAL SECURITY DEFINER
    / EXTERNAL SECURITY INVOKER
    / SECURITY DEFINER
    / SECURITY INVOKER
    / LEAKPROOF
    / NOT LEAKPROOF
    / COST numericonly
    / ROWS numericonly
    / SUPPORT any_name
    / functionsetresetclause
    / PARALLEL colid

createfunc_opt_item
    = AS func_as
    / LANGUAGE nonreservedword_or_sconst
    / TRANSFORM transform_type_list
    / WINDOW
    / common_func_opt_item


//https://www.postgresql.org/docs/9.1/sql-createfunction.html
//    | AS 'definition'
//    | AS 'obj_file', 'link_symbol'

func_as = sconst COMMA sconst /* |AS 'definition'*/ def = sconst / AS 'obj_file', 'link_symbol'*/

transform_type_list = FOR TYPE_P typename (COMMA FOR TYPE_P typename)*

definition_ = WITH definition

table_func_column = param_name func_type

table_func_column_list = table_func_column (COMMA table_func_column)*

alterfunctionstmt = ALTER (FUNCTION / PROCEDURE / ROUTINE) function_with_argtypes alterfunc_opt_list restrict_?

alterfunc_opt_list = common_func_opt_item+

restrict_ = RESTRICT

removefuncstmt
    = DROP FUNCTION function_with_argtypes_list drop_behavior_?
    / DROP FUNCTION IF_P EXISTS function_with_argtypes_list drop_behavior_?
    / DROP PROCEDURE function_with_argtypes_list drop_behavior_?
    / DROP PROCEDURE IF_P EXISTS function_with_argtypes_list drop_behavior_?
    / DROP ROUTINE function_with_argtypes_list drop_behavior_?
    / DROP ROUTINE IF_P EXISTS function_with_argtypes_list drop_behavior_?

removeaggrstmt
    = DROP AGGREGATE aggregate_with_argtypes_list drop_behavior_?
    / DROP AGGREGATE IF_P EXISTS aggregate_with_argtypes_list drop_behavior_?

removeoperstmt
    = DROP OPERATOR operator_with_argtypes_list drop_behavior_?
    / DROP OPERATOR IF_P EXISTS operator_with_argtypes_list drop_behavior_?

oper_argtypes
    = OPEN_PAREN typename CLOSE_PAREN
    / OPEN_PAREN typename COMMA typename CLOSE_PAREN
    / OPEN_PAREN NONE COMMA typename CLOSE_PAREN
    / OPEN_PAREN typename COMMA NONE CLOSE_PAREN

any_operator = (colid DOT)* all_op

operator_with_argtypes_list = operator_with_argtypes (COMMA operator_with_argtypes)*

operator_with_argtypes = any_operator oper_argtypes

dostmt = DO dostmt_opt_list

dostmt_opt_list = dostmt_opt_item+

dostmt_opt_item = sconst / LANGUAGE nonreservedword_or_sconst

createcaststmt
    = CREATE CAST OPEN_PAREN typename AS typename CLOSE_PAREN WITH FUNCTION function_with_argtypes cast_context?
    / CREATE CAST OPEN_PAREN typename AS typename CLOSE_PAREN WITHOUT FUNCTION cast_context?
    / CREATE CAST OPEN_PAREN typename AS typename CLOSE_PAREN WITH INOUT cast_context?

cast_context = AS IMPLICIT_P / AS ASSIGNMENT

dropcaststmt = DROP CAST if_exists_? OPEN_PAREN typename AS typename CLOSE_PAREN drop_behavior_?

if_exists_ = IF_P EXISTS

createtransformstmt = CREATE or_replace_? TRANSFORM FOR typename LANGUAGE name OPEN_PAREN transform_element_list CLOSE_PAREN

transform_element_list
    = FROM SQL_P WITH FUNCTION function_with_argtypes COMMA TO SQL_P WITH FUNCTION function_with_argtypes
    / TO SQL_P WITH FUNCTION function_with_argtypes COMMA FROM SQL_P WITH FUNCTION function_with_argtypes
    / FROM SQL_P WITH FUNCTION function_with_argtypes
    / TO SQL_P WITH FUNCTION function_with_argtypes

droptransformstmt = DROP TRANSFORM if_exists_? FOR typename LANGUAGE name drop_behavior_?

reindexstmt
    = REINDEX reindex_option_list? reindex_target_relation concurrently_? qualified_name
    / REINDEX reindex_option_list? SCHEMA concurrently_? name
    / REINDEX reindex_option_list? reindex_target_all concurrently_? single_name_?

reindex_target_relation = INDEX / TABLE

reindex_target_all = SYSTEM_P / DATABASE

reindex_option_list = OPEN_PAREN utility_option_list CLOSE_PAREN

altertblspcstmt
    = ALTER TABLESPACE name SET reloptions
    / ALTER TABLESPACE name RESET reloptions

renamestmt
    = ALTER AGGREGATE aggregate_with_argtypes RENAME TO name
    / ALTER COLLATION any_name RENAME TO name
    / ALTER CONVERSION_P any_name RENAME TO name
    / ALTER DATABASE name RENAME TO name
    / ALTER DOMAIN_P any_name RENAME TO name
    / ALTER DOMAIN_P any_name RENAME CONSTRAINT name TO name
    / ALTER FOREIGN DATA_P WRAPPER name RENAME TO name
    / ALTER FUNCTION function_with_argtypes RENAME TO name
    / ALTER GROUP_P roleid RENAME TO roleid
    / ALTER procedural_? LANGUAGE name RENAME TO name
    / ALTER OPERATOR CLASS any_name USING name RENAME TO name
    / ALTER OPERATOR FAMILY any_name USING name RENAME TO name
    / ALTER POLICY name ON qualified_name RENAME TO name
    / ALTER POLICY IF_P EXISTS name ON qualified_name RENAME TO name
    / ALTER PROCEDURE function_with_argtypes RENAME TO name
    / ALTER PUBLICATION name RENAME TO name
    / ALTER ROUTINE function_with_argtypes RENAME TO name
    / ALTER SCHEMA name RENAME TO name
    / ALTER SERVER name RENAME TO name
    / ALTER SUBSCRIPTION name RENAME TO name
    / ALTER TABLE relation_expr RENAME TO name
    / ALTER TABLE IF_P EXISTS relation_expr RENAME TO name
    / ALTER SEQUENCE qualified_name RENAME TO name
    / ALTER SEQUENCE IF_P EXISTS qualified_name RENAME TO name
    / ALTER VIEW qualified_name RENAME TO name
    / ALTER VIEW IF_P EXISTS qualified_name RENAME TO name
    / ALTER MATERIALIZED VIEW qualified_name RENAME TO name
    / ALTER MATERIALIZED VIEW IF_P EXISTS qualified_name RENAME TO name
    / ALTER INDEX qualified_name RENAME TO name
    / ALTER INDEX IF_P EXISTS qualified_name RENAME TO name
    / ALTER FOREIGN TABLE relation_expr RENAME TO name
    / ALTER FOREIGN TABLE IF_P EXISTS relation_expr RENAME TO name
    / ALTER TABLE relation_expr RENAME column_? name TO name
    / ALTER TABLE IF_P EXISTS relation_expr RENAME column_? name TO name
    / ALTER VIEW qualified_name RENAME column_? name TO name
    / ALTER VIEW IF_P EXISTS qualified_name RENAME column_? name TO name
    / ALTER MATERIALIZED VIEW qualified_name RENAME column_? name TO name
    / ALTER MATERIALIZED VIEW IF_P EXISTS qualified_name RENAME column_? name TO name
    / ALTER TABLE relation_expr RENAME CONSTRAINT name TO name
    / ALTER TABLE IF_P EXISTS relation_expr RENAME CONSTRAINT name TO name
    / ALTER FOREIGN TABLE relation_expr RENAME column_? name TO name
    / ALTER FOREIGN TABLE IF_P EXISTS relation_expr RENAME column_? name TO name
    / ALTER RULE name ON qualified_name RENAME TO name
    / ALTER TRIGGER name ON qualified_name RENAME TO name
    / ALTER EVENT TRIGGER name RENAME TO name
    / ALTER ROLE roleid RENAME TO roleid
    / ALTER USER roleid RENAME TO roleid
    / ALTER TABLESPACE name RENAME TO name
    / ALTER STATISTICS any_name RENAME TO name
    / ALTER TEXT_P SEARCH PARSER any_name RENAME TO name
    / ALTER TEXT_P SEARCH DICTIONARY any_name RENAME TO name
    / ALTER TEXT_P SEARCH TEMPLATE any_name RENAME TO name
    / ALTER TEXT_P SEARCH CONFIGURATION any_name RENAME TO name
    / ALTER TYPE_P any_name RENAME TO name
    / ALTER TYPE_P any_name RENAME ATTRIBUTE name TO name drop_behavior_?

column_ = COLUMN

set_data_ = SET DATA_P

alterobjectdependsstmt
    = ALTER FUNCTION function_with_argtypes no_? DEPENDS ON EXTENSION name
    / ALTER PROCEDURE function_with_argtypes no_? DEPENDS ON EXTENSION name
    / ALTER ROUTINE function_with_argtypes no_? DEPENDS ON EXTENSION name
    / ALTER TRIGGER name ON qualified_name no_? DEPENDS ON EXTENSION name
    / ALTER MATERIALIZED VIEW qualified_name no_? DEPENDS ON EXTENSION name
    / ALTER INDEX qualified_name no_? DEPENDS ON EXTENSION name

no_ = NO

alterobjectschemastmt
    = ALTER AGGREGATE aggregate_with_argtypes SET SCHEMA name
    / ALTER COLLATION any_name SET SCHEMA name
    / ALTER CONVERSION_P any_name SET SCHEMA name
    / ALTER DOMAIN_P any_name SET SCHEMA name
    / ALTER EXTENSION name SET SCHEMA name
    / ALTER FUNCTION function_with_argtypes SET SCHEMA name
    / ALTER OPERATOR operator_with_argtypes SET SCHEMA name
    / ALTER OPERATOR CLASS any_name USING name SET SCHEMA name
    / ALTER OPERATOR FAMILY any_name USING name SET SCHEMA name
    / ALTER PROCEDURE function_with_argtypes SET SCHEMA name
    / ALTER ROUTINE function_with_argtypes SET SCHEMA name
    / ALTER TABLE relation_expr SET SCHEMA name
    / ALTER TABLE IF_P EXISTS relation_expr SET SCHEMA name
    / ALTER STATISTICS any_name SET SCHEMA name
    / ALTER TEXT_P SEARCH PARSER any_name SET SCHEMA name
    / ALTER TEXT_P SEARCH DICTIONARY any_name SET SCHEMA name
    / ALTER TEXT_P SEARCH TEMPLATE any_name SET SCHEMA name
    / ALTER TEXT_P SEARCH CONFIGURATION any_name SET SCHEMA name
    / ALTER SEQUENCE qualified_name SET SCHEMA name
    / ALTER SEQUENCE IF_P EXISTS qualified_name SET SCHEMA name
    / ALTER VIEW qualified_name SET SCHEMA name
    / ALTER VIEW IF_P EXISTS qualified_name SET SCHEMA name
    / ALTER MATERIALIZED VIEW qualified_name SET SCHEMA name
    / ALTER MATERIALIZED VIEW IF_P EXISTS qualified_name SET SCHEMA name
    / ALTER FOREIGN TABLE relation_expr SET SCHEMA name
    / ALTER FOREIGN TABLE IF_P EXISTS relation_expr SET SCHEMA name
    / ALTER TYPE_P any_name SET SCHEMA name

alteroperatorstmt = ALTER OPERATOR operator_with_argtypes SET OPEN_PAREN operator_def_list CLOSE_PAREN

operator_def_list = operator_def_elem (COMMA operator_def_elem)*

operator_def_elem = colLabel EQUAL NONE / colLabel EQUAL operator_def_arg

operator_def_arg
    = func_type
    / reserved_keyword
    / qual_all_op
    / numericonly
    / sconst

altertypestmt = ALTER TYPE_P any_name SET OPEN_PAREN operator_def_list CLOSE_PAREN

alterownerstmt
    = ALTER AGGREGATE aggregate_with_argtypes OWNER TO rolespec
    / ALTER COLLATION any_name OWNER TO rolespec
    / ALTER CONVERSION_P any_name OWNER TO rolespec
    / ALTER DATABASE name OWNER TO rolespec
    / ALTER DOMAIN_P any_name OWNER TO rolespec
    / ALTER FUNCTION function_with_argtypes OWNER TO rolespec
    / ALTER procedural_? LANGUAGE name OWNER TO rolespec
    / ALTER LARGE_P OBJECT_P numericonly OWNER TO rolespec
    / ALTER OPERATOR operator_with_argtypes OWNER TO rolespec
    / ALTER OPERATOR CLASS any_name USING name OWNER TO rolespec
    / ALTER OPERATOR FAMILY any_name USING name OWNER TO rolespec
    / ALTER PROCEDURE function_with_argtypes OWNER TO rolespec
    / ALTER ROUTINE function_with_argtypes OWNER TO rolespec
    / ALTER SCHEMA name OWNER TO rolespec
    / ALTER TYPE_P any_name OWNER TO rolespec
    / ALTER TABLESPACE name OWNER TO rolespec
    / ALTER STATISTICS any_name OWNER TO rolespec
    / ALTER TEXT_P SEARCH DICTIONARY any_name OWNER TO rolespec
    / ALTER TEXT_P SEARCH CONFIGURATION any_name OWNER TO rolespec
    / ALTER FOREIGN DATA_P WRAPPER name OWNER TO rolespec
    / ALTER SERVER name OWNER TO rolespec
    / ALTER EVENT TRIGGER name OWNER TO rolespec
    / ALTER PUBLICATION name OWNER TO rolespec
    / ALTER SUBSCRIPTION name OWNER TO rolespec

createpublicationstmt = CREATE PUBLICATION name publication_for_tables_? definition_?

publication_for_tables_ = publication_for_tables

publication_for_tables
    = FOR TABLE relation_expr_list
    / FOR ALL TABLES

alterpublicationstmt
    = ALTER PUBLICATION name SET definition
    / ALTER PUBLICATION name ADD_P TABLE relation_expr_list
    / ALTER PUBLICATION name SET TABLE relation_expr_list
    / ALTER PUBLICATION name DROP TABLE relation_expr_list

createsubscriptionstmt = CREATE SUBSCRIPTION name CONNECTION sconst PUBLICATION publication_name_list definition_?

publication_name_list = publication_name_item (COMMA publication_name_item)*

publication_name_item = colLabel

altersubscriptionstmt
    = ALTER SUBSCRIPTION name SET definition
    / ALTER SUBSCRIPTION name CONNECTION sconst
    / ALTER SUBSCRIPTION name REFRESH PUBLICATION definition_?
    / ALTER SUBSCRIPTION name SET PUBLICATION publication_name_list definition_?
    / ALTER SUBSCRIPTION name ENABLE_P
    / ALTER SUBSCRIPTION name DISABLE_P

dropsubscriptionstmt
    = DROP SUBSCRIPTION name drop_behavior_?
    / DROP SUBSCRIPTION IF_P EXISTS name drop_behavior_?

rulestmt = CREATE or_replace_? RULE name AS ON event TO qualified_name where_clause? DO instead_? ruleactionlist

ruleactionlist
    = NOTHING
    / ruleactionstmt
    / OPEN_PAREN ruleactionmulti CLOSE_PAREN

ruleactionmulti = ruleactionstmtOrEmpty? (SEMI ruleactionstmtOrEmpty?)*

ruleactionstmt
    = selectstmt
    / insertstmt
    / updatestmt
    / deletestmt
    / notifystmt

ruleactionstmtOrEmpty = ruleactionstmt

event
    = SELECT
    / UPDATE
    / DELETE_P
    / INSERT

instead_
    = INSTEAD
    / ALSO

notifystmt = NOTIFY colid notify_payload?

notify_payload = COMMA sconst

listenstmt = LISTEN colid

unlistenstmt
    = UNLISTEN colid
    / UNLISTEN STAR

transactionstmt
    = ABORT_P transaction_? transaction_chain_?
    / BEGIN_P transaction_? transaction_mode_list_or_empty?
    / START TRANSACTION transaction_mode_list_or_empty?
    / COMMIT transaction_? transaction_chain_?
    / END_P transaction_? transaction_chain_?
    / ROLLBACK transaction_? transaction_chain_?
    / SAVEPOINT colid
    / RELEASE SAVEPOINT colid
    / RELEASE colid
    / ROLLBACK transaction_? TO SAVEPOINT colid
    / ROLLBACK transaction_? TO colid
    / PREPARE TRANSACTION sconst
    / COMMIT PREPARED sconst
    / ROLLBACK PREPARED sconst

transaction_
    = WORK
    / TRANSACTION

transaction_mode_item
    = ISOLATION LEVEL iso_level
    / READ ONLY
    / READ WRITE
    / DEFERRABLE
    / NOT DEFERRABLE

transaction_mode_list = transaction_mode_item (COMMA? transaction_mode_item)*

transaction_mode_list_or_empty = transaction_mode_list

transaction_chain_ = AND NO? CHAIN

viewstmt
    = CREATE (OR REPLACE)? opttemp? (
        VIEW qualified_name column_list_? reloptions_?
        / RECURSIVE VIEW qualified_name OPEN_PAREN columnlist CLOSE_PAREN reloptions_?
    ) AS selectstmt check_option_?

check_option_ = WITH (CASCADED / LOCAL)? CHECK OPTION

loadstmt = LOAD file_name

createdbstmt = CREATE DATABASE name with_? createdb_opt_list?

createdb_opt_list = createdb_opt_items

createdb_opt_items = createdb_opt_item+

createdb_opt_item = createdb_opt_name equal_? (signediconst / boolean_or_string_ / DEFAULT)

createdb_opt_name
    = identifier
    / CONNECTION LIMIT
    / ENCODING
    / LOCATION
    / OWNER
    / TABLESPACE
    / TEMPLATE

equal_ = EQUAL

alterdatabasestmt = ALTER DATABASE name (WITH createdb_opt_list? / createdb_opt_list? / SET TABLESPACE name)

alterdatabasesetstmt = ALTER DATABASE name setresetclause

dropdbstmt = DROP DATABASE (IF_P EXISTS)? name (with_? OPEN_PAREN drop_option_list CLOSE_PAREN)?

drop_option_list = drop_option (COMMA drop_option)*

drop_option = FORCE

altersystemstmt = ALTER SYSTEM_P (SET / RESET) generic_set

createdomainstmt = CREATE DOMAIN_P any_name as_? typename colquallist

alterdomainstmt
    = ALTER DOMAIN_P any_name (
        alter_column_default
        / DROP NOT NULL_P
        / SET NOT NULL_P
        / ADD_P tableconstraint
        / DROP CONSTRAINT (IF_P EXISTS)? name drop_behavior_?
        / VALIDATE CONSTRAINT name
    )

as_ = AS

altertsdictionarystmt = ALTER TEXT_P SEARCH DICTIONARY any_name definition

altertsconfigurationstmt
    = ALTER TEXT_P SEARCH CONFIGURATION any_name ADD_P MAPPING FOR name_list any_with any_name_list_
    / ALTER TEXT_P SEARCH CONFIGURATION any_name ALTER MAPPING FOR name_list any_with any_name_list_
    / ALTER TEXT_P SEARCH CONFIGURATION any_name ALTER MAPPING REPLACE any_name any_with any_name
    / ALTER TEXT_P SEARCH CONFIGURATION any_name ALTER MAPPING FOR name_list REPLACE any_name any_with any_name
    / ALTER TEXT_P SEARCH CONFIGURATION any_name DROP MAPPING FOR name_list
    / ALTER TEXT_P SEARCH CONFIGURATION any_name DROP MAPPING IF_P EXISTS FOR name_list

any_with = WITH

createconversionstmt =  CREATE default_? CONVERSION_P any_name FOR sconst TO sconst FROM any_name

clusterstmt
    = CLUSTER verbose_? qualified_name cluster_index_specification?
    / CLUSTER verbose_?
    / CLUSTER verbose_? name ON qualified_name

cluster_index_specification = USING name

vacuumstmt
    = VACUUM full_? freeze_? verbose_? analyze_? vacuum_relation_list_?
    / VACUUM OPEN_PAREN vac_analyze_option_list CLOSE_PAREN vacuum_relation_list_?

analyzestmt
    = analyze_keyword verbose_? vacuum_relation_list_?
    / analyze_keyword OPEN_PAREN vac_analyze_option_list CLOSE_PAREN vacuum_relation_list_?

utility_option_list = utility_option_elem ( ',' utility_option_elem)*

vac_analyze_option_list = vac_analyze_option_elem (COMMA vac_analyze_option_elem)*

analyze_keyword = ANALYZE / ANALYSE

utility_option_elem  = utility_option_name utility_option_arg?

utility_option_name
    = nonreservedword
    / analyze_keyword
    / FORMAT_LA

utility_option_arg
    = boolean_or_string_
    / numericonly

vac_analyze_option_elem = vac_analyze_option_name vac_analyze_option_arg?

vac_analyze_option_name = nonreservedword / analyze_keyword

vac_analyze_option_arg = boolean_or_string_ / numericonly

analyze_ = analyze_keyword

verbose_ = VERBOSE

full_ = FULL

freeze_ = FREEZE

name_list_ = OPEN_PAREN name_list CLOSE_PAREN

vacuum_relation = qualified_name name_list_?

vacuum_relation_list = vacuum_relation (COMMA vacuum_relation)*

vacuum_relation_list_ = vacuum_relation_list

explainstmt
    = EXPLAIN explainablestmt
    / EXPLAIN analyze_keyword verbose_? explainablestmt
    / EXPLAIN VERBOSE explainablestmt
    / EXPLAIN OPEN_PAREN explain_option_list CLOSE_PAREN explainablestmt

explainablestmt
    = selectstmt
    / insertstmt
    / updatestmt
    / deletestmt
    / declarecursorstmt
    / createasstmt
    / creatematviewstmt
    / refreshmatviewstmt
    / executestmt

explain_option_list = explain_option_elem (COMMA explain_option_elem)*












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