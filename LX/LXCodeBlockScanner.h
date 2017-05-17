//
//  LXCodeBlockScanner.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月11日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXScanner.h"
#import "LXValue.h"
#import "LXCodeBlock.h"

@interface LXCodeBlockScanner : NSObject
{
}

+ (LXCodeBlock*) scan:(NSString*) inputText usingScanner:(LXScanner*)scanner;
@end
