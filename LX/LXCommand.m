//
//  LXCommand.m
//
//  Created by Colin Thomas-Arnold on 10月9日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXCommand.h"
#import "LXScanner.h"
#import "LXCodeBlock.h"
#import "LXCodeBlockScanner.h"
#import "LXVariable.h"

@implementation LXCommand

+ (NSString*) runProgram:(NSString*)input
{
    if( [input length] == 0 ) { return @""; }

    LXCodeBlock *cmd = [LXCodeBlockScanner scan:input usingScanner: nil];

    double t0 = [NSDate timeIntervalSinceReferenceDate];
    id ret = [cmd run];
    double t = [NSDate timeIntervalSinceReferenceDate] - t0;
    NSString *time = [NSString stringWithFormat:@"time: %4fs", t];

    NSMutableString *output = [NSMutableString string];
    [output appendString:@"\ninput:\n"];
    [output appendString:[cmd displayString]];
    [output appendString:@"\noutput: `"];
    [output appendString:[ret displayString]];
    [output appendString:@"`\n-- outputTime:     ---------------------\n"];
    [output appendString:time];

    return output;
}

@end
