//
//  LXOpSeries.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"

#include "stdlib.h"

@implementation LXOpSeries

- (LXValue*) double:(double)a double:(double)b
{
    int i;
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity: abs(a-b) + 1];

    if( a <= b )
    {
        for(i = a; i <= b; i++ )
        {
            [ret addObject:[LXValue doubleValue:i]];
        }
    }
    else if( a > b )
    {
        for(i = a; i >= b; i-- )
        {
            [ret addObject:[LXValue doubleValue:i]];
        }
    }

    return [LXValue vectorValue:ret];
}

@end
