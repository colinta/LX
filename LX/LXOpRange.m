//
//  LXOpRange.m
//  LXCommand
//
//  Created by Colin Thomas-Arnold on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LXOps.h"

@implementation LXOpRange

- (LXValue*) value:(LXValue*)a value:(LXValue*)b
{
    if( ([b type]==numberType) && [a type]==vectorType )
    {
        //return that part of a
        return [self index:[b doubleValue] in:a];
    }
    else if( [b type]==vectorType )
    {
        //this vector should be a combination of all numbers (-> a isa vector), all strings (-> a isa dictionary),
        //or a combination of vectors containing just numbers or just strings

        //begin a recursive function
        return [self copy:a using:b];
    }
    return nil;
}

- (LXValue*) index:(NSInteger)index in:(LXValue*)a
{
    NSArray *ret = [a vectorValue];
    if( index < [ret count] && index >= 0 ) return [ret objectAtIndex:index];

    return nil;
}

- (LXValue*) copy:(LXValue*)a using:(LXValue*)b
{
    //b is a vector; it could contain more vectors (run copy: recursively), numbers (use as indices on a), or strings (use as keys on a)
    //either way, a vector will be returned (never a new dictionary!)

    //example:
    // dictionary = ["one" => 1, "two" => 2];
    // dictionary["one", "two"] -> {1, 2}
    //
    // a new dictionary could be reversed like this
    // {"one","two"} => dictionary["two", "one"] -> ["one"=>2, "two"=>1]

    NSArray *vec = [b vectorValue];
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[vec count]];

    NSEnumerator *ENUM;
    LXValue *curr;
    LXValue *add;

    if( [a type]==vectorType )
    {
        ENUM = [vec objectEnumerator];
        while( curr = [ENUM nextObject] )
        {
            if( [curr type]==vectorType )
            {
                [ret addObject:[self copy:a using:curr]];
            }
            else if( [curr type]==numberType )
            {
                add = [self index:[curr intValue] in:a];
                if( add ) [ret addObject:add];
            }
        }
    }

    return [LXValue vectorValue:ret];
}

@end
