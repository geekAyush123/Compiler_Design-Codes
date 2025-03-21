%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
%}

%%
[a-zA-Z][a-zA-Z0-9]* { 
    printf("\nEnter the value of variable %s: ", yytext);
    double val;
    scanf("%lf", &val);
    yylval.dval = val;
    
    return id; 
}
[0-9]+(\.[0-9]+)? { yylval.dval = atof(yytext); return num; }
[ \t]+
\n       {return 0;}
.        { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
