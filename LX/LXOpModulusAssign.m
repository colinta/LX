//
//  LXOpModulusAssign.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"


@implementation LXOpModulusAssign

- (id) initWithOp:(lxoperator)value
{
    self = [super initWithOp:value];
    if( self )
    {
        performOp = [LXOperator operator:modulusOp];
    }
    return self;
}

@end
