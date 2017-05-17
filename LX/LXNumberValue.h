//
//  LXNumberValue.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月18日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXValue.h"
#import "LXHeader.h"

@interface LXNumberValue : LXValue
{
    double doubleVal;
    NSNumber *numberVal;
    lxtype type;
}

- (id) initWithDouble:(double) value;

@end
