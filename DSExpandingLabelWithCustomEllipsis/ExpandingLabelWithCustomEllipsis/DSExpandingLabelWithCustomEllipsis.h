//
//  AniwaysExpandableLabel.h
//  Aniways
//
//  Created by Danny Shmueli on 5/24/14.
//  Copyright (c) 2014 Aniways. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Inspired from http://stackoverflow.com/a/15118452/207682
 */
@interface DSExpandingLabelWithCustomEllipsis : UILabel

@property (nonatomic, copy) NSString *ellipsisText;
@property (nonatomic, copy) NSAttributedString *customEllipsisAttributedText;
@property (nonatomic, copy) void (^didExpandBlock)();

-(void)setTruncatingForNumberOfLines:(int)lines;
@end
