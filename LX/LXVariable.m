//
//  LXVariable.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月15日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXVariable.h"
#import "LXScanner.h"

static NSMutableDictionary *variables = nil;

@implementation LXVariable

+ (void) initialize
{
    if( self==[LXVariable class] )
    {
        variables = [[NSMutableDictionary alloc] initWithCapacity:1000];

        //refer to LXVariable_Initialize.m for this method
        [self initializeVariables:variables];
    }
}

+ (LXVariable*) variableNamed:(NSString*) varName
{
    //simply returns a placeholder with the given name.
    //the actual variable will be determined later.
    LXVariable *ret = [[LXVariable alloc] initWithName:varName];

    return ret;
}

+ (LXVariable*) constantVariableNamed:(NSString*) varName
{
    //TODO: check for reserved words
    LXVariable *ret = [[LXVariable alloc] initConstantWithName:varName];

    return ret;
}

- (id) initConstantWithName:(NSString*) value
{
    self = [super init];
    if( self )
    {
        varName = [value copy];
        constant = YES;
        val = nil;
    }
    return self;
}

- (id) initWithName:(NSString*) value
{
    self = [super init];
    if( self )
    {
        varName = [value copy];
        children = [[NSMutableDictionary alloc] initWithCapacity:100];
        constant = NO;
        val = [LXValue doubleValue:0]; //[LXValue noValue];
    }
    return self;
}

- (void) setValue:(LXValue*) value
{
    //TODO: alert observers
    //a constant is allowed to be set, but just once
    //a non-constant can be changed.

    if( !val || !constant )
    {
        val = value;
    }
}

- (lxtype) type { return [val type]; }
- (double) doubleValue { return [val doubleValue]; }
- (BOOL) boolValue { return [val boolValue]; }
- (NSNumber*) numberValue { return [val numberValue]; }
- (NSString*) stringValue { return [val stringValue]; }
- (NSArray*) vectorValue { return [val vectorValue]; }
- (NSData*) dataValue { return [val dataValue]; }
- (LXObject*) objectValue { return [val objectValue]; }

- (NSString*) variableName { return varName; }

//childNamed: is usually called during a run: command by a placeholder.
- (LXValue*) childNamed:(LXVariable*)value
{
    id ret = nil;
    if( [[value variableName] isEqualToString:@"self"] ) return self;
    //if( [[value variableName] isEqualToString:@"super"] ) return the parent context;

    if( (ret = [variables objectForKey:[value variableName]]) ) return ret;
    if( (ret = [children objectForKey:[value variableName]]) ) return ret;

    //the variable is not in the current context.  Return a new child
    ret = [LXVariable variableNamed:[value variableName]];
    [self addChild:ret];
    return ret;
}

- (void) addChild:(LXVariable*)value
{
    [children setObject:value forKey:[value variableName]];
    [value setParent:self];
}

- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo
{
    /********************************************************
    //take this opportunity to determine what variable varName refers to.
    //either a global or a variable (old or new) within context
    //if run: is called from a dotOp, runtimeInfo already contains the correct context
    //same scenario for a function or object method.  runtimeInfo contains the most current context
    //so always get/set the variable value from the context
    //the exception is if the variable is contained in variables; then use that value.
    //also, the context ladder should be queried to determine whether or not the variable name has been set as static;
    //it should show up in the context ladder sometime.
    *********************************************************/
    NSLog(@"this should never be run - do it from LXPlaceholder.");
    LXValue *ret = [[runtimeInfo currentContext] childNamed:self];
    if( ret )
    {
        return ret;
    }

    return self;
}

- (NSString*) displayString:(NSString*)tabs
{
    return [val displayString:tabs];
}

- (NSString*) description
{
    //is the first letter a letter, and are the rest letters or numbers?
    //if so, don't use brackets.  in all other cases they are necessary.
    unichar c = [varName characterAtIndex:0];
    NSRange loc;
    BOOL useBrackets = YES;

    if( [[NSCharacterSet letterSet] characterIsMember:c] )
    {
        loc = [varName rangeOfCharacterFromSet:[NSCharacterSet letterAndNumberInvertedSet]];

        if( loc.location==NSNotFound )
        {
            useBrackets = NO;
        }
    }

    NSString *ret;

    if( useBrackets )
    {
        ret = [NSString stringWithFormat:@"<%@>", varName];
    }
    else
    {
        ret = [NSString stringWithFormat:@"%@", varName];
    }

    return [NSString stringWithFormat:@"(VarName:%@%@)", ret, (val ? [NSString stringWithFormat:@" = %@", val] : @"")];
}

@end
