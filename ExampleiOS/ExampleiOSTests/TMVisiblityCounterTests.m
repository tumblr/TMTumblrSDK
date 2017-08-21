//
//  TMVisiblityCounterTests.m
//  ExampleiOSTests
//
//  Created by Kenny Ackerson on 1/6/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMNetworkActivityVisiblityCounter.h>

@interface TMVisiblityCounterTests : XCTestCase <TMNetworkActivityIndicatorManager>

@property (nonatomic) NSInteger delegateCountTurningOn;
@property (nonatomic) NSInteger delegateCountTurningOff;

@property (nonatomic) NSInteger expectedCountTurningOn;
@property (nonatomic) NSInteger expectedCountTurningOff;

@property (nonatomic) BOOL shouldShowNetworkActivityIndicatorVisible;
@property (nonatomic) XCTestExpectation *testExpectation;

@property (nonatomic) NSInteger updateTimes;

@end

@implementation TMVisiblityCounterTests

- (void)setUp {
    [super setUp];
    self.delegateCountTurningOn = 0;
    self.delegateCountTurningOff = 0;

    self.expectedCountTurningOn = 0;
    self.expectedCountTurningOff = 0;
    
    self.shouldShowNetworkActivityIndicatorVisible = NO;
    self.testExpectation = nil;
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)networkActivityIndicatorVisible {
    if (networkActivityIndicatorVisible) {
        self.delegateCountTurningOn++;
    }
    else {
        self.delegateCountTurningOff++;
    }
    
    if (self.delegateCountTurningOff == self.expectedCountTurningOff && self.delegateCountTurningOn == self.expectedCountTurningOn) {
        [self.testExpectation fulfill];
    }
    
    self.shouldShowNetworkActivityIndicatorVisible = networkActivityIndicatorVisible;
}

- (void)testCounterOnThenCompletedTurnsActivityOff {
    TMNetworkActivityVisiblityCounter *counter = [[TMNetworkActivityVisiblityCounter alloc] initWithNetworkActivityIndicatorManager:self];

    [self addState:TMURLSessionTaskStateRunning toCounter:counter];
    [self addState:TMURLSessionTaskStateStopped toCounter:counter];
    
    self.expectedCountTurningOn = 1;
    self.expectedCountTurningOff = 1;

    self.testExpectation = [self expectationWithDescription:@"Expectation for expected delegate calls"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertTrue(!self.shouldShowNetworkActivityIndicatorVisible);
        XCTAssert(counter.activeCount == 0);
    }];
}

- (void)testCounterRunningMultipleTimesStaysOnAfterOneCompleted {
    TMNetworkActivityVisiblityCounter *counter = [[TMNetworkActivityVisiblityCounter alloc] initWithNetworkActivityIndicatorManager:self];
    
    [self addState:TMURLSessionTaskStateRunning toCounter:counter];
    [self addState:TMURLSessionTaskStateRunning toCounter:counter];
    [self addState:TMURLSessionTaskStateStopped toCounter:counter];
    
    self.expectedCountTurningOn = 1;
    self.expectedCountTurningOff = 0;
    
    self.testExpectation = [self expectationWithDescription:@"Expectation for expected delegate calls"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertTrue(self.shouldShowNetworkActivityIndicatorVisible);
        XCTAssert(counter.activeCount == 1);
    }];
}

- (void)testCounterRunningDoesNotGoNegative {
    TMNetworkActivityVisiblityCounter *counter = [[TMNetworkActivityVisiblityCounter alloc] initWithNetworkActivityIndicatorManager:self];
    
    [self addState:TMURLSessionTaskStateRunning toCounter:counter];
    [self addState:TMURLSessionTaskStateUnknown toCounter:counter];
    [self addState:TMURLSessionTaskStateUnknown toCounter:counter];
    [self addState:TMURLSessionTaskStateStopped toCounter:counter];
    
    self.expectedCountTurningOn = 1;
    self.expectedCountTurningOff = 1;
    
    self.testExpectation = [self expectationWithDescription:@"Expectation for expected delegate calls"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertTrue(!self.shouldShowNetworkActivityIndicatorVisible);
        XCTAssert(counter.activeCount == 0);
    }];
}


#pragma mark Helpers

- (void)addState:(TMURLSessionTaskState)state toCounter:(TMNetworkActivityVisiblityCounter *)counter {
    self.updateTimes++;
    [counter update:state];
}

@end
