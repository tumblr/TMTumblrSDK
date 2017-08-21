//
//  NSMutableURLRequest+TMTumblrSDKAdditions.m
//  TMTumblrSDK
//
//  Created by Kenny Ackerson on 1/16/16.
//
//

#import "NSMutableURLRequest+TMTumblrSDKAdditions.h"

@implementation NSMutableURLRequest (TMTumblrSDKAdditions)

- (void)addAdditionalHeaders:(nullable NSDictionary *)additionalHeaders {
    [additionalHeaders enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        [self addValue:obj forHTTPHeaderField:key];
    }];
}

@end
