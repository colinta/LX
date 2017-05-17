//
//  LXOpSubtraction.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXNumberScanner.h"

@implementation LXOpSubtraction

- (LXValue*) double:(double)a double:(double)b
{
    return [LXValue doubleValue:a - b];
}
- (LXValue*) double:(double)a string:(NSString*)b
{
    LXValue *val = [LXNumberScanner scan:b usingScanner:nil];
    return [self double:a value:val];
}

@end
