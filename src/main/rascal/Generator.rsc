module Generator

import IO;
import List;
import String;
import ParseTree;
import Syntax;

void main() {
    loc inFile = |project://rascaldsl/instance/spec_verilang.vl|;
    loc outFile = |project://rascaldsl/instance/output/summary.txt|;

    println("Parsing <inFile>...");
    start[Module] cst = parse(#start[Module], inFile);

    str result = generateSummary(cst);
    println(result);
    writeFile(outFile, result);
    println("Written to <outFile>");
}

str generateSummary(cst) {
    rVal =
        "=== VeriLang Module Summary ===
        'Module: <getModuleName(cst)>
        'Imports:
        '  <printImports(cst)>
        'Spaces:
        '  <printSpaces(cst)>
        'Operators:
        '  <printOperators(cst)>
        'Variables:
        '  <printVars(cst)>
        'Rules:
        '  <printRules(cst)>
        'Expressions:
        '  <printExpressions(cst)>
        '===============================
        '";
    return rVal;
}

str getModuleName(cst) {
    if (/(Module) `defmodule <ID name> <Import* _> <Declaration* _> end` := cst)
        return "<name>";
    return "unknown";
}

str printImports(cst) {
    rVal = [];
    for (/(Import) `using <ID name>` := cst)
        rVal += "using <name>";
    return isEmpty(rVal) ? "(none)" : intercalate("\n  ", rVal);
}

str printSpaces(cst) {
    rVal = [];
    for (/(DefSpace) `defspace <ID name> end` := cst)
        rVal += "<name>";
    for (/(DefSpace) `defspace <ID name> \< <ID base> end` := cst)
        rVal += "<name> \< <base>";
    return isEmpty(rVal) ? "(none)" : intercalate("\n  ", rVal);
}

str printOperators(cst) {
    rVal = [];
    for (/(DefOperator) `defoperator <ID name> : <Type tp> end` := cst)
        rVal += "<name> : <tp>";
    for (/(DefOperator) `defoperator <ID name> : <Type tp> <AttributeBlock _> end` := cst)
        rVal += "<name> : <tp> [attrs]";
    return isEmpty(rVal) ? "(none)" : intercalate("\n  ", rVal);
}

str printVars(cst) {
    rVal = [];
    for (/(VarDef) `<ID name> : <Type tp>` := cst)
        rVal += "<name> : <tp>";
    return isEmpty(rVal) ? "(none)" : intercalate("\n  ", rVal);
}

str printRules(cst) {
    rVal = [];
    for (/(DefRule) `defrule <OperatorApp lhs> -\> <OperatorApp rhs> end` := cst)
        rVal += "<lhs> -\> <rhs>";
    return isEmpty(rVal) ? "(none)" : intercalate("\n  ", rVal);
}

str printExpressions(cst) {
    rVal = [];
    for (/(DefExpression) `defexpression <Expression expr> end` := cst)
        rVal += "<expr>";
    for (/(DefExpression) `defexpression <Expression expr> <AttributeBlock _> end` := cst)
        rVal += "<expr> [attrs]";
    return isEmpty(rVal) ? "(none)" : intercalate("\n  ", rVal);
}