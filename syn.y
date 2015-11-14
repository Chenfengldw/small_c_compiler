%code requires
{
#define YYSTYPE char*

}

%{
#include <stdio.h>
#include <stack>
#include "Tree.h"
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;
extern char *yytext;
/*Solve warning: implicit declaration*/
int yyerror (const char *msg);
int yylex();
stack<treeNode *> stk;
bool printFlag = true;
%}


%token INT    /*bind the yylval type*/
%token ID
%token UNARYOP
%token BINARYOP
%token PLUS
%token MINUS
%token SHIFTOP
%token COMPAREOP
%token EQUALOP
%token BITAND
%token BITXOR
%token BITOR
%token LOGICALAND
%token LOGICALOR
%token BINASSIGNOP
%token TYPE
%token SEMI COMMA DOT ASSIGNOP LP RP LB RB LC RC STRUCT RETURN IF THEN ELSE BREAK CONT FOR

%right	NOELSE ELSE
%right 		ASSIGNOP BINASSIGNOP
%left       LOGICALOR
%left		LOGICALAND
%left       BITOR
%left		BITXOR
%left       BITAND
%left		EQUALOP
%left		COMPAREOP 
%left		SHIFTOP 
%left		PLUS MINUS
%left    	BINARYOP 
%right		UNARYOP UNMINUS
%left		DOT LP RP LB RB

%start PROGRAM

%%
PROGRAM:
		EXTDEFS				{
								cout<<"deal with PROGRAM -> extdefs\n";
								addNode("PROGRAM");
								arr[counter-1].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-1]);
							}
	;

EXTDEFS:
		EXTDEF EXTDEFS		{
								cout<<"deal with extdefs -> extdef extdefs\n";
								addNode("EXTDEFS");
								arr[counter-1].son[1] = stk.top();stk.pop();
								arr[counter-1].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-1]);
							}

	|	/*EMPTY*/			{
								cout<<"deal with extdefs -> empty\n";
								addNode("EXTDEFS");addNode("empty");arr[counter-2].son[0] =&arr[counter-1];
								stk.push(&arr[counter-2]);
							}
								
	;

EXTDEF:
		SPEC EXTVARS SEMI   {
								cout<<"deal with extdef -> spec extvars semi\n";
								addNode("EXTDEF");addNode("SEMI");
								arr[counter-2].son[1] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								arr[counter-2].son[2] = &arr[counter-1];
								stk.push(&arr[counter-2]); 

							}

	|	SPEC FUNC STMTBLOCK	{
								cout<<"-1";cout<<"deal with extdef -> spec func stmtblock\n";cout<<"-1";
								addNode("EXTDEF");cout<<"0";
								arr[counter-1].son[2] = stk.top();stk.pop();
								arr[counter-1].son[1] = stk.top();stk.pop();cout<<"2";
								arr[counter-1].son[0] = stk.top();stk.pop();cout<<"3";
								stk.push(&arr[counter-1]);cout<<"4";
							}
	;

EXTVARS:
		DEC             	{
								cout<<"deal with extvars -> dec\n";
								addNode("EXTVARS");
								arr[counter-1].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-1]);
							}

	|	DEC COMMA EXTVARS   {
								cout<<"deal with extvars -> dec comma extvars\n";
								addNode("EXTVARS");addNode("COMMA");
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2]=stk.top();stk.pop();
								arr[counter-2].son[0]=stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}

	|	/*EMPTY*/			{
								addNode("EXTVARS");addNode("empty");arr[counter-2].son[0] =&arr[counter-1];
								stk.push(&arr[counter-2]);
							}
	;

SPEC:
		TYPE            	{
								cout<<"deal with spec -> type\n";
								addNode("SPEC");addNode("TYPE");
								arr[counter-2].son[0] = &arr[counter-1];
								stk.push(&arr[counter-2]);
							}

	|	STSPEC				{
								cout<<"deal with spec -> stspec\n";
								addNode("SPEC");arr[counter-1].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-1]);
							}
	;

