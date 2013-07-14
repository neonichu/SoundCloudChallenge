//
//  BBUTrackSearchDataSource.h
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BBURefreshCompletionHandler)(NSError* error);

@interface BBUTrackSearchDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

-(void)clear;
-(id)initWithQuery:(NSString*)query;
-(void)refreshWithCompletionHandler:(BBURefreshCompletionHandler)completionHandler;
-(NSArray*)tracks;

@end
