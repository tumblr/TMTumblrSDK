//
//  TMSDKUserAgent.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 12/17/14.
//  Copyright (c) 2014 Tumblr. All rights reserved.
//

#import "TMSDKUserAgent.h"

NSString * _Nonnull const UnknownVersionString = @"Unknown";

@implementation TMSDKUserAgent

+ (NSString *)userAgentHeaderString {
    return @"TMTumblrSDK 4.0.4";
}

@end
