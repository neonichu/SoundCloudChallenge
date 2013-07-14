//
//  BBUTrackSearch.h
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 14.07.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBUTrackSearch : UICollectionReusableView

@property (nonatomic, weak) id<UISearchBarDelegate> delegate;
@property NSString* text;

@end
