//
//  DSAttributedStringTrunctor.m
//  DSExpandingLabelWithCustomEllipsis
//
//  Created by Danny Shmueli on 5/29/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import "DSAttributedStringTrunctor.h"

#import "NSAttributedString+NumberOfLines.h"

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
    
    //Delet one more to fit into label
    truncatedString = [self string:truncatedString deleteFromEndNumberOfChars:1];
    
    //add ellipsis
    truncatedString =[self string:truncatedString withElipses:ellipsis];
    
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
        return [self string:stringToExpand deleteFromEndNumberOfChars:1];
    }
    else //we are now short of lines and maybe need to add letters
    {
        NSMutableAttributedString *toShortString = [[NSMutableAttributedString alloc] initWithAttributedString:stringToExpand];
        NSAttributedString *stringToInsert = [self.fullText attributedSubstringFromRange:NSMakeRange(toShortString.length, 1)];
        [toShortString appendAttributedString:stringToInsert];
        
        return [self addToStringUntilLineIsFull:toShortString ellipses:ellipsis numberOfNeededLines:wantedNumberOfLines];
    }
}

-(NSAttributedString *)string:(NSAttributedString *)string deleteFromEndNumberOfChars:(int)numberOfCharsToDelete
{
    NSMutableAttributedString *toLongString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [toLongString deleteCharactersInRange:NSMakeRange(toLongString.length-numberOfCharsToDelete , numberOfCharsToDelete)];
    return toLongString;
}

#pragma mark - Helpers

-(int)numberOfLinesForString:(NSAttributedString *)string withEllipsis:(NSAttributedString *)ellipses
{
    NSAttributedString *stringToExpandWithEllipsis = [self string:string withElipses:ellipses];
    
    int numberOfLinesForCurrentString = [stringToExpandWithEllipsis numberOfLinesNeededWithSize:self.verticalExpandingsizeConstraint oneLineHeight:self.oneLineHeight];
    return numberOfLinesForCurrentString;
}

-(NSAttributedString *)string:(NSAttributedString *)string withElipses:(NSAttributedString *)ellipses
{
    NSMutableAttributedString *stringToExpandWithEllipsis = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [stringToExpandWithEllipsis appendAttributedString:ellipses];
    return stringToExpandWithEllipsis;
}

@end
