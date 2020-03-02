#!bin/bash

flex ../Zadanie1/Zad1.lex
gcc ../Zadanie1/lex.yy.c -o zad1
./zad1 < ../resources/l2z1a.txt > plikwynikowy1.txt
./zad1 < ../resources/l2z1b.txt > plikwynikowy2.txt