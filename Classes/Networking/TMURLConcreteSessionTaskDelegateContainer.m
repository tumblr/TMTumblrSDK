//
//  TMURLConcreteSessionTaskDelegateContainer.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/28/16.
//
//

#import "TMURLConcreteSessionTaskDelegateContainer.h"

@implementation TMURLConcreteSessionTaskDelegateContainer

- (nonnull instancetype)initWithCompletionHandler:(nonnull TMURLSessionRequestCompletionHandler)completionHandler
                               incrementalHandler:(nonnull TMURLSessionRequestIncrementedHandler)incrementalHandler
                                  progressHandler:(nonnull  TMURLSessionRequestProgressHandler)progressHandler
                                             data:(nonnull NSMutableData *)data {
    NSParameterAssert(completionHandler);
    NSParameterAssert(incrementalHandler);
    NSParameterAssert(progressHandler);
    NSParameterAssert(data);
    self = [super init];

    if (self) {
        _completionHandler = [completionHandler copy];
        _incrementalHandler = [incrementalHandler copy];
        _progressHandler = [progressHandler copy];
        _data = data;
    }
    
    return self;
}

@end
