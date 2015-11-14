%code requires
{
#define YYSTYPE char*

}

%{

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include <stack>
#include "Tree.h"

void yyerror(const char *str){
    fprintf(stderr,"error: %s\n", str);
}



int yylex();
stack<treeNode *> stk;


%}

//%token <iValue> INT
//%token <sIndex> ID
%token INT ID SEMI COMMA DOT ASSIGNOP TYPE LP RP LB RB LC RC STRUCT RETURN IF ELSE BREAK CONT FOR
%start PROGRAM

%right	NOELSE ELSE
%right 	ASSIGNOP
%left BINARYOP1 '-'
%left BINARYOP2
%right UMINUS
%left DOT LP RP LB RB

%%
PROGRAM     :   EXTDEFS {cout<<1<<' ';
					addNode("PROGRAM");
					arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
				} 
            ;



EXTDEFS     :   EXTDEF EXTDEFS { cout<<2<<' ';
					addNode("EXTDEFS");
					arr[counter-1].son[1] = stk.top();stk.pop();
					arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
				}
            |   /* */{addNode("EXTDEFS");addNode("empty");arr[counter-2].son[0] =&arr[counter-1];stk.push(&arr[counter-2]);} //{ $$ = opr('e', 0); }
            ;

EXTDEF      :   SPEC EXTVARS SEMI {cout<<3<<' ';
					addNode("EXTDEF");addNode("SEMI");
					arr[counter-2].son[1] = stk.top();stk.pop();
					arr[counter-2].son[0] = stk.top();stk.pop();
					arr[counter-2].son[2] = &arr[counter-1];
					stk.push(&arr[counter-2]); 
				}
            |   SPEC FUNC STMTBLOCK  {cout<<4<<' ';
					addNode("EXTDEF");arr[counter-1].son[2] = stk.top();
					stk.pop();arr[counter-1].son[1] = stk.top();stk.pop();
					arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
				}
            ;

EXTVARS     :   DEC {cout<<5<<' ';
					 addNode("EXTVARS");
					 arr[counter-1].son[0] = stk.top();stk.pop();
					 stk.push(&arr[counter-1]);
				}

            |   DEC COMMA EXTVARS { cout<<6<<' ';
					addNode("EXTVARS");addNode("COMMA");
					arr[counter-2].son[1] = &arr[counter-1];arr[counter-2].son[2]=stk.top();stk.pop();
					arr[counter-2].son[0]=stk.top();stk.pop();
					stk.push(&arr[counter-2]);
				}

            |   /* */{addNode("EXTVARS");addNode("empty");arr[counter-2].son[0] =&arr[counter-1];stk.push(&arr[counter-2]);} //{ $$ = opr('e', 0);}
            ;

SPEC        :   TYPE { cout<<7<<' ';
					addNode("SPEC");addNode("TYPE");
					arr[counter-2].son[0] = &arr[counter-1];
					stk.push(&arr[counter-2]);
				}

            |   STSPEC {cout<<8<<' ';
					addNode("SPEC");arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
				}
            ;

STSPEC      :   STRUCT OPTTAG LC DEFS RC {cout<<9<<' ';
					addNode("STSPEC");addNode("STRUCT");addNode("LC");addNode("RC");
					arr[counter-4].son[0] = &arr[counter-3];
					arr[counter-4].son[3] = stk.top();stk.pop();
					arr[counter-4].son[1] = stk.top();stk.pop();
					arr[counter-4].son[2] = &arr[counter-2];arr[counter-4].son[4] = &arr[counter-1];
					stk.push(&arr[counter-4]);
				}

            |   STRUCT ID {cout<<10<<' ';
					addNode("STSPEC");addNode("STRUCT");char *tmp = ("ID(%s)",$2);addNode(tmp);
					arr[counter-3].son[0] = &arr[counter-2];arr[counter-3].son[1] = &arr[counter-1];
					stk.push(&arr[counter-1]);
				}

            ;

