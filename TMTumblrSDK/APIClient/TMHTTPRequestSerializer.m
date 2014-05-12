//
//  TMHTTPRequestSerializer.m
//  TMTumblrSDK
//
//  Created by Bryan Irace on 5/12/14.
//  Copyright (c) 2014 Tumblr. All rights reserved.
//

#import "TMHTTPRequestSerializer.h"
#import "TMOAuth.h"

@interface TMHTTPRequestSerializer()

@property (nonatomic, weak) id <TMHTTPRequestSerializerDelegate> delegate;

@end

@implementation TMHTTPRequestSerializer

- (instancetype)initWithDelegate:(id <TMHTTPRequestSerializerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    
    return self;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(NSDictionary *)parameters
                                        error:(NSError *__autoreleasing *)error {
    request = [super requestBySerializingRequest:request withParameters:parameters error:error];
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSString *authorizationHeaderValue = [TMOAuth headerForURL:[request URL]
                                                        method:[request HTTPMethod]
                                                postParameters:parameters
                                                         nonce:[[NSProcessInfo processInfo] globallyUniqueString]
                                                   consumerKey:[self.delegate OAuthConsumerKey]
                                                consumerSecret:[self.delegate OAuthConsumerSecret]
                                                         token:[self.delegate OAuthToken]
                                                   tokenSecret:[self.delegate OAuthTokenSecret]];
    
    [mutableRequest setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    
    return [mutableRequest copy];
}

@end
