%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
%}

%%

[01]    { 
    yylval.n = yytext[0] - '0';
    return DIGIT;
}

\.      { 
    return DOT; 
}

[ \t]+  {}

\n      { 
    return 0; 
}

.       { 
    return yytext[0]; 
}

%%

int yywrap() { return 1; }
