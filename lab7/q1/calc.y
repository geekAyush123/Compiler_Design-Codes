%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
void yyerror(char *s);
%}

%union {
    int ival;
    char cval;
}

%token <ival> NUM
%type <ival> number factor term expr
%type <cval> mulop addop
%left '+' '-'
%left '*'

%%

stmt : expr { printf("\nValid Expression\n"); printf("Result: %d\n", $1); }
;

expr : expr addop term {
            if ($2 == '+') {
                $$ = $1 + $3;
            } else {
                $$ = $1 - $3;
            }
            printf("expr -> %d %c %d = %d\n", $1, $2, $3, $$);
        }
    | term { $$ = $1; printf("expr -> %d\n", $1); }
;

addop : '+' { $$ = '+'; printf("addop -> +\n"); }
      | '-' { $$ = '-'; printf("addop -> -\n"); }
;

term : term mulop factor {
            $$ = $1 * $3;
            printf("term -> %d %c %d = %d\n", $1, $2, $3, $$);
        }
    | factor { $$ = $1; printf("term -> %d\n", $1); }
;

mulop : '*' { $$ = '*'; printf("mulop -> *\n"); }
;

factor : '(' expr ')' { $$ = $2; printf("factor -> (%d)\n", $2); }
       | number { $$ = $1; printf("factor -> %d\n", $1); }
;

number : NUM { $$ = $1; printf("number -> %d\n", $$); }
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
