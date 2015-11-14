%option yylineno
%{
#include <stdlib.h>
#include "y.tab.h"
%}

/*Regular Definations*/
SPACE		[ \t\n]
DIGIT		[0-9]
INT     	{DIGIT}+
ID			({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*

SEMI		[;]
COMMA		[,]
DOT			[.]
UNDERSCORE	[_]
LP			[(]
RP			[)]
LB			[[]
RB			[]]
LC			[{]
RC			[}]
LETTER		[A-Za-z]
ASSIGNOP	[=]
UNARYOP		!|\+\+|--|~
BINARYOP	\*|\/|%
MINUS		[-]
PLUS		[\+]
SHIFTOP		<<|>>
COMPAREOP	>|>=|<|<=
EQUALOP		==|!=
BITAND		[&]
BITXOR      [\^]
BITOR       [\|]
LOGICALAND  &&
LOGICALOR	\|\|	
BINASSIGNOP	\+=|-=|\*=|\/=|&=|\^=|\|=|<<=|>>=
%%
 

{SPACE}			{

}

{UNARYOP} {
		yylval = yytext;return UNARYOP;
}

{BINARYOP} {
		yylval = yytext;return BINARYOP;
}

{MINUS}  {
		yylval = yytext;return MINUS;
}

{PLUS} {
		yylval = yytext;return PLUS;
}
{SHIFTOP}  {
		yylval = yytext;return SHIFTOP;
}
{COMPAREOP}  	{
		yylval = yytext;return COMPAREOP;
}
{EQUALOP}  		{
		yylval = yytext;return EQUALOP;
}
{BITAND}		{
		yylval = yytext;return BITAND;
}
{BITOR}			{
		yylval = yytext;return BITOR;
}
{BITXOR}		{
		yylval = yytext;return BITXOR;
}
{LOGICALAND}	{
		yylval = yytext;return LOGICALAND;
}
{LOGICALOR}		{
		yylval = yytext;return LOGICALOR;
}
{BINASSIGNOP}	{
		yylval = yytext;return BINASSIGNOP;
}
{ASSIGNOP}		{
		yylval = yytext;return ASSIGNOP;
}

{SEMI}			{return SEMI;}
{COMMA}			{return COMMA;}
{DOT}			{return DOT;}
if          	{return IF;}
then			{return THEN;}
else			{return ELSE;}
break			{return BREAK;}
return			{return RETURN;}
continue		{return CONT;}
for         	{return FOR;}
struct      	{return STRUCT;}
int 			{yylval = yytext;return TYPE;}
{LP}			{return LP;}
{RP}			{return RP;}
{LB}			{return LB;}
{RB}			{return RB;}
{LC}			{return LC;}
{RC}			{return RC;}

{INT}			{yylval = yytext;return INT;}
{ID}			{yylval = yytext;return ID;}

%%

int yywrap() 
{ 
   return 1; 
} 

