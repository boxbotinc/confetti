//
//  L360ConfettiView.m
//  L360ConfettiExample
//
//  Created by Mohammed Islam on 12/11/14.
//  Copyright (c) 2014 Life360. All rights reserved.
//

#import "L360ConfettiArea.h"
#import "L360ConfettiObject.h"
#import "L360ConfettiView.h"

@interface L360ConfettiArea () <L360ConfettiObjectDelegate>

// Need to hold reference to the L360ConfettiObjects while they animate
@property (nonatomic, strong) NSMutableSet *confettiObjectsCache;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;

@property (nonatomic, strong) NSArray *colors;

@end

@implementation L360ConfettiArea

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame colors:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray *)colors {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    if (colors) {
        self.colors = colors;
    }
    
    return self;
}

- (void)commonInit {
    self.userInteractionEnabled = NO;
    
    self.swayLength = 40.0f;
    self.blastSpread = 0.1f;
    self.confettiWidth = 10.0f;
    self.confettiObjectsCache = [NSMutableSet new];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    // Create gravity behavior. Don't add till view did appear
    self.gravityBehavior = [UIGravityBehavior new];
    self.gravityBehavior.magnitude = 0.5;
    
    [self.animator addBehavior:self.gravityBehavior];
    
    self.colors = @[[UIColor redColor],
                    [UIColor blueColor],
                    [UIColor greenColor],
                    [UIColor orangeColor],
                    [UIColor purpleColor],
                    [UIColor magentaColor],
                    [UIColor cyanColor],];
}

#pragma mark - Blast off!
- (void)blastFrom:(CGPoint)point numberOfConfetti:(NSInteger)numberOfConfetti {
    [self blastFrom:point angle:M_PI / 2.0f spread:self.blastSpread force:500.0f numberOfConfetti:numberOfConfetti];
}

- (void)blastFrom:(CGPoint)point angle:(CGFloat)angle spread:(CGFloat)spread force:(CGFloat)force numberOfConfetti:(NSInteger)numberOfConfetti {
    NSMutableArray *confettiObjects = [NSMutableArray array];
    
    __weak L360ConfettiArea *weakSelf = self;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        for (NSInteger i = 0; i < numberOfConfetti; i++) {
            CGFloat randomWidth = weakSelf.confettiWidth + [weakSelf randomFloatBetween:-(weakSelf.confettiWidth / 2.0) and:2.0];
            CGRect confettiFrame = CGRectMake(point.x,
                                              point.y,
                                              randomWidth,
                                              randomWidth);
            
            // Create the confetti view with the random properties
            L360ConfettiView *confettiView = [[L360ConfettiView alloc] initWithFrame:confettiFrame
                                                                    withFlutterSpeed:[weakSelf randomFloatBetween:1.0 and:5.0]
                                                                         flutterType:[weakSelf randomIntegerFrom:0 to:L360ConfettiFlutterTypeCount]];
            confettiView.backgroundColor = weakSelf.colors[[weakSelf randomIntegerFrom:0 to:weakSelf.colors.count]];
            
            // Each view is associated with an object that handles how the confetti falls
            L360ConfettiObject *confettiObject = [[L360ConfettiObject alloc] initWithConfettiView:confettiView
                                                                                 keepWithinBounds:weakSelf.bounds
                                                                                         animator:weakSelf.animator
                                                                                          gravity:weakSelf.gravityBehavior];
            
            CGFloat confettiForce = [weakSelf randomFloatBetween:force - (force * 0.3) and:force];
            CGFloat vectorForceXmin = confettiForce * cos(angle - spread);
            CGFloat vectorForceXmax = confettiForce * cos(angle + spread);
            CGFloat vectorForceYmin = -confettiForce * sin(angle - spread);
            CGFloat vectorForceYmax = -confettiForce * sin(angle + spread);
            
            confettiObject.linearVelocity = CGPointMake([weakSelf randomFloatBetween:vectorForceXmin and:vectorForceXmax],
                                                        [weakSelf randomFloatBetween:vectorForceYmin and:vectorForceYmax]);
            confettiObject.density = [weakSelf randomFloatBetween:0.2 and:1.0];
            confettiObject.swayLength = [weakSelf randomFloatBetween:0.0 and:weakSelf.swayLength];
            confettiObject.delegate = weakSelf;
            
            [confettiObjects addObject:confettiObject];
            [weakSelf.confettiObjectsCache addObject:confettiObject];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [weakSelf addSubview:confettiView];
                // Add the confetti object behavior to the animator and the view to gravity behavior
                [weakSelf.animator addBehavior:confettiObject.fallingBehavior];
                [weakSelf.gravityBehavior addItem:confettiView];
            });
        }
    });
}

#pragma mark - L360ConfettiObjectDelegate
- (void)needToDeallocateConfettiObject:(L360ConfettiObject *)confettiObject {
    [self.confettiObjectsCache removeObject:confettiObject];
    confettiObject = nil;
}

#pragma mark - Helpers
- (CGFloat)randomFloatBetween:(CGFloat)smallNumber and:(CGFloat)bigNumber {
    CGFloat diff = bigNumber - smallNumber;
    return (((CGFloat) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (NSInteger)randomIntegerFrom:(NSInteger)fromInteger to:(NSInteger)toInteger {
    if (fromInteger == toInteger) {
        return fromInteger;
    }
    
    return fromInteger + arc4random() % (toInteger - fromInteger);
}

@end
