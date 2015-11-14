#!/bin/bash
rm y.tab.* lex.yy.c *.out 
flex lex.l
yacc syn.y -d
g++ lex.yy.c y.tab.c
./a.out
