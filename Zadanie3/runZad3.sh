#!bin/bash

lex zad3.l
gcc lex.yy.c -o zad3
./zad3 < cfiletest.c > result.c
