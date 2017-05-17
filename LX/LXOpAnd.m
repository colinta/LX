//
//  LXOpAnd.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"

@implementation LXOpAnd

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    return [LXValue boolValue:[a boolValue] && [b boolValue]];
}

@end
