# Makefile for C expression parser with debug options

CC = gcc
CFLAGS = -Wall -g

all: cexpr

cexpr: y.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o cexpr y.tab.c lex.yy.c

debug: CFLAGS += -DDEBUG -DYYDEBUG=1
debug: cexpr

y.tab.c: cexpr.y
	yacc -d -v cexpr.y

lex.yy.c: cexpr.l
	lex cexpr.l

clean:
	rm -f cexpr y.tab.c y.tab.h lex.yy.c y.output

test: cexpr
	@echo "Testing valid expressions:"
	@echo "a + b * c" | ./cexpr
	@echo "x > y && z < 10" | ./cexpr
	@echo "(a || b) && !c" | ./cexpr
	@echo "\nTesting invalid expressions:"
	@echo "a ++ b" | ./cexpr
	@echo "a + * b" | ./cexpr
	@echo "a && || b" | ./cexpr

.PHONY: clean test
