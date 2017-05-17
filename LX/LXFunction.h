//
//  LXFunction.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/28/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXValue.h"

@interface LXFunction : LXValue
{
    LXValue *args;
    LXValue *code;
}

+ (LXFunction*) function;

- (void) setArguments:(LXValue*) value;
- (void) setCodeBlock:(LXValue*) value;

@end
