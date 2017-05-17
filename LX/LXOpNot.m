//
//  LXOpNot.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXNumberScanner.h"

@implementation LXOpNot

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    //b should be nil
    return [LXValue boolValue:![a boolValue]];
}

@end
