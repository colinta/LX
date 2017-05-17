//
//  LXValue.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月15日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXValue.h"
#import "LXNumberValue.h"
#import "LXStringValue.h"
#import "LXVectorValue.h"
#import "LXDataValue.h"
#import "LXPairValue.h"
#import "LXVariable.h"
#import "LXPlaceholder.h"

@implementation LXValue

+ (LXValue*) doubleValue:(double) value
{
    return [[LXNumberValue alloc] initWithDouble:value];
}
+ (LXValue*) boolValue:(BOOL) value
{
    return [[LXNumberValue alloc] initWithDouble:(value ? 1 : 0)];
}
+ (LXValue*) stringValue:(NSString*) value
{
    return [[LXStringValue alloc] initWithString:value];
}
+ (LXValue*) vectorValue:(NSArray*) value
{
    return [[LXVectorValue alloc] initWithArray:value];
}
+ (LXValue*) dataValue:(NSData*) value
{
    return [[LXDataValue alloc] initWithData:value];
}
+ (LXValue*) pairWithKey:(NSString*)_key value:(LXValue*)_val
{
    return [[LXPairValue alloc] initWithKey:_key value:_val];
}

- (void) setParent:(LXValue*) par { parent = par; }
- (LXValue*) childNamed:(LXValue*)value
{
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

    if( [strValue isEqualToString:@"type"] )
    {
        return [LXValue stringValue:[self typeToString]];
    }
    else if( [strValue isEqualToString:@"double"] )
    {
        return [LXValue doubleValue:[self doubleValue]];
    }
    else if( [strValue isEqualToString:@"string"] )
    {
        return [LXValue stringValue:[self stringValue]];
    }
    else if( [strValue isEqualToString:@"vector"] )
    {
        return [LXValue vectorValue:[self vectorValue]];
    }
    else if( [strValue isEqualToString:@"data"] )
    {
        return [LXValue dataValue:[self dataValue]];
    }

    return nil;
}

- (lxtype) type { return noType; }
- (NSString*) typeToString
{
    lxtype type = [self type];
    switch(type)
    {
    case numberType: return @"double";
    case stringType: return @"string";
    case vectorType: return @"vector";
    case objectType: return @"object";
    case pairType: return @"pair";
    case dataType: return @"data";
    case functionType: return @"function";
    case errorType: return @"error";
    }
    return @"nil";
}

- (NSInteger) intValue { return (NSInteger)[self doubleValue]; }
- (double) doubleValue { return [[self numberValue] doubleValue]; }
- (BOOL) boolValue { return [[self numberValue] boolValue]; }
- (NSNumber*) numberValue { return [NSDecimalNumber zero]; }
- (NSString*) stringValue { return @""; }
- (NSArray*) vectorValue { return [NSArray arrayWithObject:self]; }
- (NSData*) dataValue { return nil; }
- (LXObject*) objectValue { return nil; }
- (NSString*) variableName { return nil; }

- (void) setValue:(LXValue*) value { }
- (void) setDoubleValue:(double) value { }
- (void) setNumberValue:(NSNumber*) value { }
- (void) setStringValue:(NSString*) value { }
- (void) setVectorValue:(NSArray*) value { }
- (void) setObjectValue:(LXValue*) value { }
- (void) setDictionaryValue:(NSDictionary*) value { }
- (void) setDataValue:(NSData*) value { }
- (void) setArguments:(LXValue*) value { }
- (void) setCodeBlock:(LXValue*) value { }

- (NSString*) displayString { return [self displayString:@""]; }
- (NSString*) displayString:(NSString*)tabs { return @""; }

- (NSString*) description
{
    return @"LXValue";
}

+ (void) initialize
{
    static BOOL initialized = NO;
    if( initialized ) return;
    initialized = YES;
}

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    return self;
}

- (BOOL) isIdenticalTo:(LXValue*)value
{
    return NO;
}

- (BOOL) isNotEqualTo:(id)b
{
    return ! [self isEqualTo:b];
}

- (BOOL) isNotIdenticalTo:(LXValue*)b
{
    return ! [self isIdenticalTo:b];
}

- (LXValue*) arguments { return nil; }
- (LXValue*) codeBlock { return nil; }
@end
