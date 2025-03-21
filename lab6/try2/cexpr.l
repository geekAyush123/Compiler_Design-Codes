/* cexpr.l - Lexical analyzer for C expressions */
%{
#include <stdio.h>
#include "y.tab.h"

extern int yylineno;
%}

%%

"&&"        { printf("Token: AND_OP (%s)\n", yytext); return AND_OP; }
"||"        { printf("Token: OR_OP (%s)\n", yytext); return OR_OP; }
"=="        { printf("Token: EQ_OP (%s)\n", yytext); return EQ_OP; }
"!="        { printf("Token: NE_OP (%s)\n", yytext); return NE_OP; }
"<="        { printf("Token: LE_OP (%s)\n", yytext); return LE_OP; }
">="        { printf("Token: GE_OP (%s)\n", yytext); return GE_OP; }

[a-zA-Z_][a-zA-Z0-9_]*  { printf("Token: IDENTIFIER (%s)\n", yytext); return IDENTIFIER; }

0[xX][0-9a-fA-F]+       { printf("Token: CONSTANT (%s)\n", yytext); return CONSTANT; }
0[0-7]+                 { printf("Token: CONSTANT (%s)\n", yytext); return CONSTANT; }
[0-9]+                  { printf("Token: CONSTANT (%s)\n", yytext); return CONSTANT; }
[0-9]*"."[0-9]+         { printf("Token: CONSTANT (%s)\n", yytext); return CONSTANT; }
[0-9]+"."[0-9]*         { printf("Token: CONSTANT (%s)\n", yytext); return CONSTANT; }

\"[^"]*\"               { printf("Token: STRING_LITERAL (%s)\n", yytext); return STRING_LITERAL; }
\'[^']*\'               { printf("Token: CONSTANT (%s)\n", yytext); return CONSTANT; }

[ \t\n\r]               { /* Skip whitespace */ }

"+"         { printf("Token: PLUS (%s)\n", yytext); return '+'; }
"-"         { printf("Token: MINUS (%s)\n", yytext); return '-'; }
"*"         { printf("Token: MULTIPLY (%s)\n", yytext); return '*'; }
"/"         { printf("Token: DIVIDE (%s)\n", yytext); return '/'; }
"%"         { printf("Token: MODULO (%s)\n", yytext); return '%'; }
"<"         { printf("Token: LT (%s)\n", yytext); return '<'; }
">"         { printf("Token: GT (%s)\n", yytext); return '>'; }
"("         { printf("Token: LPAREN (%s)\n", yytext); return '('; }
")"         { printf("Token: RPAREN (%s)\n", yytext); return ')'; }
"!"         { printf("Token: NOT (%s)\n", yytext); return '!'; }

.           { printf("Unrecognized character: %s at line %d\n", yytext, yylineno); return ERROR; }

%%

int yywrap() {
    return 1;
}
