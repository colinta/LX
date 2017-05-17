//
//  LXFormulaScanner.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月11日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXHeader.h"
#import "LXScanner.h"

@class LXValue;

@interface LXFormulaScanner : NSObject
{

}

+ (LXValue*) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner;
+ (LXValue*) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner upToOperator:(lxoperator)lowestOperator;

@end
