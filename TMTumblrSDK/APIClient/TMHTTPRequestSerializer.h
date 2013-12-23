//
//  TMOAuthRequestSerializer.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 12/17/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
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
