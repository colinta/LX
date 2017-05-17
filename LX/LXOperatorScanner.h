//
//  LXOperatorScanner.h
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXHeader.h"
#import "LXScanner.h"

@interface LXOperatorScanner : NSObject
{

}

+ (lxoperator) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner;

@end
