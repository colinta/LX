//
//  LXOperator.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月20日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXOperator.h"
#import "LXNumberValue.h"
#import "LXError.h"
#import "LXOps.h"
#import "LXOpArguments.h"

@implementation LXOperator

+ (LXOperator*) operator:(lxoperator)op
{
    Class c = [LXOperator class];
    switch(op)
    {
        case argumentsOp: c = [LXOpArguments class]; break;
        case codeBlockOp: c = [LXOpArguments class]; break;
        case exponentOp: c = [LXOpExponent class]; break;
        case negateOp: c = [LXOpNegate class]; break;
        case seriesOp: c = [LXOpSeries class]; break;
        case rangeOp: c = [LXOpRange class]; break;
        case dotOp: c = [LXOpDot class]; break;
        case modulusOp: c = [LXOpModulus class]; break;
        case multiplicationOp: c = [LXOpMultiplication class]; break;
        case divisionOp: c = [LXOpDivision class]; break;
        case additionOp: c = [LXOpAddition class]; break;
        case subtractionOp: c = [LXOpSubtraction class]; break;
        case notOp: c = [LXOpNot class]; break;
        case andOp: c = [LXOpAnd class]; break;
        case orOp: c = [LXOpOr class]; break;
        case equalOp: c = [LXOpEqual class]; break;
        case notEqualOp: c = [LXOpNotEqual class]; break;
        case notIdenticalOp: c = [LXOpNotIdentical class]; break;
        case ltOp: c = [LXOpLessThan class]; break;
        case gtOp: c = [LXOpGreaterThan class]; break;
        case ltEqualOp: c = [LXOpLessThanEqual class]; break;
        case gtEqualOp: c = [LXOpGreaterThanEqual class]; break;
        case bitwiseAndOp: c = [LXOpBitwiseAnd class]; break;
        case bitwiseNotOp: c = [LXOpBitwiseNot class]; break;
        case bitwiseOrOp: c = [LXOpBitwiseOr class]; break;
        case bitwiseXorOp: c = [LXOpBitwiseXor class]; break;
        case shiftLeftOp: c = [LXOpShiftLeft class]; break;
        case shiftRightOp: c = [LXOpShiftRight class]; break;
        case conditionalOp: c = [LXOpConditional class]; break;
        case eitherOp: c = [LXOpEither class]; break;
        case assignOp: c = [LXOpAssign class]; break;
        case modulusAssignOp: c = [LXOpModulusAssign class]; break;
        case exponentAssignOp: c = [LXOpExponentAssign class]; break;
        case additionAssignOp: c = [LXOpAdditionAssign class]; break;
        case subtractionAssignOp: c = [LXOpSubtractionAssign class]; break;
        case multiplicationAssignOp: c = [LXOpMultiplicationAssign class]; break;
        case divisionAssignOp: c = [LXOpDivisionAssign class]; break;
        case preIncrementOp: c = [LXOpPreIncrement class]; break;
        case postIncrementOp: c = [LXOpPostIncrement class]; break;
        case preDecrementOp: c = [LXOpPreDecrement class]; break;
        case postDecrementOp: c = [LXOpPostDecrement class]; break;
    }

    LXOperator *ret = [[c alloc] initWithOp:op];

    return ret;
}

