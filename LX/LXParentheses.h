//
//  LXParentheses.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月20日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXValue.h"

@interface LXParentheses : LXValue
{
    LXValue *inside;
}

+ (LXParentheses*) value:(LXValue*)value;

- (void) setInside:(LXValue*) value;

@end
