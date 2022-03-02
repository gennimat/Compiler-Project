/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>
#include <iostream>
#include <vector>
#include <map>
#include <cassert>
#include <cstdlib>
#include <queue>


using namespace std;

#include "symbols.h"
#include "listing.h"
#include "values.h"

int yylex();
void yyerror(const char* message);

Symbols<int> symbols;

int result;

//queue stores the args values
queue<int> argumentQueue;


%}

%define parse.error verbose


%union
{
	CharPtr iden;
	Operators oper;
	int value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL
%token TYPE


%token <oper> ADDOP MULOP RELOP REMOP EXPOP
%token ANDOP OROP NOTOP 

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS


%token ARROW CASE ELSE ENDCASE ENDIF IF OTHERS REAL THEN WHEN

%type <value> body statement_ statement reductions expression relation term factor primary binary remop expop notop case_ case

%type <oper> operator


%%

function:	
	function_header optional_variable body {result = $3;};
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' 
	| error ';' ;	 //On error, skip until ';' is read. 

optional_variable:
	optional_variable variable 	
	|
	;

variable:
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);}
	| error ';' ;	//On error, skip until ';' is read. 


parameters:
	parameter more_parameters; // we created the more_parameters non-terminal in order to be able to accept more than one arguments in a function, seperated by comma. the rule is implemented next.


//parameter1, parameter2, ... , parameter n
more_parameters:
	more_parameters ',' parameter
	|
	;

	

parameter:
	IDENTIFIER ':' type {symbols.insert($1, argumentQueue.front()); argumentQueue.pop();}
	|
	;
	 

type:
	INTEGER
	| REAL
	| BOOLEAN 
	;


body:
	BEGIN_ statement_ END ';'  {$$ = $2;} ;

    
statement_:
	statement ';'
	|error ';' {$$ = 0;} //On error, skip until ';' is read. 
	;

	
statement:
	expression 
	| REDUCE operator reductions ENDREDUCE {$$ = $3;}
	| IF expression THEN statement_ ELSE statement_ ENDIF {$$ = evaluateIf($2, $4, $6);}
	| CASE expression {caseIdentifier($2);} IS case_ OTHERS ARROW statement_ ENDCASE {$$ = chooseCaseorOther($5, $8);}
	;


operator:
	ADDOP
	|MULOP
	;


case_: 
	case_ case {$$ = mergeCases($1, $2);}
	|{$$ = 0;}
	;

	
case:
	WHEN INT_LITERAL ARROW statement_ {$$ = evaluateCase($2, $4);}
	|error ';' {$$ = 0;}	//On error, skip until ';' is read. 
	;
	

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);}
	|{$$ = $<oper>0 == ADD ? 0 : 1;}
	;

//the following rules are created to apply the correct precedence to the expression 		    
expression:
	expression OROP binary {$$ = $1 || $3;}
	|binary
	;

	
binary:
	binary ANDOP relation {$$ = $1 && $3;}
	|relation
	;


relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);}
	|term
	;


term:
	term ADDOP remop {$$ = evaluateArithmetic($1, $2, $3);}
	|remop
	;


remop:
	remop REMOP factor {$$ = evaluateArithmetic($1, $2, $3);}
	|factor
	;    
  
factor:
	factor MULOP expop {$$ = evaluateArithmetic($1, $2, $3);}
	|expop 
	;
	
expop:
	primary EXPOP notop {$$ = evaluateArithmetic($1, $2, $3);}
	|notop
	;

notop: 	NOTOP primary {$$ = !$2;}
	|primary
	;


primary:
	'(' expression ')' {$$ = $2;}
	|INT_LITERAL
	|REAL_LITERAL
	|BOOL_LITERAL
	|IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);}
	;    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{

	for (int i = 1; i < argc; i++){
	
	argumentQueue.push(atoi(argv[i])); // save the arguments to the queue converting string input to integers using the atoi function.
	
	}
	
	
	firstLine();
	yyparse();
	
	
	if (lastLine() == 0){
		printf("Result = %d", result); //print the result
	}
	
	return 0;
} 
