//
//  LXOpShiftRight.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXNumberScanner.h"

@implementation LXOpShiftRight

- (LXValue*) double:(double)a double:(double)b
{
    return [LXValue doubleValue:(NSInteger)a >> (NSInteger)b];
}
- (LXValue*) double:(double)a string:(NSString*)b
{
    LXValue *val = [LXNumberScanner scan:b usingScanner:nil];
    return [self double:a value:val];
}

- (LXValue*) string:(NSString*)a double:(double)b
{
    return [LXValue stringValue:[NSString stringWithFormat:@"%@%f", a, b]];
}
- (LXValue*) string:(NSString*)a string:(NSString*)b
{
    return [LXValue stringValue:[NSString stringWithFormat:@"%@%@", a, b]];
}


@end
