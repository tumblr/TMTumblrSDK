//
//  NSMutableURLRequest+TMTumblrSDKAdditions.h
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/16/16.
//
//

#import <Foundation/Foundation.h>

/**
 *  A category that contains additions for TMTumblrSDK
 */
@interface NSMutableURLRequest (TMTumblrSDKAdditions)

/**
 *  Adds headers onto a request.
 *
 *  @param additionalHeaders The headers to add to a request.
 */
- (void)addAdditionalHeaders:(nullable NSDictionary *)additionalHeaders;

@end
