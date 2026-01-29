module Checker

extend analysis::typepal::TypePal;
import Syntax;
import ParseTree;
import util::LanguageServer;
import String;

data IdRole = personId();

data AType = personType();

data Person = person(str role = "Employee", int age = 0);

data DefInfo(list[Person] person = []);

void collect(current: (Person)`<ID name> { <Role role> , age <INT age> }`, Collector c) {
    dt = defType(personType());
    dt.person = [person(role="<role>", age=toInt("<age>"))];
    c.define("<name>", personId(), name, dt);
}

void collect(current: (Task)`Task <Action action> person <ID name> priority: <INT prio> <Duration? duration>`, Collector c) {
    c.use(name, {personId()});
}

public TModel TModelFromTree(Tree pt) {
    if (pt has top) pt = pt.top;
    c = newCollector("collectAndSolve", pt, tconfig());
    collect(pt, c);
    return newSolver(pt, c.run()).run();
}

Summary check(Planning p) {
    tm = TModelFromTree(p);
    defs = getUseDef(tm);
    return summary(p.src, 
        messages = {<m.at, m> | m <- getMessages(tm), !(m is info)}, 
        definitions = defs
    );
}