//
//  LXOpDot.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXVariable.h"

@implementation LXOpDot

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    //a dot operation is a little different;
    //it runs the left value, but then uses that value as the current Context.

    //don't forget to get rid of it when done (pop the context)

    //the neat thing is that if left is a dotOp, it will automatically do this same method, ultimately getting a single value from the context;
    // a.b.c -> (((context.a).b).c)
    //so only a is derived directly from the context.
    //or even:
    // ["one"=>1].one.type -> ((["one"=>1].one).type) = numberType

    LXValue *l = [left run:runtimeInfo];

    [runtimeInfo pushContext:l];
    id ret = [l childNamed:[right run:runtimeInfo]];
    [runtimeInfo popContext];

    if( ret ) return ret;

    //nil has been returned
    //TODO: create an error value
    return nil;
}

@end
