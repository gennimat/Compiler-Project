// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int cases;
int caseID;
bool flag;

int evaluateReduction(Operators operator_, int head, int tail){

	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


int evaluateIf(int expression, int thenStatement, int elseStatement){

	if (expression == 1){
		return thenStatement; //if expression is true continue with then branch
		}
	return elseStatement; // if expression is not true continue with else branch
}



void caseIdentifier (int expression){

	caseID = expression; // take the value from identifier token
}


int evaluateCase(int literal, int statement){
	

	if (literal == caseID) //if literal equals the value we gained from the caseIdentifier function 
	{
		flag = true; //set flag variable to true to know if we found a matching case
		return statement; //return statement
	}
	return 0; //if literal doesnt equals the value we gained from the caseIdentifier function return 0
}




int chooseCaseorOther(int cases, int otherStatement){

	if (flag == true) { //if we found a matching case at the evaluateCase function
		flag = false; // reset flag to false to reuse
		return cases; 
	}
	
	return otherStatement;
}


int mergeCases(int head, int tail){

		cases = head + tail; //merges all cases that are not others into case_
		return cases; 
}



int evaluateRelational(int left, Operators operator_, int right){

	int result;
	switch (operator_)
	{	
		case LESS:
			result = left < right;
			break;
			
		case EQUAL:
			result = left == right;
			break;
		
		case NOTEQUAL:
			result = left != right;
			break;
			
		case GREATER:
			result = left > right;
			break;
			
		case GREATEREQUAL:
			result = left >= right;
				break;
				
		case LESSEQUAL:
			result = left <= right;
			break;
		
		default:
			break;
	}
	return result;
}

int evaluateArithmetic(int left, Operators operator_, int right){

	int result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		
		case SUBTRACT:
			result = left - right;		
			break;
			
		case MULTIPLY:
			result = left * right;
			break;
		
		case DIVIDE:
			result = left / right;
			break;
			
		case EXPONENT:
			result = pow(left,right);
			break;
			
		case REM:
			if (right != 0){
			result = left % right;
			}
			break;
			
		case ARR: 
			left = right;
			result = left;
			break;
			
		default:
			break;
	}
			
	return result;
}
