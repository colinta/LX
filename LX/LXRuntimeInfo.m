//
//  LXRuntimeInfo.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXRuntimeInfo.h"
#import "LXValue.h"
#import "LXVariable.h"

@implementation LXRuntimeInfo

- (id) initWithVariableName:(NSString*)value
{
    self = [super init];
    if( self )
    {
        context = [[NSMutableArray alloc] initWithCapacity:11];
        [self pushContext:[LXVariable variableNamed:value]];
        outputString = [[NSMutableString alloc] initWithCapacity:1000];
    }
    return self;
}

- (void) pushContext:(LXValue*)value
{
    [context addObject:value];
    currentContext = value;
}

- (LXValue*) currentContext { return currentContext; }

- (void) popContext
{
    [context removeLastObject];
    currentContext = [context lastObject];
}

- (NSString*) outputString { return outputString; }

- (void) appendString:(NSString*)value
{
    [outputString appendString:value];
}

@end
