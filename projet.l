%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "projet.tab.h"   
%}

%option noyywrap

%%

[ \t\r\n]+           ;

"EBDA"              { return START; }
"ZID"               { return ADD; }
"NA9ESS"            { return SUB; }
"ADROB"             { return MUL; }
"A9SSEM"            { return DIV; }
"KAMEL"             { return END; }
"EKTEB"             { return WRITE; }
"VWRITE"            { return VWRITE; }
"SCAN"              { return SCAN; }
"BILAMA"            { return WHILE; }

"RAT"               { return RAT; }
"SYSTEM"            { return SYSTEM; }
"AKHROJ"            { return LEAVE; }
"BDA_MN_JDID"       { return RESTART; }
"IDA"               { return IF; }
"/"                 { return SLASH; }
","                 { return COMMA; }
"%"                 { return PERCENT; }
"=="                { return EQ; }
"!="                { return NEQ; }
">="                { return GE; }
"<="                { return LE; }
">"                 { return GT; }
"<"                 { return LT; }

[a-zA-Z]            { yylval.sval = strdup(yytext); return ID; }

[\-]?[0-9]+         { yylval.ival = atoi(yytext); return VALUE; }
[a-zA-Z0-9 ]+       { yylval.sval = strdup(yytext); return TXT; }


.       {
         printf("Lexical Error: %s\n", yytext);
         return YYUNDEF;
   }

%%

