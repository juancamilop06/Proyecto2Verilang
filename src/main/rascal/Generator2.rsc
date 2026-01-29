module Generator2

import IO;
import Set;
import List;
import AST;
import Syntax;
import String;

import Parser;
import Implode;

str generator2(cast) {
    ast = implode(cast);
    rVal = 
        "Info of the planning DepartmentABC
        'All Persons:
	    '";
        visit (ast) {
            case personTasks(name, _):
                rVal += "        <name>\n";
        }
        rVal +=
        "All actions of tasks:
        '======
        '";
        rVal += printTaskWithDuration(ast);
        rVal +=
        "
        '=====
        'Other way of listing all tasks:
        '        <printTaskWithoutDuration(ast)>
        '";
    return rVal;
}

str printTaskWithDuration(ast) {
    rVal = [];
    visit (ast) {
        case task(action, prio, duration): 
            rVal += "        <printAction(action)> <prio> <printDuration(duration)>";
    }
    return intercalate(" &\n", rVal);
}

str printTaskWithoutDuration(ast) {
    rVal = [];
    visit (ast) {
        case task(action, prio, _): 
            rVal += "<printAction(action)> <prio>";
    }
    return intercalate(" ,\n", rVal);
}

str printAction(action) {
    visit (action) {
        case lunchAction(location): return "Lunch at location <location>";
        case meetingAction(topic):  return "Meeting with topic <replaceAll(topic, "\"", "")>";
        case paperAction(report):   return "Paper for journal <report>";
        case paymentAction(amount): return "Pay <amount> Euro";
    }
    return "Unknown action!";
}

str printDuration(duration) {
    visit (duration) {
        case duration(dl, unit): {
            u = "";
            visit (unit) {
                case minute(): u = "m";
                case hour():   u = "h";
                case day():    u = "d";
                case week():   u = "w";
            }
            return "with duration: <dl> <u>";
        }
    } 
    return ""; // duration is optional
}
