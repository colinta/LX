//
//  LXPairValue.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXPairValue.h"
#import "LXStringValue.h"
#import "LXVariable.h"
#import "LXPlaceholder.h"

@implementation LXPairValue

- (id) initWithKey:(NSString*)_key value:(LXValue*)_val
{
    self = [super init];
    if( self )
    {
        key = nil;
        val = nil;
        [self setKey:_key];
        [self setValue:_val];
    }
    return self;
}

- (NSString*) key { return key; }
- (void) setKey:(NSString*)value
{
    key = value;
}

- (LXValue*) value { return val; }
- (void) setValue:(LXValue*)value
{
    val = value;
}

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

    if( [strValue isEqualToString:@"key"] )
    {
        return [LXValue stringValue:key];
    }
    else if( [strValue isEqualToString:@"value"] )
    {
        return val;
    }

    return nil;
}

- (lxtype) type { return pairType; }

- (double) doubleValue { return [val doubleValue]; }
- (BOOL) boolValue { return [val boolValue]; }
- (NSNumber*) numberValue { return [val numberValue]; }
- (NSString*) stringValue { return [val stringValue]; }
- (NSArray*) vectorValue { return [NSArray arrayWithObjects:[LXValue stringValue:key], val, nil]; }
- (NSData*) dataValue { return [val dataValue]; }
- (LXObject*) objectValue { return nil; }
- (NSDictionary*) dictionaryValue { return [NSDictionary dictionaryWithObjectsAndKeys:[LXValue stringValue:key], @"key", val, @"value", nil]; }
- (NSString*) variableName { return key; }

- (NSString*) displayString:(NSString*)tabs
{
    return [NSString stringWithFormat:@"(%@ => %@)", key, [val displayString:tabs]];
}

@end
