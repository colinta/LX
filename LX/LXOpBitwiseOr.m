//
//  LXOpBitwiseOr.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"

@implementation LXOpBitwiseOr

- (LXValue*) double:(double)a double:(double)b
{
    return [LXValue doubleValue:((NSInteger)a | (NSInteger)b)];
}

@end