+ (BOOL) compare:(lxoperator)left isLessThan:(lxoperator)lowerop
{
    if( left==argumentsOp || left==codeBlockOp ||
        left==postIncrementOp || left==postIncrementOp ) return NO;

    int leftValue = 0;
    int lowerValue= 0;

    switch( left )
    {
        //a ; symbol can effectively close all unmatched parentheses
        case eolOp:
            leftValue = 0;
            break;

        case closeParenthesesOp:
        case closeCurlyOp:
        case closeBracketOp:
            leftValue = 10;
            break;

        //arguments can be separated with a comma, and this has very low precedence
        case nextArgOp:
            leftValue = 15;
            break;

        case assignScanOp:
            leftValue = 19;
            break;

        case assignOp:
        case modulusAssignOp:
        case exponentAssignOp:
        case additionAssignOp:
        case subtractionAssignOp:
        case multiplicationAssignOp:
        case divisionAssignOp:
            leftValue = 29;
            break;

        case conditionalOp:
            leftValue = 30;
            break;

        case eitherOp:
            leftValue = 35;
            break;

        case andOp:
            leftValue = 40;
            break;

        case orOp:
            leftValue = 45;
            break;

        case equalOp:
        case notEqualOp:
        case notIdenticalOp:
        case ltOp:
        case gtOp:
        case ltEqualOp:
        case gtEqualOp:
            leftValue = 50;
            break;

        case additionOp:
        case subtractionOp:
            leftValue = 55;
            break;

        case modulusOp:
        case multiplicationOp:
        case divisionOp:
            leftValue = 60;
            break;

        //done with most math operations

        //a series is treated mostly as a normal number, so negates and exponents take higher precendence,
        //so 1 + -1::2^2 - 2 =
        //   1 + (-1)::(2^2) - 2 =
        //   1 + -1::4 - 1 =
        //   1 + {-1 0 1 2 3 4} - 2 =
        //   {0 1 2 3 4 5} - 2 =
        //   {-2 -1 0 1 2 3}
        case seriesOp:
            leftValue = 65;
            break;

        case negateOp:
            leftValue = 70;
            break;

        case exponentScanOp:
            leftValue = 74;
            break;

        case exponentOp:
            leftValue = 75;
            break;

        //[bitwise]not has higher precedence than exponent, so !1^2 -> (!1) ^ 2 -> 0 ^ 2 -> 0
        case bitwiseNotOp:
        case notOp:
            leftValue = 80;
            break;

        //post-/pre- Incr- / Decr- ements act on variables, so allow variable operations to take precedence
        case postIncrementOp:
        case postDecrementOp:
        case preIncrementOp:
        case preDecrementOp:
            leftValue = 85;
            break;

        //a variable/placeholder will be retrieved via a direct name,
        //or a combination of names, dots, and ranges.
        //that's why arg/code ops are lower precedence.
        case argumentsOp:
        case codeBlockOp:
            leftValue = 90;
            break;

        //these operations take place between variable names, so they have the highest precedence
        //this is tricky: x.c[1].r SHOULD go to {(x . c) [1]} . r
        //                           NOT        {(x . c) [1 . r]}
        //this is accomplished becase when rangeOp is scanned, it is immediately attached to whatever is to its left.
        //in this case, the x.c variable, since the dot has higher precedence.
        case rangeOp:
            leftValue = 95;
            break;

        case dotOp:
            leftValue = 100;
            break;
    }

    switch( lowerop )
    {
        case eolOp:
            lowerValue = 0;
            break;

        case closeParenthesesOp:
            lowerValue = 10;
            break;

        case nextArgOp:
            lowerValue = 15;
            break;

        case assignScanOp:
            lowerValue = 19;
            break;

        case assignOp:
        case modulusAssignOp:
        case exponentAssignOp:
        case additionAssignOp:
        case subtractionAssignOp:
        case multiplicationAssignOp:
        case divisionAssignOp:
            lowerValue = 29;
            break;

        case conditionalOp:
            lowerValue = 30;
            break;

        case eitherOp:
            lowerValue = 35;
            break;

        case andOp:
            lowerValue = 40;
            break;

        case orOp:
            lowerValue = 45;
            break;

        case equalOp:
        case notEqualOp:
        case notIdenticalOp:
        case ltOp:
        case gtOp:
        case ltEqualOp:
        case gtEqualOp:
            lowerValue = 50;
            break;

        case additionOp:
        case subtractionOp:
            lowerValue = 55;
            break;

        case modulusOp:
        case multiplicationOp:
        case divisionOp:
            lowerValue = 60;
            break;

        case seriesOp:
            lowerValue = 65;
            break;

        case negateOp:
            lowerValue = 70;
            break;

        case exponentScanOp:
            lowerValue = 74;
            break;

        case exponentOp:
            lowerValue = 75;
            break;

        case bitwiseNotOp:
        case notOp:
            lowerValue = 80;
            break;

        case postIncrementOp:
        case postDecrementOp:
        case preIncrementOp:
        case preDecrementOp:
            lowerValue = 85;
            break;

        case argumentsOp:
        case codeBlockOp:
            lowerValue = 90;
            break;

        case rangeOp:
            lowerValue = 95;
            break;

        case dotOp:
            lowerValue = 100;
            break;
    }

    return (leftValue <= lowerValue);
}

+ (lxoperator) rightOrder:(lxoperator)value
{
    switch(value)
    {
        case exponentOp:
            return exponentScanOp;

        case assignOp:
        case modulusAssignOp:
        case exponentAssignOp:
        case additionAssignOp:
        case subtractionAssignOp:
        case multiplicationAssignOp:
        case divisionAssignOp:
            return assignScanOp;
    }

    return value;
}

- (id) initWithOp:(lxoperator)value
{
    self = [super init];
    if( self )
    {
        op = value;
        left = nil;
        right = nil;
        runtime = nil;
    }
    return self;
}

