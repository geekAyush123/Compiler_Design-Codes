%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
%}
%%
[0-9]+   { 
    yylval.ival = atoi(yytext); 
    return NUM; 
}
[\t]+    { /* Ignore tabs */ }
\n       { return 0; }
.        { return yytext[0]; }
%%
int yywrap() {
    return 1;
}
