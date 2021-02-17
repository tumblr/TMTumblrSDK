//
//  NSURLRequest+TMTumblrSDK.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/13/16.
//
//

#import <Foundation/Foundation.h>
#import "TMHTTPRequestMethod.h"

/**
 *  A category on NSURLRequest to add extra functionality for the SDK.
 */
@interface NSURLRequest (TMTumblrSDK)

/**
 *  Creates a new @c NSURLRequest.
 *
 *  @param URL    The URL representation of this request.
 *  @param method The HTTP request method of this request.
 *
 *  @return A new instance of @c NSURLRequest.
 */
+ (nonnull instancetype)URLRequestWithURL:(nonnull NSURL *)URL method:(TMHTTPRequestMethod)method additionalHeaders:(nullable NSDictionary *)additionalHeaders;

@end
