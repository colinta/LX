//
//  LXValue.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月15日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHeader.h"
#import "LXRuntimeInfo.h"

@class LXObject;

@interface LXValue : NSObject
{
    LXValue *parent;
}

+ (LXValue*) doubleValue:(double) value;
+ (LXValue*) boolValue:(BOOL) value;
+ (LXValue*) stringValue:(NSString*) value;
+ (LXValue*) vectorValue:(NSArray*) value;
+ (LXValue*) dataValue:(NSData*) value;
+ (LXValue*) pairWithKey:(NSString*)_key value:(LXValue*)_val;

- (void) setParent:(LXValue*) par;
- (LXValue*) childNamed:(LXValue*)value;

- (lxtype) type;
- (NSString*) typeToString;

- (NSInteger) intValue;
- (double) doubleValue;
- (BOOL) boolValue;
- (NSNumber*) numberValue;
- (NSString*) stringValue;
- (NSArray*) vectorValue;
- (NSData*) dataValue;
- (LXObject*) objectValue;
- (NSString*) variableName;

- (void) setValue:(LXValue*)value; //used by assignment operators to do their assignment

- (void) setDoubleValue:(double) value;
- (void) setNumberValue:(NSNumber*) value;
- (void) setStringValue:(NSString*) value;
- (void) setVectorValue:(NSArray*) value;
- (void) setDataValue:(NSData*) value;
- (void) setObjectValue:(LXValue*) value;

//for functions
- (LXValue*) arguments;
- (LXValue*) codeBlock;
- (void) setArguments:(LXValue*) value;
- (void) setCodeBlock:(LXValue*) value;

- (NSString*) displayString;
- (NSString*) displayString:(NSString*)tabs;
- (LXValue*) run:(LXRuntimeInfo*)runtimeInfo;

- (BOOL) isIdenticalTo:(LXValue*)value;
- (BOOL) isNotIdenticalTo:(LXValue*)b;
@end
