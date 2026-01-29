module Generator3

import AST;
import Syntax;
import Parser;
import Implode;
import IO;
import List;
import String;

str printAction(Action action) {
    if (action.lunchAction?) return printAction(action.lunchAction);
    if (action.meetingAction?) return printAction(action.meetingAction);
    if (action.paperAction?) return printAction(action.paperAction);
    if (action.paymentAction?) return printAction(action.paymentAction);
    return "Unknown action!";
}

str printAction(LunchAction lunchAction) {
    return "Lunch at location <lunchAction.location>";
}

str printAction(MeetingAction meetingAction) {
    return "Meeting about <meetingAction.topic>";
}

str printAction(PaperAction paperAction) {
    return "Report <paperAction.report>";
}

str printAction(PaymentAction paymentAction) {
    return "Pay <paymentAction.amount> Euro";
}

str printDuration(duration) {
    visit (duration) {
        case duration(dl, unit): {
            u = "";
            visit (unit) {
                case minute(): u = "m";
                case hour(): u = "h";
                case day(): u = "d";
                case week(): u = "w";
            }
            return "with duration: <dl> <u>";
        }
    }
    return "";
}

str printTaskWithDuration(ast) {
    rVal = [];
    comp = [ <action, duration> | /task(action, _, duration) := ast ];
    for (<a, d> <- comp) {
        rVal += "<printAction(a)> <printDuration(d)>";
    }
    return intercalate(" &\n", rVal);
}

str printTaskWithoutDuration(ast) {
    rVal = [];
    for (a <- { action | /task(action, _, _) := ast }) {
        rVal += "<printAction(a)>";
    }
    return intercalate(" ,\n", rVal);
}

str generator3(Planning ast) {
    rVal = "Info using comprehensions
           '======
           '<printTaskWithDuration(ast)>
           '=====
           'Other way:
           '<printTaskWithoutDuration(ast)>
           '";
    return rVal;
}

void main() {
    cast = parsePlanning(|project://rascaldsl/instance/spec1.tdsl|);
    ast = implode(cast);
    result = generator3(ast);
    println(result);
    writeFile(|project://rascaldsl/instance/output/generator3.txt|, result);
}