#!bin/bash

flex zad2.lex
gcc lex.yy.c -o zad2
./zad2 < xmltest.xml > usuniete.xml