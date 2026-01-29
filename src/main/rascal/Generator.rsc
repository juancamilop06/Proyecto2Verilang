module Generator

import Syntax;
import Parser;
import Checker;
import IO;
import List;
import String;
import ParseTree;
import analysis::typepal::TypePal;

str printAction((Action)`Lunch <ID location>`) {
    return "Lunch at location <location>";
}

str printAction((Action)`Meeting <STRING topic>`) {
    return "Meeting about <topic>";
}

str printAction((Action)`Report <ID report>`) {
    return "Report <report>";
}

str printAction((Action)`Pay <INT amount> euro`) {
    return "Pay <amount> Euro";
}

str printDuration((Duration)`duration: <INT dl> <TimeUnit unit>`) {
    u = "";
    if ((TimeUnit)`min` := unit) u = "m";
    else if ((TimeUnit)`hour` := unit) u = "h";
    else if ((TimeUnit)`day` := unit) u = "d";
    else if ((TimeUnit)`week` := unit) u = "w";
    return "with duration: <dl> <u>";
}

default str printDuration(Duration? _) = "";

str printOrganizer(name, tm) {
    DefInfo defInfo = findReference(tm, name);
    if (p <- defInfo.person) {
        return "Organizer is: <name>, role: <p.role>, age: <p.age> -\>";
    }
    throw "Fix references in language instance";
}

DefInfo findReference(tm, use) {
    defs = getUseDef(tm);
    if (def <- defs[use.src]) {
        return tm.definitions[def].defInfo;
    }
    throw "Fix references in language instance";
}

str printTaskWithoutDuration(cst, tm) {
    rVal = [];
    for (<a, m> <- { <action, name> | 
        /(Task)`Task <Action action> person <ID name> priority: <INT prio> <Duration? duration>` := cst }) {
        rVal += "<printOrganizer(m, tm)> <printAction(a)>";
    }
    return intercalate(" ,\n", rVal);
}

str generator(start[Planning] cst) {
    tm = TModelFromTree(cst);
    rVal = "Info using TypePal
           '<printTaskWithoutDuration(cst, tm)>
           '";
    return rVal;
}

void main() {
    cst = parsePlanning(|project://rascaldsl/instance/spec2.tdsl|);
    result = generator(cst);
    println(result);
    writeFile(|project://rascaldsl/instance/output/generator.txt|, result);
}