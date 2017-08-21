//
//  TMUploadSessionTaskCreator.m
//  Pods
//
//  Created by Kenny Ackerson on 6/20/16.
//
//

#import "TMUploadSessionTaskCreator.h"

@interface TMUploadSessionTaskCreator ()

@property (nonatomic, readonly, nonnull) NSURL *filePath;
@property (nonatomic, readonly, nonnull) NSURLSession *session;
@property (nonatomic, readonly, nonnull) NSURLRequest *request;
@property (nonatomic, readonly, nullable) NSData *bodyData;
@property (nonatomic, copy, readonly, nullable) TMURLSessionRequestIncrementedHandler incrementalHandler;
@property (nonatomic, copy, readonly, nonnull) TMURLSessionRequestCompletionHandler completionHandler;

@end

@implementation TMUploadSessionTaskCreator

- (nonnull instancetype)initWithFilePath:(nonnull NSURL *)filePath
                                 session:(nonnull NSURLSession *)session
                                 request:(nonnull NSURLRequest *)request
                                bodyData:(nullable NSData *)bodyData
                      incrementalHandler:(nullable TMURLSessionRequestIncrementedHandler)incrementalHandler
                       completionHandler:(nonnull TMURLSessionRequestCompletionHandler)completionHandler {
    NSParameterAssert(filePath);
    NSParameterAssert(session);
    NSParameterAssert(request);
    NSParameterAssert(completionHandler);
    self = [super init];

    if (self) {
        _filePath = filePath;
        _session = session;
        _request = request;
        _bodyData = bodyData;
        _incrementalHandler = [incrementalHandler copy];
        _completionHandler = [completionHandler copy];
    }
    
    return self;
}

- (nonnull NSURLSessionTask *)uploadTask {

    NSURLSessionTask *task;

    if (self.bodyData && [self.bodyData writeToURL:self.filePath atomically:YES]) {
        if (!self.incrementalHandler) {
            task = [self.session uploadTaskWithRequest:self.request
                                              fromFile:self.filePath
                                     completionHandler:self.completionHandler];
        }
        else {
            task = [self.session uploadTaskWithRequest:self.request
                                              fromFile:self.filePath];
        }

    }
    else {
        NSLog(@"WARNING: Could not write data to disk, using fromData to initialize upload task.");
        task = [self.session uploadTaskWithRequest:self.request fromData:self.bodyData completionHandler:self.completionHandler];
    }

    return task;

}

@end
