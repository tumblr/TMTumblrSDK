//
//  TMMultithreadingTests.m
//  ExampleiOS
//
//  Created by Kenny Ackerson on 2/2/16.
//  Copyright © 2016 tumblr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMURLSession.h"
#import "TMHTTPRequest.h"

@interface TMMultithreadingTests : XCTestCase <TMNetworkActivityIndicatorManager, TMSessionTaskUpdateDelegate>

@end

@implementation TMMultithreadingTests 
- (void)setNetworkActivityIndicatorVisible:(BOOL)networkActivityIndicatorVisible {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = networkActivityIndicatorVisible;
}

- (void)URLSession:(NSURLSessionTask *)task updatedStatusTo:(TMURLSessionTaskState)state {

}

- (void)testMultithreadAccess {
    TMURLSession *sessionManager = [[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                        applicationCredentials:[[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"" consumerSecret:@""]
                                                               userCredentials:[TMAPIUserCredentials new]
                                                        networkActivityManager:self
                                                     sessionTaskUpdateDelegate:self
                                                        sessionMetricsDelegate:nil
                                                            requestTransformer:nil
                                                  customURLSessionDataDelegate:nil
                                                             additionalHeaders:nil];

    dispatch_group_t group =  dispatch_group_create();
    for (NSInteger i = 0; i < 1000; i++) {
        dispatch_group_async(group, dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT), ^{
            @autoreleasepool {

                NSURLSessionTask *session = [sessionManager taskWithRequest:[[TMHTTPRequest alloc] initWithURLString:@"https://google.com" method:TMHTTPRequestMethodGET]
                                                         incrementalHandler:^(NSData * _Nullable data, NSURLSessionDataTask * _Nonnull dataTask) {

                                                         } progressHandler:^(double progress, NSURLSessionTask * _Nonnull dataTask) {

                                                         } completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

                                                         }
                                            ];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [session resume];
                });

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    if (i % 2 == 0) {
                        [session suspend];
                        [session resume];
                    }

                    if (i % 5 == 0) {
                        [session resume];
                        [session cancel];
                    }
                    [session cancel];
                });
                usleep(100);
            }

        });
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)testMultithreadAccessOverTime {
    TMURLSession *sessionManager = [[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                        applicationCredentials:[[TMAPIApplicationCredentials alloc] initWithConsumerKey:@"" consumerSecret:@""]
                                                               userCredentials:[TMAPIUserCredentials new]
                                                        networkActivityManager:self
                                                     sessionTaskUpdateDelegate:self
                                                        sessionMetricsDelegate:nil
                                                            requestTransformer:nil
                                                  customURLSessionDataDelegate:nil
                                                             additionalHeaders:nil];

    dispatch_group_t group =  dispatch_group_create();
    for (NSInteger i = 0; i < 100; i++) {
        dispatch_group_async(group, dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT), ^{
            @autoreleasepool {

                NSURLSessionTask *session = [sessionManager taskWithRequest:[[TMHTTPRequest alloc] initWithURLString:@"https://google.com" method:TMHTTPRequestMethodGET]
                                                         incrementalHandler:^(NSData * _Nullable data, NSURLSessionDataTask * _Nonnull dataTask) {

                                                         } progressHandler:^(double progress, NSURLSessionTask * _Nonnull dataTask) {

                                                         } completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                             
                                                         }];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [session resume];
                    usleep(100);
                });

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    if (i % 2 == 0) {
                        [session suspend];
                        [session resume];
                        usleep(100);
                    }

                    if (i % 5 == 0) {
                        [session resume];
                        [session cancel];
                    }
                    [session cancel];
                });
                usleep(10000);
            }
            
        });
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    sleep(1);
}

@end
