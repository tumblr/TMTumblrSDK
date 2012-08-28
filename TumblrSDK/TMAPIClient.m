//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"
#import "TMOAuth.h"

static NSString * const TMAPIBaseURL = @"http://api.tumblr.com/v2/";

// Request methods
static NSString * const TMAPIRequestMethodGET = @"GET";
static NSString * const TMAPIRequestMethodPOST = @"POST";

// Parameter keys
static NSString * const TMAPIParameterAPIKey = @"api_key";
static NSString * const TMAPIParameterLimit = @"limit";
static NSString * const TMAPIParameterOffset = @"offset";
static NSString * const TMAPIParameterTag = @"tag";

// Response keys
static NSString * const TMAPIResponseKeyMeta = @"meta";
static NSString * const TMAPIResponseKeyStatus = @"status";
static NSString * const TMAPIResponseKeyResponse = @"response";

@interface TMAPIClient()

- (JXHTTPOperation *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
                               success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

- (void)sendRequest:(JXHTTPOperation *)request;

@end


@implementation TMAPIClient

#pragma mark - Blog methods

- (void)blogInfo:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/info", blogName] parameters:@{
                                 TMAPIParameterAPIKey : self.APIKey }
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters
          success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/followers", blogName] parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)avatar:(NSString *)blogName size:(int)size
       success:(TMAPIDataCallback)success error:(TMAPIErrorCallback)error {
    NSString *URLString = [TMAPIBaseURL stringByAppendingString:
                           [NSString stringWithFormat:@"blog/%@.tumblr.com/avatar/%d", blogName, size]];
    
    __block JXHTTPOperation *request = [JXHTTPOperation withURLString:URLString];
    
    request.completionBlock = ^ {
        int statusCode = request.responseStatusCode;
        
        if (statusCode == 200) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(request.responseData);
                });
            }
        } else {
            error([NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil]);
        }
    };

    [self sendRequest:request];
}

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
      success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    NSString *path = [NSString stringWithFormat:@"blog/%@.tumblr.com/posts", blogName];
    if (type) path = [path stringByAppendingFormat:@"/%@", type];
    
    parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    ((NSMutableDictionary *)parameters)[TMAPIParameterAPIKey] = self.APIKey;
    
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:path parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters
      success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/posts/queue", blogName] parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters
      success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/posts/draft", blogName] parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters
            success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/posts/submission", blogName] parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

#pragma mark - User methods

- (void)userInfo:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:@"user/info" parameters:nil
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)dashboard:(NSDictionary *)parameters
          success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:@"user/dashboard" parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)likes:(NSDictionary *)parameters
      success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:@"user/likes" parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)following:(NSDictionary *)parameters
          success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:@"user/following" parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

#pragma mark - Tagged methods

- (void)tagged:(NSString *)tag parameters:(NSDictionary *)parameters
       success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    ((NSMutableDictionary *)parameters)[TMAPIParameterTag] = tag;
    ((NSMutableDictionary *)parameters)[TMAPIParameterAPIKey] = self.APIKey;
    
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:@"tagged" parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

#pragma mark - Misc.

+ (id)sharedInstance {
    static TMAPIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[TMAPIClient alloc] init]; });
    return instance;
}

#pragma mark - Convenience

- (JXHTTPOperation *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
                             success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    __block JXHTTPOperation *request;
    NSString *URLString = [TMAPIBaseURL stringByAppendingString:path];
    
    if ([method isEqualToString:TMAPIRequestMethodPOST]) {
        request = [JXHTTPOperation withURLString:URLString];
        request.requestBody = [JXHTTPJSONBody withJSONObject:parameters];
        
    } else {
        request = [JXHTTPOperation withURLString:URLString queryParameters:parameters];
    }
    
    request.completionBlock = ^ {
        // TODO: Check request.requestStatusCode
        
        NSDictionary *response = request.responseJSON;
        int statusCode = response[TMAPIResponseKeyMeta] ? [response[TMAPIResponseKeyMeta][TMAPIResponseKeyStatus] intValue] : 0;
        
        if (statusCode == 200) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(response[TMAPIResponseKeyResponse]);
                });
            }
        } else {
            if (error) {
                // TODO: Pass blog or user errors from server in user info dictionary
                dispatch_async(dispatch_get_main_queue(), ^{
                    error([NSError errorWithDomain:@"Request failed" code:statusCode userInfo:nil]);
                });
            }
        }
    };
    
    return request;
}

- (void)sendRequest:(JXHTTPOperation *)request {
    NSString *authorizationHeaderValue =
    [TMOAuth authorizationHeaderForRequest:request nonce:request.uniqueIDString
                               consumerKey:self.OAuthConsumerKey consumerSecret:self.OAuthConsumerSecret
                                     token:self.OAuthToken tokenSecret:self.OAuthTokenSecret];
    
    [request setValue:authorizationHeaderValue forRequestHeader:@"Authorization"];
    
    [[JXHTTPOperationQueue sharedQueue] addOperation:request];
}

#pragma mark - Memory management

- (void)dealloc {
    self.APIKey = nil;
    self.OAuthConsumerKey = nil;
    self.OAuthConsumerSecret = nil;
    self.OAuthToken = nil;
    self.OAuthTokenSecret = nil;
    
    [super dealloc];
}

@end
