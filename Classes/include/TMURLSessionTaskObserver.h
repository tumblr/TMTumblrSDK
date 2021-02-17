//
//  TMURLSessionObserver.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/6/16.
//
//

#import <Foundation/Foundation.h>
#import "TMURLSessionTaskState.h"

/**
 *  A block for when the state of a task is updated.
 *
 *  @param state       The new state of the task.
 *  @param sessionTask The session task that is updated.
 */
typedef void (^TMURLSessionTaskObserverUpdateHandler)(TMURLSessionTaskState state, NSURLSessionTask * _Nonnull sessionTask);

/**
 * An object that observes a session task for state changes.
 */
__attribute__((objc_subclassing_restricted))
@interface TMURLSessionTaskObserver : NSObject

/**
 *  Initializes an instance of `TMURLSessionTaskObserver`.
 *
 *  @param task    The task to observe.
 *  @param queue   The queue to dispatch the state updates onto.
 *  @param handler The handler to handle the state updates.
 *
 *  @return A newly initialized instance of `TMURLSessionTaskObserver`.
 */
- (nonnull instancetype)initWithTask:(nonnull NSURLSessionTask *)task updateQueue:(nonnull dispatch_queue_t)queue updateHandler:(nonnull TMURLSessionTaskObserverUpdateHandler)handler NS_DESIGNATED_INITIALIZER;

/**
 *  Unavailable.
 *
 *  @return Undetermined.
 */
- (nonnull instancetype)init __attribute__((unavailable("Please use initWithTask:updateQueue:updateHandler: instead.")));

/**
 *  The task being observed.
 */
@property (nonatomic, readonly, nonnull) NSURLSessionTask *task;

@end
