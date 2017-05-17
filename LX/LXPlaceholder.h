//
//  LXPlaceholder.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月15日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXValue.h"

@interface LXPlaceholder : LXValue
{
    NSString *varName;

    //for functions
    LXValue *args;
    LXValue *code;
}

+ (LXPlaceholder*) variableNamed:(NSString*)varName;

- (id) initWithName:(NSString*) value;

- (void) setArguments:(LXValue*) value;
- (void) setCodeBlock:(LXValue*) value;

@end