- (lxoperator) operator
{
    return op;
}

- (LXValue*) leftValue { return left; }
- (LXValue*) rightValue { return right; }

- (void) setLeftValue:(LXValue*) value
{
    left = value;
}

- (void) setRightValue:(LXValue*) value
{
    right = value;
}

- (NSString*) displayString:(NSString*)tabs
{
    NSMutableString *ret = [NSMutableString string];

    //notOp, rangeOp, negateOp are displayed differently than the default
    switch(op)
    {
    case notOp:
        [ret appendString:@"!"];
        [ret appendString:[left displayString:tabs]];
        break;

    case rangeOp:
        [ret appendString:[left displayString:tabs]];
        [ret appendString:@"["];
        [ret appendString:[right displayString:tabs]];
        [ret appendString:@"]"];
        break;

    case negateOp:
        [ret appendString:@"-"];
        [ret appendString:[left displayString:tabs]];
        break;

    case dotOp:
        [ret appendString:[left displayString:tabs]];
        [ret appendString:@"."];
        [ret appendString:[right displayString:tabs]];
        break;

    case preIncrementOp:
        [ret appendString:@"++"];
        [ret appendString:[left displayString:tabs]];
        break;

    case postIncrementOp:
        [ret appendString:[left displayString:tabs]];
        [ret appendString:@"++"];
        break;

    case preDecrementOp:
        [ret appendString:@"--"];
        [ret appendString:[left displayString:tabs]];
        break;

    case postDecrementOp:
        [ret appendString:[left displayString:tabs]];
        [ret appendString:@"--"];
        break;

    default:
        [ret appendString:[left displayString:tabs]];
        [ret appendString:@" "];
        [ret appendString:[self opToString]];
        [ret appendString:@" "];
        [ret appendString:[right displayString:tabs]];
    }

    return ret;
}

- (NSString*) opToString
{
    NSString *ret = @"";

    switch( op )
    {
        case exponentOp:        ret = @"^";        break;
        case negateOp:            ret = @"-";        break;

        case seriesOp:            ret = @"::";    break;
        case rangeOp:            ret = @"[]";    break;
        case dotOp:                ret = @".";        break;

        case modulusOp:            ret = @"%";        break;
        case multiplicationOp:    ret = @"*";        break;
        case divisionOp:        ret = @"/";        break;
        case additionOp:        ret = @"+";        break;
        case subtractionOp:        ret = @"-";        break;

        case notOp:                ret = @"!";        break;
        case andOp:                ret = @"&&";    break;
        case orOp:                ret = @"||";    break;

        case equalOp:            ret = @"==";    break;
        case notIdenticalOp:    ret = @"!==";    break;
        case notEqualOp:        ret = @"!=";    break;
        case ltOp:                ret = @"<";        break;
        case gtOp:                ret = @">";        break;
        case ltEqualOp:            ret = @"<=";    break;
        case gtEqualOp:            ret = @">=";    break;

        case bitwiseAndOp:        ret = @"&";        break;
        case bitwiseNotOp:        ret = @"~";        break;
        case bitwiseOrOp:        ret = @"|";        break;
        case bitwiseXorOp:        ret = @"^|";    break;
        case shiftLeftOp:        ret = @"<<";    break;
        case shiftRightOp:        ret = @">>";    break;

        case conditionalOp:        ret = @"?";        break;
        case eitherOp:            ret = @":";        break;

        case assignOp:            ret = @"=";        break;
        case modulusAssignOp:    ret = @"%=";    break;
        case additionAssignOp:    ret = @"+=";    break;
        case subtractionAssignOp:ret = @"-=";    break;
        case multiplicationAssignOp:ret = @"*=";break;
        case divisionAssignOp:    ret = @"/=";    break;

        case postIncrementOp:    ret = @"p++";    break;
        case preIncrementOp:    ret = @"++p";    break;
        case postDecrementOp:    ret = @"p--";    break;
        case preDecrementOp:    ret = @"--p";    break;
    }

    return ret;
}

- (LXValue*) simplify
{
    //used by the negate operation; if the leftValue is simply a number, return that instead of using an operator
    if( op != negateOp ) return left;

    LXValue *ret = self;

    if( [left class]==[LXNumberValue class] )
    {
        //determine type, negate, and return.
        if( [left type]==numberType )    ret = [LXValue doubleValue:-([left doubleValue])];
    }

    return ret;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"(%@ %@ %@)",left, [self opToString], right];
}


