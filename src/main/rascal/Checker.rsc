module Checker

import IO;
import Syntax;
import ParseTree;
import String;
import List;
import Set;
import Message;

set[str] getDefinedSpaces(start[Module] pt) {
    set[str] spaces = {};
    for (/(DefSpace) `defspace <ID name> end` := pt)
        spaces += "<name>";
    for (/(DefSpace) `defspace <ID name> \< <ID base> end` := pt)
        spaces += "<name>";
    return spaces;
}

set[str] getDefinedOperators(start[Module] pt) {
    set[str] ops = {};
    for (/(DefOperator) `defoperator <ID name> : <Type _> end` := pt)
        ops += "<name>";
    for (/(DefOperator) `defoperator <ID name> : <Type _> <AttributeBlock _> end` := pt)
        ops += "<name>";
    return ops;
}

set[str] getDefinedVars(start[Module] pt) {
    set[str] vars = {};
    for (/(VarDef) `<ID name> : <Type _>` := pt)
        vars += "<name>";
    return vars;
}

list[str] checkVeriLang(start[Module] pt) {
    list[str] errors = [];
    set[str] spaces = getDefinedSpaces(pt);
    set[str] ops    = getDefinedOperators(pt);
    set[str] vars   = getDefinedVars(pt);

    for (/(DefSpace) `defspace <ID _> \< <ID base> end` := pt)
        if ("<base>" notin spaces)
            errors += ["Error: space <base> is not defined"];

    for (/(QuantifiedExpr) `forall <ID _> in <ID domain> . <Expression _>` := pt)
        if ("<domain>" notin spaces)
            errors += ["Error: space <domain> is not defined (used in forall)"];

    for (/(QuantifiedExpr) `exists <ID _> in <ID domain> . <Expression _>` := pt)
        if ("<domain>" notin spaces)
            errors += ["Error: space <domain> is not defined (used in exists)"];

    for (/(OperatorApp) `( <ID name> <Term+ _> )` := pt)
        if ("<name>" notin ops)
            errors += ["Error: operator <name> is not defined"];

    for (/(RelExpr) `<Term _> <ID op> <Term _>` := pt)
        if ("<op>" notin ops)
            errors += ["Error: operator <op> is not defined (used as infix)"];

    return errors;
}

public void checkFromFile(loc file) {
    start[Module] pt = parse(#start[Module], file);
    list[str] errors = checkVeriLang(pt);
    if (errors == []) {
        println("No semantic errors found.");
    }
    else {
        println("Semantic errors found:");
        for (str e <- errors) {
            println("  - <e>");
        }
    }
}