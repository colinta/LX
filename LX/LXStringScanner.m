//
//  LXStringScanner.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月18日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXStringScanner.h"
#import "LXValue.h"
#import "LXError.h"

@implementation LXStringScanner

+ (LXValue*) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner
{
    NSMutableString *ret = [NSMutableString string];

    //prepare the scanner
    if( scanner==nil )
    {
        scanner = [LXScanner scannerWithString:inputText];
    }

    //set the style
    [scanner pushStyle:[LXScanner stringStyle]];

    unichar closer = '"';
    NSString *closerStr = @"\"";

    if( ![scanner scanString:@"\""] )
    {
        [scanner popStyle]; //clear the stringStyle

        [scanner pushStyle:[LXScanner errorStyle]];
        [scanner scanUpToString:@"\n"];
        [scanner popStyle];
        return [LXError expected:@"String delimiter (\") expected."];
    }

    //now, scan through the characters in the string
    // \* -> * character, keep scanning
    // " (closer) -> stop scanning
    unichar c = '\0';
    BOOL slash = NO;
    NSString *append;

    NSUInteger index = [scanner scanLocation],
        max = [inputText length];
    while( c != closer && index < max)
    {
        c = [inputText characterAtIndex:index];
        append = [NSString stringWithFormat:@"%C",c];
        [scanner scanString:append];

        if( !slash && c=='\\' )
        {
            slash = YES;
        }
        else if( c != closer || slash )
        {
            if( slash )
            {
                if( c=='n' || c=='r' )
                    append = @"\n";
                else if( c=='t' )
                    append = @"\t";

                //all other characters, including " (closer) are just appended as-is; \" -> ", \f -> f, \\ -> \, etc.
                slash = NO;
            }
            [ret appendString:append];
            c = '\0';
        }

        index++;
    }
    [scanner popStyle];

    return [LXValue stringValue:ret];
}

@end
