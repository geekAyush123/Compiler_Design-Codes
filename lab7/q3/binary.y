%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
void yyerror(char *s);
%}

%union {
    int n;
    float f;
}

%token <n> DIGIT
%token DOT
%type <n> A
%type <f> S B

%%

S   : A          { printf("\nDecimal: %d\n", $1); }
    | A DOT B    { printf("\nDecimal: %f\n", $1 + $3); }
    ;

A   : A DIGIT    { $$ = ($1 << 1) + $2; }
    | DIGIT      { $$ = $1; }
    ;

B   : DIGIT B    { $$ = $2 / 2.0 + $1 / 2.0; }
    | DIGIT      { $$ = $1 / 2.0; }
    ;


%%

void yyerror(char *s) {
    fprintf(stderr, "\nYYERROR: %s\n", s);
}

int main() {
    printf("\nInput: ");
    yyparse();
    return 0;
}
