Code = SimplifiedExtSQL

SimplifiedExtSQL = ExtSQLStreamVar __ '=' __ 'DB::' DrallExtSQL

ExtSQLStreamVar = ExtSQLStreamSingleVar

ExtSQLStreamSingleVar = VarName

DrallExtSQL = table:DrallExtSQLSingleTableSelector __ ( DrallExtSQLDirectTableOperations / DrallExtSQLOptimized)

DrallExtSQLSingleTableSelector = Table

DrallExtSQLDirectTableOperations = DrallExtSQLNew

DrallExtSQLNew =  "." __ "new" __ "(" __ ")"

DrallExtSQLOptimized = DrallExtSQLOptimizedTableFieldsSelector? DrallExtSQLOptimizedWhereRules? DrallExtSQLOptimizedGroupBy? DrallExtSQLOptimizedHaving? DrallExtSQLOptimizedOrderBy? DrallExtSQLOptimizedLimit? DrallExtSQLOptimizedOffset?

DrallExtSQLOptimizedTableFieldsSelector = '[' __ AllClause? TargetList? IntoClause __ ']'

DrallExtSQLOptimizedWhereRules = '(' '@TODO_EXPR' ')'

DrallExtSQLOptimizedGroupBy = '.groupby' __ '(' __ '@TODO' __ ')'

DrallExtSQLOptimizedHaving = '.having' __ '(' __ '@TODO' __ ')'

DrallExtSQLOptimizedOrderBy = '.orderby' __ '(' __ '@TODO' __ ')'

DrallExtSQLOptimizedLimit = '.limit' __ '(' __ Integer __ ')'

DrallExtSQLOptimizedOffset = '.offset' __ '(' __ Integer __ ')' /* pode ser VIEW var or some other language var */

ExtSQLStreamSingleVarOperations = ExtSQLStreamSingleVar DirectVariableOperations

DirectVariableOperations = __ "." __ ( "save" / "delete") __ "(" __ ")"

TargetList = ""

IntoClause = whitespace "INTO" whitespace OptTempTableName

OptTempTableName = whitespace ("LOCAL" / "GLOBAL")? ("TEMPORARY" / "TEMP") Table? QualifiedName
	/ "UNLOGGED" Table? QualifiedName
    / Table QualifiedName
    / QualifiedName

QualifiedName = ColId Indirection?

Indirection = IndirectionEl+

IndirectionEl = __ "." __ ( AttrName / Star ) 
              / "(" __ (AExpr / SliceBound? ":" SliceBound?) ")"

SliceBound = AExpr

AttrName = ColLabel

/*Column identifier --- names that can be column, table, etc names*/
ColId = Identifier / UnreservedKeyword / ColNameKeyword

ColLabel = Identifier
			/ UnreservedKeyword
            / ColNameKeyword
            / TypeFuncNameKeyword
            / ReservedKeyword

Identifier = VarName Uescape?
    / UnicodeQuotedIdentifier
    / Plsqlvariablename

Uescape = Uescape_p AnyConst

QuotedIdentifier
  = '"' chars:QuotedIdentifierChars '"' {
      // Join the characters, replacing doubled quotes with a single quote
      return chars.join('').replace(/""/g, '"');
    }

