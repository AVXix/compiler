#!/bin/bash

yacc -d -y --debug --verbose 22101004.y
echo 'Generated the parser C file as well the header file'
g++ -w -c -o y.o y.tab.c
echo 'Generated the parser object file'
flex 22101004.l
echo 'Generated the scanner C file'
g++ -fpermissive -w -c -o l.o lex.yy.c
