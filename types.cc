#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"


Types caseExpressionType; //global variable which holds the type of the case expression so that we can compare it 

Types declaredType; //global variable which holds the type of the declared return type of a function so that we can compare it with the type which is returned


void checkAssignment(Types lValue, Types rValue, string message){

	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
	{	
		
		if (lValue !=BOOL_TYPE && rValue == BOOL_TYPE)
		{
			appendError(GENERAL_SEMANTIC, "Type Mismatch, can't be Boolean");
		}
	
		if (lValue ==BOOL_TYPE && rValue != BOOL_TYPE)
		{
			appendError(GENERAL_SEMANTIC, "Type Mismatch, must be boolean");
		}
		
		if (lValue ==INT_TYPE && rValue == REAL_TYPE)
		{
			appendError(GENERAL_SEMANTIC, "Variable Initialization Can't Be Narrowed, Must Be Integer");
		}
		
	}
	
	
	}

void declareReturnType (Types declaredReturnType){

	declaredType = declaredReturnType; //store the return type that the user declared for the function to be able to check if he indeed returns the function with correct type.

}

void checkReturnType(Types returnedType){

if (declaredType == INT_TYPE && returnedType == REAL_TYPE) {
		appendError(GENERAL_SEMANTIC, "Narrowing Function Return Type from INT to REAL is not Allowed. ");
	}
	if ( returnedType == BOOL_TYPE && (declaredType == INT_TYPE || declaredType == REAL_TYPE)) {
		appendError(GENERAL_SEMANTIC, "Returned Type Doesen't Match The Declared Function's Return Type. ");
	}
	if (declaredType == BOOL_TYPE && (returnedType == INT_TYPE || returnedType == REAL_TYPE)) {
		appendError(GENERAL_SEMANTIC, "Returned Type Doesen't Match The Declared Function's Return Type. ");
	}

}

void checkIf(Types expression, Types thenStatement, Types elseStatement)
{
	if(expression != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "'If' Expression Must Be Of Boolean Type");
	}
	if(thenStatement != elseStatement)
	{
		appendError(GENERAL_SEMANTIC, "Then And Else Statements Must Be Of The Same Type");
	}
}

//the logic followed here is the same with the check return type 
void caseExpression(Types expression)
{
	caseExpressionType = expression; // save the case expression type in a global variable to be used by checkOtherStatement and checkCase
}

//iif any of the cases expression Type doesent match the type of the case statement.
void checkCase(Types statement) 
{
	if(statement != caseExpressionType)
	{
	appendError(GENERAL_SEMANTIC, "Case Type Mismatch");	
	}
}

//if the type of the expression of other statement doesent match the case type statement.
void checkOtherStatement(Types otherStatement)
{
	if(otherStatement != caseExpressionType) 
	{
	appendError(GENERAL_SEMANTIC, "Case Type Mismatch In Other Statement");	
	}
}



//Remainder Operator must have Integer Operands.
void checkRemainder(Types left, Types right)
{
	if(left != INT_TYPE || right !=INT_TYPE)
	{
	appendError(GENERAL_SEMANTIC, "Whole And Remainder Must Be Integers");	
	}
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
	{
		return MISMATCH;
	}
		
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Integer Type Required");
		return MISMATCH;
	}
	
	if (left == INT_TYPE && right == REAL_TYPE)
	{
		return REAL_TYPE;
	}
	
	if (left == REAL_TYPE && right == INT_TYPE)
	{
		return REAL_TYPE;
	}	
	
	return INT_TYPE;
}

Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
	{
		return MISMATCH;
	}
		
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
	{
		return MISMATCH;
	}
	return BOOL_TYPE;
}
	
