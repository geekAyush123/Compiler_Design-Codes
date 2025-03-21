q2: parser.y lexer.l
	yacc -d parser.y
	lex lexer.l
	gcc lex.yy.c y.tab.c -o q2

clean:
	rm -f q2 y.tab.* lex.yy.*
