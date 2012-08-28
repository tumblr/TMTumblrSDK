//
//  TMAPIClient.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/26/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient.h"
#import "TMOAuth.h"

// Request methods
static NSString * const TMAPIRequestMethodGET = @"GET";
static NSString * const TMAPIRequestMethodPOST = @"POST";

// Parameter keys
static NSString * const TMAPIParameterAPIKey = @"api_key";
static NSString * const TMAPIParameterLimit = @"limit";
static NSString * const TMAPIParameterOffset = @"offset";


@interface TMAPIClient()

- (JXHTTPOperation *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
                               success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error;

- (void)sendRequest:(JXHTTPOperation *)request;

@end


@implementation TMAPIClient

#pragma mark - Blog methods

- (void)blogInfo:(NSString *)blogName success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/info", blogName] parameters:@{
                                 TMAPIParameterAPIKey : self.APIKey }
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)followers:(NSString *)blogName limit:(int)limit offset:(int)offset
          success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/followers", blogName] parameters:@{
                                  TMAPIParameterLimit : intToString(limit),
                                 TMAPIParameterOffset : intToString(offset) }
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)avatar:(NSString *)blogName size:(int)size
       success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/avatar/%d", blogName, size] parameters:nil
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
      success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    NSString *path = [NSString stringWithFormat:@"blog/%@.tumblr.com/posts", blogName];
    if (type) path = [path stringByAppendingFormat:@"/%@", type];
    
    if (parameters) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        ((NSMutableDictionary *)parameters)[TMAPIParameterAPIKey] = self.APIKey;
    } else {
        parameters = @{ TMAPIParameterAPIKey : self.APIKey };
    }
    
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:path parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters
      success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/posts/queue", blogName] parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters
      success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/posts/draft", blogName] parameters:parameters
                                               success:success error:error];
    
    [self sendRequest:request];
}

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters
            success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    JXHTTPOperation *request = [self requestWithMethod:TMAPIRequestMethodGET path:
                                [NSString stringWithFormat:@"blog/%@.tumblr.com/posts/submission", blogName] parameters:parameters
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

static inline NSString *intToString(int integer) {
    return [NSString stringWithFormat:@"%d", integer];
}

- (void)sendRequest:(JXHTTPOperation *)request {
    NSString *authorizationHeaderValue =
    [TMOAuth authorizationHeaderForRequest:request nonce:request.uniqueIDString
                               consumerKey:self.OAuthConsumerKey consumerSecret:self.OAuthConsumerSecret
                                     token:self.OAuthToken tokenSecret:self.OAuthTokenSecret];
    
    [request setValue:authorizationHeaderValue forRequestHeader:@"Authorization"];
    
    [[JXHTTPOperationQueue sharedQueue] addOperation:request];
}

- (JXHTTPOperation *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
                             success:(TMAPISuccessCallback)success error:(TMAPIErrorCallback)error {
    __block JXHTTPOperation *request;
    NSString *URLString = [NSString stringWithFormat:@"http://api.tumblr.com/v2/%@", path];
    
    if ([method isEqualToString:TMAPIRequestMethodPOST]) {
        request = [JXHTTPOperation withURLString:URLString];
        request.requestBody = [JXHTTPJSONBody withJSONObject:parameters];
    } else {
        request = [JXHTTPOperation withURLString:URLString queryParameters:parameters];
    }
    
    request.completionBlock = ^ {
        NSDictionary *response = request.responseJSON;
        int statusCode = response[@"meta"] ? [response[@"meta"][@"status"] intValue] : 0;
        
        if (statusCode == 200) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(response[@"response"]);
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
