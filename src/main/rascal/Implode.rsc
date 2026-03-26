module Implode

import Syntax;
import AST;
import ParseTree;
import Node;

public Module implodeModule(Tree pt) = implode(#Module, pt);