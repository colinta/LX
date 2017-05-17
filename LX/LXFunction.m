//
//  LXFunction.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/28/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXFunction.h"

@implementation LXFunction

+ (LXFunction*) function
{
    return [[self alloc] init];
}

- (void) setArguments:(LXValue*) value
{
    args = value;
}

- (void) setCodeBlock:(LXValue*) value
{
    code = value;
}

- (NSString*) displayString:(NSString*)tabs
{
    NSMutableString *ret = [NSMutableString string];

    [ret appendString:@"("];

    NSEnumerator *ENUM = [[args vectorValue] objectEnumerator];
    LXValue *curr;
    BOOL addComma = NO;
    while( curr = [ENUM nextObject] )
    {
        if( addComma )
            [ret appendString:@", "];
        [ret appendString:[curr displayString:tabs]];
        addComma = YES;
    }

    [ret appendString:@")"];

    return ret;
}

- (NSString*) description
{
    return @"LXFunction";
}

@end
