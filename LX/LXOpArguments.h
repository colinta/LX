/*
 *  LXOpArguments.h
 *  LXCommand
 *
 *  Created by Colin Thomas-Arnold on 2/28/07.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "LXOperator.h"

@interface LXOpArguments : LXOperator
{
    LXValue *args;
    LXValue *code;
}

@end
