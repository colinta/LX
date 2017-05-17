//
//  LXDataValue.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXDataValue.h"


@implementation LXDataValue

- (id) initWithData:(NSData*)value
{
    self = [super init];
    if( self )
    {
        dataVal = [[NSData alloc] initWithData:value];
    }
    return self;
}

- (NSString*) displayString:(NSString*)tabs
{
    NSMutableString *ret = [NSMutableString string];

    [ret appendString:@"<<\n\t"];

    NSUInteger i, max = [dataVal length];
    NSRange range = NSMakeRange(0, 1);

    void *p = NULL;
    for( i = 0; i < max; i++ )
    {
        range.location = i;

        [dataVal getBytes:p range:range];
        [ret appendFormat:@"%p ", p];
        if( (i % 16 == 15) && (i+1 < max) )
            [ret appendString:@"\n\t"];
    }

    [ret appendString:@"\n>>"];

    return ret;
}

- (NSString*) description
{
    NSMutableString *ret = [NSMutableString stringWithString:@"(Data: <<"];

    NSUInteger i, max = [dataVal length];
    NSRange range = NSMakeRange(0, 1);

    void *p = NULL;
    for( i = 0; i < max; i++ )
    {
        range.location = i;

        [dataVal getBytes:p range:range];
        [ret appendFormat:@"%p ", p];
    }

    [ret appendString:@">>)"];

    return ret;
}

@end
