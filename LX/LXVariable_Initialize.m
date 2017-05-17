//
//  LXVariable.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2月27日2007年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXVariable.h"
#import "LXFns.h"

@implementation LXVariable (LXVariableInitialize)

+ (void) initializeVariables:(NSMutableDictionary*)variables
{
    LXVariable *var;

    //pi
    NSString *pi = [NSString stringWithFormat:@"%C", (unichar)0x03c0]; //π
    var = [[LXVariable alloc] initConstantWithName:pi];
    [var setValue:[LXValue doubleValue:M_PI]];
    [variables setObject:var forKey:pi];
    [variables setObject:var forKey:@"pi"];
    [variables setObject:var forKey:@"PI"];
    [variables setObject:var forKey:@"Pi"];

    //e
    var = [[LXVariable alloc] initConstantWithName:@"e"];
    [var setValue:[LXValue doubleValue:M_E]];
    [variables setObject:var forKey:@"e"];
    [variables setObject:var forKey:@"E"];

    //true, false
    var = [[LXVariable alloc] initConstantWithName:@"true"];
    [var setValue:[LXValue boolValue:YES]];
    [variables setObject:var forKey:@"true"];
    [variables setObject:var forKey:@"TRUE"];
    [variables setObject:var forKey:@"yes"];
    [variables setObject:var forKey:@"YES"];

    var = [[LXVariable alloc] initConstantWithName:@"false"];
    [var setValue:[LXValue boolValue:NO]];
    [variables setObject:var forKey:@"false"];
    [variables setObject:var forKey:@"FALSE"];
    [variables setObject:var forKey:@"no"];
    [variables setObject:var forKey:@"NO"];

    //TODO: initialize reserved words (if, for, while, ...)

    //this is where ALL the function objects are created, like if, while, for, sin, etc.
    var = [[LXVariable alloc] initConstantWithName:@"print"];
    [var setValue:[LXFnPrint function]];
    [variables setObject:var forKey:@"print"];
    /*
    [LXVariable setConstantValue:[LXFunction newIfFunction] forVariableName:@"if"];
    [LXVariable setConstantValue:[LXFunction newWhileFunction] forVariableName:@"while"];
    [LXVariable setConstantValue:[LXFunction newDoFunction] forVariableName:@"do"];
    [LXVariable setConstantValue:[LXFunction newForFunction] forVariableName:@"for"];
    [LXVariable setConstantValue:[LXFunction newSwitchFunction] forVariableName:@"switch"];
    [LXVariable setConstantValue:[LXFunction newTryFunction] forVariableName:@"try"];

    [LXVariable setConstantValue:[LXFunction newSinFunction] forVariableName:@"sin"];
    [LXVariable setConstantValue:[LXFunction newCosFunction] forVariableName:@"cos"];
    [LXVariable setConstantValue:[LXFunction newTanFunction] forVariableName:@"tan"];
    [LXVariable setConstantValue:[LXFunction newArcsinFunction] forVariableName:@"arcsin"];
    [LXVariable setConstantValue:[LXFunction newArccosFunction] forVariableName:@"arccos"];
    [LXVariable setConstantValue:[LXFunction newArctanFunction] forVariableName:@"arctan"];
    */
}

@end
