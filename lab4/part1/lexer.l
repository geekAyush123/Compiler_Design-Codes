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

\n                    { line_count++; }
[A-Za-z]+             { word_count++; }
[A-Z]                 { capital_count++; }
[a-z]                 { small_count++; }
[0-9]                 { digit_count++; }  // This matches single digits (0-9)
[0-9]+                { num_count++; }     // This matches multi-digit numbers (e.g., 10, 21, etc.)
[\+\-\*/\%\^&@]         { special_count++; }  // Special characters
[\(\)\[\]\{\};,]      { delimiter_count++; } // Delimiters (e.g., parentheses, braces)
==|<=|>=|<|>          { relational_operator_count++; } // Relational operators
.                      { total_chars++; }  // Any unmatched character

%%

int main() {
    yylex();
    printf("Lines: %d\n", line_count);
    printf("Words: %d\n", word_count);
    printf("Capital Letters: %d\n", capital_count);
    printf("Small Letters: %d\n", small_count);
    printf("Numbers (10, 21): %d\n", num_count);
    printf("Digits (0-9): %d\n", digit_count);
    printf("Special Characters: %d\n", special_count);
    printf("Delimiters: %d\n", delimiter_count);
    printf("Relational Operators: %d\n", relational_operator_count);
    printf("Total Characters: %d\n", total_chars);
    return 0;
}
