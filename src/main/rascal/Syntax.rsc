module Syntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

start syntax Module
    = verilangModule: 'defmodule' ID name Import* imports Declaration* decls 'end';

syntax Import
    = using: 'using' ID name;

syntax Declaration
    = DefSpace
    | DefOperator
    | DefRule
    | DefExpression
    | DefVar;

syntax DefSpace
    = defspace: 'defspace' ID name ('\<' ID base)? 'end';

syntax DefOperator
    = defoperator: 'defoperator' ID name ':' Type tp AttributeBlock? 'end';

syntax Type
    = typeBase:   ID name
    | typeInt:    'Int'
    | typeBool:   'Bool'
    | typeChar:   'Char'
    | typeString: 'String'
    > right typeArrow: Type left '-\>' Type right;

syntax AttributeBlock
    = attributeBlock: '[' Attribute+ ']';

syntax Attribute
    = attribute: ID name (':' AttributeValue)?;

syntax AttributeValue
    = attrId:    ID name
    | attrEmpty: '∅';

syntax DefVar
    = defvar: 'defvar' {VarDef ","}+ 'end';

syntax VarDef
    = vardef: ID name ':' Type tp;

syntax DefRule
    = defrule: 'defrule' OperatorApp '-\>' OperatorApp 'end';

syntax OperatorApp
    = opapp: '(' ID name Term+ ')';

syntax DefExpression
    = defexpression: 'defexpression' Expression AttributeBlock? 'end';

syntax Expression
    = quantExpr: QuantifiedExpr
    | logExpr:   LogicalExpr;

syntax QuantifiedExpr
    = forallExpr: 'forall' ID var 'in' ID domain '.' Expression body
    | existsExpr: 'exists' ID var 'in' ID domain '.' Expression body;

syntax LogicalExpr
    = equivExpr: LogicalExpr '≡'   LogicalExpr
    > implExpr:  LogicalExpr '=\>'  LogicalExpr
    > orExpr:    LogicalExpr 'or'  LogicalExpr
    > andExpr:   LogicalExpr 'and' LogicalExpr
    > negExpr:   'neg' LogicalExpr
    | relBase:   RelExpr;

syntax RelExpr
    = relExpr:   Term RelOp Term
    | inExpr:    Term 'in' Term
    | infixApp:  Term ID op Term
    | termBase:  Term;

syntax RelOp
    = eq:  '='
    | lt:  '\<'
    | gt:  '\>'
    | leq: '\<='
    | geq: '\>='
    | neq: '\<\>';

// Typed literals — criterio 4 de la rubrica
syntax Term
    = termOp:     OperatorApp
    | termId:     ID name
    | termParen:  '(' Expression ')'
    | termInt:    INT ':' 'Int'
    | termBool:   BoolLit ':' 'Bool'
    | termChar:   CHAR ':' 'Char'
    | termString: STRING ':' 'String'
    | termFloat:  FLOAT
    | termBare:   INT
    | termBareF:  FLOAT;

syntax BoolLit
    = bTrue:  'true'
    | bFalse: 'false';

lexical INT    = [0-9]+ !>> [0-9.];
lexical FLOAT  = [0-9]+ '.' [0-9]+ !>> [0-9];
lexical CHAR = [\'] ![\'\\\n] [\'];
lexical STRING = "\"" ![\"\n]* "\"";
lexical ID     = ([a-zA-Z][a-zA-Z0-9\-]* !>> [a-zA-Z0-9\-]) \ Reserved;

keyword Reserved
    = "defmodule" | "using"         | "defspace"     | "defoperator"
    | "defrule"   | "defexpression" | "defvar"       | "forall"
    | "exists"    | "defer"         | "end"
    | "and"       | "or"            | "neg"           | "in"
    | "Int"       | "Bool"          | "Char"          | "String"
    | "true"      | "false";