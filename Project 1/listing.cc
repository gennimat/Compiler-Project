// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>

#include <iostream>
#include <queue> 


using namespace std;

#include "listing.h"

static int lineNumber;
static string error = ""; //this variable holds the error message
static int totalErrors = 0;//total error start counting at 0

static void displayErrors();

int lexicalerror; //total number of lexical errors in the program.
int syntaxerror;  // total number of syntax errors in the program (at project1 will always be 0).
int semanticerror; // total number of semantic errors in the program (at project 1 will always be 0).


queue<string> errorqueue; //create the errorqueue.


void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	if (totalErrors == 0){
	printf("Compiled Sucessfully\n");
	}
	else {
	printf("Lexical Errors: %d\n", lexicalerror);
	printf("Syntax Errors: %d\n", syntaxerror);
	printf("Semantic Errors: %d\n", semanticerror);
	
	}

	return totalErrors;
	
}
    
void appendError(ErrorCategories errorCategory, string message)
{

	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

		
	if(errorCategory == 0){
	lexicalerror++;
	}
	
	else if (errorCategory == 1){
	syntaxerror++;
	}
	
	else if (errorCategory ==2){
	semanticerror++;
	}
	
	else if (errorCategory ==3 ){
	semanticerror++;
	}

	error = messages[errorCategory] + message;
	totalErrors++;
	
	errorqueue.push(error); //FIFO(for correct order) push the error messages in the queue so we can display them later with displayErrors().
	
}

void displayErrors()
{
	
	while (!errorqueue.empty()){
	
		printf("%s\n", errorqueue.front().c_str()); //print the error message.
		errorqueue.pop(); //remove the error message that we printed from the queue.
	}
		
	error.assign(""); //initialize the error to "" again, to be be able to get new errors if there are.
}
