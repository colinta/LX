//
//  LXPlaceholder.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2月27日2007年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXPlaceholder.h"
#import "LXScanner.h"

@implementation LXPlaceholder

+ (LXPlaceholder*) variableNamed:(NSString*) varName
{
    //simply returns a placeholder with the given name.
    //the actual variable will be determined later.
    LXPlaceholder *ret = [[LXPlaceholder alloc] initWithName:varName];

    return ret;
}

- (id) initWithName:(NSString*) value
{
    self = [super init];
    if( self )
    {
        varName = [[NSString alloc] initWithString:value];
        args = nil;
        code = nil;
    }
    return self;
}

- (void) setArguments:(LXValue*) value
{
    args = value;
}

- (void) setCodeBlock:(LXValue*) value
{
    code = value;
}

- (lxtype) type { return placeholderType; }

- (NSString*) variableName { return varName; }

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

    LXValue *ret = [[runtimeInfo currentContext] childNamed:self];
    if( ret )
    {
        return ret;
    }

    return self;
}

- (NSString*) displayString:(NSString*)tabs
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

    return ret;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"(Placeholder:%@)", varName];
}

@end
