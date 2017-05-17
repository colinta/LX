//
//  LXError.h
//  LXCommand
//
//  Created by tyke on 12月12日06年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXValue.h"

@interface LXError : LXValue
{
    NSString *errorDescription;
}

- (id) initWithDescription:(NSString*)value;

+ (LXError*) expected:(NSString*)value;

@end
