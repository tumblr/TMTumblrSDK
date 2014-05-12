//
//  TMHTTPRequestSerializer.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 5/12/14.
//  Copyright (c) 2014 Tumblr. All rights reserved.
//

#import "AFURLRequestSerialization.h"
@protocol TMHTTPRequestSerializerDelegate;

@interface TMHTTPRequestSerializer : AFHTTPRequestSerializer

- (instancetype)initWithDelegate:(id <TMHTTPRequestSerializerDelegate>)delegate;

@end

@protocol TMHTTPRequestSerializerDelegate <NSObject>

- (NSString *)OAuthConsumerKey;

- (NSString *)OAuthConsumerSecret;

- (NSString *)OAuthToken;

- (NSString *)OAuthTokenSecret;

@end