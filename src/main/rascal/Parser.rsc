module Parser

import Syntax;
import ParseTree;

start[Planning] parsePlanning(loc file) {
    return parse(#start[Planning], file);
}