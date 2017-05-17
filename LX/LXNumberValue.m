//
//  LXIntValue.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月18日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXNumberValue.h"


@implementation LXNumberValue

- (lxtype) type { return type; }

- (id) init
{
    return [self initWithDouble:0];
}

- (id) initWithDouble:(double) value
{
    self = [super init];
    if( self )
    {
        type = numberType;
        doubleVal = value;
        numberVal = [[NSNumber alloc] initWithDouble:doubleVal];
    }
    return self;
}

- (double) doubleValue { return doubleVal; }
- (NSString*) stringValue { return [numberVal description]; }
- (NSNumber*) numberValue { return numberVal; }

- (NSString*) displayString:(NSString*)tabs
{
    return [numberVal description];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"(Number:%@)", numberVal];
}

@end
