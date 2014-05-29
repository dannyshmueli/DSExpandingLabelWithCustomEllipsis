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


@interface DSAttributedStringTrunctorTests : XCTestCase

@property (nonatomic, strong) DSAttributedStringTrunctor *target;

@end

@implementation DSAttributedStringTrunctorTests

- (void)setUp
{
    [super setUp];
    self.target = [DSAttributedStringTrunctor new];
}

- (void)tearDown
{
    self.target = nil;
    [super tearDown];
}

- (void)testExample
{
    id mock = [OCMockObject mockForClass:[NSAttributedString class]];
    [[[mock stub] numberOfLinesNeededWithSize:[OCMArg any] oneLineHeight:[OCMArg any]];
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
