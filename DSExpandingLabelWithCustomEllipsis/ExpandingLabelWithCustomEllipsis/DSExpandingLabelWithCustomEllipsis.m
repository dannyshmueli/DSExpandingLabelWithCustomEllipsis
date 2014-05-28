//
//  AniwaysExpandableLabel.m
//  Aniways
//
//  Created by Danny Shmueli on 5/24/14.
//  Copyright (c) 2014 Aniways. All rights reserved.
//

#import "DSExpandingLabelWithCustomEllipsis.h"
#import "NSAttributedString+NumberOfLines.h"

@interface DSExpandingLabelWithCustomEllipsis ()

@property (nonatomic, copy) NSAttributedString *fullText;
@property (nonatomic, readonly) CGSize verticalExpandingsizeConstraint;
@property (nonatomic) CGFloat oneLineHeight;
@end

@implementation DSExpandingLabelWithCustomEllipsis

NSString *const kDSDefaultEllipsis = @"...More";

-(CGSize)verticalExpandingsizeConstraint
{
    return CGSizeMake(self.bounds.size.width, CGFLOAT_MAX);
}

-(void)setTruncatingForNumberOfLines:(int)lines
{
    //remove restrictions
    self.numberOfLines = 0;
    
    NSAttributedString *ellipsis = self.customEllipsisAttributedText ? self.customEllipsisAttributedText : [[NSAttributedString alloc] initWithString: kDSDefaultEllipsis];
    
    self.fullText = self.attributedText;

    self.oneLineHeight = [self.fullText heightOfOneLine];
    
    NSAttributedString *truncatedString = [self trunctate:self.fullText ellipses:ellipsis numberOfNeededLines:lines];
    
    truncatedString = [self addToStringUntilLineIsFull:truncatedString ellipses:ellipsis numberOfNeededLines:lines];
    
    //add ellipsis
    truncatedString =[self string:truncatedString withElipses:ellipsis];

    //resize label
    CGRect labelFrame = self.frame;
    labelFrame.size.height = self.oneLineHeight * lines;
    self.frame = labelFrame;
    
    //set the text
    self.attributedText = truncatedString;
    
    //add tapper for expand
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)];
    [self addGestureRecognizer:tapper];
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
-(NSAttributedString *)addToStringUntilLineIsFull:(NSAttributedString *)stringToExpand ellipses:(NSAttributedString *)ellipsis numberOfNeededLines:(int)wantedNumberOfLines
{
    int numberOfLinesForCurrentString = [self numberOfLinesForString:stringToExpand withEllipsis:ellipsis];
    
    //we always call this method when we are already less or equal from wantedLines
    if (numberOfLinesForCurrentString > wantedNumberOfLines)
    {
        NSMutableAttributedString *toLongString = [[NSMutableAttributedString alloc] initWithAttributedString:stringToExpand];
        [toLongString deleteCharactersInRange:NSMakeRange(toLongString.length-2 , 2)];
        return toLongString;
    }
    else //we are now short of lines and maybe need to add letters
    {
        NSMutableAttributedString *toShortString = [[NSMutableAttributedString alloc] initWithAttributedString:stringToExpand];
        NSAttributedString *stringToInsert = [self.fullText attributedSubstringFromRange:NSMakeRange(toShortString.length, 1)];
        [toShortString appendAttributedString:stringToInsert];
        
        return [self addToStringUntilLineIsFull:toShortString ellipses:ellipsis numberOfNeededLines:wantedNumberOfLines];
    }
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

#pragma mark - Button Handler

-(void)expand:(UITapGestureRecognizer *)tapper
{
    int linesNeeded = [self.fullText numberOfLinesNeededWithSize:self.verticalExpandingsizeConstraint oneLineHeight:self.oneLineHeight];
    
    CGRect labelFrame = self.frame;
    labelFrame.size.height = self.oneLineHeight * linesNeeded + self.oneLineHeight/2;
    self.frame = labelFrame;
    
    self.attributedText = self.fullText;
    
    if (self.didExpandBlock)
        self.didExpandBlock();
}

@end
