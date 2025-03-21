%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);
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
    | input expression '\n' { printf("✅ Valid C expression\n"); fflush(stdout); }
    | input error '\n' { yyerror("❌ Invalid expression"); yyerrok; fflush(stdout); }
    ;

expression
    : logical_or_expression
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression OR_OP logical_and_expression
    ;

logical_and_expression
    : equality_expression
    | logical_and_expression AND_OP equality_expression
    ;

equality_expression
    : relational_expression
    | equality_expression EQ_OP relational_expression
    | equality_expression NE_OP relational_expression
    ;

relational_expression
    : additive_expression
    | relational_expression '>' additive_expression
    | relational_expression '<' additive_expression
    | relational_expression GE_OP additive_expression
    | relational_expression LE_OP additive_expression
    ;

additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression
    | additive_expression '-' multiplicative_expression
    ;

multiplicative_expression
    : unary_expression
    | multiplicative_expression '*' unary_expression
    | multiplicative_expression '/' unary_expression
    | multiplicative_expression '%' unary_expression
    ;

unary_expression
    : postfix_expression
    | '+' unary_expression %prec UNARY
    | '-' unary_expression %prec UNARY
    | '!' unary_expression %prec UNARY
    ;

postfix_expression
    : primary_expression
    ;

primary_expression
    : IDENTIFIER
    | CONSTANT
    | STRING_LITERAL
    | '(' expression ')'
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
    }

    printf("Enter C expressions (Ctrl+D on Unix/Linux, Ctrl+Z on Windows to end):\n");
    fflush(stdout);

    yyparse();

    return 0;
}
