//
//  BBUTrackCell.h
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 27.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBUTrackCell : UICollectionViewCell

-(UIImageView*)flipSideImageView;
-(UIImageView*)imageView;
-(void)startAnimating;
-(void)stopAnimating;
-(UILabel*)titleLabel;
-(UIImageView*)zoomingImageView;

@end
