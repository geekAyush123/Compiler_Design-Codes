%{
#include <stdio.h>
#include <string.h>

// Token type definitions
enum TokenType {
    KEYWORD, IDENTIFIER, OPERATOR, 
    LITERAL_INT, LITERAL_FLOAT, 
    SEPARATOR, PREPROCESSOR, 
    STORAGE_CLASS, COMMENT, 
    ESCAPE_SEQUENCE
};

// Function to print tokens
void printToken(enum TokenType type, char* text) {
    char* typeNames[] = {
        "KEYWORD", "IDENTIFIER", "OPERATOR", 
        "INT_LITERAL", "FLOAT_LITERAL", 
        "SEPARATOR", "PREPROCESSOR", 
        "STORAGE_CLASS", "COMMENT", 
        "ESCAPE_SEQUENCE"
    };
    printf("Token Type: %s, Value: %s\n", typeNames[type], text);
}
%}

/* Exclusive start conditions for multi-line comments and preprocessor directives */
%x COMMENT PREPROCESSOR

/* Define some useful regex patterns */
DIGIT           [0-9]
LETTER          [a-zA-Z]
IDENTIFIER      [a-zA-Z_][a-zA-Z0-9_]{0,31}  /* Limit identifier length to 32 chars */

/* Keywords */
KEYWORDS        (int|char|void|for|while|if|else|return|switch|case|break|continue|do|struct|union|enum|typedef|const|volatile|goto|sizeof|static|extern|inline|restrict|alignas|alignof|explicit|friend|mutable|namespace|template|try|catch|throw|noexcept|new|delete|this|decltype|typename|private|protected|public|virtual|override|final|consteval|constinit|typeid)

/* Storage Classes */
STORAGE_CLASS   (auto|register|static|extern|volatile)

/* Operators */
OPERATORS       ("+"|"-"|"*"|"/"|"="|"++"|"--"|"=="|"!="|"<="|">="|"&&"|"||")

/* Separators */
SEPARATORS      [,;(){}[\]]

%%

 /* Keywords */
{KEYWORDS}      { printToken(KEYWORD, yytext); }

 /* Storage Classes */
{STORAGE_CLASS} { printToken(STORAGE_CLASS, yytext); }

 

 /* Literals */
{DIGIT}+        { printToken(LITERAL_INT, yytext); }
{DIGIT}+"."{DIGIT}+ { printToken(LITERAL_FLOAT, yytext); }

 /* Operators */
{OPERATORS}     { printToken(OPERATOR, yytext); }

 /* Separators */
{SEPARATORS}    { printToken(SEPARATOR, yytext); }

 /* Single-line Comments */
"//".*          { printToken(COMMENT, yytext); }

 /* Multi-line Comments */
"/*"            { BEGIN(COMMENT); }
<COMMENT>"*/"   { BEGIN(INITIAL); }
<COMMENT>.      { /* Ignore multi-line comment content */ }

 /* Preprocessor Directives */
"#"             { BEGIN(PREPROCESSOR); }
<PREPROCESSOR>\n { BEGIN(INITIAL); }
<PREPROCESSOR>include { printToken(PREPROCESSOR, yytext); }
<PREPROCESSOR>define  { printToken(PREPROCESSOR, yytext); }
<PREPROCESSOR>ifdef   { printToken(PREPROCESSOR, yytext); }
<PREPROCESSOR>ifndef  { printToken(PREPROCESSOR, yytext); }

 /* Escape Sequences */
\\n             { printToken(ESCAPE_SEQUENCE, "newline"); }
\\t             { printToken(ESCAPE_SEQUENCE, "tab"); }
\\r             { printToken(ESCAPE_SEQUENCE, "carriage return"); }
\\\\            { printToken(ESCAPE_SEQUENCE, "backslash"); }

 /* Whitespace */
[ \t\n]+        ; /* Ignore whitespace */

 /* Catch any unrecognized tokens */
.               { printf("Unrecognized token: %s\n", yytext); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        if (!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return 1;
        }
    }
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}