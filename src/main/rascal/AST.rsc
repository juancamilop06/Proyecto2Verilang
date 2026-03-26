module AST

data Module = verilangModule(str name, list[Import] imports, list[Decl] decls);

data Import = using(str name);

data Decl 
    = spaceDecl(str name, list[str] base)
    | operatorDecl(str name, Type tp, list[Attribute] attrs)
    | ruleDecl(OperatorApp lhs, OperatorApp rhs)
    | expressionDecl(Expression expr, list[Attribute] attrs)
    | varDecl(list[VarDef] vars);

data Type 
    = typeBase(str name)
    | typeArrow(str name, Type next);

data Attribute = attribute(str name, list[str] val);

data VarDef = vardef(str name, Type tp);

data OperatorApp = opapp(str name, list[Term] args);

data Term 
    = tOpApp(OperatorApp op)
    | tId(str name)
    | tParen(Expression expr)
    | tInt(int i)
    | tFloat(real f)
    | tInfix(Term tleft, str op, Term tright);

data Expression 
    = forallExpr(str var, str domain, Expression body)
    | existsExpr(str var, str domain, Expression body)
    | equivExpr(Expression eleft, Expression eright)
    | implExpr(Expression eleft, Expression eright)
    | orExpr(Expression eleft, Expression eright)
    | andExpr(Expression eleft, Expression eright)
    | negExpr(Expression e)
    | relExpr(Term rleft, str op, Term rright)
    | inExpr(Term ileft, Term iright)
    | infixApp(Term aleft, str op, Term aright)
    | exprTerm(Term t);