//
//  NSAttributedString+SimpleAddDelete.m
//  DSExpandingLabelWithCustomEllipsis
//
//  Created by Danny Shmueli on 5/30/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import "NSAttributedString+SimpleAddDelete.h"

@implementation NSAttributedString (SimpleAddDelete)

-(NSAttributedString *)attributtedStringByAppendAttributtedString:(NSAttributedString *)stringToAppend
{
    NSMutableAttributedString *stringToExpandWithEllipsis = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    [stringToExpandWithEllipsis appendAttributedString:stringToAppend];
    return stringToExpandWithEllipsis;
}

-(NSAttributedString *)deleteFromEndNumberOfChars:(int)numberOfCharsToDelete
{
    NSMutableAttributedString *toLongString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    [toLongString deleteCharactersInRange:NSMakeRange(toLongString.length-numberOfCharsToDelete , numberOfCharsToDelete)];
    return toLongString;
}

@end
