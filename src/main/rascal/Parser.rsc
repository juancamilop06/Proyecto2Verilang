module Parser

import Syntax;
import ParseTree;

start[Module] parseVeriLang(loc l) = parse(#start[Module], l);
start[Module] parseVeriLang(str s, loc l) = parse(#start[Module], s, l);