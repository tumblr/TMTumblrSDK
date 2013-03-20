//
//  TMAPIClientBlogTest.m
//  TMTumblrSDK
//
//  Created by John Crepezzi on 3/20/13.
//  Copyright (c) 2013 Tumblr. All rights reserved.
//

#import "TMAPIClientBlogTest.h"

@implementation TMAPIClientBlogTest

@synthesize client;

- (void) testBlogInfoRequest {
    JXHTTPOperation *op = [client blogInfoRequest:@"b.n"];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/info"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testBlogInfo {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient blogInfo:@"b.n" callback:check];
    }];
}

- (void) testFollowersRequest {
    JXHTTPOperation *op = [client followersRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/followers"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testFollowers {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient followers:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testAvatarRequest {
    JXHTTPOperation *op = [client avatarRequest:@"b.n" size:128];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/avatar/128"];
    [self assertQuery:op  is:@"api_key=consumer_key"];
}

- (void) testAvatar {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient avatar:@"b.n" size:64 callback:check];
    }];
}

- (void) testPostsRequest {
    JXHTTPOperation *op = [client postsRequest:@"b.n" type:nil parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testPosts {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient posts:@"b.n" type:nil parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testPosts_WithTypeRequest {
    JXHTTPOperation *op = [client postsRequest:@"b.n" type:@"audio" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/audio"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testQueueRequest {
    JXHTTPOperation *op = [client queueRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/queue"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testQueue {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient queue:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testDraftsRequest {
    JXHTTPOperation *op = [client draftsRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/draft"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testDrafts {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient drafts:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

- (void) testSubmissionsRequest {
    JXHTTPOperation *op = [client submissionsRequest:@"b.n" parameters:@{@"limit": @"1"}];
    [self assertMethod:op is:@"GET"];
    [self assertPath:op   is:@"/v2/blog/b.n/posts/submission"];
    [self assertQuery:op  is:@"api_key=consumer_key&limit=1"];
}

- (void) testSubmissions {
    [self assertCallback:^(TMAPIClient *mClient, TMAPICallback check) {
        [mClient submissions:@"b.n" parameters:@{@"limit": @"1"} callback:check];
    }];
}

@end
