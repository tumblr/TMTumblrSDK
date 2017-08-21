//
//  TMSynchronousMockURLSessionTask.h
//  ExampleiOS
//
//  Created by Tyler Tape on 5/3/17.
//  Copyright © 2017 tumblr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMTumblrSDK/TMURLSessionCallbacks.h>

/**
 A mock @c NSURLSessionTask that executes the request's completion block synchronously with dummy response data so we can
 avoid making an async network request
 */
@interface TMSynchronousMockURLSessionTask : NSURLSessionTask

/**
 The completion block of the original task which we want to inject dummy data for
 */
@property (nonatomic, copy) TMURLSessionRequestCompletionHandler completionHandler;

/**
 Designated initializer

 @param data Mock response data
 @param response A mock response object
 @param error A mock error
 @return A new @c TMSynchronousMockURLSessionTask
 */
- (instancetype)initWithDummyData:(NSData *)data dummyResponse:(NSURLResponse *)response dummyError:(NSError *)error;

@end
