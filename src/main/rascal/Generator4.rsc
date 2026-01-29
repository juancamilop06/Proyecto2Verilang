module Generator4

import IO;
import Set;
import List;
// import AST;
import Syntax;
import String;

import Parser;
// import Implode;


str generator4(cst) {
    rVal = 
        "Info of the planning DepartmentABC
        'All Persons:
	    '       <for (person <- {name | /(PersonTasks) `Person <ID name> <Task+ tasks>` := cst }) {><person>
        '       <}>
        'All actions of tasks:
        '======
        '        <printTaskWithDuration(cst)>
        '=====
        'Other way of listing all tasks:
        '        <printTaskWithoutDuration(cst)>
        '";
    return rVal;
}

str printTaskWithDuration(ast) {
    rVal = [];
    for (<a, p, d> <- [ <action, prio, duration> | /(Task) `Task <Action action> priority: <INT prio> <Duration? duration>` := ast ]) {
        rVal += "<printAction(a)> <p> <printDuration(d)>";
    }
    return intercalate(" &\n", rVal);
}

str printTaskWithoutDuration(ast) {
    rVal = [];
    for (<a, p> <- { <action, prop> | /(Task) `Task <Action action> priority: <INT prio> <Duration? duration>` := ast }) {
        rVal += "<printAction(a)> <p>";
    }
    return intercalate(" ,\n", rVal);
}

str printAction(action) {
    if (/(LunchAction) `Lunch <ID location>`      := action)  return "Lunch at location <location>";
    if (/(MeetingAction) `Meeting <STRING topic>` := action)  return "Meeting with topic <replaceAll("<topic>", "\"", "")>";
    if (/(PaperAction) `Report <ID report>`       := action)  return "Paper for journal <report>";
    if (/(PaymentAction) `Pay <INT amount> euro`  := action)  return "Pay <amount> Euro";
    return "Unknown action!";
}

str printDuration(duration) {
    rVal = "";
    if (/(Duration) `duration: <INT dl> <TimeUnit unit>` := duration) {
        u = "";
        if (/(Minute) `min` := duration) u = "m";
        if (/(Hour) `hour`  := duration) u = "h";
        if (/(Day) `day`    := duration) u = "d";
        if (/(Week) `week`  := duration) u = "w";
        return "with duration: <dl> <u>";
    } else {
        ; // duration is optional
    }
    return rVal;
}
