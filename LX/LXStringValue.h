//
//  LXStringValue.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月18日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXValue.h"
#import "LXHeader.h"

@interface LXStringValue : LXValue
{
    NSString *stringVal;
}

- (id) initWithString:(NSString*)value;

@end
