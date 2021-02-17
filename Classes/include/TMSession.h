//
//  TMSession.h
//  Pods
//
//  Created by Kenny Ackerson on 10/26/16.
//
//

@protocol TMRequest;
@class TMNetworkActivityVisiblityCounter;

@protocol TMSession

/**
 *  Creates an OAuth-signed HTTP session task for the specified URL request object, and calls a handler upon completion.
 *
 *  @param request            (Required) An @c TMRequest object that provides the URL, cache policy, request type, body data or body stream, and so on.
 *  @param incrementalHandler (Required) A block that is called when some of the data has been gathered from the server.
 *  @param completionHandler  (Required) The completion handler to call when the load request is complete.
 *
 *  @return The new session data task.
 */
- (nonnull NSURLSessionTask *)taskWithRequest:(nonnull id <TMRequest>)request
                           incrementalHandler:(nonnull TMURLSessionRequestIncrementedHandler)incrementalHandler
                              progressHandler:(nonnull TMURLSessionRequestProgressHandler)progressHandler
                            completionHandler:(nonnull TMURLSessionRequestCompletionHandler)completionHandler;

/**
 *  Creates an OAuth-signed HTTP session task for the specified URL request object, and calls a handler upon completion.
 *
 *  @param request            (Required) An @c TMRequest object that provides the URL, cache policy, request type, body data or body stream, and so on.
 *  @param completionHandler  (Required) The completion handler to call when the load request is complete.
 *
 *  @return The new session data task.
 */
- (nonnull NSURLSessionTask *)taskWithRequest:(nonnull id <TMRequest>)request
                            completionHandler:(nonnull TMURLSessionRequestCompletionHandler)completionHandler;

/**
 *  Creates, signs, and paramaterizes a @c NSURLRequest from a given @c TMRequest.
 *
 *  @param request The API Request.
 *
 *  @return A signed @c NSURLRequest.
 */
- (nonnull NSURLRequest *)paramaterizedRequestFromRequest:(nonnull id <TMRequest>)request;

/**
 *  The visibility counter for this Session .
 */
@property (nonatomic, nullable, readonly) TMNetworkActivityVisiblityCounter *networkActivityVisibilityCounter;

/**
 *  Calculates whether or not we can sign requests at the time.
 *
 *  @return Whether or not we can sign request right now.
 */
- (BOOL)canSignRequests;

/**
 * Creates a copy of an existing TMURLSession instance with a new value for its configuration property.
 *
 * @param configuration (Required) A NSURLSessionConfiguration instance which defines the NSURLSession object's behavior and policies.
 *
 * @return A TMURLSession instance.
 */
- (nonnull instancetype)copyWithNewConfiguration:(nonnull NSURLSessionConfiguration *)configuration;


@end
