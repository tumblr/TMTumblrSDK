//
//  TMConcreteURLSessionTaskDelegate.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/28/16.
//
//

#import <Foundation/Foundation.h>
#import "TMURLConcreteSessionTaskDelegateContainer.h"

@protocol TMURLSessionMetricsDelegate;

/**
 *  A concrete delegate for @c NSURLSession that can give incremental and completion updates.
 */
__attribute__((objc_subclassing_restricted))
@interface TMConcreteURLSessionTaskDelegate : NSObject <NSURLSessionDataDelegate>

/**
 *  Initializes an instance of @c TMConcreteURLSessionTaskDelegate.
 *
 *  @param sessionMetricsDelegate   An object that can handle session metrics for network requests.
 */
- (nonnull instancetype)initWithSessionMetricsDelegate:(nullable id <TMURLSessionMetricsDelegate>)sessionMetricsDelegate;

/**
 *  Adds a session task to this delegate.
 *
 *  @param task               The task to start tracking.
 *  @param handler            A handler for completion of the request.
 *  @param incrementalHandler A handler for incremental data before the request is over.
 *  @param progressHandler    A block that handles reporting network task progress.
 */
- (void)addSessionTask:(nonnull NSURLSessionTask *)task
     completionHandler:(nonnull TMURLSessionRequestCompletionHandler)handler
    incrementalHandler:(nonnull TMURLSessionRequestIncrementedHandler)incrementalHandler
        progressHandler:(nonnull TMURLSessionRequestProgressHandler)progressHandler;

@end
