//
//  LXCodeBlockScanner.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月11日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXCodeBlockScanner.h"
#import "LXFormulaScanner.h"
#import "LXHeader.h"

@implementation LXCodeBlockScanner

+ (LXCodeBlock*) scan:(NSString*) inputText usingScanner:(LXScanner*)scanner
{
    //prepare the scanner.  hopefully, whatever called [LXCodeBlock scan:...] made a scanner with a context.
    if( scanner==nil )
    {
        scanner = [LXScanner scannerWithString:inputText];
    }

    unichar currentChar = '\0';

    LXValue *currentCommand;
    //approximate the number of commands by the number of newline characters.
    NSMutableArray *commands = [NSMutableArray arrayWithCapacity:[[inputText componentsSeparatedByString:@"\n"] count]];

    while( currentChar != '}' && ![scanner isAtEnd] )
    {
        //LXFormulaScanner must get rid of whitespace before passing control back to CodeBlockScanner so that the search for '}' will occur correctly
        currentCommand = [LXFormulaScanner scan:inputText usingScanner:scanner];

        if( currentCommand )    [commands addObject:currentCommand];

        if( ![scanner isAtEnd] ) currentChar = [scanner currentChar];
    }

    LXCodeBlock *codeBlock = [LXCodeBlock codeBlockWithCommands:commands];

    return codeBlock;
}


@end
