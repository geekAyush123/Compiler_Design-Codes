%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

extern int yylval;
%}

%%

[ \t]+         ;  /* Ignore whitespaces */
\n             return '\n';

[0-9]+        { yylval = atoi(yytext); return CONSTANT; }
[a-zA-Z_][a-zA-Z0-9_]*  return IDENTIFIER;

"&&"          return AND_OP;
"||"          return OR_OP;
"=="          return EQ_OP;
"!="          return NE_OP;
">="          return GE_OP;
"<="          return LE_OP;
">"           return '>';
"<"           return '<';
"+"           return '+';
"-"           return '-';
"*"           return '*';
"/"           return '/';
"%"           return '%';
"("           return '(';
")"           return ')';
"!"           return '!';

"\""([^\"]*)"\"" { yylval = 0; return STRING_LITERAL; }

.              return ERROR;

%%

int yywrap() {
    return 1;
}