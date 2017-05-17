//
//  LXOpConditional.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"

@implementation LXOpConditional

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    //if the operation is unary, just return that value
    //otherwise, activate the operation
    id ret = [self value:[left run:runtimeInfo] value:[right run:runtimeInfo]];

    if( ret ) return ret;

    //nil has been returned
    //TODO: create an error value
    return nil;
}

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    if( [b isKindOfClass:[LXOperator class]] && [(LXOperator*)b operator]==eitherOp )
    {
        return [a boolValue] ? [(LXOpEither*)b leftValue] : [(LXOpEither*)b rightValue];
    }
    return b; //LXERROR; eitherOp not found.  Operation ignored
}

@end
