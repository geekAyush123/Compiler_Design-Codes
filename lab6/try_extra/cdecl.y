/* cdecl.y - Yacc parser for C declarations */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);
%}

%token IDENTIFIER CONSTANT STRING_LITERAL
%token INT CHAR FLOAT DOUBLE VOID LONG SHORT SIGNED UNSIGNED
%token STRUCT ENUM
%token CONST VOLATILE EXTERN STATIC REGISTER

/* Operator precedence */
%left ','
%right '='

%%

declaration
    : declaration_specifiers init_declarator_list ';'    
    { printf("Valid C declaration statement\n"); }
    ;

declaration_specifiers
    : storage_class_specifier
    | type_specifier
    | type_qualifier
    | storage_class_specifier type_specifier
    | type_qualifier type_specifier
    | storage_class_specifier type_qualifier type_specifier
    | type_qualifier storage_class_specifier type_specifier
    | storage_class_specifier storage_class_specifier 
    { yyerror("Error: Conflicting storage classes"); }
    ;

storage_class_specifier
    : EXTERN
    | STATIC
    | REGISTER
    ;

type_specifier
    : VOID
    | CHAR
    | SHORT
    | INT
    | LONG
    | FLOAT
    | DOUBLE
    | SIGNED
    | UNSIGNED
    | struct_or_union_specifier
    | enum_specifier
    ;

type_qualifier
    : CONST
    | VOLATILE
    ;

struct_or_union_specifier
    : STRUCT IDENTIFIER
    ;

enum_specifier
    : ENUM IDENTIFIER
    ;

init_declarator_list
    : init_declarator
    | init_declarator_list ',' init_declarator
    ;

init_declarator
    : declarator
    | declarator '=' initializer
    ;

declarator
    : pointer direct_declarator
    | direct_declarator
    ;

pointer
    : '*'
    | '*' pointer
    | '*' type_qualifier_list pointer
    | '*' type_qualifier_list
    ;

type_qualifier_list
    : type_qualifier
    | type_qualifier_list type_qualifier
    ;

direct_declarator
    : IDENTIFIER
    | '(' declarator ')'
    | direct_declarator '[' constant_expression ']'
    | direct_declarator '[' ']'
    ;

constant_expression
    : CONSTANT
    ;

initializer
    : assignment_expression
    | '{' initializer_list '}'
    | '{' initializer_list ',' '}'
    ;

initializer_list
    : initializer
    | initializer_list ',' initializer
    ;

assignment_expression
    : CONSTANT
    | STRING_LITERAL
    | IDENTIFIER
    ;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
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
    
    printf("Enter C declaration statements (Ctrl+D on Unix/Linux, Ctrl+Z on Windows to end):\n");
    yyparse();
    
    return 0;
}
