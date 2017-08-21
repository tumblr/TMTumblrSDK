//
//  TMURLSessionTaskStateProducer.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/26/16.
//
//

#import "TMURLSessionTaskStateProducer.h"

@interface TMURLSessionTaskStateProducer ()

@property (nonatomic) BOOL hasCompleted;
@property (nonatomic) BOOL hasStarted;
@property (nonatomic) BOOL hasNotifiedOfSafeState;

@property (nonatomic) NSTimer *timer;

@property (nonatomic, readonly, nonnull) dispatch_queue_t queue;
@property (nonatomic, readonly, copy, nonnull) TMURLSessionTaskObserverUpdateHandler handler;
@property (nonatomic, readonly, nonnull) NSURLSessionTask *task;

@property (nonatomic, readonly, nonnull) dispatch_queue_t syncQueue;

@end

@implementation TMURLSessionTaskStateProducer

- (nonnull instancetype)initWithQueue:(nonnull dispatch_queue_t)queue handler:(nonnull TMURLSessionTaskObserverUpdateHandler)handler task:(nonnull NSURLSessionTask *)task {
    NSParameterAssert(queue);
    NSParameterAssert(handler);
    NSParameterAssert(task);
    self = [super init];
    
    if (self) {
        _queue = queue;
        _handler = [handler copy];
        _task = task;
        _syncQueue = dispatch_queue_create("com.tumblr.sdk.stateproducer", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)submitState:(NSURLSessionTaskState)state {
    dispatch_sync(self.syncQueue, ^{

        if (self.hasCompleted && !self.hasNotifiedOfSafeState) {
            [self restartTimer];
            return;
        }

        if (self.hasCompleted) {
            return;
        }
        
        if (state == NSURLSessionTaskStateSuspended) {
            dispatch_sync(self.queue, ^{
                self.handler(TMURLSessionTaskStateUnknown, self.task);
            });
            return;
        }
        
        if (!self.hasStarted && state == NSURLSessionTaskStateRunning) {
            self.hasStarted = YES;
            dispatch_sync(self.queue, ^{
                self.handler(TMURLSessionTaskStateRunning, self.task);
            });
        }

        void(^stoppedBlock)(NSURLSessionTaskState) = ^(NSURLSessionTaskState state){
            if (state == NSURLSessionTaskStateCompleted) {
                [self sendSafeMessage];
            }
            else {
                [self restartTimer];
            }
        };

        // This can happen if you never call resume on a task or it never actually starts but is stopped before.
        if (!self.hasStarted && (state == NSURLSessionTaskStateCompleted || state == NSURLSessionTaskStateCanceling)) {
            self.hasCompleted = YES;
            dispatch_sync(self.queue, ^{
                self.handler(TMURLSessionTaskStateStoppedWithoutEverRunning, self.task);

                stoppedBlock(state);
            });
        }
        else if (!self.hasCompleted && (state == NSURLSessionTaskStateCompleted || state == NSURLSessionTaskStateCanceling)) {
            self.hasCompleted = YES;
            dispatch_sync(self.queue, ^{
                self.handler(TMURLSessionTaskStateStopped, self.task);

                stoppedBlock(state);
            });
        }
    });
}

- (void)restartTimer {
    [self.timer invalidate];
    self.timer = nil;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sendSafeMessage) userInfo:nil repeats:NO];
}

- (void)sendSafeMessage {
    self.handler(TMURLSessionTaskStateStoppedAndSafeToStopObserving, self.task);
    self.hasNotifiedOfSafeState = YES;
}

- (void)dealloc {
    dispatch_sync(self.syncQueue, ^{
        [self.timer invalidate];
        self.timer = nil;
        if (!self.hasCompleted) {
            dispatch_sync(self.queue, ^{ if (self.handler) { self.handler(TMURLSessionTaskStateStopped, self.task); } });
        }
    });
}

@end
