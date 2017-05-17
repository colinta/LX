//
//  LXCodeBlock.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月11日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXCodeBlock.h"

@implementation LXCodeBlock

+ (LXCodeBlock*) codeBlockWithCommands:(NSArray*)commands
{
    LXCodeBlock *ret = [[LXCodeBlock alloc] initWithCommands:commands];
    return ret;
}

- (id) init
{
    self = [super init];
    if( self )
    {
        _commands = nil;
    }
    return self;
}

- (id) initWithCommands:(NSArray*)commands
{
    self = [super init];
    if( self )
    {
        _commands = [[NSArray alloc] initWithArray:commands];
    }
    return self;
}

- (LXValue*) run
{
    //prepare blank runTimeInfo
    //'blank' means context variable is '_'
    //error -> nil;
    //caughtError -> nil;
    LXRuntimeInfo *runtime = [[LXRuntimeInfo alloc] initWithVariableName:@"_"];
    return [self run:runtime];
}

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    LXValue *ret;
    LXValue *currCommand;
    NSEnumerator *ENUM = [_commands objectEnumerator];

    while( currCommand = [ENUM nextObject] )
    {
        ret = [currCommand run:runtimeInfo];
        //TODO: collect errors and pass them back up
        //hopefully a try() function will catch it and pass it on as a caughtError

        //check runtimeInfo for a return value, and pop-return it if it exists
    }

    if (ret) {
        return ret;
    }
    else {
        return [runtimeInfo currentContext];
    }
}

- (NSString*) displayString { return [[self displayString:@""] stringByAppendingString:@"\n"]; }

- (NSString*) displayString:(NSString*)tabs
{
    NSMutableString *ret = [NSMutableString stringWithFormat:@"%@{\n",tabs];
    NSString *newtabs = [tabs stringByAppendingString:@"\t"];

    id currCommand;
    NSEnumerator *ENUM = [_commands objectEnumerator];
    while( currCommand = [ENUM nextObject] )
    {
        [ret appendString:newtabs];
        [ret appendString:[currCommand displayString:newtabs]];
        [ret appendString:@"\n"];
    }

    [ret appendFormat:@"%@}",tabs];

    return ret;
}

- (NSString*) description
{
    NSMutableString *ret = [NSMutableString stringWithString:@"(CodeBlock:\n{"];

    id currCommand;
    NSEnumerator *ENUM = [_commands objectEnumerator];
    while( currCommand = [ENUM nextObject] )
    {
        [ret appendString:@"\t"];
        [ret appendString:[currCommand description]];
        [ret appendString:@"\n"];
    }

    [ret appendString:@"})"];
    return ret;
}

@end