UnicodeQuotedIdentifier = ( '""' / [^\u0000"] )*


AnyConst = StringConstant
    / UnicodeEscapeStringConstant
    / DollarString
    / EscapeStringConstant

DollarString = "$" Tag? "$"

Tag = IdentifierStartChar StrictIdentifierChar*

EscapeStringConstant = "'" ValidString* "'" ValidString+ "'"

StringConstant = UnterminatedStringConstant "'"  // match UnterminatedStringConstant followed by a single quote

UnterminatedStringConstant = "'" ( "''" / [^'] )*   // match a single quote, then zero or more of either two single quotes or any char except single quote

UnicodeEscapeStringConstant = UnterminatedUnicodeEscapeStringConstant "'"

UnterminatedUnicodeEscapeStringConstant = "U" "&" UnterminatedStringConstant

/* Reserved keyword --- these keywords are usable only as a ColLabel.
 *
 * Keywords appear here if they could not be distinguished from variable,
 * type, or function names in some contexts.  Don't put things here unless
 * forced to.
 */
ReservedKeyword =
    All
    / Analyse
    / Analyze
    / And
    / Any
    / Array
    / As
    / Asc
    / Asymmetric
    / Both
    / Case
    / Cast
    / Check
    / Collate
    / Column
    / Constraint
    / Create
    / Current_catalog
    / Current_date
    / Current_role
    / Current_time
    / Current_timestamp
    / Current_user
    / Default
    / Deferrable
    / Desc
    / Distinct
    / Do
    / Else
    / End_p
    / Except
    / False_p
    / Fetch
    / For
    / Foreign
    / From
    / Grant
    / Group_p
    / Having
    / In_p
    / Initially
    / Intersect
    / Into
    / Lateral_p
    / Leading
    / Limit
    / Localtime
    / Localtimestamp
    / Not
    / Null_p
    / Offset
    / On
    / Only
    / Or
    / Order
    / Placing
    / Primary
    / References
    / Returning
    / Select
    / Session_user
    / Some
    / Symmetric
    / System_user
    / Table_p
    / Then
    / To
    / Trailing
    / True_p
    / Union
    / Unique
    / User
    / Using
    / Variadic
    / When
    / Where
    / Window
    / With


// reserved keywords

//

All = 'ALL'

Analyse = 'ANALYSE'

Analyze = 'ANALYZE'

And = 'AND'

Any = 'ANY'

Array = 'ARRAY'

As = 'AS'

Asc = 'ASC'

Asymmetric = 'ASYMMETRIC'

Both = 'BOTH'

Case = 'CASE'

Cast = 'CAST'

Check = 'CHECK'

Collate = 'COLLATE'

Column = 'COLUMN'

Constraint = 'CONSTRAINT'

Create = 'CREATE'

Current_catalog = 'CURRENT_CATALOG'

Current_date = 'CURRENT_DATE'

Current_role = 'CURRENT_ROLE'

Current_time = 'CURRENT_TIME'

Current_timestamp = 'CURRENT_TIMESTAMP'

Current_user = 'CURRENT_USER'

Default = 'DEFAULT'

Deferrable = 'DEFERRABLE'

Desc = 'DESC'

Distinct = 'DISTINCT'

Do = 'DO'

Else = 'ELSE'

Except = 'EXCEPT'

False_p = 'FALSE'

Fetch = 'FETCH'

For = 'FOR'

Foreign = 'FOREIGN'

From = 'FROM'

Grant = 'GRANT'

Group_p = 'GROUP'

Having = 'HAVING'

In_p = 'IN'

Initially = 'INITIALLY'

Intersect = 'INTERSECT'

Into = 'INTO'

Lateral_p = 'LATERAL'

Leading = 'LEADING'

Limit = 'LIMIT'

Localtime = 'LOCALTIME'

Localtimestamp = 'LOCALTIMESTAMP'

Not = 'NOT'

Null_p = 'NULL'

Offset = 'OFFSET'

On = 'ON'

Only = 'ONLY'

Or = 'OR'

Order = 'ORDER'

Placing = 'PLACING'

Primary = 'PRIMARY'

References = 'REFERENCES'

Returning = 'RETURNING'

Select = 'SELECT'

Session_user = 'SESSION_USER'

Some = 'SOME'

Symmetric = 'SYMMETRIC'

Table_p = 'TABLE'

Then = 'THEN'

To = 'TO'

Trailing = 'TRAILING'

True_p = 'TRUE'

Union = 'UNION'

Unique = 'UNIQUE'

User = 'USER'

Using = 'USING'

Variadic = 'VARIADIC'

When = 'WHEN'

Where = 'WHERE'

Window = 'WINDOW'

With = 'WITH'





/* "Unreserved" keywords --- available for use as any kind of name.
 */
UnreservedKeyword = 
    Abort_p
    / Absent
    / Absolute_p
    / Access
    / Action
    / Add_p
    / Admin
    / After
    / Aggregate
    / Also
    / Alter
    / Always
    / Asensitive
    / Assertion
    / Assignment
    / At
    / Atomic
    / Attach
    / Attribute
    / Backward
    / Before
    / Begin_p
    / Breadth
    / By
    / Cache
    / Call
    / Called
    / Cascade
    / Cascaded
    / Catalog
    / Chain
    / Characteristics
    / Checkpoint
    / Class
    / Close
    / Cluster
    / Columns
    / Comment
    / Comments
    / Commit
    / Committed
    / Compression
    / Conditional
    / Configuration
    / Conflict
    / Connection
    / Constraints
    / Content_p
    / Continue_p
    / Conversion_p
    / Copy
    / Cost
    / Csv
    / Cube
    / Current_p
    / Cursor
    / Cycle
    / Data_p
    / Database
    / Day_p
    / Deallocate
    / Declare
    / Defaults
    / Deferred
    / Definer
    / Delete_p
    / Delimiter
    / Delimiters
    / Depends
    / Depth
    / Detach
    / Dictionary
    / Disable_p
    / Discard
    / Document_p
    / Domain_p
    / Double_p
    / Drop
    / Each
    / Empty_p
    / Enable_p
    / Encoding
    / Encrypted
    / Enum_p
    / Error
    / Escape
    / Event
    / Exclude
    / Excluding
    / Exclusive
    / Execute
    / Explain
    / Expression
    / Extension
    / External
    / Family
    / Filter
    / Finalize
    / First_p
    / Following
    / Force
    / Format
    / Forward
    / Function
    / Functions
    / Generated
    / Global
    / Granted
    / Groups
    / Handler
    / Header_p
    / Hold
    / Hour_p
    / Identity_p
    / If_p
    / Immediate
    / Immutable
    / Implicit_p
    / Import_p
    / Include
    / Including
    / Increment
    / Indent
    / Index
    / Indexes
    / Inherit
    / Inherits
    / Inline_p
    / Input_p
    / Insensitive
    / Insert
    / Instead
    / Invoker
    / Isolation
    / Keep
    / Key
    / Keys
    / Label
    / Language
    / Large_p
    / Last_p
    / Leakproof
    / Level
    / Listen
    / Load
    / Local
    / Location
    / Lock_p
    / Locked
    / Logged
    / Mapping
    / Match
    / Matched
    / Materialized
    / Maxvalue
    / Merge
    / Method
    / Minute_p
    / Minvalue
    / Mode
    / Month_p
    / Move
    / Name_p
    / Names
    / Nested
    / New
    / Next
    / Nfc
    / Nfd
    / Nfkc
    / Nfkd
    / No
    / Normalized
    / Nothing
    / Notify
    / Nowait
    / Nulls_p
    / Object_p
    / Of
    / Off
    / Oids
    / Old
    / Omit
    / Operator
    / Option
    / Options
    / Ordinality
    / Others
    / Over
    / Overriding
    / Owned
    / Owner
    / Parallel
    / Parameter
    / Parser
    / Partial
    / Partition
    / Passing
    / Password
    / Path
    / Period
    / Plan
    / Plans
    / Policy
    / Preceding
    / Prepare
    / Prepared
    / Preserve
    / Prior
    / Privileges
    / Procedural
    / Procedure
    / Procedures
    / Program
    / Publication
    / Quote
    / Quotes
    / Range
    / Read
    / Reassign
    / Recursive
    / Ref
    / Referencing
    / Refresh
    / Reindex
    / Relative_p
    / Release
    / Rename
    / Repeatable
    / Replace
    / Replica
    / Reset
    / Restart
    / Restrict
    / Return
    / Returns
    / Revoke
    / Role
    / Rollback
    / Rollup
    / Routine
    / Routines
    / Rows
    / Rule
    / Savepoint
    / Scalar
    / Schema
    / Schemas
    / Scroll
    / Search
    / Second_p
    / Security
    / Sequence
    / Sequences
    / Serializable
    / Server
    / Session
    / Set
    / Sets
    / Share
    / Show
    / Simple
    / Skip_p
    / Snapshot
    / Source
    / Sql_p
    / Stable
    / Standalone_p
    / Start
    / Statement
    / Statistics
    / Stdin
    / Stdout
    / Storage
    / Stored
    / Strict_p
    / String_p
    / Strip_p
    / Subscription
    / Support
    / Sysid
    / System_p
    / Tables
    / Tablespace
    / Target
    / Temp
    / Template
    / Temporary
    / Text_p
    / Ties
    / Transaction
    / Transform
    / Trigger
    / Truncate
    / Trusted
    / Type_p
    / Types_p
    / Uescape_p
    / Unbounded
    / Uncommitted
    / Unconditional
    / Unencrypted
    / Unknown
    / Unlisten
    / Unlogged
    / Until
    / Update
    / Vacuum
    / Valid
    / Validate
    / Validator
    / Value_p
    / Varying
    / Version_p
    / View
    / Views
    / Volatile
    / Whitespace_p
    / Within
    / Without
    / Work
    / Wrapper
    / Write
    / Xml_p
    / Year_p
    / Yes_p
    / Zone

ColNameKeyword = Between
    / Bigint
    / Bit
    / Boolean_p
    / Char_p
    / character
    / Coalesce
    / Dec
    / Decimal_p
    / Exists
    / Extract
    / Float_p
    / Greatest
    / Grouping
    / Inout
    / Int_p
    / Integer_p
    / Interval
    / Json
    / Json_array
    / Json_arrayagg
    / Json_exists
    / Json_object
    / Json_objectagg
    / Json_query
    / Json_scalar
    / Json_serialize
    / Json_table
    / Json_value
    / Least
    / Merge_action
    / National
    / Nchar
    / None
    / Normalize
    / Nullif
    / Numeric
    / Out_p
    / Overlay
    / Position
    / Precision
    / Real
    / Row
    / Setof
    / Smallint
    / Substring
    / Time
    / Timestamp
    / Treat
    / Trim
    / Values
    / Varchar
    / Xmlattributes
    / Xmlconcat
    / Xmlelement
    / Xmlexists
    / Xmlforest
    / Xmlnamespaces
    / Xmlparse
    / Xmlpi
    / Xmlroot
    / Xmlserialize
    / Xmltable


/* Type/function identifier --- keywords that can be type or function names.
 *
 * Most of these are keywords that are used as operators in expressions;
 * in general such keywords can't be column names because they would be
 * ambiguous with variables, but they are unambiguous as function identifiers.
 *
 * Do not include POSITION, SUBSTRING, etc here since they have explicit
 * productions in a_expr to support the goofy SQL9x argument syntax.
 */
TypeFuncNameKeyword = 
    Authorization 
    / Binary 
    / Collation 
    / Concurrently 
    / Cross 
    / Current_schema 
    / Freeze 
    / Full 
    / Ilike 
    / Inner_p 
    / Is 
    / Isnull 
    / Join 
    / Left 
    / Like 
    / Natural 
    / Notnull 
    / Outer_p 
    / Overlaps 
    / Right 
    / Similar 
    / Tablesample 
    / Verbose 


// reserved keywords (can be function or type)

//

Authorization = 'AUTHORIZATION';

Binary = 'BINARY';

Collation = 'COLLATION';

Concurrently = 'CONCURRENTLY';

Cross = 'CROSS';

Current_schema = 'CURRENT_SCHEMA';

Freeze = 'FREEZE';

Full = 'FULL';

Ilike = 'ILIKE';

Inner_p = 'INNER';

Is = 'IS';

Isnull = 'ISNULL';

Join = 'JOIN';

Left = 'LEFT';

Like = 'LIKE';

Natural = 'NATURAL';

Notnull = 'NOTNULL';

Outer_p = 'OUTER';

Over = 'OVER';

Overlaps = 'OVERLAPS';

Right = 'RIGHT';

Similar = 'SIMILAR';

Verbose = 'VERBOSE';



// non-reserved keywords
Abort_p = "ABORT"

Absolute_p = "ABSOLUTE"

Access = "ACCESS"

Action = "ACTION"

Add_p = "ADD"

Admin = "ADMIN"

After = "AFTER"

Aggregate = "AGGREGATE"

Also = "ALSO"

Alter = "ALTER"

Always = "ALWAYS"

Assertion = "ASSERTION"

Assignment = "ASSIGNMENT"

At = "AT"

Attribute = "ATTRIBUTE"

Backward = "BACKWARD"

Before = "BEFORE"

Begin_p = "BEGIN"

By = "BY"

Cache = "CACHE"

Called = "CALLED"

Cascade = "CASCADE"

Cascaded = "CASCADED"

Catalog = "CATALOG"

Chain = "CHAIN"

Characteristics = "CHARACTERISTICS"

Checkpoint = "CHECKPOINT"

Class = "CLASS"

Close = "CLOSE"

Cluster = "CLUSTER"

Comment = "COMMENT"

Comments = "COMMENTS"

Commit = "COMMIT"

Committed = "COMMITTED"

Configuration = "CONFIGURATION"

Connection = "CONNECTION"

Constraints = "CONSTRAINTS"

Content_p = "CONTENT"

Continue_p = "CONTINUE"

Conversion_p = "CONVERSION"

Copy = "COPY"

Cost = "COST"

Csv = "CSV"

Cursor = "CURSOR"

Cycle = "CYCLE"

Data_p = "DATA"

Database = "DATABASE"

Day_p = "DAY"

Deallocate = "DEALLOCATE"

Declare = "DECLARE"

Defaults = "DEFAULTS"

Deferred = "DEFERRED"

Definer = "DEFINER"

Delete_p = "DELETE"

Delimiter = "DELIMITER"

Delimiters = "DELIMITERS"

Dictionary = "DICTIONARY"

Disable_p = "DISABLE"

Discard = "DISCARD"

Document_p = "DOCUMENT"

Domain_p = "DOMAIN"

Double_p = "DOUBLE"

Drop = "DROP"

Each = "EACH"

Enable_p = "ENABLE"

Encoding = "ENCODING"

Encrypted = "ENCRYPTED"

Enum_p = "ENUM"

Escape = "ESCAPE"

Event = "EVENT"

Exclude = "EXCLUDE"

Excluding = "EXCLUDING"

Exclusive = "EXCLUSIVE"

Execute = "EXECUTE"

Explain = "EXPLAIN"

Extension = "EXTENSION"

External = "EXTERNAL"

Family = "FAMILY"

First_p = "FIRST"

Following = "FOLLOWING"

Force = "FORCE"

Forward = "FORWARD"

Function = "FUNCTION"

Functions = "FUNCTIONS"

Global = "GLOBAL"

Granted = "GRANTED"

Handler = "HANDLER"

Header_p = "HEADER"

Hold = "HOLD"

Hour_p = "HOUR"

Identity_p = "IDENTITY"

If_p = "IF"

Immediate = "IMMEDIATE"

Immutable = "IMMUTABLE"

Implicit_p = "IMPLICIT"

Including = "INCLUDING"

Increment = "INCREMENT"

Index = "INDEX"

Indexes = "INDEXES"

Inherit = "INHERIT"

Inherits = "INHERITS"

Inline_p = "INLINE"

Insensitive = "INSENSITIVE"

Insert = "INSERT"

Instead = "INSTEAD"

Invoker = "INVOKER"

Isolation = "ISOLATION"

Key = "KEY"

Label = "LABEL"

Language = "LANGUAGE"

Large_p = "LARGE"

Last_p = "LAST"

Leakproof = "LEAKPROOF"

Level = "LEVEL"

Listen = "LISTEN"

Load = "LOAD"

Local = "LOCAL"

Location = "LOCATION"

Lock_p = "LOCK"

Mapping = "MAPPING"

Match = "MATCH"

Matched = "MATCHED"

Materialized = "MATERIALIZED"

Maxvalue = "MAXVALUE"

Merge = "MERGE"

Minute_p = "MINUTE"

Minvalue = "MINVALUE"

Mode = "MODE"

Month_p = "MONTH"

Move = "MOVE"

Name_p = "NAME"

Names = "NAMES"

Next = "NEXT"

No = "NO"

Nothing = "NOTHING"

Notify = "NOTIFY"

Nowait = "NOWAIT"

Nulls_p = "NULLS"

Object_p = "OBJECT"

Of = "OF"

Off = "OFF"

Oids = "OIDS"

Operator = "OPERATOR"

Option = "OPTION"

Options = "OPTIONS"

Owned = "OWNED"

Owner = "OWNER"

Parser = "PARSER"

Partial = "PARTIAL"

Partition = "PARTITION"

Passing = "PASSING"

Password = "PASSWORD"

Plans = "PLANS"

Preceding = "PRECEDING"

Prepare = "PREPARE"

Prepared = "PREPARED"

Preserve = "PRESERVE"

Prior = "PRIOR"

Privileges = "PRIVILEGES"

Procedural = "PROCEDURAL"

Procedure = "PROCEDURE"

Program = "PROGRAM"

Quote = "QUOTE"

Range = "RANGE"

Read = "READ"

Reassign = "REASSIGN"

Recheck = "RECHECK"

Recursive = "RECURSIVE"

Ref = "REF"

Refresh = "REFRESH"

Reindex = "REINDEX"

Relative_p = "RELATIVE"

Release = "RELEASE"

Rename = "RENAME"

Repeatable = "REPEATABLE"

Replace = "REPLACE"

Replica = "REPLICA"

Reset = "RESET"

Restart = "RESTART"

Restrict = "RESTRICT"

Returns = "RETURNS"

Revoke = "REVOKE"

Role = "ROLE"

Rollback = "ROLLBACK"

Rows = "ROWS"

Rule = "RULE"

Savepoint = "SAVEPOINT"

Schema = "SCHEMA"

Scroll = "SCROLL"

Search = "SEARCH"

Second_p = "SECOND"

Security = "SECURITY"

Sequence = "SEQUENCE"

Sequences = "SEQUENCES"

Serializable = "SERIALIZABLE"

Server = "SERVER"

Session = "SESSION"

Set = "SET"

Share = "SHARE"

Show = "SHOW"

Simple = "SIMPLE"

Snapshot = "SNAPSHOT"

Stable = "STABLE"

Standalone_p = "STANDALONE"

Start = "START"

Statement = "STATEMENT"

Statistics = "STATISTICS"

Stdin = "STDIN"

Stdout = "STDOUT"

Storage = "STORAGE"

Strict_p = "STRICT"

Strip_p = "STRIP"

Sysid = "SYSID"

System_p = "SYSTEM"

Tables = "TABLES"

Tablespace = "TABLESPACE"

Temp = "TEMP"

Template = "TEMPLATE"

Temporary = "TEMPORARY"

Text_p = "TEXT"

Transaction = "TRANSACTION"

Trigger = "TRIGGER"

Truncate = "TRUNCATE"

Trusted = "TRUSTED"

Type_p = "TYPE"

Types_p = "TYPES"

Unbounded = "UNBOUNDED"

Uncommitted = "UNCOMMITTED"

Unencrypted = "UNENCRYPTED"

Unknown = "UNKNOWN"

Unlisten = "UNLISTEN"

Unlogged = "UNLOGGED"

Until = "UNTIL"

Update = "UPDATE"

Vacuum = "VACUUM"

Valid = "VALID"

Validate = "VALIDATE"

Validator = "VALIDATOR"

Varying = "VARYING"

Version_p = "VERSION"

View = "VIEW"

Volatile = "VOLATILE"

Whitespace_p = "WHITESPACE"

Without = "WITHOUT"

Work = "WORK"

Wrapper = "WRAPPER"

Write = "WRITE"

Xml_p = "XML"

Year_p = "YEAR"

Yes_p = "YES"

Zone = "ZONE"




Between = 'BETWEEN'

Bigint = 'BIGINT'

Bit = 'BIT'

Boolean_p = 'BOOLEAN'

Char_p = 'CHAR'

Character = 'CHARACTER'

Coalesce = 'COALESCE'

Dec = 'DEC'

Decimal_p = 'DECIMAL'

Exists = 'EXISTS'

Extract = 'EXTRACT'

Float_p = 'FLOAT'

Greatest = 'GREATEST'

Inout = 'INOUT'

Int_p = 'INT'

Integer_p = 'INTEGER'

Interval = 'INTERVAL'

Least = 'LEAST'

National = 'NATIONAL'

Nchar = 'NCHAR'

None = 'NONE'

Nullif = 'NULLIF'

Numeric = 'NUMERIC'

Overlay = 'OVERLAY'

Position = 'POSITION'

Precision = 'PRECISION'

Real = 'REAL'

Row = 'ROW'

Setof = 'SETOF'

Smallint = 'SMALLINT'

Substring = 'SUBSTRING'

Time = 'TIME'

Timestamp = 'TIMESTAMP'

Treat = 'TREAT'

Trim = 'TRIM'

Values = 'VALUES'

Varchar = 'VARCHAR'

Xmlattributes = 'XMLATTRIBUTES'

Xmlcomment = 'XMLCOMMENT'

Xmlagg = 'XMLAGG'

Xml_is_well_formed = 'XML_IS_WELL_FORMED'

Xml_is_well_formed_document = 'XML_IS_WELL_FORMED_DOCUMENT'

Xml_is_well_formed_content = 'XML_IS_WELL_FORMED_CONTENT'

Xpath = 'XPATH'

Xpath_exists = 'XPATH_EXISTS'

Xmlconcat = 'XMLCONCAT'

Xmlelement = 'XMLELEMENT'

Xmlexists = 'XMLEXISTS'

Xmlforest = 'XMLFOREST'

Xmlparse = 'XMLPARSE'

Xmlpi = 'XMLPI'

Xmlroot = 'XMLROOT'

Xmlserialize = 'XMLSERIALIZE'
//MISSED

Call = 'CALL'

Current_p = 'CURRENT'

Attach = 'ATTACH'

Detach = 'DETACH'

Expression = 'EXPRESSION'

Generated = 'GENERATED'

Logged = 'LOGGED'

Stored = 'STORED'

Include = 'INCLUDE'

Routine = 'ROUTINE'

Transform = 'TRANSFORM'

Import_p = 'IMPORT'

Policy = 'POLICY'

Method = 'METHOD'

Referencing = 'REFERENCING'

New = 'NEW'

Old = 'OLD'

Value_p = 'VALUE'

Subscription = 'SUBSCRIPTION'

Publication = 'PUBLICATION'

Out_p = 'OUT'

End_p = 'END'

Routines = 'ROUTINES'

Schemas = 'SCHEMAS'

Procedures = 'PROCEDURES'

Input_p = 'INPUT'

Support = 'SUPPORT'

Parallel = 'PARALLEL'

Sql_p = 'SQL'

Depends = 'DEPENDS'

Overriding = 'OVERRIDING'

Conflict = 'CONFLICT'

Skip_p = 'SKIP'

Locked = 'LOCKED'

Ties = 'TIES'

Rollup = 'ROLLUP'

Cube = 'CUBE'

Grouping = 'GROUPING'

Sets = 'SETS'

Tablesample = 'TABLESAMPLE'

Ordinality = 'ORDINALITY'

Xmltable = 'XMLTABLE'

Columns = 'COLUMNS'

Xmlnamespaces = 'XMLNAMESPACES'

Rowtype = 'ROWTYPE'

Normalized = 'NORMALIZED'

Within = 'WITHIN'

Filter = 'FILTER'

Groups = 'GROUPS'

Others = 'OTHERS'

Nfc = 'NFC'

Nfd = 'NFD'

Nfkc = 'NFKC'

Nfkd = 'NFKD'

Uescape_p = 'UESCAPE'

Views = 'VIEWS'

Normalize = 'NORMALIZE'

Dump = 'DUMP'

Error = 'ERROR'

Use_variable = 'USE_VARIABLE'

Use_column = 'USE_COLUMN'

Constant = 'CONSTANT'

Perform = 'PERFORM'

Get = 'GET'

Diagnostics = 'DIAGNOSTICS'

Stacked = 'STACKED'

Elsif = 'ELSIF'

While = 'WHILE'

Foreach = 'FOREACH'

Slice = 'SLICE'

Exit = 'EXIT'

Return = 'RETURN'

Raise = 'RAISE'

Sqlstate = 'SQLSTATE'

Debug = 'DEBUG'

Info = 'INFO'

Notice = 'NOTICE'

Warning = 'WARNING'

Exception = 'EXCEPTION'

Assert = 'ASSERT'

Loop = 'LOOP'

Open = 'OPEN'

Format = 'FORMAT'



// KEYWORDS (Appendix C)



Json = 'JSON'
Json_array = 'JSON_ARRAY'
Json_arrayagg = 'JSON_ARRAYAGG'
Json_exists = 'JSON_EXISTS'
Json_object = 'JSON_OBJECT'
Json_objectagg = 'JSON_OBJECTAGG'
Json_query = 'JSON_QUERY'
Json_scalar = 'JSON_SCALAR'
Json_serialize = 'JSON_SERIALIZE'
Json_table = 'JSON_TABLE'
Json_value = 'JSON_VALUE'
Merge_action = 'MERGE_ACTION'

System_user = 'SYSTEM_USER'

Absent = 'ABSENT'
Asensitive = 'ASENSITIVE'
Atomic = 'ATOMIC'
Breadth = 'BREATH'
Compression = 'COMPRESSION'
Conditional = 'CONDITIONAL'
Depth = 'DEPTH'
Empty_p = 'EMPTY'
Finalize = 'FINALIZE'
Indent = 'INDENT'
Keep = 'KEEP'
Keys = 'KEYS'
Nested = 'NESTED'
Omit = 'OMIT'
Parameter = 'PARAMETER'
Path = 'PATH'
Plan = 'PLAN'
Quotes = 'QUOTES'
Scalar = 'SCALAR'
Source = 'SOURCE'
String_p = 'STRING'
Target = 'TARGET'
Unconditional = 'UNCONDITIONAL'

Period = 'PERIOD'

Format_la = 'FORMAT_LA'






AExpr = AExprQual

AExprQual = AExprLessLess

AExprLessLess = AExprOr ( ( "<<" / ">>" ) AExprOr )*

AExprOr = AExprAnd ( Or AExprAnd )*

AExprAnd = AExprBetween ( And AExprBetween )*

AExprBetween = AExprIn ( Not? Between "SYMMETRIC"? AExprIn And AExprIn)?

AExprIn = AExprUnaryNot (Not? In InExpr)

AExprUnaryNot = Not? AExprIsNull

AExprIsNull = AExprIsNot ( Isnull / Notnull )?

AExprIsNot = AExprCompare (
            Is Not? (
                    Null
                    / True
                    / False
                    / Unknown
                    / Distinct From AExpr
                    / Of __ "(" __ TypeList __ ")"
                    / Document
                    / UnicodeNormalForm? Normalized
                )
			)?

AExprCompare = AExprLike __(
                (
					"<"
                	/ ">"
                	/ "="
                	/ "<="
                	/ ">="
                	/ "!="
                	/ "<>"
                )
                __
                AExprLike
                / SubQuery_op SubType (SelectWithParens / "(" AExpr ")" )
			)?

AExprLike = AExprQualOp ( Not? ( Like / Ilike / Similar To ) AExprQualOp Escape? )?

AExprQualOp = AExprUnaryQualOp ( QualOp AExprUnaryQualOp )*

AExprUnaryQualOp = QualOp? AExprAdd

AExprAdd = AExprMul ( ( Minus / Plus ) AExprMul )*

AExprMul = AExprCaret ( ( Star / Slash / Percent ) AExprCaret )*

AExprCaret = AExprUnarySign ( Caret AExprUnarySign )?

AExprUnarySign = ( Minus / Plus )? AExprAtTimeZone

AExprAtTimeZone = AExprCollate (At Time Zone AExpr)?

AExprCollate = AExprTypeCast ( Collate AnyName )?

AExprTypeCast = CExpr ( Typecast TypeName )*

BExpr = CExpr
        / Typecast TypeName
        //right	unary plus, unary minus
        / ( Plus / Minus ) BExpr
        //^	left	exponentiation
        / Caret BExpr
        // / %	left	multiplication, division, modulo
        / ( Star / Slash / Percent ) BExpr
        //+ -	left	addition, subtraction
        / ( Plus / Minus ) BExpr
        //(any other operator)	left	all other native and user-defined operators
        / QualOp BExpr
        //< > = <= >= <>	 	comparison operators
        / ( "<" / ">" / "=" / "!=" / "<>" / ">=" / "<=" ) BExpr
        / QualOp BExpr
        / QualOp
        / Is Not? ( Distinct From BExpr / Of "(" TypeList ")" / Document_p )
        
CExpr = Exists SelectWithParens
		/ Array ( SelectWithParens / ArrayExpr )
        / Param OptIndirection
        / Grouping "(" ExprList ")"
        / Unique SelectWithParens
        / ColumnRef
        / AExprConst
        / "(" AExprInParens "=" AExpr ")" OptIndirection
        / CaseExpr
        / FuncExpr
        / SelectWithParens Indirection?
        / ExplicitRow
        / ImplicitRow
        / Row Overlaps Row
        / Default

SimpleTypeName = GenericType
				/ Numeric
                / Bit
                / Character
                / ConstDateTime
                / ConstInterval ( Interval? / "(" Iconst ")" )
                / JsonType

GenericType = TypeFunctionName Attrs? TypeModifiers?

TypeModifiers = "(" ExprList ")"

Distinct = "DISTINCT"

Document = "DOCUMENT"

In = "IN"

Null = "NULL"

True = "TRUE"

False = "FALSE"

Minus = "-"

Plus = "+"

Typecast = "::"

Slash = "/"

Percent = "%"

Character = Character_c ("(" Iconst ")")?

Character_c
    / (Character_p / Char_p / Nchar) Varying?
    / Varchar
    / National (Character / Char_p) Varying?

InExpr = SelectWithParens / "(" ExprList ")"

TypeList = TypeName ( "," TypeName )*

UnicodeNormalForm = Nfc / Nfd / Nfkc / Nfkd

SetOf = "SETOF"

Varying = Varying_p

QualOp = OperatorAction / Operator "(" AnyOperator ")"

Caret = "^"

TypeName = SetOf? SimpleTypeName ( OptArrayBounds / Array ( "(" Iconst ")" )? )

OptArrayBounds = ( "(" Iconst? ")" )*

OperatorAction = OperatorCharacter //4.1. Lexical Structure -> 4.1.3. Operators

OperatorCharacter = [+-/<>=~!@#%^&|`?*]

AnyName = ColId Attrs?

Attrs = ( "." AttrName )+



Table = VarName

VarName = $(IdentifierStartChar IdentifierChar*)

Plsqlvariablename = ":" VarName

ValidString = UnicodeChar+

UnicodeChar = [\u0000-\uFFFF] / SurrogatePair

SurrogatePair = [\uD800-\uDBFF] [\uDC00-\uDFFF]

StrictIdentifierChar = IdentifierStartChar / IdentifierChar

IdentifierStartChar = [a-zA-Z_]

IdentifierChar = [a-zA-Z0-9_]

AllClause = "ALL"i

Star = "*"

Integer = $([0-9])+

whitespace "required space characters" = [ \t\u000C]+ / NL

__ "space characters" = [ \t\u000C]* / NL*

NL "new line" = v:[\r\n]+ { return { section: 'ExtHTMLDocument', type: 'NEW_LINE', value: v, attrs:[], dynamic_attrs:[], event_attrs:[], children:[], location: location() }; }