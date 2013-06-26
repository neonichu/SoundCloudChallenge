//
//  BBUTrackCell.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 27.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUTrackCell.h"

static const CGFloat kDefaultTitleHeight = 20.0;

@interface BBUTrackCell ()

@property UIImageView* imageView;
@property UILabel* titleLabel;

@end

#pragma mark -

@implementation BBUTrackCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.imageView.height - kDefaultTitleHeight,
                                                                    self.imageView.width, kDefaultTitleHeight)];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

-(void)layoutSubviews {
    self.imageView.size = self.frame.size;
    self.titleLabel.y = self.imageView.height - self.titleLabel.height;
}

@end
