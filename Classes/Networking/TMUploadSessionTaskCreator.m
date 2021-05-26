//
//  TMUploadSessionTaskCreator.m
//  Pods
//
//  Created by Kenny Ackerson on 6/20/16.
//
//

#import "TMUploadSessionTaskCreator.h"

@interface TMUploadSessionTaskCreator ()

@property (nonatomic, readonly) NSURL *filePath;
@property (nonatomic, readonly) NSURLSession *session;
@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly) NSData *bodyData;
@property (nonatomic, copy, readonly) TMURLSessionRequestIncrementedHandler incrementalHandler;
@property (nonatomic, copy, readonly) TMURLSessionRequestCompletionHandler completionHandler;

@end

@implementation TMUploadSessionTaskCreator

- (nonnull instancetype)initWithFilePath:(NSURL *)filePath
                                 session:(NSURLSession *)session
                                 request:(NSURLRequest *)request
                                bodyData:(NSData *)bodyData
                      incrementalHandler:(TMURLSessionRequestIncrementedHandler)incrementalHandler
                       completionHandler:(TMURLSessionRequestCompletionHandler)completionHandler {
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

    if (self.filePath) {
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
