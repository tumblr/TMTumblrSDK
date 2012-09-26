//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"

#import "TMOAuth.h"

NSString * const TMAPIParameterLimit = @"limit";
NSString * const TMAPIParameterOffset = @"offset";
NSString * const TMAPIParameterTag = @"tag";
NSString * const TMAPIParameterURL = @"url";
NSString * const TMAPIParameterPostID = @"id";
NSString * const TMAPIParameterReblogKey = @"reblog_key";
NSString * const TMAPIParameterType = @"type";

@interface TMAPIClient() {
    JXHTTPOperationQueue *_queue;
}

NSString *URLWithPath(NSString *path);

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

- (JXHTTPOperation *)get:(NSString *)path parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path) queryParameters:mutableParameters];
    [self sendRequest:request callback:callback];
    
    return request;
}

- (JXHTTPOperation *)post:(NSString *)path parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"api_key"] = self.OAuthConsumerKey;
    
    JXHTTPOperation *request = [JXHTTPOperation withURLString:URLWithPath(path)];
    request.requestBody = [JXHTTPFormEncodedBody withDictionary:mutableParameters];
    [self sendRequest:request callback:callback];
    
    return request;
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

- (void)sendRequest:(JXHTTPOperation *)request callback:(TMAPICallback)callback {
    __block JXHTTPOperation *blockRequest = request;
    
    request.completionBlock = ^ {
        NSDictionary *response = blockRequest.responseJSON;
        int statusCode = response[@"meta"] ? [response[@"meta"][@"status"] intValue] : 0;
        
        if (callback) {
            NSError *error = nil;
            
            if (statusCode != 200) {
                error = [NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil];
                NSLog(@"%@", blockRequest.requestURL);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(response[@"response"], error);
            });
        }
    };

    [self sendRequest:request];
}

#pragma mark - Helper function

NSString *URLWithPath(NSString *path) {
    return [@"http://api.tumblr.com/v2/" stringByAppendingString:path];
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
