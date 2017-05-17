//
//  LXOperator.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月20日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXHeader.h"
#import "LXValue.h"

@interface LXOperator : LXValue
{
    LXValue *left;
    LXValue *right;
    lxoperator op;
    id runtime;
}

+ (LXOperator*) operator:(lxoperator)op;
+ (BOOL) compare:(lxoperator)left isLessThan:(lxoperator)right;
+ (lxoperator) rightOrder:(lxoperator)value;

- (id) initWithOp:(lxoperator)value;
- (lxoperator) operator;

- (LXValue*) leftValue;
- (LXValue*) rightValue;
- (void) setLeftValue:(LXValue*) value;
- (void) setRightValue:(LXValue*) value;

//used in conjunction with the negate operator to return a negative number.
- (LXValue*) simplify;

//used only for debugging purposes
- (NSString*) opToString;

//convenience methods.  called from - (LXValue*) run:
- (LXValue*) value:(LXValue*)a value:(LXValue*)b;

- (LXValue*) double:(double)a value:(LXValue*)b;
- (LXValue*) string:(NSString*)a value:(LXValue*)b;
- (LXValue*) vector:(NSArray*)a value:(LXValue*)b;

- (LXValue*) double:(double)a double:(double)b;
- (LXValue*) double:(double)a string:(NSString*)b;
- (LXValue*) double:(double)a vector:(NSArray*)b;

- (LXValue*) string:(NSString*)a double:(double)b;
- (LXValue*) string:(NSString*)a string:(NSString*)b;
- (LXValue*) string:(NSString*)a vector:(NSArray*)b;

- (LXValue*) vector:(NSArray*)a double:(double)b;
- (LXValue*) vector:(NSArray*)a string:(NSString*)b;
- (LXValue*) vector:(NSArray*)a vector:(NSArray*)b;

@end
