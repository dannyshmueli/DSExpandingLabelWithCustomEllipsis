//
//  DSAttributedStringTrunctor.m
//  DSExpandingLabelWithCustomEllipsis
//
//  Created by Danny Shmueli on 5/29/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import "DSAttributedStringTrunctor.h"

#import "DSAttributedString+NumberOfLines.h"
#import "NSAttributedString+SimpleAddDelete.h"

@interface DSAttributedStringTrunctor ()

@property (nonatomic, copy) NSAttributedString *fullText;
@property (nonatomic, readonly) CGSize verticalExpandingsizeConstraint;
@property (nonatomic) CGFloat oneLineHeight;

@end

@implementation DSAttributedStringTrunctor

-(NSAttributedString *)trunctate:(NSAttributedString *)stringToTruncate
                        withSize:(CGSize)sizeConstraint
                        withEllipses:(NSAttributedString *)ellipsis
             numberOfNeededLines:(int)wantedNumberOfLines
                   oneLineHeight:(CGFloat)oneLineHeight
{
    self.fullText = stringToTruncate;
    _verticalExpandingsizeConstraint = sizeConstraint;
    self.oneLineHeight = oneLineHeight;
    
    NSAttributedString *truncatedString = [self trunctate:self.fullText ellipses:ellipsis numberOfNeededLines:wantedNumberOfLines];
    
    truncatedString = [self addToStringUntilLineIsFull:truncatedString ellipses:ellipsis numberOfNeededLines:wantedNumberOfLines];
    
    //Delet one more char to fit into label
    truncatedString = [truncatedString deleteFromEndNumberOfChars:1];
    
    //add ellipsis
    truncatedString =[truncatedString attributtedStringByAppendAttributtedString:ellipsis];
    
    return truncatedString;
}

//this will trim the text to fit 2 lines.
//using binary search (line in the desert)
-(NSAttributedString *)trunctate:(NSAttributedString *)stringToTruncate ellipses:(NSAttributedString *)ellipsis numberOfNeededLines:(int)wantedNumberOfLines
{
    int numberOfLinesForCurrentString = [self numberOfLinesForString:stringToTruncate withEllipsis:ellipsis];
    
    if (numberOfLinesForCurrentString > wantedNumberOfLines)
    {
        //split by half
        stringToTruncate = [stringToTruncate attributedSubstringFromRange:NSMakeRange(0, stringToTruncate.length / 2)];
        return [self trunctate:stringToTruncate ellipses:ellipsis numberOfNeededLines:wantedNumberOfLines];
    }
    return stringToTruncate;
}

//this will return expanded text to make up full line including the ellipsis
-(NSAttributedString *)addToStringUntilLineIsFull:(NSAttributedString *)stringToExpand
                                         ellipses:(NSAttributedString *)ellipsis numberOfNeededLines:(int)wantedNumberOfLines
{
    int numberOfLinesForCurrentString = [self numberOfLinesForString:stringToExpand withEllipsis:ellipsis];
    
    //we always call this method when we are already less or equal from wantedLines
    if (numberOfLinesForCurrentString > wantedNumberOfLines)
    {
        return [stringToExpand deleteFromEndNumberOfChars:1];
    }
    else //we are now short of lines and maybe need to add letters
    {
        
        NSAttributedString *stringToInsert = [self.fullText attributedSubstringFromRange:NSMakeRange(stringToExpand.length, 1)];
        NSAttributedString *toShortString = [stringToExpand attributtedStringByAppendAttributtedString:stringToInsert];

        return [self addToStringUntilLineIsFull:toShortString ellipses:ellipsis numberOfNeededLines:wantedNumberOfLines];
    }
}

#pragma mark - Helpers

-(int)numberOfLinesForString:(NSAttributedString *)string withEllipsis:(NSAttributedString *)ellipses
{
    NSAttributedString *stringToExpandWithEllipsis = [string attributtedStringByAppendAttributtedString:ellipses];
    
    int numberOfLinesForCurrentString = [stringToExpandWithEllipsis numberOfLinesNeededWithSize:self.verticalExpandingsizeConstraint oneLineHeight:self.oneLineHeight];
    return numberOfLinesForCurrentString;
}


@end
