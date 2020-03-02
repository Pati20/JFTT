%option noyywrap
%{
#include <stdio.h>
#include <stdbool.h>
bool kom_dokumentacyjne=false;
%}

ukosnik 	        [/]
ukosnikwsteczny 	[\\]
gwiazdka 	        [*]
wykrzyknik          [!]

%x string
%x include
%x kom_one
%x kom_multi
%x kom_one1
%x kom_one2
%x kom_multi1
%x kom_multi2

%%
\"					           	{ECHO; BEGIN(string);}
<string>{ukosnikwsteczny}\n      ECHO;
<string>{ukosnikwsteczny}\"		  ECHO;
<string>\"              {ECHO; BEGIN(INITIAL);}
<string>.			      	  ECHO;



"#include <"              {ECHO; BEGIN(include);}
<include>.              ECHO;
<include>\n|\>             {ECHO; BEGIN(INITIAL);}


{ukosnik}{ukosnik}				  BEGIN(kom_one);
<kom_one>.*{ukosnikwsteczny}\n		;
<kom_one>.				    	;
<kom_one>[^{ukosnikwsteczny}]\n	BEGIN(INITIAL);


{ukosnik}{3}					   	{if(kom_dokumentacyjne) ECHO; BEGIN(kom_one1);}
<kom_one1>.*{ukosnikwsteczny}\n	    {if(kom_dokumentacyjne) ECHO;}
<kom_one1>.					        {if(kom_dokumentacyjne) ECHO;}
<kom_one1>[^{ukosnikwsteczny}]\n    {if(kom_dokumentacyjne) ECHO; BEGIN(INITIAL);}


{ukosnik}{ukosnik}{wykrzyknik}	    {if(kom_dokumentacyjne) ECHO; BEGIN(kom_one2);}
<kom_one2>.*{ukosnikwsteczny}\n	    {if(kom_dokumentacyjne) ECHO;}
<kom_one2>.					        {if(kom_dokumentacyjne) ECHO;}
<kom_one2>[^{ukosnikwsteczny]\n	    {if(kom_dokumentacyjne) ECHO; BEGIN(INITIAL);}


{ukosnik}{gwiazdka}				    BEGIN(kom_multi);
<kom_multi>(.|\n)	      		    ;
<kom_multi>{gwiazdka}{ukosnik}    	BEGIN(INITIAL);


{ukosnik}{gwiazdka}{2}			    {if(kom_dokumentacyjne) ECHO; BEGIN(kom_multi1);}
<kom_multi1>(.|\n)		  	        {if(kom_dokumentacyjne) ECHO;}
<kom_multi1>{gwiazdka}{ukosnik}	    {if(kom_dokumentacyjne) ECHO; BEGIN(INITIAL);}

{ukosnik}{gwiazdka}{wykrzyknik}		{if(kom_dokumentacyjne) ECHO; BEGIN(kom_multi2);}
<kom_multi2>(.|\n)		  	        {if(kom_dokumentacyjne) ECHO;}
<kom_multi2>{gwiazdka}{ukosnik}	    {if(kom_dokumentacyjne) ECHO; BEGIN(INITIAL);}

%%
int main(int k,char **argcv)
{
yylex();
return 0;
}