//
//  LXOperatorScanner.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOperatorScanner.h"


@implementation LXOperatorScanner

+ (lxoperator) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner
{
    //prepare the scanner
    if( scanner==nil )
    {
        scanner = [LXScanner scannerWithString:inputText];
    }

    [scanner pushStyle:[LXScanner operatorStyle]];
    unichar currentChar = [scanner currentChar];
    [scanner scanForward:1];

    lxoperator currentOp;

    switch( currentChar )
    {
    case '(':
        currentOp = argumentsOp;
        break;
    case '{':
        currentOp = codeBlockOp;
        break;
    case '%':
        //check next character: %= modulusAssignOp, % modulusOp
        if( [scanner scanString:@"="] )
        {
            currentOp = modulusAssignOp;
        }
        else
        {
            currentOp = modulusOp;
        }
        break;
    case '-':
        //check next character: -- post-decrement, -= subtractionAssignOp, -> dotOp (php/c++ style), - subtractionOp
        if( [scanner scanString:@"-"] )
        {
            currentOp = postDecrementOp;
        }
        else if( [scanner scanString:@"="] )
        {
            currentOp = subtractionAssignOp;
        }
        else if( [scanner scanString:@">"] )
        {
            currentOp = dotOp;
        }
        else
        {
            currentOp = subtractionOp;
        }
        break;
    case '+':
        //check next character: ++ post-increment, += additionAssignOp, + additionOp
        if( [scanner scanString:@"+"] )
        {
            currentOp = postIncrementOp;
        }
        else if( [scanner scanString:@"="] )
        {
            currentOp = additionAssignOp;
        }
        else
        {
            currentOp = additionOp;
        }
        break;
    case '*':
        //check next character: ** exponentOp (gnuplot style)
        if( [scanner scanString:@"*"] )
        {
            currentOp = exponentOp;
            break;
        }
    case 0x00d7: //×
        //check next character: *= ×= multiplicationAssignOp, * × multiplicationOp
        if( [scanner scanString:@"="] )
        {
            currentOp = multiplicationAssignOp;
        }
        else
        {
            currentOp = multiplicationOp;
        }
        break;
    case '/':
    case 0x00f7: //÷
        //check next character: /= divisionAssignOp, / divisionOp
        if( [scanner scanString:@"="] )
        {
            currentOp = divisionAssignOp;
        }
        else
        {
            currentOp = divisionOp;
        }
        break;
    case '.':
        currentOp = dotOp;
        break;
    case '[':
        currentOp = rangeOp;
        break;
    case ':':
        //check next character: :: seriesOp, : eitherOp
        if( [scanner scanString:@":"] )
        {
            currentOp = seriesOp;
        }
        else
        {
            currentOp = eitherOp;
        }
        break;
    case '^':
        //check next character: ^= exponentAssignOp, ^| bitwiseXorOp, ^ exponent
        if( [scanner scanString:@"="] )
        {
            currentOp = exponentAssignOp;
        }
        else if( [scanner scanString:@"|"] )
        {
            currentOp = bitwiseXorOp;
        }
        else
        {
            currentOp = exponentOp;
        }
        break;
    case '!':
        // != , ≠ , or ! are all equivalent (easier than making x ! 2 an error: let it slide!)
        // !== not identical
        if( [scanner scanString:@"=="] )
        {
            currentOp = notIdenticalOp;
        }
        else if( [scanner scanString:@"="] )
        {
            currentOp = notEqualOp;
        }
        else
        {
            currentOp = notOp;
        }
        break;
    case 0x2260: //≠
        currentOp = notEqualOp;
        break;
    case '=':
        //check next character: == equalOp, = assignOp
        if( [scanner scanString:@"="] )
        {
            currentOp = equalOp;
        }
        else
        {
            currentOp = assignOp;
        }
        break;
    case 0x2264: //≤
        currentOp = ltEqualOp;
        break;
    case 0x2265: //≥
        currentOp = gtEqualOp;
        break;
    case '<':
        //check next character: <= ltEqualOp, << shiftLeftOp, < ltOp  **notice that 2 <<varname> is wrong.  2 < <varname> is right.
        if( [scanner scanString:@"="] )
        {
            currentOp = ltEqualOp;
        }
        else if( [scanner scanString:@"<"] )
        {
            currentOp = shiftLeftOp;
        }
        else
        {
            currentOp = ltOp;
        }
        break;
    case '>':
        //check next character: >= gtEqualOp, >> shiftRightOp, > gtOp
        if( [scanner scanString:@"="] )
        {
            currentOp = gtEqualOp;
        }
        else if( [scanner scanString:@">"] )
        {
            currentOp = shiftRightOp;
        }
        else
        {
            currentOp = gtOp;
        }
        break;
    case '&':
        //check next character: && boolean and, & bitwise and
        if( [scanner scanString:@"&"] )
        {
            currentOp = andOp;
        }
        else
        {
            currentOp = bitwiseAndOp;
        }
        break;
    case '|':
        //check next character: || boolean or, | bitwise or
        if( [scanner scanString:@"|"] )
        {
            currentOp = orOp;
        }
        else
        {
            currentOp = bitwiseOrOp;
        }
        break;
    case ',':
        //this will create an 'operation' between two vector/argument/range values.
        //this operation is not processed like usual operations.  the first time a comma is found,
        //an array is made to hold the arguments.  at the end, that array is turned into an LXVectorValue object.
        currentOp = nextArgOp;
        break;
    case '?':
        currentOp = conditionalOp;
        break;
    case ')':
        currentOp = closeParenthesesOp;
        break;
    case '}':
        currentOp = closeCurlyOp;
        break;
    case ']':
        currentOp = closeBracketOp;
        break;
    case ';':
    case '\n':
        currentOp = eolOp;
        break;
    default:
        [scanner scanBack:1]; //don't scan the character, whatever it was.
        currentOp = nextArgOp;

        //the default action is to assume that another value has been found
        //so things like x = {1 2 3 4 5}; is fine, as opposed to the formal x = {1,2,3,4,5};
        //however, ambiguous things like x = {1 2 3 -4 5} will turn into x = {1, 2, 3-4, 5}
        break;
    }

    [scanner popStyle];

    return currentOp;
}
@end
