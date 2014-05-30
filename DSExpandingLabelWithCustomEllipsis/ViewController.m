//
//  ViewController.m
//  DSExpandingLabelWithCustomEllipsis
//
//  Created by Danny Shmueli on 5/25/14.
//  Copyright (c) 2014 Danny Shmueli. All rights reserved.
//

#import "ViewController.h"
#import "DSExpandingLabelWithCustomEllipsis.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet DSExpandingLabelWithCustomEllipsis *myExpandingLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSAttributedString *loremIpsum = [[NSAttributedString alloc] initWithString: @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. In euismod tortor neque, id iaculis risus fermentum et. Donec vulputate, lectus sit amet venenatis mattis, tellus diam volutpat purus, suscipit ultricies leo massa nec massa. Suspendisse imperdiet sit amet sem vel porta. Phasellus accumsan felis vitae nulla consectetur, vehicula" attributes:@{NSFontAttributeName: self.myExpandingLabel.font}];
    
	NSMutableAttributedString *customEllipsis = [[NSMutableAttributedString alloc] initWithString:@"!!!More"];
    [customEllipsis addAttribute:NSFontAttributeName
                           value:[UIFont boldSystemFontOfSize:self.myExpandingLabel.font.pointSize]
                           range:NSMakeRange(3, 4)];
    
    
    self.myExpandingLabel.customEllipsisAttributedText = customEllipsis;
    self.myExpandingLabel.attributedText = loremIpsum;
    self.myExpandingLabel.didExpandBlock = ^(){
        NSLog(@"did tap label");
    };
    [self.myExpandingLabel setTruncatingForNumberOfLines:2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
