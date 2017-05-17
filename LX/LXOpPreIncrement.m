//
//  LXOpPreIncrement.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"


@implementation LXOpPreIncrement

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    //b needs to be assigned to a, if it can contain a mutable value.
    return a;
}

@end
