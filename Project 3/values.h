// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, ADD, SUBTRACT, MULTIPLY, DIVIDE, EXPONENT, REM, ARR, EQUAL, NOTEQUAL, GREATER, GREATEREQUAL, LESSEQUAL};

int evaluateReduction(Operators operator_, int head, int tail);

int evaluateIf(int expression, int thenStatement, int elseStatement);

int chooseCaseorOther(int cases, int otherStatement);
int mergeCases (int head, int tail);  
int evaluateCase(int literal, int statement);
void caseIdentifier (int expression);

int evaluateRelational(int left, Operators operator_, int right);

int evaluateArithmetic(int left, Operators operator_, int right);