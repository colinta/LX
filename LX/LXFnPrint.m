//
//  LXFnPrint.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/28/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXFns.h"
#import "LXVectorValue.h"

@implementation LXFnPrint

+ (LXFunction*) function
{
    return [[LXFnPrint alloc] init];
}

- (LXValue*) run:runtimeInfo
{
    if( [args isKindOfClass:[LXVectorValue class]] )
    {
        NSEnumerator *ENUM = [[args vectorValue] objectEnumerator];
        LXValue *curr;

        while( curr = [ENUM nextObject] )
        {
            [runtimeInfo appendString:[curr stringValue]];
        }
    }
    else
    {
        [runtimeInfo appendString:[args stringValue]];
    }

    return self;
}
@end
