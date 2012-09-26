//
//  TMAPIClient+Blog.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+Blog.h"

@implementation TMAPIClient (Blog)

- (NSOperation *)blogInfo:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/info", blogName] parameters:nil callback:callback];
}

- (NSOperation *)followers:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/followers", blogName] parameters:parameters
            callback:callback];
}

- (NSOperation *)avatar:(NSString *)blogName size:(int)size callback:(TMAPIDataCallback)callback {
    NSString *URLString = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/%d", blogName,
                           size];
    __block JXHTTPOperation *request = [JXHTTPOperation withURLString:URLString];
    
    request.completionBlock = ^ {
        if (callback) {
            if (request.responseStatusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(request.responseData, nil);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil, [NSError errorWithDomain:@"Request failed" code:request.responseStatusCode userInfo:nil]);
                });
            }
        }
    };
    
    [self sendRequest:request];
    
    return request;
}

- (NSOperation *)posts:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                   callback:(TMAPICallback)callback {
    NSString *path = [NSString stringWithFormat:@"blog/%@.tumblr.com/posts", blogName];
    if (type) path = [path stringByAppendingFormat:@"/%@", type];
    
    return [self get:path parameters:parameters callback:callback];
}

- (NSOperation *)queue:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/queue", blogName] parameters:parameters
             callback:callback];
}

- (NSOperation *)drafts:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/draft", blogName] parameters:parameters
             callback:callback];
}

- (NSOperation *)submissions:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:[NSString stringWithFormat:@"blog/%@.tumblr.com/posts/submission", blogName] parameters:parameters
             callback:callback];
}

@end
