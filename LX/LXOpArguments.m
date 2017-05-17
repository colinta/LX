//
//  LXOpArguments.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/28/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOpArguments.h"

@implementation LXOpArguments

- (id) initWithOp:(lxoperator)value
{
    self = [super initWithOp:value];
    if( self )
    {
        args = nil;
        code = nil;
    }
    return self;
}

- (LXValue*) arguments { return args; }
- (LXValue*) codeBlock { return code; }

- (void) setArguments:(LXValue*) value
{
    args = value;
}

- (void) setCodeBlock:(LXValue*) value
{
    code = value;
}

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    //a function operation takes the arguments and codeBlock and runs them against
    //the variable name to the left, if it contains a function
    LXValue *l = [left run:runtimeInfo];

//    l = [l value];

    [l setArguments:[args run:runtimeInfo]];
    [l setCodeBlock:[code run:runtimeInfo]];
    id ret = [l run:runtimeInfo];

    if( ret ) return ret;

    //nil has been returned
    //TODO: create an error value
    return nil;
}

- (NSString*) displayString:(NSString*)tabs
{
    NSMutableString *ret = [NSMutableString string];
    [ret appendString:[left displayString:tabs]];

    if( [self arguments] )
    {
        [ret appendString:@"("];
        [ret appendString:[[self arguments] displayString:tabs]];
        [ret appendString:@")"];
    }

    if( [self codeBlock] )
    {
        [ret appendString:@"\n"];
        [ret appendString:[[self codeBlock] displayString:tabs]];
    }

    return ret;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"(Args: %@ %@ %@})",left, args, code];
}

@end
