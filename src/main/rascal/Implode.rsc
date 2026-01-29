module Implode

import AST;
import Syntax;
import ParseTree;

Planning implode(start[Planning] tree) {
    return implode(#Planning, tree);
}
