//
//  LXFormulaScanner.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月11日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXFormulaScanner.h"

#import "LXValue.h"
#import "LXVectorValue.h"
#import "LXPairValue.h"
#import "LXOperator.h"
#import "LXOpArguments.h"
#import "LXParentheses.h"
#import "LXError.h"

#import "LXCodeBlockScanner.h"
#import "LXVariableNameScanner.h"
#import "LXStringScanner.h"
#import "LXNumberScanner.h"
#import "LXOperatorScanner.h"

@implementation LXFormulaScanner

+ (LXValue*) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner
{
    //only the LXCodeBlockScanner uses this form, so it is the start of a new command.  This is useful
    //when an EOL character (\n, ;) is found.  All formula scanners except the one looking for eolOp will stop just BEFORE the EOL char.
    return [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:eolOp];
}

+ (LXValue*) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner upToOperator:(lxoperator)lowestOperator
{
    //prepare the scanner
    if( scanner==nil )
    {
        scanner = [LXScanner scannerWithString:inputText];
    }

    [scanner skipWhitespace];
    [scanner pushStyle:[LXScanner defaultStyle]];

    unichar currentChar = [scanner currentChar];
    LXValue *leftVal = nil;
    LXValue *rightVal = nil;
    LXOperator *tempop = nil;
    lxoperator currentOp, scanOp;

    NSMutableArray *vectorVal = nil;

    BOOL valueExpected = YES;
    BOOL keepScanning = YES;

    //in case this is at the end of an empty function()
    if( currentChar==')' )
    {
        [scanner popStyle];
        return nil;
    }

    [scanner skipWhitespace];

    while( keepScanning && ! [scanner isAtEnd])
    {
        if( valueExpected )
        {
            valueExpected = NO;

            //could be parentheses (), vector {}, dictionary [], negate -, not !, binary negate ~, number 123, string "", variable name <>
            //TODO:, #label iff lowestOperator==eolOp
            switch(currentChar)
            {
            case '#':
                /*
                if( lowestOperator==eolOp )
                {
                    leftVal = [LXVariableNameScanner scan:inputText usingScanner:scanner];
                    //label
                    keepScanning = NO;
                }
                else
                */
                {
                    [scanner pushStyle:[LXScanner commentStyle]];
                    [scanner scanUpToString:@"\n"];
                    [scanner scanString:@"\n"];
                    [scanner popStyle];
                    keepScanning = NO;
                }
                break;

            case '(':
                [scanner scanString:@"("];
                //scan the parentheses as a formula (closeParenthesesOp is a very low-valued operation)
                leftVal = [LXParentheses value:[LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:closeParenthesesOp]];

                //TODO: error check; closing ')'
                [scanner scanString:@")"];
                break;

            case '[':
                [scanner scanString:@"["];
                //scan the vector as a comma separated group, ending in a }
                leftVal = [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:closeBracketOp];

                //TODO: error check; closing '}'
                [scanner scanString:@"]"];

                //check that leftVal is a vector
                //if leftVal is not a vector, make it one
                if( ! [leftVal isKindOfClass:[LXVectorValue class]] )
                {
                    leftVal = [LXValue vectorValue:[NSArray arrayWithObject:leftVal]];
                }
                break;

            case '-':
                [scanner pushStyle:[LXScanner operatorStyle]];
                if( [scanner scanString:@"--"] )
                {
                    [scanner popStyle];
                    //prepare the pre-decrement operation
                    tempop = [LXOperator operator:preDecrementOp];
                    leftVal = [LXVariableNameScanner scan:inputText usingScanner:scanner];
                    [tempop setLeftValue:leftVal];

                    leftVal = tempop;
                }
                else
                {
                    [scanner scanString:@"-"];
                    [scanner popStyle];
                    //prepare the negate operation.  the only thing higher is an exponent or function operation.
                    tempop = [LXOperator operator:negateOp];
                    leftVal = [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:negateOp];
                    [tempop setLeftValue:leftVal];

                    leftVal = [(LXOperator*)tempop simplify]; //give the negate operation a chance to decrease overhead; may return a negative number
                }
                break;

            case '+':
                [scanner pushStyle:[LXScanner operatorStyle]];
                if( [scanner scanString:@"++"] )
                {
                    [scanner popStyle];
                    //prepare the pre-increment operation
                    tempop = [LXOperator operator:preIncrementOp];
                    leftVal = [LXVariableNameScanner scan:inputText usingScanner:scanner];
                    [tempop setLeftValue:leftVal];

                    leftVal = tempop;
                }
                else
                {
                    [scanner scanString:@"+"];
                    [scanner popStyle];
                    //any number or variable can be preceded by a "+", but it will be ignored.
                    leftVal = [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:negateOp];
                }
                break;

            case '!':
                [scanner pushStyle:[LXScanner operatorStyle]];
                [scanner scanString:@"!"];
                [scanner popStyle];
                //prepare the not operation
                tempop = [LXOperator operator:notOp];
                leftVal = [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:notOp];
                [tempop setLeftValue:leftVal];

                leftVal = tempop;
                break;

            case '~':
                [scanner pushStyle:[LXScanner operatorStyle]];
                [scanner scanString:@"~"];
                [scanner popStyle];
                //prepare the not operation
                tempop = [LXOperator operator:bitwiseNotOp];
                leftVal = [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:bitwiseNotOp];
                [tempop setLeftValue:leftVal];

                leftVal = tempop;
                break;

            case '"':
                //string scanner needs to scan the first ' or " to determine the closing character
                leftVal = [LXStringScanner scan:inputText usingScanner:scanner];
                break;

            case '0':case'1':case'2':case'3':case'4':case'5':case'6':case'7':case'8':case'9':case'.':
                //number scanner needs to scan the first digit
                leftVal = [LXNumberScanner scan:inputText usingScanner:scanner];
                break;

            case 'a':case'b':case'c':case'd':case'e':case'f':case'g':case'h':case'i':case'j':case'k':case'l':case'm':case'n':case'o':case'p':case'q':case'r':case's':case't':case'u':case'v':case'w':case'x':case'y':case'z':
            case 'A':case'B':case'C':case'D':case'E':case'F':case'G':case'H':case'I':case'J':case'K':case'L':case'M':case'N':case'O':case'P':case'Q':case'R':case'S':case'T':case'U':case'V':case'W':case'X':case'Y':case'Z':
            case '<':case'_':
                //variable name scanner needs to scan the first letter
                leftVal = [LXVariableNameScanner scan:inputText usingScanner:scanner];
                //leftVal is now a placeholder, not yet an actual variable.
                //the nature of the placeholder is determined at run time.  If it is used
                //in an expression, like X+1, the value will be fetched and used.
                //if it's used in an assignment, the variable is fetched and the value is stored.
                //in the case of a dotOp or rangeOp, a new placeholder (or placeholders) is created.
                //actually, the LXOpDot and LXOpRange objects can act as placeholders in their own right.
                //the only difference is that they respond to -(id)setValue: and -(id)value accordingly.
                break;

            default:
                //TODO: assign an error value to leftVal and exit
                [scanner pushStyle:[LXScanner commentStyle]];
                [scanner scanUpToString:@"\n"];
                [scanner popStyle];
                [scanner scanString:@"\n"];
                keepScanning = NO;
            }
        }
        else //an operation is expected
        {
            // scan the operation, and compare with lowestOperator.
            // If the operation is higher than the lowestOperator, continue.
            // otherwise, back up and exit the current scan.
            int opIndex = [scanner scanLocation];

            //scan for the next op
            currentOp = [LXOperatorScanner scan:inputText usingScanner:scanner];
            //* automatically scans the operator
            BOOL keepChecking = NO;

            if( [LXOperator compare:currentOp isLessThan:lowestOperator] )
            {
                //the current operation is of lower or same precedence than the previous operation
                //5*3*2
                //   ^  like here

                //if the lowestOperator is eolOp, this is the end of this operation, otherwise unscan the operation
                if( lowestOperator != eolOp )
                {
                    [scanner setScanLocation:opIndex];
                }
                keepScanning = NO;
            }
            else //the operation should be processed (it is higher precedence than the current operation)
            {
                switch(currentOp)
                {
                case argumentsOp:
                    rightVal = [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:closeParenthesesOp];
                    [scanner scanString:@")"];

                    //if leftVal is a variableName, this will activate its function ability
                    //TODO: otherwise, create an error
                    tempop = [LXOperator operator:argumentsOp];
                    [tempop setLeftValue:leftVal];
                    [tempop setArguments:rightVal];

                    leftVal = tempop;

                    //don't scan a value
                    keepChecking = NO;
                    break;

                case codeBlockOp:
                    rightVal = [LXCodeBlockScanner scan:inputText usingScanner:scanner];

                    //this is used with function/code blocks like if, try, class, ...
                    //TODO: create an error if it's an unsupported type in leftVal
                    if( [leftVal isKindOfClass:[LXOpArguments class]] )
                    {
                        [leftVal setCodeBlock:rightVal];
                    }
                    else
                    {
                        tempop = [LXOperator operator:argumentsOp];
                        [tempop setLeftValue:leftVal];
                        [tempop setCodeBlock:rightVal];

                        leftVal = tempop;
                    }

                    //don't scan a value
                    keepChecking = NO;
                    break;

                //preIncr-Decr-ment is taken care of above, as a value, not an operation
                case postDecrementOp:
                case postIncrementOp:
                    //store the operation
                    tempop = [LXOperator operator:currentOp];
                    [tempop setLeftValue:leftVal];

                    leftVal = tempop;
                    //search for another operation
                    keepChecking = NO;
                    break;

                case nextArgOp:
                    //a comma (or NON-op symbol) has been found.  The argument should be stored in an array, and the array should be converted to
                    //an LXVector in lieu of just returning leftVal.
                    if( !vectorVal )
                    {
                        vectorVal = [NSMutableArray array];
                    }

                    [vectorVal addObject:leftVal];

                    //restart the scanning
                    valueExpected = YES;
                    leftVal = nil;
                    rightVal = nil;
                    break;

                case rangeOp:
                    //special case of rangeOp; looks for a matching ']'
                    rightVal = [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:closeBracketOp];

                    //rightVal may be a scalar or vector;
                    //just leave it as is.  the LXOpRange object will use this information to
                    //determine whether to return a vector or scalar.
                    //a[1] -> scalar   -> a[1]
                    //a[1,2] -> vector -> {a[1], a[2]}
                    //a[{1,2}, {3,4}]  -> { { a[1], a[2] }, { a[3], a[4] } }
                    //a[{1}] -> vector -> {a[1]}

                    //TODO: error check; closing ']'
                    [scanner scanString:@"]"];

                    //store the operation
                    tempop = [LXOperator operator:rangeOp];
                    [tempop setRightValue:rightVal];
                    [tempop setLeftValue:leftVal];

                    leftVal = tempop;
                    break;

                case closeParenthesesOp:
                case closeCurlyOp:
                case closeBracketOp:
                case noOp:
                    break;

                default:
                    //here comes the recursive function.  this will scan in another formula, treating it as a single value.
                    //it stops when it reaches an operator of lower precedence than the current operation )]} < + < * < ^

                    //special cases of right-ordered operations (assigns, exponent)
                    //their scanning op is lower than their actual op, so 2^3^4 -> 2^(3^4) not (2^3)^4 like with left-to-right ops
                    scanOp = [LXOperator rightOrder: currentOp];

                    rightVal = [LXFormulaScanner scan:inputText usingScanner:scanner upToOperator:scanOp];

                    //store the operation
                    tempop = [LXOperator operator:currentOp];
                    [tempop setRightValue:rightVal];
                    [tempop setLeftValue:leftVal];

                    leftVal = tempop;
                    break;

                }
            }
        } //either an operation or a value has been scanned.

        [scanner skipSpaces];

        if( ![scanner isAtEnd] )    currentChar = [scanner currentChar];
    }

    if( vectorVal )
    {
        [vectorVal addObject:leftVal];
        leftVal = [LXValue vectorValue:vectorVal];
    }

    [scanner popStyle];
    return leftVal;
}

@end
