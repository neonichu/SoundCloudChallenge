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

#define XCTFail STFail

typedef SenTestCase XCTestCase;
#endif

@interface SoundCloudChallengeTests : XCTestCase

@end

#pragma mark -

@implementation SoundCloudChallengeTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
