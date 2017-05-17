//
//  LXCodeBlock.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月11日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXValue.h"

@interface LXCodeBlock : LXValue
{
    NSArray *_commands;
}

+ (LXCodeBlock*) codeBlockWithCommands:(NSArray*)commands;

- (id) initWithCommands:(NSArray*)commands;
- (LXValue*) run;

- (NSString*) displayString;

@end
