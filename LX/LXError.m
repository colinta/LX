//
//  LXError.m
//  LXCommand
//
//  Created by tyke on 12月12日06年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXError.h"


@implementation LXError

- (id) initWithDescription:(NSString*)value
{
    self = [super init];
    if( self )
    {
        errorDescription = [[NSString alloc] initWithString:value];
    }
    return self;
}

+ (LXError*) expected:(NSString*)value
{
    return [[LXError alloc] initWithDescription:value];
}

- (NSString*) displayString:(NSString*)tabs
{
    return errorDescription;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"(Error: %@)", errorDescription];
}

@end
