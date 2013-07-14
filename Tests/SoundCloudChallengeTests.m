//
//  SoundCloudChallengeTests.m
//  SoundCloudChallengeTests
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#ifdef __IPHONE_7_0
#import <XCTest/XCTest.h>
#else 
#import <SenTestingKit/SenTestingKit.h>

#define XCTAssertEqualObjects STAssertEqualObjects
#define XCTAssertNil STAssertNil
#define XCTFail STFail

typedef SenTestCase XCTestCase;
#endif

#import "BBUTrackItem.h"

@interface SoundCloudChallengeTests : XCTestCase

@end

#pragma mark -

@implementation SoundCloudChallengeTests

-(void)testTrackItem {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"SampleTrackResponse" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    BBUTrackItem* trackItem = [BBUTrackItem trackItemWithDictionary:dictionary];
    
    XCTAssertNil(trackItem.artworkURL, @"Error in artworkURL");
    XCTAssertEqualObjects([NSURL URLWithString:@"https://i1.sndcdn.com/avatars-000006288728-hy3g41-large.jpg?cc07a88"],
                          trackItem.avatarURL, @"Error in avatarURL");
    XCTAssertEqualObjects(@(100769720), trackItem.identifier, @"Error in identifier");
    XCTAssertEqualObjects([NSURL URLWithString:@"http://soundcloud.com/scott-capurro/test-run-of-comedy"],
                          trackItem.permalinkURL, @"Error in permalinkURL");
    XCTAssertEqualObjects(@"Test run of comedy", trackItem.title, @"Error in title");
    XCTAssertEqualObjects([NSURL URLWithString:@"https://w1.sndcdn.com/L6v9gN4tkbpq_m.png"],
                          trackItem.waveformURL, @"Error waveformURL");
}

@end
