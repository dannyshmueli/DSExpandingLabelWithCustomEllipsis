//
//  AniwaysExpandableLabel.m
//  Aniways
//
//  Created by Danny Shmueli on 5/24/14.
//  Copyright (c) 2014 Aniways. All rights reserved.
//

#import "DSExpandingLabelWithCustomEllipsis.h"
#import "NSAttributedString+NumberOfLines.h"
#import "DSAttributedStringTrunctor.h"

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
    
    //store full text for expanding later
    self.fullText = self.attributedText;
    
    self.oneLineHeight = [self.fullText heightOfOneLine];
    
    DSAttributedStringTrunctor *truncator = [DSAttributedStringTrunctor new];
    NSAttributedString *truncatedString  = [truncator trunctate:self.fullText
                                                       withSize:self.verticalExpandingsizeConstraint
                                                       withEllipses:ellipsis
                                            numberOfNeededLines:lines
                                                  oneLineHeight:self.oneLineHeight];
    
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

#pragma mark - Button Handler

-(void)expand:(UITapGestureRecognizer *)tapper
{
    [self removeGestureRecognizer:tapper];
    
    int linesNeeded = [self.fullText numberOfLinesNeededWithSize:self.verticalExpandingsizeConstraint oneLineHeight:self.oneLineHeight];
    
    CGRect labelFrame = self.frame;
    labelFrame.size.height = self.oneLineHeight * linesNeeded + self.oneLineHeight/2;
    self.frame = labelFrame;
    
    self.attributedText = self.fullText;
    
    if (self.didExpandBlock)
        self.didExpandBlock();
}

@end
