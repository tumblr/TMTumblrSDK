//
//  TMOAuth.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/27/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

@interface TMOAuth : NSObject

+ (NSString *)authorizationHeaderForRequest:(JXHTTPOperation *)request nonce:(NSString *)nonce
                                consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
                                      token:(NSString *)token tokenSecret:(NSString *)tokenSecret;

@end
