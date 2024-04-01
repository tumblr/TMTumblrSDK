//
//  TMConcreteURLSessionTaskDelegateTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 1/29/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMConcreteURLSessionTaskDelegate.h"
#import "TMFakeMetricsDelegate.h"

@interface TMConcreteURLSessionTaskDelegateTests : XCTestCase

@end

@implementation TMConcreteURLSessionTaskDelegateTests

- (void)testSessionMetricsCallsThrough {
    TMFakeMetricsDelegate *delegate = [[TMFakeMetricsDelegate alloc] init];
    TMConcreteURLSessionTaskDelegate *concreteDelegate = [[TMConcreteURLSessionTaskDelegate alloc] initWithSessionMetricsDelegate:delegate];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL new]]];

    NSURLSessionTaskMetrics *metrics = [[NSURLSessionTaskMetrics alloc] init];

    [concreteDelegate URLSession:session task:dataTask didFinishCollectingMetrics:metrics];

    XCTAssertEqual(delegate.metrics, metrics);
    XCTAssertEqual(delegate.task, dataTask);

}

- (void)testDataIsCorrectOnCompletion {
    TMConcreteURLSessionTaskDelegate *concreteDelegate = [[TMConcreteURLSessionTaskDelegate alloc] init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL new]]];

    int *bytes = malloc(sizeof(int) * 2);
    bytes[0] = 1;
    bytes[1] = 0;

    NSData *myData = [[NSData alloc] initWithBytes:bytes length:sizeof(int) * 2];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Finished "];

    [concreteDelegate addSessionTask:dataTask completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        int originalData = bytes[0];
        int gotData = ((int *)data.bytes)[0];

        int originalDataTwo = bytes[1];
        int gotDataTwo = ((int *)data.bytes)[1];

        XCTAssert(originalData == gotData && originalDataTwo == gotDataTwo);
        [expectation fulfill];
    } incrementalHandler:^(NSData * _Nullable data, NSURLSessionDataTask * _Nonnull dataTask) { }
    progressHandler:^(double progress, NSURLSessionTask * _Nonnull dataTask) { }];

    [concreteDelegate URLSession:session dataTask:dataTask didReceiveData:myData];
    [concreteDelegate URLSession:session task:dataTask didCompleteWithError:nil];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        XCTAssert(!error);
    }];
    
    free(bytes);
}

- (void)testBothHandlersAreCalled {
    TMConcreteURLSessionTaskDelegate *concreteDelegate = [[TMConcreteURLSessionTaskDelegate alloc] init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL new]]];

    XCTestExpectation *incrementalExpectation = [self expectationWithDescription:@"Called incremental"];
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Called Completion"];

    [concreteDelegate addSessionTask:dataTask completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [completionExpectation fulfill];
    } incrementalHandler:^(NSData * _Nullable data, NSURLSessionDataTask * _Nonnull dataTask) {
        [incrementalExpectation fulfill];
    }
     progressHandler:^(double progress, NSURLSessionTask * _Nonnull dataTask) { }];

    [concreteDelegate URLSession:session dataTask:dataTask didReceiveData:[[NSData alloc] init]];
    [concreteDelegate URLSession:session task:dataTask didCompleteWithError:nil];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        XCTAssert(!error);
    }];
}

- (void)testAllHandlersAreCalled {
    TMConcreteURLSessionTaskDelegate *concreteDelegate = [[TMConcreteURLSessionTaskDelegate alloc] init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL new]]];

    XCTestExpectation *incrementalExpectation = [self expectationWithDescription:@"Called incremental"];
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Called Completion"];
    XCTestExpectation *progressExpectation = [self expectationWithDescription:@"Called progress handler"];

    [concreteDelegate addSessionTask:dataTask completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [completionExpectation fulfill];
    } incrementalHandler:^(NSData * _Nullable data, NSURLSessionDataTask * _Nonnull dataTask) {
        [incrementalExpectation fulfill];
    }
                     progressHandler:^(double progress, NSURLSessionTask * _Nonnull dataTask) {
                         [progressExpectation fulfill];
                     }];

    [concreteDelegate URLSession:session dataTask:dataTask didReceiveData:[[NSData alloc] init]];
    [concreteDelegate URLSession:session task:dataTask didSendBodyData:3 totalBytesSent:8 totalBytesExpectedToSend:11];
    [concreteDelegate URLSession:session task:dataTask didCompleteWithError:nil];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        XCTAssert(!error);
    }];
}

@end
