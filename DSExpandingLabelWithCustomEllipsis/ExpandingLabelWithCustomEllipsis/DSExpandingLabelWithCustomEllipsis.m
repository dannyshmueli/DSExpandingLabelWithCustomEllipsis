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

@end

@implementation DSExpandingLabelWithCustomEllipsis

-(void)setTruncatingForNumberOfLines:(int)lines
{
    self.fullText = self.attributedText;
    
    NSAttributedString *ellipsis = self.customEllipsisAttributedText ? self.customEllipsisAttributedText : [[NSAttributedString alloc] initWithString: @""];
    
    self.numberOfLines = 0;
    
    NSMutableAttributedString *truncatedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    float oneLineHeight = [truncatedString heightOfOneLine];
    
    CGSize sizeConstraint = CGSizeMake(self.bounds.size.width, CGFLOAT_MAX);
    if ([truncatedString numberOfLinesNeededWithSize:sizeConstraint oneLineHeight:oneLineHeight] > lines)
    {
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
    }
//        self.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)];
//        [self addGestureRecognizer:tapper];
//    }else{
//        CGRect labelFrame = self.frame;
//        labelFrame.size.height = [@"A" sizeWithFont:self.font].height * lines;
//        self.frame = labelFrame;
//        self.text = txt;
//    }
}

#pragma mark - Private

//-(float)oneLineHeight
//{
//    return [self.attributedText attributedSubstringFromRange:NSMakeRange(0, 1)].size.height;
//}
//
//-(int)numberOfLinesNeededWhenOneLineHeightIs:(float)oneLineHeight
//{
//    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.text];
//    float totalHeight = [attributedText boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
//                                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                                     context:NULL].size.height;
//    int numberOfLines = nearbyint(totalHeight/oneLineHeight);
//    return numberOfLines;
//}

//-(int)numberOfLinesNeeded:(NSAttributedString *)s
//{
//    float oneLineHeight = [@"A" sizeWithFont:self.font].height;
//    float totalHeight = [s boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
//                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
//                                        context:NULL].size.height;
//    int numberOfLines = nearbyint(totalHeight/oneLineHeight);
//    NSLog(@"currently Neede Number of lines: %i", numberOfLines);
//    return numberOfLines;
//}


-(void)expand:(UITapGestureRecognizer *) tapper {
//    int linesNeeded = [self numberOfLinesNeeded:[[NSAttributedString alloc] initWithString: self.fullText]];
    CGRect labelFrame = self.frame;
//    labelFrame.size.height = [@"A" sizeWithFont:self.font].height * linesNeeded;
    self.frame = labelFrame;
    self.attributedText = self.fullText;
    
    if (self.didExpandBlock)
        self.didExpandBlock();
}

@end
