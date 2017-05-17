//
//  LXVectorValue.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月19日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXVectorValue.h"
#import "LXStringValue.h"
#import "LXVariable.h"
#import "LXPlaceholder.h"

@implementation LXVectorValue

- (lxtype) type { return vectorType; }

- (id) initWithArray:(NSArray*)value
{
    self = [super init];
    if( self )
    {
        vectorVal = [[NSMutableArray alloc] initWithArray:value];
    }
    return self;
}

- (double) doubleValue { return 0.0; }
- (NSString*) stringValue { return @"Vector"; }
- (NSArray*) vectorValue { return vectorVal; }

- (LXValue*) childNamed:(LXValue*)value
{
    if( [super childNamed:value] ) return [super childNamed:value];

    NSString *strValue;

    if( [value isKindOfClass:[LXStringValue class]] )
    {
        strValue = [(LXStringValue*)value stringValue];
    }
    else if( [value isKindOfClass:[LXVariable class]] )
    {
        strValue = [(LXVariable*)value variableName];
    }
    else if( [value isKindOfClass:[LXPlaceholder class]] )
    {
        strValue = [(LXPlaceholder*)value variableName];
    }
    else
    {
        return nil;
    }

    if( [strValue isEqualToString:@"length"] )
    {
        return [LXValue doubleValue:[vectorVal count]];
    }

    return nil;
}

- (NSString*) displayString:(NSString*)tabs
{
    NSMutableString *ret = [NSMutableString string];

    [ret appendString:@"["];

    NSEnumerator *ENUM = [vectorVal objectEnumerator];
    LXValue *curr;
    BOOL addComma = NO;
    while( curr = [ENUM nextObject] )
    {
        if( addComma )
            [ret appendString:@", "];
        [ret appendString:[curr displayString:tabs]];
        addComma = YES;
    }

    [ret appendString:@"]"];

    return ret;
}

- (NSString*) description
{
    NSMutableString *ret = [NSMutableString stringWithString:@"(Vector:[\n"];

    NSEnumerator *ENUM = [vectorVal objectEnumerator];
    LXValue *curr;
    while( curr = [ENUM nextObject] )
    {
        [ret appendString:@"\t"];
        [ret appendString:[curr description]];
        [ret appendString:@",\n"];
    }

    [ret appendString:@"])"];

    return ret;
}

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[vectorVal count]];
    NSEnumerator *ENUM = [vectorVal objectEnumerator];
    LXValue *curr;
    while( curr = [ENUM nextObject] )
    {
        [ret addObject:[curr run:runtimeInfo]];
    }

    return [LXValue vectorValue:ret];
}

@end
