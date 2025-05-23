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
			/ UnreservedKeyWord
            / ColNameKeyword
            / TypeFuncNameKeyword
            / ReservedKeyword

Identifier = VarName Uescape?
    / UnicodeQuotedIdentifier
    / Plsqlvariablename

Uescape = "UESCAPE"i AnyConst

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
    / Uescape
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
        / BExpr Typecast TypeName
        //right	unary plus, unary minus
        / ( Plus / Minus ) BExpr
        //^	left	exponentiation
        / BExpr Caret BExpr
        // / %	left	multiplication, division, modulo
        / BExpr ( Star / Slash / Percent ) BExpr
        //+ -	left	addition, subtraction
        / BExpr ( Plus / Minus ) BExpr
        //(any other operator)	left	all other native and user-defined operators
        / BExpr QualOp BExpr
        //< > = <= >= <>	 	comparison operators
        / BExpr ( "<" / ">" / "=" / "!=" / "<>" / ">=" / "<=" ) BExpr
        / QualOp BExpr
        / BExpr QualOp
        / BExpr Is Not? ( Distinct From BExpr / Of "(" TypeList ")" / Document_p )
        
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

Collate = "COLLATE"

From = "FROM"

Of = "OF"

Or = "OR"

And = "AND"

Not = "NOT"

Between = "BETWEEN"

Unknown = "UNKNOWN"

Normalized = "NORMALIZED"

In = "IN"

Is = "IS"

At = "AT"

Time = "TIME"

Zone = "ZONE"

Isnull = "ISNULL"

Notnull = "NOTNULL"

Null = "NULL"

True = "TRUE"

False = "FALSE"

Minus = "-"

Plus = "+"

Typecast = "::"

Slash = "/"

Percent = "%"


InExpr = SelectWithParens / "(" ExprList ")"

TypeList = TypeName ( "," TypeName )*

UnicodeNormalForm = Nfc / Nfd / Nfkc / Nfkd

Nfc = "NFC"

Nfd = "NFD"

Nfkc = "NFKC"

Nfkd = "NFKD"

SetOf = "SETOF"


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

ValidString = UnicodeChar+ / __+

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
