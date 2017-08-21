//
//  TMConcreteURLSessionTaskDelegate.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/28/16.
//
//

#import "TMConcreteURLSessionTaskDelegate.h"
#import "TMURLSessionMetricsDelegate.h"
#import "TMNetworkSpeedTracker.h"

@interface TMConcreteURLSessionTaskDelegate ()

@property (nonatomic, readonly, nonnull) NSMutableDictionary <NSNumber *, TMURLConcreteSessionTaskDelegateContainer *> *dictionary;

@property (nonatomic, readonly, nonnull) dispatch_queue_t queue;

@property (nonatomic, nullable, weak, readonly) id <TMURLSessionMetricsDelegate> sessionMetricsDelegate;

@property (nonatomic, readonly) TMNetworkSpeedTracker *networkSpeedTracker;

@end

@implementation TMConcreteURLSessionTaskDelegate

- (instancetype)init {
    return [self initWithSessionMetricsDelegate:nil];
}

- (nonnull instancetype)initWithSessionMetricsDelegate:(nullable id <TMURLSessionMetricsDelegate>)sessionMetricsDelegate {

    self = [super init];

    if (self) {
        _networkSpeedTracker = [[TMNetworkSpeedTracker alloc] init];
        _sessionMetricsDelegate = sessionMetricsDelegate;
        _dictionary = [[NSMutableDictionary alloc] init];
        _queue = dispatch_queue_create("com.tumblr.TMConcreteURLSessionTaskDelegate", DISPATCH_QUEUE_SERIAL);
    }

    return self;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {

    for (NSURLSessionTaskTransactionMetrics *metric in metrics.transactionMetrics) {
        if (metric.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad) {

            [self.networkSpeedTracker track:metric.responseStartDate endDate:metric.responseEndDate bytes:task.countOfBytesReceived];

        }
    }

    [self.sessionMetricsDelegate task:task didFinishCollectingMetrics:metrics];
}

- (void)addSessionTask:(nonnull NSURLSessionTask *)task
     completionHandler:(nonnull TMURLSessionRequestCompletionHandler)handler
    incrementalHandler:(nonnull TMURLSessionRequestIncrementedHandler)incrementalHandler
       progressHandler:(nonnull TMURLSessionRequestProgressHandler)progressHandler
{
    NSParameterAssert(task);
    NSParameterAssert(handler);
    NSParameterAssert(incrementalHandler);
    NSParameterAssert(progressHandler);

    NSMutableData *data = [[NSMutableData alloc] init];
    NSNumber *taskIdentifier = @(task.taskIdentifier);
    TMURLConcreteSessionTaskDelegateContainer *container = [[TMURLConcreteSessionTaskDelegateContainer alloc] initWithCompletionHandler:handler
                                                                                                                     incrementalHandler:incrementalHandler
                                                                                                                        progressHandler:progressHandler
                                                                                                                                   data:data];
    dispatch_sync(self.queue, ^{
        [self.dictionary setObject:container forKey:taskIdentifier];
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {

    NSNumber *taskIdentifier = @(task.taskIdentifier);

    dispatch_sync(self.queue, ^{
        TMURLConcreteSessionTaskDelegateContainer *container = [self.dictionary objectForKey:taskIdentifier];

        if (container) {
            container.uploadProgress = totalBytesExpectedToSend == 0 ? 0 : (double)totalBytesSent / (double)totalBytesExpectedToSend;
            container.progressHandler(container.uploadProgress * 0.8, task);
        }
    });
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSNumber *taskIdentifier = @(dataTask.taskIdentifier);

    dispatch_sync(self.queue, ^{
        TMURLConcreteSessionTaskDelegateContainer *container = [self.dictionary objectForKey:taskIdentifier];

        if (container) {
            [container.data appendData:data];

            const double expectedToReceive = dataTask.countOfBytesExpectedToReceive;

            const double received = expectedToReceive == 0 ? 0 : (double)dataTask.countOfBytesReceived / expectedToReceive;

            if (received > 0) {
                container.progressHandler(container.uploadProgress * 0.8 + received * 0.2, dataTask);
            }

            container.incrementalHandler(container.data, dataTask);
        }
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    NSNumber *taskIdentifier = @(task.taskIdentifier);

    dispatch_sync(self.queue, ^{
        TMURLConcreteSessionTaskDelegateContainer *container = [self.dictionary objectForKey:taskIdentifier];

        if (container) {

            /**
             *  We technically should be copying this data object but noticed it was a little bit slower, so in order to get images
             *  and other resources loading a little faster, we are just not going to do so.
             */
            container.completionHandler(container.data, task.response, error);

            /**
             *  We have to clear this out, or else we leak these forever.
             */
            self.dictionary[@(task.taskIdentifier)] = nil;
        }
    });
}

// Crash fix for iOS 10 issue related to NSURLSessionTaskMetrics. See http://www.openradar.me/28301343
- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL haveProblematicSelector = aSelector == @selector(URLSession:task:didFinishCollectingMetrics:);
    if (!haveProblematicSelector) {
        return [super respondsToSelector:aSelector];
    }
    
    NSOperatingSystemVersion version = [[[NSProcessInfo alloc] init] operatingSystemVersion];
    BOOL haveCrashAffectedOSVersion = version.majorVersion == 10 && (version.minorVersion == 0 || version.minorVersion == 1);
    return haveCrashAffectedOSVersion ? NO : [super respondsToSelector:aSelector];  //don't respond to problematic selector on iOS 10.0 or iOS 10.1
}

@end
