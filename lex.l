%{
#include <stdio.h>
#include "y.tab.h"

%}


INT         [0-9]+
SEMI        [;]
COMMA       [,]
DOT         [.]
BINARYOP1	\+|==|>=|<=
BINARYOP2	\*|\/|&|\|
ASSIGNOP    [\=]
TYPE        int
LP          [(]
RP          [)]
LB          [[]
RB          []]
LC          [{]
RC          [}]
STRUCT      struct
RETURN      return
IF          if
ELSE        else
BREAK       break
CONT        continue
FOR         for
ID          [a-zA-Z][a-zA-Z]*

int linecount = 1;

%%
{INT} {
yylval = yytext; return INT;
}

{SEMI} {
return SEMI;
}

{DOT} {
return DOT;
}

{COMMA} {
return COMMA;
}

{ASSIGNOP} {
return ASSIGNOP;
}


{LP} {
return LP;
}

{RP} {
return RP;
}

{LB} {
return LB;
}

{RC} {
return RC;
}

{LC} {
return LC;
}

{TYPE} {
return TYPE;
}

{STRUCT} {
return STRUCT;
}

{RETURN} {
return RETURN;
}

{IF} {
return IF;
}

{ELSE} {
return ELSE;
}

{BREAK} {
return BREAK;
//printf("BREAK\n");
}

{CONT} {
return CONT;
//printf("CONT\n");
}

{FOR} {
return FOR;
//printf("FOR\n");
}

{BINARYOP1} {
yylval = yytext;
return BINARYOP1;
}

{BINARYOP2} {
yylval = yytext;
return BINARYOP2;
}

[\-] {
return '-';
}

{ID} {
yylval = yytext;return ID;
}


[\n ] {

} /* ignore newlines */




%%


/*
* Now this is where you want your main program
*/
int yywrap(void){
    return 1;
}
