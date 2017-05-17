//
//  LXStringValue.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月18日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXStringValue.h"
#import "LXVariable.h"
#import "LXPlaceholder.h"
#import "LXNumberScanner.h"

@implementation LXStringValue

- (lxtype) type { return stringType; }

- (id) init
{
    return [self initWithString:@""];
}

- (id) initWithString:(NSString*)value
{
    self = [super init];
    if( self )
    {
        stringVal = [[NSString alloc] initWithString:value];
    }
    return self;
}

- (NSNumber*) numberValue { return [[LXNumberScanner scan:stringVal usingScanner:nil] numberValue]; }
- (BOOL) boolValue { return ([stringVal isEqualToString:@""] ? NO : YES); }
- (NSString*) stringValue { return stringVal; }

- (LXValue*) childNamed:(LXValue*)value
{
    if( [super childNamed:value] ) return [super childNamed:value];

    NSString *strValue;

    if( [value isKindOfClass:[LXStringValue class]] )
    {
        strValue = [(LXStringValue*)value stringValue];
    }
    else if( [value isKindOfClass:[LXVariable class]] )
    {
        strValue = [(LXVariable*)value variableName];
    }
    else if( [value isKindOfClass:[LXPlaceholder class]] )
    {
        strValue = [(LXPlaceholder*)value variableName];
    }
    else
    {
        return nil;
    }

    if( [strValue isEqualToString:@"length"] )
    {
        return [LXValue doubleValue:[stringVal length]];
    }

    return nil;
}

- (NSString*) displayString:(NSString*)tabs
{
    NSMutableString *ret = [NSMutableString stringWithCapacity:[stringVal length]+2];
    [ret setString:@"\""];

    unichar c;
    NSUInteger index = 0,
        length = [stringVal length];
    for( index = 0; index < length; index++ )
    {
        c = [stringVal characterAtIndex:index];
        switch(c)
        {
            case '\\':
            case '"':
                [ret appendString:@"\\"];
                break;

            case '\n':
            case '\r':
                [ret appendString:@"\\"];
                c = 'n';
                break;

            case '\t':
                [ret appendString:@"\\"];
                c = 't';
                break;
        }

        [ret appendFormat:@"%C",c];
    }
    [ret appendString:@"\""];

    return ret;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"\"%@\"", stringVal];
}

@end
