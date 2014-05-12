//
//  TMHTTPSessionManager.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 5/12/14.
//  Copyright (c) 2014 Tumblr. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "TMAPIBlocks.h"

@interface TMHTTPSessionManager : AFHTTPSessionManager

/// OAuth consumer key. Must be set prior to authenticating or making any API requests.
@property (nonatomic, copy) NSString *OAuthConsumerKey;

/// OAuth consumer key. Must be set prior to authenticating or making any API requests.
@property (nonatomic, copy) NSString *OAuthConsumerSecret;

/**
 OAuth token. Initially set by this library's OAuth/xAuth implementations after authenticating.
 
 The Tumblr SDK does not currently persist this value. You are responsible for storing this value and setting it on
 subsequent app launches prior to making any API requests.
 */
@property (nonatomic, copy) NSString *OAuthToken;

/**
 OAuth token secret. Initially set by this library's OAuth/xAuth implementations after authenticating.
 
 The Tumblr SDK does not currently persist this value. You are responsible for storing this value and setting it on
 subsequent app launches prior to making any API requests.
 */
@property (nonatomic, copy) NSString *OAuthTokenSecret;

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;

// TODO: Add hooks for hooking into all success/failure blocks

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters
                     callback:(TMAPICallback)callback;

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters
                      callback:(TMAPICallback)callback;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      callback:(TMAPICallback)callback;

@end