%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
void yyerror(char *s);
%}

%union {
    int ival;
}

%token <ival> IDENTIFIER
%token EQ NEQ
%type <ival> exp exp_2 exp_3 exp_4 exp_5
%left '|' '&'
%left EQ NEQ

%%

program  : program exp '\n' { printf("Result = %d\n", $2); }
         | /* empty */ 
         ;

exp      : exp_2                         { $$ = $1; printf("exp -> exp_2 = %d\n", $$); }
         | exp '&' exp_2                  { $$ = $1 & $3; printf("exp -> exp & exp_2 = %d\n", $$); }
         ;

exp_2    : exp_3                         { $$ = $1; printf("exp_2 -> exp_3 = %d\n", $$); }
         | exp_2 '|' exp_3                { $$ = $1 | $3; printf("exp_2 -> exp_2 | exp_3 = %d\n", $$); }
         ;

exp_3    : exp_4                         { $$ = $1; printf("exp_3 -> exp_4 = %d\n", $$); }
         | exp_4 EQ exp_4                 { $$ = ($1 == $3); printf("exp_3 -> exp_4 == exp_4 = %d\n", $$); }
         | exp_4 NEQ exp_4                { $$ = ($1 != $3); printf("exp_3 -> exp_4 != exp_4 = %d\n", $$); }
         ;

exp_4    : exp_5                         { $$ = $1; printf("exp_4 -> exp_5 = %d\n", $$); }
         | '!' exp_5                      { $$ = !$2; printf("exp_4 -> ! exp_5 = %d\n", $$); }
         ;

exp_5    : IDENTIFIER                     { $$ = $1; printf("exp_5 -> IDENTIFIER = %d\n", $$); }
         | '(' exp ')'                    { $$ = $2; printf("exp_5 -> ( exp ) = %d\n", $$); }
         ;

%%

void yyerror(char *s) {
    fprintf(stderr, "YYERROR: %s\n", s);
}

int main() {
    printf("Enter expressions (Ctrl+D to exit):\n");
    yyparse();
    return 0;
}