STSPEC:
		STRUCT OPTTAG LC DEFS RC	{
										cout<<"deal with stspec -> struct opttag lc defs rc\n";
										addNode("STSPEC");addNode("STRUCT");addNode("LC");addNode("RC");
										arr[counter-4].son[0] = &arr[counter-3];
										arr[counter-4].son[3] = stk.top();stk.pop();
										arr[counter-4].son[1] = stk.top();stk.pop();
										arr[counter-4].son[2] = &arr[counter-2];
										arr[counter-4].son[4] = &arr[counter-1];
										stk.push(&arr[counter-4]);
									}

	|	STRUCT ID           		{
										cout<<"deal with stspec -> struct id\n";					
										addNode("STSPEC");addNode("STRUCT");char *tmp = ("ID(%s)",$2);addNode(tmp);
										arr[counter-3].son[0] = &arr[counter-2];arr[counter-3].son[1] = &arr[counter-1];
										stk.push(&arr[counter-3]);								
									}

OPTTAG:
	ID                  			{
										cout<<"deal with opttag -> id\n";
										addNode("OPTTAG");char *tmp = ("ID(%s)",$1);addNode(tmp);
										arr[counter-2].son[0] = &arr[counter-1];
										stk.push(&arr[counter-2]);
									}

	|	/*EMPTY*/					{
										cout<<"deal with opttag -> empty\n";
										addNode("OPTTAG");addNode("empty");
										arr[counter-2].son[0] =&arr[counter-1];
										stk.push(&arr[counter-2]);
									}	
	;

VAR:
		ID               			{
										cout<<"deal with var -> id \n";
										addNode("VAR");char *tmp = ("ID(%s)",$1);addNode(tmp);//addNode(($1));
										arr[counter-2].son[0] = &arr[counter-1];
										stk.push(&arr[counter-2]);
									}

	|	VAR LB INT RB				{
										cout<<"deal with var -> var lb int rb\n";
										addNode("VAR");addNode("LB");char *tmp = ("INT(%s)",$3);addNode(tmp);addNode("RB");
										arr[counter-4].son[0] = stk.top();stk.pop();
										arr[counter-4].son[1] = &arr[counter-3];
										arr[counter-4].son[2] = &arr[counter-2];
										arr[counter-4].son[3] = &arr[counter-1];
										stk.push(&arr[counter-4]);
									}
	;

FUNC://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		ID LP PARAS RP				{
										cout<<"deal with func -> id lp paras rp\n";
										addNode("FUNC");char *tmp = ("ID(%s)",$1);addNode(tmp);addNode("LP");addNode("RP");
										arr[counter-4].son[0] = &arr[counter-3];
										arr[counter-4].son[1] = &arr[counter-2];
										arr[counter-4].son[3] = &arr[counter-1];
										arr[counter-4].son[2] = stk.top();stk.pop();
										stk.push(&arr[counter-4]);
									}
	;

PARAS://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		PARA COMMA PARAS            {
										cout<<"deal with paras -> para comma paras\n";
										addNode("PARAS");addNode("COMMA");
										arr[counter-2].son[2] = stk.top();stk.pop();
										arr[counter-2].son[1] = &arr[counter-1];arr[counter-2].son[0] = stk.top();stk.pop();
										stk.push(&arr[counter-2]);
									}

	|	PARA                        {
										cout<<"deal with paras -> para\n";
										addNode("PARAS");
										arr[counter-1].son[0] = stk.top();stk.pop();
										stk.push(&arr[counter-1]);
									}
	|	/*EMPTY*/				    {
										cout<<"deal with paras -> empty\n";
										addNode("PARAS");addNode("empty");
										arr[counter-2].son[0] =&arr[counter-1];
										stk.push(&arr[counter-2]);							
									}
	;

PARA://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk						
		SPEC VAR                    {
										cout<<"deal with para -> spec var\n";
										addNode("PARA");
										arr[counter-1].son[1] = stk.top();stk.pop();
										arr[counter-1].son[0] = stk.top();stk.pop();
										stk.push(&arr[counter-1]);
									}
	;

