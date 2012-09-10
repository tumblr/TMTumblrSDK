//
//  TMAPIClient+Posting.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+Posting.h"

@interface TMAPIClient (_Posting)

- (JXHTTPOperation *)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                        success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

@end

@implementation TMAPIClient (_Posting)

- (JXHTTPOperation *)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                        success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    NSMutableDictionary *mutableParameters = parameters ? [NSMutableDictionary dictionaryWithDictionary:parameters]
            : [NSMutableDictionary dictionary];
    mutableParameters[@"type"] = type;
    
    return [self post:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName] parameters:mutableParameters
              success:success error:error];
}

@end


@implementation TMAPIClient (Posting)

- (JXHTTPOperation *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                        error:(TMAPIErrorCallback)error {
    return [self post:@"post/edit" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                          error:(TMAPIErrorCallback)error {
    return [self post:@"post/reblog" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)deletePost:(NSString *)blogName id:(NSString *)postID success:(TMAPICallback)success
                          error:(TMAPIErrorCallback)error {
    return [self post:@"post/delete" parameters:@{ @"id" : postID } success:success error:error];
}

- (JXHTTPOperation *)text:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error {
    return [self createPost:blogName type:@"text" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)quote:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error {
    return [self createPost:blogName type:@"quote" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)link:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error {
    return [self createPost:blogName type:@"link" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)chat:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error {
    return [self createPost:blogName type:@"chat" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)audio:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error {
    // TODO
    return nil;
}

- (JXHTTPOperation *)video:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error {
    // TODO
    return nil;
}

- (JXHTTPOperation *)photo:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
                     error:(TMAPIErrorCallback)error {
    // TODO
    return nil;
}

@end
