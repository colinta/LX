//
//  LXOpAddition.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXNumberScanner.h"

@implementation LXOpAddition

//  DDDD   BBB    L
//  D   D  B  B   L
//  D   D  BBBB   L
//  D   D  B   B  L
//  DDDD   BBBB   LLLLL
- (LXValue*) double:(double)a double:(double)b
{
    return [LXValue doubleValue:a + b];
}
- (LXValue*) double:(double)a string:(NSString*)b
{
    LXValue *val = [LXNumberScanner scan:b usingScanner:nil];
    return [self double:a value:val];
}

//   SSS  TTTTT  RRRR
//  S       T    R   R
//   SS     T    RRRR
//     S    T    R  R
//  SSSS    T    R   R
- (LXValue*) string:(NSString*)a value:(LXValue*)b
{
    return [self string:a string:[b stringValue]];
}

- (LXValue*) string:(NSString*)a string:(NSString*)b
{
    return [LXValue stringValue:[NSString stringWithFormat:@"%@%@", a, b]];
}


@end
