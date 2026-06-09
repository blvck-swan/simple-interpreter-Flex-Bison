%{
#include <stdio.h>
#include <string.h>
#include "projet.tab.h"

int yylex();
void yyerror(const char* s);

int sum = 0;
int sub = 0;
int mul = 1;
int divv = 1;     
int i;
int ints[50];    
char* Stri;
%}

%union {
    int   ival;
    char* sval;
}

%token START END VALUE TXT COMMA SLASH ADD SUB MUL DIV WRITE SCAN RAT ID WHILE
%token SYSTEM LEAVE RESTART PERCENT VWRITE
%token IF               
%token EQ NEQ LT GT LE GE 
%token YYUNDEF
%type <ival> VALUE
%type <sval> TXT ID
%type <ival> Cond   

%start S

%%

S:
      START A
    ;

A:
      
    | ADD SLASH B SLASH          { printf("Result: %d\n", sum);  sum = 0; } A
    | SUB SLASH C SLASH          { printf("Result: %d\n", sub);  sub = 0; } A
    | MUL SLASH D SLASH          { printf("Result: %d\n", mul);  mul = 1; } A
    | DIV SLASH E SLASH          { printf("Result: %d\n", divv); divv = 1; } A
    | WRITE SLASH F SLASH        { printf("%s\n", Stri); Stri = NULL; } A
    | RAT SLASH G SLASH          { printf("DONE\n"); } A
    | SCAN SLASH H               { printf("DONE\n"); } A
    | SYSTEM SLASH RESTART SLASH S
    | SYSTEM SLASH LEAVE SLASH   { YYACCEPT; }
    | IF SLASH Cond SLASH A
    | WHILE SLASH Cond SLASH A

    ;
B:
      VALUE               { sum += $1; }
    | ID                  { int idx = $1[0] - 'A'; sum += ints[idx]; }
    | VALUE COMMA         { sum += $1; } B
    | ID COMMA            { int idx = $1[0] - 'A'; sum += ints[idx]; } B
    ;

C:
      VALUE               { sub = $1; } COMMA C2
    | ID                  { int idx = $1[0] - 'A'; sub = ints[idx]; } COMMA C2
    ;

C2:
      VALUE               { sub -= $1; }
    | ID                  { int idx = $1[0] - 'A'; sub -= ints[idx]; }
    ;

D:
      VALUE               { mul = $1; } COMMA D2
    | ID                  { int idx = $1[0] - 'A'; mul = ints[idx]; } COMMA D2
    ;

D2:
      VALUE               { mul *= $1; }
    | ID                  { int idx = $1[0] - 'A'; mul *= ints[idx]; }
    ;

E:
      VALUE               { divv = $1; } COMMA E2
    | ID                  { int idx = $1[0] - 'A'; divv = ints[idx]; } COMMA E2
    ;

E2:
      VALUE               { divv /= $1; }
    | ID                  { int idx = $1[0] - 'A'; divv /= ints[idx]; }
    ;

F:
      TXT                 { Stri = $1; }
    ;

G:
      ID SLASH VALUE      { int idx = $1[0] - 'A'; ints[idx] = $3; }
    ;

H:
      ID SLASH            { i = $1[0] - 'A'; printf("insert %s: ", $1); } H2
    ;

H2:
      VALUE               { ints[i] = $1; }
    ;

Cond:
      ID GT VALUE         { int idx = $1[0] - 'A'; $$ = (ints[idx] >  $3); }
    | ID LT VALUE         { int idx = $1[0] - 'A'; $$ = (ints[idx] <  $3); }
    | ID EQ VALUE         { int idx = $1[0] - 'A'; $$ = (ints[idx] == $3); }
    | ID NEQ VALUE        { int idx = $1[0] - 'A'; $$ = (ints[idx] != $3); }
    | ID GE VALUE         { int idx = $1[0] - 'A'; $$ = (ints[idx] >= $3); }
    | ID LE VALUE         { int idx = $1[0] - 'A'; $$ = (ints[idx] <= $3); }
    ;

%%

void yyerror(const char* s) {
    printf("Syntax Error\n");
}

int main() {
    printf("Enter your program:\n");
    yyparse();
    printf("Syntax analysis complete\n");
    return 0;
}
