//
//  TMAPIClient+Posting.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+Posting.h"

@implementation TMAPIClient (Posting)

- (NSOperation *)editPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self post:@"post/edit" parameters:parameters callback:callback];
}

- (NSOperation *)reblogPost:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self post:@"post/reblog" parameters:parameters callback:callback];
}

- (NSOperation *)deletePost:(NSString *)blogName id:(NSString *)postID callback:(TMAPICallback)callback {
    return [self post:@"post/delete" parameters:@{ TMAPIParameterPostID : postID } callback:callback];
}

- (NSOperation *)createPost:(NSString *)blogName type:(NSString *)type parameters:(NSDictionary *)parameters
                   callback:(TMAPICallback)callback {
    NSMutableDictionary *mutableParameters = parameters ? [NSMutableDictionary dictionaryWithDictionary:parameters]
    : [NSMutableDictionary dictionary];
    mutableParameters[TMAPIParameterType] = type;
    
    return [self post:[NSString stringWithFormat:@"blog/%@.tumblr.com/post", blogName] parameters:mutableParameters
             callback:callback];
}

- (NSOperation *)text:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self createPost:blogName type:@"text" parameters:parameters callback:callback];
}

- (NSOperation *)quote:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self createPost:blogName type:@"quote" parameters:parameters callback:callback];
}

- (NSOperation *)link:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self createPost:blogName type:@"link" parameters:parameters callback:callback];
}

- (NSOperation *)chat:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self createPost:blogName type:@"chat" parameters:parameters callback:callback];
}

- (NSOperation *)audio:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    // TODO
    return nil;
}

- (NSOperation *)video:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    // TODO
    return nil;
}

- (NSOperation *)photo:(NSString *)blogName parameters:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    // TODO
    return nil;
}

@end
