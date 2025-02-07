%{
#include <stdio.h>
#include <string.h>

// Token definitions
enum TokenType {
    KEYWORD, 
    IDENTIFIER, 
    OPERATOR, 
    LITERAL_INT, 
    LITERAL_FLOAT, 
    SEPARATOR, 
    PREPROCESSOR, 
    STORAGE_CLASS, 
    COMMENT,
    ESCAPE_SEQUENCE,
    UNKNOWN // Added for unknown characters
};

// Function to print token details
void printToken(enum TokenType type, char* text) {
    char* typeNames[] = {
        "KEYWORD", "IDENTIFIER", "OPERATOR", "INTEGER LITERAL", 
        "FLOAT LITERAL", "SEPARATOR", "PREPROCESSOR", 
        "STORAGE CLASS", "COMMENT", "ESCAPE SEQUENCE", "UNKNOWN","APOSTROPHE"
    };
    printf("Token Type: %s, Value: %s\n", typeNames[type], text);
}
%}

/* Options to track line numbers */
%option yylineno

/* Definitions for common patterns */
DIGIT           [0-9]
LETTER          [a-zA-Z_]
IDENTIFIER      {LETTER}({LETTER}|{DIGIT}){0,31}
WHITESPACE      [ \t\r\n]

/* Keywords */
KEYWORD         (int|char|void|for|while|if|else|return|switch|case|break|continue|do|struct|union|enum|typedef|const|volatile|goto|sizeof|static|extern|inline|restrict|alignas|alignof|explicit|friend|mutable|namespace|template|try|catch|throw|noexcept|new|delete|this|decltype|typename|private|protected|public|virtual|override|final|consteval|constinit|typeid)

/* Operators */
OPERATOR        ("+"|"-"|"*"|"/"|"="|"=="|"!="|"<"|">"|"<="|">="|"&&"|"||"|"!"|"++"|"--")

/* Storage Classes */
STORAGE_CLASS   (auto|register|static|extern|volatile)

/* Preprocessor Directives */
PREPROCESSOR    ^#(include|define|ifdef|ifndef|endif|undef)

/* Rules */
%%

{KEYWORD}       { printToken(KEYWORD, yytext); }

{PREPROCESSOR}  { printToken(PREPROCESSOR, yytext); }

{STORAGE_CLASS} { printToken(STORAGE_CLASS, yytext); }

{IDENTIFIER}    { printToken(IDENTIFIER, yytext); }

{OPERATOR}      { printToken(OPERATOR, yytext); }

{WHITESPACE}    ; /* Ignore whitespace */

[;,(){}[\]]     { printToken(SEPARATOR, yytext); }

\/\/.*          { printToken(COMMENT, yytext); } /* Single-line comments */

\/\*(.|\n)*?\*\/ { printToken(COMMENT, yytext); } /* Multi-line comments */

\\[ntr\\]       { printToken(ESCAPE_SEQUENCE, yytext); }

{DIGIT}+        { printToken(LITERAL_INT, yytext); }

{DIGIT}+\.{DIGIT}+ { printToken(LITERAL_FLOAT, yytext); }

;           { printToken(UNKNOWN, yytext); } 

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        if (!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return 1;
        }
    }
    
    yylex(); // Start lexical analysis
    return 0;
}

int yywrap() {
    return 1;
}
