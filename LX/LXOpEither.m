//
//  LXOpEither.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"

@implementation LXOpEither

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    id ret = [LXOperator operator:eitherOp];
    [ret setLeftValue:a];
    [ret setRightValue:b];

    return ret;
}

- (lxtype) type { return [left type]; }
- (double) doubleValue { return [left doubleValue]; }
- (BOOL) boolValue { return [left boolValue]; }
- (NSNumber*) numberValue { return [left numberValue]; }
- (NSString*) stringValue { return [left stringValue]; }
- (NSArray*) vectorValue { return [left vectorValue]; }
- (NSData*) dataValue { return [left dataValue]; }
- (LXObject*) objectValue { return [left objectValue]; }
- (NSString*) variableName { return [left variableName]; }

@end
