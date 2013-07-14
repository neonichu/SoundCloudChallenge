//
//  BBUTrackCell.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 27.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BBUTrackCell.h"

static const CGFloat kDefaultTitleHeight = 20.0;

@interface BBUTrackCell ()

@property (getter = isAnimating) BOOL animating;
@property UIImageView* flipSideImageView;
@property BOOL flipSideVisible;
@property UIImageView* imageView;
@property UILabel* titleLabel;

@end

#pragma mark -

@implementation BBUTrackCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        self.contentView.layer.borderWidth = 1.0;
        
        self.flipSideImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.flipSideImageView.layer.doubleSided = NO;
        [self.contentView addSubview:self.flipSideImageView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor sc_color];
        self.imageView.layer.doubleSided = NO;
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.height - kDefaultTitleHeight,
                                                                    self.imageView.width, kDefaultTitleHeight)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

-(void)layoutSubviews {
    self.imageView.size = self.frame.size;
    self.imageView.width -= 2.0;
    self.imageView.height -= kDefaultTitleHeight;
    self.imageView.x = 1.0;
    
    self.flipSideImageView.frame = self.imageView.frame;
    
    self.titleLabel.y = self.height - self.titleLabel.height;
}

#pragma mark - Flip animation

-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    if (finished) {
        UIView *topView = self.imageView, *viewToReset = self.flipSideImageView;
        
        if (self.flipSideVisible) {
            topView = self.flipSideImageView;
            viewToReset = self.imageView;
        }
        
        viewToReset.layer.transform = CATransform3DIdentity;
        viewToReset.layer.zPosition = 0;
        [self insertSubview:viewToReset belowSubview:topView];
        
        [self startAnimating];
    }
    
    self.animating = NO;
}

+(CAAnimation*)flipAnimationForView:(UIView*)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D oldTransform = view.layer.transform;
    CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    transform.m34 = 10.0 / 800.0;
    view.layer.transform = transform;
    
    animation.duration = 0.5;
    animation.fromValue = [NSValue valueWithCATransform3D:oldTransform];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    view.layer.zPosition = 100;
    
    return animation;
}

-(void)startAnimating {
    NSTimeInterval nextTime = (float)(arc4random_uniform(120) + 30) / 60.0;
    [self performSelector:@selector(startFlipAnimation) withObject:nil afterDelay:nextTime];
}

-(void)startFlipAnimation {
    if (self.animating) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    UIView *backView = self.flipSideImageView, *targetView = self.imageView;
    
    if (self.flipSideVisible) {
        backView = self.imageView;
        targetView = self.flipSideImageView;
    }
    
    backView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        backView.alpha = 1.0;
    }];
    
    CAAnimation* animation = [[self class] flipAnimationForView:targetView];
    animation.delegate = self;
    [targetView.layer addAnimation:animation forKey:@"flip"];
    
    self.animating = YES;
    self.flipSideVisible = !self.flipSideVisible;
}

@end
