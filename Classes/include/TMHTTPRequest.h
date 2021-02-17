//
//  TMHTTPRequest.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/13/16.
//
//

#import <Foundation/Foundation.h>
#import "TMHTTPRequestMethod.h"
#import "TMRequest.h"

/**
 * A model of an HTTP request.
 */
__attribute__((objc_subclassing_restricted))
@interface TMHTTPRequest : NSObject <TMRequest>

/**
 *  Initializes an instance of @c TMHTTPRequest.
 *
 *  @param URLString The string representation of the URL.
 *  @param method    The HTTP method to use.
 *
 *  @return A new instance of @c TMHTTPRequest.
 */
- (nonnull instancetype)initWithURLString:(nonnull NSString *)URLString
                                   method:(TMHTTPRequestMethod)method;

/**
 *  Initializes an instance of @c TMHTTPRequest.
 *
 *  @param URLString           The string representation of the URL.
 *  @param method              The HTTP method to use.
 *  @param additionalHeaders   Additional headers to add to the request if wanted.
 *  @param requestBody         The request body object that represents a HTTP request body
 *  @param isSigned            Whether or not this request should be signed.
 *
 *  @return A new instance of @c TMHTTPRequest.
 */
- (nonnull instancetype)initWithURLString:(nonnull NSString *)URLString
                                   method:(TMHTTPRequestMethod)method
                        additionalHeaders:(nullable NSDictionary *)additionalHeaders
                              requestBody:(nullable id <TMRequestBody>)requestBody
                                 isSigned:(BOOL)isSigned
                                 isUpload:(BOOL)isUpload;

@end
