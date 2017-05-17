//
//  LXVariable.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月15日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXValue.h"

@interface LXVariable : LXValue
{
    NSString *varName;
    BOOL constant;
    NSMutableDictionary *children;
    LXValue *val;

    //for functions
    NSArray *args;
    LXValue *code;
}

+ (LXVariable*) variableNamed:(NSString*)varName;
+ (LXVariable*) constantVariableNamed:(NSString*) varName;

- (id) initConstantWithName:(NSString*) value;
- (id) initWithName:(NSString*) value;

- (LXValue*) childNamed:(LXVariable*)value;
- (void) addChild:(LXVariable*) value;

@end

@interface LXVariable (LXVariableInitialize)
+ (void) initializeVariables:(NSMutableDictionary*)variables;
@end
