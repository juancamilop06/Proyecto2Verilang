module TPChecker

extend analysis::typepal::TypePal;

import Syntax;
import ParseTree;

data IdRole
    = spaceId()
    | operatorId()
    | varId();

data AType
    = intType()
    | boolType()
    | charType()
    | stringType()
    | userType(str name);

void collect(current: (Type) `Int`,    Collector c) { c.fact(current, intType());    }
void collect(current: (Type) `Bool`,   Collector c) { c.fact(current, boolType());   }
void collect(current: (Type) `Char`,   Collector c) { c.fact(current, charType());   }
void collect(current: (Type) `String`, Collector c) { c.fact(current, stringType()); }
void collect(current: (Type) `<ID name>`, Collector c) { c.fact(current, userType("<name>")); }

void collect(current: (Module) `defmodule <ID _> <Import* _> <Declaration* _> end`, Collector c) {
    visit(current) {
        case (DefSpace) `defspace <ID name> end`:
            c.define("<name>", spaceId(), name, defType(userType("<name>")));
        case (DefSpace) `defspace <ID name> \< <ID base> end`: {
            c.define("<name>", spaceId(), name, defType(userType("<name>")));
            c.use(base, {spaceId()});
        }
        case (DefOperator) `defoperator <ID name> : <Type tp> end`: {
            c.define("<name>", operatorId(), name, defType(userType("<name>")));
            collect(tp, c);
        }
        case (DefOperator) `defoperator <ID name> : <Type tp> <AttributeBlock _> end`: {
            c.define("<name>", operatorId(), name, defType(userType("<name>")));
            collect(tp, c);
        }
        case (VarDef) `<ID name> : <Type tp>`: {
            c.define("<name>", varId(), name, defType(userType("<name>")));
            collect(tp, c);
        }
    }
}

public TModel TModelFromTree(start[Module] pt) {
    TypePalConfig cfg = tconfig();
    Collector col = newCollector("verilangCollect", pt, cfg);
    collect(pt.top, col);
    return newSolver(pt, col.run()).run();
}

public void checkTypesFromFile(loc file) {
    start[Module] pt = parse(#start[Module], file);
    TModel tm = TModelFromTree(pt);
    list[Message] msgs = [m | m <- getMessages(tm), !(m is info)];
    if (msgs == []) {
        println("[TypePal] TModel OK - no errors");
    }
    else {
        println("[TypePal] Messages:");
        for (msg <- msgs) {
            println("  - <msg>");
        }
    }
}