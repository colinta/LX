//
//  LXOpBitwiseNot.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"


@implementation LXOpBitwiseNot

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    //b should be nil
    if( [a type]==numberType ) return [LXValue doubleValue:~(NSInteger)[a doubleValue]];

    return nil;
}

@end
