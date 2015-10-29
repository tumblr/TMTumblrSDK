//
//  TMOAuth.h
//  TumblrAuthentication
//
//  Created by Bryan Irace on 11/19/12.
//  Copyright (c) 2012 Tumblr. All rights reserved.
//

@import Foundation;
@interface TMOAuth : NSObject

/// Base string used to generate the OAuth signature
@property (nonatomic, strong, readonly) NSString *baseString;

/// Authentication header value
@property (nonatomic, strong, readonly) NSString *headerString;

/**
 Build an authentication header for a Tumblr API request.
 
 @param URL API request URL
 @param method HTTP method (GET or POST)
 @param postParameters POST body parameters
 @param nonce Unique request identifier
 @param consumerKey OAuth consumer key
 @param consumerSecret OAuth consumer secret
 @param token OAuth user token
 @param tokenSecret OAuth user secret
 */
- (id)initWithURL:(NSURL *)URL method:(NSString *)method postParameters:(NSDictionary *)postParameters
            nonce:(NSString *)nonce consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
            token:(NSString *)token tokenSecret:(NSString *)tokenSecret;

/// Convenience method for generating an OAuth header string
+ (NSString *)headerForURL:(NSURL *)URL method:(NSString *)method postParameters:(NSDictionary *)postParameters
                     nonce:(NSString *)nonce consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
                     token:(NSString *)token tokenSecret:(NSString *)tokenSecret;

@end
