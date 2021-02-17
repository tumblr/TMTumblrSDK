//
//  TMSDKUserAgent.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 12/17/14.
//  Copyright (c) 2014 Tumblr. All rights reserved.
//

@import Foundation;

extern NSString * _Nonnull const UnknownVersionString;

@interface TMSDKUserAgent : NSObject

+ (nonnull NSString *)userAgentHeaderString;

@end
