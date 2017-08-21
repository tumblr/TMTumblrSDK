//
//  TMURLSessionTaskStateProducer.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/26/16.
//
//

#import <Foundation/Foundation.h>
#import "TMURLSessionTaskObserver.h"

/**
 *  Responsible for converting a stream of @c NSURLSessionTaskState into @c TMURLSessionState
 */
__attribute__((objc_subclassing_restricted))
@interface TMURLSessionTaskStateProducer : NSObject

/**
 *  Initializes an instance of @c TMURLSessionTaskStateProducer.
 *
 *  @param queue   The queue to call the handler block on.
 *  @param handler The block to handle state changes.
 *  @param task    The session task that the state is being updated for.
 *
 *  @return An intialized instance of @c TMURLSessionTaskStateProducer.
 */
- (nonnull instancetype)initWithQueue:(nonnull dispatch_queue_t)queue handler:(nonnull TMURLSessionTaskObserverUpdateHandler)handler task:(nonnull NSURLSessionTask *)task;

/**
 *  Submits a @c NSURLSessionTaskState to be processed
 *
 *  @param state The @c NSURLSessionTaskState to be processed and converted.
 */
- (void)submitState:(NSURLSessionTaskState)state;

@end
