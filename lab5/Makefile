lab_5: parser.y lexer.l
	yacc -d parser.y
	lex lexer.l
	gcc lex.yy.c y.tab.c -o lab_5

clean:
	rm -f lab5 y.tab.* lex.yy.*
