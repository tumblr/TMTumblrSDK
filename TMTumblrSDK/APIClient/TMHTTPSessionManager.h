//
//  TMHTTPSessionManager.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 12/6/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "TMAPIClient.h"

@interface TMHTTPSessionManager : AFHTTPSessionManager

// TODO: Add hooks for hooking into all success/failure blocks

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters
                     callback:(TMAPICallback)callback;

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters
                      callback:(TMAPICallback)callback;

@end
