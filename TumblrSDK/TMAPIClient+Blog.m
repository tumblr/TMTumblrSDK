//
//  TMAPIClient+Blog.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+Blog.h"

@implementation TMAPIClient (Blog)

- (void)blogInfo:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/info", blogName]
   parameters:@{ TMAPIParameterAPIKey : self.OAuthConsumerKey } success:success error:error];
}

- (void)followers:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
            error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/followers", blogName] parameters:parameters success:success
        error:error];
}

- (void)avatar:(NSString *)blogName size:(int)size success:(TMAPIDataCallback)success error:(TMAPIErrorCallback)error {
    NSString *URLString = [TMAPIBaseURL stringByAppendingString:[NSString stringWithFormat:@"blog/%@.tumblr.com/avatar/%d",
                                                                 blogName, size]];
    
    __block JXHTTPOperation *request = [JXHTTPOperation withURLString:URLString];
    
    request.completionBlock = ^ {
        if (request.responseStatusCode == 200) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(request.responseData);
                });
            }
        } else {
            error([NSError errorWithDomain:@"Request failed" code:request.responseStatusCode userInfo:nil]);
        }
    };
    
    [self sendRequest:request];
}

- (void)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
      success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    NSString *path = [NSString stringWithFormat:@"blog/%@.tumblr.com/posts", blogName];
    if (type) path = [path stringByAppendingFormat:@"/%@", type];
    
    NSMutableDictionary *mutableParameters = parameters ? [NSMutableDictionary dictionaryWithDictionary:parameters]
            : [NSMutableDictionary dictionary];
    mutableParameters[TMAPIParameterAPIKey] = self.OAuthConsumerKey;
    
    [self get:path parameters:mutableParameters success:success error:error];
}

- (void)queue:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/queue", blogName] parameters:parameters
      success:success error:error];
}

- (void)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/draft", blogName] parameters:parameters
      success:success error:error];
}

- (void)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
              error:(TMAPIErrorCallback)error {
    [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/submission", blogName] parameters:parameters
      success:success error:error];
}

@end
