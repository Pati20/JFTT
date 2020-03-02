%{
#include <stdio.h>
#include <math.h>
#include <stdbool.h>

#define ROZMIAR_STOSU 2000

int yylex();
int yywrap();

int wsk = -1;
int stos[ROZMIAR_STOSU];
int blad = false;
int X, Y;

void push(int liczba) {
    wsk++;
    if (wsk < ROZMIAR_STOSU) {
        stos[wsk] = liczba;
    } else {
        fprintf(stderr, "BŁĄD: przepełnienie stosu.\n");
        blad = true;
    } 
}

int pop()  {
    if (wsk >= 0) {
        wsk--;
        return stos[wsk + 1];
    } else {
        blad = true;
        return 0;
    }
}
%}

%x ERROR

%%
-?[0-9]+                    push(atoi(yytext));

\+                          {
                                X = pop();
                                Y = pop();
                                push(X + Y);
                            }

\-                          {
                                X = pop();
                                Y = pop();
                                push(Y - X);
                            }

\*                          {
                                X = pop();
                                Y = pop();
                                push(X * Y);
                            }

\/                          {
                                X = pop();
                                if (X == 0) {
                                    fprintf(stderr, "BŁĄD: dzielenie przez 0 jest zabronione!\n");
                                    BEGIN(ERROR);
                                } else {
                                    Y = pop();
                                    push(Y / X);
                                }
                            }     

\%                          {
                                X = pop();
                                if (X == 0) {
                                    fprintf(stderr, "BŁĄD: dzielenie przez 0 jest zabronione!\n");
                                    BEGIN(ERROR);
                                } else {
                                    Y = pop();
                                    push(Y % X);
                                }
                            }  
\^                          {
                                X = pop();
                                Y = pop();
                                push( (int) pow((double) Y, (double) X));
                            }

[ \t]                       ;

[\n]                        {
                                if(wsk != 0) {
                                    fprintf(stderr, "BŁĄD: za mala liczba operatorow\n");
                                    wsk = -1;
                                    blad = false;
                                    BEGIN(INITIAL);
                                } else {
                                    int wynik_dzialania = pop();
                                    if(!blad) {
                                        printf("= %d\n", wynik_dzialania);
                                    } else {
                                        fprintf(stderr, "BŁĄÐ: za mała liczba argumentów\n");
                                    }
                                    blad = false;
                                    wsk = -1;
                                    BEGIN(INITIAL);   
                                }
                            }  

.                           {
                                fprintf(stderr, "BŁĄD: niepoprawny symbol: \"%s\"\n", yytext);
                                wsk = -1;
                                BEGIN(ERROR);
                            }
<ERROR>{
    .                       ;
    \n                      {wsk = -1; BEGIN(INITIAL);}
}

%%

int yywrap() {
    return 1;
}

int main() {
    return yylex();
}