//
//  DSAttributedStringTrunctor.h
//  DSExpandingLabelWithCustomEllipsis
//
//  Created by Danny Shmueli on 5/29/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSAttributedStringTrunctor : NSObject

-(NSAttributedString *)trunctate:(NSAttributedString *)stringToTruncate
                        withSize:(CGSize)sizeConstraint
                        withEllipses:(NSAttributedString *)ellipsis
             numberOfNeededLines:(int)wantedNumberOfLines
                   oneLineHeight:(CGFloat)oneLineHeight;


@end
