#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
const char *keywords[]={"for","while","if", "else", "return","int","float","char","void"};
const int keyword_count=sizeof(keywords)/sizeof(keywords[0]);
int isKeyword(const char* token){
    for(int i=0;i<keyword_count;i++){
        if(strcmp(token, keywords[i])==0){
            return 1;
        }
    }
    return 0;
}
int isIdentifier(const char* token){
    if(isalpha(token[0])||token[0]=='_'){
        for(int i=1;token[i]!='\0';i++){
            if(!isalnum(token[i]) && token[i]!='_'){
                return 0;
            }
        }
    return 1;
    }
    return 0;
}
int isOperator(char ch){
    const char operators[]= "+-*/%<>=!&|^";
    return strchr(operators,ch)!=NULL;
}
int isSeparator(char ch){
    const char separators[]=",;(){}[]";
    return strchr(separators, ch) != NULL;
}
void tokenize(const char *line) {
    char token[100];
    int i = 0, j = 0;

    while (line[i] != '\0') {
        if (isspace(line[i])) {
            i++;
            continue;
        }

        if (isOperator(line[i])) {
            printf("Operator: %c\n", line[i]);
            i++;
            continue;
        }

        if (isSeparator(line[i])) {
            printf("Separator: %c\n", line[i]);
            i++;
            continue;
        }

        if (isalnum(line[i]) || line[i] == '_') {
            j = 0;
            while (isalnum(line[i]) || line[i] == '_') {
                token[j++] = line[i++];
            }
            token[j] = '\0';

            if (isKeyword(token)) {
                printf("Keyword: %s\n", token);
            } else if (isIdentifier(token)) {
                printf("Identifier: %s\n", token);
            } else {
                printf("Unknown token: %s\n", token);
            }
            continue;
        }

        printf("Unknown character: %c\n", line[i]);
        i++;
    }
}
int main() {
    char line[256];
    printf("Enter a line of code: \n");
    fgets(line, sizeof(line), stdin);

    printf("\nTokens identified:\n");
    tokenize(line);

    return 0;
}
