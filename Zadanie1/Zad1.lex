%{
#include<stdio.h>
int yylex();
int yywrap();
int licznikSlow;
int licznikLinii;
%}

%%

^[ \t]*\n*
[ \t]+$
[ \t]+        { printf(" ");}
\n            { printf("\n"); licznikLinii++;}
[^ \t\n]*     { printf("%s", yytext); licznikSlow++;}

%%

int yywrap() {
    printf("\n---\nPlik zawiera %d słów oraz %d linii.\n", licznikSlow,licznikLinii);
    return 1;
}

int main() {
    return yylex();
}
