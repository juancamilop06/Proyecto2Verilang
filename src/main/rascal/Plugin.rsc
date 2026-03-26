module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;

import Syntax;

PathConfig pcfg = getProjectPathConfig(|project://rascaldsl|, mode=interpreter());
Language veriLang = language(pcfg, "VeriLang", "vl", "Plugin", "contribs");

set[LanguageService] contribs() = {
    parser(start[Module] (str program, loc src) {
        return parse(#start[Module], program, src);
    })
};

void main() {
    registerLanguage(veriLang);
}