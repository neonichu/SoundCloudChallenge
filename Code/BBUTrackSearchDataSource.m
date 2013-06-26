//
//  BBUTrackSearchDataSource.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <NSObject+Expectation.h>
#import <SCUI.h>

#import "BBUTrackCell.h"
#import "BBUTrackItem.h"
#import "BBUTrackSearchDataSource.h"

static NSString* const kCellIdentifier = @"trackCell";

@interface BBUTrackSearchDataSource ()

@property NSString* query;
@property NSArray* tracks;

@end

#pragma mark -

@implementation BBUTrackSearchDataSource

-(id)initWithQuery:(NSString *)query {
    self = [super init];
    if (self) {
        self.query = query;
    }
    return self;
}

-(void)refreshWithCompletionHandler:(BBURefreshCompletionHandler)completionHandler {
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:@"https://api.soundcloud.com/tracks.json"]
             usingParameters:@{ @"q": self.query, @"order": @"hotness" }
                 withAccount:[SCSoundCloud account]
      sendingProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
          // TODO: Show some fancy progress
      }
             responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                 if (!responseData) {
                     if (completionHandler) {
                         completionHandler(error);
                     }
                     return;
                 }
                 
                 id tracks = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                 
                 if (!tracks) {
                     if (completionHandler) {
                         completionHandler(error);
                     }
                     return;
                 }
                 
                 NSLog(@"Got %i tracks from SoundCloud API.", [tracks count]);
                 
                 NSMutableArray* tempTracks = [NSMutableArray new];
                 
                 for (id track in [tracks nilUnlessKindOfClass:[NSArray class]]) {
                     NSDictionary* trackData = [track nilUnlessKindOfClass:[NSDictionary class]];
                     if (trackData) {
                         [tempTracks addObject:[BBUTrackItem trackItemWithDictionary:trackData]];
                     }
                 }
                 
                 self.tracks = [tempTracks copy];
                 
                 if (completionHandler) {
                     completionHandler(nil);
                 }
             }];
}

#pragma mark - UICollectionView data source methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBUTrackItem* track = self.tracks[indexPath.row];
    
    BBUTrackCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell.imageView setImageWithURL:track.artworkURL];
    cell.titleLabel.text = track.title;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [collectionView registerClass:[BBUTrackCell class] forCellWithReuseIdentifier:kCellIdentifier];
    return self.tracks.count;
}

#pragma mark - UICollectionView delegate methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BBUTrackItem* track = self.tracks[indexPath.row];
    
    // TODO: Check if SoundCloud app is installed and open track there if it is
    [[UIApplication sharedApplication] openURL:track.permalinkURL];
}

@end
