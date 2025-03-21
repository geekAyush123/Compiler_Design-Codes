q3: binary.y binary.l
	yacc -d binary.y
	lex binary.l
	gcc lex.yy.c y.tab.c -o q3 

clean:
	rm -f q3 y.tab.* lex.yy.*
