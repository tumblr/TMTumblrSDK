//
//  TMAPIClient+User.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+User.h"

@implementation TMAPIClient (User)

- (void)userInfo:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:@"user/info" parameters:nil success:success error:error];
}

- (void)dashboard:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:@"user/dashboard" parameters:parameters success:success error:error];
}

- (void)likes:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:@"user/likes" parameters:parameters success:success error:error];
}

- (void)following:(NSDictionary *)parameters success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self get:@"user/following" parameters:parameters success:success error:error];
}

- (void)follow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self post:@"/user/follow" parameters:@{ TMAPIParameterURL : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
       success:success error:error];
}

- (void)unfollow:(NSString *)blogName success:(TMAPICallback)success error:(TMAPIErrorCallback)error {
    [self post:@"/user/unfollow" parameters:@{ TMAPIParameterURL : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
       success:success error:error];
}

- (void)like:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
       error:(TMAPIErrorCallback)error {
    [self post:@"/user/like" parameters:@{ TMAPIParameterPostID : postID, TMAPIParameterReblogKey : reblogKey }
       success:success error:error];
}

- (void)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey success:(TMAPICallback)success
         error:(TMAPIErrorCallback)error {
    [self post:@"/user/unlike" parameters:@{ TMAPIParameterPostID : postID, TMAPIParameterReblogKey : reblogKey }
       success:success error:error];
}

@end
