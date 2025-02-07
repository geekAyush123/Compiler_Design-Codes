%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

// Declare yylval
union {
    double dval;
    char sval;
} yylval;

// Global variables
double result = 0;
#define MAX_STACK_SIZE 1000
double value_stack[MAX_STACK_SIZE];
char operator_stack[MAX_STACK_SIZE];
int value_stack_top = -1;
int operator_stack_top = -1;
int error_occurred = 0;

// Error handling
void handle_error(const char* message) {
    printf("Error: %s\n", message);
    error_occurred = 1;
}

// Stack operations
void push_value(double val) {
    if (value_stack_top >= MAX_STACK_SIZE - 1) {
        handle_error("Value stack overflow");
        return;
    }
    value_stack[++value_stack_top] = val;
}

void push_operator(char op) {
    if (operator_stack_top >= MAX_STACK_SIZE - 1) {
        handle_error("Operator stack overflow");
        return;
    }
    operator_stack[++operator_stack_top] = op;
}

double pop_value() {
    if (value_stack_top < 0) {
        handle_error("Value stack underflow");
        return 0;
    }
    return value_stack[value_stack_top--];
}

char pop_operator() {
    if (operator_stack_top < 0) {
        handle_error("Operator stack underflow");
        return '\0';
    }
    return operator_stack[operator_stack_top--];
}

// Function to apply operator
void apply_operator() {
    if (value_stack_top < 1) {
        handle_error("Not enough operands");
        return;
    }

    char op = pop_operator();
    double b = pop_value();
    double a = pop_value();
    double res = 0;

    switch (op) {
        case '+': res = a + b; break;
        case '-': res = a - b; break;
        case '*': res = a * b; break;
        case '/': 
            if (b == 0) {
                handle_error("Division by zero");
                return;
            }
            res = a / b; 
            break;
        case '^': 
            res = pow(a, b); 
            break;
        case '%':
            if (b == 0) {
                handle_error("Modulo by zero");
                return;
            }
            res = fmod(a, b);
            break;
        default:
            handle_error("Unknown operator");
            return;
    }
    push_value(res);
}

// Function for operator precedence
int precedence(char op) {
    switch (op) {
        case '+': case '-': return 1;
        case '*': case '/': case '%': return 2;
        case '^': return 3;
        default: return 0;
    }
}

// Function to evaluate expression
void evaluate_expression() {
    while (operator_stack_top >= 0 && !error_occurred) {
        if (operator_stack[operator_stack_top] == '(') {
            handle_error("Mismatched parentheses");
            return;
        }
        apply_operator();
    }
}

// Function to handle unary operations
void handle_unary(char op) {
    if (op == '-') {
        if (value_stack_top >= 0) {
            value_stack[value_stack_top] = -value_stack[value_stack_top];
        }
    }
}

%}

%option noyywrap

DIGIT           [0-9]
NUMBER          {DIGIT}+(\.{DIGIT}+)?([eE][\+\-]?{DIGIT}+)?
OPERATOR        [\+\-\*/\^%]
WHITESPACE      [ \t\r\n]
LEFT_PAREN      \(
RIGHT_PAREN     \)

%%

{NUMBER}        {
                    if (!error_occurred) {
                        yylval.dval = atof(yytext);
                        push_value(yylval.dval);
                        printf("Number: %.2f\n", yylval.dval);
                    }
                }

{OPERATOR}      {
                    if (!error_occurred) {
                        char op = yytext[0];
                        while (operator_stack_top >= 0 && 
                               operator_stack[operator_stack_top] != '(' &&
                               precedence(operator_stack[operator_stack_top]) >= precedence(op)) {
                            apply_operator();
                        }
                        push_operator(op);
                        printf("Operator: %c\n", op);
                    }
                }

{LEFT_PAREN}    {
                    if (!error_occurred) {
                        push_operator('(');
                        printf("Left Parenthesis\n");
                    }
                }

{RIGHT_PAREN}   {
                    if (!error_occurred) {
                        while (operator_stack_top >= 0 && operator_stack[operator_stack_top] != '(') {
                            apply_operator();
                        }
                        if (operator_stack_top < 0) {
                            handle_error("Mismatched parentheses");
                        } else {
                            operator_stack_top--;  // Pop '('
                            printf("Right Parenthesis\n");
                        }
                    }
                }

{WHITESPACE}    ;

.               { handle_error("Invalid character in expression"); }

%%

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <math_expression>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("Failed to open file");
        return 1;
    }

    yylex();
    fclose(yyin);

    if (!error_occurred) {
        evaluate_expression();
        if (!error_occurred && value_stack_top >= 0) {
            printf("Final Result: %.6f\n", value_stack[value_stack_top]);
        }
    }

    return error_occurred ? 1 : 0;
}