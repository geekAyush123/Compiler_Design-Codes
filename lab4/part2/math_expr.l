%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Declare yylval
union {
    double dval;
    char sval;
} yylval;

// To store the result of calculations
double result = 0;

// Declare stacks for operators and values
#define MAX_STACK_SIZE 100
double value_stack[MAX_STACK_SIZE];
char operator_stack[MAX_STACK_SIZE];
int value_stack_top = -1;
int operator_stack_top = -1;

// Helper function to apply operator to two operands
void apply_operator() {
    char op = operator_stack[operator_stack_top--];
    double b = value_stack[value_stack_top--];
    double a = value_stack[value_stack_top--];
    double res = 0;

    switch (op) {
        case '+': res = a + b; break;
        case '-': res = a - b; break;
        case '*': res = a * b; break;
        case '/': 
            if (b == 0) {
                printf("Error: Division by zero\n");
                exit(1);
            }
            res = a / b; break;
    }
    value_stack[++value_stack_top] = res;
}

// Function to handle operator precedence
int precedence(char op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
}

// Function to handle the input and parsing
void evaluate_expression() {
    while (operator_stack_top >= 0) {
        apply_operator();
    }
}

%}

%option noyywrap

DIGIT           [0-9]
NUMBER          {DIGIT}+(\.{DIGIT}+)? 
OPERATOR        [\+\-\*/]
WHITESPACE      [ \t\r\n]
LEFT_PAREN      \(
RIGHT_PAREN     \)

%%

{NUMBER}        {
                    yylval.dval = atof(yytext);
                    value_stack[++value_stack_top] = yylval.dval;
                    printf("Number: %.2f\n", yylval.dval);
                }

{OPERATOR}      {
                    char op = yytext[0];
                    while (operator_stack_top >= 0 && 
                           precedence(operator_stack[operator_stack_top]) >= precedence(op)) {
                        apply_operator();
                    }
                    operator_stack[++operator_stack_top] = op;
                    printf("Operator: %c\n", op);
                }

{LEFT_PAREN}    {
                    operator_stack[++operator_stack_top] = '(';
                    printf("Left Parenthesis: ( \n");
                }

{RIGHT_PAREN}   {
                    while (operator_stack[operator_stack_top] != '(') {
                        apply_operator();
                    }
                    operator_stack_top--;  // Pop '('
                    printf("Right Parenthesis: )\n");
                }

{WHITESPACE}    ;

%%

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <math_expression>\n", argv[0]);
        return 1;
    }

    // Input the mathematical expression
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("Failed to open file");
        return 1;
    }

    yylex(); // Start lexical analysis
    fclose(yyin);

    // Evaluate the remaining operators
    evaluate_expression();

    // Display final result
    printf("Final Result: %.2f\n", value_stack[value_stack_top]);
    return 0;
}
