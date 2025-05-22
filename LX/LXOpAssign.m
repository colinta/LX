//
//  LXOpAssign.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXPairValue.h"

@implementation LXOpAssign

- (id) initWithOp:(lxoperator)value
{
    self = [super initWithOp:value];
    if( self )
    {
        performOp = nil;
    }
    return self;
}

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    //if the operation is unary, just return that value
    //otherwise, activate the operation
    id l = [left run:runtimeInfo];
    id r = [right run:runtimeInfo];

    //this method takes care of ALL the assign ops by using the performOp variable
    //if defined, it is used to create the value to be stored.
    if( performOp )
    {
        r = [performOp value:l value:r];
    }

    [(LXPairValue*)l setValue:r];

    return r;
}

@end
