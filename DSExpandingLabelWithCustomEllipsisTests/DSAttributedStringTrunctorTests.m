//
//  DSExpandingLabelWithCustomEllipsisTests.m
//  DSExpandingLabelWithCustomEllipsisTests
//
//  Created by Danny Shmueli on 5/25/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "DSAttributedStringTrunctor.h"
#import "NSAttributedString+NumberOfLines.h"


@interface DSAttributedStringTrunctor (UnitTestsOverrides)
//This is the private method we stub
-(NSNumber *)numberOfLinesForString:(NSAttributedString *)string withEllipsis:(NSAttributedString *)ellipses;

//Target private method to check.
-(NSAttributedString *)trunctate:(NSAttributedString *)stringToTruncate ellipses:(NSAttributedString *)ellipsis numberOfNeededLines:(int)wantedNumberOfLines;

-(NSAttributedString *)addToStringUntilLineIsFull:(NSAttributedString *)stringToExpand
                                         ellipses:(NSAttributedString *)ellipsis numberOfNeededLines:(int)wantedNumberOfLines;

@property (nonatomic, copy) NSAttributedString *fullText;

@end



@interface DSAttributedStringTrunctorTests : XCTestCase

@property (nonatomic, strong) DSAttributedStringTrunctor *target;

@property (nonatomic, copy) NSAttributedString *ellipsis, *fullText;

@end

@implementation DSAttributedStringTrunctorTests

- (void)setUp
{
    [super setUp];
    
    self.ellipsis = [[NSAttributedString alloc] initWithString:@"..More"];
    self.fullText = [[NSAttributedString alloc] initWithString:@"This text is a Three lines text. This text is a Three lines text. This text is a Three lines text."];
    
    self.target = [DSAttributedStringTrunctor new];
}

- (void)tearDown
{
    self.target = nil;
    [super tearDown];
}

- (void)testTruncate_WhenWantedLinesIsLessThanCurrentLines_ShouldReturnNotMoreThanTwoLines
{
    int lineLegnth  = 33;
    [self stubNumberOfLinesForLineLength:lineLegnth forNumberOfLinesForInputText:5 forElipsisLength:self.ellipsis.length];

    int wantedNumberOfLines = 2;
    NSAttributedString *result = [self.target trunctate:self.fullText
                                               ellipses:self.ellipsis
                                    numberOfNeededLines:wantedNumberOfLines];
    
    NSInteger resultPlusElipsisLength = result.length + self.ellipsis.length;
    NSInteger expectedMaxLength = lineLegnth * wantedNumberOfLines;
    XCTAssertTrue(resultPlusElipsisLength <= expectedMaxLength, @"truncated text length: %i should be shorter than %i", resultPlusElipsisLength, wantedNumberOfLines);
}

- (void)testAddToText_WhenTextIsNotFullLine_ShouldAddFromFullTextUntilLineFull
{
    self.target.fullText = self.fullText;
    
    NSAttributedString *shortText = [self.fullText attributedSubstringFromRange:NSMakeRange(0, 50)];

    int lineLegnth  = 33;
    [self stubNumberOfLinesForLineLength:lineLegnth forNumberOfLinesForInputText:3 forElipsisLength:self.ellipsis.length];
    
    NSAttributedString *result = [self.target addToStringUntilLineIsFull:shortText ellipses:self.ellipsis numberOfNeededLines:2];
    NSInteger resultPlusElipsisLength = result.length + self.ellipsis.length;
    XCTAssertTrue(resultPlusElipsisLength == lineLegnth * 2, @"");
}


#pragma mark - Helpers

-(void)stubNumberOfLinesForLineLength:(int)lineLength forNumberOfLinesForInputText:(int)numberOfLinesForInputText forElipsisLength:(int)ellipsesLength
{
    id targretMock = [OCMockObject partialMockForObject:self.target];
    for (int i = 1; i <= numberOfLinesForInputText; i++)
    {
        [[[targretMock  stub] andReturnValue:@(i)] numberOfLinesForString:[OCMArg checkWithBlock:^BOOL(NSAttributedString *string)
        {
            BOOL isInNumberOfLinesRange = string.length > 0 && string.length + ellipsesLength <= lineLength * i ;
            return isInNumberOfLinesRange;
        }] withEllipsis:[OCMArg any]];
        
    }
}

@end
