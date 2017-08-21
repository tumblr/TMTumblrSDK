//
//  TMNetworkActivityVisiblityCounter.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/7/16.
//
//

#import "TMNetworkActivityVisiblityCounter.h"

@interface TMNetworkActivityVisiblityCounter ()

@property (nonatomic, weak, readonly) id <TMNetworkActivityIndicatorManager> networkActivityIndicatorManager;
@property (nonatomic, readonly, nonnull) dispatch_queue_t queue;
@property (nonatomic, nullable) NSTimer *timer;
@property (nonatomic) NSInteger count;

@end

@implementation TMNetworkActivityVisiblityCounter

- (nonnull instancetype)initWithNetworkActivityIndicatorManager:(nonnull id <TMNetworkActivityIndicatorManager>)networkActivityIndicatorManager {
    NSParameterAssert(networkActivityIndicatorManager);
    
    self = [super init];
    
    if (self) {
        _networkActivityIndicatorManager = networkActivityIndicatorManager;
        _queue = dispatch_queue_create("com.tumblr.TMNetworkActivityVisiblityCounter", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)update:(TMURLSessionTaskState)state {
    switch (state) {
        case TMURLSessionTaskStateRunning:
            [self updateCount:YES];
            break;
        case TMURLSessionTaskStateStoppedWithoutEverRunning:
            break;
        case TMURLSessionTaskStateStopped:
            [self updateCount:NO];
            break;
        case TMURLSessionTaskStateUnknown:
            break;
        case TMURLSessionTaskStateStoppedAndSafeToStopObserving:
            break;
    }
}

- (NSInteger)activeCount {
    __block NSInteger activeCount = 0;
    dispatch_sync(self.queue, ^{
        activeCount = self.count;
    });
    return activeCount;
}

#pragma mark Private

- (void)updateCount:(BOOL)increment {
    dispatch_sync(self.queue, ^{
        if (increment) {
            self.count++;
            [self.timer invalidate];
            self.timer = nil;
        }
        else {
            self.count--;
            NSAssert(self.count >= 0, @"This should never happen");
            if (self.count >= 1) {
                return;
            }
            else {
                [self resetTimer];
            }
        }
        
        if (increment && self.count == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.networkActivityIndicatorManager setNetworkActivityIndicatorVisible:YES];
            });
        }
    });
}

- (void)resetTimer {
    self.timer = [NSTimer timerWithTimeInterval:0.25 target:self selector:@selector(timerHit) userInfo:nil repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerHit {
    [self.networkActivityIndicatorManager setNetworkActivityIndicatorVisible:NO];
}

@end
