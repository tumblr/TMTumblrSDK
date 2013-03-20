//
//  TMOAuth.h
//  TumblrAuthentication
//
//  Created by Bryan Irace on 11/19/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

@interface TMOAuth : NSObject

@property (nonatomic, strong, readonly) NSString *baseString;
@property (nonatomic, strong, readonly) NSString *headerString;

- (id)initWithURL:(NSURL *)URL method:(NSString *)method postParameters:(NSDictionary *)postParameters
            nonce:(NSString *)nonce consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
            token:(NSString *)token tokenSecret:(NSString *)tokenSecret;

// Build OAuth header
+ (NSString *)headerForURL:(NSURL *)URL method:(NSString *)method postParameters:(NSDictionary *)postParameters
                     nonce:(NSString *)nonce consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
                     token:(NSString *)token tokenSecret:(NSString *)tokenSecret;

@end
