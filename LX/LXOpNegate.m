//
//  LXOpNegate.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"
#import "LXNumberScanner.h"

@implementation LXOpNegate

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    //b should be nil
    if( [a type]==numberType ) return [LXValue doubleValue:-[a doubleValue]];
    else if( [a type]==stringType )
    {
        NSString *str = [a stringValue];
        NSInteger i;
        NSUInteger max = [str length];
        NSMutableString *ret = [NSMutableString stringWithCapacity:max];
        for( i = max - 1; i >= 0; i-- )
        {
            [ret appendString:[str substringWithRange:NSMakeRange(i,1)]];
        }
        return [LXValue stringValue:ret];
    }

    return nil;
}

@end
