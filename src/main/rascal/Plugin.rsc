module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;
import Syntax;
import Checker;

PathConfig pcfg = getProjectPathConfig(|project://rascaldsl|);
Language tdslLang = language(pcfg, "TDSL", "tdsl", "Plugin", "contribs");

set[LanguageService] contribs() = {
    parser(start[Planning] (str program, loc src) {
        return parse(#start[Planning], program, src);
    }),
    summarizer(Summary (loc _, start[Planning] p) {
        return check(p.top);
    })
};

void main() {
    registerLanguage(tdslLang);
}