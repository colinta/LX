//
//  LXRuntimeInfo.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXValue;

@interface LXRuntimeInfo : NSObject
{
    NSMutableArray *context;
    LXValue *currentContext;

    NSMutableString *outputString;
}

- (id) initWithVariableName:(NSString*)value;

- (void) pushContext:(LXValue*)value;
- (LXValue*) currentContext;
- (void) popContext;

- (NSString*) outputString;
- (void) appendString:(NSString*)value;

@end
