//
//  LXNumberScanner.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月17日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "LXNumberScanner.h"
#import "LXValue.h"
#import "LXError.h"

@implementation LXNumberScanner

+ (LXValue*) scan:(NSString*)inputText usingScanner:(LXScanner*)scanner
{
    //may start with a '0x' or "0X" -> hexadecimal Set
    //may start with a .
    //may contain an e or E (x10^) AFTER a numeric digit
    /*SO:
        check for 0
        {
            scan [possible] x / X
            scan all 0-9a-z, convert to an int and return
        }

        scan all digits
        check for .
        {
            scan all digits
        }
        check for e || E
        {
            scan all digits -> n
            multiply 10^n
        }
    */
    //prepare the scanner
    if( scanner==nil )
    {
        scanner = [LXScanner scannerWithString:inputText];
    }

    int numberStart = [scanner scanLocation];
    int signchange;
    if( [scanner scanString:@"-"] )
    {
        signchange = -1;
    }
    else {
        signchange = 1;
    }

    if( [scanner scanString:@"0x"] ||
        [scanner scanString:@"0X"] )
    {
        NSString *hexadecimal = nil;

        [scanner scanBack:2];
        [scanner pushStyle:[LXScanner numberStyle]];
        [scanner scanForward:2];
        [scanner scanCharactersFromSet:[NSCharacterSet hexadecimalSet] intoString:&hexadecimal];
        [scanner popStyle];

        //TODO: convert hexadecimal to an integer
        NSInteger i, max = [hexadecimal length] - 1;
        NSInteger val = 0;
        NSInteger factor = 1;
        NSInteger total = 0;
        BOOL error = NO;
        unichar c;

        for( i = max; i >= 0; i-- )
        {
            c = [hexadecimal characterAtIndex:i];

            switch(c)
            {
                case '0': val = 0; break;
                case '1': val = 1; break;
                case '2': val = 2; break;
                case '3': val = 3; break;
                case '4': val = 4; break;
                case '5': val = 5; break;
                case '6': val = 6; break;
                case '7': val = 7; break;
                case '8': val = 8; break;
                case '9': val = 9; break;
                case 'a': case 'A': val = 10; break;
                case 'b': case 'B': val = 11; break;
                case 'c': case 'C': val = 12; break;
                case 'd': case 'D': val = 13; break;
                case 'e': case 'E': val = 14; break;
                case 'f': case 'F': val = 15; break;
                default:
                    error = YES;
                break;
            }

            if( error )
            {
                //NON-hex character found.  scan to end of text and mark as error
                [scanner setScanLocation:numberStart];
                [scanner pushStyle:[LXScanner errorStyle]];
                [scanner scanCharactersFromSet:[NSCharacterSet letterAndNumberInvertedSet] intoString:NULL];
                [scanner popStyle];
                return [LXError expected:@"Hexadecimal characters (0-9, a-f) expected"];
            }

            total += val * factor;
            factor *= 16;
        }

        return [LXValue doubleValue:signchange*total];
    }

    int retInt = 0;
    double retDouble;
    double add;

    [scanner pushStyle:[LXScanner numberStyle]];
    [scanner scanInt:&retInt];

    retDouble = (double)retInt;

    NSString *afterPoint;

    if( [scanner scanString:@"."] )
    {
        if( [scanner scanCharactersFromSet:[NSCharacterSet digitsSet] intoString:&afterPoint] )
        {
            afterPoint = [@"0." stringByAppendingString:afterPoint];

            add = [afterPoint doubleValue];
            retDouble += add;
        }
        else
        {
            //just a lonely '.' with no numbers on either side.  mark the . as an error, but return the int number 0
            [scanner popStyle]; //clear the number style

            [scanner pushStyle:[LXScanner errorStyle]];
            [scanner scanString:@"."];
            [scanner popStyle];

            return [LXValue doubleValue:0];
        }
    }

    if( [scanner scanString:@"e"] || [scanner scanString:@"E"] )
    {
        int exponent = 0;
        [scanner scanInt:&exponent];

        if( exponent > 0 )
        {
            while( exponent > 0 )
            {
                retInt *= 10;
                retDouble *= 10;
                exponent--;
            }
        }
        else if( exponent < 0 )
        {
            while( exponent < 0 )
            {
                retDouble /= 10;
                exponent++;
            }
        }
    }

    [scanner popStyle];

    return [LXValue doubleValue:(double)signchange*retDouble];
}

@end
