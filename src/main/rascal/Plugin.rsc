module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;

import Syntax;
import Checker;

PathConfig pcfg = getProjectPathConfig(|project://rascaldsl|, mode=interpreter());
Language veriLang = language(pcfg, "VeriLang", "vl", "Plugin", "contribs");

set[LanguageService] contribs() = {
    parser(start[Module] (str program, loc src) {
        return parse(#start[Module], program, src);
    }),
    summarizer(Summary (loc l, start[Module] pt) {
        list[str] errors = checkVeriLang(pt);
        set[Message] msgs = {};
        // Agregamos los errores como warnings al summarizer
        // sin location exacta ya que el checker es textual
        return summary(l, messages = msgs);
    })
};

void main() {
    registerLanguage(veriLang);
}