OPTTAG      :   ID {cout<<11<<' ';
					addNode("OPTTAG");char *tmp = ("ID(%s)",$1);addNode(tmp);
					arr[counter-2].son[0] = &arr[counter-1];
					stk.push(&arr[counter-2]);
				}

            |   /* */{addNode("OPTTAG");addNode("empty");arr[counter-2].son[0] =&arr[counter-1];stk.push(&arr[counter-2]);} //{ $$ = opr('e', 0); }
            ;
VAR         :   ID {cout<<12<<' ';

					addNode("VAR");char *tmp = ("ID(%s)",$1);addNode(tmp);//addNode(($1));
					arr[counter-2].son[0] = &arr[counter-1];
					stk.push(&arr[counter-2]);
				}

            |   VAR LB INT RB {cout<<13<<' ';
					addNode("VAR");addNode("LB");addNode("INT");addNode("RB");
					arr[counter-4].son[0] = stk.top();stk.pop();
					arr[counter-4].son[1] = &arr[counter-3];
					arr[counter-4].son[2] = &arr[counter-2];
					arr[counter-4].son[3] = &arr[counter-1];
					stk.push(&arr[counter-4]);
				}

FUNC        :   ID LP PARAS RP {cout<<14<<' ';
					cout<<1;
					addNode("FUNC");char *tmp = ("ID(%s)",$1);addNode(tmp);addNode("LP");addNode("RP");
					arr[counter-4].son[0] = &arr[counter-3];arr[counter-4].son[1] = &arr[counter-2];
					arr[counter-4].son[3] = &arr[counter-1];arr[counter-4].son[2] = stk.top();stk.pop();
					stk.push(&arr[counter-4]);
				}
            ;
PARAS       :   PARA COMMA PARAS {cout<<15<<' ';
					addNode("PARAS");addNode("COMMA");
					arr[counter-2].son[2] = stk.top();stk.pop();
					arr[counter-2].son[1] = &arr[counter-1];arr[counter-2].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
				}
            |   PARA {cout<<16<<' ';
					addNode("PARAS");
					arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);

				}
            |   {
            ;
PARA        :   SPEC VAR {cout<<17<<' ';
					addNode("PARA");
					arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
				}
            ;
STMTBLOCK   :   LC DEFS STMTS RC {cout<<18<<' ';
					addNode("STMTBLOCK");
					addNode("LC");
					addNode("RC");
					arr[counter-3].son[0] = &arr[counter-2];
					arr[counter-3].son[3] = &arr[counter-1];
					arr[counter-3].son[2] = stk.top();stk.pop();
					arr[counter-3].son[1] = stk.top();stk.pop();
					stk.push(&arr[counter-3]);
					
				}
            ;
STMTS       :   STMT STMTS {cout<<19<<' ';
					addNode("STMTS");
					arr[counter-1].son[1] = stk.top();stk.pop();
					arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
				}
            |   { addNode("STMTS");addNode("empty");arr[counter-2].son[0] = &arr[counter-1];}
            ;
STMT        :   EXP SEMI {cout<<20<<' ';
					addNode("STMT");addNode("SEMI");
					arr[counter-2].son[0] = stk.top();stk.pop();
					arr[counter-2].son[1] = &arr[counter-1];
					stk.push(&arr[counter-2]);
				}
            |   STMTBLOCK { addNode("STMT");arr[counter-1].son[1] = stk.top();stk.pop();stk.push(&arr[counter-1]);}

            |   RETURN EXP SEMI {cout<<21<<' ';
					addNode("STMT");addNode("SEMI");
					arr[counter-2].son[0] = stk.top();stk.pop();
					arr[counter-2].son[1] = stk.top();stk.pop();
					arr[counter-2].son[2] = &arr[counter-1];
                    stk.push(&arr[counter-2]);
				}

            |   IF LP EXP RP STMT ESTMT {cout<<22<<' ';
					addNode("STMT");addNode("IF");addNode("LP");addNode("RP");
					arr[counter-4].son[0] = &arr[counter-3];
					arr[counter-4].son[1] = &arr[counter-2];
					arr[counter-4].son[3] = &arr[counter-1];
					arr[counter-4].son[5] = stk.top();stk.pop();
					arr[counter-4].son[4] = stk.top();stk.pop();
					arr[counter-4].son[2] = stk.top();stk.pop();
                    stk.push(&arr[counter-4]);
					
				}

            |   FOR LP EXPS SEMI EXPS SEMI EXPS RP STMT { cout<<23<<' ';
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
					stk.push(&arr[counter-4]);
				 }

            |   CONT SEMI {cout<<24<<' ';
					addNode("STMT");addNode("SEMI");
					arr[counter-2].son[1] = &arr[counter-1];
					arr[counter-2].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-2]);					
				}

            |   BREAK SEMI {cout<<25<<' ';
					cout<<2;
					cout<<arr[0].syn<<arr[1].syn<<arr[2].syn;
					addNode("STMT");addNode("BREAK");addNode("STMI");
					cout<<arr[0].syn<<arr[1].syn<<arr[2].syn;
					arr[counter-3].son[0] = &arr[counter-2];
					arr[counter-3].son[1] = &arr[counter-1];
					stk.push(&arr[counter-3]);
			    }
            ;

