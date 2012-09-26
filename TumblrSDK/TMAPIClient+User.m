//
//  TMAPIClient+User.m
//  TumblrSDK
//
//  Created by Bryan Irace on 8/28/12.
//  Copyright (c) 2012 Bryan Irace. All rights reserved.
//

#import "TMAPIClient+User.h"

@implementation TMAPIClient (User)

- (NSOperation *)userInfo:(TMAPICallback)callback {
    return [self get:@"user/info" parameters:nil callback:callback];
}

- (NSOperation *)dashboard:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:@"user/dashboard" parameters:parameters callback:callback];
}

- (NSOperation *)likes:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:@"user/likes" parameters:parameters callback:callback];
}

- (NSOperation *)following:(NSDictionary *)parameters callback:(TMAPICallback)callback {
    return [self get:@"user/following" parameters:parameters callback:callback];
}

- (NSOperation *)follow:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self post:@"/user/follow" parameters:@{ TMAPIParameterURL : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
             callback:callback];
}

- (NSOperation *)unfollow:(NSString *)blogName callback:(TMAPICallback)callback {
    return [self post:@"/user/unfollow" parameters:@{ TMAPIParameterURL : [NSString stringWithFormat:@"blog/%@.tumblr.com", blogName] }
             callback:callback];
}

- (NSOperation *)like:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    return [self post:@"/user/like" parameters:@{ TMAPIParameterPostID : postID, TMAPIParameterReblogKey : reblogKey }
             callback:callback];
}

- (NSOperation *)unlike:(NSString *)postID reblogKey:(NSString *)reblogKey callback:(TMAPICallback)callback {
    return [self post:@"/user/unlike" parameters:@{ TMAPIParameterPostID : postID, TMAPIParameterReblogKey : reblogKey }
             callback:callback];
}

@end
