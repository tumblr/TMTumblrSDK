//
//  TMURLSessionTaskObserverTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 6/13/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TMTumblrSDK/TMURLSessionTaskObserver.h>

@interface TMURLSessionTaskObserverTests : XCTestCase

@end

@implementation TMURLSessionTaskObserverTests

- (void)testDeallocDoesntCrash {
    TMURLSessionTaskObserver *observer = [[TMURLSessionTaskObserver alloc] initWithTask:[[NSURLSessionTask alloc] init] updateQueue:dispatch_queue_create("com.tumblr.tests", DISPATCH_QUEUE_CONCURRENT) updateHandler:^(TMURLSessionTaskState state, NSURLSessionTask * _Nonnull sessionTask) {

    }];

    observer = nil;
}

- (void)testKVOSuperCallThrowsException {
    TMURLSessionTaskObserver *observer = [[TMURLSessionTaskObserver alloc] initWithTask:[[NSURLSessionTask alloc] init] updateQueue:dispatch_queue_create("com.tumblr.tests", DISPATCH_QUEUE_CONCURRENT) updateHandler:^(TMURLSessionTaskState state, NSURLSessionTask * _Nonnull sessionTask) {

    }];

    /**
     *  We call the super method if we dont handle, which is the correct implementation - however it is supposed to throw an exception because it was never handled.
     */
    XCTAssertThrows([observer observeValueForKeyPath:@"retainCount" ofObject:[NSObject new] change:nil context:nil]);

}

@end
