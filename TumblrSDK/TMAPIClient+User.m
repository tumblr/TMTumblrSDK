//
//  TMAPIClient+User.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+User.h"

@implementation TMAPIClient (User)

- (JXHTTPOperation *)userInfo:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    return [self get:@"user/info" parameters:nil success:success error:error];
}

- (JXHTTPOperation *)dashboard:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    return [self get:@"user/dashboard" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)likes:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    return [self get:@"user/likes" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)following:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    return [self get:@"user/following" parameters:parameters success:success error:error];
}

- (JXHTTPOperation *)follow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    return [self post:@"/user/follow" parameters:@{ @"url" : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
              success:success error:error];
}

- (JXHTTPOperation *)unfollow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    return [self post:@"/user/unfollow" parameters:@{ @"url" : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
              success:success error:error];
}

- (JXHTTPOperation *)like:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
                    error:(TMAPIErrorCallback)error {
    return [self post:@"/user/like" parameters:@{ @"id" : postID, @"reblog_key" : reblogKey } success:success
                error:error];
}

- (JXHTTPOperation *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
                      error:(TMAPIErrorCallback)error {
    return [self post:@"/user/unlike" parameters:@{ @"id" : postID, @"reblog_key" : reblogKey } success:success
                error:error];
}

@end
