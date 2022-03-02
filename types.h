typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE};

void checkAssignment(Types lValue, Types rValue, string message);

//
void checkIf(Types expression, Types thenStatement, Types elseStatement);

void declareReturnType (Types returnType);

void checkReturnType(Types returnedType);


void caseExpression(Types expression);
void checkOtherStatement(Types otherStatement);
void checkCase(Types statement);
void checkRemainder(Types left, Types right);

Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);