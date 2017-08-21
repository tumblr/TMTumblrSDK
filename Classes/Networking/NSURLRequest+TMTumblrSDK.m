//
//  NSURLRequest+TMTumblrSDK.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/13/16.
//
//

#import "NSURLRequest+TMTumblrSDK.h"
#import "NSMutableURLRequest+TMTumblrSDKAdditions.h"
#import "TMRequestMethodHelpers.h"

@implementation NSURLRequest (TMTumblrSDK)

+ (nonnull instancetype)URLRequestWithURL:(nonnull NSURL *)URL method:(TMHTTPRequestMethod)method additionalHeaders:(nullable NSDictionary *)additionalHeaders {
    NSParameterAssert(URL);
    
    return ^ NSURLRequest * {
        NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        mutableURLRequest.HTTPMethod = [TMRequestMethodHelpers stringFromMethod:method];
        [mutableURLRequest addAdditionalHeaders:additionalHeaders];
        return [mutableURLRequest copy];
    }();
}

@end