ESTMT       :   ELSE STMT {cout<<26<<' ';
					addNode("ESTMT");addNode("ELSE");
					arr[counter-2].son[0] = &arr[counter-1];
					arr[counter-2].son[1] = stk.top();stk.pop();
					stk.push(&arr[counter-2]);
					
			    }
            |    %prec NOELSE
            ;
DEFS        :   DEF DEFS {cout<<27<<' ';
					addNode("DEFS");
					arr[counter-1].son[2] = stk.top();stk.pop();
					arr[counter-1].son[1] = stk.top();stk.pop();
					stk.push(&arr[counter-2]);				
			   }
            |     { addNode("DEFS");addNode("empty");arr[counter-2].son[0] = &arr[counter-1];}            ;

DEF         :   SPEC DECS SEMI {cout<<28<<' ';
					addNode("DEF");addNode("SEMI");
					arr[counter-2].son[1] = stk.top();stk.pop();
					arr[counter-2].son[0] = stk.top();stk.pop();
					arr[counter-2].son[0] = &arr[counter-1];
					stk.push(&arr[counter-2]);	
			   }
            ;
DECS        :   DEC COMMA DECS {cout<<29<<' ';
					addNode("DECS");addNode("COMMA");
					arr[counter-2].son[2] = stk.top();stk.pop();
					arr[counter-2].son[0] = stk.top();stk.pop();
					arr[counter-2].son[1] = &arr[counter-1];
					stk.push(&arr[counter-2]);					
 			   }

            |   DEC {cout<<30<<' ';
					addNode("DECS");
					arr[counter-1].son[0] = stk.top();stk.pop();	
					stk.push(&arr[counter-1]);					   
			   }

            ;
DEC         :   VAR {cout<<31<<' ';
					addNode("DEC");
					arr[counter-1].son[0] = stk.top();stk.pop();	
					stk.push(&arr[counter-1]);	 
			   }

            |   VAR ASSIGNOP INIT {cout<<32<<' ';
					addNode("DEC");addNode("ASSIGNOP");
					arr[counter-2].son[2] = stk.top();stk.pop();
					arr[counter-2].son[0] = stk.top();stk.pop();
					arr[counter-2].son[1] = &arr[counter-1];
					stk.push(&arr[counter-2]);	 
			   }
            ;
INIT        :   EXPS  { cout<<33<<' ';
					addNode("INIT");
					arr[counter-1].son[0] = stk.top();stk.pop();	
					stk.push(&arr[counter-1]);	 
			   }
            |   LC ARGS RC  {cout<<34<<' ';
					addNode("INIT");
					addNode("LC");
					addNode("RC");
					arr[counter-3].son[0] = &arr[counter-2];
					arr[counter-3].son[2] = &arr[counter-1];
					arr[counter-3].son[1] = stk.top();stk.pop();	
					stk.push(&arr[counter-3]);	 
			   }
            ;