STMTBLOCK:	//okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk						
		LC DEFS STMTS RC            {
										cout<<"deal with stmtblock -> lc defs stmts rc\n";
										addNode("STMTBLOCK");cout<<"1";
										addNode("LC");cout<<"2";
										addNode("RC");cout<<"3";
										cout<<'*'<<counter<<'*';
										arr[counter-3].son[0] = &arr[counter-2];cout<<"4";
										arr[counter-3].son[3] = &arr[counter-1];cout<<"5";
										arr[counter-3].son[2] = stk.top();stk.pop();cout<<"6";
										arr[counter-3].son[1] = stk.top();stk.pop();cout<<"7";
										stk.push(&arr[counter-3]);cout<<"8";
									}
	;

STMTS://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		STMT STMTS                  {
										cout<<"deal with stmts -> stmt stmts\n";
										cout<<"1";
										addNode("STMTS");cout<<"2";
										arr[counter-1].son[1] = stk.top();stk.pop();cout<<"3";
										arr[counter-1].son[0] = stk.top();stk.pop();cout<<"4";
										stk.push(&arr[counter-1]);cout<<"5";
									}

	|	/*EMPTY*/					{
										cout<<"deal with stmts -> empty\n";
										addNode("STMTS");addNode("empty");
										arr[counter-2].son[0] = &arr[counter-1];
										stk.push(&arr[counter-2]);										
									}
	;

STMT://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		EXP SEMI                                        {
															cout<<"deal with stmt -> exp semi\n";
															addNode("STMT");addNode("SEMI");
															arr[counter-2].son[0] = stk.top();stk.pop();
															arr[counter-2].son[1] = &arr[counter-1];
															stk.push(&arr[counter-2]);
														}
	|	STMTBLOCK                                       {
															cout<<"deal with stmt -> stmtblock\n";
															addNode("STMT");
															arr[counter-1].son[0] = stk.top();stk.pop();
															stk.push(&arr[counter-1]);
														}
	|	RETURN EXP SEMI                                 {
															cout<<"deal with stmt -> stmtblock\n";
															addNode("STMT");addNode("RETURN");addNode("SEMI");
															arr[counter-3].son[1] = stk.top();stk.pop();
															arr[counter-3].son[0] =&arr[counter-2];
															arr[counter-3].son[2] = &arr[counter-1];
															stk.push(&arr[counter-3]);
														}

	|	IF LP EXP RP STMT ESTMT                         {
															cout<<"deal with stmt -> if lp exp rp stmt estmt\n";
															addNode("STMT");addNode("IF");addNode("LP");addNode("RP");
															arr[counter-4].son[0] = &arr[counter-3];
															arr[counter-4].son[1] = &arr[counter-2];
															arr[counter-4].son[3] = &arr[counter-1];
															arr[counter-4].son[5] = stk.top();stk.pop();
															arr[counter-4].son[4] = stk.top();stk.pop();
															arr[counter-4].son[2] = stk.top();stk.pop();
															stk.push(&arr[counter-4]);
														}

	|	FOR LP FEXP SEMI FEXP SEMI FEXP RP STMT            {
															addNode("STMT");addNode("FOR");addNode("LP");addNode("SEMI");addNode("SEMI");addNode("RP");
															arr[counter-6].son[0] = &arr[counter-5];
															arr[counter-6].son[1] = &arr[counter-4];
															arr[counter-6].son[3] = &arr[counter-3];
															arr[counter-6].son[5] = &arr[counter-2];
															arr[counter-6].son[7] = &arr[counter-1];
															arr[counter-6].son[8] = stk.top();stk.pop();
															arr[counter-6].son[6] = stk.top();stk.pop();
															arr[counter-6].son[4] = stk.top();stk.pop();
															arr[counter-6].son[2] = stk.top();stk.pop();
															stk.push(&arr[counter-6]);
														}

	|	CONT SEMI                                       {
															cout<<"deal with stmt -> cont semi\n";
															addNode("STMT");addNode("SEMI");
															arr[counter-2].son[1] = &arr[counter-1];
															arr[counter-2].son[0] = stk.top();stk.pop();
															stk.push(&arr[counter-2]);	
														} 

	|	BREAK SEMI                                      {
															cout<<"deal with stmt -> break semi\n";
															addNode("STMT");addNode("BREAK");addNode("STMI");
												
															arr[counter-3].son[0] = &arr[counter-2];
															arr[counter-3].son[1] = &arr[counter-1];
															stk.push(&arr[counter-3]);
														} 
	;

