%{
  #include <stdio.h>
%}

%%
"\""([^"]|[\r\n])*"\"" {fprintf(yyout, "%s", yytext);}
"<![CDATA["([^]]|]][^>]|[\r\n])*"]]>" {fprintf(yyout, "%s", yytext);}
"<!--"([^-]|-[^-]|[\r\n])*"-->"  {printf("%s\n", yytext);}
%%

int yywrap() {
  return 1;
}

int main() {
  yyout = fopen("wynik.xml", "w");
  yylex();
  return 0;
}