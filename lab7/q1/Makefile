calc: calc.y calc.l
	yacc -d calc.y
	lex calc.l
	gcc lex.yy.c y.tab.c -o calc 

clean:
	rm -f calc y.tab.* lex.yy.*
