//
//  NSAttributedString+NumberOfLines.m
//  DSExpandingLabelWithCustomEllipsis
//
//  Created by Danny Shmueli on 5/25/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import "NSAttributedString+NumberOfLines.h"

@implementation NSAttributedString (NumberOfLines)

-(float)heightOfOneLine
{
    if (self.length == 0)
        return 0;
    
    //Get the first letter height
    return [self attributedSubstringFromRange:NSMakeRange(0, 1)].size.height;
}

-(int)numberOfLinesNeededWithSize:(CGSize)sizeConstraint oneLineHeight:(float)oneLineHeight
{
    float totalHeight = [self boundingRectWithSize:sizeConstraint
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                     context:NULL].size.height;
    return nearbyint(totalHeight/oneLineHeight);
}

@end