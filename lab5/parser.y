%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
void yyerror(char *s);
%}
%union {
    double dval;
}
%token <dval> id num
%type <dval> expr
%left '+' '-'
%left '*' '/' '%'
%right UMINUS

%%
stmt : expr { printf("\nValid Expression\n"); };
expr : '(' expr ')' { $$ = $2; }
        | expr '+' expr { printf("\nPlus"); $$ = $1 + $3; printf("\nResult: %.2lf", $$); }
        | expr '-' expr { printf("\nMinus "); $$ = $1 - $3; printf("\nResult: %.2lf", $$); }
        | expr '*' expr { printf("\nMultiplication "); $$ = $1 * $3; printf("\nResult: %.2lf", $$); }
        | expr '/' expr { 
            printf("\nDivision "); 
            if ($3 == 0) { printf("\nError: Division by zero!"); exit(1); }
            else { $$ = $1 / $3; printf("\nResult: %.2lf", $$); }
        }
        | expr '%' expr { printf("\nModulus recognized"); $$ = (int)$1 % (int)$3; printf("\nResult: %.2lf", $$); }
        | '-' expr %prec UMINUS { $$ = -$2; printf("\nUnary minus applied, Result: %.2lf", $$); }
        | num { $$ = $1; }
        ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main() {
    printf("Enter an arithmetic expression: ");
    yyparse();
    return 0;
}
