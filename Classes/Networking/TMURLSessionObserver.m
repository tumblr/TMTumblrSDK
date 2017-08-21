//
//  TMURLSessionObserver.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/6/16.
//
//

#import "TMURLSessionObserver.h"

@interface TMURLSessionObserver ()

@property (nonatomic, readonly) NSMutableArray *tasks;
@property (nonatomic, readonly) dispatch_queue_t queue;
@property (nonatomic, readonly) dispatch_queue_t taskObserverQueue;

@property (nonatomic, readonly, copy) NSArray <TMURLSessionTaskObserverUpdateHandler> * handlers;

@end

@implementation TMURLSessionObserver

- (nonnull instancetype)initWithHandlers:(nonnull NSArray <TMURLSessionTaskObserverUpdateHandler> *)handlers {
    NSParameterAssert(handlers);
    self = [super init];
    if (self) {
        _handlers = [handlers copy];
        _tasks = [[NSMutableArray alloc] init];
        _queue = dispatch_queue_create("com.tumblr.observer", DISPATCH_QUEUE_SERIAL);
        _taskObserverQueue = dispatch_queue_create("com.tumblr.observerDelegateQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)addSessionTask:(nonnull NSURLSessionTask *)task {
    NSParameterAssert(task);
    typeof(self) __weak weakSelf = self;
    dispatch_sync(self.queue, ^{
        [self.tasks addObject:[[TMURLSessionTaskObserver alloc] initWithTask:task updateQueue:self.taskObserverQueue updateHandler:^(TMURLSessionTaskState state, NSURLSessionTask *sessionTask) {

            typeof(self) strongSelf = weakSelf;

            if (!strongSelf || !sessionTask) {
                return;
            }

            dispatch_sync(strongSelf.taskObserverQueue, ^{
                for (TMURLSessionTaskObserverUpdateHandler handler in weakSelf.handlers) { handler(state, sessionTask); }
            });

            if (state == TMURLSessionTaskStateStoppedAndSafeToStopObserving) {

                /**
                 *  We are safe to stop observing, but lets wait a little just to make sure.
                 */
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), strongSelf.queue, ^{
                    [self removeTask:task];
                });
            }

        }]];
    });
}

#pragma mark - Private

- (void)removeTask:(NSURLSessionTask *)task {
    
    for (NSInteger i = 0; i < self.tasks.count; i++) {
        const TMURLSessionTaskObserver *sessionTaskObserver = self.tasks[i];
        
        if ([task isEqual:sessionTaskObserver.task]) {
            [self.tasks removeObjectAtIndex:i];
            break;
        }
    }
}

@end
