/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>
#include <vector>
#include <map>


using namespace std;

#include "symbols.h"
#include "listing.h"
#include "types.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

bool began = false;




%}

%define parse.error verbose


%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token TYPE
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL



%token ADDOP MULOP RELOP REMOP EXPOP
%token ANDOP OROP NOTOP 

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS


%token ARROW CASE ELSE ENDCASE ENDIF IF OTHERS REAL THEN WHEN

%type <type> type body statement_ statement reductions expression relation term factor primary binary remop expop notop case_ case




%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' {declareReturnType($5);} 
	| error ';' ;	 //On error, skip until ';' is read. 

optional_variable:
	optional_variable variable 	
	|
	;

variable:
	IDENTIFIER ':' type IS statement_  {checkAssignment($3, $5, "Variable Initialization"); if (symbols.find($1, $3)) appendError(DUPLICATE_IDENTIFIER, $1); symbols.insert($1, $3);}
	| error ';' ;	//On error, skip until ';' is read. 


parameters:
	parameter more_parameters;


//parameter1, parameter2, ... , parameter n
more_parameters:
	more_parameters ',' parameter
	|
	;

	

parameter:
	IDENTIFIER ':' type {symbols.insert($1, $3);}
	|
	;
	 

type:
	INTEGER {$$ = INT_TYPE;}
	| REAL	{$$ = REAL_TYPE;}
	| BOOLEAN  {$$ = BOOL_TYPE;}
	;


body:
	BEGIN_ {began = true;} statement_ END ';' ;

    
statement_:
	statement ';' {if(began) {checkReturnType($1);}}
	|error ';' {$$ = MISMATCH;} //On error, skip until ';' is read. 
	;

	
statement:
	expression 
	| REDUCE operator reductions ENDREDUCE {$$ = $3;}
	| IF expression THEN statement_ ELSE statement_ ENDIF {checkIf($2, $4, $6);}
	| CASE expression {caseExpression($2);} IS case_ OTHERS ARROW statement_ ENDCASE {checkOtherStatement($8);};
	


operator:
	ADDOP
	|MULOP
	;


case_: 
	case_ case
	|{$$ = MISMATCH;}
	;

	
case:
	WHEN INT_LITERAL ARROW statement_ {checkCase($4);}
	|error ';'  {$$ = MISMATCH;}	//On error, skip until ';' is read. 
	;
	

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);}
	|{$$ = INT_TYPE;}
	;

//the following rules are created to apply the correct precedence to the expression 		    
expression:
	expression OROP binary {$$ = checkLogical($1, $3);}
	|binary
	;

	
binary:
	binary ANDOP relation {$$ = checkLogical($1, $3);} 
	|relation
	;


relation:
	relation RELOP term {$$ = checkRelational($1, $3);}
	|term
	;


term:
	term ADDOP remop {$$ = checkArithmetic($1, $3);}
	|remop
	;


remop:
	remop REMOP factor  {$$ = checkArithmetic($1, $3); checkRemainder($1, $3);}  
	|factor
	;    
  
factor:
	factor MULOP expop  {$$ = checkArithmetic($1, $3);} 
	|expop 
	;
	
expop:
	primary EXPOP notop {$$ = checkArithmetic($1, $3);}
	|notop
	;

notop: 	NOTOP primary {$$ = $2;}
	|primary
	;


primary:
	'(' expression ')' {$$ = $2;}
	|INT_LITERAL	{$$ = INT_TYPE;}
	|REAL_LITERAL	{$$ = REAL_TYPE;}
	|BOOL_LITERAL	{$$ = BOOL_TYPE;}
	|IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);}
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
