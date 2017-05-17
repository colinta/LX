//
//  LXDataValue.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/27/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXValue.h"

@interface LXDataValue : LXValue
{
    NSData *dataVal;
}

- (id) initWithData:(NSData*)value;

@end
