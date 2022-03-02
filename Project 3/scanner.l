/* Compiler Theory and Design
   Dr. Duane J. Jarc */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "values.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
othercomment	"//".*\n
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9])*  
digit		[0-9]
int		{digit}+
punc		[\(\),:;]
real		{digit}+\.{digit}*([eE][+-]?{digit}+)?


%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{othercomment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}

"<"		{ ECHO;  yylval.oper = LESS; return(RELOP); }
"+"		{ ECHO;  yylval.oper = ADD ; return(ADDOP); }
"*"		{ ECHO;  yylval.oper = MULTIPLY; return(MULOP); }
"=>"		{ ECHO;  yylval.oper = ARR; return(ARROW); }	

"=" 		{ ECHO;  yylval.oper = EQUAL; return(RELOP); }
"/="		{ ECHO;  yylval.oper = NOTEQUAL; return(RELOP); }
">"		{ ECHO;  yylval.oper = GREATER; return(RELOP); }
">="		{ ECHO;  yylval.oper = GREATEREQUAL; return(RELOP); }
"<="		{ ECHO;  yylval.oper = LESSEQUAL; return(RELOP); } 

"/"		{ ECHO;  yylval.oper = DIVIDE; return(MULOP); }
"-"		{ ECHO;  yylval.oper = SUBTRACT; return(ADDOP); }

"**"		{ ECHO;  yylval.oper = EXPONENT; return(EXPOP); }

true		{ECHO;   yylval.value= true; return (BOOL_LITERAL);}
false		{ECHO;   yylval.value = false; return (BOOL_LITERAL);}

begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
case 		{ ECHO; return(CASE); }
else 		{ ECHO; return(ELSE); }
endcase		{ ECHO; return(ENDCASE); } 
endif		{ ECHO; return(ENDIF); }
if		{ ECHO; return(IF); }
others		{ ECHO; return(OTHERS); } 
real		{ ECHO; return(REAL); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }

or		{ ECHO; return(OROP); }
not		{ ECHO; return(NOTOP); }

rem		{ ECHO; yylval.oper = REM; return(REMOP); } 


{int}		{ ECHO;  yylval.value = atoi(yytext); return(INT_LITERAL); }

{real}		{ ECHO;  yylval.value = atoi(yytext); return(REAL_LITERAL); }



{id}		{ ECHO;	yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
			
{punc}		{ ECHO; return(yytext[0]); }

.		{ ECHO; appendError(LEXICAL, yytext); }
%%

