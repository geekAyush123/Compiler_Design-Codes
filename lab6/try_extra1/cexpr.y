%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);

int is_arithmetic = 0, is_relational = 0, is_logical = 0; // Flags to identify expression type
int result = 0;  // Store evaluation result
%}

%token IDENTIFIER CONSTANT STRING_LITERAL
%token AND_OP OR_OP EQ_OP NE_OP LE_OP GE_OP
%token ERROR

%left OR_OP
%left AND_OP
%left EQ_OP NE_OP
%left '<' '>' LE_OP GE_OP
%left '+' '-'
%left '*' '/' '%'
%right UNARY

%%

input
    : /* empty */
    | input expression '\n' {
        if (is_logical) {
            printf("Logical Expression. Evaluated Result: %d\n", result);
        } else if (is_relational) {
            printf("Relational Expression. Evaluated Result: %d\n", result);
        } else if (is_arithmetic) {
            printf("Arithmetic Expression. Evaluated Result: %d\n", result);
        } else {
            printf(" Invalid Expression.\n");
        }
        is_arithmetic = is_relational = is_logical = 0; // Reset flags
    }
    | input error '\n' { yyerror(" Invalid expression"); yyerrok; }
    ;

expression
    : logical_or_expression { result = $1; }
    ;

logical_or_expression
    : logical_and_expression { $$ = $1; }
    | logical_or_expression OR_OP logical_and_expression { $$ = $1 || $3; is_logical = 1; }
    ;

logical_and_expression
    : equality_expression { $$ = $1; }
    | logical_and_expression AND_OP equality_expression { $$ = $1 && $3; is_logical = 1; }
    ;

equality_expression
    : relational_expression { $$ = $1; }
    | equality_expression EQ_OP relational_expression { $$ = ($1 == $3); is_relational = 1; }
    | equality_expression NE_OP relational_expression { $$ = ($1 != $3); is_relational = 1; }
    ;

relational_expression
    : additive_expression { $$ = $1; }
    | relational_expression '>' additive_expression { $$ = ($1 > $3); is_relational = 1; }
    | relational_expression '<' additive_expression { $$ = ($1 < $3); is_relational = 1; }
    | relational_expression GE_OP additive_expression { $$ = ($1 >= $3); is_relational = 1; }
    | relational_expression LE_OP additive_expression { $$ = ($1 <= $3); is_relational = 1; }
    ;

additive_expression
    : multiplicative_expression { $$ = $1; }
    | additive_expression '+' multiplicative_expression { $$ = $1 + $3; is_arithmetic = 1; }
    | additive_expression '-' multiplicative_expression { $$ = $1 - $3; is_arithmetic = 1; }
    ;

multiplicative_expression
    : unary_expression { $$ = $1; }
    | multiplicative_expression '*' unary_expression { $$ = $1 * $3; is_arithmetic = 1; }
    | multiplicative_expression '/' unary_expression { 
        if ($3 == 0) {
            yyerror(" Division by zero!");
            YYERROR;
        }
        $$ = $1 / $3; 
        is_arithmetic = 1; 
    }
    | multiplicative_expression '%' unary_expression { $$ = $1 % $3; is_arithmetic = 1; }
    ;

unary_expression
    : postfix_expression { $$ = $1; }
    | '+' unary_expression %prec UNARY { $$ = +$2; }
    | '-' unary_expression %prec UNARY { $$ = -$2; }
    | '!' unary_expression %prec UNARY { $$ = !$2; is_logical = 1; }
    ;

postfix_expression
    : primary_expression { $$ = $1; }
    ;

primary_expression
    : IDENTIFIER { $$ = 0; /* Assume identifier value is 0 for now */ }
    | CONSTANT { $$ = yylval; }  // Use yylval instead of yytext
    | STRING_LITERAL { $$ = 0; /* Ignore strings */ }
    | '(' expression ')' { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
        printf("Reading expressions from %s\n", argv[1]);
    } else {
        printf("Enter C expressions (Ctrl+D to end):\n");
    }
    fflush(stdout);

    yyparse();

    return 0;
}