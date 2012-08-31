//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"
#import "TMOAuth.h"

NSString * const TMAPIBaseURL = @"http://api.tumblr.com/v2/";

NSString * const TMAPIParameterAPIKey = @"api_key";
NSString * const TMAPIParameterLimit = @"limit";
NSString * const TMAPIParameterOffset = @"offset";
NSString * const TMAPIParameterTag = @"tag";
NSString * const TMAPIParameterURL = @"url";
NSString * const TMAPIParameterPostID = @"id";
NSString * const TMAPIParameterReblogKey = @"reblog_key";
NSString * const TMAPIParameterType = @"type";

NSString * const TMAPIResponseKeyMeta = @"meta";
NSString * const TMAPIResponseKeyStatus = @"status";
NSString * const TMAPIResponseKeyResponse = @"response";


@interface TMAPIClient() {
    JXHTTPOperationQueue *_queue;
}

- (void)sendRequest:(JXHTTPOperation *)request success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

@end


@implementation TMAPIClient

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _queue = [[JXHTTPOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)get:(NSString *)path parameters:(NSDictionary *)parameters success:(TMAPICallback)success
      error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [JXHTTPOperation withURLString:[TMAPIBaseURL stringByAppendingString:path]
                                              queryParameters:parameters];
    
    [self sendRequest:request success:success error:error];
}

- (void)post:(NSString *)path parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [JXHTTPOperation withURLString:[TMAPIBaseURL stringByAppendingString:path]];
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:parameters];

    [self sendRequest:request success:success error:error];
}

- (void)sendRequest:(JXHTTPOperation *)request {
    NSString *authorizationHeaderValue = [TMOAuth authorizationHeaderForRequest:request
                                                                          nonce:request.uniqueIDString
                                                                    consumerKey:self.OAuthConsumerKey
                                                                 consumerSecret:self.OAuthConsumerSecret
                                                                          token:self.OAuthToken
                                                                    tokenSecret:self.OAuthTokenSecret];
    
    [request setValue:authorizationHeaderValue forRequestHeader:@"Authorization"];
    
    [_queue addOperation:request]; 
}

#pragma mark - Class extension

- (void)sendRequest:(JXHTTPOperation *)request success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    __block JXHTTPOperation *blockRequest = request;
    
    request.completionBlock = ^ {
        NSDictionary *response = blockRequest.responseJSON;
        int statusCode = response[TMAPIResponseKeyMeta] ? [response[TMAPIResponseKeyMeta][TMAPIResponseKeyStatus] intValue] : 0;
        
        if (statusCode == 200) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(response[TMAPIResponseKeyResponse]);
                });
            }
        } else {
            NSLog(@"%@", request.requestURL);
            
            if (error) {
                // TODO: Pass blog or user errors from server in user info dictionary
                dispatch_async(dispatch_get_main_queue(), ^{
                    error([NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil]);
                });
            }
        }
    };

    [self sendRequest:request];
}

#pragma mark - Memory management

- (void)dealloc {
    self.OAuthConsumerKey = nil;
    self.OAuthConsumerSecret = nil;
    self.OAuthToken = nil;
    self.OAuthTokenSecret = nil;
    
    [_queue release];
    
    [super dealloc];
}

@end
