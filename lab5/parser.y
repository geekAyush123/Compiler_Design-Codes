%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);  // Declare yylex, defined in lexer.l
extern int yyerror(const char *s);  // Declare yyerror, defined below
%}

%token NUMBER
%left '+' '-'
%left '*' '/'
%left UMINUS

%%

program:
    | program expr '\n' { printf("Valid expression, result: %d\n", $2); }
    ;

expr:
    expr '+' expr    { $$ = $1 + $3; }
    | expr '-' expr  { $$ = $1 - $3; }
    | expr '*' expr  { $$ = $1 * $3; }
    | expr '/' expr  { 
                        if ($3 == 0) {
                            yyerror("Division by zero!");
                            exit(1);
                        }
                        $$ = $1 / $3; 
                      }
    | '(' expr ')'   { $$ = $2; }
    | NUMBER         { $$ = $1; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    ;

%%

int main(void) {
    printf("Enter an arithmetic expression: ");
    int result = yyparse();  // Start parsing
    if (result == 0) {
        printf("Parsing successful\n");
    } else {
        printf("Parsing failed\n");
    }
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}
