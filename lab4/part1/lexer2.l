%{
#include <stdio.h>
#include <ctype.h>
int line_count = 0;
int word_count = 0;
int capital_count = 0;
int small_count = 0;
int num_count = 0;
int digit_count = 0;
int special_count = 0;
int delimiter_count = 0;
int relational_operator_count = 0;
int total_chars = 0;
%}

%%

\n                     { line_count++; }
[A-Za-z]+             { 
                        word_count++; 
                        for(int i = 0; i < yyleng; i++) {
                            if(isupper(yytext[i])) capital_count++;
                            else if(islower(yytext[i])) small_count++;
                        }
                      }
[0-9]+                { num_count++; digit_count += yyleng; }
[\+\-\*/\%\^]         { special_count++; total_chars++; }
[\(\)\[\]\{\};,]      { delimiter_count++; total_chars++; }
==|!=|<=|>=|<|>       { relational_operator_count++; total_chars += yyleng; }
[ \t]                 { total_chars++; }
.                     { total_chars++; }

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s input_file\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Could not open file %s\n", argv[1]);
        return 1;
    }

    yyin = file;  // Set input file for flex
    yylex();      // Start lexical analysis
    
    printf("\nAnalysis of file: %s\n", argv[1]);
    printf("------------------------\n");
    printf("Lines: %d\n", line_count);
    printf("Words: %d\n", word_count);
    printf("Capital Letters: %d\n", capital_count);
    printf("Small Letters: %d\n", small_count);
    printf("Numbers: %d\n", num_count);
    printf("Digits: %d\n", digit_count);
    printf("Special Characters: %d\n", special_count);
    printf("Delimiters: %d\n", delimiter_count);
    printf("Relational Operators: %d\n", relational_operator_count);
    printf("Total Characters: %d\n", total_chars);

    fclose(file);
    return 0;
}

int yywrap() {
    return 1;
}