ESTMT:
		ELSE STMT           		                    {
															cout<<"deal with estmt -> else stmt\n";
															addNode("ESTMT");addNode("ELSE");
															arr[counter-2].son[0] = &arr[counter-1];
															arr[counter-2].son[1] = stk.top();stk.pop();
															stk.push(&arr[counter-2]);
														}
	|						%prec NOELSE                {
															cout<<"deal with estmt -> empty\n";
															addNode("ESTMT");addNode("empty");
															arr[counter-2].son[0] = &arr[counter-1];
															stk.push(&arr[counter-2]);
														}

	;




DEFS://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		DEF DEFS                                       {
															cout<<"deal with defs -> def defs\n";
															addNode("DEFS");
															arr[counter-1].son[1] = stk.top();stk.pop();
															arr[counter-1].son[0] = stk.top();stk.pop();
															stk.push(&arr[counter-1]);
														}

	|	/*EMPTY*/	      				          		{
															cout<<"deal with defs -> empty\n";
															addNode("DEFS");addNode("empty");
															arr[counter-2].son[0] = &arr[counter-1];
															stk.push(&arr[counter-2]);										
														}
	;
     
DEF://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		SPEC DECS SEMI      			                {
															cout<<"deal with def -> spec decs semi\n";
															addNode("DEF");addNode("SEMI");
															arr[counter-2].son[1] = stk.top();stk.pop();
															arr[counter-2].son[0] = stk.top();stk.pop();
															arr[counter-2].son[2] = &arr[counter-1];
															stk.push(&arr[counter-2]);	
														}
	;

DECS://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		DEC COMMA DECS      {
								cout<<"deal with decs -> dec comma decs\n";
								addNode("DECS");addNode("COMMA");
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								arr[counter-2].son[1] = &arr[counter-1];
								stk.push(&arr[counter-2]);
							}
	|	DEC                 {
								cout<<"deal with decs -> dec\n";
								addNode("DECS");
								arr[counter-1].son[0] = stk.top();stk.pop();	
								stk.push(&arr[counter-1]);								
							}
	;

DEC://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		VAR					{
								cout<<"deal with dec -> var\n";
								addNode("DEC");
								arr[counter-1].son[0] = stk.top();stk.pop();	
								stk.push(&arr[counter-1]);	
							}	

	|	VAR ASSIGNOP INIT	{
								cout<<"deal with dec -> var assignop init\n";
								addNode("DEC");addNode("ASSIGNOP");
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								arr[counter-2].son[1] = &arr[counter-1];
								stk.push(&arr[counter-2]);	
							}	
	;

INIT:
		EXP                 {
								cout<<"deal with init -> exp\n";
								addNode("INIT");
								arr[counter-1].son[0] = stk.top();stk.pop();	
								stk.push(&arr[counter-1]);	 
		                    }

	|	LC ARGS RC          {
								cout<<"deal with init -> lc args rc\n";
								addNode("INIT");
								addNode("LC");
								addNode("RC");
								arr[counter-3].son[0] = &arr[counter-2];
								arr[counter-3].son[2] = &arr[counter-1];
								arr[counter-3].son[1] = stk.top();stk.pop();	
								stk.push(&arr[counter-3]);
							}
	;

