//
//  TMOAuth.h
//  TumblrSDK
//
//  Created by Bryan Irace on 8/27/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "JXHTTP.h"

@interface TMOAuth : NSObject

+ (NSString *)authorizationHeaderForRequest:(JXHTTPOperation *)request consumerKey:(NSString *)consumerKey
                             consumerSecret:(NSString *)consumerSecret token:(NSString *)token
                                tokenSecret:(NSString *)tokenSecret;

@end
