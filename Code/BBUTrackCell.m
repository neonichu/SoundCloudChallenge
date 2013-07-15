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
@property (nonatomic) UIImageView* flipSideImageView;
@property BOOL flipSideVisible;
@property (nonatomic) UIImageView* imageView;
@property (nonatomic) UILabel* titleLabel;
@property UIImageView* zoomingImageView;

@end

#pragma mark -

@implementation BBUTrackCell

-(UIImageView *)flipSideImageView {
    if (!_flipSideImageView) {
        _flipSideImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _flipSideImageView.layer.doubleSided = NO;
        _flipSideImageView.userInteractionEnabled = YES;
        
        [_flipSideImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(longPressed:)]];
    }
    
    return _flipSideImageView;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _imageView.backgroundColor = [UIColor sc_color];
        _imageView.layer.doubleSided = NO;
        _imageView.userInteractionEnabled = YES;
        
        [_imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(longPressed:)]];
    }
    
    return _imageView;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        self.contentView.layer.borderWidth = 1.0;
        
        [self.contentView addSubview:self.flipSideImageView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        
        self.zoomingImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView insertSubview:self.zoomingImageView atIndex:0];
    }
    return self;
}

-(void)layoutSubviews {
    self.imageView.size = self.frame.size;
    self.imageView.width -= 2.0;
    self.imageView.height -= kDefaultTitleHeight;
    self.imageView.x = 1.0;
    
    self.flipSideImageView.frame = self.imageView.frame;
    self.zoomingImageView.frame = self.imageView.frame;
    
    self.titleLabel.width = self.imageView.width - 10.0;
    self.titleLabel.y = self.height - self.titleLabel.height;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, self.height - kDefaultTitleHeight,
                                                                0.0, kDefaultTitleHeight)];
        
        _titleLabel.font = [UIFont fontWithName:@"Avenir" size:10.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
    }
    
    return _titleLabel;
}

#pragma mark - Zoom gesture

-(void)longPressed:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [self stopAnimating];
    [self.contentView bringSubviewToFront:self.zoomingImageView];
    self.zoomingImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:1.0 animations:^{
        self.zoomingImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (!finished) {
            [self resetZoomAnimation];
            return;
        }
        
        [UIView animateWithDuration:1.0 animations:^{
            self.zoomingImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [self resetZoomAnimation];
        }];
    }];
}

-(void)resetZoomAnimation {
    self.zoomingImageView.transform = CGAffineTransformIdentity;
    [self.contentView sendSubviewToBack:self.zoomingImageView];
    [self startAnimating];
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
        [self.contentView insertSubview:viewToReset belowSubview:topView];
        
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

-(void)stopAnimating {
    [self.flipSideImageView.layer removeAllAnimations];
    [self.imageView.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startFlipAnimation) object:nil];
}

@end
