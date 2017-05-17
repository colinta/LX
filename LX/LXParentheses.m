//
//  LXParentheses.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月20日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXParentheses.h"


@implementation LXParentheses

+ (LXParentheses*) value:(LXValue*) value
{
    LXParentheses *ret = [[LXParentheses alloc] init];
    [ret setInside:value];

    return ret;
}

- (id) init
{
    self = [super init];
    if( self )
    {
        inside = nil;
    }
    return self;
}

- (void) setInside:(LXValue*) value
{
    inside = value;
}

- (NSString*) displayString:(NSString*)tabs
{
    NSMutableString *ret = [NSMutableString string];
    [ret appendString:@"("];
    [ret appendString:[inside displayString:tabs]];
    [ret appendString:@")"];
    return ret;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"(%@)", inside];
}

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    return [inside run:runtimeInfo];
}

@end
