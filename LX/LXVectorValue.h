//
//  LXVectorValue.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月19日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXValue.h"

@interface LXVectorValue : LXValue
{
    NSMutableArray *vectorVal;
}

- (id) initWithArray:(NSArray*)value;

@end
