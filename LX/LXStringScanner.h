//
//  LXStringScanner.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月18日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXScanner.h"

@class LXValue;

@interface LXStringScanner : NSObject
{

}

+ (LXValue*) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner;

@end
