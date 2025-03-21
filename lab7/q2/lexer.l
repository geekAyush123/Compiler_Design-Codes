%{
    #include "y.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
%}

%%

"=="   { return EQ; }
"!="   { return NEQ; }
"&"    { return '&'; }
"|"    { return '|'; }
"!"    { return '!'; }
"("    { return '('; }
")"    { return ')'; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.ival = 0; return IDENTIFIER; }  // Variable names
[0-9]+ { yylval.ival = atoi(yytext); return IDENTIFIER; }  // Numeric identifiers
[\t ]+ { /* Ignore tabs and spaces */ }
\n     { return '\n'; }
.      { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
