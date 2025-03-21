/* cdecl.l - Improved lexical analyzer for C declarations */
%{
#include <stdio.h>
#include "y.tab.h"
%}

%%

"void"      { return VOID; }
"char"      { return CHAR; }
"short"     { return SHORT; }
"int"       { return INT; }
"long"      { return LONG; }
"float"     { return FLOAT; }
"double"    { return DOUBLE; }
"signed"    { return SIGNED; }
"unsigned"  { return UNSIGNED; }
"const"     { return CONST; }
"volatile"  { return VOLATILE; }
"extern"    { return EXTERN; }
"static"    { return STATIC; }
"register"  { return REGISTER; }
"struct"    { return STRUCT; }
"enum"      { return ENUM; }

[a-zA-Z_][a-zA-Z0-9_]*  { return IDENTIFIER; }

[0-9]+                  { return CONSTANT; }
[0-9]*"."[0-9]+         { return CONSTANT; }
[0-9]+"."[0-9]*         { return CONSTANT; }

\"[^"]*\"               { return STRING_LITERAL; }
\'[^']*\'               { return CONSTANT; }  /* Character constant */

[ \t\n\r]               { /* Skip whitespace */ }

.                       { return yytext[0]; }  /* Return single chars */

%%

/* Redefine yywrap to avoid dependency on -ll library */
int yywrap() {
    return 1;
}