ARRS        :   LB EXP RB ARRS {cout<<35<<' ';
					addNode("ARRS");
					addNode("LB");
					addNode("RB");
					arr[counter-3].son[0] = &arr[counter-2];
					arr[counter-3].son[2] = &arr[counter-1];
					arr[counter-3].son[3] = stk.top();stk.pop();
					arr[counter-3].son[1] = stk.top();stk.pop();	
					stk.push(&arr[counter-3]);	 
			   }
            |  { addNode("ARRS");addNode("empty");arr[counter-2].son[0] = &arr[counter-1];}
            ;
ARGS        :   EXP COMMA ARGS { cout<<36<<' ';
					addNode("ARRS");
					addNode("COMMA");
					arr[counter-2].son[1] = &arr[counter-1];
					arr[counter-2].son[2] = stk.top();stk.pop();
					arr[counter-2].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-3]);	
			   }
            |   EXPS {cout<<37<<' ';
					addNode("ARGS");
					arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
			   }
            ;

EXPS        :   EXP {cout<<38<<' ';
			   		addNode("EXPS");
					arr[counter-1].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-1]);
			   }
			|   { addNode("EXPS");addNode("empty");arr[counter-2].son[0] = &arr[counter-1];}

EXP         :   EXP BINARYOP1 EXP {
					addNode("EXP");
					char *tmp = ("BINARYOP:%S",$2);
					addNode(tmp);
					arr[counter-2].son[1] = &arr[counter-1];
					arr[counter-2].son[2] = stk.top();stk.pop();
					arr[counter-2].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-2]);
			   }
	  	    |   EXP BINARYOP2 EXP { 
					addNode("EXP");
					char *tmp = ("BINARYOP:%S",$2);
					addNode(tmp);
					arr[counter-2].son[1] = &arr[counter-1];
					arr[counter-2].son[2] = stk.top();stk.pop();
					arr[counter-2].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-2]);
			   }
			|   EXP '-' EXP { 
					addNode("EXP");
					addNode("BINARYOP:-");
					arr[counter-2].son[1] = &arr[counter-1];
					arr[counter-2].son[2] = stk.top();stk.pop();
					arr[counter-2].son[0] = stk.top();stk.pop();
					stk.push(&arr[counter-2]);
			   }
	       
            |   '-' EXP  %prec UMINUS {
					addNode("EXP");
					addNode("UNIARYOP:-");
					arr[counter-2].son[0] = &arr[counter-1];
					arr[counter-2].son[1] = stk.top();stk.pop();
					stk.push(&arr[counter-2]);					
 				}
            |   LP EXP RP   { 
					addNode("EXP");addNode("LP");addNode("RP");
					arr[counter-3].son[0] = &arr[counter-2];
					arr[counter-3].son[2] = &arr[counter-1];
					arr[counter-3].son[1] = stk.top();stk.pop();	
					stk.push(&arr[counter-3]);	
			   }
            |   ID  { 
					cout<<5;
					addNode("EXP");char *tmp = ("ID(%s)",$1);addNode(tmp);
					arr[counter-2].son[0] = &arr[counter-1];
					stk.push(&arr[counter-2]);
			   }
            |   EXP DOT ID { 
					addNode("EXP");addNode("DOT");addNode("ID"); 
					arr[counter-3].son[1] = &arr[counter-2];
					arr[counter-3].son[2] = &arr[counter-1];
					arr[counter-3].son[0] = stk.top();stk.pop();	
					stk.push(&arr[counter-3]);	
			   }
            |   INT {
					addNode("EXP");
					addNode("INT");
					arr[counter-2].son[0] = &arr[counter-1];
					stk.push(&arr[counter-2]);					
 			   }
	    ;

%%

//#define SIZEOF_NODETYPE ((char *) &p->con - (char *)p)


int main(void){
    printf("%s\n","please input the small-c codes");	
    yyparse();
	preOrder(&arr[counter-1],1);
    return 1;
}