EXP://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		LP EXP RP           {
								cout<<"deal with exp -> lp exp rp\n";
								addNode("EXP");addNode("LP");addNode("RP");
								arr[counter-3].son[0] = &arr[counter-2];
								arr[counter-3].son[2] = &arr[counter-1];
								arr[counter-3].son[1] = stk.top();stk.pop();	
								stk.push(&arr[counter-3]);	
							}
	|	ID LP ARGS RP       {
								cout<<"deal with exp -> id lp args rp\n";
								addNode("EXP");addNode("ID");addNode("LP");addNode("RP");
								arr[counter-4].son[0] = &arr[counter-3];
								arr[counter-4].son[1] = &arr[counter-2];
								arr[counter-4].son[2] = stk.top();stk.pop();
								arr[counter-4].son[3] = &arr[counter-1];	
								stk.push(&arr[counter-4]);	
											
							}
	|	ID ARRS             {
								cout<<"deal with exp -> id arrs\n";
								addNode("EXP");char *tmp = ("ID(%s)",$1);addNode(tmp);
								arr[counter-2].son[0] = &arr[counter-1];
								arr[counter-2].son[1] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}
	|	EXP DOT ID /*x.length()?*/{
								cout<<"deal with exp -> exp dot id\n";
								addNode("EXP");addNode("DOT");char *tmp = ("ID(%s)",$3);addNode(tmp);
								arr[counter-3].son[1] = &arr[counter-2];
								arr[counter-3].son[2] = &arr[counter-1];
								arr[counter-3].son[0] = stk.top();stk.pop();	
								stk.push(&arr[counter-3]);				
							}
	|	INT                 {
								cout<<"deal with exp -> int\n";
								addNode("EXP");char *tmp = ("INT(%d)",$1);addNode(tmp);	
								arr[counter-2].son[0] = &arr[counter-1];
								stk.push(&arr[counter-2]);						
							}
	|	UNARYOP EXP         {
								cout<<"deal with exp -> unaryop exp\n";
								addNode("EXP");addNode("UNIARYOP");
								arr[counter-2].son[0] = &arr[counter-1];
								arr[counter-2].son[1] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
	                        }

	|	EXP BINARYOP EXP    	{
								cout<<"deal with exp -> exp BINARYOP exp\n";
								addNode("EXP");
								char *tmp = ("BINARYOP:%S",$2);
								addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}	

	|	MINUS EXP %prec	UNMINUS {
								cout<<"deal with exp -> MINUS exp\n";
								addNode("EXP");addNode("MINUS");
								arr[counter-2].son[0] = &arr[counter-1];
								arr[counter-2].son[1] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}	

	|	EXP MINUS EXP    	{
								cout<<"deal with exp -> exp MINUS exp\n";
								addNode("EXP");
								addNode("BINARYOP:-");
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);	
							}	


	|	EXP PLUS EXP    	{
								cout<<"deal with exp -> exp PLUS exp\n";
								addNode("EXP");
								addNode("BINARYOP:+");
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}	       


	|	EXP SHIFTOP EXP    	{
								cout<<"deal with exp -> exp SHIFTOP exp\n";
								addNode("EXP");
								char *tmp = ("SHIFT(%S)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}	                     

	|	EXP COMPAREOP EXP    	{
								cout<<"deal with exp -> exp COMPAREOP exp\n";
								addNode("EXP");
								char *tmp = ("COMPARE(%s)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}


	|	EXP EQUALOP EXP    	{
								cout<<"deal with exp -> exp EQUALOP exp\n";
								addNode("EXP");
								char *tmp = ("EQUALOP(%s)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}


	|	EXP BITXOR EXP    	{
								cout<<"deal with exp -> exp BITXOR exp\n";
								addNode("EXP");
								char *tmp = ("BITXOR(%s)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}

	|	EXP BITOR EXP    	{
								cout<<"deal with exp -> exp BITOR exp\n";
								addNode("EXP");
								char *tmp = ("BITOR(%s)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}

	|	EXP BITAND EXP    	{
								cout<<"deal with exp -> exp BITAND exp\n";
								addNode("EXP");
								char *tmp = ("BITAND(%s)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}

	|	EXP LOGICALAND EXP  {
								cout<<"deal with exp -> exp LOGICALAND exp\n";
								addNode("EXP");
								char *tmp = ("LOGICALAND(%s)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
	                        }

	|	EXP LOGICALOR EXP   {
								cout<<"deal with exp -> exp LOGICALOR exp\n";
								addNode("EXP");
								char *tmp = ("LOGICALOR(%s)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
	                        }

	|	EXP BINASSIGNOP EXP    {
								cout<<"deal with exp -> exp BINASSIGNOP exp\n";
								addNode("EXP");
								char *tmp = ("BINASSIGNOP(%s)",$2);addNode(tmp);
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);	
	                        }

	|	EXP ASSIGNOP EXP    {
								cout<<"deal with exp -> exp assignop exp\n";
								addNode("EXP");
								addNode("ASSIGNOP");
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);
							}	
	;
FEXP://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		EXP 				{
								cout<<"deal with fexp -> exp\n";
								addNode("FEXP");
								arr[counter-1].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-1]);
							}
	|	/*EMPTY*/           {   cout<<"deal with fexp -> empty\n";
								addNode("EXPS");addNode("empty");
								arr[counter-2].son[0] = &arr[counter-1];
								stk.push(&arr[counter-2]);	
							}


ARRS://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		LB EXP RB ARRS      {
								cout<<"deal with arrs -> lb exp rb arrs\n";
								addNode("ARRS");
								addNode("LB");
								addNode("RB");
								arr[counter-3].son[0] = &arr[counter-2];
								arr[counter-3].son[2] = &arr[counter-1];
								arr[counter-3].son[3] = stk.top();stk.pop();
								arr[counter-3].son[1] = stk.top();stk.pop();	
								stk.push(&arr[counter-3]);	 
							}
	|	/*EMPTY*/			{
								cout<<"deal with arrs -> empty\n";
								addNode("ARRS");addNode("empty");
								arr[counter-2].son[0] = &arr[counter-1];
								stk.push(&arr[counter-2]);						
							}
	;

ARGS://okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
		EXP COMMA ARGS      {
								cout<<"deal with args -> exp comma args\n";
								addNode("ARRS");
								addNode("COMMA");
								arr[counter-2].son[1] = &arr[counter-1];
								arr[counter-2].son[2] = stk.top();stk.pop();
								arr[counter-2].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-2]);	
							}	

	|	EXP					{
								cout<<"deal with args -> exp\n";
								addNode("ARGS");
								arr[counter-1].son[0] = stk.top();stk.pop();
								stk.push(&arr[counter-1]);
							}	
	;


%%


int main (int argc, char const *argv[]) {

	if (argc == 1){
		fprintf(stderr, "%s\n", "please write your code or specify the input file");

		yyparse();
		preOrder(&arr[counter-1],1);
		return 0;
	}

	else if (argc == 2){
		FILE *fin = fopen(argv[1],"r");
		if (!fin) { 
			return fprintf (stderr, "YACC: Input file %s does not exist!\n", argv[1]);
		}
		yyin = fin;
		while(!feof(yyin)){
			yyparse();
		}
		preOrder(&arr[counter-1],1);
		fclose(fin);
	}

	else if (argc == 3){
		FILE *fin = fopen(argv[1], "r");
		FILE *fout = fopen(argv[2],"w");
		if (!fin) {
			return fprintf (stderr, "YACC: Input file %s does not exist!\n", argv[1]);
		}
		if (!fout) {
			return fprintf (stderr, "YACC: Output file %s does not exist!\n", argv[2]);
		}
		yyin = fin;
		yyout = fout;
		while (!feof(yyin)){
			yyparse();
		}
		preOrder(&arr[counter-1],1);
		fclose(fin);
		fclose(fout);
	}

	else {
		fprintf(stderr, "%s\n" , "YACC: Wrong format.");
		fprintf(stderr, "%s\n" , "YACC: or you can specify the source code path. \nexample --> $./a.out  inputFile outputFile\n");
	}
	return 0;
}

/* Added because panther doesn't have liby.a installed. */
int yyerror (const char *msg) {
	printFlag = false;
	fprintf (stderr, "YACC: %s\n", msg);
	fprintf(stderr, "YACC: line %d\n", yylineno);
	fprintf(stderr, "YACC: at %s\n", yytext);
	return -1;
}
