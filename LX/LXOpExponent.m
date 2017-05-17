//
//  LXOpExponent.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXNumberScanner.h"

#include <math.h>

@implementation LXOpExponent

//  DDDD   BBB    L
//  D   D  B  B   L
//  D   D  BBBB   L
//  D   D  B   B  L
//  DDDD   BBBB   LLLLL
- (LXValue*) double:(double)a double:(double)b
{
    return [LXValue doubleValue:pow(a, b)];
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

//same behaviour as *
- (LXValue*) string:(NSString*)a double:(double)_b
{
    NSInteger b = _b;
    NSMutableString *ret = [NSMutableString stringWithCapacity:[a length] * b];

    int i;
    for( i = 0; i < b; i++ )
    {
        [ret appendString:a];
    }

    return [LXValue stringValue:ret];
}

@end
