/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER

%token BOOL_LITERAL INT_LITERAL REAL_LITERAL

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%token ADDOP MULOP RELOP ANDOP OROP NOTOP REMOP EXPOP

%token ANDOP OROP NOTOP

%token ARROW CASE ELSE ENDCASE ENDIF IF OTHERS REAL THEN WHEN


%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' 
	| error ';' ;	 //On error, skip until ';' is read. 

optional_variable:
	optional_variable variable 	
	|
	;

variable:
	IDENTIFIER ':' type IS statement_ 
	| error ';' ;	//On error, skip until ';' is read. 


parameters:
	parameter more_parameters; // we created the more_parameters non-terminal in order to be able to accept more than one arguments in a function, seperated by comma. the rule is implemented next.


//parameter1, parameter2, ... , parameter n
more_parameters:
	more_parameters ',' parameter
	|
	;

	

parameter:
	IDENTIFIER ':' type
	|
	;
	 

type:
	INTEGER
	| REAL
	| BOOLEAN 
	;


body:
	BEGIN_ statement_ END ';' ;

    
statement_:
	statement ';'
	|error ';' //On error, skip until ';' is read. 
	;

	
statement:
	expression 
	| REDUCE operator reductions ENDREDUCE 
	| IF expression THEN statement_ ELSE statement_ ENDIF
	| CASE expression IS case_ OTHERS ARROW statement_ ENDCASE 
	;


operator:
	ADDOP
	|MULOP
	;


case_: 
	case_ case
	|
	;

	
case:
	WHEN INT_LITERAL ARROW statement_
	|error ';' 	//On error, skip until ';' is read. 
	;
	

reductions:
	reductions statement_ 
	|
	;

//the following rules are created to apply the correct precedence to the expression 		    
expression:
	expression OROP binary 
	|binary
	;

	
binary:
	binary ANDOP relation
	|relation
	;


relation:
	relation RELOP term
	|term
	;


term:
	term ADDOP remop
	|remop
	;


remop:
	remop REMOP factor
	|factor
	;    
  
factor:
	factor MULOP expop
	|expop 
	;
	
expop :
	primary EXPOP notop
	|notop
	;
	
notop: 
	NOTOP primary
	|primary
	;


primary:
	'(' expression ')'
	|INT_LITERAL
	|REAL_LITERAL
	|BOOL_LITERAL
	|IDENTIFIER
	;    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
