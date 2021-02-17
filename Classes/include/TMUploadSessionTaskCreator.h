//
//  TMUploadSessionTaskCreator.h
//  Pods
//
//  Created by Kenny Ackerson on 6/20/16.
//
//

#import <Foundation/Foundation.h>
#import "TMURLSessionCallbacks.h"

/**
 * Creates an upload task.
 *  
 * Handles:
 * 
 *  - Creating the request
 *  - Creating a temporary file on disk with the upload body
 *  - Handles whether or not you want incremental data callbacks or not
 */
__attribute__((objc_subclassing_restricted))
@interface TMUploadSessionTaskCreator : NSObject

/**
 *  Initializes an new instance of @c TMUploadSessionTaskCreator.
 *
 *  @param filePath           The file path to save the request body to temporarily.
 *  @param session           The URL session object to create the upload session on.
 *  @param request            A request object to create the upload task with.
 *  @param bodyData           The body data to upload to the server.
 *  @param incrementalHandler A block that is called when some of the data has been gathered from the server (copied).
 *  @param completionHandler  The completion handler to call when the load request is complete (copied).
 *
 *  @return A new instance of @c TMUploadSessionTaskCreator that can now make a new upload task.
 */
- (nonnull instancetype)initWithFilePath:(nonnull NSURL *)filePath
                                 session:(nonnull NSURLSession *)session
                                 request:(nonnull NSURLRequest *)request
                                bodyData:(nullable NSData *)bodyData
                      incrementalHandler:(nullable TMURLSessionRequestIncrementedHandler)incrementalHandler
                       completionHandler:(nonnull TMURLSessionRequestCompletionHandler)completionHandler;

/**
 *  Creates a new upload task for a request to upload to a server.
 *
 *  @return A new upload task that can upload a blob of data to the server.
 */
- (nonnull NSURLSessionTask *)uploadTask;

@end
