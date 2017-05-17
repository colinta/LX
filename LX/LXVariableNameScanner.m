//
//  LXVariableNameScanner.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月15日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXVariableNameScanner.h"
#import "LXHeader.h"
#import "LXFormulaScanner.h"
#import "LXPlaceholder.h"
#import "LXOperator.h"
#import "LXError.h"

@implementation LXVariableNameScanner

+ (LXValue*) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner
{
    //prepare the scanner
    if( scanner==nil )
    {
        scanner = [LXScanner scannerWithString:inputText];
    }

    LXValue *newVar = nil;
    NSString *text;

    if( [scanner scanString:@"#"] )  //label
    {
        [scanner scanBack:1];
        [scanner pushStyle:[LXScanner labelStyle]];
        [scanner scanForward:1];
        [scanner scanUpToString:@"\n" intoString:&text];
        [scanner scanString:@"\n"];
        [scanner popStyle];
        return [LXPlaceholder variableNamed:text];
    }

    if( [scanner scanString:@"<"] ) // <>-enclosed variable name
    {
        int varStart = [scanner scanLocation];
        [scanner pushStyle:[LXScanner variableNameStyle]];
        [scanner scanUpToString:@">" intoString:&text];
        [scanner popStyle];
        [scanner scanString:@">"];

        //check for reserved words
        NSEnumerator *ENUM = [[LXScanner reservedWords] objectEnumerator];
        NSString *curr;
        BOOL found = NO;
        while( (curr = [ENUM nextObject]) && !found)
        {
            if( [text isEqualToString:curr] ) //RESERVED WORD FOUND
            {
                //back up, and highlight the current text as a reserved word
                [scanner setScanLocation:varStart];
                [scanner pushStyle:[LXScanner reservedWordStyle]];
                [scanner scanString:text];
                [scanner popStyle];
                [scanner scanString:@">"];
                found = YES;
            }
        }

        //if scanner contains a context, then it should be used
        newVar = [LXPlaceholder variableNamed:text];
    }
    else if( [[NSCharacterSet letterSet] characterIsMember:[scanner currentChar]] ) //A-z0-9 compliant variable name (starts with A-z)
    {
        int varStart = [scanner scanLocation];
        //letterAndNumberSet INCLUDES spaces, so variables CAN have internal spaces
        [scanner pushStyle:[LXScanner variableNameStyle]];
        [scanner scanCharactersFromSet:[NSCharacterSet letterAndNumberSet] intoString:&text];
        [scanner popStyle];

        //trailing spaces are NOT allowed (unless enclosed by <>): so trim them.
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        //check for reserved words
        NSEnumerator *ENUM = [[LXScanner reservedWords] objectEnumerator];
        NSString *curr;
        BOOL found = NO;
        while( (curr = [ENUM nextObject]) && !found)
        {
            if( [text isEqualToString:curr] ) //RESERVED WORD FOUND
            {
                //back up, and highlight the current text as a reserved word
                [scanner setScanLocation:varStart];
                [scanner pushStyle:[LXScanner reservedWordStyle]];
                [scanner scanString:text];
                [scanner popStyle];
                found = YES;
            }
        }

        //this is just a temporary placeholder.  it will be evaluated at runtime
        newVar = [LXPlaceholder variableNamed:text];
    }

    if( newVar )
    {
        return newVar;
    }
    else
    {
        //nothing was scanned! flag the rest of the line as an error
        [scanner pushStyle:[LXScanner errorStyle]];
        [scanner scanUpToString:@"\n"];
        [scanner scanString:@"\n"];
        [scanner popStyle];
        return [LXError expected:@"Variable Name expected"];
    }
}

@end
