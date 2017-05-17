//
//  LXOpVariable.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/28/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"


@implementation LXOpVariable

- (id) initWithOp:(lxoperator) value
{
    self = [super initWithOp:value];
    if( self )
    {
        args = nil;
        code = nil;
    }
    return self;
}

- (void) setArguments:(LXValue*) value
{
    args = value;
}

- (void) setCodeBlock:(LXValue*) value
{
    code = value;
}

@end
