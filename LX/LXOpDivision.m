//
//  LXOpDivision.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXNumberScanner.h"

@implementation LXOpDivision

//  DDDD   BBB    L
//  D   D  B  B   L
//  D   D  BBBB   L
//  D   D  B   B  L
//  DDDD   BBBB   LLLLL
- (LXValue*) double:(double)a double:(double)b
{
    return [LXValue doubleValue:a / b];
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
- (LXValue*) string:(NSString*)a double:(double)b
{
    //chop the string into b number of pieces.
    NSUInteger i, max = [a length], len = (NSUInteger)ceil(max / b);
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:b];
    NSString *curr;
    NSRange currRange = NSMakeRange(0, len);

    for( i = len; i < max; i += len )
    {
        curr = [a substringWithRange:currRange];
        [ret addObject:[LXValue stringValue:curr]];

        currRange.location += len;
    }
    currRange.length = max - currRange.location;
    curr = [a substringWithRange:currRange];
    [ret addObject:[LXValue stringValue:curr]];

    return [LXValue vectorValue:ret];
}
- (LXValue*) string:(NSString*)a string:(NSString*)b
{
    //separate the string into pieces as delimited by b

    //"a b c d" / " " = {"a", "b", "c", "d"}
    return [LXValue vectorValue:[a componentsSeparatedByString:b]];
}


@end
