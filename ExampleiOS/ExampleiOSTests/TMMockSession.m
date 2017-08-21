//
//  TMMockSession.m
//  ExampleiOS
//
//  Created by Tyler Tape on 5/3/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import "TMMockSession.h"
#import <TMTumblrSDK/TMRequest.h>
#import "TMNetworkActivityVisiblityCounter.h"

@interface TMMockSession ()

@property (nonatomic) NSDictionary *taskDictionary;

@end

@implementation TMMockSession

- (instancetype)initWithMockTaskDictionary:(NSDictionary *)taskDictionary {
    self = [super init];
    if (self) {
        _taskDictionary = taskDictionary;
    }
    return self;
}

- (BOOL)canSignRequests {
    return NO;
}

- (nullable TMNetworkActivityVisiblityCounter *)networkActivityVisibilityCounter {
    return nil;
}

- (NSURLRequest *)paramaterizedRequestFromRequest:(id<TMRequest>)request {
    NSAssert(NO, @"paramaterizedRequestFromRequest not implemented");
    return nil;
}

- (nonnull NSURLSessionTask *)taskWithRequest:(nonnull id <TMRequest>)request
                            completionHandler:(nonnull TMURLSessionRequestCompletionHandler)completionHandler {
    TMSynchronousMockURLSessionTask *task = self.taskDictionary[request.URL.absoluteString];
    task.completionHandler = completionHandler;
    return task;
}

- (instancetype)copyWithNewConfiguration:(NSURLSessionConfiguration *)configuration {
    NSAssert(NO, @"copyWithNewConfiguration not implemented");
    return nil;
}

- (nonnull NSURLSessionTask *)taskWithRequest:(nonnull id <TMRequest>)request
                           incrementalHandler:(nonnull TMURLSessionRequestIncrementedHandler)incrementalHandler
                              progressHandler:(nonnull TMURLSessionRequestProgressHandler)progressHandler
                            completionHandler:(nonnull TMURLSessionRequestCompletionHandler)completionHandler {
    NSAssert(NO, @"taskWithRequest:incrementalHandler:progressHandler:completionHandler not implemented");
    return nil;
}

@end
