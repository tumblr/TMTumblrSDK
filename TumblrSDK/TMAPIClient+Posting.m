//
//  TMAPIClient+Posting.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+Posting.h"

@interface TMAPIClient (_Posting)

- (void)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
success:(TMAPICallback)success error:(TMAPIErrorCallback)error;

@end

@implementation TMAPIClient (_Posting)

- (void)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
           success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    NSMutableDictionary *mutableParameters = parameters ? [NSMutableDictionary dictionaryWithDictionary:parameters]
            : [NSMutableDictionary dictionary];
    mutableParameters[TMAPIParameterType] = type;
    
    [self post:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName] parameters:mutableParameters
       success:success error:error];
}

@end


@implementation TMAPIClient (Posting)

- (void)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
           error:(TMAPIErrorCallback)error {
    [self post:@"post/edit" parameters:parameters success:success error:error];
}

- (void)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
             error:(TMAPIErrorCallback)error {
    [self post:@"post/reblog" parameters:parameters success:success error:error];
}

- (void)deletePost:(NSString *)blogName id:(NSString *)postID success:(TMAPICallback)success
             error:(TMAPIErrorCallback)error {
    [self post:@"post/delete" parameters:@{ TMAPIParameterPostID : postID } success:success error:error];
}

- (void)text:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    [self createPost:blogName type:@"text" parameters:parameters success:success error:error];
}

- (void)quote:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    [self createPost:blogName type:@"quote" parameters:parameters success:success error:error];
}

- (void)link:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    [self createPost:blogName type:@"link" parameters:parameters success:success error:error];
}

- (void)chat:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    [self createPost:blogName type:@"chat" parameters:parameters success:success error:error];
}

- (void)audio:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    // TODO
}

- (void)video:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    // TODO
}

- (void)photo:(NSString *)blogName parameters:(NSDictionary *)parameters success:(TMAPICallback)success
        error:(TMAPIErrorCallback)error {
    // TODO
}

@end
