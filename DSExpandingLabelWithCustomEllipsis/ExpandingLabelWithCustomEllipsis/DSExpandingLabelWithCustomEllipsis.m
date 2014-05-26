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

@end

@implementation DSExpandingLabelWithCustomEllipsis

-(CGSize)verticalExpandingsizeConstraint
{
    return CGSizeMake(self.bounds.size.width, CGFLOAT_MAX);
}


-(void)setTruncatingForNumberOfLines:(int)lines
{
    self.fullText = self.attributedText;
    
    NSAttributedString *ellipsis = self.customEllipsisAttributedText ? self.customEllipsisAttributedText : [[NSAttributedString alloc] initWithString: @""];
    
    self.numberOfLines = 0;
    
    NSMutableAttributedString *truncatedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    float oneLineHeight = [truncatedString heightOfOneLine];
    
    CGSize sizeConstraint = self.verticalExpandingsizeConstraint;
    if (![truncatedString numberOfLinesNeededWithSize:sizeConstraint oneLineHeight:oneLineHeight] > lines)
        return;
    
    [truncatedString appendAttributedString:[[NSAttributedString alloc] initWithAttributedString:ellipsis]];
    NSRange range = NSMakeRange(truncatedString.length - (ellipsis.length+1), 1);
    while ([truncatedString numberOfLinesNeededWithSize:sizeConstraint oneLineHeight:oneLineHeight] > lines) {
        [truncatedString deleteCharactersInRange:range];
        range.location--;
    }
    [truncatedString deleteCharactersInRange:range];  //need to delete one more to make it fit
    
    //resize label
    CGRect labelFrame = self.frame;
    labelFrame.size.height = oneLineHeight * lines;
    self.frame = labelFrame;
    
    self.text = nil;
    self.attributedText = truncatedString;
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)];
    [self addGestureRecognizer:tapper];
    
}

#pragma mark - Button Handler

-(void)expand:(UITapGestureRecognizer *)tapper
{
    float oneLineHeight = [self.fullText heightOfOneLine];
    int linesNeeded = [self.fullText numberOfLinesNeededWithSize:self.verticalExpandingsizeConstraint oneLineHeight:oneLineHeight];
    
    CGRect labelFrame = self.frame;
    labelFrame.size.height = oneLineHeight * linesNeeded + oneLineHeight/2;
    self.frame = labelFrame;
    
    self.attributedText = self.fullText;
    
    if (self.didExpandBlock)
        self.didExpandBlock();
}

@end
