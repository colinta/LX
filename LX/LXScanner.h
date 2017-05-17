/*
 *  LXScanner.h
 *  LXCommand
 *
 *  Created by Colin Thomas-Arnold on 10月10日2006年.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 *
 */

#include <Foundation/Foundation.h>
#include "LXHeader.h"

@interface LXScanner : NSObject
{
    NSScanner *scanner;
    NSMutableAttributedString *attrString;

    NSMutableArray *styleStack;
    NSDictionary *currStyle;
}

//styles:
+ (NSDictionary*) defaultStyle;
+ (NSDictionary*) stringStyle;
+ (NSDictionary*) numberStyle;
+ (NSDictionary*) variableNameStyle;
+ (NSDictionary*) reservedWordStyle;
+ (NSDictionary*) commentStyle;
+ (NSDictionary*) errorStyle;
+ (NSDictionary*) labelStyle;
+ (NSDictionary*) operatorStyle;

+ (id) scannerWithString:(NSString*)value;
- (id) initWithString:(NSString*)value;

//setting the style
//once the style has been pushed, all scanned characters will be recorded with that style.
- (void) pushStyle:(NSDictionary*)value;
- (void) popStyle;
- (NSDictionary*) currentStyle;

//getting the color-coded string
- (NSAttributedString*) attributedString;

//for skipping characters and comments
- (void) skipCharacterSet:(NSCharacterSet*) chars;
- (void) skipWhitespace;
- (void) skipSpaces;

//NSScanner methods:
- (void) scanBack:(int)count;
- (void) scanForward:(int)count;
- (unichar) currentChar;
- (BOOL) isAtEnd;
- (int) scanLocation;
- (void) setScanLocation:(int)value;
- (BOOL) scanUpToString:(NSString*)value;
- (BOOL) scanString:(NSString*)value;
- (BOOL) scanUpToString:(NSString*)value intoString:(NSString**)var;
- (BOOL) scanCharactersFromSet:(NSCharacterSet *)value intoString:(NSString **)var;
- (BOOL) scanInt:(int*)var;

//reserved words (convenient place to put this, though not really part of a "scan" operation
+ (NSArray*) reservedWords;
@end

@interface NSScanner (LXScannerAdditions)
- (BOOL) scanUpToString:(NSString*)value;
- (BOOL) scanString:(NSString*)value;
@end

@interface NSCharacterSet (LXCharacterSet)
+ (NSCharacterSet*) numberSet;
+ (NSCharacterSet*) letterSet;
+ (NSCharacterSet*) letterAndNumberSet;
+ (NSCharacterSet*) letterAndNumberInvertedSet;
+ (NSCharacterSet*) digitsSet;
+ (NSCharacterSet*) hexadecimalSet;
@end
