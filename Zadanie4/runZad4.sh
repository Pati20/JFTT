#!bin/bash

flex zad4.l
gcc lex.yy.c -o zad4 -lm
./zad4 < data.in