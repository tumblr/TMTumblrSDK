//
//  TMAPIRequest.h
//  TMTumblrSDK
//
//  Created by Coulton Vento on 7/9/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMHTTPRequestMethod.h"
#import "TMRequest.h"

@protocol TMRequestBody;

/**
 *  Object holding information about a @c NSURLRequest.
 */
__attribute__((objc_subclassing_restricted))
@interface TMAPIRequest : NSObject <TMRequest>

/**
 *  Unavailable.
 *
 *  @return Undefined.
 */
- (nonnull instancetype) init __attribute__((unavailable("init not available")));

/**
 *  Initializes an instance of @c TMAPIRequest.
 *
 *  @param baseURL                 (Required) The base URL for the request. (ex: http://api.tumblr.com/v2)
 *  @param method                  (Required) The request method.
 *  @param path                    (Required) The path to be appended to the base URL. (ex: config)
 *  @param queryParameters         (Optional) Dictionary of query parameters – query items for requests.
 *
 *  @return An instance of @c TMAPIRequest.
 */
- (nonnull instancetype)initWithBaseURL:(nonnull NSURL *)baseURL
                                 method:(TMHTTPRequestMethod)method
                                   path:(nonnull NSString *)path
                        queryParameters:(nullable NSDictionary *)queryParameters NS_DESIGNATED_INITIALIZER;

/**
 *  Initializes an instance of @c TMAPIRequest.
 *
 *  @param baseURL                 (Required) The base URL for the request. (ex: http://api.tumblr.com/v2)
 *  @param method                  (Required) The request method.
 *  @param path                    (Required) The path to be appended to the base URL. (ex: config)
 *  @param queryParameters         (Optional) Dictionary of query parameters – query items for requests.
 *  @param requestBody              The request body object that represents a HTTP request body
 *
 *  @return An instance of @c TMAPIRequest.
 */
- (nonnull instancetype)initWithBaseURL:(nonnull NSURL *)baseURL
                                 method:(TMHTTPRequestMethod)method
                                   path:(nonnull NSString *)path
                        queryParameters:(nullable NSDictionary *)queryParameters
                            requestBody:(nullable id <TMRequestBody>)requestBody
                       additionalHeaders:(nullable NSDictionary *)additionalHeaders;

/**
 *  Initializes an instance of @c TMAPIRequest.
 *
 *  @param baseURL                 (Required) The base URL for the request. (ex: http://api.tumblr.com/v2)
 *  @param method                  (Required) The request method.
 *  @param path                    (Required) The path to be appended to the base URL. (ex: config)
 *  @param queryParameters         (Optional) Dictionary of query parameters – query items for requests.
 *  @param requestBody             The request body object that represents a HTTP request body
 *  @param additionalHeaders       Additional headers for this request.
 *  @param isUpload                Whether or not this is an upload request or not.
 *
 *  @return An instance of @c TMAPIRequest.
 */
- (nonnull instancetype)initWithBaseURL:(nonnull NSURL *)baseURL
                                 method:(TMHTTPRequestMethod)method
                                   path:(nonnull NSString *)path
                        queryParameters:(nullable NSDictionary *)queryParameters
                            requestBody:(nullable id <TMRequestBody>)requestBody
                       additionalHeaders:(nullable NSDictionary *)additionalHeaders
                               isUpload:(BOOL)isUpload;

@end
