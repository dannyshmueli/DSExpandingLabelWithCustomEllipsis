//
//  NSAttributedString+NumberOfLines.h
//  DSExpandingLabelWithCustomEllipsis
//
//  Created by Danny Shmueli on 5/25/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (NumberOfLines)
-(float)heightOfOneLine;
-(int)numberOfLinesNeededWithSize:(CGSize)sizeConstraint oneLineHeight:(float)oneLineHeight;

@end
