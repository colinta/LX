//
//  LXScanner.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 10月9日2006年.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "LXScanner.h"
#import "LXHeader.h"

static NSCharacterSet *numberSet = nil;
static NSCharacterSet *letterSet = nil;
static NSCharacterSet *letterAndNumberSet = nil;
static NSCharacterSet *letterAndNumberInvertedSet = nil;
static NSCharacterSet *digitsSet = nil;
static NSCharacterSet *hexadecimalSet = nil;
static NSCharacterSet *allwhitespace = nil;
static NSCharacterSet *spacestabs = nil;

static BOOL lxcharactersetinitialized = NO;

static NSDictionary *defaultStyle = nil;
static NSDictionary *stringStyle = nil;
static NSDictionary *numberStyle = nil;
static NSDictionary *variableNameStyle = nil;
static NSDictionary *reservedWordStyle = nil;
static NSDictionary *commentStyle = nil;
static NSDictionary *errorStyle = nil;
static NSDictionary *labelStyle = nil;
static NSDictionary *operatorStyle = nil;

static NSArray *reservedWords = nil;

@implementation LXScanner

+ (NSDictionary*) defaultStyle { return defaultStyle; }
+ (NSDictionary*) stringStyle { return stringStyle; }
+ (NSDictionary*) numberStyle { return numberStyle; }
+ (NSDictionary*) variableNameStyle { return variableNameStyle; }
+ (NSDictionary*) reservedWordStyle { return reservedWordStyle; }
+ (NSDictionary*) commentStyle { return commentStyle; }
+ (NSDictionary*) errorStyle { return errorStyle; }
+ (NSDictionary*) labelStyle { return labelStyle; }
+ (NSDictionary*) operatorStyle { return operatorStyle; }

+ (void) initialize
{
    if( lxcharactersetinitialized ) return;

    lxcharactersetinitialized = YES;

    numberSet = [NSCharacterSet characterSetWithCharactersInString:@".1234567890"];
    letterSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"];
    letterAndNumberSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890"];
    letterAndNumberInvertedSet = [letterAndNumberSet invertedSet];
    digitsSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    hexadecimalSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890abcdefABCDEF"];
    allwhitespace = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r"];
    spacestabs = [NSCharacterSet characterSetWithCharactersInString:@" \t"];

    NSNumber *italics = [NSNumber numberWithFloat:0.3];

    NSColor *errorBack = [NSColor colorWithCalibratedRed:1.0 green:0.9 blue:0.9 alpha:1.0];
    NSColor *stringColor = [NSColor colorWithCalibratedRed:.25 green:.55 blue:0.12 alpha:1.0];
    NSColor *labelColor = [NSColor colorWithCalibratedRed:.1 green:.55 blue:0.0 alpha:1.0];
    NSColor *operatorColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];

    defaultStyle = [NSDictionary dictionaryWithObjectsAndKeys: [NSColor blackColor], NSForegroundColorAttributeName, nil];
    stringStyle = [NSDictionary dictionaryWithObjectsAndKeys: stringColor, NSForegroundColorAttributeName, nil];
    numberStyle = [NSDictionary dictionaryWithObjectsAndKeys: [NSColor blueColor], NSForegroundColorAttributeName, nil];
    variableNameStyle = [NSDictionary dictionaryWithObjectsAndKeys: [NSColor purpleColor], NSForegroundColorAttributeName, nil];
    reservedWordStyle = [NSDictionary dictionaryWithObjectsAndKeys: [NSColor blueColor], NSForegroundColorAttributeName, nil];
    commentStyle = [NSDictionary dictionaryWithObjectsAndKeys: [NSColor grayColor], NSForegroundColorAttributeName, italics, NSObliquenessAttributeName, nil];
    errorStyle = [NSDictionary dictionaryWithObjectsAndKeys: errorBack, NSBackgroundColorAttributeName, [NSColor blackColor], NSForegroundColorAttributeName, nil];
    labelStyle = [NSDictionary dictionaryWithObjectsAndKeys: labelColor, NSForegroundColorAttributeName, nil];
    operatorStyle = [NSDictionary dictionaryWithObjectsAndKeys: operatorColor, NSForegroundColorAttributeName, nil];
}

+ (id) scannerWithString:(NSString*)value
{
    return [[LXScanner alloc] initWithString:value];
}

- (id) initWithString:(NSString*)value
{
    self = [super init];
    if( self )
    {
        scanner = [[NSScanner alloc] initWithString:value];
        [scanner setCharactersToBeSkipped:nil];
        attrString = [[NSMutableAttributedString alloc] initWithString:value];

        currStyle = defaultStyle;
        styleStack = [[NSMutableArray alloc] initWithObjects:currStyle, nil];
    }
    return self;
}

//setting the style
//once the style has been pushed, all scanned characters will be recorded with that style.
- (void) pushStyle:(NSDictionary*)value
{
    [styleStack addObject:value];
    currStyle = value;
}

- (void) popStyle
{
    [styleStack removeLastObject];
    currStyle = (NSDictionary*)[styleStack lastObject];
}

- (NSDictionary*) currentStyle { return currStyle; }

//getting a copy of the color-coded string
- (NSAttributedString*) attributedString
{
    return [[NSAttributedString alloc] initWithAttributedString:attrString];
}

- (unichar) currentChar
{
    if( [scanner isAtEnd] ) return '\0';
    return [[scanner string] characterAtIndex:[scanner scanLocation]];
}

