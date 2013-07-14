//
//  BBUTrackItem.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <NSObject+Expectation.h>

#import "BBUTrackItem.h"

@interface BBUTrackItem ()

@property NSURL* artworkURL;
@property NSURL* avatarURL;
@property NSNumber* identifier;
@property NSURL* permalinkURL;
@property NSString* title;
@property NSURL* waveformURL;

@end

#pragma mark -

@implementation BBUTrackItem

+(NSURL*)safeURLFromString:(NSString*)urlString {
    urlString = [urlString nilUnlessKindOfClass:[NSString class]];
    
    if (!urlString) {
        return nil;
    }
    
    return [NSURL URLWithString:urlString];
}

+(instancetype)trackItemWithDictionary:(NSDictionary *)dictionary {
    return [[[self class] alloc] initWithDictionary:dictionary];
}

#pragma mark -

-(NSString *)description {
    return [NSString stringWithFormat:@"BBUTrackItem %@ (%@)", self.title, self.identifier];
}

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.artworkURL = [[self class] safeURLFromString:dictionary[@"artwork_url"]];
        self.avatarURL = [[self class] safeURLFromString:dictionary[@"user"][@"avatar_url"]];
        self.identifier = [dictionary[@"id"] nilUnlessKindOfClass:[NSNumber class]];
        self.permalinkURL = [[self class] safeURLFromString:dictionary[@"permalink_url"]];
        self.title = [dictionary[@"title"] nilUnlessKindOfClass:[NSString class]];
        self.waveformURL = [[self class] safeURLFromString:dictionary[@"waveform_url"]];
    }
    return self;
}

@end
