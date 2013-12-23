//
//  TMOAuthRequestSerializer.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 12/17/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMOAuthRequestSerializer.h"
#import "TMOAuth.h"

@implementation TMOAuthRequestSerializer

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(NSDictionary *)parameters
                                        error:(NSError *__autoreleasing *)error {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSString *authorizationHeaderValue = [TMOAuth headerForURL:[request URL]
                                                        method:[request HTTPMethod]
                                                    parameters:parameters
                                                         nonce:[[NSProcessInfo processInfo] globallyUniqueString]
                                                   consumerKey:[self.delegate OAuthConsumerKey]
                                                consumerSecret:[self.delegate OAuthConsumerSecret]
                                                         token:[self.delegate OAuthToken]
                                                   tokenSecret:[self.delegate OAuthTokenSecret]];
    
    [mutableRequest setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    
    return [mutableRequest copy];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)coder {
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

@end