//these methods help ease the creation of new operators
//by default, the functions will return nil
//except vectors, which are propogated out (a+{1,2,3} => {a+1, a+2, a+3}  {1,2} * {3,4} => {1*3, 2*4}

//so, for addition, the only methods that need to be replaced are:
// number and string combinations
// ALL number and number combinations
// and that's it!

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    if( [a type]==numberType ) return [self double:[a doubleValue] value:b];
    else if( [a type]==stringType ) return [self string:[a stringValue] value:b];
    else if( [a type]==vectorType ) return [self vector:[a vectorValue] value:b];
    return nil;
}

- (LXValue*) double:(double)a value:(LXValue*)b
{
    if( [b type]==numberType ) return [self double:a double:[b doubleValue]];
    else if( [b type]==stringType ) return [self double:a string:[b stringValue]];
    else if( [b type]==vectorType ) return [self double:a vector:[b vectorValue]];
    return nil;
}
- (LXValue*) string:(NSString*)a value:(LXValue*)b
{
    if( [b type]==numberType ) return [self string:a double:[b doubleValue]];
    else if( [b type]==stringType ) return [self string:a string:[b stringValue]];
    else if( [b type]==vectorType ) return [self string:a vector:[b vectorValue]];
    return nil;
}
- (LXValue*) vector:(NSArray*)a value:(LXValue*)b
{
    if( [b type]==numberType ) return [self vector:a double:[b doubleValue]];
    else if( [b type]==stringType ) return [self vector:a string:[b stringValue]];
    else if( [b type]==vectorType ) return [self vector:a vector:[b vectorValue]];
    return nil;
}


- (LXValue*) double:(double)a double:(double)b { return nil; }
- (LXValue*) double:(double)a string:(NSString*)b { return nil; }

- (LXValue*) double:(double)a vector:(NSArray*)b
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[b count]];
    NSEnumerator *ENUM = [b objectEnumerator];
    LXValue *curr;

    while( curr= [ENUM nextObject] )
    {
        [ret addObject: [self double:a value:curr]];
    }

    return [LXValue vectorValue:ret];
}

- (LXValue*) string:(NSString*)a double:(double)b { return nil; }
- (LXValue*) string:(NSString*)a string:(NSString*)b { return nil; }
- (LXValue*) string:(NSString*)a vector:(NSArray*)b
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[b count]];
    NSEnumerator *ENUM = [b objectEnumerator];
    LXValue *curr;

    while( curr= [ENUM nextObject] )
    {
        [ret addObject: [self string:a value:curr]];
    }

    return [LXValue vectorValue:ret];
}


- (LXValue*) vector:(NSArray*)a double:(double)b
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[a count]];
    NSEnumerator *ENUM = [a objectEnumerator];
    LXValue *curr;

    while( curr= [ENUM nextObject] )
    {
        if( [curr type]==numberType ) [ret addObject:[self double:[curr doubleValue] double:b]];
        else if( [curr type]==stringType ) [ret addObject:[self string:[curr stringValue] double:b]];
        else if( [curr type]==vectorType ) [ret addObject:[self vector:[curr vectorValue] double:b]];
    }

    return [LXValue vectorValue:ret];
}
- (LXValue*) vector:(NSArray*)a string:(NSString*)b
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[a count]];
    NSEnumerator *ENUM = [a objectEnumerator];
    LXValue *curr;

    while( curr= [ENUM nextObject] )
    {
        if( [curr type]==numberType ) [ret addObject:[self double:[curr doubleValue] string:b]];
        else if( [curr type]==stringType ) [ret addObject:[self string:[curr stringValue] string:b]];
        else if( [curr type]==vectorType ) [ret addObject:[self vector:[curr vectorValue] string:b]];
    }

    return [LXValue vectorValue:ret];
}
- (LXValue*) vector:(NSArray*)a vector:(NSArray*)b
{
    if( [a count] != [b count] ) return [LXError expected:@"Same number of items in both vectors"];

    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[a count]];

    NSEnumerator *aENUM = [a objectEnumerator];
    LXValue *acurr;
    NSEnumerator *bENUM = [b objectEnumerator];
    LXValue *bcurr;

    while( (acurr= [aENUM nextObject]) && (bcurr = [bENUM nextObject]) )
    {
        [ret addObject:[self value:acurr value:bcurr]];
    }

    return [LXValue vectorValue:ret];
}

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    //if the operation is unary, just return that value
    //otherwise, activate the operation
    id l = [left run:runtimeInfo];
    id r = [right run:runtimeInfo];

    id ret = [self value:l value:r];

    if( ret ) return ret;

    //nil has been returned
    //TODO: create an error value
    return nil;
}


@end
