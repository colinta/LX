//
//  LXOpSubtractionAssign.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"


@implementation LXOpSubtractionAssign

- (id) initWithOp:(lxoperator)value
{
    self = [super initWithOp:value];
    if( self )
    {
        performOp = [LXOperator operator:subtractionOp];
    }
    return self;
}

@end
