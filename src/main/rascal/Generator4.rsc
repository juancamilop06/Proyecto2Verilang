module Generator4

import Syntax;
import Parser;
import IO;
import List;
import String;
import ParseTree;

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

str printTaskWithDuration(cst) {
    rVal = [];
    visit (cst) {
        case (Task)`Task <Action action> priority: <INT prio> <Duration? duration>`:
            rVal += "<printAction(action)> <printDuration(duration)>";
    }
    return intercalate(" &\n", rVal);
}

str printTaskWithoutDuration(cst) {
    rVal = [];
    for (a <- { action | 
        /(Task)`Task <Action action> priority: <INT prio> <Duration? duration>` := cst }) {
        rVal += "<printAction(a)>";
    }
    return intercalate(" ,\n", rVal);
}

str generator4(start[Planning] cst) {
    rVal = "Info using concrete syntax
           '======
           '<printTaskWithDuration(cst)>
           '=====
           'Other way:
           '<printTaskWithoutDuration(cst)>
           '";
    return rVal;
}

void main() {
    cst = parsePlanning(|project://rascaldsl/instance/spec1.tdsl|);
    result = generator4(cst);
    println(result);
    writeFile(|project://rascaldsl/instance/output/generator4.txt|, result);
}