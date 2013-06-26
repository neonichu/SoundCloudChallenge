//
//  BBUTrackItem.h
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBUTrackItem : NSObject

+(instancetype)trackItemWithDictionary:(NSDictionary*)dictionary;

-(NSURL*)artworkURL;
-(NSURL*)avatarURL;
-(NSString*)identifier;
-(NSURL*)permalinkURL;
-(NSString*)title;
-(NSURL*)waveformURL;

@end
