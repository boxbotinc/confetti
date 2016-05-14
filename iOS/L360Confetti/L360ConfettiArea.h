//
//  L360ConfettiView.h
//  L360ConfettiExample
//
//  Created by Mohammed Islam on 12/11/14.
//  Copyright (c) 2014 Life360. All rights reserved.
//

#import <UIKit/UIKit.h>

@class L360ConfettiArea;

@interface L360ConfettiArea : UIView

- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray *)colors;

// Convenience method
- (void)blastFrom:(CGPoint)point numberOfConfetti:(NSInteger)numberOfConfetti;

/**
 *  Use this to shoot confetti out towards some general direction with some specific force
 *  The width determines the square size of the confetti.
 *
 *  @angle      The general angle (in radians) with which the confetti will blast out from.
 *  @force      The force in which the confetti will blast out at. Ranges of 100-1000 is normal.
 */
- (void)blastFrom:(CGPoint)point angle:(CGFloat)angle spread:(CGFloat)spread force:(CGFloat)force numberOfConfetti:(NSInteger)numberOfConfetti;

/**
 *  This is the upper limit on how much the confetti sways 
 *  (the actual number per confetti is a random number between 0.0 and this value
 *  This is for iPad/iPhone6+ implementations where the swaying of the confetti will seem too small as compared to iPhone
 *  DEFAULT: 50.0
 */
@property (nonatomic, assign) CGFloat swayLength;

/**
 *  This determines the spread of blastFrom:towards:withForce:confettiWidth:numberOfConfetti.
 *  It's basically the blast angle + or - this value in Radians
 *  DEFAULT: 0.1
 */
@property (nonatomic, assign) CGFloat blastSpread;

@property (nonatomic, assign) CGFloat confettiWidth;

@end
