//
//  TMNetworkSpeedTrackerTests.m
//  Tests
//
//  Created by Ken Krzeminski on 12/19/17.
//  Copyright © 2017 Tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMNetworkSpeedTracker.h>

// Testable tracker for receiving multiple events
@interface TestableTMNetworkSpeedTracker : TMNetworkSpeedTracker

@end

@implementation TestableTMNetworkSpeedTracker

+ (NSMutableArray *)sharedArray {
    static dispatch_once_t once;
    static NSMutableArray *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

@end

// Testable tracker for testing the state before 10 events are reached
@interface TestableEmptyTMNetworkSpeedTracker : TMNetworkSpeedTracker

@end

@implementation TestableEmptyTMNetworkSpeedTracker

+ (NSMutableArray *)sharedArray {
    static dispatch_once_t once;
    static NSMutableArray *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

@end


@interface TMNetworkSpeedTrackerTests : XCTestCase


@end

// Test constants

// Number of bytes transferred in a mock response
const short tinyPayload = 10;
const short oneKBPayload = 1024;
const short badStatePayload = 18750;
const int moderateStatePayload = 68750;
const int goodStatePayload = 68751;

// Time interval for transfers
const float timeInterval = 1.0;

@implementation TMNetworkSpeedTrackerTests

- (void)testUnknownQualityState {
    TMNetworkSpeedTracker *testEmptyTracker = [[TestableEmptyTMNetworkSpeedTracker alloc] init];
    NSDate* start = [NSDate date];
    NSDate* endDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:start];

    XCTAssertEqual([TestableEmptyTMNetworkSpeedTracker quality], TMNetworkSpeedQualityUnkown,
                   "Received a network quality other than 'unknown' with no tracked network speed rates.");

    for (int i = 0; i < 20; i++) {
        [testEmptyTracker track:start endDate:endDate bytes:tinyPayload];
    }
    XCTAssertEqual([TestableEmptyTMNetworkSpeedTracker quality], TMNetworkSpeedQualityUnkown,
                   "Quality was tracked when a series of requests smaller than the trackable payload size were received.");

    [testEmptyTracker track:start endDate:endDate bytes:oneKBPayload];
    XCTAssertEqual([TestableEmptyTMNetworkSpeedTracker quality], TMNetworkSpeedQualityUnkown,
                   "Received a network quality other than 'unknown' with only one tracked network speed rate.");

    // The tracker should only send back a state other than "Unknown" when it receives 10 requests.
    for (int i = 0; i < 8; i++) {
        [testEmptyTracker track:start endDate:endDate bytes:oneKBPayload];
    }
    XCTAssertEqual([TestableEmptyTMNetworkSpeedTracker quality], TMNetworkSpeedQualityUnkown,
                   "After receiving at 9 requests that are 1 KB in size, the tracker sending back a quality other than 'Unknown'.");

    [testEmptyTracker track:start endDate:endDate bytes:oneKBPayload];
    XCTAssertNotEqual([TestableEmptyTMNetworkSpeedTracker quality], TMNetworkSpeedQualityUnkown,
                      "After receiving at 10 requests that are 1 KB in size, the tracker sending back an 'Unknown' network quality.");
}

- (void)testBadQualityState {
    TMNetworkSpeedTracker *testTracker = [[TestableTMNetworkSpeedTracker alloc] init];
    NSDate* start = [NSDate date];
    NSDate* endDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:start];

    for (int i = 0; i < 10; i++) {
        [testTracker track:start endDate:endDate bytes:badStatePayload];
    }

    XCTAssertEqual([TestableTMNetworkSpeedTracker quality], TMNetworkSpeedQualityBad,
                   "150 kbps was not rated as 'Bad'.");
}

- (void)testModerateQualityState {
    TMNetworkSpeedTracker *testTracker = [[TestableTMNetworkSpeedTracker alloc] init];
    NSDate* start = [NSDate date];
    NSDate* endDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:start];

    for (int i = 0; i < 10; i++) {
        [testTracker track:start endDate:endDate bytes:moderateStatePayload];
    }

    XCTAssertEqual([TestableTMNetworkSpeedTracker quality], TMNetworkSpeedQualityModerate,
                   "550 kbps was not rated as 'Moderate'.");
}

- (void)testGoodQualityState {
    TMNetworkSpeedTracker *testTracker = [[TestableTMNetworkSpeedTracker alloc] init];
    NSDate* start = [NSDate date];
    NSDate* endDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:start];

    for (int i = 0; i < 10; i++) {
        [testTracker track:start endDate:endDate bytes:goodStatePayload];
    }

    XCTAssertEqual([TestableTMNetworkSpeedTracker quality], TMNetworkSpeedQualityGood,
                   "> 550 kbps was not rated as 'Good'.");
}

@end
