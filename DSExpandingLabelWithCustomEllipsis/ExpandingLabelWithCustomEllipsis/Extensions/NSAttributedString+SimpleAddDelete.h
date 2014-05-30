//
//  NSAttributedString+SimpleAddDelete.h
//  DSExpandingLabelWithCustomEllipsis
//
//  Created by Danny Shmueli on 5/30/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (SimpleAddDelete)

-(NSAttributedString *)attributtedStringByAppendAttributtedString:(NSAttributedString *)stringToAppend;
-(NSAttributedString *)deleteFromEndNumberOfChars:(int)numberOfCharsToDelete;
@end
