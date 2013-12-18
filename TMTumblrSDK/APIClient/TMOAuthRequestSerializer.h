//
//  TMOAuthRequestSerializer.h
//  TMTumblrSDK
//
//  Created by Bryan Irace on 12/17/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "AFURLRequestSerialization.h"
@protocol TMOAuthRequestSerializerDelegate;

@interface TMOAuthRequestSerializer : NSObject <AFURLRequestSerialization>

@property (nonatomic, weak) id <TMOAuthRequestSerializerDelegate> delegate;

@end

@protocol TMOAuthRequestSerializerDelegate <NSObject>

- (NSString *)OAuthConsumerKey;

- (NSString *)OAuthConsumerSecret;

- (NSString *)OAuthToken;

- (NSString *)OAuthTokenSecret;

@end