- (void) skipCharacterSet:(NSCharacterSet*) chars
{
    if( [scanner isAtEnd] ) return;

    NSUInteger location = [scanner scanLocation];
    NSString *scannerstring = [scanner string];
    NSUInteger eol = [scannerstring length];

    BOOL keepScanning = YES;
    unichar c, nc;

    while( keepScanning )
    {
        //check for EOL
        if( location < eol )
        {
            c = [scannerstring characterAtIndex:location];

            //check for a // or /* */ style comment
            if( c=='/' && location + 1 < eol )
            {
                nc = [scannerstring characterAtIndex:location + 1];
                if( nc=='/' ) //line comment
                {
                    [self pushStyle:commentStyle];
                    [self scanForward:2];
                    [self scanUpToString:@"\n"];
                    [self popStyle];
                    //[self scanString:@"\n"]; //don't do this!  the \n might be an eolOp.  let the scanner scan it in the next iteration

                    location = [scanner scanLocation];
                }
                else if( nc=='*' ) /* block comment */
                {
                    [self pushStyle:commentStyle];
                    [self scanForward:2];
                    [self scanUpToString:@"*/"];
                    [self scanString:@"*/"];
                    [self popStyle];

                    location = [scanner scanLocation];
                }
                else
                {
                    //not a comment, so all done.
                    keepScanning = NO;
                }
            }
            //check for anything but whitespace (using chars)
            else if( ![chars characterIsMember:c] )
            {
                keepScanning = NO;
            }
            else
            {
                location++;
                [scanner setScanLocation:location];
            }
        }
        else
        {
            keepScanning = NO;
        }
    }
}

- (void) skipWhitespace
{
    [self skipCharacterSet:allwhitespace];
}

- (void) skipSpaces
{
    [self skipCharacterSet:spacestabs];
}

- (void) scanBack:(int)count
{
    NSInteger loc = [scanner scanLocation];
    loc -= count;
    if( loc < 0 ) loc = 0;
    [scanner setScanLocation:loc];
}

- (void) scanForward:(int)count
{
    NSInteger loc = [scanner scanLocation];
    NSUInteger max = [[scanner string] length];

    NSInteger w = count;
    if( loc + w > max ) w = max - loc;
    //apply current style to this range
    [attrString setAttributes:currStyle range:NSMakeRange(loc, w)];
    [scanner setScanLocation:loc + w];
}

- (BOOL) scanUpToString:(NSString*)value
{
    NSUInteger loc = [scanner scanLocation];
    BOOL ret = [scanner scanUpToString:value intoString:NULL];
    NSInteger w = [scanner scanLocation] - loc;
    [attrString setAttributes:currStyle range:NSMakeRange(loc, w)];
    return ret;
}

- (BOOL) scanString:(NSString*)value
{
    NSUInteger loc = [scanner scanLocation];
    BOOL ret = [scanner scanString:value intoString:NULL];
    NSInteger w = [scanner scanLocation] - loc;
    [attrString setAttributes:currStyle range:NSMakeRange(loc, w)];
    return ret;
}

//NSScanner methods:
- (BOOL) isAtEnd { return [scanner isAtEnd]; }
- (NSUInteger) scanLocation { return [scanner scanLocation]; }
- (void) setScanLocation:(int)value { [scanner setScanLocation:value]; }

- (BOOL) scanUpToString:(NSString*)value intoString:(NSString**)var
{
    NSUInteger loc = [scanner scanLocation];
    BOOL ret = [scanner scanUpToString:value intoString:var];
    NSInteger w = [scanner scanLocation] - loc;
    [attrString setAttributes:currStyle range:NSMakeRange(loc, w)];
    return ret;
}

- (BOOL) scanCharactersFromSet:(NSCharacterSet *)value intoString:(NSString **)var
{
    NSUInteger loc = [scanner scanLocation];
    BOOL ret = [scanner scanCharactersFromSet:value intoString:var];
    NSInteger w = [scanner scanLocation] - loc;
    [attrString setAttributes:currStyle range:NSMakeRange(loc, w)];
    return ret;
}

- (BOOL) scanInt:(int*)var
{
    NSUInteger loc = [scanner scanLocation];
    BOOL ret = [scanner scanInt:var];
    NSInteger w = [scanner scanLocation] - loc;
    [attrString setAttributes:currStyle range:NSMakeRange(loc, w)];
    return ret;
}

+ (NSArray*) reservedWords
{
    if( reservedWords==nil )
        reservedWords = [[NSArray alloc] initWithObjects:
            @"if",
            //@"else",
            // @"while",
            // @"until",
            // @"do",
            // @"for",
            // @"switch",
            // @"try",
            // @"finally",
            // @"catch",
            // @"observe",
            @"def",
            // @"class",
            @"self",
            // @"super",
            @"print",
            nil];
    return reservedWords;
}

@end

@implementation NSScanner (LXScannerAdditions)
- (BOOL) scanUpToString:(NSString*)value
{
    return [self scanUpToString:value intoString:NULL];
}

- (BOOL) scanString:(NSString*)value
{
    return [self scanString:value intoString:NULL];
}
@end

@implementation NSCharacterSet (LXCharacterSet)
+ (NSCharacterSet*) numberSet { return numberSet; }
+ (NSCharacterSet*) letterSet { return letterSet; }
+ (NSCharacterSet*) letterAndNumberSet { return letterAndNumberSet; }
+ (NSCharacterSet*) letterAndNumberInvertedSet { return letterAndNumberInvertedSet; }
+ (NSCharacterSet*) digitsSet { return digitsSet; }
+ (NSCharacterSet*) hexadecimalSet { return hexadecimalSet; }
@end
