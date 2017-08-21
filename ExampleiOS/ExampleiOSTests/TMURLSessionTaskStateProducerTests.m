//
//  TMURLSessionTaskStateProducerTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 1/26/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMURLSessionTaskStateProducer.h>

@interface TMURLSessionTaskStateProducerTests : XCTestCase

@end

@implementation TMURLSessionTaskStateProducerTests

- (void)testRunningOnlyCalledOnce {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:0 callStoppedWithoutRunningThisNumberOftimes:0];
}

- (void)testStoppedWithoutRunningCalledAndCanceling {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateCanceling)] callRunningThisNumberOftimes:0 callStoppedThisNumberOftimes:0 callStoppedWithoutRunningThisNumberOftimes:1];
}

- (void)testStoppedWithoutRunningCalledAndComplete {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateCompleted)] callRunningThisNumberOftimes:0 callStoppedThisNumberOftimes:0 callStoppedWithoutRunningThisNumberOftimes:1];
}

- (void)testRunningCalledTwice {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateRunning)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:0 callStoppedWithoutRunningThisNumberOftimes:0];
}

- (void)testRunningThenCallingCancelingCallsRunningAndStoppedOnce {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCanceling)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:1 callStoppedWithoutRunningThisNumberOftimes:0];
}

- (void)testRunningThenCallingCompleteCallsRunningAndStoppedOnce {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCompleted)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:1 callStoppedWithoutRunningThisNumberOftimes:0];
}

- (void)testRunningThenCallingCompleteTwiceCallsRunningAndStoppedOnce {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCanceling), @(NSURLSessionTaskStateCanceling)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:1 callStoppedWithoutRunningThisNumberOftimes:0];
}

- (void)testRunningThenCallingCompleteTwiceCallsRunningAndStoppedOnceWithCompleted {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCompleted), @(NSURLSessionTaskStateCompleted)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:1 callStoppedWithoutRunningThisNumberOftimes:0];
}

- (void)testRunningThenCallingCompleteTwiceAlternatingCallsRunningAndStoppedOnce {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCanceling), @(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCanceling)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:1 callStoppedWithoutRunningThisNumberOftimes:0];
}

- (void)testRunningThenCallingCompleteTwiceAlternatingCallsRunningAndStoppedOnceWithCompleted {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCompleted), @(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCompleted)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:1 callStoppedWithoutRunningThisNumberOftimes:0];
}

- (void)testRunningThenCallingCompleteTwiceAlternatingCallsRunningAndStoppedOnceAlternatingCompletedAndCanceled {
    [self assertTheseSessionTaskSubmissions:@[@(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCanceling), @(NSURLSessionTaskStateRunning), @(NSURLSessionTaskStateCompleted)] callRunningThisNumberOftimes:1 callStoppedThisNumberOftimes:1 callStoppedWithoutRunningThisNumberOftimes:0];
}

#pragma mark - Helpers

- (void)assertTheseSessionTaskSubmissions:(nonnull NSArray <NSNumber *> *)submissions
             callRunningThisNumberOftimes:(NSInteger)numberOfTimesRunningCalled
             callStoppedThisNumberOftimes:(NSInteger)numberOfTimesStoppedCalled
callStoppedWithoutRunningThisNumberOftimes:(NSInteger)numberOfTimesStoppedWithoutRunningCalled {
    
    [self assertTheseSessionTaskSubmissions:submissions callRunningThisNumberOftimes:numberOfTimesRunningCalled callStoppedThisNumberOftimes:numberOfTimesStoppedCalled callStoppedWithoutRunningThisNumberOftimes:numberOfTimesStoppedWithoutRunningCalled multithreaded:NO];
}

- (void)assertTheseSessionTaskSubmissions:(nonnull NSArray <NSNumber *> *)submissions
             callRunningThisNumberOftimes:(NSInteger)numberOfTimesRunningCalled
             callStoppedThisNumberOftimes:(NSInteger)numberOfTimesStoppedCalled
callStoppedWithoutRunningThisNumberOftimes:(NSInteger)numberOfTimesStoppedWithoutRunningCalled
                            multithreaded:(BOOL)multithreaded {
    
    __block NSInteger numberOfTimesRunningHappened = 0;
    __block NSInteger numberOfTimesStoppedHappened = 0;
    __block NSInteger numberOfTimesStoppedWithoutRunningHappened = 0;
    
    TMURLSessionTaskStateProducer *producer = [[TMURLSessionTaskStateProducer alloc] initWithQueue:dispatch_queue_create("com.tumblr.tests", DISPATCH_QUEUE_SERIAL) handler:^(TMURLSessionTaskState state, NSURLSessionTask * _Nonnull sessionTask) {
        if (state == TMURLSessionTaskStateRunning) {
            numberOfTimesRunningHappened += 1;
        }
        else if (state == TMURLSessionTaskStateStopped) {
            numberOfTimesStoppedHappened += 1;
        }
        else if (state == TMURLSessionTaskStateStoppedWithoutEverRunning) {
            numberOfTimesStoppedWithoutRunningHappened += 1;
        }
    } task:[[NSURLSessionTask alloc] init]];
    
    void (^work)(NSInteger state) = ^(NSInteger state) {
        [producer submitState:state];
    };
    
    if (multithreaded) {
        dispatch_group_t group = dispatch_group_create();
        
        for (NSNumber *number in submissions) {
            dispatch_group_async(group, dispatch_queue_create("my.test.q", DISPATCH_QUEUE_CONCURRENT), ^{
                work([number integerValue]);
            });
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
    else {
        for (NSNumber *number in submissions) {
            work([number integerValue]);
        }
    }

    XCTAssert(numberOfTimesRunningHappened == numberOfTimesRunningCalled);
    XCTAssert(numberOfTimesStoppedHappened == numberOfTimesStoppedCalled);
    XCTAssert(numberOfTimesStoppedWithoutRunningHappened == numberOfTimesStoppedWithoutRunningCalled);
    
}

@end
