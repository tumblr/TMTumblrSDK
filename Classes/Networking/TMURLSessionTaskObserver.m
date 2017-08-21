//
//  TMURLSessionObserver.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/6/16.
//
//

#import "TMURLSessionTaskObserver.h"
#import "TMURLSessionTaskStateProducer.h"

@interface TMURLSessionTaskObserver ()

@property (nonatomic, readonly) TMURLSessionTaskStateProducer *sesssionTaskStateProducer;

@end

static void *TMURLSessionTaskObserverContext = &TMURLSessionTaskObserverContext;

@implementation TMURLSessionTaskObserver

- (nonnull instancetype)initWithTask:(nonnull NSURLSessionTask *)task
                         updateQueue:(nonnull dispatch_queue_t)queue
                       updateHandler:(nonnull TMURLSessionTaskObserverUpdateHandler)handler {
    NSParameterAssert(task);
    NSParameterAssert(queue);
    NSParameterAssert(handler);
    self = [super init];
    
    if (self) {
        _sesssionTaskStateProducer = [[TMURLSessionTaskStateProducer alloc] initWithQueue:queue handler:handler task:task];
        _task = task;
        [task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:TMURLSessionTaskObserverContext];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == TMURLSessionTaskObserverContext && [keyPath isEqualToString:@"state"]) {
        
        NSParameterAssert([change[NSKeyValueChangeNewKey] isKindOfClass:[NSNumber class]]);
        NSParameterAssert([object isKindOfClass:[NSURLSessionTask class]]);
        
        const NSURLSessionTaskState new = [change[NSKeyValueChangeNewKey] integerValue];
        
        [self.sesssionTaskStateProducer submitState:new];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.task removeObserver:self forKeyPath:@"state"];
}

@end
