#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
const char *keywords[] = {
    "break", "case", "char", "const", "continue", "default", "do",
    "double", "else", "enum", "extern", "float", "for", "goto", "if",
    "int", "long","return", "short", "signed", "sizeof", "static",
    "struct", "switch", "typedef", "union", "unsigned", "void", "while"
};
const int keyword_count = sizeof(keywords) / sizeof(keywords[0]);

typedef enum {
    TOKEN_KEYWORD,
    TOKEN_IDENTIFIER,
    TOKEN_NUMBER,
    TOKEN_STRING,
    TOKEN_OPERATOR,
    TOKEN_SEPARATOR,
    TOKEN_COMMENT,
    TOKEN_PREPROCESSOR,
    TOKEN_UNKNOWN
} TokenType;

typedef struct {
    TokenType type;
    char value[256];
    int line;
    int column;
} Token;

int isKeyword(const char* token) {
    for (int i = 0; i < keyword_count; i++) {
        if (strcmp(token, keywords[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

int isIdentifier(const char* token) {
    if (isalpha(token[0]) || token[0] == '_') {
        for (int i = 1; token[i] != '\0'; i++) {
            if (!isalnum(token[i]) && token[i] != '_') {
                return 0;
            }
        }
        return 1;
    }
    return 0;
}

int isNumber(const char* token) {
    int dots = 0;
    for (int i = 0; token[i] != '\0'; i++) {
        if (token[i] == '.') {
            dots++;
            if (dots > 1) return 0;
        } else if (!isdigit(token[i])) {
            return 0;
        }
    }
    return 1;
}

int isOperator(const char* str) {
    const char* operators[] = {
        "+", "-", "*", "/", "%", "=",
        "==", "!=", "<", ">", "<=", ">=",
        "&&", "||", "!", "&", "|", "^",
        "++", "--", "+=", "-=", "*=", "/=",
        "%=", "&=", "|=", "^=", "<<", ">>",
        NULL
    };

    for (int i = 0; operators[i] != NULL; i++) {
        if (strcmp(str, operators[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

int isSeparator(char ch) {
    return strchr(",;(){}[]", ch) != NULL;
}

void processToken(Token* token) {
    printf("Line %d, Column %d: ", token->line, token->column);
    
    switch (token->type) {
        case TOKEN_KEYWORD:
            printf("Keyword: %s\n", token->value);
            break;
        case TOKEN_IDENTIFIER:
            printf("Identifier: %s\n", token->value);
            break;
        case TOKEN_NUMBER:
            printf("Number: %s\n", token->value);
            break;
        case TOKEN_STRING:
            printf("String: %s\n", token->value);
            break;
        case TOKEN_OPERATOR:
            printf("Operator: %s\n", token->value);
            break;
        case TOKEN_SEPARATOR:
            printf("Separator: %s\n", token->value);
            break;
        case TOKEN_COMMENT:
            printf("Comment: %s\n", token->value);
            break;
        case TOKEN_PREPROCESSOR:
            printf("Preprocessor: %s\n", token->value);
            break;
        case TOKEN_UNKNOWN:
            printf("Unknown token: %s\n", token->value);
            break;
    }
}

void tokenize(const char* input) {
    Token token;
    char buffer[256];
    int line = 1;
    int column = 1;
    int i = 0;
    
    while (input[i] != '\0') {
        if (isspace(input[i])) {
            if (input[i] == '\n') {
                line++;
                column = 1;
            } else {
                column++;
            }
            i++;
            continue;
        }

        if (input[i] == '/' && input[i + 1] == '/') {
            int j = 0;
            token.type = TOKEN_COMMENT;
            token.line = line;
            token.column = column;
            
            while (input[i] != '\n' && input[i] != '\0') {
                token.value[j++] = input[i++];
            }
            token.value[j] = '\0';
            processToken(&token);
            continue;
        }

        if (input[i] == '#') {
            int j = 0;
            token.type = TOKEN_PREPROCESSOR;
            token.line = line;
            token.column = column;
            
            while (input[i] != '\n' && input[i] != '\0') {
                token.value[j++] = input[i++];
            }
            token.value[j] = '\0';
            processToken(&token);
            continue;
        }

        if (input[i] == '"') {
            int j = 0;
            token.type = TOKEN_STRING;
            token.line = line;
            token.column = column;
            token.value[j++] = input[i++];
            
            while (input[i] != '"' && input[i] != '\0') {
                if (input[i] == '\\') {
                    token.value[j++] = input[i++];
                }
                token.value[j++] = input[i++];
            }
            if (input[i] == '"') {
                token.value[j++] = input[i++];
            }
            token.value[j] = '\0';
            processToken(&token);
            continue;
        }

        if (strchr("+-*/%=!<>&|^", input[i])) {
            char op[3] = {input[i], input[i + 1], '\0'};
            if (isOperator(op)) {
                token.type = TOKEN_OPERATOR;
                token.line = line;
                token.column = column;
                strcpy(token.value, op);
                processToken(&token);
                i += 2;
                column += 2;
            } else {
                op[1] = '\0';
                if (isOperator(op)) {
                    token.type = TOKEN_OPERATOR;
                    token.line = line;
                    token.column = column;
                    strcpy(token.value, op);
                    processToken(&token);
                    i++;
                    column++;
                }
            }
            continue;
        }

        if (isSeparator(input[i])) {
            token.type = TOKEN_SEPARATOR;
            token.line = line;
            token.column = column;
            token.value[0] = input[i];
            token.value[1] = '\0';
            processToken(&token);
            i++;
            column++;
            continue;
        }

        if (isalnum(input[i]) || input[i] == '_') {
            int j = 0;
            while (isalnum(input[i]) || input[i] == '_') {
                buffer[j++] = input[i++];
                column++;
            }
            buffer[j] = '\0';

            token.line = line;
            token.column = column - strlen(buffer);
            strcpy(token.value, buffer);

            if (isKeyword(buffer)) {
                token.type = TOKEN_KEYWORD;
            } else if (isNumber(buffer)) {
                token.type = TOKEN_NUMBER;
            } else if (isIdentifier(buffer)) {
                token.type = TOKEN_IDENTIFIER;
            } else {
                token.type = TOKEN_UNKNOWN;
            }
            processToken(&token);
            continue;
        }

        token.type = TOKEN_UNKNOWN;
        token.line = line;
        token.column = column;
        token.value[0] = input[i];
        token.value[1] = '\0';
        processToken(&token);
        i++;
        column++;
    }
}

char* readFile(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        printf("Error: Could not open file %s\n", filename);
        return NULL;
    }

    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);

    char* content = (char*)malloc(size + 1);
    if (content == NULL) {
        printf("Error: Memory allocation failed\n");
        fclose(file);
        return NULL;
    }

    size_t read_size = fread(content, 1, size, file);
    content[read_size] = '\0';

    fclose(file);
    return content;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <source_file>\n", argv[0]);
        return 1;
    }

    char* source_code = readFile(argv[1]);
    if (source_code == NULL) {
        return 1;
    }

    printf("Tokens identified:\n");
    
    tokenize(source_code);

    free(source_code);
    return 0;
}