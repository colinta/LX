//
//  LXOpIdentical.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"

@implementation LXOpIdentical

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    return [LXValue boolValue:[a isIdenticalTo:b]];
}

@end
