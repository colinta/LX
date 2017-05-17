//
//  LXOpLessThan.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"

@implementation LXOpLessThan

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    return [LXValue boolValue:[a isLessThan:b]];
}

@end
