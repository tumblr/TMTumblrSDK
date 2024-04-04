//
//  TMURLSessionCallbacks.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/28/16.
//
//

/**
 *  Completion handler after making a request.
 *
 *  @param data     The data received back from the server.
 *  @param response The response from the server.
 *  @param error    An error, if any.
 */
typedef void (^TMURLSessionRequestCompletionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

/**
 *  Completion handler after making a request.
 *
 *  @param data     The data received back from the server.
 */
typedef void (^TMURLSessionRequestIncrementedHandler)(NSData * _Nullable data, NSURLSessionDataTask * _Nonnull dataTask);

/**
 *  Completion handler after making a request.
 *
 *  @param progress     The current progress of the session task
 *  @param dataTask     The task that is associcatedwith this progress
 */
typedef void (^TMURLSessionRequestProgressHandler)(double progress, NSURLSessionTask * _Nonnull dataTask);
