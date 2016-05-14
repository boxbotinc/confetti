//
//  ViewControllerConfettiPlayground.m
//  L360ConfettiExample
//
//  Created by Mohammed Islam on 12/12/14.
//  Copyright (c) 2014 Life360. All rights reserved.
//

#import "ViewControllerConfettiPlayground.h"
#import "L360ConfettiArea.h"

@interface ViewControllerConfettiPlayground ()

@property (nonatomic, strong) L360ConfettiArea *confettiView;

@end

@implementation ViewControllerConfettiPlayground

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Inset the view a bit to make sure that the point conversion is working properly on taps
    self.confettiView = [[L360ConfettiArea alloc] initWithFrame:CGRectMake(0.0,
                                                                           100.0,
                                                                           self.view.frame.size.width,
                                                                           self.view.frame.size.height - 100.0 - 100.0)];
    // make the boundaries of the area clear
    self.confettiView.layer.borderWidth = 1.0;
    self.confettiView.layer.borderColor = [UIColor blackColor].CGColor;
    self.confettiView.swayLength = 20.0;
    
    [self.view addSubview:self.confettiView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UILabel *life360Label = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                      self.confettiView.frame.origin.y + self.confettiView.frame.size.height,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height - (self.confettiView.frame.origin.y + self.confettiView.frame.size.height))];
    life360Label.text = @"Life360 RoX!!";
    life360Label.font = [UIFont fontWithName:@"Helvetica" size:22.0];
    life360Label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:life360Label];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeWindow)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"make sure all the confetti are cleaned up properly here using debugger");
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    CGPoint tapPoint = [recognizer locationInView:self.view];
    
    // Make sure to convert the point so to account for the subview properly
    
    // Test Bursts
//    [self.confettiView burstAt:[self.view convertPoint:tapPoint toView:self.confettiView]
//                  confettiWidth:10.0
//              numberOfConfetti:60];
    
    // Test blasts
    self.confettiView.blastSpread = 0.3;
    [self.confettiView blastFrom:[self.view convertPoint:tapPoint toView:self.confettiView]
                numberOfConfetti:60];
}

- (void)closeWindow
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
