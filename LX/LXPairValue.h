//
//  LXPairValue.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXValue.h"

@interface LXPairValue : LXValue
{
    NSString *key;
    LXValue *val;
}

- (id) initWithKey:(NSString*)_key value:(LXValue*)_val;

- (NSString*) key;

- (void) setKey:(NSString*)value;

@end
