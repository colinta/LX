//
//  main.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月9日2006年.
//  Copyright __MyCompanyName__ 2006. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LXCommand.h"

int main(int argc, char *argv[])
{
    NSString *command = [LXCommand runProgram:@"a = [2, 1, -3]\nb=[4, 1, 2]\na * b\n"];
    NSLog(@"%@", command);
    return 0;
}
