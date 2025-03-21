# Makefile for C declaration parser (MinGW/MSYS2 compatible)

CC = gcc
CFLAGS = -Wall

all: cdecl

cdecl: y.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o cdecl y.tab.c lex.yy.c

y.tab.c: cdecl.y
	yacc -d cdecl.y

lex.yy.c: cdecl.l
	lex cdecl.l

clean:
	rm -f cdecl y.tab.c y.tab.h lex.yy.c